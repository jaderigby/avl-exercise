var mongoose = require('mongoose');

var Schema = mongoose.Schema;
var UserSchema = new Schema({
	firstName: String,
	middleName: String,
	lastName: String
});

module.exports = mongoose.model('User', UserSchema);