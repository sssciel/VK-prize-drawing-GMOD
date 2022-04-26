AddCSLuaFile()

local PREFIX = {Color(158, 53, 210), "EWards | "} -- префикс

local cycle_time = vkgivss.cycletime -- время цикла

local text = Color(245,245,245) -- цвет текста

local MESSAGES = {
	{Color(255, 200, 50), "Сейчас в группе ВК проходит большой конкурс. ", text, "Открыть конкурс: ", Color(255,0,0), "!конкурс "}, -- написано как (цвет, текст, цвет, текст и т.д.)
}

if (SERVER) then

	if !vkgivss.activate then return end
	util.AddNetworkString("AutoChatMessage")
	local curmsg = 1
	
	timer.Create("AutoChatMessages", cycle_time, 0, function()
		net.Start("AutoChatMessage")
			net.WriteUInt(curmsg, 16)
		net.Broadcast()

		curmsg = curmsg + 1
		if (curmsg > #MESSAGES) then
			curmsg = 1
		end
	end)
else
	net.Receive("AutoChatMessage", function()
		local t = {}
		table.Add(t, PREFIX)
		table.Add(t, MESSAGES[net.ReadUInt(16)])
		
		chat.AddText(unpack(t))
	end)
end