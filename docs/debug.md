# Debug

The **Debug** module provides introspection and manipulation tools for functions, constants, upvalues, child prototypes, and execution stack frames under the `debug` library table.

## `debug.getinfo`

Retrieves detailed metadata regarding a Lua/C function or a stack frame level.

```lua
function debug.getinfo(target: ((...any) -> ...any) | number, what: string?): DebugInfo | nil
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `target` | Either a function closure or an integer stack level (`1` represents the immediate caller). |
| `what` *(optional)* | Format string specifying which fields to populate (`"snalu"`). |

### Returns

- `DebugInfo | nil` - A table with the following fields, or `nil` on failure:
  - `source: string` - The source chunk identifier.
  - `short_src: string` - A truncated/clean version of the source path.
  - `what: string` - `"Lua"`, `"C"`, or `"main"`.
  - `currentline: number` - Current executing line number.
  - `linedefined: number` - Line where the function was defined.
  - `numparams: number` - Number of fixed parameters accepted by the function.
  - `is_vararg: boolean` - Whether the function accepts variable arguments (`...`).
  - `nups: number` - Number of captured upvalues.
  - `name: string | nil` - The name of the function if available.
  - `func: function | nil` - Reference to the target function (when queried by function).

### Example

```lua
local info = debug.getinfo(print)
print("Print type:", info.what) -- "C"

local function myFunc(a, b, ...) end
local fnInfo = debug.getinfo(myFunc)
print("Params:", fnInfo.numparams, "Is vararg:", fnInfo.is_vararg) -- 2, true
```

## `debug.getupvalues`

Returns a table containing all upvalues captured by a function, indexed both by their 1-based numerical index and by their variable name.

```lua
function debug.getupvalues(fn: (...any) -> ...any): { [any]: any }
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The function whose upvalues to retrieve. |

### Returns

- `{ [any]: any }` - Table containing all captured upvalues.

### Example

```lua
local secret = "MySecretUpval"
local function getter() return secret end

local uvs = debug.getupvalues(getter)
print(uvs[1], uvs.secret) -- "MySecretUpval", "MySecretUpval"
```

## `debug.getupvalue`

Retrieves a single upvalue from a function at a 1-based index.

```lua
function debug.getupvalue(fn: (...any) -> ...any, index: number): any
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The function whose upvalue to retrieve. |
| `index` | The 1-based index of the upvalue. |

### Returns

- `any` - The value stored at the upvalue slot, or `nil` if out of bounds.

### Example

```lua
local count = 42
local function getCount() return count end
print(debug.getupvalue(getCount, 1)) -- 42
```

## `debug.setupvalue`

Mutates the value of a function's upvalue at a 1-based index in-place.

```lua
function debug.setupvalue(fn: (...any) -> ...any, index: number, value: any): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The target function whose upvalue to modify. |
| `index` | The 1-based index of the upvalue to overwrite. |
| `value` | The new value to set. |

### Example

```lua
local admin = false
local function checkAdmin() return admin end

debug.setupvalue(checkAdmin, 1, true)
print(checkAdmin()) -- true
```

## `debug.getconstants`

Returns an array containing all constants stored in a Luau function's constant pool (`Proto.k`).

```lua
function debug.getconstants(fn: (...any) -> ...any): { [number]: any }
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The Luau bytecode function to inspect. |

### Returns

- `{ [number]: any }` - Array of literal numbers, strings, and booleans in the function's constant pool.

### Example

```lua
local function greet()
    local msg = "Welcome to pUNC!"
    return msg
end

local consts = debug.getconstants(greet)
for i, c in ipairs(consts) do
    print(i, c)
end
```

## `debug.getconstant`

Retrieves a single constant from a function's constant pool at a 1-based index.

```lua
function debug.getconstant(fn: (...any) -> ...any, index: number): any
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The target function. |
| `index` | The 1-based index of the constant to retrieve. |

### Returns

- `any` - The constant value, or `nil` if out of range.

### Example

```lua
local function f() return "TargetValue" end
print(debug.getconstant(f, 1))
```

## `debug.setconstant`

Modifies a constant slot in a Luau function's constant pool, altering its behavior directly in memory.

