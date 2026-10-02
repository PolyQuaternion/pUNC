# Signals

The **Signals** module provides functions for inspecting, firing, and managing the lifecycle of `PTSignal` event connections and callbacks across the Datamodel.

## `firesignal`

Fires all active connections connected to the specified `PTSignal` instance with any provided variable arguments.

```lua
function firesignal(signal: PTSignal, ...: any): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `signal` | The target `PTSignal` instance to fire. |
| `...` *(optional)* | Arbitrary arguments to forward to all connected listeners. |

### Example

```lua
local part = Instance.New("Part")

part.Touched:Connect(function(hit)
    print("Part was touched by:", hit)
end)

-- Manually fire the Touched signal with a mock hit instance
-- This will not be replicated!
firesignal(part.Touched, world)
```

## `getconnections`

Returns an array of [`Connection`](#connection-type) objects representing all active subscriptions and callbacks attached to the specified `PTSignal`.

```lua
function getconnections(signal: PTSignal): { Connection }
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `signal` | The `PTSignal` instance whose connections to inspect. |

### Returns

- `{ Connection }` - An array of `Connection` objects connected to the signal.

### Example

```lua
local button = Instance.New("UIButton")

button.Clicked:Connect(function()
    print("Button clicked!")
end)

local connections = getconnections(button.Clicked)
print("Total connections:", #connections)

local conn = connections[1]
print("Is enabled:", conn.Enabled)
print("Is Lua connection:", conn.LuaConnection)
print("Connected function:", conn.Function)

-- Disable the connection without disconnecting
conn.Enabled = false
firesignal(button.Clicked) -- Does not trigger

-- Re-enable via property and fire directly
conn.Enabled = true
conn:Fire()
```

## `Connection` Type

The `Connection` object represents an individual event subscription returned by [`getconnections`](#getconnections). It encapsulates the callback state, associated Luau execution context, and provides granular control over the listener's lifecycle.

### Type Definition

```lua
type Connection = {
    Enabled: boolean,
    LuaConnection: boolean,
    Function: ((...any) -> ...any)?,
    Thread: thread?,

    Disconnect: (self: Connection) -> (),
    Fire: (self: Connection, ...any) -> (),
    Defer: (self: Connection, ...any) -> (),
}
```

### Properties

#### `Enabled`
- **Type**: `boolean`
- **Access**: Read / Write
- **Description**: Determines whether the connection is active and will respond to `firesignal` or normal engine signal dispatches. Setting `conn.Enabled = false` suppresses execution without removing the connection from the signal. Setting `conn.Enabled = true` resumes normal execution.

```lua
conn.Enabled = false -- listener is temporarily muted
conn.Enabled = true  -- listener is active again
```

#### `LuaConnection`
- **Type**: `boolean`
- **Access**: Read-only
- **Description**: `true` if the callback was registered from a Luau script; `false` if it is an internal engine / C# delegate.

#### `Function`
- **Type**: `function | nil`
- **Access**: Read-only
- **Description**: The underlying Luau function that was passed to `:Connect()` or `:Once()`. Allows direct reflection, upvalue inspection via `debug.getupvalues(conn.Function)`, or function hooking via `hookfunction(conn.Function, newFn)`. Returns `nil` if the connection is a native C# delegate.

```lua
local fn = conn.Function
if fn then
    local info = debug.getinfo(fn)
    print("Callback defined in:", info.source, "at line:", info.currentline)
end
```

#### `Thread`
- **Type**: `thread | nil`
- **Access**: Read-only
- **Description**: The Luau thread/coroutine context allocated for handling invocations of this callback. Returns `nil` if no thread handler is associated.

### Methods

#### `connection:Disconnect`

Permanently removes the connection from the signal's callback list and sets `Enabled` to `false`. Once disconnected, the connection cannot be re-enabled.

```lua
function connection:Disconnect(): ()
```

#### `connection:Fire`

Immediately invokes this specific connection's callback handler with the provided arguments, bypassing signal-level dispatching and executing even if `connection.Enabled` is set to `false`.

```lua
function connection:Fire(...: any): ()
```

##### Parameters

| Parameter | Description |
| :--- | :--- |
| `...` *(optional)* | Arguments passed directly to the callback function. |

##### Example

```lua
-- Directly trigger a specific listener
conn:Fire("custom_argument", 123)
```

#### `connection:Defer`

Schedules this specific connection's callback handler to execute asynchronously on the next execution frame/task cycle with the provided arguments.

```lua
function connection:Defer(...: any): ()
```

##### Parameters

| Parameter | Description |
| :--- | :--- |
| `...` *(optional)* | Arguments forwarded to the deferred callback function. |

##### Example

```lua
-- Defer execution to avoid blocking the current thread
conn:Defer("async_data")
```
