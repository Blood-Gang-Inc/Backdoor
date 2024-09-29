-- Plugin Setup
local toolbar = plugin:CreateToolbar("Script Importer")
local button = toolbar:CreateButton("Script Importer", "Automatically inserts import methods into scripts", "rbxassetid://4458901886")

-- Function to modify a script
local function modifyScript(script, method)
    local importStatement

    -- Determine the import method to use
    if method == "require" then
        importStatement = 'local myModule = require(123456789)' -- Replace with actual module ID
    elseif method == "getfenv" then
        importStatement = 'local myEnv = getfenv()' -- Example for getfenv
    elseif method == "loadstring" then
        importStatement = 'local myFunction = loadstring("print(\'Hello World\')")' -- Example for loadstring
    else
        return -- Exit if no valid method is selected
    end

    -- Check if the script already has the import statement
    if not script.Source:find(importStatement) then
        -- Insert the import statement at the bottom of the script
        script.Source = script.Source .. "\n" .. importStatement
    end
end

-- Function to handle script modification
local function onScriptOpened(script)
    -- Automatically modify the script with the chosen method (defaulting to require)
    modifyScript(script, "require") -- Change this to the desired method
end

-- Connect to ScriptEditorService
local ScriptEditorService = game:GetService("ScriptEditorService")
ScriptEditorService.TextDocumentDidOpen:Connect(onScriptOpened)

-- Plugin loaded silently without any print statements
