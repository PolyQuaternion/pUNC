# Instances

The **Instances** module provides Datamodel instance manipulation, instance querying and enumeration, userdata proxy cloning, weak userdata cache inspection/invalidation, dedicated executor UI containers, and physical interaction event triggers.

## `getinstances`

Returns an array of all `Instance` objects currently loaded in the Datamodel hierarchy and active in memory.

```lua
function getinstances(): { Instance }
```

### Returns

- `{ Instance }` - An array of all active `Instance` objects.

### Example

```lua
local instances = getinstances()
print(string.format("Found %d instances in memory", #instances))
```

## `getnilinstances`

Returns an array of all `Instance` objects currently in memory whose `Parent` property is `nil` (such as unparented instances or instances removed from the active Datamodel tree).

```lua
function getnilinstances(): { Instance }
```

### Returns

- `{ Instance }` - An array of all unparented `Instance` objects.

### Example

```lua
local nilInstances = getnilinstances()
print(string.format("Found %d unparented instances", #nilInstances))
```

## `cloneref`

Creates a new, distinct userdata proxy reference to the same underlying game instance. The cloned reference has an independent Lua table/userdata identity (so `rawget`, `rawset`, or table comparisons treat it as distinct), while continuing to point to the exact same managed object.

```lua
function cloneref(instance: Instance): Instance | nil
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `instance` | The Datamodel `Instance` to clone a reference for. |

### Returns

- `Instance | nil` - A distinct userdata proxy to the instance.

### Example

```lua
local original = world
local proxy = cloneref(world)

print(original == proxy) -- false
print(rawequal(original, proxy)) -- false
```

## `compareinstances`

Compares two instance userdata references and returns whether they point to the exact same underlying Datamodel object, regardless of `__eq` overrides or `cloneref` proxies.

```lua
function compareinstances(first: Instance, second: Instance): boolean
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `first` | The first instance userdata reference to compare. |
| `second` | The second instance userdata reference to compare. |

### Returns

- `boolean` - `true` if both references point to the same underlying managed C# object; otherwise `false`.

### Example

```lua
local proxy = cloneref(world)
print(compareinstances(world, proxy)) -- true
```

## `cache.iscached`

Checks whether an instance currently has an active userdata entry in the internal weak userdata cache.

```lua
function cache.iscached(instance: Instance): boolean
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `instance` | The instance to query in the cache. |

### Returns

- `boolean` - `true` if the instance is currently cached; otherwise `false`.

### Example

```lua
print("Is world cached:", cache.iscached(world)) -- true
```

## `cache.invalidate`

Evicts an instance reference from the weak userdata cache so that subsequent lookups generate fresh proxy objects.

```lua
function cache.invalidate(instance: Instance): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `instance` | The instance to evict from the cache. |

### Example

```lua
cache.invalidate(world)
print(cache.iscached(world)) -- false
```

## `cache.replace`

Replaces an existing cached userdata object with another userdata reference in the weak cache.

```lua
function cache.replace(oldInstance: Instance, newInstance: Instance): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `oldInstance` | The original instance key in the cache. |
| `newInstance` | The new userdata instance value to store in the cache slot. |

### Example

```lua
local proxy = cloneref(world)
cache.replace(world, proxy)
```

## `firephysicaltouch`

Simulates a physical collision touch or touch-ended event between two `Physical` instances, invoking their respective `Touched` or `TouchEnded` event signals.

```lua
function firephysicaltouch(target: Physical, hit: Physical, ended: (boolean | number)?): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `target` | The target `Physical` instance whose touch event will be triggered. |
| `hit` | The other `Physical` instance involved in the collision. |
| `ended` *(optional)* | `true` or `1` to fire `TouchEnded`; `false`, `0`, or omitted to fire `Touched`. |

### Example

```lua
local partA = Environment:FindChild("PartA")
local partB = Environment:FindChild("PartB")
if partA and partB then
    firephysicaltouch(partA, partB, false) -- Fires Touched
end
```

## `firephysicalclick`

Fires the `Clicked` signal on a `Physical` instance as if clicked by the local player.

```lua
function firephysicalclick(target: Physical): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `target` | The target `Physical` instance to click. |

### Example

```lua
local buttonPart = Environment:FindChild("ClickButton")
if buttonPart then
    firephysicalclick(buttonPart)
end
```

## `fireinteractionprompt`

Triggers the `Interacted` signal on an `InteractionPrompt` instance on behalf of the local player.

```lua
function fireinteractionprompt(prompt: InteractionPrompt): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `prompt` | The `InteractionPrompt` instance to activate. |

### Example

```lua
local doorPrompt = Environment:FindChild("DoorPrompt")
if doorPrompt then
    fireinteractionprompt(doorPrompt)
end
```
