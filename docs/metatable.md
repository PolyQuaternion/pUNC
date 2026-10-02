# Metatable

The **Metatable** module provides low-level metatable inspection, manipulation, table immutability controls, and namecall interception.

## `getrawmetatable`

Retrieves the metatable of a table or userdata, completely bypassing any `__metatable` lock.

```lua
function getrawmetatable(object: { any } | userdata): { [any]: any } | nil
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `object` | The table or userdata instance whose underlying metatable is to be retrieved. |

### Returns

- `{ [any]: any } | nil` - The raw metatable, or `nil` if the object has no metatable.

### Example

```lua
local tbl = setmetatable({}, { __metatable = "Locked Metatable", customProp = 100 })
local rawMt = getrawmetatable(tbl)
print(rawMt.customProp) -- 100
```

## `setrawmetatable`

Replaces the metatable of a table or userdata instance directly, bypassing read-only protections and `__metatable` locks.

```lua
function setrawmetatable(object: { any } | userdata, metatable: { [any]: any }): boolean
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `object` | The target table or userdata whose metatable should be replaced. |
| `metatable` | The new metatable table to attach. |

### Returns

- `boolean` - `true` on success; otherwise `false`.

### Example

```lua
local tbl = {}
table.freeze(tbl)
setrawmetatable(tbl, {
    __index = function(t, k)
        return "Intercepted: " .. tostring(k)
    end
})
print(tbl.randomProperty) -- "Intercepted: randomProperty"
```

## `setreadonly`

Sets or clears the read-only / frozen flag on a Lua table.

```lua
function setreadonly(target: { any }, readonly: boolean): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `target` | The table to modify. |
| `readonly` | `true` to freeze the table and prevent modifications; `false` to make it writable. |

### Example

```lua
local tbl = { x = 10 }
table.freeze(tbl)
setreadonly(tbl, false)
tbl.x = 20 -- Allowed
```

## `isreadonly`

Checks whether a Lua table is currently marked as read-only.

```lua
function isreadonly(target: { any }): boolean
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `target` | The table to check. |

### Returns

- `boolean` - `true` if the table is read-only; otherwise `false`.

### Example

```lua
local tbl = {}
print("Is read-only:", isreadonly(tbl)) -- false
setreadonly(tbl, true)
print("Is read-only:", isreadonly(tbl)) -- true
```

## `getnamecallmethod`

Returns the method name string when called inside a `__namecall` metamethod invocation.

```lua
function getnamecallmethod(): string | nil
```

### Returns

- `string | nil` - The string name of the called method, or `nil` if not currently inside a `__namecall` invocation.

### Example

```lua
local origNamecall
origNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    print("Namecall method invoked: " .. tostring(method))
    return origNamecall(self, ...)
end))
```

## `setnamecallmethod`

Overwrites or sets the method name atom for the current `__namecall` invocation.

```lua
function setnamecallmethod(method: string): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `method` | The method name string to set. |

### Example

```lua
setnamecallmethod("CustomMethod")
```
