--[[
    EN :
    Zombie Shelter v2.0 by Meiryi / Meika / Shiro / Shigure
    You SHOULD NOT edit / modify / reupload the codes, it includes editing gamemode's name
    If you have any problems, feel free to contact me on steam, thank you for reading this

    ZH-TW :
    夜襲生存戰 v2.0 by Meiryi  / Meika / Shiro / Shigure
    任何的修改是不被允許的 (包括模式的名稱)，有問題請在Steam上聯絡我, 謝謝!
    
    ZH-CN :
    昼夜求生 v2.0 by Meiryi  / Meika / Shiro / Shigure
    任何形式的编辑是不被允许的 (包括模式的名称), 若有问题请在Steam上联络我
]]

function ZShelter.GetFixedValue(inputNum) 
    local target = 0.016666
    return inputNum / (target / RealFrameTime())
end

function ZShelter.GetTextSize(font, text)
    surface.SetFont(font)
    return surface.GetTextSize(text)
end

function ZShelter.CreateImage(parent, x, y, w, h, image, color)
    if(!color) then color = color_white end
    local img = vgui.Create("DImage", parent)
        img:SetPos(x, y)
        img:SetSize(w, h)
        img:SetImage(image)
        img:SetImageColor(color)

    return img
end

function ZShelter.CreateFrame(parent, x, y, w, h, color)
    local panel = vgui.Create("DFrame", parent)
        panel:SetPos(x, y)
        panel:SetSize(w, h)
        panel:SetDraggable(false)
        panel:SetTitle("")
        panel:ShowCloseButton(false)
        panel.Paint = function()
            draw.RoundedBox(0, 0, 0, w, h, color)
        end
    return panel
end

function ZShelter.CreatePanelMat(parent, x, y, w, h, mat, color)
    local panel = vgui.Create("DPanel", parent)
        panel:SetPos(x, y)
        panel:SetSize(w, h)
        panel.Paint2x = function() end
        panel.Paint = function()
            surface.SetDrawColor(color.r, color.g, color.b, color.a)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(0, 0, w, h)
            panel.Paint2x()
        end
    return panel
end

function ZShelter.CreatePanel(parent, x, y, w, h, color, r)
    r = r || 0
    local panel = vgui.Create("DPanel", parent)
        panel:SetPos(x, y)
        panel:SetSize(w, h)
        panel.Paint = function()
            draw.RoundedBox(r, 0, 0, w, h, color)
        end
    return panel
end

function ZShelter.CreateLabel(parent, x, y, text, font, color, bg, bgcolor)
    local label = vgui.Create("DLabel", parent)
        label.oPos = Vector(x, y)
        label:SetPos(x, y)
        label:SetFont(font)
        label:SetText(text)
        label:SetColor(color)
        local w, h = ZShelter.GetTextSize(font, label:GetText())
        label:SetSize(w, h)

        label.CentHor = function()
            local w, h = ZShelter.GetTextSize(font, label:GetText())
            label:SetPos(label.oPos.x - w / 2, label.oPos.y)
            label:SetSize(w, h)
        end

        label.CentVer = function()
            local w, h = ZShelter.GetTextSize(font, label:GetText())
            label:SetPos(label.oPos.x, label.oPos.y - h / 2)
            label:SetSize(w, h)
        end

        label.CentPos = function()
            local w, h = ZShelter.GetTextSize(font, label:GetText())
            label:SetPos(label.oPos.x - w / 2, label.oPos.y - h / 2)
            label:SetSize(w, h)
        end

        label.UpdateText = function(text)
            label:SetText(text)
            local w, h = ZShelter.GetTextSize(font, label:GetText())
            label:SetSize(w, h)
        end

        if(bg) then
            label.oPaint = label.Paint
            label.Paint = function()
                draw.RoundedBox(0, 0, 0, label:GetWide(), label:GetTall(), bgcolor)
                label.oPaint(label)
            end
        end

    local tw, th = ZShelter.GetTextSize(font, label:GetText())
    return tw, th, label
end

