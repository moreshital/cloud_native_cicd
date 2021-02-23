var express = require('express')
var app = express()

app.get('/', function (req, res) {
  res.send('Welcome to WIDS 2021!')
})

app.get('/environment', function (req, res) {
  res.send(process.env.NODE_ENV)
})

app.listen(3000, function () {
  console.log('Listening on port 3000...')
})
