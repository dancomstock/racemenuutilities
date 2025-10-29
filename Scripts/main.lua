--author = animandan
--version = 1.0.0
--date = 2025-04-30

config = require("config") -- Load the config file
delayMultiplier = config.delayMultiplier -- Multiplier for the delay time for loading each piece of a preset.
presetLocation = config.presetLocation -- The location you want to save and load presets from.
enableNBO = config.enableNBO
NBOLocation = config.NBOLocation
NBOPresetLocation = config.NBOPresetLocation


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

unloadedRaces = {
    DarkSeducer = 1,
    Dremora = 2,
    GoldenSaint = 3,
    Sheogorath = 4,
    VampireRace = 5,
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
    return t[#t]
  end

function getNameFromFullName(fullName)
    if not fullName then
        print("Full name is nil")
        return nil
      end
      sep = "."
      local t = {}
      for str in string.gmatch(fullName, "([^"..sep.."]+)") do
        table.insert(t, str)
      end
      return t[#t]
    end


function GetPhenotypeDataFields(data)
    local VCharacterPhenotypeData = getCharacterPhenotypeData()
    if not VCharacterPhenotypeData then
        print("No instance of 'VCharacterPhenotypeData' was found.\n")
        return nil
    end

    -- local data = {}

    -- -- Get FaceMorphsSource
    -- if VCharacterPhenotypeData.FaceMorphsSource and VCharacterPhenotypeData.FaceMorphsSource:IsValid() then
    --     data.FaceMorphsSource = getPathFromFullName(VCharacterPhenotypeData.FaceMorphsSource:GetFullName())
    -- end

    -- Get FaceBaseMesh
    if VCharacterPhenotypeData.FaceBaseMesh and VCharacterPhenotypeData.FaceBaseMesh:IsValid() then
        data.FaceBaseMesh = getPathFromFullName(VCharacterPhenotypeData.FaceBaseMesh:GetFullName())
    end

    -- Get FaceMorphValuesMap
    data.FaceMorphValuesMap = {}
    if VCharacterPhenotypeData.FaceMorphValuesMap then
        VCharacterPhenotypeData.FaceMorphValuesMap:ForEach(function(key, value)
            data.FaceMorphValuesMap[key:get():ToString()] = value:get()
        end)
    end

    -- Get Hair
    if VCharacterPhenotypeData.Hair and VCharacterPhenotypeData.Hair:IsValid() then
        data.Hair = getPathFromFullName(VCharacterPhenotypeData.Hair:GetFullName())
    end
    -- if VCharacterPhenotypeData.CustomisationBeardIndex then
    --     data.CustomisationHairIndex = VCharacterPhenotypeData.CustomisationHairIndex
    -- end

    -- Get Eyebrows
    if VCharacterPhenotypeData.Eyebrows and VCharacterPhenotypeData.Eyebrows:IsValid() then
        data.Eyebrows = getPathFromFullName(VCharacterPhenotypeData.Eyebrows:GetFullName())
    end

    -- if VCharacterPhenotypeData.CustomisationEyebrowsIndex then
    --     data.CustomisationEyebrowsIndex = VCharacterPhenotypeData.CustomisationEyebrowsIndex
    -- end

    -- Get Mustache
    if VCharacterPhenotypeData.Mustache and VCharacterPhenotypeData.Mustache:IsValid() then
        data.Mustache = getPathFromFullName(VCharacterPhenotypeData.Mustache:GetFullName())
    else
        data.Mustache = ("/Game/Dev/Phenotypes/Mustache/HP_MS_None.HP_MS_None")
    end


    -- Get Beard
    if VCharacterPhenotypeData.Beard and VCharacterPhenotypeData.Beard:IsValid() then
        data.Beard = getPathFromFullName(VCharacterPhenotypeData.Beard:GetFullName())
    else
        data.Beard = ("/Game/Dev/Phenotypes/Beard/HP_BD_None.HP_BD_None")
    end


    -- Get HairColorsL
    data.HairColorsL = {}
    if VCharacterPhenotypeData.HairColorsL then
        VCharacterPhenotypeData.HairColorsL:ForEach(function(key, value)
            data.HairColorsL[key:get()] = { R = value:get().R, G = value:get().G, B = value:get().B, A = value:get().A }
        end)
    end

    -- -- Get FaceMaterialSlotOverrides
    data.FaceMaterialSlotOverrides = {}
    if VCharacterPhenotypeData.FaceMaterialSlotOverrides then
        VCharacterPhenotypeData.FaceMaterialSlotOverrides:ForEach(function(key, value)
            data.FaceMaterialSlotOverrides[key:get():ToString()] = getPathFromFullName(value:get():GetFullName())
        end)
    end

    -- Get SkinParametersMap
    data.SkinParametersMap = {}
    if VCharacterPhenotypeData.SkinParametersMap then
        VCharacterPhenotypeData.SkinParametersMap:ForEach(function(key, value)
            data.SkinParametersMap[key:get():ToString()] = value:get()
        end)
    end

    -- -- Get SkinColorsMap
    -- data.SkinColorsMap = {}
    -- if VCharacterPhenotypeData.SkinColorsMap then
    --     VCharacterPhenotypeData.SkinColorsMap:ForEach(function(key, value)
    --         data.SkinColorsMap[key:get():ToString()] = { R = value:get().R, G = value:get().G, B = value:get().B, A = value:get().A }
    --     end)
    -- end

    -- Get SkinColorsMapL
    data.SkinColorsMapL = {}
    if VCharacterPhenotypeData.SkinColorsMapL then
        VCharacterPhenotypeData.SkinColorsMapL:ForEach(function(key, value)
            data.SkinColorsMapL[key:get():ToString()] = { R = value:get().R, G = value:get().G, B = value:get().B, A = value:get().A }
        end)
    end

    -- Get SenescenceLevel
    data.SenescenceLevel = VCharacterPhenotypeData.SenescenceLevel

    -- Get EyeMaterial
    if VCharacterPhenotypeData.EyeMaterial and VCharacterPhenotypeData.EyeMaterial:IsValid() then
        data.EyeMaterial = getPathFromFullName(VCharacterPhenotypeData.EyeMaterial:GetFullName())
    end
    -- if VCharacterPhenotypeData.CustomisationEyeMaterialIndex then
    --     data.CustomisationEyeMaterialIndex = VCharacterPhenotypeData.CustomisationEyeMaterialIndex
    -- end

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


function SaveCharacterData(name, description, author, character, save_dir)
    local save_dir = save_dir or presetLocation
    local VPairedCharacter = nil
    local VCharacterPhenotypeData = nil
    if character == nil then
        VPairedCharacter = FindFirstOf("BP_OblivionPlayerCharacter_C")
        if not VPairedCharacter
        then
            print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
            return
        end
    else
        VPairedCharacter = character
    end
    VCharacterPhenotypeData = VPairedCharacter.PhenotypeData
    -- local VCharacterPhenotypeData = getCharacterPhenotypeData()
    if not VCharacterPhenotypeData then
        print("No instance of 'VCharacterPhenotypeData' was found.\n")
        return
    end

    local data = {
        Race = VPairedCharacter.Race:GetFullName(),
        Sex = VPairedCharacter.Sex,
    }


    GetPhenotypeDataFields(data)

    data.Name = name
    data.Description = description
    data.Date = os.date("%Y-%m-%d %H:%M:%S")
    data.APIVersion = "v2"
    data.Author = author
    data.ModVersion = "1.1.0"
    data.ModName = "RaceMenuUtilities"
    data.ModCreator = "animandan"

    if enableNBO then
        local NBOPath = NBOLocation .. "FEMALE_Body.json"
        local NBOData = LoadJson_new(NBOPath)
        data.NBO = NBOData or {}
    end

    local filePath = save_dir .. name .. ".json"

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


function LoadPhenotypeDataFields(data, character)
    local VPairedCharacter = nil
    local VCharacterPhenotypeData = nil
    if character == nil then
        VPairedCharacter = FindFirstOf("BP_OblivionPlayerCharacter_C")
        if not VPairedCharacter
        then
            print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
            return
        end
    else
        VPairedCharacter = character
    end
    VCharacterPhenotypeData = VPairedCharacter.PhenotypeData
    -- local VCharacterPhenotypeData = getCharacterPhenotypeData()
    if not VCharacterPhenotypeData then
        print("No instance of 'VCharacterPhenotypeData' was found.\n")
        return
    end


    -- sleep(delayTime)
    
    
    -- ExecuteInGameThread(function()
    --     if data.FaceMorphsSource then
    --         print("[RaceMenuUtilities] Assign FaceMorphsSource")
    --         VCharacterPhenotypeData.FaceMorphsSource = LoadAsset(data.FaceMorphsSource)
    --     end
    -- end)

    -- BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
    -- BP_OblivionPlayerCharacter_C:RefreshAppearance(15)

    sleep(delayTime)

    
    
    if data.FaceBaseMesh then
        ExecuteInGameThread(function()
        print("[RaceMenuUtilities] Assign FaceBaseMesh")
        VCharacterPhenotypeData.FaceBaseMesh = LoadAsset(data.FaceBaseMesh)
        end)
    end

    sleep(delayTime)

    -- BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
        
    
    -- ExecuteInGameThread(function()
    if data.FaceMorphValuesMap then
        print("[RaceMenuUtilities] Assign FaceMorphValuesMap")
        -- VCharacterPhenotypeData.FaceMorphValuesMap = {}
        for key, value in pairs(data.FaceMorphValuesMap) do
            print("Updating MorphTarget: " .. tostring(key) .. " = " .. tostring(value))
            sleep(delayTime)
            ExecuteInGameThread(function()
                keyFName = FName(key)
                if not keyFName then
                    print("Failed to create FName from key: " .. tostring(key))
                    return
                end
                VCharacterPhenotypeData.FaceMorphValuesMap:Add(keyFName, value)
            end)
        end
    end
-- end)

    sleep(delayTime)

    -- BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
        

    
    ExecuteInGameThread(function()
        if data.Hair then
            print("[RaceMenuUtilities] Assign Hair")
            Hair =  LoadAsset(data.Hair)
            print("Hair: " .. tostring(Hair:GetFullName()))
            VCharacterPhenotypeData.Hair = Hair
            
        end
        if data.CustomisationHairIndex then
            VCharacterPhenotypeData.CustomisationHairIndex = data.CustomisationHairIndex
        end
    end)

    sleep(delayTime)

    -- BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
        
   
    ExecuteInGameThread(function()
        if data.Eyebrows then 
                print("[RaceMenuUtilities] Assign Eyebrows")
                Eyebrows = LoadAsset(data.Eyebrows)
                VCharacterPhenotypeData.Eyebrows = Eyebrows
            end
            if data.CustomisationEyebrowsIndex then
                VCharacterPhenotypeData.CustomisationEyebrowsIndex = data.CustomisationEyebrowsIndex
        end
    end)

    sleep(delayTime)

    
    ExecuteInGameThread(function()
        if data.Mustache then
            print("[RaceMenuUtilities] Assign Mustache")
            VCharacterPhenotypeData.Mustache = LoadAsset(data.Mustache)
        end
        if data.CustomisationMustacheIndex then
            VCharacterPhenotypeData.CustomisationMustacheIndex = data.CustomisationMustacheIndex
        end
    end)

sleep(delayTime)

    
    ExecuteInGameThread(function()
        if data.Beard then
            print("[RaceMenuUtilities] Assign Beard")
            VCharacterPhenotypeData.Beard = LoadAsset(data.Beard)
        end
        if data.CustomisationBeardIndex then
            VCharacterPhenotypeData.CustomisationBeardIndex = data.CustomisationBeardIndex
        end
    end)

    
    ExecuteInGameThread(function()
        if data.FaceMaterialSlotOverrides then
            print("[RaceMenuUtilities] Assign FaceMaterialSlotOverrides")
            -- VCharacterPhenotypeData.FaceMaterialSlotOverrides = {}
            for key, value in pairs(data.FaceMaterialSlotOverrides) do
                VCharacterPhenotypeData.FaceMaterialSlotOverrides.Add(FName(key), LoadAsset(value))
            end
        end
    end)

sleep(delayTime)

    
    
    if data.SkinParametersMap then
        print("[RaceMenuUtilities] Assign SkinParametersMap")
        -- VCharacterPhenotypeData.SkinParametersMap = {}
        for key, value in pairs(data.SkinParametersMap) do
            sleep(delayTime)
            ExecuteInGameThread(function()
            print("Updating SkinParametersMap: " .. tostring(key) .. " = " .. tostring(value))
            local keyFName = FName(key)
            if not keyFName then
                print("Failed to create FName from key: " .. tostring(key))
                return
            end
            VCharacterPhenotypeData.SkinParametersMap:Add(keyFName, value)
        end)
    end
end

sleep(delayTime)

--     print("[RaceMenuUtilities] Assign SkinColorsMap")
--     ExecuteInGameThread(function()
--     if data.SkinColorsMap then
--         VCharacterPhenotypeData.SkinColorsMap = {}
--         for key, value in pairs(data.SkinColorsMap) do
--             VCharacterPhenotypeData.SkinColorsMap.Add(key, FColor(value.R, value.G, value.B, value.A))
--         end
--     end
-- end)

   
    
    if data.SkinColorsMapL then 
        print("[RaceMenuUtilities] Assign SkinColorsMapL")
        -- VCharacterPhenotypeData.SkinColorsMapL = {}
        for key, value in pairs(data.SkinColorsMapL) do
            sleep(delayTime)
            ExecuteInGameThread(function()
                print("Updating SkinColorsMapL: " .. tostring(key) .. " = " .. tostring(value))
                keyFName = FName(key)
                if not keyFName then
                    print("Failed to create FName from key: " .. tostring(key))
                    return
                end
                local FLinearColor = {}
                FLinearColor.R = value.R
                FLinearColor.G = value.G
                FLinearColor.B = value.B
                FLinearColor.A = value.A
                VCharacterPhenotypeData.SkinColorsMapL:Add(keyFName, FLinearColor)
            end)
        end
    end

    sleep(delayTime)

    
    ExecuteInGameThread(function()
        if data.SenescenceLevel then
            print("[RaceMenuUtilities] Assign SenescenceLevel")
            VCharacterPhenotypeData.SenescenceLevel = data.SenescenceLevel
        end
    end)



    sleep(delayTime)


   
    ExecuteInGameThread(function()
        if data.EyeMaterial then 
            print("[RaceMenuUtilities] Assign EyeMaterial")
            VCharacterPhenotypeData.EyeMaterial = LoadAsset(data.EyeMaterial)
        end
        if data.CustomisationEyeMaterialIndex then
            VCharacterPhenotypeData.CustomisationEyeMaterialIndex = data.CustomisationEyeMaterialIndex
        end
    end)


    sleep(delayTime)

    if enableNBO then
        local NBOPath = NBOLocation .. "FEMALE_Body.json"
        SaveJson(data.NBO, NBOPath)
    end

    sleep(delayTime)

    ExecuteInGameThread(function()
        VPairedCharacter:RefreshAppearance(15)
    end)



    print("Phenotype data loaded into VCharacterPhenotypeData.")
end



function RefreshCharacterAppearance()
    ExecuteInGameThread(function()
        BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
        if BP_OblivionPlayerCharacter_C then
            BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
        end
    end)
end


function LoadCharacterData(name)
    local filePath = presetLocation .. name .. ".json"
    if not filePath then
        print("No file path provided.")
        return
    end
    print("File path: " .. filePath)
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

    local UVRaceSexMenuViewModelInstance = FindFirstOf("VRaceSexMenuViewModel") --UVRaceSexMenuViewModel
    if not UVRaceSexMenuViewModelInstance or not UVRaceSexMenuViewModelInstance:IsValid() then
        print("Invalid UVRaceSexMenuViewModelInstance provided.")
        return
    end


    sleep(delayTime) -- Wait for the character to update

    print("CurrentRace: " .. tostring(data.CurrentRace) .. "\n")
    local raceString = data.CurrentRace:gsub("%s+", "")
    print("raceString: " .. tostring(raceString) .. "\n")
    
    if raceRowOrder[raceString] ~= nil then
        TESRacePtr = FindObject('TESRace', raceString)
        if not TESRacePtr or not TESRacePtr:IsValid() then
            print("No instance of class 'TESRace' was found.\n")
            return
        end
    else
        ExecuteInGameThread(function()
            -- TESRaceString = string.format("/Game/Forms/actors/race/" .. raceString .. "." .. raceString)
            -- print("TESRaceString: " .. tostring(TESRaceString) .. "\n")
            -- TESRacePtr = LoadAsset(TESRaceString)
            -- print("TESRacePtr: " .. tostring(TESRacePtr:GetFullName()) .. "\n")
            -- if not TESRacePtr or not TESRacePtr:IsValid() then
            --     print("No instance of class 'TESRace' was found.\n")
            --     return
            -- end
            -- print("TESRacePtr: " .. tostring(TESRacePtr:GetFullName()) .. "\n")
            TESRacePtr = LoadAsset(raceString)
            print("TESRacePtr: " .. tostring(TESRacePtr:GetFullName()) .. "\n")
            if not TESRacePtr or not TESRacePtr:IsValid() then
                print("No instance of class 'TESRace' was found.\n")
                return
            end
            print("TESRacePtr: " .. tostring(TESRacePtr:GetFullName()) .. "\n")
        end)
        sleep(delayTime*20) -- Wait for the character to update
    end

    -- local TESRaceString = string.format("/Game/Forms/actors/race/" .. "Goldensaint" .. "." .. "Goldensaint")

    
    -- TESRacePtr = UVRaceSexMenuViewModelInstance.RacesPtrArray[RacesPtrArrayOrder[raceString]]
    -- if not TESRacePtr or not TESRacePtr:IsValid() then
    --     print("No instance of class 'TESRace' was found.\n")
    --     return
    -- end
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

    if data.BaseFaceMesh then
        SetBaseFaceMesh(data.BaseFaceMesh)
    end
    
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


    
    -- Set Skin Parameters
    if data.SkinParametersMap then
        for key, value in pairs(data.SkinParametersMap) do
            sleep(delayTime)
            SetSkinParameter(key, value)
        end
    end

    sleep(delayTime)


    if data.SenescenceLevel then
        print("setting SenescenceLevel")
        SetSenescenceValue(data.SenescenceLevel)
    end

    sleep(delayTime*5)

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
                local data = LoadJson(name)
                if data.APIVersion == "v1" then
                    print("API version 1")
                    LoadCharacterData(name)
                else
                    LoadPhenotypeDataFields(data)
                end 
            end)
        elseif Parameters[1] == "list" then
            local dir = Parameters[2] or presetLocation
            printAndOutput("Listing character data...\n", OutputDevice)
            local filePath = dir
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
                            Name = file:gsub("%.json$", ""),
                            Race = getNameFromFullName(data.Race) or data.CurrentRace or "Unknown",
                            Type = data.Sex or data.CurrentSex or "Unknown",
                            Description = data.Description or "No description",
                            Author = data.Author or "Unknown",
                            Date = data.Date or "Unknown",
                            APIVersion = data.APIVersion or "Unknown"
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
            printAndOutput(string.format("%-20s   %-15s   %-10s   %-30s   %-20s   %-30s   %-20s", "Name", "Race", "Type", "Description", "Author", "Date", "APIVersion"), OutputDevice)
            for _, char in ipairs(characterData) do
                printAndOutput(string.format("%-20s   %-15s   %-10s   %-30s   %-20s   %-30s   %-20s", char.Name, char.Race, char.Type, char.Description, char.Author, char.Date, char.APIVersion), OutputDevice)
            end
        elseif Parameters[1] == "set" then
            local assetType = Parameters[2]
            local assetPath = Parameters[3]
    
            if not assetType or not assetPath then
                printAndOutput("Invalid parameters. Usage: rmu set <type> <asset>", OutputDevice)
                return false
            end
    
            if assetType == "hair" then
                printAndOutput("Setting Hair...", OutputDevice)
                SetHair(assetPath)
            elseif assetType == "beard" then
                printAndOutput("Setting Beard...", OutputDevice)
                SetBeard(assetPath)
            elseif assetType == "mustache" then
                printAndOutput("Setting Mustache...", OutputDevice)
                SetMustache(assetPath)
            elseif assetType == "eyebrows" then
                printAndOutput("Setting Eyebrows...", OutputDevice)
                SetEyebrows(assetPath)
            elseif assetType == "eyes" then
                printAndOutput("Setting Eyes...", OutputDevice)
                SetEyes(assetPath)
            elseif assetType == "face" then
                printAndOutput("Setting Base Face Mesh...", OutputDevice)
                SetBaseFaceMesh(assetPath)
            elseif assetType == "skin" then
                printAndOutput("Setting Skin Parameter...", OutputDevice)
                local parameterName = Parameters[3]
                local value = tonumber(Parameters[4])
                if not parameterName or not value then
                    printAndOutput("Invalid parameters. Usage: rmu set skin <parameterName> <value>", OutputDevice)
                    return false
                end
                SetSkinParameter(parameterName, value)
            elseif assetType == "race" then
                printAndOutput("Setting Race...", OutputDevice)
                SetRace(assetPath)
            elseif assetType == "load" then
                printAndOutput("Loading Asset...", OutputDevice)
                justLoad(assetPath)
            else
                printAndOutput("Unknown type. Valid types are: hair, eyes, face.", OutputDevice)
            end
        elseif Parameters[1] == "help" then
            printAndOutput("Available commands:\n", OutputDevice)
            printAndOutput("rmu save <name> <description>(optional) <author>(optional) - Save character data\n", OutputDevice)
            printAndOutput("rmu load <name> - Load character data\n", OutputDevice)
            printAndOutput("rmu list <sort_column>(optional) <sort_order>(optional) - List character data\n", OutputDevice)
            printAndOutput("rmu set <type> <asset> - Set hair, eyes, or face mesh\n", OutputDevice)
            printAndOutput("rmu help - Show this help message\n", OutputDevice)
            printAndOutput("Tips:", OutputDevice)
            printAndOutput("1. SAVE BEFORE RUNNING COMMANDS", OutputDevice)
            printAndOutput("2. If your name or desciption has spaces, surround them in quotes like this \"Has Spaces\"", OutputDevice)
            printAndOutput("3. The console behaves strangely on the racemenu, it helps to be clicked on to the Overview tab", OutputDevice)
        elseif Parameters[1] == "close" then
            CloseMenu()
        elseif Parameters[1] == "nbo" then
            local name = Parameters[3]
            if Parameters[2] == "set" then
                SetNBO(name)
            elseif Parameters[2] == "save" then     
                SaveNBO(name)
            else
                printAndOutput("Incorrect parameters for NBO\n", OutputDevice)
            end
        else
            printAndOutput("Unknown command. Use 'rmu help' for a list of commands.\n", OutputDevice)
        end

    return true
end)


function CloseMenu()
        local UVRaceSexMenuViewModelInstance = FindFirstOf("VRaceSexMenuViewModel") --UVRaceSexMenuViewModel
        if not UVRaceSexMenuViewModelInstance or not UVRaceSexMenuViewModelInstance:IsValid() then
            print("Invalid UVRaceSexMenuViewModelInstance provided.")
            return
        end

        UVRaceSexMenuViewModelInstance:CloseMenu(1)
end


function SetHair(assetPath)
    ExecuteInGameThread(function()
        local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
        if not BP_OblivionPlayerCharacter_C then
            print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
            return
        end

        local Hair = LoadAsset(assetPath)
        if not Hair or not Hair:IsValid() then
            print("Failed to load hair asset: " .. assetPath)
            return
        end

        print("Setting Hair: " .. tostring(Hair:GetFullName()))
        BP_OblivionPlayerCharacter_C.PhenotypeData.Hair = Hair
        BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
    end)
end


function SetBeard(assetPath)
    ExecuteInGameThread(function()
        local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
        if not BP_OblivionPlayerCharacter_C then
            print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
            return
        end

        local Beard = LoadAsset(assetPath)
        if not Beard or not Beard:IsValid() then
            print("Failed to load Beard asset: " .. assetPath)
            return
        end

        print("Setting Beard: " .. tostring(Beard:GetFullName()))
        BP_OblivionPlayerCharacter_C.PhenotypeData.Beard = Beard
        BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
    end)
end


function SetMustache(assetPath)
    ExecuteInGameThread(function()
        local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
        if not BP_OblivionPlayerCharacter_C then
            print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
            return
        end

        local Mustache = LoadAsset(assetPath)
        if not Mustache or not Mustache:IsValid() then
            print("Failed to load Mustache asset: " .. assetPath)
            return
        end

        print("Setting Mustache: " .. tostring(Mustache:GetFullName()))
        BP_OblivionPlayerCharacter_C.PhenotypeData.Mustache = Mustache
        BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
    end)
end


function SetEyebrows(assetPath)
    ExecuteInGameThread(function()
        local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
        if not BP_OblivionPlayerCharacter_C then
            print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
            return
        end

        local Eyebrows = LoadAsset(assetPath)
        if not Eyebrows or not Eyebrows:IsValid() then
            print("Failed to load Eyebrows asset: " .. assetPath)
            return
        end

        print("Setting Eybrows: " .. tostring(Eyebrows:GetFullName()))
        BP_OblivionPlayerCharacter_C.PhenotypeData.Eyebrows = Eyebrows
        BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
    end)
end


function SetEyes(assetPath)
    ExecuteInGameThread(function()
        local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
        if not BP_OblivionPlayerCharacter_C then
            print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
            return
        end

        local EyeMaterial = LoadAsset(assetPath)
        if not EyeMaterial or not EyeMaterial:IsValid() then
            print("Failed to load eye material asset: " .. assetPath)
            return
        end

        print("Setting Eyes: " .. tostring(EyeMaterial:GetFullName()))
        BP_OblivionPlayerCharacter_C.PhenotypeData.EyeMaterial = EyeMaterial
        BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
    end)
end


function getVPhenotypeCustomizationSession()
    local VPhenotypeCustomizationSession = FindFirstOf("VPhenotypeCustomizationSession")
    if not VPhenotypeCustomizationSession or not VPhenotypeCustomizationSession:IsValid() then
        print("No instance of class 'VPhenotypeCustomizationSession' was found.")
        return
    end
    return VPhenotypeCustomizationSession
end


function SetBaseFaceMesh(assetPath)
    ExecuteInGameThread(function()
        local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
        if not BP_OblivionPlayerCharacter_C then
            print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
            return
        end

        local FaceMesh = LoadAsset(assetPath)
        if not FaceMesh or not FaceMesh:IsValid() then
            print("Failed to load face mesh asset: " .. assetPath)
            return
        end

        print("Setting Base Face Mesh: " .. tostring(FaceMesh:GetFullName()))
        BP_OblivionPlayerCharacter_C.PhenotypeData.FaceBaseMesh = FaceMesh
        BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
    end)
end


function SetSkinParameter(parameterName, value)
    ExecuteInGameThread(function()
        local VPhenotypeCustomizationSession = FindFirstOf("VPhenotypeCustomizationSession")
        if not VPhenotypeCustomizationSession or not VPhenotypeCustomizationSession:IsValid() then
            print("No instance of class 'VPhenotypeCustomizationSession' was found.")
            return
        end

        local keyFName = FName(parameterName)
        if not keyFName then
            print("Failed to create FName from key: " .. tostring(parameterName))
            return
        end

        print("Setting Skin Parameter: " .. tostring(keyFName) .. " = " .. tostring(value))
        VPhenotypeCustomizationSession:SetSkinParameter(keyFName, value, true)


        local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
        if not BP_OblivionPlayerCharacter_C
        then
            print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
            return
        end
        BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
    end)
end


function justLoad(assetPath)
    ExecuteInGameThread(function()

        Asset = LoadAsset(assetPath)
        if not Asset or not Asset:IsValid() then
            print("Failed to load asset: " .. assetPath)
            return
        end
        print("Loaded: " .. assetPath)

    end)
end

function LoadJson(name, dir)
    local dir = dir or presetLocation
    local filePath = dir .. name .. ".json"
    if not filePath then
        print("No file path provided.")
        return nil
    end
    print("File path: " .. filePath)
    print("Loading character data from " .. filePath)

    local file = io.open(filePath, "r")
    if not file then
        print("Failed to open file for reading: " .. filePath)
        return nil
    end

    local content = file:read("*a")
    file:close()

    local data, pos, err = json.decode(content, 1, nil)
    if err then
        print("Failed to decode JSON data: " .. err)
        return nil
    end
    return data
end


function SetNBO(name, dir)
    local dir = dir or NBOPresetLocation
    local filePath = dir .. name .. ".json"
    local NBOPath = NBOLocation .. "FEMALE_Body.json"
    local NBOData = LoadJson_new(filePath)
    SaveJson(NBOData, NBOPath)

    local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
    if not BP_OblivionPlayerCharacter_C
    then
        print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
        return
    end
    BP_OblivionPlayerCharacter_C:RefreshAppearance(15)

end

function SaveNBO(name, dir)
    local dir = dir or NBOPresetLocation
    local filePath = dir .. name .. ".json"
    local NBOPath = NBOLocation .. "FEMALE_Body.json"
    local NBOData = LoadJson_new(NBOPath)
    SaveJson(NBOData, filePath)
end


function SaveJson(data, filePath)
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


function LoadJson_new(filePath)
    -- local dir = dir or presetLocation
    -- local filePath = dir .. name .. ".json"
    local data = {}
    if not filePath then
        print("No file path provided.")
        return nil
    end
    print("File path: " .. filePath)
    print("Loading character data from " .. filePath)

    local file = io.open(filePath, "r")
    if not file then
        print("Failed to open file for reading: " .. filePath)
        return nil
    end

    local content = file:read("*a")
    file:close()

    local data, pos, err = json.decode(content, 1, nil)
    if err then
        print("Failed to decode JSON data: " .. err)
        return nil
    end
    return data
end


function LoadAllRaces(racesDir)
    local racesDir = racesDir or "ue4ss/Mods/RaceMenuUtilities/Races/"
    local raceFiles = {}
    local races = {}

    -- Collect all .json files in the directory
    for file in io.popen('dir "' .. racesDir .. '" /b'):lines() do
        if file:match("%.json$") then
            table.insert(raceFiles, file)
        end
    end

    -- Sort alphabetically
    table.sort(raceFiles, function (a, b)
        return string.lower(a) < string.lower(b)
        -- return a < b
    end)

    -- Load each file and add RaceIndex
    for i, file in ipairs(raceFiles) do
        local fullPath = racesDir .. file
        local f = io.open(fullPath, "r")
        if f then
            local content = f:read("*a")
            f:close()
            local data, _, err = json.decode(content, 1, nil)
            if not err and type(data) == "table" then
                data.RaceIndex = i-1
                table.insert(races, data)
            else
                print("Failed to decode JSON for race file: " .. file)
            end
        else
            print("Failed to open race file: " .. file)
        end
    end

    return races
end


function GetRaceDataTables(racesDir)
    local races = LoadAllRaces(racesDir)
    local paths = {}
    local indices = {}
    local descriptions = {}
    local origins = {}

    for _, race in ipairs(races) do
        local name = race.Name
        if name then
            paths[name] = race.Path or ""
            indices[name] = race.RaceIndex or 0
            descriptions[name] = race.Description or ""
            origins[name] = race.Origins or ""
        end
    end

    return paths, indices, descriptions, origins
end


function GetAssetFileNamesByCategory(baseDir)
    local baseDir = baseDir or "ue4ss/Mods/RaceMenuUtilities/Options/"
    local categories = { "Eyes", "Hair", "Beard", "Mustache", "Face" } -- Added "Face"
    local result = {}

    for _, category in ipairs(categories) do
        local dir = baseDir .. category .. "/"
        local files = {}
        local handle = io.popen('dir "' .. dir .. '" /b')
        if handle then
            for file in handle:lines() do
                if file:match("%.json$") then
                    local name = file:gsub("%.json$", "")
                    table.insert(files, name)
                end
            end
            handle:close()
        end
        result[category] = files
    end

    return result.Eyes, result.Hair, result.Beard, result.Mustache, result.Face -- Added Face to return
end


function GetOptionJsonByTypeAndFileName(optionType, fileName, baseDir)
    -- baseDir is optional, defaults to "ue4ss/Mods/RaceMenuUtilities/Options/"
    local baseDir = baseDir or "ue4ss/Mods/RaceMenuUtilities/Options/"
    if not optionType or not fileName then
        print("Option type or file name not provided.")
        return nil
    end

    local filePath = baseDir .. tostring(optionType) .. "/" .. tostring(fileName) .. ".json"
    local file = io.open(filePath, "r")
    if not file then
        print("Failed to open file for reading: " .. filePath)
        return nil
    end

    local content = file:read("*a")
    file:close()

    local data, pos, err = json.decode(content, 1, nil)
    if err then
        print("Failed to decode JSON data: " .. err)
        return nil
    end
    return data
end


RegisterCustomEvent("RMU_getStuffFromLua", function (WBP_RaceMenuUtilities)
    print("custom event!\n")
    -- local WBP_RaceMenuUtilities = (FindAllOf("WBP_RaceMenuUtilities") or {})[1]
   
    if WBP_RaceMenuUtilities:get() ~= nil and WBP_RaceMenuUtilities:get():IsValid() then
        _WBP_RaceMenuUtilities = WBP_RaceMenuUtilities:get()
    end

    local paths, indices, descriptions, origins = GetRaceDataTables()
    -- print(paths["Nord"], indices["Nord"], descriptions["Nord"], origins["Nord"])

    for key, value in pairs(paths) do
        _WBP_RaceMenuUtilities.RacePaths:Add(tostring(key),tostring(paths[key]))
        _WBP_RaceMenuUtilities.RaceIds:Add(tostring(key), tostring(indices[key]))
        _WBP_RaceMenuUtilities.RaceDescriptions:Add(tostring(key), tostring(descriptions[key]))
        _WBP_RaceMenuUtilities.RaceOrigins:Add(tostring(key), tostring(origins[key]))
    end

    local eyes, hair, beard, mustache, face = GetAssetFileNamesByCategory()

    for i, filename in ipairs(eyes) do 
        _WBP_RaceMenuUtilities.EyesFileList[i] = tostring(filename)
    end

    for i, filename in ipairs(hair) do 
        _WBP_RaceMenuUtilities.HairFileList[i] = tostring(filename)
    end

    for i, filename in ipairs(beard) do
        _WBP_RaceMenuUtilities.BeardFileList[i] = tostring(filename)
    end

    for i, filename in ipairs(mustache) do
        _WBP_RaceMenuUtilities.MustacheFileList[i] = tostring(filename)
    end

    for i, filename in ipairs(face) do
        _WBP_RaceMenuUtilities.FaceFileList[i] = tostring(filename)
    end
end)

RegisterCustomEvent("RMU_getOptionMapFromLua", function (_, Type, FileName, OptionMap)
    local data = GetOptionJsonByTypeAndFileName(Type:get():ToString(), FileName:get():ToString())
    for key, value in pairs(data) do 
        OptionMap:get():Add(tostring(key), tostring(value))
    end
end)




RegisterCustomEvent("RMU_closeVSexRaceMenu", function ()
    CloseMenu()
end)








