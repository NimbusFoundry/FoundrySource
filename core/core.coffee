###
 core code
###
core = new Object()

core._plugins = {}

core._workspace = {}

core._models = {}

core.angular = 
	dependency : []

core.loaded = false

core.bootstraped = false

core.default_plugin = ''

window.create_object_dictionary= (all)->
  dict = {}
  
  for obj in all
    dict[obj.id] = obj
    
  dict

#check if this is a redirect, put up the logging in spinner, if it is.
if Nimbus.Client.GDrive.is_auth_redirected()
  $("#login_buttons").addClass("redirect")

core.current_user = (callback)->
	self = this
	#initialize yourself
	Nimbus.Share.get_me (me)-> 
		console.log(me)
		self._current_user = me
		if !self._current_user.email
			self._current_user.email = Nimbus.Share.get_user_email()
		callback(me) if callback
		$("#user_pic").attr("src", me.pic)
		$("#user_pic_large").attr("src", me.pic)

core.shared_users = (callback)->
	self = this
	#initialize current users
	Nimbus.Share.get_shared_users_real (users) ->
		console.log(users)
		self._user_list = window.create_object_dictionary(users)
		callback(users) if callback


###
 separate plugin loading form init process to accerate the app time
###
core.plugins_loaded = false

core.load_plugins = ()->
	self = @
	require(['core'], (main)->
		# set loaded to true
		self.plugins_loaded = true
		require(main.plugins, ()->
			# assgin the plugin
			for plugin in arguments
				self._plugins[plugin.name] = plugin

			# config angular
			dependency = self.angular.dependency.concat(['foundry-ui','ngRoute'])
			angular
			.module('foundry', dependency)
			.config(['$routeProvider', ($routeProvider)->
				for route,path of main.paths
					$routeProvider
						.when '/'+route, 
							templateUrl : path+'.html'
				return
			])
			.run(['$rootScope','$location', ($rootScope,$location)->
				$rootScope._plugins = []
				for inex,_plugin of foundry._plugins
					$rootScope._plugins.push(_plugin)
				$rootScope._active_app_path = ''
				# config current user varible
				$rootScope._current_global_user = foundry._current_user

				# add location update handler
				$rootScope.$on('$locationChangeSuccess', (evt, new_path, old_path)->
					default_path = localStorage.default_plugin || foundry.default_plugin
					if default_path and !$location.path()
						$location.path(default_path)
					else if !$location.path()
						$location.path('/workspace')
					$rootScope._active_app_path = $location.path()
					localStorage.default_plugin = $location.path()
					return
				)
				return
			])

			console.log 'plugins loaded'
			self.plugin_load_completed()
		)
	)

define('core',['config'],(config)->
	# load for app plugins into packages
	console.log config
	paths = {}
	plugins = []
	packages = []
	for key,value of config.plugins
		paths[key] = value + '/index'
		plugins.push(key)
		packages.push(
			name : key
			location : value
			main : 'index'
		)

	requirejs.config(
		'packages' :  packages
	)

	c = 
		'plugins' : plugins
		'paths' : paths
		'packages' : packages
		'appName' : config.appName

	return c
)

core.plugin_load_completed = ()->
	console.log 'plugins is loaded'

# config method
core.init = (callback)->
	self = @

	cb = ()->
		self.init_settings()
		
		# call each plugin's inited method
		for key,value of self._plugins
			if typeof value.inited is 'function'
				value.inited()
		
		# bootstrap angular
		if !self.bootstraped
			angular.bootstrap(document, ['foundry'])
			self.bootstraped = true
		if callback
			callback()
		return


	if @.plugins_loaded
		console.log 'plugins loaded, and start the callback'
		@reinitialize(cb)
	else
		console.log 'not yet, put the callback into the plugin_callbak'
		plugin_completed = @.plugin_load_completed
		@plugin_load_completed = ()->
			plugin_completed()
			self.reinitialize(cb)
	
	return

