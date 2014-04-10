require! {fs, async}
(err, files) <~ fs.readdir "#__dirname/../data/scrape/"
# files.length = 1
hit = 0
matches = {}
<~ async.each files, (file, cb) ->
    (err, content) <~ fs.readFile "#__dirname/../data/scrape/#file"
    content .= toString!
    if -1 < content.indexOf "ajax.googleapis.com"
        m = content.match /ajax.googleapis.com([^"']+)/g
        for mm in m
            matches[mm] ?= 0
            matches[mm]++
        hit++
    cb!
for addr, count of matches
    console.log "#addr\t#count"

