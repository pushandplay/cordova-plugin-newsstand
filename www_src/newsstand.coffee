argscheck = require 'cordova/argscheck'
channel = require 'cordova/channel'
utils = require 'cordova/utils'
exec = require 'cordova/exec'
cordova = require 'cordova'

channel.createSticky 'onCordovaInfoReady'
# Tell cordova channel to wait on the CordovaInfoReady event
channel.waitForInitialization 'onCordovaInfoReady'

Newsstand = () ->
	@

Newsstand::test = (successCallback, errorCallback) ->
	argscheck.checkArgs 'fF', 'Newsstand.test', arguments
	exec successCallback, errorCallback, "Newsstand", "test", []

module.exports = new Newsstand()