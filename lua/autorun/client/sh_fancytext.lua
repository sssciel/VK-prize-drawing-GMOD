-- author https://github.com/Herover/fancytext/
fText = {}
PANEL = {}
function PANEL:Init()

	self.sepwide = 18	-- We cant run surface.GetTextSize if the panel is made too early
	self.chartall = 18
	timer.Simple(0.5, function()	
		local wide, tall = surface.GetTextSize( " " )
		self.sepwide = wide
		self.chartall = tall
	end)
	self.lines = {}
	self.maxlines = false
	self.curwide = 0
	self.margin = 5
  
  self.maxwide = 0 --Max known curwide used
	
	self.fontInternal = false
	self.font = "ChatFont" --default font
	
	self.scroll = 0
	
	self.pnlCanvas 	= vgui.Create( "Panel", self )
	--self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.PerformLayout = function( pnl )
	self.pnlCanvas.OnMouseReleased = self.OnMouseReleased -- Inner element seems to block parent, bubble!
		self:_PerformLayout()
		self:InvalidateParent()
	
	end
	local me = self
	self.pnlCanvas.Paint = function()
		local color = Color(255, 255, 255, 255)
		local font = me.fontInternal or self.font
		local last_item = false
		if font then
			surface.SetFont( font )
		end
		local spacer, ctall = surface.GetTextSize( " " )
		me.sepwide = spacer
		me.chartall = ctall
		local liney = -ctall
		for l_n=1, #me.lines do
			l_v = me.lines[l_n]
			local lastx = 0
			if liney + 2*me.chartall > me.VBar:GetScroll() and liney + 2*me.chartall < me.VBar:GetScroll() + me:GetTall() + me.chartall then
				local h = 0
				local w = 0
				for i_n=1, #l_v do
					i_v = l_v[i_n]
					if i_v[1] == "text" then
						w = i_v[2].w
						h = i_v[2].h
						if last_item and last_item[1] == "text" then
							--lastx = lastx + spacer
						end
						self:PaintTextpart( i_v[2].text, font, lastx, liney + ctall, color )
					elseif i_v[1] == "image" then
						w = i_v[2].w
						h = i_v[2].h
						surface.SetMaterial( i_v[2].mat )
						surface.SetDrawColor(255,255,255,255)
						surface.DrawTexturedRect( lastx, liney + i_v[2].h, i_v[2].w, i_v[2].h )
					elseif i_v[1] == "textcolor" then
						color = i_v[2]
						w = 0
						h = 0
					elseif i_v[1] == "font" then
						spacer, ctall = surface.GetTextSize( " " )
						me.sepwide = spacer
						me.chartall = ctall
						font = i_v[2]
						w = 0
						h = 0
					elseif i_v[1] == "blank" then
						w = i_v[2].w
						h = i_v[2].h
					elseif i_v[1] == "panel" then
						w = i_v[2].w
						h = i_v[2].h
						i_v[2].panel:SetPos( lastx, liney + i_v[2].h )
						i_v[2].panel:SetVisible( true )
					end
					lastx = lastx + w
					last_item = i_v
				end
			else
				for i_n=1, #l_v do
					i_v = l_v[i_n]
					if i_v[1] == "panel" then 
						i_v[2].panel:SetVisible( false )
					elseif i_v[1] == "font" then
						spacer, ctall = surface.GetTextSize( " " )
						me.sepwide = spacer
						me.chartall = ctall
						font = i_v[2]
					elseif i_v[1] == "textcolor" then
						color = i_v[2]
					end
				end
			end
			--liney = liney + h
			liney = liney + me.chartall
		end
	end
	
	-- Create the scroll bar
	self.VBar = vgui.Create( "DVScrollBar", self )
	self.VBar:Dock( RIGHT )
	
end

function PANEL:Tick()

	

end

--[[---------------------------------------------------------
   Name: SizeToContents
-----------------------------------------------------------]]
function PANEL:SizeToContents()

	self:SetSize( self.pnlCanvas:GetSize() )
	
end

--[[---------------------------------------------------------
   Name: GetVBar
-----------------------------------------------------------]]
function PANEL:GetVBar()

	return self.VBar
	
end

--[[---------------------------------------------------------
   Name: GetCanvas
-----------------------------------------------------------]]
function PANEL:GetCanvas()

	return self.pnlCanvas

end

function PANEL:InnerWidth()

	return self:GetCanvas():GetWide()

end

function PANEL:GetContentWide()
  return self.maxwide
end

function PANEL:SetW(w)
  self:SetWide(w)
  self:GetCanvas():SetWide(w)
end

--[[---------------------------------------------------------
   Name: Rebuild
-----------------------------------------------------------]]
function PANEL:Rebuild()

	--self:GetCanvas():SizeToChildren( false, true )
		
	-- Although this behaviour isn't exactly implied, center vertically too
	if ( self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall() ) then

		self:GetCanvas():SetPos( 0, (self:GetTall()-self:GetCanvas():GetTall()) * 0.5 )
	end
	
