# this file is for analytic tracking
# 
define('core/analytic', ()->
	
	# baseUrl =  "http://www.google-analytics.com/collect?v=1&tid=UA-46950334-2&cid=001"
	init = ()->
		ga('create', 'UA-55223184-1', { 'userId': foundry._current_user.email });
		# ga('set', '&uid', foundry._current_user.email); # Set the user ID using signed-in user_id.
		ga('require', 'displayfeatures');
		ga('set', 'dimension1', foundry._current_user.email);
		ga('set', 'dimension2', Nimbus.realtime.c_file.title);
		ga('set', 'dimension3', Nimbus.realtime.c_file.owners[0].emailAddress+':'+Nimbus.realtime.c_file.owners[0].displayName);

		# count user 
		count = foundry._models.User.all()
		ga('set', 'dimension4', count);

		ga('send', 'pageview');
		
	# get the space count for current user = (data)->
	get_owner_space_count = ()->
		count = 0
		for space in Nimbus.realtime.app_files
			if space.owners[0].permissionId is foundry._current_user.id
				count++

		count

	# priate property and settings
	send_owner_event = (data)->
		return if !ga
		# check how many workspace belongs to this user
		count = get_owner_space_count()		

		# send create space event
		ga('send', 'event', 'forum_owner_operation:'+data.email, 'create_workspace:'+data.name, count)

	# send add user event
	send_user_event = (data)->
		return if !ga
		# get user count
		count = foundry._models.User.all().length

		ga('send', 'event', 'forum_owner_operation:'+data.email, 'share_workspace:'+data.user, count)

	# private methods

	send_login_event = (data)->

		# check if this is the owner 

		
		# and the time he logins


	api = 
		init : ()->
			# setup the track
			init()

		owner : (data)->
			# send the owner operation and his space count
			send_owner_event(data)

		user : (data)->
			# track the user in a workspace
			send_user_event(data)

		login : (data)->
			# send login event
			send_login_event(data)
)