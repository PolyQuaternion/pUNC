# Scripts

The **Scripts** module provides dynamic string compilation, caller security checks, script bytecode inspection, script hashing, and thread execution reflection.

## `loadstring`

Compiles raw Luau source code into an executable function closure without running it immediately.

```lua
function loadstring(source: string, chunkname: string?): (((...any) -> ...any)?, string?)
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `source` | The Luau source code string to compile. |
| `chunkname` *(optional)* | Debug chunk name identifier (defaults to `"=loadstring"`). |

### Returns

- `((...any) -> ...any)?` - Compiled function chunk, or `nil` on compilation/syntax error.
- `error: string?` - Syntax error message string if compilation failed.

### Example

```lua
local code = [[
    local name = ...
    print("Hello, " .. tostring(name) .. "!")
]]

local fn, err = loadstring(code, "=GreetingChunk")
if fn then
    fn("user")
else
    warn("Compile error:", err)
end
```

## `checkcaller`

Returns whether the currently running thread originated from the executor rather than a game script.

```lua
function checkcaller(): boolean
```

### Returns

- `boolean` - `true` if called from an executor script; `false` if called by a game script.

### Example

```lua
if checkcaller() then
    print("Executing with elevated executor privileges.")
end
```

## `getsenv`

Returns the global environment table (`_G`) of a running `Script` or loaded `ModuleScript`.

```lua
function getsenv(script: Script): { [any]: any } | nil
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `script` | The target `Script` or `ModuleScript` instance. |

### Returns

- `{ [any]: any } | nil` - The script's globals environment table, or `nil` if not running.

### Example

```lua
local targetScript = getscripts()[1]
if targetScript then
    local env = getsenv(targetScript)
    print("Script global variables:", env)
end
```

## `getscriptbytecode`

Returns the compiled Luau bytecode of a `Script` as a binary string. If the script was not compiled yet, it is compiled on demand.

```lua
function getscriptbytecode(script: Script): string | nil
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `script` | The target `Script` instance. |

### Returns

- `string | nil` - A binary string containing the compiled bytecode bytes, or `nil` on failure.

### Example

```lua
local targetScript = getscripts()[1]
if targetScript then
    local bc = getscriptbytecode(targetScript)
    print("Bytecode size in bytes:", #bc)
end
```

## `getscripthash`

Computes and returns a SHA-384 hash string representing the script's compiled bytecode.

```lua
function getscripthash(script: Script): string
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `script` | The target `Script` instance. |

### Returns

- `string` - Lowercase 96-character hexadecimal SHA-384 hash string.

### Example

```lua
local targetScript = getscripts()[1]
if targetScript then
    local hash = getscripthash(targetScript)
    print("Script bytecode hash:", hash)
end
```

## `getscriptclosure`

Instantiates and returns a callable function chunk from the target script's compiled bytecode without executing the script's original instance.

```lua
function getscriptclosure(script: Script): ((...any) -> ...any) | nil
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `script` | The target `Script` instance. |

### Returns

- `((...any) -> ...any) | nil` - A new callable closure of the script's main chunk, or `nil` on failure.

### Example

```lua
local targetScript = getscripts()[1]
if targetScript then
    local closure = getscriptclosure(targetScript)
    if closure then
        print("Obtained callable script closure.")
    end
end
```

## `getcallingscript`

Walks the Lua call stack and returns the `Script` instance that invoked the calling function.

```lua
function getcallingscript(): Script | nil
```

### Returns

- `Script | nil` - The `Script` instance found on the call stack, or `nil` if invoked from top-level executor threads.

### Example

```lua
local caller = getcallingscript()
if caller then
    print("Called by script:", caller.Name)
end
```

## `getrunningscripts`

Returns an array of all active `Script` instances that are currently executing in the Datamodel (excluding ModuleScripts).

```lua
function getrunningscripts(): { [number]: Script }
```

### Returns

- `{ [number]: Script }` - Array of all currently running `Script` instances.

### Example

```lua
local running = getrunningscripts()
print("Total running scripts:", #running)
for _, s in ipairs(running) do
    print(" - " .. s.Name)
end
```

## `decompile`

Decompiles Luau bytecode from a `Script` instance, `buffer`, or bytecode `string` back into readable Luau source code using the offline Luau Decompiler engine.

```lua
function decompile(target: Script | buffer | string, mode: string?): string
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `target` | The target `Script` instance, bytecode `buffer`, or bytecode string to decompile. |
| `mode` *(optional)* | Optional mode: `"disasm"` / `"disassemble"` for disassembly, `"json"` for structured metadata. |

### Returns

- `string` - Decompiled Luau source code or disassembly output.

### Example

```lua
local targetScript = getscripts()[1]
if targetScript then
    local source = decompile(targetScript)
    print(source)
end
```
