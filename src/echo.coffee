WS = require('ws').Server
_  = require 'underscore'

class Echo
	defaults: ->
		return port: 8888, host: '0.0.0.0'

	constructor: (options={}, @stats, @logs)->
		@options = _.extend {}, @defaults(), options
		@connections = []

		@runSocket()

	runSocket: ->
		@_ws = new WS port: @options.port, host: @options.host
		@_ws.on 'connection', _.bind @onOpen, @

	onOpen: (ws_conn)->
		@connections.push ws_conn
		ws_conn.on 'close', =>
			@onClose ws_conn
			@stats?.disconnect()

		ws_conn.on 'message', (message)=>
			@echo ws_conn, message
			@stats?.message message
			@logs?.log message

		@stats?.connect()

	onClose: (conn)->
		@connections = _.without @connections, conn

	echo: (conn, message)->
		conn.send message

module.exports = Echo
