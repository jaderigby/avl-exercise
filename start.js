var port = process.env.PORT || 3000;

// grunt tasks
var cp = require('child_process');
var grunt = cp.spawn('grunt', ['--force', 'default', 'watch'])
grunt.stdout.on('data', function(data) {
	// relay output to console
	console.log("%s", data)
});

// set up app
var express = require('express');
var app = express();

// Logging
var logger = require('morgan');
app.use(logger('dev'));

// configure body-parser
var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// for api: connect to database
var mongoose = require('mongoose');
var dbName = 'test';
var connectionString = 'mongodb://localhost:27017/' + dbName;
mongoose.connect(connectionString);

// service static files
var static = require('serve-static')
var path = require('path');
app.use(static(path.join(__dirname, 'app')));

//==== for api
var User = require('./app/models/user');
var router = express.Router();

// verify api = "localhost:3000/api"
router.get('/', function(req, res) {
    res.json({ message: 'Yay! Our api is working!' });   
});

// get
router.route('/users').get(function(req, res) {
	User.find(function(err, users) {
		if (err) {
			return res.send(err);
		}

		res.json(users);
	});
});

// post
router.route('/users').post(function(req, res) {
	// var db = new mongoOp();
	var user = new User(req.body);

	user.save(function(err, usr) {
		if (err) {
			return res.send(err);
		}

		res.send({
			"user" : {
				"_id" : usr._id
				, "firstName" : req.body.firstName
				, "middleName" : req.body.middleName
				, "lastName" : req.body.lastName
			}
			, "message" :  "Name saved"
		});
	});
});

// put
router.route('/users/:id').put(function(req,res) {
	User.findOne({ _id: req.params.id }, function(err, user) {
		if (err) {
			return res.send(err);
		}

		for (prop in req.body) {
			user[prop] = req.body[prop];
		}

		// save the user
		user.save(function(err) {
			if (err) {
				return res.send(err);
			}

			res.json({
				"user" : {
					"_id" : req.body._id
					, "firstName" : req.body.firstName
					, "middleName" : req.body.middleName
					, "lastName" : req.body.lastName
				}
				, "message" : "Name updated successfully"
			});
		});
	});
});

// retrieve
router.route('/users/:id').get(function(req, res) {
	User.findOne({ _id: req.params.id}, function(err, user) {
		if (err) {
			return res.send(err);
		}

		res.json(user);
	});
});

// delete
router.route('/users/:id').delete(function(req, res) {
	User.remove({
		_id: req.params.id
	}, function(err, user) {
		if (err) {
			return res.send(err);
		}

		res.json({ message: 'Successfully removed' });
	});
});

app.use('/api', router);
//=======| api

// auto-open in default browser
var opn = require('opn');
opn('http://localhost:' + port);

app.listen(port);