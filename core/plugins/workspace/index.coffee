define('workspace', ['require','core/analytic'],(require, analytic)->
	c_file = Nimbus.realtime.c_file
	doc_plugin=
		type : 'plugin'
		title : 'Workspace'
		anchor : '#/workspace'
		name : 'workspace'
		version : 1.0
		order : -13
		icon : 'icon-folder-close'
		_app_files : []
		_app_folders : []
		init : ()->
			self = @
			# check last opened workspace 
			if localStorage['last_opened_workspace'] and (localStorage['last_opened_workspace'] isnt Nimbus.realtime.c_file.id)
				@open(
					id : localStorage['last_opened_workspace']
				)
			else
				localStorage['last_opened_workspace'] = Nimbus.realtime.c_file.id
				foundry.shared_users((users)->
					_users = users
					foundry.current_user((me)->
						for user in _users
							if user.id is me.id
								foundry._current_user.role = user.role

						# check user email
						if !foundry._current_user.email
							foundry._current_user.email = Nimbus.Share.get_user_email()
						
						console.log _users
						foundry.initialized(self.name)
					)
				)

			# use controller
			define_controller()
		inited : ()->
			log 'inited'
			if @switch_callback
				@switch_callback()

			# test analytic api 
			console.log analytic
		# switch callback is for 
		# switching document finished, and inited is called
		switch_callback : null
		# get all workspaces
		# this is identical to Nimbus.realtime.app_files for now
		all_doc : ()->
			# filter folder
			files = []
			folders = []
			for file in Nimbus.realtime.app_files
				if file.mimeType and file.mimeType is 'application/vnd.google-apps.drive-sdk.'+Nimbus.Auth.app_id
					files.push(file)
				else
					folders.push(file)

			@_app_files = files
			@_app_folders = folders
				
			@_app_files

		# open a workspace 
		# @input - document object
		# @callback - will be called when the document is loaded
		open : (doc, callback)->
			# open file
			localStorage['last_opened_workspace'] = doc.id
			Nimbus.Share.switch_to_app_file_real(doc.id, ()->
				# foundry.reinitialize()
				callback() if callback
				angular.element(document).scope().$apply()

				# setup analytics parameters
				ga('set', 'dimension2', Nimbus.realtime.c_file.title);
				ga('set', 'dimension3', Nimbus.realtime.c_file.owners[0].emailAddress+':'+Nimbus.realtime.c_file.owners[0].displayName);
				ga('set', 'dimension4', foundry._models.User.all())
				return
			)
			return

		# create a workspace with 
		# @input - name of the space
		# @callback - after the worksapce is created and callback with document data
		create : (name, callback)->
			# exception on null name
			if !name
				console.log 'name required'
			self = @
			Nimbus.Client.GDrive.insertFile("", name, 'application/vnd.google-apps.drive-sdk', null, (data)-> 
				Nimbus.realtime.app_files.push(data)
				self._app_files.push(data)
				callback(data)
				angular.element(document).scope().$apply()
				return
			)

			# add analytic event
			analytic.owner(
				id : foundry._current_user.id
				email : foundry._current_user.email
				date : new Date().getTime()
				'name' : name
			)

			return

		current : ()->
			# return current opened file
			return Nimbus.realtime.c_file

		is_current : (doc)->
			return doc.id is Nimbus.realtime.c_file.id

		rename : (doc, name, cb)->
			self = @
			id = doc.id
			old_name = doc.title
			param = 
				path: "/drive/v2/files/"+id
				method: "PATCH"
				params: 
					key: Nimbus.Auth.key
					fileId : id
				body:
					title : name	
				callback:(file)->
					for index,_file of Nimbus.realtime.app_files
						if doc.id is _file.id
							file.title = name	
					# the folder belongs to the current space
					folder = Nimbus.realtime.folder.binary_files

					# apply changes 
					apply_changes = (changed_file)->
						if cb
							cb(changed_file)
						angular.element(document).scope().$apply()

					# rename folder and determine whether to replace 
					rename_folder = (target, replace)->
						self.rename_folder(target, name+' files', (f)->
							if replace
								window.folder.binary_files = f
							apply_changes(file)
						)
					if c_file.id isnt id
						# get the folder first
					    query = "mimeType = 'application/vnd.google-apps.folder' and title = '" + old_name + " files' and properties has { key='space' and value='" + id + "' and visibility='PRIVATE' }";
					    Nimbus.Client.GDrive.getMetadataList(query, (data)->
					    	if !data.error 
					    		if data.items.length >=  1
						    		folder = data.items[0]
						    		rename_folder(folder)
						    	else
						    		apply_changes()
						    else
						    	apply_changes()
					    )
					else
						rename_folder(folder, true)
					
					return
			
			request = gapi.client.request(param)
			# request.execute()
			return
		# input folder object
		# and the name to be changed
		# callback
		rename_folder : (folder, name, cb)->
			log 'rename the folder'
			id = folder.id
			param = 
				path: "/drive/v2/files/"+id
				method: "PATCH"
				params: 
					key: Nimbus.Auth.key
					fileId : id
				body:
					title : name	
				callback:(file)->
					if cb
						cb(file)

					angular.element(document).scope().$apply()

			request = gapi.client.request(param)
			# request.execute()
			return
		del_doc : (doc, callback)->
			# delte document
			return if doc.id is Nimbus.realtime.c_file.id
			Nimbus.Client.GDrive.deleteFile(doc.id)
			for index,file of @_app_files
				if doc.id is file.id
					@_app_files.splice(index,1)
			
			for index,file of Nimbus.realtime.app_files
				if doc.id is file.id
					Nimbus.realtime.app_files.splice(index,1)

			return
				
)

