var Echo, Logs, Stats, echo, logs, stats;

Echo = require('./lib/echo');

Stats = require('./lib/stats');

Logs = require('./lib/logs');

stats = new Stats({}, {
  port: 8889,
  host: '0.0.0.0'
});

logs = new Logs();

echo = new Echo({
  port: 8888,
  host: '0.0.0.0'
}, stats, logs);

