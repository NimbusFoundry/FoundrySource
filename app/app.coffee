# setup plugins to load
if not localStorage["version"]?
	localStorage["version"] ="google"
	window.location.reload()

foundry.supportEmail = 'admin@nimbusfoundry.com, admin@nimbusbase.com'
foundry.angular.dependency = []

define('config', ()->
	config = {}
	config.appName = 'Forum'

	config.plugins = 
		forum: 'app/plugins/forum'
		account: 'app/plugins/account'
		# todo : 'plugins/todo'
		document : 'core/plugins/document'
		user : 'core/plugins/user'
		workspace : 'core/plugins/workspace'
		support : 'core/plugins/support'

	config
)

foundry.load_plugins()

Nimbus.Auth.setup 
	'GDrive':
		'app_id' : '965255374748'
		'key': '965255374748-s2ln5arng133cj8goqu0s6gvfsp2to99.apps.googleusercontent.com'
		"scope": "openid https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/gmail.compose https://www.googleapis.com/auth/gmail.modify https://apps-apis.google.com/a/feeds/domain/"
		# "app_name": "foundry"
	"app_name": "forum"
	'synchronous' : false

	'DynamoDB':
		'Google':
			'app_id' : '195693500289'
			'client_id':'195693500289.apps.googleusercontent.com'
			"scope": "https://www.googleapis.com/auth/plus.login"
 
		"app_name":"N05FC192-A6CF-B6BD94C3"
		"region":"us-west-2"

# callback for loading
Nimbus.Auth.authorized_callback = ()->
	if Nimbus.Auth.authorized()
		$("#login_buttons").addClass("redirect")

foundry.ready(()->
	config = foundry.parse_open_url()
	if config
		if config.space
			localStorage.last_open_workspace = config.space
		if config.topic
			localStorage.to_open_topic = config.topic

		# add pushstate so it won't be this url
		state = 
			title: document.title,
			url: location.href.replace(location.search,'')
			otherkey: {}
		window.history.pushState(state, document.title, state.url);

	console.log 'ready: ' + Nimbus.Auth.authorized()
	checkGooglePermission = (type) ->
		return () ->
			if typeof arguments[0] is 'object' and (arguments[0].code is 401 or arguments[0].code is 403)
				console.log type + " perimission not granted."
				foundry.logout()
				location.reload()

	if Nimbus.Auth.authorized()
		gapi.client.load('gmail', 'v1', () ->
			console.log "Gmail loaded"
			# add indicator
			foundry.init(()->
				gapi.client.gmail.users.messages.modify({id:"not_exist",userId:"me"}).execute(checkGooglePermission("gmail.modify"))
				gapi.client.gmail.users.messages.send({userId:'me'}).execute(checkGooglePermission("gmail.send"))

				# remove indicator
				$('#loading').addClass('loaded')  
				$("#login_buttons").removeClass("redirect")
			)
		);
	return
)

window.mailTasks = []
require(['dist/mailComposer.min'], (composeFun) ->
	window.composeMail = composeFun
	if window.mailTasks.length 
		for task in window.mailTasks
			composeFun(task.data, task.callback)
)
$(document).ready(()->
	
	$('#google_login').on('click',(evt)->
		 
		if not (localStorage["version"] is "google")
			localStorage["version"] = "google"
			window.location.reload()
		
		Nimbus.Auth.authorize('GDrive')
	)

	$('#aws_login').on('click',(evt)->
		
		if not (localStorage["version"] is "aws")
			localStorage["version"] = "aws"
			window.location.reload()

		Nimbus.Auth.authorize('DynamoDB',"Google")
	)

	$('.logout_btn').on('click', (evt)->
		foundry.logout()
		location.reload()
	)
	return
)