function ZShelter.CreateScroll(parent, x, y, w, h, color)
    local frame = vgui.Create("DScrollPanel", parent)
    frame:SetPos(x, y)
    frame:SetSize(w, h)
    frame.Paint = function() draw.RoundedBox(0, 0, 0, w, h, color) end

    frame.ScrollAmount = ScreenScaleH(64) -- You can change it with returned panel object
    frame.Smoothing = 0.2

    frame.CurrrentScroll = 0
    frame.MaximumScroll = 0 -- Don't touch this value

    local DVBar = frame:GetVBar()
    local down = false
    local clr = 0

    DVBar:SetWide(ScreenScaleH(4))
    DVBar:SetX(DVBar:GetX() - DVBar:GetWide())

    DVBar.Think = function()
        frame.MaximumScroll = DVBar.CanvasSize
        if(down) then return end
        local dvscroll = DVBar:GetScroll()
        local step = frame.CurrrentScroll - dvscroll
        if(math.abs(step) > 1) then
            clr = 125
        end
        DVBar:SetScroll(dvscroll + ZShelter.GetFixedValue(step * frame.Smoothing))
    end

    function frame:OnMouseWheeled(delta)
        frame.CurrrentScroll = math.Clamp(frame.CurrrentScroll + frame.ScrollAmount * -delta, 0, frame.MaximumScroll)
    end

    function DVBar:Paint(drawW, drawH)
        draw.RoundedBox(0, 0, 0, drawW, drawH, Color(0, 0, 0, 150))
    end

    function DVBar.btnUp:Paint() return end
    function DVBar.btnDown:Paint() return end

    DVBar.btnGrip.oOnMousePressed = DVBar.btnGrip.OnMousePressed
    function DVBar.btnGrip.OnMousePressed(self, code)
        down = true
        DVBar.btnGrip.oOnMousePressed(self, code)
        frame.CurrrentScroll = DVBar:GetScroll()
    end
    DVBar.oOnMousePressed = DVBar.OnMousePressed
    function DVBar.OnMousePressed(self, code)
        down = true
        DVBar.oOnMousePressed(self, code)
    end

    function DVBar.btnGrip:Paint(drawW, drawH)
        local roundWide = drawW * 0.5
        if(DVBar.btnGrip:IsHovered()) then
            clr = math.Clamp(clr + ZShelter.GetFixedValue(8), 0, 80)
            if(input.IsMouseDown(107) && !down) then
                down = true
            end
        else
            clr = math.Clamp(clr - ZShelter.GetFixedValue(8), 0, 80)
        end

        if(down && !input.IsMouseDown(107)) then
            down = false
        end

        if(down) then
            frame.CurrrentScroll = DVBar:GetScroll()
            clr = 125
        end

        local _color = 130 + clr
        draw.RoundedBox(roundWide, 0, 0, drawW, drawH, Color(_color, _color, _color, 255))
    end
    return frame
end

function ZShelter.InvisButton(parent, x, y, w, h, func)
    local btn = vgui.Create("DButton", parent)
        btn:SetPos(x, y)
        btn:SetSize(w, h)
        btn:SetText("")
        btn.Paint = function() end
        btn.DoClick = func
        
        return btn
end

function ZShelter.CustomPopupMenu(parent, x, y, w, h, color)
    local menu = ZShelter.CreatePanel(nil, x, y, w, 1, color)
    menu:SetZPos(32766)
    menu:MakePopup()
    local removing = false
    local alpha = 0

    menu.TargetHeight = 0
    menu.CurrentTall = 1
    menu.AddOptions = function(opt, func)
        local btn = ZShelter.CreateButton(menu, 0, 0, menu:GetWide(), ScreenScaleH(16), opt, "ZShelter-ScoreboardPopupFont", Color(220, 220, 220, 255), Color(30, 30, 30, 255), function()
            removing = true
            func()
        end)
        btn:Dock(TOP)
        btn:DockMargin(0, 0, 0, ScreenScaleH(1))
        menu.TargetHeight = menu.TargetHeight + ScreenScaleH(17)
        btn.Alpha = 0
        btn.Paint = function()
            draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(30, 30, 30, 255))
            if(btn:IsHovered()) then
                btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(15), 0, 105)
            else
                btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(15), 0, 105)
            end
            draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(255, 255, 255, btn.Alpha))
        end
    end

    menu.Wait = true
    menu:SetAlpha(0)
    menu.Think = function()
        if(menu.Wait) then menu.Wait = false return end -- 1 Frame delay
        if(removing) then
            alpha = math.Clamp(alpha - ZShelter.GetFixedValue(15), 0, 255)
            menu.CurrentTall = math.Clamp(menu.CurrentTall - ZShelter.GetFixedValue(menu.CurrentTall * 0.25), 0, menu.TargetHeight)
        else
            alpha = math.Clamp(alpha + ZShelter.GetFixedValue(15), 0, 255)
            menu.CurrentTall = math.Clamp(menu.CurrentTall + ZShelter.GetFixedValue((menu.TargetHeight - menu.CurrentTall) * 0.25), 0, menu.TargetHeight)
        end
        if(!IsValid(parent) || !menu:HasFocus()) then
            removing = true
        end
        menu:SetTall(menu.CurrentTall)
        menu:SetAlpha(alpha)
        if(alpha <= 0 && removing) then
            menu:Remove()
        end
    end
    menu.Paint = function()
        draw.RoundedBox(0, 0, 0, menu:GetWide(), menu:GetTall(), color)
    end
    return menu
