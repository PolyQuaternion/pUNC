# System

The **System** module provides mostly miscellaneous functions and functions which modify the host.

## `identifyexecutor`

Returns the name and version string of the running executor environment.

```lua
function identifyexecutor(): (string, string)
```

### Returns

- `name: string` - The name of the executor (e.g. `"Quaternion"`).
- `version: string` - The version string of the executor (e.g. `"1.0.0"`).

### Example

```lua
local name, version = identifyexecutor()
print("Running on: " .. name .. " v" .. version)
```

## `gethui`

Returns a hidden, dedicated `PlayerGUI` container detached from standard game scripts, allowing safe rendering of executor UI elements (or storing of Instances) without detection by game anti-cheats.

```lua
function gethui(): PlayerGUI | nil
```

### Returns

- `PlayerGUI | nil` - A detached `PlayerGUI` instance container.

### Example

```lua
local hui = gethui()
if hui then
    local label = Instance.New("GUI")
    label.Name = "Script UI"
    label.Parent = hui
end
```

## `getcustomasset`

Loads a local asset file from the workspace/filesystem, decodes it into the game engine's resource cache, and generates a synthetic asset ID string that can be assigned directly to asset properties such as `UIImage.ImageID`, `Sound.AudioID`, or `Model.MeshID`.

Supported formats include images (`.png`, `.jpg`, `.jpeg`, `.webp`, `.svg`, `.tga`, `.bmp`), audio files (`.mp3`, `.ogg`, `.wav`), and 3D meshes/scenes (`.glb`, `.gltf`).

```lua
function getcustomasset(filePath: string, noCache: boolean?): string
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `filePath` | The relative or absolute path to the local asset file. |
| `noCache` | *(Optional)* If set to `true`, generates a new asset ID rather than returning an existing cached asset ID for the file. Default is `false`. |

### Returns

- `string` - The numeric asset ID string representing the loaded resource (e.g. `"900000001"`).

### Example

```lua
local filePath = "explosion.mp3"

local response = request({
    Url = "https://www.myinstants.com/media/sounds/vine-boom.mp3",
    Method = "GET"
})

writefile(filePath, response.Body)
local customAssetId = getcustomasset(filePath)

local sound = Instance.New("Sound")
sound.SoundID = tonumber(customAssetId)
sound.Loop = false
sound.PlayInWorld = false
sound.Parent = Environment

sound:Play()
```


## `setclipboard`

Sets the system clipboard text content across supported platforms.

```lua
function setclipboard(content: string): boolean
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `content` | The string text to copy to the system clipboard. |

### Returns

- `boolean` - `true` if the text was successfully written to the clipboard; otherwise `false`.

### Example

```lua
setclipboard("https://polytoria.com")
```

## `getclipboard`

Retrieves the current text content from the system clipboard.

```lua
function getclipboard(): string
```

### Returns

- `string` - The current string content stored in the system clipboard.

### Example

```lua
local text = getclipboard()
print("Clipboard contains: " .. text)
```

## `setfpscap`

Configures the maximum frames per second (FPS) limit for the client engine.

```lua
function setfpscap(cap: number): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `cap` | The target framerate cap. Set to `0` or negative to remove the FPS cap. |

### Example

```lua
setfpscap(30) -- For a low end device
```