end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:_PerformLayout()

	self.scroll = self.VBar:GetScroll()
	local vbarvisible = self.VBar:IsVisible()
	
	if self.PerformLayout then
		self:PerformLayout()
	end

	local Wide = self:GetWide()
	local YPos = 0
	
	--self:Rebuild()
	
	self.pnlCanvas:SetTall( #self.lines * self.chartall or 7 )
	
	self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
	YPos = self.VBar:GetOffset()
		
	--if ( self.VBar.Enabled ) then Wide = Wide - self.VBar:GetWide() end

	self.pnlCanvas:SetPos( 0, self.scroll )
	self.pnlCanvas:SetWide( Wide )
	
	--self:Rebuild()
	
	self.VBar:SetScroll( self.scroll )
	self.VBar:SetVisible( vbarvisible )
	--self.VBar:SetEnabled( vbarvisible )


end

--[[---------------------------------------------------------
   Name: OnMouseWheeled
-----------------------------------------------------------]]
function PANEL:OnMouseWheeled( dlta )

	return self.VBar:OnMouseWheeled( dlta )
	
end

--[[---------------------------------------------------------
   Name: OnVScroll
-----------------------------------------------------------]]
function PANEL:OnVScroll( iOffset )

	self.pnlCanvas:SetPos( 0, iOffset )
	
end

function PANEL:Clear()

	return self.pnlCanvas:Clear()

end

function PANEL:GotoTextEnd()

	self.VBar:SetScroll(self.pnlCanvas:GetTall())
	
end

function PANEL:SetVerticalScrollbarEnabled( bool )
	
	--if !bool then
	--	self.scroll = self.VBar:GetScroll()
	--end
	self.VBar:SetEnabled( bool )
	self.VBar:SetVisible( bool )
	--if bool then
	--	self.VBar:SetScroll( self.scroll )
	--end
end

function PANEL:SetFontInternal( font )

	self:InsertFontChange( font )
	self.fontInternal = font

end

function PANEL:AppendItem( item )
  if type(item) == "string" then
    return self:AppendText( item )
  end
	if self.maxlines and #self.lines > self.maxlines then
		--print("REMOVING")
		table.remove( self.lines, 1 )
	end
	local wide = item[2].w
	--print("sepwide",self.sepwide)
	--print("word",part,self.curwide, self.sepwide, wide, "<", self:GetWide(),self)
	if self.curwide + wide < self:GetWide() - self.margin*2 then
		--If above passes, theres enough room to add another word
		self.curwide = self.curwide + wide
		table.insert( self.lines[#self.lines], item )
    self.maxwide = math.max(self.curwide, self.maxwide)
	else
		--Otherwise add another line before inserting part
		--print("newline", part)
    table.insert(self.lines, {})
    self.maxwide = math.max(self.curwide, self.maxwide)
		self.curwide = wide
		table.insert( self.lines[#self.lines], item )
	end
	
	self:_PerformLayout()
  
end

function PANEL:AppendText( text )
	
	local etext = string.Explode("\n", text) --Split newlines in sections

	if self.fontInternal then
		surface.SetFont( self.fontInternal )
	else
		surface.SetFont( self.font )
	end
	for l,line in pairs(etext) do --Loop lines
		--print("line",line)
		local parts = string.Explode(" ", line) --Split spaces, perhaps find another way to split seperators
		for n,part in pairs(parts) do
			local wide, tall = surface.GetTextSize( part )
			if part != "" and part != " " then --I dont know why this is possible
				self:AppendItem( {"text", {text = part, w = wide, h = tall}} )
				self:AppendItem( {"blank", {w = 4, h = tall}} )
			end
		end
		if l != #etext then --Begin new line, except if it's the last line
      self.maxwide = math.max(self.curwide, self.maxwide)
			self.lines[#self.lines + 1] = {}
			self.curwide = 0
		end
	end
  
  self.maxwide = math.max(self.curwide, self.maxwide)
	
	self:_PerformLayout()
	
end

function PANEL:AppendImage( info )

	self:AppendItem( {"image", info} )
	self:_PerformLayout()

end

function PANEL:AppendFunc( fn )
	local info = fn(self.chartall)
	info.panel:SetParent( self.pnlCanvas )
	self.pnlCanvas:Add( info.panel )
	self:AppendItem( {"panel", info} )
end

function PANEL:InsertColorChange( r, g, b, a )
  if #self.lines == 0 then
    table.insert(self.lines, {})
  end
	table.insert(self.lines[#self.lines], {"textcolor", Color(r, g, b, a)})
end

function PANEL:InsertFontChange( font )
  if #self.lines == 0 then
    table.insert(self.lines, {})
  end
	table.insert(self.lines[#self.lines], {"font", font})
	surface.SetFont( font ) --Fixme: Needed to calc following text widths, causes side effects!
end

function PANEL:Paint( w, h )
	
end

function PANEL:PaintTextpart( text, font, x, y, colour )
	--draw.SimpleTextOutlined(text, font, x, y, colour, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0,0,0))
	--draw.SimpleText(text, font, x, y, colour)
	surface.SetFont( font )
	surface.SetTextPos( x, y )
	surface.SetTextColor( colour )
	surface.DrawText( text )
end

function PANEL:OnMouseReleased()
  
end

vgui.Register('DFancyText', PANEL)
