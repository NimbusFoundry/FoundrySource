
define('support', ()->
	name : 'support'
	title: 'Support'
	anchor: '#/support'
	type: 'plugin'
	icon: 'icon-info-sign'
	order: -15
	init: ()->
		foundry.initialized(@name)

	inited: ()->
		define_controller()
)

define_controller = ()->
	moduleName = 'foundry'
	if !foundry
		moduleName = 'foundry'

	angular.module(moduleName).controller('SupportController', ['$scope', '$foundry', ($scope, $foundry)->
		
		# default email
		defaultEmail = 'admin@nimbusfoundry.com'

		$scope.createTicket = ()->
			# add ticket
			msg = $scope.newTicket
			$scope.newTicket = ''
			emails = []

			if foundry.supportEmail
				emails = foundry.supportEmail.split(',')
			else
				emails.push('release@nimbusbase.com')
			
			Nimbus.Share.add_share_user_real(emails[0], (user)->
				console.log user
				data = 
					'id' : user.id
					'email': emails[0]
					'name' : user.name
					'role': 'Admin'
				foundry._user_list[user.id] = data if !foundry._user_list[user.id]
			)

			template = "<table style='border-collapse:collapse;width:100%;'>
				<tr>
					<td style='background: #1fa086;color: #fff;padding: 10px;border: 1px solid #1fa086;width:20%;border-bottom-color:#ddd;'>Workspace Name</td>
					<td style='border:1px solid #ddd; padding-left: 20px;'>#{Nimbus.realtime.c_file.title}</td>
				</tr>
				<tr>
					<td style='background: #1fa086;color: #fff;padding: 10px;border: 1px solid #1fa086;width:20%;border-bottom-color:#ddd;'>Workspace Owner</td>
					<td style='border:1px solid #ddd; padding-left: 20px;'>#{foundry._current_owner.email}</td>
				</tr>
				<tr>
					<td style='background: #1fa086;color: #fff;padding: 10px;border: 1px solid #1fa086;width:20%;border-bottom-color:#ddd;'>Support Subject</td>
					<td style='border:1px solid #ddd; padding-left: 20px;'>#{msg}</td>
				</tr>
			</table>"

			ccEmails = emails.slice(1).reduce((a, b)->
				s = ''
				if a
					s = "#{a}, '#{b.split('@')[0]}' <#{b}>" 
				else 
					s = "#{b.split('@')[0]}' <#{b}>"
				return s
			, '')
			# send email to admin
			$foundry.gmail('Forum Support', emails[0], template, ccEmails)

			# show notification
			$('#notification').slideDown().delay(3000).slideUp()
			return

	])
