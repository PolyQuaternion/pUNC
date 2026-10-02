# Filesystem

The **Filesystem** module provides file and directory operations within the executor's workspace directory. Directory traversal escapes (`..`) are strictly sandboxed.

## `readfile`

Reads the complete contents of a file from the workspace directory and returns it as a string.

```lua
function readfile(path: string): (string, string?)
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `path` | Relative path to the file inside the workspace directory. |

### Returns

- `content: string` - The file content. On failure, returns `nil`.
- `error: string?` - Error message string if the file could not be read; otherwise `nil`.

### Example

```lua
local content = readfile("config.json")
print("Config:", content)
```

## `writefile`

Creates or overwrites a file in the workspace directory with the specified string content. Any missing parent directories are created automatically.

```lua
function writefile(path: string, content: string): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `path` | Relative path to the file to create or overwrite. |
| `content` | The string or binary content to write. |

### Example

```lua
writefile("settings/theme.txt", "dark_mode=true")
```

## `appendfile`

Appends text or binary data to the end of an existing file in the workspace. If the file does not exist, it will be created.

```lua
function appendfile(path: string, content: string): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `path` | Relative path to the file. |
| `content` | The string content to append. |

### Example

```lua
appendfile("logs.txt", "[" .. os.date() .. "] Script started.\n")
```

## `isfile`

Checks whether a file exists at the specified workspace path.

```lua
function isfile(path: string): boolean
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `path` | Relative path to check. |

### Returns

- `boolean` - `true` if the file exists and is a regular file; `false` otherwise.

### Example

```lua
if isfile("data.json") then
    print("Found existing data file.")
end
```

## `isfolder`

Checks whether a directory exists at the specified workspace path.

```lua
function isfolder(path: string): boolean
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `path` | Relative path to check. |

### Returns

- `boolean` - `true` if the directory exists; `false` otherwise.

### Example

```lua
if isfolder("scripts") then
    print("Scripts folder is present.")
end
```

## `makefolder`

Creates a new directory (and any necessary intermediate parent directories) in the workspace.

```lua
function makefolder(path: string): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `path` | Relative path of the folder to create. |

### Example

```lua
makefolder("configs/custom")
```

## `delfile`

Deletes a file from the workspace.

```lua
function delfile(path: string): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `path` | Relative path of the file to delete. |

### Example

```lua
delfile("temp_cache.dat")
```

## `delfolder`

Recursively deletes a folder and all of its contents from the workspace.

```lua
function delfolder(path: string): ()
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `path` | Relative path of the folder to delete. |

### Example

```lua
delfolder("temporary_data")
```

## `listfiles`

Lists all file and folder paths located inside the specified workspace directory.

```lua
function listfiles(folder: string?): { [number]: string }
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `folder` *(optional)* | Relative path to the folder to list (defaults to `""` for workspace root). |

### Returns

- `{ [number]: string }` - Array of relative path strings of entries found in the folder.

### Example

```lua
local files = listfiles("")
for _, filePath in ipairs(files) do
    print("Entry:", filePath)
end
```

## `loadfile`

Reads a Lua script file from the workspace and compiles it into an executable function chunk without executing it immediately.

```lua
function loadfile(path: string): (((...any) -> ...any)?, string?)
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `path` | Relative path to the `.lua` file in the workspace. |

### Returns

- `((...any) -> ...any)?` - Compiled function chunk, or `nil` on compilation failure.
- `error: string?` - Compilation or I/O error message if loading failed.

### Example

```lua
local mainChunk, err = loadfile("scripts/auto_farm.lua")
if mainChunk then
    mainChunk()
else
    warn("Failed to load script:", err)
end
```
