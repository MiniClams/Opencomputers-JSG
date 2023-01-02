event = require("event")
c = require("component")
sg = c.stargate

loop = true

print("Enter Name To Save As: ")
name = io.read()
file = io.open("address/"..name, "w")
print("Dial Gate Using DHD")

chevron = event.listen("stargate_dhd_chevron_engaged", function(envname, address, caller, symbolCount, lock, symbolName)
  file:write(":"..symbolName..":")
  print(symbolName)
end)

active = event.listen("stargate_wormhole_stabilized", function(envname, address, caller, isInitiating)
  print("Connection Stabilized")
  if isInitiating then
    print("Connection is outgoing, address saved")
    event.cancel(chevron)
    event.cancel(active)
    event.cancel(error)
    file:close()
    loop = false
  else
    print("Connection is incoming, aborting save")
    file:close()
    filesystem.remove("/home/address/"..name)
    event.cancel(chevron)
    event.cancel(active)
    event.cancel(error)
    loop = false
  end
end)

error = event.listen("stargate_failed", function(envname, address, caller, reason)
  print("Stargate Failed to Dial Address for Reason: ")
  print(reason)
  print("Aborting Save")
  file:close()
  filesystem.remove("/home/address/"..name)
  event.cancel(chevron)
  event.cancel(active)
  event.cancel(error)
  loop = false
end)

while loop do os.sleep(0.1) end