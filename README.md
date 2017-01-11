# hubot-ping

A script that tracks your outgoing pings on Slack, making sure you never forget any of your requests.

## Functionality
- All messages that begin with `@ping @mention` are automatically recorded into your ping log.
- View your ping log by typing `@ping log`, which will display all of your outgoing pings, sorted oldest-first.
- Re-ping by typing `@ping n`, which will repeat message `n` in the channel it was originally sent to and update its timestamp in your log.
- Close pings by typing `@ping close n`.

<b>Tip:</b> hubot-ping supports multiple re-pings and closes in the same command: `@ping 0 1 2` will close ping 0, 1, and 2.

## Development

```bash
cd hubot-ping
npm install
bin/hubot
```
