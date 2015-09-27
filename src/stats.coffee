WS       = require('ws').Server
_        = require 'underscore'
Backbone = require 'backbone'
Logs     = require './logs'

class Stats extends Backbone.Model
    defaults:
        connections_count: 0
        messages_count: 0
        max_connections: 0
        messages: []

    initialize: (data, @options)->
        @logs = new Logs()
        @_ws = new WS port: @options.port, host: @options.host

        @_ws.on 'connection', (client)=>
            @send client

        @on 'change', @update
        @bindExit()

    bindExit: ->
        exit = =>
            @logStat()
            process.removeAllListeners 'SIGINT'
            process.removeAllListeners 'SIGTERM'
            process.exit()

        process.on 'SIGINT', exit
        process.on 'SIGTERM', exit

    connect: ->
        connections = @get('connections_count') + 1
        max_connections = @get 'max_connections'
        @set 'connections_count', connections

        if max_connections < connections
            @set 'max_connections', connections

    disconnect: ->
        connections = @get('connections_count') - 1
        @set 'connections_count', connections

    message: (text)->
        messages = @get('messages_count') + 1
        @get('messages').push text
        @set 'messages_count', messages

    update: ->
        data = @toJSON()

        @_ws.clients.forEach (client)->
            client.send JSON.stringify data

    send: (client)->
        data = @toJSON()
        client.send JSON.stringify data

    logStat: ->
        data = @toJSON()
        @logs.log JSON.stringify _.omit data, 'messages'

module.exports = Stats
