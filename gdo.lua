event = require("event")
c = require("component")
sg = c.stargate

IDC = 1234

incoming = event.listen("stargate_open", function(one, two, init)
  if init == false then
    if sg.getIrisState() == "CLOSED" then
      print("Incoming Traveler, Iris Closed")
    else
      print("Incoming Traveler, closing Iris")
      sg.toggleIris()
    end
  end
end)

closing = event.listen("stargate_wormhole_closed_fully", function(one, two, init)
  if init == false then
    if sg.getIrisState() == "CLOSED" then
      print("Stargate Closed, Opening Iris...")
      sg.toggleIris()
    end
  end
end)

received_code = event.listen("received_code", function(one, two, three, code)
  if sg.getIrisState() == "CLOSED" then
    if code == IDC then
      sg.toggleIris()
      sg.sendMessageToIncoming("Shield is Down!")
      print("Correct IDC, lowering shield")
      loop = false
    else
      sg.sendMessageToIncoming("Shield is Up! Do not Proceed!")
    end
  else
    sg.sendMessageToIncoming("Shield is Down!")
    print("Notifying Shield is already down")
  end
end)