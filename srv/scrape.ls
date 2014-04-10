require! {
    request
    fs
    async
}
(err, data) <~ fs.readFile "#__dirname/../data/list.txt"
lines = data.toString!replace /\r/g "" .split "\n" .filter -> it
# lines.length = 1
<~ async.each lines, (url, cb) ->
    (err, res, body) <~ request.get do
        uri: "http://#url"
        encoding: null

    <~ fs.writeFile "#__dirname/../data/scrape/#url", body
    cb!

