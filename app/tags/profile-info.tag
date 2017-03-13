<profile-info>
	<style type="text/css">
		#statusMessageBox, #errorMessage {
			position: relative;
			margin: 0 auto -30px;
			padding: 15px 25px 15px 15px;
			width: 85%;
			max-width: 600px;
		}
		#statusMessageBox {
			position: absolute;
			margin: auto;
			top: 17px;
			left: 0;
			right: 0;
			color: #3e595f;
			background: #e1ebef;
			opacity: 0;
		}
		#errorMessage {
			position: absolute;
			margin: auto;
			top: 17px;
			left: 0;
			right: 0;
			color: #b30000;
			background-color: #f3e3e3;
			opacity: 0;
		}
		.normal {
			transition: all 0.2s ease-in-out;
			border: 1px solid #888;
			background-color: #444;
		}
		.require {
			transition: all 0.2s ease-in-out;
			border: 1px solid #e4b6b6;
			background-color: #583838;
		}
	</style>
	<div style="display: none" id="errorMessage" class="error-message">
		<div id="message">
			{ errorMessageText }
		</div>
		<div class="close">
			<span onclick={ excuse } class="icon-close"></span>
		</div>
	</div>
	<div style="display: none" id="statusMessageBox" class="status-message-box">
		<div id="statusMessageText">
			{ statusMessageText }
		</div>
		<div class="close">
			<span onclick={ excuse } class="icon-close"></span>
		</div>
	</div>
	<form onsubmit={ submit } class="profile-inputs-wrap">
		<p>
			<label>First Name</label>
			<br />
			<input placeholder="First Name - required" class={ firstClass } onkeyup={ change } type="text" ref="first" />
		</p>
		<p>
			<label>Middle Name (Optional)</label>
			<br />
			<input placeholder="Middle Name" type="text" ref="middle" />
		</p>
		<p>
			<label>Last Name</label>
			<br />
			<input placeholder="Last Name - required" onkeyup={ change } class={ lastClass } type="text" ref="last" />
		</p>
		<p class="center-justify">
			<input type="submit" name="Update" value="Update">
		</p>
	</form>

	<script>

		// Initialize data
		var self = this
		self.content
		function retrieveAjax() {
			showSpinner()
			$.ajax({
				url: '/api/users',
				method: 'GET'
			})
			.done(function(data) {
				console.log(data)
				self.content = data[0]
				self.contentLength = data.length
				if (data.length === 1) {
					self.refs.first.value = data[0].firstName
					self.refs.middle.value = data[0].middleName
					self.refs.last.value = data[0].lastName
				}
				self.update()
			})
			.error(function(err) {
				console.log(err)
			})
			.always(function() {
				hideSpinner()
			})
		}

		retrieveAjax()

		// normalize required classes
		self.firstClass = 'normal'
		self.lastClass = 'normal'
		function showSpinner() {
			var elem = '#spinnerOverlay'
			$(elem).show()
			$(elem).animate({
				opacity: 1
			}, 150)
			setTimeout(hideSpinner, 3000)
		}
		function hideSpinner() {
			$('#spinnerOverlay').animate({
				opacity: 0
			}, 150, function() {
				$('#spinnerOverlay').hide()
			})
		}
		function showError() {
			var elem = '#errorMessage'
			$(elem).show()
			$(elem).animate({
				opacity: 1
			}, 150)
		}
		function hideError() {
			var elem = '#errorMessage'
			$(elem).animate({
				opacity: 0
			}, 150, function() {
				$(elem).hide()
			})
		}
		function showStatusMessage() {
			if (typeof statusTimer !== 'undefined') { clearTimeout(statusTimer) }
			var elem = '#statusMessageBox'
			$(elem).show()
			$(elem).animate({
				opacity: 1
			}, 150)
			statusTimer = setTimeout(hideStatusMessage, 4000)
		}
		function hideStatusMessage() {
			var elem = '#statusMessageBox'
			$(elem).animate({
				opacity: 0
			}, 150, function() {
				$(elem).hide()
			})
		}
		String.prototype.capitalize = function() {
			return this.charAt(0).toUpperCase() + this.slice(1)
		}
		function handleErrors(obj1, obj2, messageVisible) {
			// compose error messages
			errorMessageSub = " can't be blank"
			firstErrorMessage = "First name" + errorMessageSub
			lastErrorMessage = "Last name" + errorMessageSub
			firstAndLastErrorMessage = 'First name and last name' + errorMessageSub
			// evaluate values
			firstVal = (obj1.value === '' || !obj1.value) ? false : obj1.value
			lastVal = (obj2.value === '' || !obj2.value) ? false : obj2.value
			// logic
			if (!firstVal && !lastVal && messageVisible) {
				self.firstClass = 'require'
				self.lastClass = 'require'
				self.errorMessageText = firstAndLastErrorMessage
				if (messageVisible) {
					showError()
				}
				return false
			}
			else if (!firstVal && messageVisible) {
				self.firstClass = 'require'
				self.lastClass = 'normal'
				self.errorMessageText = firstErrorMessage
				if (messageVisible) {
					showError()
				}
				return false
			}
			else if (!lastVal && messageVisible) {
				self.firstClass = 'normal'
				self.lastClass = 'require'
				self.errorMessageText = lastErrorMessage
				if (messageVisible) {
					showError()
				}
				return false
			}
			else {
				self.firstClass = 'normal'
				self.lastClass = 'normal'
				self.errorMessageText = ''
				hideError()
				return true
			}
		}
		function isMessageVisible(){
			return ($('#errorMessage:visible').length > 0)
		}
		function createAjax(data) {
			$.ajax({
				url: '/api/users',
				method: 'POST',
				data: data
			})
			.done(function(response) {
				console.log(response.message)
				console.log("response: ", response)
				self.contentLength = 1
				self.content = response.user
				self.statusMessageText = response.message
				showStatusMessage()
				self.update()
			})
			.error(function(err) {
				console.log("Sorry, please try submitting again.")
			})
			.always(function() {
				hideSpinner()
			})
		}
		function updateAjax() {
			console.log("self.content: ", self.content)
			var newObj = {
				"_id" : self.content._id
				, "firstName" : self.refs.first.value
				, "middleName" : self.refs.middle.value
				, "lastName" : self.refs.last.value
			}
			$.ajax({
				url: '/api/users/' + self.content._id,
				method: 'PUT',
				data: newObj
			})
			.done(function(response) {
				// console.log(self.content)
				// console.log("response: ", response)
				self.contentLength = 1
				self.content = response.user
				self.statusMessageText = response.message
				showStatusMessage()
				self.update()
			})
			.error(function(err) {
				console.log("Sorry, please try submitting again.")
			})
			.always(function() {
				hideSpinner()
			})
		}
		function handleAjax(data) {
			var sameValues = false
			if (self.contentLength === 0) {
				showSpinner()
				createAjax(data)
			}
			else if (self.contentLength === 1) {
				sameValues = (self.content.firstName === self.refs.first.value && self.content.middleName === self.refs.middle.value && self.content.lastName === self.refs.last.value)
				if (!sameValues) {
					showSpinner()
					updateAjax()
				}
				else if (sameValues) {
					console.log("do nothing")
				}
			}
			else {
				console.log("Hmm, something went wrong. Try reloading the page.")
			}
		}

		// used to track if error message is shown upon submission
		errorMessageActivate = false
		errorMessageExcused = false
		submit(e) {
			e.preventDefault()
			firstVal = (self.refs.first.value === '' || !self.refs.first.value) ? false : self.refs.first.value
			lastVal = (self.refs.last.value === '' || !self.refs.last.value) ? false : self.refs.last.value
			if (!firstVal || !lastVal) {
				errorMessageExcused = false
				errorMessageActivate = true
			}
			status = handleErrors(self.refs.first, self.refs.last, errorMessageActivate, self)
			if (status === 'true') {
				var values = {
					"firstName" : self.refs.first.value
					, "middleName" : self.refs.middle.value
					, "lastName" : self.refs.last.value
				}
				handleAjax(values, self)
			}
		}
		change(e) {
			handleErrors(self.refs.first, self.refs.last, errorMessageActivate)
		}
		excuse(e) {
			errorMessageExcused = true
			hideError()
			hideStatusMessage()
		}
	</script>
</profile-info>