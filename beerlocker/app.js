var express = require('express')
var mongoose = require('mongoose')
var bodyParser = require('body-parser')
var beerController = require('./controllers/beer')
var userController = require('./controllers/user')
var passport = require('passport')
var authController = require('./controllers/auth')

mongoose.connect('mongodb://localhost:27017/beerlocker')

var app = express()

app.use(bodyParser.urlencoded({
  extended: true
}))

app.use(passport.initialize())

var port = process.env.PORT || 3000

var router = express.Router()

router.route('/beers')
  .post(authController.isAuthenticated, beerController.postBeers)
  .get(authController.isAuthenticated, beerController.getBeers)

router.route('/beers/:beer_id')
  .get(authController.isAuthenticated, beerController.getBeer)
  .put(authController.isAuthenticated, beerController.putBeer)
  .delete(authController.isAuthenticated, beerController.deleteBeer)

router.route('/users')
  .post(userController.postUsers)
  .get(authController.isAuthenticated, userController.getUsers)

app.use('/api', router)

app.listen(port)
console.log('Insert beer on port ' + port)
