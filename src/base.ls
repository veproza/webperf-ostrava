require! {
    http
    fs
    mime
}
first_chunk = 11680_bytes
httpServer = http.createServer (request, response) ->
    request.on \end ->
        console.log request.url
        time = if request.url is "/index.html" then 1 else 5000
        <~ setTimeout _, time
        (err, data) <~ fs.readFile "#__dirname/../www/#{request.url}"
        if err
            response.writeHead 404
            response.end!
        else
            headers =
                "Cache-Control": "no-cache"
                "Pragma": "no-cache"
                "Content-Type": mime.lookup request.url
            if data.length > first_chunk
                d_chunk1 = data.slice 0, first_chunk
                d_chunk2 = data.slice first_chunk
                console.log "Chunk 1"
                response.write d_chunk1
                <~ setTimeout _, 2000
                console.log "Chunk 2"
                response.end d_chunk2
            else
                headers."Content-Length": data.length
                response.writeHead 200, "ok", headers
                response.end data
    request.resume!

<~ httpServer.listen 8080
console.log "Server listening"
