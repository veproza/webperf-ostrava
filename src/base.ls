require! {
    http
    fs
    mime
    zlib
}
first_chunk = 11680_bytes
t0 = 0
httpServer = http.createServer (request, response) ->
    if request.url is "/index.html"
        t0 := Date.now!
    console.log Date.now! - t0, request.url
    time = if request.url is "/index.html" then 1 else 5000
    # <~ setTimeout _, time
    (err, data) <~ fs.readFile "#__dirname/../www/#{request.url}"
    if err
        response.writeHead 404
        response.end!
    else
        headers =
            "Cache-Control": "no-cache"
            "Pragma": "no-cache"
            "Content-Type": mime.lookup request.url
        headers."Content-Length" = data.length
        if data.length > first_chunk
            headers."Content-Encoding" = "gzip"
            response.writeHead 200, "ok", headers
            (err, compressed) <~ zlib.gzip data
            d_chunk1 = compressed.slice 0, first_chunk
            d_chunk2 = compressed.slice first_chunk
            response.end compressed
        else
            response.writeHead 200, "ok", headers
            response.end data
    # request.resume!

<~ httpServer.listen 8080
console.log "Server listening"
