require! {
    http
    fs
    mime
}

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
                "Content-Length": data.length
                "Content-Type": mime.lookup request.url
            response.writeHead 200, "ok", headers
            response.end data
    request.resume!

<~ httpServer.listen 8080
console.log "Server listening"
