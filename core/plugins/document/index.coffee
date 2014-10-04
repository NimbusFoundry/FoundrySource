define('document',(require)->
	doc_plugin=
		type : 'plugin'
		title : 'Document'
		anchor : '#/document'
		name : 'document'
		version : 1.0
		order : -10
		icon : 'icon-file'
		controller_scope : null
		init : ()->
			self = @
			# draft for document model
			# save the data into model or somewhere else

			name = 'Document'
			attributes = ["id", "title", "timestamp"]
			foundry.model(name, attributes,(model)->
				model.onUpdate((mode, obj, isLocal)->
					# recall all file function to start
					if mode is 'CREATE' and !isLocal
						self.all_file(()->

							# reload the controller scope from here 
							if self.controller_scope
								self.controller_scope.load()
								self.controller_scope.$apply()
							
						)
				)

				# retrive all file here only once
				self.all_file(()->
					foundry.initialized(self.name)
				)
			)
			
			# define controller
			define_controller()
			return
		all_file : (callback)->
			self = @
			if Nimbus.realtime.folder
				Nimbus.Client.GDrive.getMetadataList("'" + Nimbus.realtime.folder.binary_files.id + "' in parents", (data)->
					self._documents = window.create_object_dictionary(data.items)
					callback(data.items) if callback
					return
				)
			else
				return []

		upload_file : (file, callback)->
			Nimbus.Binary.upload_file(file,(f)->
				callback(f) if callback
			)

		delete_file : (doc, callback)->
			Nimbus.Client.GDrive.deleteFile(doc.id)
			delete this._documents[doc.id]
			# remove the model
			model = foundry._models.Document
			doc = model.findByAttribute('id', doc.id)
			doc.destroy() if doc

			if callback
				callback()

		get : (id)->
			return @_documents[id]
		# this should be used only for sync records
		set : (id, data)->
			if !@_documents[id]
				@_documents[id] = data

				model = foundry._models.Document
				doc = model.create(
					title : data.title
					id : data.id
					timestamp : new Date().getTime()
				)
				doc.save()
			return
			
)

define_controller = ()->
	angular.module('foundry').controller('DocumentController', ['$scope', '$rootScope', 'ngDialog', '$foundry', '$timeout', ($scope, $rootScope, ngDialog, $foundry, $timeout)->
		$rootScope.breadcum = 'Documents'
		file_module = foundry.load('document')

		# assign controller scope for later useaeg 
		file_module.controller_scope = $scope

		$scope.load = (callback)->

			$scope.files = file_module._documents
			callback() if callback
			return

		$scope.choosed_file = null
		
		$scope.upload_document = ()->
			spinner = $foundry.spinner(
				type : 'loading'
				text : 'Uploading '
			)
			Nimbus.Binary.upload_file($scope.choosed_file,(file)->
				# push this into documents
				file_module.set(file._file.id, file._file)

				$scope.choosed_file = null
				$scope.load()
				$scope.$apply()
				spinner.hide()
			)
			return

		$scope.delete_document = (file)->
			spinner = $foundry.spinner(
				type : 'loading'
				text : 'Deleteing...'
			)
			file_module.delete_file(file, ()->
				console.log 'deleting file'
				$timeout(()->
					$scope.load(()->
						spinner.hide()
					)
				,3000)
			)

		$scope.load()
		return
	])
