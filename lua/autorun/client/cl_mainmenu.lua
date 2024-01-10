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
        vkdrawing.drawBDBlur(self, 3)
        
		render.UpdateScreenEffectTexture()
      	draw.RoundedBox(8,0,0,w,h,Color(0,0,0,235))
      	draw.RoundedBox(8,0,0,w,30,Color(137,33,107))
      	vkdrawing.drawTexturedRect_Borders("right",8,0,0,w,30,Color(218,63,83))
      	draw.SimpleText(vkgivss.title,"hud_subs",10,3,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
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

concommand.Add("vk_giveaway", MainMenu)
net.Receive('vk_open_', MainMenu)