--author = animandan
--version = 1.0.0
--date = 2025-04-30

config = require("config") -- Load the config file
delayMultiplier = config.delayMultiplier -- Multiplier for the delay time for loading each piece of a preset.
presetLocation = config.presetLocation -- The location you want to save and load presets from.


local UEHelpers = require("UEHelpers")
local json = require("dkjson")


print("[RaceMenuUtilities] Mod loaded\n")

delayTime = 10*delayMultiplier

raceRowOrder = {
    Argonian = 1,
    Breton = 2,
    DarkElf = 3,
    HighElf = 4,
    Imperial = 5,
    Khajiit = 6,
    Nord = 7,
    Orc = 8,
    Redguard = 9,
    WoodElf = 10
}

RacesPtrArrayOrder = {
    DarkElf = 1,
    Imperial = 2,
    Argonian = 3,
    Breton = 4,
    Orc = 5,
    Redguard = 6,
    Nord = 7,
    WoodElf = 8,
    Khajiit = 9,
    HighElf = 10
}

function getPathFromFullName(fullName)
    if not fullName then
      print("Full name is nil")
      return nil
    end
    sep = "%s"
    local t = {}
    for str in string.gmatch(fullName, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
    return t[2]
  end



function getCharacterPhenotypeData()

    local VCharacterPhenotypeDatas = FindAllOf("VCharacterPhenotypeData")

    if not VCharacterPhenotypeDatas then
        print("No instances of 'VCharacterPhenotypeData' were found\n")
        return nil
    else
        for Index, VCharacterPhenotypeDataInstance in pairs(VCharacterPhenotypeDatas) do
            print(string.format("[%d] %s\n", Index, VCharacterPhenotypeDataInstance:GetFullName()))
            if VCharacterPhenotypeDataInstance:GetFullName():find("OblivionPlayerCharacter_C")
            then
                VCharacterPhenotypeData = VCharacterPhenotypeDataInstance
                print("Found instance of 'VCharacterPhenotypeData' in 'OblivionPlayerCharacter_C': " .. tostring(VCharacterPhenotypeData:GetFullName()) .. "\n")
                return VCharacterPhenotypeData
            end
        end
    end
    print("No instance of 'VCharacterPhenotypeData' in 'OblivionPlayerCharacter_C' was found.\n")
    return nil
end


function SaveCharacterData(name, description, author)
    local UVRaceSexMenuViewModelInstance = FindFirstOf("VRaceSexMenuViewModel") --UVRaceSexMenuViewModel
    if not UVRaceSexMenuViewModelInstance or not UVRaceSexMenuViewModelInstance:IsValid() then
        print("Invalid UVRaceSexMenuViewModelInstance provided.")
        return
    end

    local VCharacterPhenotypeData = getCharacterPhenotypeData()
    if not VCharacterPhenotypeData then
        print("No instance of 'VCharacterPhenotypeData' was found.\n")
        return
    end

    local data = {
        CurrentRace = UVRaceSexMenuViewModelInstance.CurrentRace:ToString(),
        CurrentSex = UVRaceSexMenuViewModelInstance.CurrentSex,
        CurrentArchetype = UVRaceSexMenuViewModelInstance.CurrentArchetype,
        MorphTargets = {},
        ColorTargets = {},
        CustomisationTargets = {}
    }

    -- Save MorphTargets
    UVRaceSexMenuViewModelInstance.PhenotypeData.MorphTargets:ForEach(function(key, value)
        data.MorphTargets[key:get():ToString()] = value:get()
    end)

    -- Save ColorTargets
    UVRaceSexMenuViewModelInstance.PhenotypeData.ColorTargets:ForEach(function(key, value)
        data.ColorTargets[key:get():ToString()] = {
            R = value:get().R,
            G = value:get().G,
            B = value:get().B,
            A = value:get().A
        }
    end)

    -- Save CustomisationTargets
    UVRaceSexMenuViewModelInstance.PhenotypeData.CustomisationTargets:ForEach(function(key, value)
        data.CustomisationTargets[key:get()] = value:get()
    end)


    --save EyeColor
    data.EyeMaterial = getPathFromFullName(VCharacterPhenotypeData.Eyematerial:GetFullName())
    data.CustomisationEyeMaterialIndex = VCharacterPhenotypeData.CustomisationEyeMaterialIndex

    --save Hair
    data.Hair = getPathFromFullName(VCharacterPhenotypeData.Hair:GetFullName())
    data.CustomisationHairIndex = VCharacterPhenotypeData.CustomisationHairIndex

    --save Mustache
    data.Mustache = getPathFromFullName(VCharacterPhenotypeData.Mustache:GetFullName())
    data.CustomisationMustacheIndex = VCharacterPhenotypeData.CustomisationMustacheIndex

    --save Beard
    data.Beard = getPathFromFullName(VCharacterPhenotypeData.Beard:GetFullName())
    data.CustomisationBeardIndex = VCharacterPhenotypeData.CustomisationBeardIndex

    data.Name = name
    data.Description = description
    data.Date = os.date("%Y-%m-%d %H:%M:%S")
    data.APIVersion = "v1"
    data.Author = author
    data.ModVersion = "1.0.0"
    data.ModName = "RaceMenuUtilities"
    data.ModCreator = "animandan"


    local filePath = presetLocation .. name .. ".json"

    -- Write to JSON file
    local file = io.open(filePath, "w")
    if file then
        local jsonData = json.encode(data, { indent = true }) -- Use dkjson's encode function
        file:write(jsonData)
        file:close()
        print("Character data saved to " .. filePath)
    else
        print("Failed to open file for writing: " .. filePath)
    end
end

function sleep(ms)
    local start = os.clock()
    while os.clock() - start < ms / 1000 do end
end

local function LoadCharacterData(name)
    local filePath = presetLocation .. name .. ".json"
    if not filePath then
        print("No file path provided.")
        return
    end
    print("File path: " .. filePath)
    local UVRaceSexMenuViewModelInstance = FindFirstOf("VRaceSexMenuViewModel") --UVRaceSexMenuViewModel
    if not UVRaceSexMenuViewModelInstance or not UVRaceSexMenuViewModelInstance:IsValid() then
        print("Invalid UVRaceSexMenuViewModelInstance provided.")
        return
    end
    print("Loading character data from " .. filePath)

    local file = io.open(filePath, "r")
    if not file then
        print("Failed to open file for reading: " .. filePath)
        return
    end

    local content = file:read("*a")
    file:close()

    local data, pos, err = json.decode(content, 1, nil)
    if err then
        print("Failed to decode JSON data: " .. err)
        return
    end

    sleep(delayTime) -- Wait for the character to update

    print("CurrentRace: " .. tostring(data.CurrentRace) .. "\n")
    local raceString = data.CurrentRace:gsub("%s+", "")
    print("raceString: " .. tostring(raceString) .. "\n")
    
    local racePtr = RacesPtrArrayOrder[raceString]
    print("racePtr: " .. tostring(racePtr) .. "\n")
    
    TESRacePtr = UVRaceSexMenuViewModelInstance.RacesPtrArray[RacesPtrArrayOrder[raceString]]
    if not TESRacePtr or not TESRacePtr:IsValid() then
        print("No instance of class 'TESRace' was found.\n")
        return
    end
    print("Instance of class 'TESRace' was found")
    print("TESRacePtr: " .. tostring(TESRacePtr:GetFullName()) .. "\n")
    
   sleep(delayTime) -- Wait for the character to update

    NewRaceDescription = FText("racemnuutilities")
    RaceIndex = raceRowOrder[raceString]
    print("RaceIndex: " .. tostring(RaceIndex) .. "\n")
    SexIndex = data.CurrentSex
    ArchetypeIndex = data.CurrentArchetype
    bUpdateCharacter = true

    ExecuteInGameThread(function()
        print("Updating RaceSexArchetype: " .. tostring(NewRaceDescription) .. ", " .. tostring(RaceIndex) .. ", " .. tostring(SexIndex) .. ", " .. tostring(ArchetypeIndex) .. ", " .. tostring(TESRacePtr) .. ", " .. tostring(bUpdateCharacter))
        UVRaceSexMenuViewModelInstance:UpdateRaceSexArchetype(NewRaceDescription, RaceIndex, SexIndex, ArchetypeIndex, TESRacePtr, bUpdateCharacter)
    end)
    
    sleep(delayTime*10) -- Wait for the character to update

    print("Applying EyeColor...")
    ExecuteInGameThread(function()
        print("Updating EyeColor: " .. tostring(data.EyeMaterial) .. " = " .. tostring(data.CustomisationEyeMaterialIndex))
        EyeMaterial = LoadAsset(data.EyeMaterial)
        print("EyeMaterial: " .. tostring(EyeMaterial:GetFullName()))
        UVRaceSexMenuViewModelInstance:UpdateEyeColor(EyeMaterial, data.CustomisationEyeMaterialIndex, true)
    end)
    print("EyeColor applied")
    
    sleep(delayTime) -- Wait for the character to update


    print("Applying Hair...")
    ExecuteInGameThread(function()
        print("Updating Hair: " .. tostring(data.Hair) .. " = " .. tostring(data.CustomisationHairIndex))
        Hair = LoadAsset(data.Hair)
        UVRaceSexMenuViewModelInstance:UpdateHair(Hair, data.CustomisationHairIndex, true)
    end)
    print("Hair applied")

    sleep(delayTime) -- Wait for the character to update

    
    print("Applying Beard...")
    ExecuteInGameThread(function()
        print("Updating Beard: " .. tostring(data.Beard) .. " = " .. tostring(data.CustomisationBeardIndex))
        Beard = LoadAsset(data.Beard)
        UVRaceSexMenuViewModelInstance:UpdateHair(Beard, data.CustomisationBeardIndex, true)
    end)
    print("Beard applied")

    sleep(delayTime) -- Wait for the character to update

    print("Applying Mustache...")
    ExecuteInGameThread(function()
        print("Updating Mustache: " .. tostring(data.Mustache) .. " = " .. tostring(data.CustomisationMustacheIndex))
        Mustache = LoadAsset(data.Mustache)
        UVRaceSexMenuViewModelInstance:UpdateHair(Mustache, data.CustomisationMustacheIndex, true)
    end)
    print("Mustache applied")

    sleep(delayTime) -- Wait for the character to update
    
    print("Applying MorphTargets...")
    for key, value in pairs(data.MorphTargets) do 
        sleep(delayTime) -- Wait for the character to update

        ExecuteInGameThread(function()
            print("Updating MorphTarget: " .. tostring(key) .. " = " .. tostring(value))
            keyFName = FName(key)
            if not keyFName then
                print("Failed to create FName from key: " .. tostring(key))
                return
            end
            UVRaceSexMenuViewModelInstance:UpdateMorphTarget(keyFName, value, true)
        end)
    end
    print("MorphTargets applied")

    sleep(delayTime) -- Wait for the character to update

    print("Applying ColorTargets...")
    for key, value in pairs(data.ColorTargets) do
        sleep(delayTime) -- Wait for the character to update
        ExecuteInGameThread(function()
            print("Updating ColorTarget: " .. tostring(key) .. " = " .. tostring(value.R) .. ", " .. tostring(value.G) .. ", " .. tostring(value.B) .. ", " .. tostring(value.A))
            keyFName = FName(key)
            if not keyFName then
                print("Failed to create FName from key: " .. tostring(key))
                return
            end
            local Fcolor = {}
            Fcolor.R = value.R
            Fcolor.G = value.G
            Fcolor.B = value.B
            Fcolor.A = value.A
            
            UVRaceSexMenuViewModelInstance:UpdateColorTarget(keyFName, Fcolor, true)
        end)
    end
    sleep(delayTime) -- Wait for the character to update

    print("ColorTargets applied")
    sleep(delayTime) -- Wait for the character to update


    print("Character data loaded from " .. filePath)
end

function printAndOutput(message, OutputDevice)
    print(string.format("[RaceMenuUtilities] %s\n",message))
    OutputDevice:Log(string.format("[RaceMenuUtilities] %s\n",message))
end

RegisterConsoleCommandHandler("rmu", function(FullCommand, Parameters, OutputDevice)
    -- ExecuteInGameThread(function()
            
        
        print("[RaceMenuUtilities] RegisterConsoleCommandHandler:\n")

        print(string.format("[RaceMenuUtilities] Command: %s\n", FullCommand))
        -- printAndOutput(string.format("Command: %s\n", FullCommand), OutputDevice)
        print(string.format("[RaceMenuUtilities] Number of parameters: %i\n", #Parameters))
        -- printAndOutput(string.format("Number of parameters: %i\n", #Parameters), OutputDevice)

        for ParameterNumber, Parameter in ipairs(Parameters) do
            print(string.format("[RaceMenuUtilities] Parameter #%i -> '%s'\n", ParameterNumber, Parameter))
        end


        if Parameters[1] == "save" then
            local name = Parameters[2]
            if not name then
                printAndOutput("No name provided", OutputDevice)
                return false
            end
            printAndOutput(string.format("Name: %s", name), OutputDevice)

            local description = Parameters[3]
            if not description then
                description = "No description provided"
            end
            printAndOutput(string.format("Description: %s\n", description), OutputDevice)

            local author = Parameters[4]
            if not author then
                author = "No author provided"
            end
            printAndOutput(string.format("Author: %s\n", author), OutputDevice)

            printAndOutput("Saving character data...\n", OutputDevice)
            ExecuteAsync(function()
                SaveCharacterData(name, description, author)
            end)
        elseif Parameters[1] == "load" then
            local name = Parameters[2]
            if not name then
                printAndOutput("No name provided", OutputDevice)
                return false
            end
            printAndOutput(string.format("Name: %s\n", name), OutputDevice)

            printAndOutput("Loading character data...\n", OutputDevice)
            ExecuteAsync(function()
                LoadCharacterData(name)
            end)
        elseif Parameters[1] == "list" then
            printAndOutput("Listing character data...\n", OutputDevice)
            local filePath = "ue4ss\\Mods\\RaceMenuUtilities\\Presets\\"
            local files = {}
            for file in io.popen('dir "' .. filePath .. '" /b'):lines() do
                table.insert(files, file)
            end

            -- Parse JSON files and collect details
            local characterData = {}
            for _, file in ipairs(files) do
                local fullPath = filePath .. file
                local fileHandle = io.open(fullPath, "r")
                if fileHandle then
                    local content = fileHandle:read("*a")
                    fileHandle:close()
                    local data, _, err = json.decode(content, 1, nil)
                    if not err then
                        table.insert(characterData, {
                            Name = data.Name or "Unknown",
                            Race = data.CurrentRace or "Unknown",
                            Type = data.CurrentSex or "Unknown",
                            Description = data.Description or "No description",
                            Author = data.Author or "Unknown",
                            Date = data.Date or "Unknown"
                        })
                    else
                        printAndOutput("Failed to decode JSON for file: " .. file, OutputDevice)
                    end
                else
                    printAndOutput("Failed to open file: " .. file, OutputDevice)
                end
            end

            -- Sorting logic
            local sortColumn = Parameters[2] or "Name" -- Default to sorting by Name
            local sortOrder = Parameters[3] or "asc" -- Default to ascending order
            table.sort(characterData, function(a, b)
                if sortOrder == "asc" then
                    return a[sortColumn] < b[sortColumn]
                else
                    return a[sortColumn] > b[sortColumn]
                end
            end)

            -- Print and output the sorted data
            printAndOutput(string.format("%-20s %-15s %-10s %-30s %-20s %-20s", "Name", "Race", "Type", "Description", "Author", "Date"), OutputDevice)
            for _, char in ipairs(characterData) do
                printAndOutput(string.format("%-20s %-15s %-10s %-30s %-20s %-20s", char.Name, char.Race, char.Type, char.Description, char.Author, char.Date), OutputDevice)
            end
        elseif Parameters[1] == "help" then
            printAndOutput("Available commands:\n", OutputDevice)
            printAndOutput("rmu save <name> <description>(optional) <author>(optional) - Save character data\n", OutputDevice)
            printAndOutput("rmu load <name> - Load character data\n", OutputDevice)
            printAndOutput("rmu list <sort_column>(optional) <sort_order>(optional) - List character data\n", OutputDevice)
            printAndOutput("rmu help - Show this help message\n", OutputDevice)
            printAndOutput("Tips:", OutputDevice)
            printAndOutput("1. SAVE BEFORE RUNNING COMMANDS", OutputDevice)
            printAndOutput("2. If your name or desciption has spaces, surround them in quotes like this \"Has Spaces\"", OutputDevice)
            printAndOutput("3. The console behaves strangely on the racemenu, it helps to be clicked on to the Overview tab", OutputDevice)
        else
            printAndOutput("Unknown command. Use 'rmu help' for a list of commands.\n", OutputDevice)
        end


-- end)
    return true
end)