end

function ZShelter.CreateButton(parent, x, y, w, h, text, font, tcolor, bcolor, func, r)
    if(!r) then r = 0 end
    local b = vgui.Create("DButton", parent)
    b:SetPos(x, y)
    b:SetSize(w, h)
    b:SetText(text)
    b:SetFont(font)
    b:SetTextColor(tcolor)
    b.Paint = function() draw.RoundedBox(r, 0, 0, b:GetWide(), b:GetTall(), bcolor) end
    b.DoClick = func
    return b
end

function ZShelter.CircleAvatar(parent, x, y, w, h, player, resolution)
    local base = ZShelter.CreatePanel(parent, x, y, w, h, Color(30, 30, 30, 255))
    local av = base:Add("AvatarImage")
    local c = ZShelter.BuildCircle(base:GetWide() / 2, base:GetTall() / 2, base:GetWide() * 0.5)
    av:SetSize(w, h)
    av:SetPlayer(player, resolution)
    av:SetPaintedManually(true)
    base.Paint = function()
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilTestMask(0xFF)
        render.SetStencilWriteMask(0xFF)
        render.SetStencilReferenceValue(0x01)
        render.SetStencilCompareFunction(STENCIL_NEVER)
        render.SetStencilFailOperation(STENCIL_REPLACE)
        render.SetStencilZFailOperation(STENCIL_REPLACE)
        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawPoly(c)
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        av:PaintManual()
        render.SetStencilEnable(false)
    end
    return base
end

local circle_seg = 64
function ZShelter.BuildCircle(x, y, radius)
    local c = {}
    table.insert(c, {x = x, y = y})

    for i = 0, circle_seg do
        local a = math.rad(i / circle_seg * -360)
        table.insert(c, {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius
        })
    end

    local a = math.rad(0)
    table.insert(c, {
        x = x + math.sin(a) * radius,
        y = y + math.cos(a) * radius
    })
    return c
end

local blur = Material("pp/blurscreen")
function ZShelter.DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)
    for i = 1, 6 do
        blur:SetFloat("$blur", (i / 6) * amount)
        blur:Recompute()
        render.UpdateScreenEffectTexture()

        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
end

function ZShelter:DrawFilledCircle(x, y, radius, scl)
    local cir = {}
    local seg = 30
    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * (-360 * scl))
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end
    surface.DrawPoly( cir )
end

function ZShelter:CircleTimerAnimation(x, y, radius, thickness, t, color)
    draw.NoTexture()
    surface.SetDrawColor(color.r, color.g, color.b, color.a) -- Don't use Color(), it's slow af, check wiki

    render.ClearStencil()

    render.SetStencilEnable(true)
    render.SetStencilTestMask(0xFF)
    render.SetStencilWriteMask(0xFF)
    render.SetStencilReferenceValue(0x01)

    render.SetStencilCompareFunction(STENCIL_NEVER)
    render.SetStencilFailOperation(STENCIL_REPLACE)
    render.SetStencilZFailOperation(STENCIL_REPLACE)
    ZShelter:DrawFilledCircle(x, y, radius - thickness, 1)
    render.SetStencilCompareFunction(STENCIL_GREATER)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    ZShelter:DrawFilledCircle(x, y, radius, t)
    render.SetStencilEnable(false)
end