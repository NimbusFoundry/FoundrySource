angular.module('foundry-ui').filter('utc_date', ()->
	(input, format)->
		out = new Date(input)
		out = out.toDateString()
		out
)