local chatbox = peripheral.find("chat_box")
local invbox = {peripheral.find("inventory_manager")}

local event, username, message, uuid, isHidden, messageUtf8
local tokens = {}
local whitelist = {} -- Add users here (e.g. {["Jeb_"]=1,["Notch"]=2}

local function main()
  while true do
    -- Tokenize message
    rs.setOutput("back", true)
    event, username, message, uuid, isHidden, messageUtf8 = os.pullEvent("chat")
    for token in string.gmatch(message, "%S+") do
      table.insert(tokens, token)
    end

    -- Check to see if it is a whitelisted user + a grid command
    if tokens[1]:lower() == "^grid" then
      print("hi user")
      if whitelist[username] then
        print("hi me")

        -- Check the command
        if tokens[2] then

        if tokens[2]:lower() == "trash" then
          print("Trash cmnd")
          if tokens[3] and tokens[4] then
            print("\\_ Inv check")
            for i, item in pairs(invbox[whitelist[username]].getItems()) do
              if item.name == "minecraft:"..table.concat(tokens, "_", 4):lower() then
                invbox[whitelist[username]].removeItemFromPlayer("right", {name=item.name, toslot=1, fromslot=item.slot, count=tonumber(tokens[3])})
                chatbox.sendMessageToPlayer("Removing "..item.displayName.." from inventory. :checkmark:",username,"Grid")
                break
              end
            end
          else
            if invbox[whitelist[username]].getItemInHand() then
              chatbox.sendMessageToPlayer("Removing "..invbox[whitelist[username]].getItemInHand().displayName.." from inventory. :checkmark:",username,"Grid")
              invbox[whitelist[username]].removeItemFromPlayer("right", {name=invbox[whitelist[username]].getItemInHand().name, toslot=1, fromslot=98, count=64})
            else
              chatbox.sendMessageToPlayer("No item to trash. :x:",username,"Grid")
            end
          end
        elseif tokens[2]:lower() == "echo" then
          chatbox.sendMessageToPlayer(table.concat(tokens, " ", 3),username,"Grid")
        elseif tokens[2]:lower() == "empty" then
          chatbox.sendMessageToPlayer("Emptying trash...",username,"Grid")
          rs.setOutput("back", false)
          sleep(8)
          rs.setOutput("back", true)
          chatbox.sendMessageToPlayer("Trash emptied! :checkmark:",username,"Grid")
        else
          chatbox.sendMessageToPlayer("Unknown command :x:",username,"Grid")
        end
        else
          chatbox.sendMessageToPlayer("Invalid arguments :x:",username,"Grid")
        end
      else
        chatbox.sendMessageToPlayer("Not permitted to use this Grid setup :x:",username,"Grid")
      end
    end
    tokens = {}
    sleep(0.2)
  end
end

main()
