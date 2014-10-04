# this is plugin for admin sdk
# targeted to get the info related with 
# certain domain

define('core/admin', ()->

	admin_base_url = 'https://apps-apis.google.com/a/feeds/domain/2.0/'

	authAdmin = ()->
		# using the scope or other things


	getUserCount = (domain, callback)->

		des = admin_base_url + domain.name + '/general/currentNumberOfUsers'

		$.ajax(
			url : des
			success : (data)->
				# get the result 
				console.log data
				callback(data) if callback
		)

	api = 
		get_user_count : (d, c)->
			getUserCount(d, c)
		auth : ()->
			# auth this
			console.log 'auth the api or not'

)