# Cryptography

The **Cryptography** module (`crypt`) provides cryptographic hashing algorithms, symmetric AES encryption/decryption across multiple cipher modes, and secure pseudo-random byte/key generation.

## `crypt.hash`

Computes a cryptographic hash digest of input data using the specified algorithm.

```lua
function crypt.hash(data: string, algo: string?): string
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `data` | The input string data to hash. |
| `algo` *(optional)* | The hashing algorithm to use (`"sha256"`, `"sha1"`, `"sha224"`, `"sha384"`, `"sha512"`, `"md5"`). Defaults to `"sha256"`. |

### Returns

- `string` - Lowercase hexadecimal hash digest string.

### Example

```lua
local hash = crypt.hash("password123", "sha256")
print("SHA-256:", hash)
```

## `crypt.encrypt`

Encrypts plaintext data using AES across various cipher modes (`CBC`, `CFB`, `CTR`, `OFB`, `GCM`, `ECB`). Returns the Base64-encoded ciphertext and the generated/used Base64-encoded IV or nonce.

```lua
function crypt.encrypt(data: string | buffer, key: string | buffer, iv: (string | buffer)?, mode: string?): (string, string)
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `data` | Plaintext string or buffer to encrypt. |
| `key` | 16, 24, or 32-byte key string/buffer (or Base64 key). Keys of other lengths are automatically SHA-256 normalized. |
| `iv` *(optional)* | Initialization vector (IV) or nonce. If omitted, a cryptographically secure random IV is generated. |
| `mode` *(optional)* | Cipher mode: `"CBC"`, `"CFB"`, `"CTR"`, `"OFB"`, `"GCM"`, `"ECB"` (case-insensitive, defaults to `"CBC"`). |

### Returns

- `ciphertext: string` - Base64-encoded encrypted ciphertext payload.
- `iv: string` - Base64-encoded initialization vector / nonce used for encryption.

### Example

```lua
local key = crypt.generatekey()
local cipher, iv = crypt.encrypt("Secret Payload", key, nil, "CBC")
print("Ciphertext:", cipher)
print("IV:", iv)
```

## `crypt.decrypt`

Decrypts Base64 or raw ciphertext using AES with the matching key, IV, and cipher mode.

```lua
function crypt.decrypt(cipher: string | buffer, key: string | buffer, iv: (string | buffer)?, mode: string?): string
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `cipher` | Base64-encoded ciphertext string or raw buffer to decrypt. |
| `key` | The encryption key string or buffer. |
| `iv` *(optional)* | The Base64 or raw IV/nonce used during encryption. |
| `mode` *(optional)* | Cipher mode: `"CBC"`, `"CFB"`, `"CTR"`, `"OFB"`, `"GCM"`, `"ECB"` (defaults to `"CBC"`). |

### Returns

- `string` - Decrypted plaintext string.

### Example

```lua
local decrypted = crypt.decrypt(cipher, key, iv, "CBC")
print("Decrypted:", decrypted) -- "Secret Payload"
```

## `crypt.generatebytes`

Generates cryptographically secure random bytes of specified length.

```lua
function crypt.generatebytes(length: number?): string
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `length` *(optional)* | Number of random bytes to generate (defaults to `32`). |

### Returns

- `string` - A string containing the random bytes.

### Example

```lua
local randomBytes = crypt.generatebytes(16)
print("Bytes length:", #randomBytes) -- 16
```

## `crypt.generatekey`

Generates a cryptographically secure 256-bit (32-byte) AES key, returned as a Base64-encoded string.

```lua
function crypt.generatekey(): string
```

### Returns

- `string` - Base64-encoded 256-bit key string.

### Example

```lua
local key = crypt.generatekey()
print("Generated AES Key:", key)
```
