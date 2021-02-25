var express = require('express')
var app = express()

app.set('view engine', 'ejs')

app.get('/', function (req, res) {
  res.render(process.env.NODE_ENV)
});

app.get('/test', function (req, res) {
  res.send('Test is passed')
})

app.get('/environment', function (req, res) {
 res.render(process.env.NODE_ENV)
})

app.listen(3000, function () {
  console.log('Listening on port 3000...')
})
