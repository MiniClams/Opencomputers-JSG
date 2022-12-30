event = require("event")
c = require("component")
sg = c.stargate

loop = true

local args = {...}

if args[1] then
  name = args[1]
else 
  print("Enter Location to Dial: ")
  name = io.read()
end
file = io.open("address/"..name, "r")

text = file:read("*all")
address = {}
i = 0
for glyph in string.gmatch(text, "%b::") do
  address[i] = glyph:sub(2, -2)
  i = i + 1
end

print(address[0])
sg.engageSymbol(address[0])

j = 1

locked = event.listen("stargate_spin_chevron_engaged", function()
  if j < i then
    print(address[j])
    sg.engageSymbol(address[j])
    j = j + 1
  else
    sg.engageGate()
  end
end)

active = event.listen("stargate_wormhole_stabilized", function(envname, address, caller, isInitiating)
  if isInitiating then
    print("Connection Stabilized")
    event.cancel(locked)
    event.cancel(active)
    event.cancel(error)
    event.cancel(red)
    file:close()
    loop = false
  end
end)

error = event.listen("stargate_failed", function(envname, address, caller, reason)
  print("Dialing Failed for Reason: "..reason)
  event.cancel(locked)
  event.cancel(active)
  event.cancel(error)
  event.cancel(red)
  file.close()
  loop = false
end)

red = event.listen("redstone_changed", function(evname, address, side, old, new)
  print("Dial Cancel Requested...")
  event.cancel(locked)
  event.cancel(active)
  event.cancel(error)
  event.cancel(red)
  file:close()
  loop = false
end)

while loop do os.sleep(0.1) end