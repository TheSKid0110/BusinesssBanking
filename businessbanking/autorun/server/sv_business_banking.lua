print("Server-side code loaded!")

util.AddNetworkString("BUSINESS_BANKING_GET_BALANCE")
util.AddNetworkString("BUSINESS_BANKING_SEND_BALANCE")
util.AddNetworkString("BUSINESS_BANKING_WITHDRAW")
util.AddNetworkString("BUSINESS_BANKING_DEPOSIT")
util.AddNetworkString("BUSINESS_BANKING_SEND_MONEY")

net.Receive("BUSINESS_BANKING_GET_BALANCE", function(len, ply)
    local playersBalance = ply:GetPData("BUSINESS_BANKING_BALANCE", 0)
    net.Start("BUSINESS_BANKING_SEND_BALANCE")
    net.WriteInt(playersBalance, 32)
    net.Send(ply)
end)

net.Receive("BUSINESS_BANKING_WITHDRAW", function(len, ply)
    local amount = net.ReadUInt(32)
    local playersBalance = ply:GetPData("BUSINESS_BANKING_BALANCE", 0)
    if tonumber(playersBalance) >= amount then
        ply:SetPData("BUSINESS_BANKING_BALANCE", playersBalance - amount)
        ply:addMoney(amount)
        net.Start("BUSINESS_BANKING_SEND_BALANCE")
        net.WriteInt(ply:GetPData("BUSINESS_BANKING_BALANCE", 0), 32)
        net.Send(ply)
    elseif tonumber(playersBalance) < amount then
        ply:ChatPrint("You do not have enough money to withdraw that amount.")
    end
end)

net.Receive("BUSINESS_BANKING_DEPOSIT", function(len, ply)
    local amount = net.ReadUInt(32)
    local playersBalance = ply:GetPData("BUSINESS_BANKING_BALANCE", 0)
    if ply:canAfford(amount) then
        ply:SetPData("BUSINESS_BANKING_BALANCE", playersBalance + amount)
        ply:addMoney(-amount)
        net.Start("BUSINESS_BANKING_SEND_BALANCE")
        net.WriteInt(ply:GetPData("BUSINESS_BANKING_BALANCE", 0), 32)
        net.Send(ply)
    elseif not ply:canAfford(amount) then
        ply:ChatPrint("You do not have enough money to deposit that amount.")
    end
end)

net.Receive("BUSINESS_BANKING_SEND_MONEY", function(len, ply)
    local amount = net.ReadUInt(32)
    local target = net.ReadEntity()
    local playersBalance = ply:GetPData("BUSINESS_BANKING_BALANCE", 0)
    if tonumber(playersBalance) >= amount then
        ply:SetPData("BUSINESS_BANKING_BALANCE", playersBalance - amount)
        target:SetPData("BUSINESS_BANKING_BALANCE", target:GetPData("BUSINESS_BANKING_BALANCE", 0) + amount)
        net.Start("BUSINESS_BANKING_SEND_BALANCE")
        net.WriteInt(ply:GetPData("BUSINESS_BANKING_BALANCE", 0), 32)
        net.Send(ply)
    elseif tonumber(playersBalance) < amount then
        ply:ChatPrint("You do not have enough money to send that amount.")
    end
end)

timer.Create("BUSINESS_BANKING_INTEREST", BUSINESS_BANKING.InterestTimer ,0, function()
    for _, ply in ipairs(player.GetAll()) do
        local playersBalance = ply:GetPData("BUSINESS_BANKING_BALANCE", 0)
        ply:SetPData("BUSINESS_BANKING_BALANCE", playersBalance + (playersBalance * BUSINESS_BANKING["InterestRate"]))
        ply:ChatPrint("You have received interest on your bank balance.")
    end


end)
