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
    (err, compressed) <~ zlib.gzip data
    if err
        response.writeHead 404
        response.end!
    else
        headers =
            "Cache-Control": "no-cache"
            "Pragma": "no-cache"
            "Content-Type": mime.lookup request.url
            "Content-Encoding": "gzip"

        if request.url is "/index.html"
            response.writeHead 200, "ok", headers
            d_chunk1 = compressed.slice 0, 2920
            d_chunk2 = compressed.slice 2920
            response.write d_chunk1
            <~ process.nextTick
            response.end d_chunk2
        else
            headers."Content-Length" = compressed.length
            response.writeHead 200, "ok", headers
            response.end compressed
    # request.resume!

<~ httpServer.listen 8080
console.log "Server listening"
