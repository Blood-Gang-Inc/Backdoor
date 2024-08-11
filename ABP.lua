--[[
    ANTI-BACKDOOR V2 - Roblox Backdoor Protection (ABP)
        "Enhancing Security, Elevating Confidence — ABP: A Pinnacle of Digital Fortification."
    
    OVERVIEW:
    - This script fortifies game security through systematic detection and eradication of potential backdoors.
    - It meticulously scrutinizes suspicious modules and group memberships, acting as a stalwart guardian against unauthorized access.
    - Integrate this script as the cornerstone of your holistic security infrastructure.

    😊 CREDITS:
    - Original Creator: 4z#6666 (demonswith1n)
    - Publishers: Barney_thekid7
    - Date: 2022
    - Source - GitHub & Pastebin
 
    🛡️ MAY PROTECT YOU FROM:
    - Saz & RP Backdoor (Identifies a common backdoor tool used in exploiting Roblox games)
    - Common Backdoors (Recognizes frequently used backdoor module names) (Recommended to keep the list up-to-date)
    - Viruses (Targets malicious scripts jeopardizing game integrity)
    - New Backdoors (Adapts to emerging backdoor patterns)
    - Logging from Strange Scripts (Detects unexpected logging behavior)

    📝 IMPLEMENTATION NOTES:
    - Maintain the BackdoorModules list with regular updates to align with evolving backdoor patterns.
    - Regularly review and refine this script to proactively counteract emerging threats.
    - Vigilantly monitor game logs and player reports for any anomalous activities.
    - Consider augmenting security measures with obfuscation detection.

    📜 USAGE:
    - Seamlessly integrate this script into your game's ServerScriptService for continuous, unobtrusive monitoring.

    ❗ DISCLAIMERS:
    - While highly effective, no script guarantees absolute security; ongoing vigilance and regular updates are paramount.
    - Tailor the BackdoorModules and BackdoorGroups lists to suit the specifics of your unique context. (It will not be 100% accurate, there may be some false postives.)
]]

local ABP = {
    Webhook = "", -- Insert your webhook URL for notifications. (Recommended for monitoring, etc.)
    BackdoorModules = {"BackdoorModule", "Backdoor", "Virus", "Logs", "Loaded"},
    BackdoorGroups = {9821767}, -- Doesn't remove the backdoor itself, just prevents them from joining and using it.

    Reasons = {
        Group = {
            Member = "[ABP]: You've been detected to be in a potential backdoor group and as a result been kicked from this game.",
        },
        Asset = {
            Detected = "[ABP]: A script was removed detected by our systems. Name: "
        },
    }
}

local function SendWebhook(text)
    if game.HttpService.HttpEnabled == true then
        require(15383209609).Request(ABP.Webhook, text)
    end
end
SendWebhook("Welcome to ABP! 🥳 Your game is now fortified with ABP, enhancing security and elevating confidence.")

local function KickPlayer(player, reason)
    SendWebhook("[ABP]: A player was kicked detected by our systems. Name: ".. player.Name.. "Kicked!")
    player:Kick("[ABP]: Kicking player - " .. player.Name .. " - Reason: ", reason)
end
local function DeleteBackdoor(module)
    warn("[ABP]: Deleting suspicious module - " .. module.Name)
    SendWebhook("A script was removed detected by our systems. Name: ".. module.Name.. "Removed!")
    module:Destroy()
end

local function CheckForBackdoor(player)
    local function CheckModule(module)
        for _, backdoorModule in ipairs(ABP.BackdoorModules) do
            if string.find(string.lower(module.Name), string.lower(backdoorModule)) then
                return true
            end
        end
        return false
    end
    game.DescendantAdded:Connect(function(descendant)
        if CheckModule(descendant) == true then
            SendWebhook("Potential backdoor detected: " .. descendant:GetFullName())
            DeleteBackdoor(descendant)
        end
    end)
    local function scanScripts()
        local suspiciousKeywords = {"require", "getfenv", "loadstring"}
        local function containsSuspiciousKeyword(source)
            for _, keyword in ipairs(suspiciousKeywords) do
                if string.find(source, keyword) then
                    return true
                end
            end
            return false
        end
        for _, script in ipairs(game:GetDescendants()) do
            if script:IsA("Script") or script:IsA("LocalScript") or script:IsA("ModuleScript") then
                local success, source = pcall(function() return script.Source end)
                if success and containsSuspiciousKeyword(source) then
                    warn("Suspicious script found: " .. script:GetFullName())
                    SendWebhook("[ABP]: Suspicious script found: " .. script:GetFullName())
                end
            end
        end
    end
    game.DescendantRemoving:Connect(function(descendant)
        SendWebhook("Potential backdoor removed: " .. descendant:GetFullName())
    end)
    player.DescendantAdded:Connect(function(descendant)
        SendWebhook("[ABP]: Potential backdoor was added: " .. descendant:GetFullName())
        if CheckModule(descendant) == true then
            DeleteBackdoor(descendant)
        end
    end)
    local function CheckGroupMembership(player)
        for _, groupId in ipairs(ABP.BackdoorGroups) do
            if player:IsInGroup(groupId) then
                return true
            end
        end
        return false
    end
    for _, module in ipairs(game:GetService("ServerScriptService"):GetChildren()) do
        if module:IsA("ModuleScript") and CheckModule(module) then
            DeleteBackdoor(module)
        end
    end
    if CheckGroupMembership(player) == true then
        SendWebhook("A user has attempted to join the game in a blacklisted group! Profile: https://roblox.com/users/"..player.UserId.."/profile".. " https://roblox.com/games/"..game.PlaceId.. "Blocked!")
        KickPlayer(player, ABP.Reasons.Group.Member)
    end
end
game:GetService("RunService").Stepped:Connect(function()
    for _, player in ipairs(game.Players:GetPlayers()) do
        CheckForBackdoor(player)
    end
end)
