surface.CreateFont("vk_inf", {size = 23, antialias = true, extended = true, font = "Montserrat Medium"})
surface.CreateFont("vk_hud", {size = 45, antialias = true, extended = true, font = "Montserrat SemiBold"})
surface.CreateFont("hud_subs", {size = 23, weight = 450, antialias = true, extended = true, font = "Montserrat Medium"})

vkdrawing = {}

local surface_GetTextureID = surface.GetTextureID
local Material = Material
local math_min = math.min
local math_Round = math.Round
local math_floor = math.floor
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectUV = surface.DrawTexturedRectUV
local surface_SetTexture = surface.SetTexture
local surface_DrawRect = surface.DrawRect

local tex_corner8 = surface_GetTextureID( "gui/corner8" )
local tex_corner16  = surface_GetTextureID( "gui/corner16" )
local tex_corner32  = surface_GetTextureID( "gui/corner32" )
local tex_corner64  = surface_GetTextureID( "gui/corner64" )
local tex_corner512 = surface_GetTextureID( "gui/corner512" )
local tex_white   = surface_GetTextureID( "vgui/white" )

function vkdrawing.drawTexturedRect_Borders(pos,bordersize,x,y,wide,tall,color)
    local gradient = Material( "gui/gradient", "smooth")
    if pos == 'right' then
      gradient = Material( "vgui/gradient-r", "smooth")
    elseif pos == 'top' then
      gradient = Material( "vgui/gradient-u", "smooth")
    elseif pos == 'bottom' then
      gradient = Material( "vgui/gradient-d", "smooth")
    end

    local bordersize = bordersize
    bordersize = math_min( math_Round( bordersize ), math_floor( wide / 2 ) )

    local tex = tex_corner8
    if ( bordersize > 8 ) then tex = tex_corner16 end
    if ( bordersize > 16 ) then tex = tex_corner32 end
    if ( bordersize > 32 ) then tex = tex_corner64 end
    if ( bordersize > 64 ) then tex = tex_corner512 end

    surface.SetDrawColor( color )
    surface.SetMaterial( gradient )
    if pos == 'left' or pos == 'right' then
      surface_DrawTexturedRect( x + bordersize, y, wide - bordersize * 2, tall )
    else
      surface_DrawTexturedRect( x, y+bordersize, wide, tall-bordersize*2 )
      end

    if pos == 'left' then
      surface_DrawRect( x, y + bordersize, bordersize, tall - bordersize * 2 )
      surface_SetTexture( tex )
      surface_DrawTexturedRectUV( x, y, bordersize, bordersize, 0, 0, 1, 1 ) -- левый верхий
      surface_DrawTexturedRectUV( x, y + tall -bordersize, bordersize, bordersize, 0, 1, 1, 0 ) -- левый нижний
    elseif pos == 'right' then
      surface_DrawRect( x + wide - bordersize, y + bordersize, bordersize, tall - bordersize * 2 )
      surface_SetTexture( tex )
      surface_DrawTexturedRectUV( x + wide - bordersize, y, bordersize, bordersize, 1, 0, 0, 1 ) -- правый верхний
      surface_DrawTexturedRectUV( x + wide - bordersize, y + tall - bordersize, bordersize, bordersize, 1, 1, 0, 0 ) -- правый нижний 
    elseif pos == 'top' then
      surface_DrawRect( x+bordersize, y, wide-bordersize*2, bordersize )
      surface_SetTexture( tex )
      surface_DrawTexturedRectUV( x, y, bordersize, bordersize, 0, 0, 1, 1 )
      surface_DrawTexturedRectUV( x + wide - bordersize, y, bordersize, bordersize, 1, 0, 0, 1 )
    elseif pos == 'bottom' then
      surface_DrawRect( x+bordersize, y+tall-bordersize, wide-bordersize*2, bordersize )
      surface_SetTexture( tex )
      surface_DrawTexturedRectUV( x + wide - bordersize, y + tall - bordersize, bordersize, bordersize, 1, 1, 0, 0 )
      surface_DrawTexturedRectUV( x, y + tall -bordersize, bordersize, bordersize, 0, 1, 1, 0 )
    end
end

local gradient = Material( "vgui/gradient-l", "smooth")

function vkdrawing.drawBFGrad( x,y,w,h, color )
	surface.SetDrawColor( color )
	surface.SetMaterial( gradient )
	surface.DrawTexturedRectUV( x,y,w,h, 0, 0, 1, 1 )
end

local blur = Material("pp/blurscreen")
function vkdrawing.drawBDBlur(panel, amount) --Panel blur function
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 6 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end
end