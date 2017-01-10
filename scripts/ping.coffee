module.exports = (robot) ->
  robot.hear /@ping (@.+)/i, (res) ->
    current_date = new Date()
    datetime =  "[" \
      + current_date.getDate() + "/" \
      + (current_date.getMonth() + 1) + "/" \
      + current_date.getFullYear() + " " \
      + current_date.getHours() + ":" \
      + current_date.getMinutes() + ":" \
      + current_date.getSeconds() \
      + "]"
    ping_entry = res.message.text + " " + datetime
    res.reply ping_entry

    sender = res.message.user.name
    sender_pings = robot.brain.get(sender)
    if not sender_pings
      sender_pings = []
    sender_pings.push(ping_entry)

    robot.brain.set sender, sender_pings
    res.reply "Ping saved."

  robot.hear /@ping log\b/i, (res) ->
    sender = res.message.user.name
    ping_log = robot.brain.get(sender)
    if ping_log and ping_log.length() > 0
      res.reply "Here are your outgoing pings:"
      for i, log of ping_log
        res.reply "(" + i + ") " + log
    else
      res.reply "No outgoing pings found for you #{sender}."

  robot.hear /@ping close (\d+)(( \d*)*)/i, (res) ->
    # Parse the message for the ping entries to close
    words = res.match[0].split(" ")
    close_indices = []
    for i, word of words
      if i >= 2 and word
        close_indices.push(word)

    # Remove the ping entries from the sender's log
    # Avoid complications by doing an index-exclusive clone
    sender = res.message.user.name
    ping_log = robot.brain.get(sender)
    new_ping_log = []
    for i, ping_entry of ping_log
      if i not in close_indices
        new_ping_log.push(ping_entry)
    robot.brain.set sender, new_ping_log
