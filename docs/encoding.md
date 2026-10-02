# Encoding

The **Encoding** module provides standard Base64 encoding/decoding utilities as well as high-speed LZ4 block data compression and decompression utilities.

## `base64encode`

Encodes arbitrary binary or string data into standard Base64 representation.

```lua
function base64encode(data: string): string
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `data` | The raw string data to encode. |

### Returns

- `string` - Base64 encoded string.

### Example

```lua
local encoded = base64encode("pUNC")
print(encoded) -- "cFVOQw=="
```

## `base64decode`

Decodes a Base64-encoded string back into original string or binary bytes.

```lua
function base64decode(data: string): string
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `data` | The Base64 string to decode. |

### Returns

- `string` - Decoded raw string data.

### Example

```lua
local decoded = base64decode("cFVOQw==")
print(decoded) -- "pUNC"
```

## `lz4compress`

Compresses raw string or binary data using the standard LZ4 block compression algorithm.

```lua
function lz4compress(data: string): string | nil
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `data` | The uncompressed string or binary data to compress. |

### Returns

- `string | nil` - The compressed LZ4 byte sequence, or `nil` on failure.

### Example

```lua
local rawData = string.rep("pUNC Big Long LZ4 Block ", 50)
local compressed = lz4compress(rawData)
print("Original size:", #rawData, "Compressed size:", #compressed)
```

## `lz4decompress`

Decompresses an LZ4 block compressed string back into its original uncompressed data.

```lua
function lz4decompress(data: string, expectedSize: number?): string | nil
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `data` | The LZ4 compressed byte sequence. |
| `expectedSize` *(optional)* | Expected uncompressed size in bytes. If omitted or `0`, dynamically buffer expands during decompression. |

### Returns

- `string | nil` - The restored uncompressed data string, or `nil` on decompression failure.

### Example

```lua
local decompressed = lz4decompress(compressed, #rawData)
print("Decompression matched:", decompressed == rawData) -- true
```