core.module_status = {}

core.reinitialize = (callback)->
	if callback
		@.module_finished = callback	

	for k,v of this._plugins
		if v.type is 'plugin'
			@module_status[v.name] = 'start'

	for k,v of this._plugins
		if v.type is 'plugin'
			try
				v.init()
			catch e
				console.log e
	# callback()
	return

core.initialized = (module)->
	# check if all module initialzed
	@module_status[module] = 'end'
	console.log @module_status
	
	for k,v of this._plugins
		return if @module_status[v.name] is 'start'
	# call when all module finished
	if @module_finished
		@module_finished()
	
	
# ready callback ?? not sure if this will be need.
core.ready = (callback)->
	self = @
	Nimbus.Auth.set_app_ready(()->
		callback()
		self.loaded = true
	)

# register model,return the class only
core.model = (name, attributes, callback)->
	self = this
	if name and attributes
		model = Nimbus.Model.setup(name,attributes)
		self._models[name] = model
		
		sync_finished = ()->
			callback(model)
		model.sync_all(sync_finished)
		model
	else
		throw 'Model name and attributes should be specified'
		undefined
# register plugin
core.module = (name, obj, callback)->
	name_used = false
	if !core._plugins[name]
		core._plugins[name] = obj
	else
		name_used = true
	callback(!name_used)
	console.log 'register '+if !name_used then 'ok' else 'failed' 

# load plugin
core.load = (name)->
	@_plugins[name]

core.load_model = (name)->
	@_models[name]

core.logout = ()->
	Nimbus.Auth.logout()

###
	parse context within url
###
core.parse_open_url = ()->
	config = {}
	string = decodeURIComponent(location.search.substring(1)).replace('/','')
	regex = /([^&=]+)=([^&]*)/g;
	while m = regex.exec(string)
		config[m[1]] = m[2]

	if config.state
		try
			open_setting = JSON.parse(config.state)
			if open_setting
				localStorage.login_user = open_setting.userId
				if open_setting.ids[0]
					localStorage.last_opened_workspace = open_setting.ids[0]
		catch e
			console.log e
	else if config.space
		localStorage.last_opened_workspace = config.space
		localStorage.to_open_topic = config.topic

	config
core.parse_open_url()

#add a setting section
###
	function: initialize the setting
###
core.init_settings = ()->
	core.settings = core.model("Settings", ["userid", "setting_name", "setting_value"], (model)->
		core.settings = model
		core._my_settings = model.findByAttribute("userid", core._current_user.id)
	)

###
	input: the key and the value to set
	function: set the setting
###
core.set_setting = (key, value) ->
	my_settings = foundry.settings.select( (item)-> item.userid is foundry._current_user.id and item.setting_name is key )

	if my_settings.length is 0
	  foundry.settings.create({ "userid": foundry._current_user.id, "setting_name": key, "setting_value": value })
	else
	  x = my_settings[0]
	  x.setting_value = value
	  x.save()

###
	input: the key for the setting to retrieve
	output: the value of the key
	function: output a setting
###
core.get_setting = (key) ->
	setting = foundry.settings.select( (item)-> item.userid is foundry._current_user.id and item.setting_name is key )
	if setting.length > 0
		return setting[0].setting_value
	else
		return null

#same as get setting but not for yourself
core.get_setting_all = (userid, key) ->
	setting = foundry.settings.select( (item)-> item.userid is userid and item.setting_name is key )
	if setting.length > 0
		return setting[0].setting_value
	else
		return null

# make a file public
# input - file id
core.set_file_public = (id, callback)->
	param = 
		body :
			role : 'reader'
			type : 'anyone'
		path : "/drive/v2/files/#{id}/permissions"
		params : 
			fileId : id
		method: "POST"
		callback : (data)->
			log data
			callback(data) if callback

	gapi.client.request(param)

window.foundry = core
