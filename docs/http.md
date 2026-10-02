# HTTP Networking

The **HTTP Networking** module provides robust capabilities for making synchronous/asynchronous HTTP requests, handling custom headers, cookies, query parameters, payloads, and fetching remote resources.

## `request`

Performs an HTTP request (supporting `GET`, `POST`, `PUT`, `DELETE`, `PATCH`, `HEAD`) and returns a comprehensive response table containing the status code, status message, body, headers, and cookies.

The `User-Agent` header is set to the executor name and version (e.g. `Quaternion/1.0.0`) by default, but can be overridden.

```lua
function request(options: {
    Url: string,
    Method: string?,
    Headers: { [string]: string }?,
    Cookies: { [string]: string }?,
    Body: string?
}): {
    Success: boolean,
    StatusCode: number,
    StatusMessage: string,
    Body: string,
    Headers: { [string]: string },
    Cookies: { [string]: string }
}
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `options.Url` *(or `options.url`)* | The destination URL string (e.g. `"https://httpbin.org/get"`). |
| `options.Method` *(or `options.method`, optional)* | HTTP method: `"GET"`, `"POST"`, `"PUT"`, `"DELETE"`, `"PATCH"`, `"HEAD"` (defaults to `"GET"`). |
| `options.Headers` *(or `options.headers`, optional)* | Key-value table of HTTP request headers. |
| `options.Cookies` *(or `options.cookies`, optional)* | Key-value table of cookies sent with the request. |
| `options.Body` *(or `options.body`, optional)* | Request payload string for POST/PUT/PATCH requests. |

### Returns

- `{ Success: boolean, StatusCode: number, StatusMessage: string, Body: string, Headers: table, Cookies: table }` - Response object containing:
  - `Success: boolean` - `true` if HTTP status code is in the 2xx range; otherwise `false`.
  - `StatusCode: number` - Integer HTTP response status code (e.g. `200`, `404`).
  - `StatusMessage: string` - HTTP reason phrase (e.g. `"OK"`, `"Not Found"`).
  - `Body: string` - Response body content string.
  - `Headers: { [string]: string }` - Key-value map of response headers.
  - `Cookies: { [string]: string }` - Key-value map of cookies parsed from `Set-Cookie` headers.

### Example

```lua
local response = request({
    Url = "https://httpbin.org/post",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = '{"user":"bjarnos"}'
})

if response.Success then
    print("Status:", response.StatusCode)
    print("Body:", response.Body)
end
```

## `httpget`

Convenience helper that performs an HTTP `GET` request to a URL and returns the raw response body string directly.

```lua
function httpget(url: string): string
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `url` | The URL string to fetch. |

### Returns

- `string` - The response body string (or empty string on failure).

### Example

```lua
local scriptSource = httpget("https://raw.githubusercontent.com/example/script/main.lua")
loadstring(scriptSource)()
```

## `WebSocket.connect`

Establishes a persistent, bidirectional WebSocket connection to a remote server and returns a `WebSocketClient` instance equipped with `PTSignal` message/event hooks and send/close methods.

Both `WebSocket.connect` and lowercase `websocket.connect` (as well as `syn.websocket.connect`) are supported.

```lua
function WebSocket.connect(url: string): WebSocketClient
```

### Parameters

| Parameter | Description |
| :--- | :--- |
| `url` | The WebSocket destination URL (must start with `ws://` or `wss://`). |

### Returns

- `WebSocketClient` - An active WebSocket connection object with the following interface:

#### Properties & Signals

| Member | Type | Description |
| :--- | :--- | :--- |
| `OnMessage` / `onmessage` | `PTSignal<string>` | Signal fired whenever a message is received from the server. The listener receives `(message: string)`. |
| `OnClose` / `onclose` | `PTSignal` | Signal fired when the WebSocket connection is closed. |
| `OnError` / `onerror` | `PTSignal<string>` | Signal fired when a socket communication error occurs. The listener receives `(errorMessage: string)`. |
| `Url` / `url` | `string` | The connected WebSocket server URL. |

#### Methods

| Method | Signature | Description |
| :--- | :--- | :--- |
| `Send` / `send` | `(message: string) -> ()` | Transmits a text message over the open WebSocket. |
| `Close` / `close` | `() -> ()` | Gracefully closes the WebSocket connection. |

### Example

```lua
local socket = WebSocket.connect("ws://127.0.0.1:8080")

socket.OnMessage:Connect(function(message)
    print("Received from server:", message)
end)

socket.OnClose:Connect(function()
    print("Socket connection has closed")
end)

socket.OnError:Connect(function(err)
    warn("WebSocket error:", err)
end)

-- Send a message
socket:Send("Hello from Quaternion!")

-- Close when done
wait(1)
socket:Close()
```
