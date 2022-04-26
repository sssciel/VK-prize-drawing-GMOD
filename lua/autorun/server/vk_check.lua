local api = vk:Session("") -- свой личный ключ api
local apii = vk:Session("") -- сервисный ключ приложения вк

local function IntToBool(int)
    if int == 1 then
        return true
    else
        return false
    end
end

local PMETA = FindMetaTable("Player")

function PMETA:GetPData(name, default)
	name = Format( "%s[%s]", self:SteamID64(), name)
	local val = sql.QueryValue("SELECT value FROM playerpdata WHERE infoid = "..SQLStr(name).." LIMIT 1")

	return val or default
end

function PMETA:SetPData(name, value)
	name = Format("%s[%s]", self:SteamID64(), name)
	return sql.Query("REPLACE INTO playerpdata (infoid, value) VALUES ("..SQLStr(name)..", "..SQLStr(value).." )") ~= false
end

function PMETA:RemovePData(name)
	name = Format("%s[%s]", self:SteamID64(), name)
	return sql.Query("DELETE FROM playerpdata WHERE infoid = "..SQLStr(name)) ~= false
end

util.AddNetworkString('vk_checklink')
util.AddNetworkString('vk_check_repost')
util.AddNetworkString('vk_open_post_m')
util.AddNetworkString('vk_open_')
util.AddNetworkString('vk_open_admin')
util.AddNetworkString('vk_results_get')
util.AddNetworkString('open_results_panel')

local dirname = 'datap_'..vkgivss.giveawayid
local dirname1 = 'datap_'..vkgivss.giveawayid..'1'

if not file.Exists(dirname, "DATA") then
	file.CreateDir(dirname)
end

if not file.Exists(dirname1, "DATA") then
	file.CreateDir(dirname1)
end

net.Receive('vk_checklink', function(len,pl)

    local link = net.ReadString()

    --print('получил')

    if string.find(link,'/id') then
        local idp = link:sub(10)
        if !file.Exists(dirname..'/vk'..idp..'.txt', 'DATA') then
            api.groups.isMember{group_id = vkgivss.groupid, user_id = idp}:cb(function(res)
                if IntToBool(res.response) then
                    print(link.." подписался: "..res.response)
                    file.Write(dirname..'/vk'..idp..'.txt',pl:SteamID()..'/0')
                    pl:SetPData('vk'..vkgivss.giveawayid, idp)
                    pl:SendLua('vkidin:Remove()') 
                    net.Start('vk_open_post_m')
                    net.WriteString(idp)
                    net.Send(pl)
                else
                    DarkRP.notify(pl,1,4,'Кого вы обманываете?')
                end
            end)
        else
            local filestr = file.Read(dirname..'/vk'..idp..'.txt')
            local vk_ex = string.Explode( "/", filestr )
            if vk_ex[2] == 0 then
                local vk_pdata = pl:GetPData("vk"..vkgivss.giveawayid)
                print(vk_pdata)
                pl:SendLua('vkidin:Remove()') 
                net.Start('vk_open_post_m')
                net.WriteString(vk_pdata)
                net.Send(pl)
            else
                DarkRP.notify(pl,1,4,'Такой vk уже зарегистрирован')
            end
        end
    else
        local idp = link:sub(8)
        api.utils.resolveScreenName{screen_name = idp}:cb(function(res)
            local idpp = res.response.object_id
            if !file.Exists(dirname..'/vk'..idpp..'.txt', 'DATA') then
                api.groups.isMember{group_id = vkgivss.groupid, user_id = idpp}:cb(function(res)
                    if IntToBool(res.response) then
                        print(link.." подписался: "..res.response)
                        file.Write(dirname..'/vk'..idpp..'.txt',pl:SteamID()..'/0')
                        pl:SetPData('vk'..vkgivss.giveawayid, idpp)
                        pl:SendLua('vkidin:Remove()') 
                        net.Start('vk_open_post_m')
                        net.WriteString(idpp)
                        net.Send(pl)
                    else
                        DarkRP.notify(pl,1,4,'Кого вы обманываете?')
                    end
                end)
            else
                local filestr = file.Read(dirname..'/vk'..idpp..'.txt')
                local vk_ex = string.Explode( "/", filestr )
                local vk_pdata = pl:GetPData("vk"..vkgivss.giveawayid)
                print(vk_pdata)
                if vk_ex[2] == 0 then
                    pl:SendLua('vkidin:Remove()') 
                    net.Start('vk_open_post_m')
                    net.WriteString(vk_pdata)
                    net.Send(pl)
                else
                    DarkRP.notify(pl,1,4,'Такой vk уже зарегистрирован')
                end
            end
        end)          
    end
 
end)

