surface.CreateFont("vk_inf", {size = 23, antialias = true, extended = true, font = "Montserrat Medium"})
surface.CreateFont("vk_hud", {size = 45, antialias = true, extended = true, font = "Montserrat SemiBold"})

local function openpostchech()

  local vkid = net.ReadString()

  vkiding = vgui.Create("DFrame")
  vkiding:SetSize(500, 170)
  vkiding:Center()
  vkiding:MakePopup()
  vkiding:SetDraggable(false)
  vkiding:ShowCloseButton(false)
  vkiding:SetTitle("")
  vkiding.Paint = function(self,w,h)
      DrawBDBlur(self,2)
      render.UpdateScreenEffectTexture()
      draw.RoundedBox(8,0,0,w,h,Color(0,0,0,235))
      draw.RoundedBox(8,0,0,w,30,Color(137,33,107))
      surface.DrawTexturedRect_Borders("right",8,0,0,w,30,Color(218,63,83))
      draw.SimpleText(vkgivss.title,"hud_subs",10,3,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
      draw.SimpleText('А теперь посавьте лайк и сделайте репост',"hud_subs",w/2,40,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
  end 

  local mainpanel_closee = vgui.Create( "DButton", vkiding )
  mainpanel_closee:SetSize( 30, 30 )
  mainpanel_closee:SetPos( vkiding:GetWide() - 30,0 )
  mainpanel_closee:SetText( "" )
  mainpanel_closee:SetTextColor( Color( 255, 255, 255 ) )
  mainpanel_closee.Paint = function(self,w,h)
    draw.RoundedBox(8,0,0,w,h,Color(220, 20, 60,230))
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawLine( 7,7,22,22) 
    surface.DrawLine( 7,22,22,7)
  end
  mainpanel_closee.DoClick = function()
    vkiding:Remove()   
  end

  --local vk_ = vgui.Create("DLabel", vkiding)
  --vk_:SetFont('hud_subs')
  --vk_:SetText('А теперь посавьте лайк и сделайте репост\nэтой записи')
  --vk_:SizeToContents()
  --vk_:SetPos(vkiding:GetWide()/2-vk_:GetTextSize()/2,40)
  --vk_:SetColor(color_white)

  local vk_s_ = vgui.Create("DLabel", vkiding)
  vk_s_:SetFont('hud_subs')
  vk_s_:SetText(vkgivss.posturl)
  vk_s_:SizeToContents()
  vk_s_:SetPos(vkiding:GetWide()/2-vk_s_:GetTextSize()/2,70)
  vk_s_:SetColor(color_white)
	vk_s_:SetTooltip("Скопировать ссылку")
	vk_s_:SetMouseInputEnabled(true)
	function vk_s_:OnMousePressed(mcode)
    SetClipboardText(vkgivss.posturl)
    gui.OpenURL('https://'..vkgivss.posturl)
  end

  local btn = vgui.Create('XeninUI.ButtonV2', vkiding)
  btn:SetSize(150,40)
  btn:SetPos(vkiding:GetWide()/2-btn:GetWide()/2,vkiding:GetTall()-60)
  btn:SetRoundness( 2 )
  btn:SetText('Проверить')
  btn:SetYOffset( -2 )
  btn:SetGradient( true )
  btn.DoClick = function()
    net.Start('vk_check_repost')
      net.WriteString(vkid)
    net.SendToServer()
  end

end

net.Receive('vk_open_post_m', openpostchech)

local function check_vk_sub()

  vkidin = vgui.Create("DFrame")
  vkidin:SetSize(500, 250)
  vkidin:Center()
  vkidin:MakePopup()
  vkidin:SetDraggable(false)
  vkidin:ShowCloseButton(false)
  vkidin:SetTitle("")
  vkidin.Paint = function(self,w,h)
      DrawBDBlur(self,2)
      render.UpdateScreenEffectTexture()
      draw.RoundedBox(8,0,0,w,h,Color(0,0,0,235))
      draw.RoundedBox(8,0,0,w,30,Color(137,33,107))
      surface.DrawTexturedRect_Borders("right",8,0,0,w,30,Color(218,63,83))
      draw.SimpleText(vkgivss.title,"hud_subs",10,3,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
  end

  local mainpanel_closee = vgui.Create( "DButton", vkidin )
  mainpanel_closee:SetSize( 30, 30 )
  mainpanel_closee:SetPos( vkidin:GetWide() - 30,0 )
  mainpanel_closee:SetText( "" )
  mainpanel_closee:SetTextColor( Color( 255, 255, 255 ) )
  mainpanel_closee.Paint = function(self,w,h)
    draw.RoundedBox(8,0,0,w,h,Color(220, 20, 60,230))
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawLine( 7,7,22,22) 
    surface.DrawLine( 7,22,22,7)
  end
  mainpanel_closee.DoClick = function()
    vkidin:Remove()   
  end

  local vk_ = vgui.Create("DLabel", vkidin)
  vk_:SetFont('hud_subs')
  vk_:SetText('Для начала подпишитесь на нашу группу ВК')
  vk_:SizeToContents()
  vk_:SetPos(vkidin:GetWide()/2-vk_:GetTextSize()/2,40)
  vk_:SetColor(color_white)

  local vk__ = vgui.Create("DLabel", vkidin)
  vk__:SetFont('hud_subs')
  vk__:SetText('и введите ссылку на свой профиль ВК') 
  vk__:SizeToContents()
  vk__:SetPos(vkidin:GetWide()/2-vk__:GetTextSize()/2,65)
  vk__:SetColor(color_white)

  local vk_s_ = vgui.Create("DLabel", vkidin)
  vk_s_:SetFont('hud_subs')
  vk_s_:SetText(vkgivss.groupurl)
  vk_s_:SizeToContents()
  vk_s_:SetPos(vkidin:GetWide()/2-vk_s_:GetTextSize()/2,90)
  vk_s_:SetColor(color_white)
	vk_s_:SetTooltip("Скопировать ссылку")
	vk_s_:SetMouseInputEnabled(true)
	function vk_s_:OnMousePressed(mcode)
    SetClipboardText(vkgivss.groupurl)
    gui.OpenURL('https://'..vkgivss.groupurl)
  end
  
  local vk_en = vgui.Create("DTextEntry", vkidin)
  vk_en:SetSize(250,40)
  vk_en:SetPos(125,125)
  vk_en:SetValue( "vk.com/id00000" )
  vk_en.Paint = function(self,w,h)
    draw.RoundedBox(8,0,0,w,h,Color(30,30,30))
    self:DrawTextEntryText(Color(255, 255, 255), Color(120, 0, 120), Color(255, 255, 255))
  end
  vk_en:SetFont('scoreboard_inf')

  local btn = vgui.Create('XeninUI.ButtonV2', vkidin)
  btn:SetSize(150,40)
  btn:SetPos(vkidin:GetWide()/2-btn:GetWide()/2,vkidin:GetTall()-60)
  btn:SetRoundness( 2 )
  btn:SetText('Проверить')
  btn:SetYOffset( -2 )
  btn:SetGradient( true )
  btn.DoClick = function()
    if string.sub(vk_en:GetValue(),1,7) ~= 'vk.com/' then return LocalPlayer():ChatPrint('Неверный формат ссылки') end
    net.Start('vk_checklink')
      net.WriteString(vk_en:GetValue())
    net.SendToServer()
  end

end


local function vk_prizes(people)
  people = people or 'недоступно'
  local mainmenu = vgui.Create("DFrame")
  mainmenu:SetSize(768, 520)
  mainmenu:Center()
  mainmenu:MakePopup()
  mainmenu:SetDraggable(false)
  mainmenu:ShowCloseButton(false)
  mainmenu:SetTitle("")
  mainmenu.Paint = function(self,w,h)
      DrawBDBlur(self,2)
      render.UpdateScreenEffectTexture()
      draw.RoundedBox(8,0,0,w,h,Color(0,0,0,235))
      draw.RoundedBox(8,0,0,w,30,Color(137,33,107))
      surface.DrawTexturedRect_Borders("right",8,0,0,w,30,Color(218,63,83))
      draw.SimpleText(vkgivss.title,"hud_subs",10,3,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
      draw.SimpleText('До окончания: '..os.date( "%d дней %H часов %M минут" , os.time(vkgivss.dateto)-os.time() ),"hud_subs_big",w/2,40,HSVToColor(  ( CurTime() * 10 ) % 360, 1, 1 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
      draw.SimpleText('Участвует: '..people..' человек',"hud_subs_n",w/2,75,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
  end

  local mainpanel_closee = vgui.Create( "DButton", mainmenu )
  mainpanel_closee:SetSize( 30, 30 )
  mainpanel_closee:SetPos( mainmenu:GetWide() - 30,0 )
  mainpanel_closee:SetText( "" )
  mainpanel_closee:SetTextColor( Color( 255, 255, 255 ) )
  mainpanel_closee.Paint = function(self,w,h)
    draw.RoundedBox(8,0,0,w,h,Color(220, 20, 60,230))
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawLine( 7,7,22,22) 
    surface.DrawLine( 7,22,22,7)
  end
  mainpanel_closee.DoClick = function()
      mainmenu:Remove()   
  end

  for i=1, #vkgivss.Prizes do
    local pr_txt = i..' место: '..vkgivss.Prizes[i].prize
    --surface.SetFont('hud_subs_big')
    --local pr_txt_w = select(1, surface.GetTextSize(pr_txt))
    prize = vgui.Create('DLabel',mainmenu)
    prize:SetPos(15,80+30*i)
    prize:SetText(pr_txt)
    prize:SetFont('hud_subs_big')
    prize:SetColor( vkgivss.Prizes[i].color )
    prize:SizeToContents()
  end

  local btn = vgui.Create('XeninUI.ButtonV2', mainmenu)
  btn:SetSize(180,40)
  btn:SetPos(mainmenu:GetWide()/2-btn:GetWide()/2,mainmenu:GetTall()-60)
  btn:SetRoundness( 2 )
  btn:SetFont('hud_subs_n')
  btn:SetText('Участвовать')
  btn:SetYOffset( -2 )
  btn:SetGradient( true )
  btn.DoClick = function()
    check_vk_sub()
    mainmenu:Remove()  
  end

end

local function MainMenu()

    if !vkgivss.activate then return end

    local people = net.ReadString()

    local mainmenu = vgui.Create("DFrame")
    mainmenu:SetSize(500, 250)
    mainmenu:Center()
    mainmenu:MakePopup()
    mainmenu:SetDraggable(false)
    mainmenu:ShowCloseButton(false)
    mainmenu:SetTitle("")
    mainmenu.Paint = function(self,w,h)
		DrawBDBlur(self,2)
		render.UpdateScreenEffectTexture()
      	draw.RoundedBox(8,0,0,w,h,Color(0,0,0,235))
      	draw.RoundedBox(8,0,0,w,30,Color(137,33,107))
      	surface.DrawTexturedRect_Borders("right",8,0,0,w,30,Color(218,63,83))
      	draw.SimpleText(vkgivss.title,"hud_subs",10,3,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
    end

    --sound.PlayURL( "https://www.dropbox.com/s/tex1ymd03exz3dm/demonstrative.mp3?dl=1", "", function() end ) 

    

    local mainpanel_closee = vgui.Create( "DButton", mainmenu )
    mainpanel_closee:SetSize( 30, 30 )
    mainpanel_closee:SetPos( mainmenu:GetWide() - 30,0 )
    mainpanel_closee:SetText( "" )
    mainpanel_closee:SetTextColor( Color( 255, 255, 255 ) )
    mainpanel_closee.Paint = function(self,w,h)
      draw.RoundedBox(8,0,0,w,h,Color(220, 20, 60,230))
      surface.SetDrawColor( 255, 255, 255 )
      surface.DrawLine( 7,7,22,22) 
      surface.DrawLine( 7,22,22,7)
    end
    mainpanel_closee.DoClick = function()
        mainmenu:Remove()   
    end
    
    local btn = vgui.Create('XeninUI.ButtonV2', mainmenu)
    btn:SetSize(180,40)
    btn:SetPos(250-100,mainmenu:GetTall()-60)
    btn:SetRoundness( 2 )
    btn:SetText('Участвовать')
    btn:SetYOffset( -2 )
    btn:SetGradient( true )
    btn.DoClick = function()
      vk_prizes(people)
      mainmenu:Remove()  
    end

    local inf = vgui.Create("DFancyText", mainmenu)
    inf:SetPos(10,40)
    inf:SetSize(480,130)
    inf:SetFontInternal( "vk_inf" )
    inf:AppendText(vkgivss.information)
    inf:InsertColorChange( 255, 0, 0, 255 )
    inf:GotoTextEnd()
    inf:SetVerticalScrollbarEnabled(false)
	  inf:AppendFunc(function(h)
		local panel = vgui.Create( "AvatarImage" )
		panel:SetSize(0,0)
		panel:SetPlayer( LocalPlayer(), 16 )
		return {panel = panel, h = h, w = h}
	  end)

end

hook.Add("HUDPaint", "texsadfsdfasdf", function()

  if GetGlobalBool('results_giv_vk') then
    draw.SimpleText('Подводятся итоги конкурса', 'vk_hud', ScrW()/2,60, HSVToColor(  ( CurTime() * 35 ) % 360, 1, 1 ), TEXT_ALIGN_CENTER)
  end

end)

concommand.Add("vk_giveaway", MainMenu)

concommand.Add("vk_giveaway_credits", function() print('Система написана для проекта AnimeLife. Все права принадлежат автору enmanish (ciel) | vk.com/sss_okay') end)

local s = "giveaways/results/results.wav"

concommand.Add("vk_giveaway_sound", function() LocalPlayer():EmitSound(s) end)

net.Receive('vk_open_', MainMenu)

local function adminmenu()

  local total = vgui.Create("DFrame")
  total:SetSize(300, 110)
  total:Center()
  total:MakePopup()
  total:SetDraggable(false)
  total:ShowCloseButton(false)
  total:SetTitle("")
  total.Paint = function(self,w,h)
      DrawBDBlur(self,2)
      render.UpdateScreenEffectTexture()
      draw.RoundedBox(8,0,0,w,h,Color(0,0,0,235))
      draw.RoundedBox(8,0,0,w,30,Color(137,33,107))
      surface.DrawTexturedRect_Borders("right",8,0,0,w,30,Color(218,63,83))
      draw.SimpleText(vkgivss.title,"hud_subs",10,3,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
  end

  local mainpanel_closee = vgui.Create( "DButton", total )
  mainpanel_closee:SetSize( 30, 30 )
  mainpanel_closee:SetPos( total:GetWide() - 30,0 )
  mainpanel_closee:SetText( "" )
  mainpanel_closee:SetTextColor( Color( 255, 255, 255 ) )
  mainpanel_closee.Paint = function(self,w,h)
    draw.RoundedBox(8,0,0,w,h,Color(220, 20, 60,230))
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawLine( 7,7,22,22) 
    surface.DrawLine( 7,22,22,7)
  end
  mainpanel_closee.DoClick = function()
    total:Remove()   
  end

  local btn = vgui.Create('XeninUI.ButtonV2', total)
  btn:SetSize(150,40)
  btn:SetPos(total:GetWide()/2-btn:GetWide()/2,total:GetTall()-60)
  btn:SetRoundness( 2 )
  btn:SetText('Результаты')
  btn:SetYOffset( -2 )
  btn:SetGradient( true )
  btn.DoClick = function()
    net.Start('vk_results_get')
    net.SendToServer()
    LocalPlayer():ChatPrint('Результаты в консоле')
  end

end

net.Receive('vk_open_admin', adminmenu)

local function resultspanel()

  local results = net.ReadTable()

  local mainmenu = vgui.Create("DFrame")
  mainmenu:SetSize(768, 520)
  mainmenu:Center()
  mainmenu:MakePopup()
  mainmenu:SetDraggable(false)
  mainmenu:ShowCloseButton(false)
  mainmenu:SetTitle("")
  mainmenu.Paint = function(self,w,h)
    DrawBDBlur(self,2)
    render.UpdateScreenEffectTexture()
    draw.RoundedBox(8,0,0,w,h,Color(0,0,0,235))
    draw.RoundedBox(8,0,0,w,30,Color(137,33,107))
    surface.DrawTexturedRect_Borders("right",8,0,0,w,30,Color(218,63,83))
    draw.SimpleText(vkgivss.title,"hud_subs",10,3,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
    draw.SimpleText('Нажмите на место (текст), чтобы скопировать данные',"hud_subs",10,40,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
  end

  local mainpanel_closee = vgui.Create( "DButton", mainmenu )
  mainpanel_closee:SetSize( 30, 30 )
  mainpanel_closee:SetPos( mainmenu:GetWide() - 30,0 )
  mainpanel_closee:SetText( "" )
  mainpanel_closee:SetTextColor( Color( 255, 255, 255 ) )
  mainpanel_closee.Paint = function(self,w,h)
    draw.RoundedBox(8,0,0,w,h,Color(220, 20, 60,230))
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawLine( 7,7,22,22) 
    surface.DrawLine( 7,22,22,7)
  end
  mainpanel_closee.DoClick = function()
    mainmenu:Remove()   
  end

  for i=1, #results do
    local pr_txt = i..' место: steamid: '..results[i].steamid..'    ВК: '..results[i].vkid
    prize = vgui.Create('DLabel',mainmenu)
    prize:SetPos(15,50+30*i)
    prize:SetText(pr_txt)
    prize:SetFont('hud_subs')
    prize:SetColor( color_white )
    prize:SizeToContents()
    prize:SetTooltip("Скопировать данные")
    prize:SetMouseInputEnabled(true)
    function prize:OnMousePressed(mcode)
      SetClipboardText('steamid: '..results[i].steamid..'    ВК: '..results[i].vkid)
    end
  end

end

net.Receive('open_results_panel', resultspanel)
