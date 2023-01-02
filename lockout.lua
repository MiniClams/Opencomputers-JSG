event = require("event")
c = require("component")
r = c.os_magreader
m = c.modem

r.setEventName("swipe")

loop = true

confirmation = "qaz-xsw-123"

activate = event.listen("swipe", function(evname, address, player, data)
  if data == confirmation then
    print("Shutdown activated by player: "..player)
    event.cancel(activate)
    loop = false
  else
    print("Activation by player: "..player)
    m.broadcast(6782, confirmation, data)
  end
end)

while loop do os.sleep(0.1) end