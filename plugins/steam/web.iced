steam = require 'steam-login'
_ = require 'underscore'

checkAuth = (req, res, next) ->
	if req.isAuthenticated()
		return next()
	else
		req.session.redirectTo = req.path
		res.redirect '/login'

Mikuia.Web.use steam.middleware
	realm: 'http://dev.mikuia.tv'
	verify: 'http://dev.mikuia.tv/dashboard/plugins/steam/verify'
	apiKey: Mikuia.settings.plugins.steam.apiKey

Mikuia.Web.get '/dashboard/plugins/steam/auth', steam.authenticate(), (req, res) =>
	res.redirect '/dashboard/settings#steam'

Mikuia.Web.get '/dashboard/plugins/steam/verify', checkAuth, steam.verify(), (req, res) =>
	if req.steam?.steamid?
		Channel = new Mikuia.Models.Channel req.user.username
		await Channel.setSetting 'steam', 'steamId', req.steam.steamid, defer whatever

	res.redirect '/dashboard/settings#steam'