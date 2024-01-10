--[[

GENERAL CONFIG

]]--

vkgivss = {}

-- Is giveaway is active
vkgivss.activate = true

-- VK token version
vkgivss.version = 5.10 -- версия токена

-- Giveaway expire day
vkgivss.dateto = {

    year  = 2020,
    month = 07,
    day   = 14,
    hour  = 02,
    min   = 20,

}

vkgivss.Prizes = {
 
    {
        prize = 'Cyberpunk 2077 + 2000 донат валюты',
        color = Color(212,47,47)
    },
    {
        prize = '1500 донат валюты',
        color = Color(235,212,45)
    },
    {
        prize = '1000 донат валюты',
        color = Color(174,45,235)
    },
    {
        prize = '800 донат валюты',
        color = Color(64,204,57)
    },
    {
        prize = '800 донат валюты',
        color = Color(64,204,57)
    },
    {
        prize = '800 донат валюты',
        color = Color(64,204,57)
    },
    {
        prize = '500 донат валюты',
        color = Color(125,133,125)
    },
    {
        prize = '500 донат валюты',
        color = Color(125,133,125)
    },
    {
        prize = '500 донат валюты',
        color = Color(125,133,125)
    },
    {
        prize = '500 донат валюты',
        color = Color(125,133,125)
    },

}

vkgivss.giveawayid = 'anlfirst' -- ID конкурса. ИЗМЕНЯТЬ ТОЛЬКО ПРИ НОВОМ КОНКУРСЕ

vkgivss.groupurl = 'vk.com/an1melife'

vkgivss.posturl = 'vk.com/an1melife?w=wall-167656439_1429'

vkgivss.groupid = '167656439'

vkgivss.postid = '1429' -- ID поста

vkgivss.information = [[
    Server N is holding a new contest dedicated to the project's birthday. Any server player can participate in it. To learn more and participate in the contest, click on the Participate button
]]

vkgivss.title = 'VK prize drawing' -- заголовок в меню

vkgivss.cycletime = 1800 -- время между сообщениями в чате

vkgivss.command = 'prizedrawing' -- команда для открытия меню БЕЗ ! или /

vkgivss.chatmessage = '' -- настраивается в auto_chatmessages.lua

vkgivss.giftfor = true -- подарок за участие

vkgivss.giftmoney = 5000 -- подарок 5000 за участие

--[[

CHAT MESSAGES CONFIG

]]--

-- Prefix in the chat
local PREFIX = {Color(158, 53, 210), "EWards | "}

-- Cycle in the chat
local cycle_time = vkgivss.cycletime

-- Color of a text in chat
local text = Color(245,245,245) -- цвет текста

-- Messages in the chat
local MESSAGES = {
	{Color(255, 200, 50), "A big prizedrawing is currently taking place in the VK group. ", text, "More information: ", Color(255,0,0), "!prizedrawing "},
}

-- Don't touch
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