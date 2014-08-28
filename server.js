var express         = require('express');
var morgan          = require('morgan');
var cookieParser   = require('cookie-parser');
var bodyParser     = require('body-parser');
var connect         = require('connect');
var connectTimeout = require('connect-timeout');


var app = express();

app.use(connect());
app.use(morgan('combined'));
app.use(cookieParser());
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }))
// parse application/json
app.use(bodyParser.json())
// parse application/vnd.api+json as json
app.use(bodyParser.json({ type: 'application/vnd.api+json' }))


// respond
app.use(function(req, res, next){
  res.send('Hello World');
});

app.listen(process.env.PORT || 3000);
