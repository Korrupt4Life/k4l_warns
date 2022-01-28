local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

local vRP = Proxy.getInterface("vRP")
local vRPclient = Tunnel.getInterface("vRP","K4LCore")

AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
	exports.ghmattimysql:execute("INSERT IGNORE INTO vrp_users(id,warn) VALUES(@user_id,@warn)", {['@user_id'] = user_id}, function(affected)
	end)
end)
function sendToDiscwarnK4L(title, message, footer)
    local embed = {}
    embed = {
        {
            ["color"] = 1, -- GREEN = 65280 --- RED = 16711680
            ["title"] = "**".. title .."**",
            ["description"] = "" .. message ..  "\nData **"..os.date("%x %X %p").."**",
            ["footer"] = {
                ["text"] = "Powered by K4L",
            },
        }
    }
    PerformHttpRequest('https://discord.com/api/webhooks/920392746982854667/uj6sviHQ0ErH7Xy0YFxoUy0gTkg_oWEM-4fxF--OafZFxtTvt9u6A-p5AcfxF18idTVR', 
    function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand("warns", function(source)
	user_id = vRP.getUserId({source})
    exports.ghmattimysql:execute('SELECT warn FROM vrp_users WHERE id = @user_id;', {['@user_id'] = user_id},function(pula, affected)
		vRPclient.notify(source,{"Ai <span style='color:red'>"..  pula[1].warn .." <span style='color:white'>warn(uri)"})
	end)
end)

local k4l_add_warn = {function(player,choice)
    local user_id = vRP.getUserId({player}) 
    vRP.prompt({player,"ID","",function(player,target_id) 
        if target_id ~= nil and target_id ~= "" then 
            vRP.prompt({player,"Motiv","",function(player,motiv)
                if motiv ~= nil and motiv ~="" then
                    exports.ghmattimysql:execute('UPDATE vrp_users SET warn = warn + 1 WHERE id = @target_id', {["target_id"] = target_id}, function(teapa) end)
                    exports.ghmattimysql:execute('SELECT * FROM vrp_users WHERE id = @target_id;', {['@target_id'] = target_id},function(date)
                    TriggerClientEvent("chatMessage", -1, "^4• ^0Adminul ^1"..GetPlayerName(player) .."^0 i-a dat ^4warn ^0lui ^1"..GetPlayerName(target_id).." ^0[ ^1"..(date[1].warn + 1).." ^0] ^4warn-uri ^0acumulate\nMotiv : ^4"..motiv.."")
                    sendToDiscwarnK4L("Admin Warn Logs","**"..GetPlayerName(player).."** [ **"..user_id.."** ] i-a dat warn lui **"..GetPlayerName(target_id).."** [ **"..target_id.."** ]\nMotiv **"..motiv.."**\nNumar warnuri : **"..(date[1].warn + 1).."**")
                        if (date[1].warn == 3) then
                        TriggerClientEvent("chatMessage", -1, "^4• ^1"..GetPlayerName(target_id).." ^0a acumulat^4 3 ^0warnuri si a primit^4 3 ^0zile ^4BAN")
                        vRP.ban({player,target_id,72,"Acumulare 3/3 warn"})
                        exports.ghmattimysql:execute('UPDATE vrp_users SET warn = warn - 3 WHERE id = @target_id', {["target_id"] = target_id}, function(eu)
                        end)
                        end
                end)
            else
        vRPclient.notify(source,{"Nu pus niciun <span style='color:red'>motiv"})
    end
end})
else
vRPclient.notify(source,{"Nu ai selectat niciun <span style='color:red'>ID"})
end
end})
end,"Adauga warn unui jucator"}

local k4l_rst_warn = {function(player,choice)
    local user_id = vRP.getUserId({player}) 
    vRP.prompt({player,"ID","",function(player,target_id) 
        if target_id ~= nil and target_id ~= "" then 
            exports.ghmattimysql:execute('SELECT * FROM vrp_users WHERE id = @target_id;', {['@target_id'] = target_id},function(date)
                    exports.ghmattimysql:execute('UPDATE vrp_users SET warn = 0 WHERE id = @target_id', {["target_id"] = target_id}, function(rows)
                    TriggerClientEvent("chatMessage", -1, "^4• ^0Adminul ^1"..GetPlayerName(player) .."^0 i-a resetat ^4warnurile ^0lui ^1"..GetPlayerName(target_id).." ^0[ ^1"..target_id.." ^0]")
                    sendToDiscwarnK4L("Admin Warn Logs","**"..GetPlayerName(player).."** [ **"..user_id.."** ] i-a resetat warnurile lui **"..GetPlayerName(target_id).."** [ **"..target_id.."** ]\nNumar warnuri : **"..(date[1].warn + 1).."**")
                    end)
                end)
else
vRPclient.notify(source,{"Nu ai selectat niciun <span style='color:red'>ID"})
end
end})
end,"Reseteaza warnurile unui jucator"}

local k4l_rmv_warn = {function(player,choice)
    local user_id = vRP.getUserId({player}) 
    vRP.prompt({player,"ID","",function(player,target_id) 
        if target_id ~= nil and target_id ~= "" then 
            exports.ghmattimysql:execute('SELECT * FROM vrp_users WHERE id = @target_id;', {['@target_id'] = target_id},function(date)
                    exports.ghmattimysql:execute('UPDATE vrp_users SET warn = warn - 1 WHERE id = @target_id', {["target_id"] = target_id}, function(rows)
                    TriggerClientEvent("chatMessage", -1, "^4• ^0Adminul ^1"..GetPlayerName(player) .."^0 i-a scos ^41 ^0warnurile lui ^1"..GetPlayerName(target_id).." ^0[ ^1"..target_id.." ^0]")
                    sendToDiscwarnK4L("Admin Warn Logs","**"..GetPlayerName(player).."** [ **"..user_id.."** ] i-a scos un warn lui **"..GetPlayerName(target_id).."** [ **"..target_id.."** ]\nNumar warnuri : **"..(date[1].warn - 1).."**")
                    end)
                end)
else
vRPclient.notify(source,{"Nu ai selectat niciun <span style='color:red'>ID"})
end
end})
end,"Scoate un warn unui jucator"}

vRP.registerMenuBuilder({"admin", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
      local choices = {}
      if vRP.isUserAdvancedStaff({user_id}) then
        choices["Warn Adaugare"] = k4l_add_warn
        choices["Warn Reset"] = k4l_rst_warn
        choices["Warn Scoatere"] = k4l_rmv_warn
      end
      add(choices)
    end
  end})