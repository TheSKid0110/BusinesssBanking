function BUSINESS_BANKING:OpenMenu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(100, 200)
    frame:Center()
    frame:SetTitle("Banking")
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
    end

    local balance = vgui.Create("DLabel", frame)
    net.Receive("BUSINESS_BANKING_SEND_BALANCE", function()
        local playerBalance = net.ReadInt(32)
        balance:SetText("Balance: " .. playerBalance)
        balance:SizeToContents()
        balance:SetPos(frame:GetWide() / 2 - balance:GetWide() / 2 - balance:GetTall() / 2, 50)
        
    end)

    --Replaced the basic button with a better looking one because it looks better--
    local close = vgui.Create("DButton", frame)
    close:SetSize(20, 20)
    close:SetPos(80, 0)
    close:SetText("X")
    close:SetTextColor(Color(255, 255, 255))
    close.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
    end
    close.DoClick = function()
        frame:Close()
    end
    -------------------------------------------------------------------------------
    local deposit = vgui.Create("DButton", frame)
    deposit:SetSize(50, 50)
    deposit:SetPos(0, 150)
    deposit:SetText("Deposit")
    deposit:SetTextColor(Color(255, 255, 255))
    deposit.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0))
    end
    deposit.DoClick = function()
        BUSINESS_BANKING:Deposit()
    end

    local withdraw = vgui.Create("DButton", frame)
    withdraw:SetSize(50, 50)
    withdraw:SetPos(50, 150)
    withdraw:SetText("Withdraw")
    withdraw:SetTextColor(Color(255, 255, 255))
    withdraw.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
    end
    withdraw.DoClick = function()
        BUSINESS_BANKING:Withdraw()
    end

    
end



function BUSINESS_BANKING:Deposit()
    local dInput = vgui.Create("DTextEntry")
    dInput:SetSize(100, 20)
    dInput:Center()
    dInput:SetPlaceholderText("Amount")
    dInput:MakePopup()
    dInput.OnEnter = function()
        local amount = dInput:GetValue()
        net.Start("BUSINESS_BANKING_DEPOSIT")
        net.WriteUInt(amount, 32)
        net.SendToServer()
        dInput:Remove()
    end
end

function BUSINESS_BANKING:Withdraw()
    local wInput = vgui.Create("DTextEntry")
    wInput:SetSize(100, 20)
    wInput:Center()
    wInput:SetPlaceholderText("Amount")
    wInput:MakePopup()
    wInput.OnEnter = function()
        local amount = wInput:GetValue()
        net.Start("BUSINESS_BANKING_WITHDRAW")
        net.WriteUInt(amount, 32)
        net.SendToServer()
        wInput:Remove()
    end
end

hook.Add("OnPlayerChat", "BUSINESS_BANKING:OpenMenu", function(ply, text)
    if string.lower(text) == "!bank" then
        net.Start("BUSINESS_BANKING_GET_BALANCE")
        net.SendToServer()
        BUSINESS_BANKING:OpenMenu()
    end
end)

