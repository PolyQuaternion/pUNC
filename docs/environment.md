# Environment

The **Environment** module provides functions to inspect and access the global execution tables, the game runtime environment, the Lua registry, garbage-collected objects, and active scripts in the Datamodel.

## `getgenv`

Returns the persistent global environment table shared across all executed scripts within the executor. Variables stored in `getgenv()` persist across distinct script executions.

```lua
function getgenv(): { [any]: any }
```

### Returns

- `{ [any]: any }` - The shared global environment table.

### Example

```lua
getgenv().MyGlobalConfig = { Enabled = true, Speed = 50 }
print(getgenv().MyGlobalConfig.Speed)
```

## `getdefaultenv`

Returns the game engine's original runtime global environment table (`_G`).

```lua
function getdefaultenv(): { [any]: any }
```

### Returns

- `{ [any]: any }` - The game runtime's global environment table.

### Example

```lua
local defaultenv = getdefaultenv()
print(defaultenv.print, defaultenv.math)
```

## `getreg`

Returns the Lua VM Registry table, containing internal references, metatables, and cached objects.

```lua
function getreg(): { [any]: any }
```

### Returns

- `{ [any]: any }` - The Lua VM registry table.

### Example

```lua
local registry = getreg()
for key, value in pairs(registry) do
    print(key, value)
end
```

## `getgc`

Returns an array containing all active objects tracked by the Luau garbage collector. By default, returns functions and userdata; pass `true` to include tables as well.

```lua
function getgc(includeTables: boolean?): { any }
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `includeTables` *(optional)* | When set to `true`, table objects in memory are collected in addition to functions and userdata. |

### Returns

- `{ any }` - Array of all active GC objects found in the VM.

### Example

```lua
local objects = getgc(true)
print("Total GC items tracked: " .. #objects)
```

## `getloadedmodules`

Returns an array of all `ModuleScript` instances that have been loaded and executed by the game engine.

```lua
function getloadedmodules(): { ModuleScript }
```

### Returns

- `{ ModuleScript }` - Array of loaded `ModuleScript` instances.

### Example

```lua
for _, mod in ipairs(getloadedmodules()) do
    print("Loaded module: " .. mod.Name)
end
```

## `getscripts`

Returns an array of all `Script` instances currently active in the Datamodel.

```lua
function getscripts(): { Script }
```

### Returns

- `{ Script }` - Array of all active `Script` instances.

### Example

```lua
for _, script in ipairs(getscripts()) do
    print("Found script: " .. script.Name .. " (" .. script:GetPath() .. ")")
end
```
