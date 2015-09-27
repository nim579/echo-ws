Echo  = require './src/echo'
Stats = require './src/stats'
Logs  = require './src/logs'

stats = new Stats {},
  port: 8889
  host: '0.0.0.0'

logs = new Logs()

echo = new Echo
  port: 8888
  host: '0.0.0.0'
, stats, logs

