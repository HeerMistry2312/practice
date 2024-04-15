let http = require('http');
let port = 7000;
http.createServer((a, b) => {
    b.writeHead(200, { 'content-type': 'text/html' });
    b.write("<h1>Hello and Welcome to my Server...</h1>")
    b.end();
}).listen(port, () => {
    console.log(`Server Running on port ${port}`)
});


let fs = require('fs')
let func1 = (err, content) => {
    if (err) {
        console.error(`Error: ${err}`)
        return
    }
    console.log(`data: ${content}`)
}


let f2 = (name, callback) => {
    fs.readFile(name, 'utf-8', (err, data) => {
        if (err) {
            callback(err, null)
            return
        }
        callback(null, data)
    })
}
f2('heer.txt', func1)


let os = require('os')
let system = {
    CPUS: os.cpus().length,
    Free_memory: os.freemem(),
    Home_Directory: os.homedir(),
    Host_Name: os.hostname(),
    NetworkInterfaces: os.networkInterfaces(),
    Platform: os.platform(),
    Release: os.release(),
    Total_Memory: os.totalmem(),
    Type: os.type(),
    User_Info: os.userInfo(),
    Version: os.version()
}
console.log(system)


let express = require('express')
let app = express()
let port = 8000;
app.get('/welcome', (req, res) => {
    res.send("<h1>Welcome to my Web-Page...</h1>")
})
app.listen(port, () => {
    console.log(`Server Started on portno: ${port}`)
})

let path = require('path')
let fs = require('fs')
console.log(__dirname)
let folders = ['config', 'controllers', 'db', 'handlers', 'interface', 'libs', 'middleware', 'models', 'routes', 'views']
folders.forEach(folders => {
    let x = fs.mkdirSync(path.join(__dirname, folders))
    if (fs.existsSync(x)) {
        console.log("Direcory already Exists...")
        return
    }
    console.log(`Direcory Created For ${folders}`)
})
fs.writeFileSync('app.js', '');

console.log('Express folder structure created successfully!');

