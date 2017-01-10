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

  robot.hear /@ping list\b/i, (res) ->
    sender = res.message.user.name
    ping_log = robot.brain.get(sender)
    if ping_log
      res.reply "Here are your outgoing pings:"
      for i, log of ping_log
        res.reply "(" + i + ") " + log
    else
      res.reply "No outgoing pings found for you #{sender}."

  robot.hear /@ping close (\d+)(( \d*)*)/i, (res) ->
    words = res.match[0].split(" ")
    close_indices = []
    for i, word of words
      if i >= 2 and word
        close_indices.push(word)
    res.reply close_indices
