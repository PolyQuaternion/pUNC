# Closures

The **Closures** module provides functions to inspect, wrap, clone, and detour / hook Lua and C closures safely.

## `newcclosure`

Wraps a standard Lua function (`LClosure`) into a native C closure (`CClosure`). Calling the resulting closure creates an independent call frame that masks the Lua stack from error tracebacks and call stack inspections.

```lua
function newcclosure(fn: (...any) -> ...any): (...any) -> ...any
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The Lua function to wrap into a C closure. If a C closure is provided, it is cloned. |

### Returns

- `(...any) -> ...any` - A new C closure wrapping the input function.

### Example

```lua
local cFunction = newcclosure(function(a, b)
    return a + b
end)
print(iscclosure(cFunction)) -- true
```

## `newlclosure`

Wraps a C closure or existing function into a pure Lua closure.

```lua
function newlclosure(fn: (...any) -> ...any): (...any) -> ...any
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The function to wrap as a Lua bytecode closure. |

### Returns

- `(...any) -> ...any` - A new Lua closure.

### Example

```lua
local lPrint = newlclosure(print)
print(iscclosure(lPrint)) -- false
lPrint("Called through LClosure wrapper")
```

## `iscclosure`

Returns whether a given function is a C closure.

```lua
function iscclosure(fn: (...any) -> ...any): boolean
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The function to inspect. |

### Returns

- `boolean` - `true` if `fn` is a C closure; `false` otherwise.

### Example

```lua
print(iscclosure(print)) -- true
print(iscclosure(function() end)) -- false
```

## `isexecutorclosure`

Returns whether the given function was created, loaded, or registered by the executor environment.

```lua
function isexecutorclosure(fn: (...any) -> ...any): boolean
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The function to check. |

### Returns

- `boolean` - `true` if `fn` belongs to the executor; `false` if it is an original game engine function.

### Example

```lua
print(isexecutorclosure(readfile)) -- true
print(isexecutorclosure(print)) -- false
```

## `clonefunction`

Creates a distinct clone of the target function with identical behavior and upvalues, but a unique function pointer/reference.

```lua
function clonefunction(fn: (...any) -> ...any): (...any) -> ...any
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The function to clone. |

### Returns

- `(...any) -> ...any` - A new function clone.

### Example

```lua
local original = function(x) return x * 2 end
local copy = clonefunction(original)
print(copy(5)) -- 10
print(copy == original) -- false
```

## `hookfunction`

Detours a target function so that future invocations redirect to `hook`. Returns a backup clone of the original function so the original implementation can still be called.

```lua
function hookfunction(target: (...any) -> ...any, hook: (...any) -> ...any): (...any) -> ...any
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `target` | The function to detour/hook. |
| `hook` | The new replacement hook function. |

### Returns

- `(...any) -> ...any` - A clone of the original function before it was hooked.

### Example

```lua
local originalPrint
originalPrint = hookfunction(print, newcclosure(function(...)
    originalPrint("[Intercepted]", ...)
end))

print("Hello World!") -- Prints: [Intercepted] Hello World!
```

## `restorefunction`

Restores a previously hooked function back to its original unmodified implementation.

```lua
function restorefunction(target: (...any) -> ...any): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `target` | The hooked function to restore. |

### Example

```lua
restorefunction(print)
print("Normal print restored!")
```

## `hookmetamethod`

Hooks a specific metamethod on an object's metatable, bypassing write protection and returning the original metamethod function.

```lua
function hookmetamethod(object: { any } | userdata, method: string, hook: (...any) -> ...any): ((...any) -> ...any) | nil
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `object` | The table or userdata whose metatable metamethod should be hooked. |
| `method` | The name of the metamethod (e.g. `"__index"`, `"__namecall"`, `"__newindex"`). |
| `hook` | The replacement hook function. |

### Returns

- `((...any) -> ...any) | nil` - The original metamethod function, or `nil` if the object or metamethod was not found.

### Example

```lua
local origIndex
origIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if key == "SecretValue" then
        return 1337
    end
    return origIndex(self, key)
end))

print(game.SecretValue) -- 1337
```
