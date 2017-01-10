# Description:
#   A script that tracks your outgoing pings on Slack.
#
# Commands:
#   @ping [@mention ...] ... - create a new ping
#   @ping log - view your outgoing pings
#   @ping close [n ...] - close pings identified by index number
#
# Author:
#   RaymondXu

class PingEntry
  constructor: (@msg, @timestamp, @channel) ->

  toString: ->
    return @msg + " [" + @timestamp + "]"

module.exports = (robot) ->
  # @ping [@mention ...] ... - create a new ping
  robot.hear /@ping (@.+)/i, (res) ->
    # Build ping entry
    currentDate = new Date()
    datetime = currentDate.getDate() + "/" \
      + (currentDate.getMonth() + 1) + "/" \
      + currentDate.getFullYear() + " " \
      + currentDate.getHours() + ":" \
      + currentDate.getMinutes() + ":" \
      + currentDate.getSeconds()
    pingEntry = new PingEntry res.message.text, datetime, res.channel

    # Store ping entry
    sender = res.message.user.name
    pingLog = robot.brain.get(sender)
    if not pingLog
      pingLog = []
    pingLog.push(pingEntry)

    robot.brain.set sender, pingLog
    res.reply "Ping saved."

  # @ping log - view your outgoing pings
  robot.hear /@ping log\b/i, (res) ->
    # Dump sender's ping log
    sender = res.message.user.name
    pingLog = robot.brain.get(sender)
    if pingLog and pingLog.length > 0
      res.reply "Here are your outgoing pings:"
      for i, log of pingLog
        res.reply "(" + i + ") " + log.toString()
    else
      res.reply "No outgoing pings found for you #{sender}."

  # @ping [n ...] - re-ping an old ping
  robot.hear /@ping (\d+)(( \d*)*)/i, (res) ->
    # Parse the message for the ping entries re-ping
    words = res.match[0].split(" ")
    pingIndices = []
    for i, word of words
      if i >= 1 and word
        pingIndices.push(word)

    # Re-ping
    sender = res.message.user.name
    pingLog = robot.brain.get(sender)
    for i, pingEntry of pingLog
      if i in pingIndices
        robot.messageRoom pingEntry.channel, "#{pingEntry.msg}"

  # @ping close [n ...] - close pings identified by index number
  robot.hear /@ping close (\d+)(( \d*)*)/i, (res) ->
    # Parse the message for the ping entries to close
    words = res.match[0].split(" ")
    closeIndices = []
    for i, word of words
      if i >= 2 and word
        closeIndices.push(word)

    # Remove the ping entries from the sender's log
    # Avoid complications by doing an index-exclusive copy
    sender = res.message.user.name
    pingLog = robot.brain.get(sender)
    newPingLog = []
    for i, pingEntry of pingLog
      if i not in closeIndices
        newPingLog.push(pingEntry)
    robot.brain.set sender, newPingLog
