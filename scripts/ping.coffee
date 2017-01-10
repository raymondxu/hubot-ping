module.exports = (robot) ->
  robot.hear /@ping (.*)/i, (res) ->
    target = res.match[1]
    if "@" in target
      res.send "Ping for #{target} detected"
    else
      res.send "Target?"

module.exports = (robot) ->
  robot.hear /\b@mypings\b/i, (res) ->
    res.reply "Here are your outgoing pings"
