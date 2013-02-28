/*
 * Module dependencies
 */
var express = require('express')
  , lessMiddleware = require('less-middleware')


var app = express()

app.use(express.methodOverride());
 
// ## CORS middleware
// 
// see: http://stackoverflow.com/questions/7067966/how-to-allow-cors-in-express-nodejs
var allowCrossDomain = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
      
    // intercept OPTIONS method
    if ('OPTIONS' == req.method) {
      res.send(200);
    }
    else {
      next();
    }
};
app.use(allowCrossDomain);

app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.logger('dev'))
app.use(lessMiddleware({
  src      : __dirname + "/public",
  compress : true
}))
app.use(express.static(__dirname + '/public'))

app.get('/', function (req, res) {
  res.render('index',
  { title : 'Home' }
  )
})
app.get('/hacker', function (req, res) {
  res.render('hacker',
  { title : 'Hacker' }
  )
})

app.listen(3000)