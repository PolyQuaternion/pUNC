# Input

The **Input** module provides functions to simulate hardware input events, including keyboard key presses, mouse clicks, absolute and relative cursor positioning, and mouse wheel scrolling.

## `keypress`

Simulates pressing down a virtual keyboard key code. A list of key codes can be found [here](https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes).

```lua
function keypress(keycode: number): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `keycode` | The virtual key code (e.g. `0x20` for Space). |

### Example

```lua
keypress(0x20) -- Hold Space key
```

## `keyrelease`

Simulates releasing a previously pressed virtual keyboard key code.

```lua
function keyrelease(keycode: number): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `keycode` | The virtual key code to release. |

### Example

```lua
keyrelease(0x20) -- Release Space key
```

## `mouse1press`

Simulates pressing down the primary (left) mouse button.

```lua
function mouse1press(): ()
```

### Example

```lua
mouse1press()
```

## `mouse1release`

Simulates releasing the primary (left) mouse button.

```lua
function mouse1release(): ()
```

### Example

```lua
mouse1release()
```

## `mouse1click`

Simulates an immediate left mouse button click (press followed by release).

```lua
function mouse1click(): ()
```

### Example

```lua
mouse1click()
```

## `mouse2press`

Simulates pressing down the secondary (right) mouse button.

```lua
function mouse2press(): ()
```

### Example

```lua
mouse2press()
```

## `mouse2release`

Simulates releasing the secondary (right) mouse button.

```lua
function mouse2release(): ()
```

### Example

```lua
mouse2release()
```

## `mouse2click`

Simulates an immediate right mouse button click (press followed by release).

```lua
function mouse2click(): ()
```

### Example

```lua
mouse2click()
```

## `mousemoveabs`

Warps the mouse cursor to absolute screen pixel coordinates `(x, y)`.

```lua
function mousemoveabs(x: number, y: number): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `x` | The absolute X screen coordinate in pixels. |
| `y` | The absolute Y screen coordinate in pixels. |

### Example

```lua
mousemoveabs(960, 540) -- Center on 1080p display
```

## `mousemoverel`

Moves the mouse cursor relative to its current screen position by `(dx, dy)` pixels.

```lua
function mousemoverel(dx: number, dy: number): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `dx` | Horizontal delta in pixels. |
| `dy` | Vertical delta in pixels. |

### Example

```lua
mousemoverel(15, -10)
```

## `mousescroll`

Simulates mouse wheel scrolling. Positive values scroll up (`WheelUp`), negative values scroll down (`WheelDown`).

```lua
function mousescroll(delta: number): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `delta` | Scroll amount and direction (positive = up, negative = down). |

### Example

```lua
mousescroll(1) -- Scroll up 1 tick
```