net.Receive('vk_check_repost', function(len,pl)

    local vkid = net.ReadString()
    vkid = vkid:sub(1)
    local groupp = tostring(vkgivss.groupid)*-1

    apii.likes.getList{type = "post", owner_id = groupp, item_id = vkgivss.postid, filter = "copies", friends_only = 0}:cb(function(res)
        for i = 1, #res.response.items do
            if (tostring(res.response.items[i]) == tostring(vkid)) then 
                file.Write(dirname1..'/vk'..vkid..'.txt',pl:SteamID()..'/'..vkid)
                if file.Exists(dirname1..'/peoples.txt', "DATA") then
                    local peoples = tonumber(file.Read(dirname1..'/peoples.txt'))
                    file.Write(dirname1..'/peoples.txt',peoples+1)
                else
                    file.Write(dirname1..'/peoples.txt',1)
                end
                file.Write(dirname..'/vk'..vkid..'.txt',pl:SteamID()..'/1')
                DarkRP.notify(pl,1,4,'Вы теперь участвуете в конкурсе') 
                pl:SendLua('vkiding:Remove()') 
                if vkgivss.giftfor then
                    pl:addMoney(vkgivss.giftmoney)
                end
                for k,v in pairs(player.GetAll()) do    
                    DarkRP.talkToPerson(v, Color(139,0,139), "EWards |", Color(255,255,255), " В конкурсе теперь участвует: " .. pl:Nick())
                end
                break
            end
        end
    end)
    
end)

net.Receive('vk_results_get', function(len,pl)

    local files = {}
    local randfiles = {}

    for k,v in pairs( file.Find( dirname1.."/*.txt", "DATA" ) ) do
        if v == 'peoples.txt' then continue end
        print(v)
		local tosend = file.Read( dirname1.."/" .. v )
		local tbl = string.Explode( "/", tosend)

		local steamid = tbl[1]
        local vki = tbl[2]
        
        math.randomseed(os.clock()^5)

        table.insert( files, { steamid = steamid, vkid = vki } )

    end	

    math.randomseed(os.clock()^5)

    table.insert( randfiles, files[math.random(1, #files)])
    table.insert( randfiles, files[math.random(1, #files)])
    table.insert( randfiles, files[math.random(1, #files)])
    table.insert( randfiles, files[math.random(1, #files)]) 
    table.insert( randfiles, files[math.random(1, #files)]) 
    table.insert( randfiles, files[math.random(1, #files)]) 
    table.insert( randfiles, files[math.random(1, #files)]) 
    table.insert( randfiles, files[math.random(1, #files)]) 
    table.insert( randfiles, files[math.random(1, #files)]) 
    table.insert( randfiles, files[math.random(1, #files)]) 
    
    net.Start('open_results_panel') 
    net.WriteTable(randfiles)
    net.Send(pl)

    SetGlobalBool("results_giv_vk", true)
    timer.Simple( 10, function() SetGlobalBool("results_giv_vk", false) end )
    
    for i=1, #randfiles do
        local pr_txt = i..' место в конкурсе занял: SteamID: '..randfiles[i].steamid
        for k,v in pairs(player.GetAll()) do    
            DarkRP.talkToPerson(v, Color(139,0,139), "EWards |", Color(255,255,255), pr_txt)
            v:SendLua("RunConsoleCommand(\"vk_giveaway_sound\")")
        end
    end
	
end)

local function vk_openmenu( ply, text, public )
    if string.find(text, '^[!/]'..vkgivss.command) then
        net.Start('vk_open_')
        net.WriteString(file.Exists(dirname1..'/peoples.txt', "DATA") and file.Read(dirname1..'/peoples.txt') or 1)
        net.Send(ply)
		return ""
    end
end
hook.Add( "PlayerSay", "vk_openmenu", vk_openmenu )

local function vk_openadmin( ply, text, public )
    if string.find(text, '^[!/]тамада') then
        net.Start('vk_open_admin')
        --net.WriteString(file.Exists(dirname1..'/peoples.txt', "DATA") and file.Read(dirname1..'/peoples.txt') or 1)
        net.Send(ply)
		return ""
    end
end
hook.Add( "PlayerSay", "vk_openadmin", vk_openadmin )