define_controller = ()->

	angular.module('foundry').controller('ProjectController', ['$scope', '$rootScope', 'ngDialog', '$foundry', ($scope, $rootScope, ngDialog, $foundry)->
		docModule = foundry.load('workspace')

		$rootScope.breadcum = 'Workspace'
		$scope.filename = ''
		$scope.current_edit = -1

		$scope.load = ()->
			$scope.projects = docModule.all_doc()

		$scope.is_loaded = (doc)->
			docModule.is_current(doc)

		$scope.add_document = ()->
			$scope.filename = ''
			# open modal
			ngDialog.open
				template: 'newfile'
				controller : @
				scope: $scope
			return

		$scope.create_doc = ()->
			# retrive file name
			ngDialog.close()
		
			spinner = $foundry.spinner(
				type : 'loading'
				text : 'Creating '+$scope.filename+'...'
			)
			docModule.create($scope.filename, (file)->
				if file.title is $scope.filename
					$scope.load()
					# ngDialog.close()
					spinner.hide()

					# switch to that doc
					for index,project of $scope.projects
						if file.id is project.id
							$scope.switch(index)
							return	
				
			)
			return

		$scope.edit = (index)->
			doc = $scope.projects[index]
			$scope.current_edit = index
			$scope.newname = doc.title
			ngDialog.open
				template: 'rename'
				scope: $scope
			return

		$scope.switch = (index)->
			$scope.current_doc = doc = $scope.projects[index]
			
			spinner = $foundry.spinner(
				type : 'loading'
				text : 'Switching...'
			)
			docModule.switch_callback = ()->
				$scope.load()
				spinner.hide()

			docModule.open(doc,()->
				
			)
			return

		$scope.rename = ()->
			doc = $scope.projects[$scope.current_edit]
			spinner = $foundry.spinner(
				type : 'loading'
				text : 'Renaming...'
			)
			ngDialog.close()

			docModule.rename(doc, $scope.newname, (file)->
				console.log file
				$scope.load()
				spinner.hide()
			)
			return

		$scope.delet_doc = (index)->
			doc = $scope.projects[index]
			docModule.del_doc(doc)
			return

		$scope.load()

		return
	])