```lua
function debug.setconstant(fn: (...any) -> ...any, index: number, value: any): string?
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The target function to modify. |
| `index` | The 1-based index of the constant slot to overwrite. |
| `value` | The replacement constant value. |

### Returns

- `string | nil` - Returns an error message string if the index is out of bounds, target is a C closure, or a type mismatch occurs; returns `nil` on success.

### Example

```lua
local function getFlag() return "DISABLED" end
local err = debug.setconstant(getFlag, 1, "ENABLED")
if err then
    warn("Failed to set constant: " .. err)
end
print(getFlag()) -- "ENABLED"
```

::: warning Type Restrictions
To maintain VM type safety and prevent bytecode type confusion, `debug.setconstant` strictly requires that the replacement value matches the primitive type of the original constant (e.g., string for string, number for number). If the types differ, an error string is returned and the modification is aborted.
:::

## `debug.getprotos`

Returns an array of callable function closures representing the nested child prototypes defined within a function.

```lua
function debug.getprotos(fn: (...any) -> ...any): { [number]: (...any) -> ...any }
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The parent function containing nested function declarations. |

### Returns

- `{ [number]: (...any) -> ...any }` - Array of child prototype function closures.

### Example

```lua
local function outer()
    local function inner1() return 10 end
    local function inner2() return 20 end
    return inner1() + inner2()
end

local protos = debug.getprotos(outer)
print("Child functions count: " .. #protos)
```

## `debug.getproto`

Retrieves a single child prototype function closure from a parent function at a 1-based index.

```lua
function debug.getproto(fn: (...any) -> ...any, index: number): ((...any) -> ...any) | nil
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `fn` | The parent function. |
| `index` | The 1-based index of the child prototype. |

### Returns

- `((...any) -> ...any) | nil` - A callable function for the child prototype, or `nil` if out of bounds.

### Example

```lua
local function parent()
    local function child() return "child output" end
    return child()
end

local childFn = debug.getproto(parent, 1)
print(childFn()) -- "child output"
```

## `debug.setproto`

Replaces a child prototype in a parent function so that future executions of the parent will instantiate closures using the replacement function prototype.

```lua
function debug.setproto(target: (...any) -> ...any, index: number, replacement: (...any) -> ...any): string?
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `target` | The parent function containing the child prototype. |
| `index` | The 1-based index of the child prototype to replace. |
| `replacement` | The replacement function whose prototype should be installed. |

### Returns

- `string | nil` - Returns an error message string if any stability/structural preconditions fail (upvalues, parameter count, stack size, or invalid index); returns `nil` on success.

### Example

```lua
local function parent()
    local function auth() return false end
    return auth()
end

local function bypass() return true end
local err = debug.setproto(parent, 1, bypass)
if err then
    warn("Failed to set proto: " .. err)
end
print(parent()) -- true
```

::: warning Prototype Restrictions & Safety
Replacing a function prototype requires that:
1. The replacement function has the **exact same upvalue count** as the original child prototype.
2. The replacement function has the **exact same parameter count**.
3. The replacement function's **maximum stack size (`maxstacksize`)** does not exceed the target's stack frame allocation.

If these constraints are not met, `debug.setproto` will return a descriptive error string and safely reject the operation to avoid VM stack corruption.
:::

## `debug.getstack`

Inspects local variables and evaluation stack slots in a given call stack frame level.

```lua
function debug.getstack(level: number, index: number?): any | { [number]: any }
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `level` | The stack frame level (`1` is the current calling function). |
| `index` *(optional)* | If provided, returns the specific slot at that 1-based index. If omitted, returns an array of all active local slots. |

### Returns

- `any | { [number]: any }` - The slot value, or an array table of all stack slots at the frame.

### Example

```lua
local myVar = "test"
local stackLocals = debug.getstack(1)
print(stackLocals[1]) -- "test"
```

## `debug.setstack`

Overwrites a local variable / stack slot at a given stack frame level and slot index.

```lua
function debug.setstack(level: number, index: number, value: any): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `level` | The stack frame level. |
| `index` | The 1-based slot index to overwrite. |
| `value` | The new value to store in the local slot. |

### Example

```lua
local score = 100
debug.setstack(1, 1, 9999)
print(score) -- 9999
```
