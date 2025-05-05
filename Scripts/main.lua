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

unloadedRaces = {
    DarkSeducer = 1,
    Dremora = 2,
    GoldenSaint = 3,
    Sheogorath = 4,
    VampireRace = 5,
}


-- RacesPtrArrayOrder = {
--     DarkElf = 1,
--     Imperial = 2,
--     Argonian = 3,
--     Breton = 4,
--     Orc = 5,
--     Redguard = 6,
--     Nord = 7,
--     WoodElf = 8,
--     Khajiit = 9,
--     HighElf = 10
-- }




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
    end
    -- if VCharacterPhenotypeData.CustomisationMustacheIndex then
    --     data.CustomisationMustacheIndex = VCharacterPhenotypeData.CustomisationMustacheIndex
    -- end

    -- Get Beard
    if VCharacterPhenotypeData.Beard and VCharacterPhenotypeData.Beard:IsValid() then
        data.Beard = getPathFromFullName(VCharacterPhenotypeData.Beard:GetFullName())
    end
    -- if VCharacterPhenotypeData.CustomisationBeardIndex then
    --     data.CustomisationBeardIndex = VCharacterPhenotypeData.CustomisationBeardIndex
    -- end

    -- -- Get HairColors
    -- data.HairColors = {}
    -- if VCharacterPhenotypeData.HairColors then
    --     VCharacterPhenotypeData.HairColors:ForEach(function(key, value)
    --         data.HairColors[key:get()] = { R = value:get().R, G = value:get().G, B = value:get().B, A = value:get().A }
    --     end)
    -- end

    -- Get HairColorsL
    data.HairColorsL = {}
    if VCharacterPhenotypeData.HairColorsL then
        VCharacterPhenotypeData.HairColorsL:ForEach(function(key, value)
            data.HairColorsL[key:get()] = { R = value:get().R, G = value:get().G, B = value:get().B, A = value:get().A }
        end)
    end

    -- -- Get SkinParameterDefinitions
    -- if VCharacterPhenotypeData.SkinParameterDefinitions and VCharacterPhenotypeData.SkinParameterDefinitions:IsValid() then
    --     data.SkinParameterDefinitions = getPathFromFullName(VCharacterPhenotypeData.SkinParameterDefinitions:GetFullName())
    -- end

    -- -- Get BodyProperties
    -- if VCharacterPhenotypeData.BodyProperties then
    --     data.BodyProperties = {}
    --     if VCharacterPhenotypeData.BodyProperties.BoneScalingMap then
    --         data.BodyProperties.BoneScalingMap = {}
    --         VCharacterPhenotypeData.BodyProperties.BoneScalingMap:ForEach(function(key, value)
    --             data.BodyProperties.BoneScalingMap[key:get():ToString()] = value:get()
    --         end)
    --     end
    -- end

    -- -- Get FaceMaterialSlotOverrides
    -- data.FaceMaterialSlotOverrides = {}
    -- if VCharacterPhenotypeData.FaceMaterialSlotOverrides then
    --     VCharacterPhenotypeData.FaceMaterialSlotOverrides:ForEach(function(key, value)
    --         data.FaceMaterialSlotOverrides[key:get():ToString()] = getPathFromFullName(value:get():GetFullName())
    --     end)
    -- end

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


function SaveCharacterData(name, description, author)
    local UVRaceSexMenuViewModelInstance = FindFirstOf("VRaceSexMenuViewModel") --UVRaceSexMenuViewModel
    if not UVRaceSexMenuViewModelInstance or not UVRaceSexMenuViewModelInstance:IsValid() then
        print("Invalid UVRaceSexMenuViewModelInstance provided.")
        return
    end

    local data = {
        CurrentRace = UVRaceSexMenuViewModelInstance.CurrentRace:ToString(),
        CurrentSex = UVRaceSexMenuViewModelInstance.CurrentSex
        -- CurrentArchetype = UVRaceSexMenuViewModelInstance.CurrentArchetype
        -- MorphTargets = {},
        -- ColorTargets = {},
        -- CustomisationTargets = {}
    }

    -- -- Save MorphTargets
    -- UVRaceSexMenuViewModelInstance.PhenotypeData.MorphTargets:ForEach(function(key, value)
    --     data.MorphTargets[key:get():ToString()] = value:get()
    -- end)

    -- -- Save ColorTargets
    -- UVRaceSexMenuViewModelInstance.PhenotypeData.ColorTargets:ForEach(function(key, value)
    --     data.ColorTargets[key:get():ToString()] = {
    --         R = value:get().R,
    --         G = value:get().G,
    --         B = value:get().B,
    --         A = value:get().A
    --     }
    -- end)

    -- -- Save CustomisationTargets
    -- UVRaceSexMenuViewModelInstance.PhenotypeData.CustomisationTargets:ForEach(function(key, value)
    --     data.CustomisationTargets[key:get()] = value:get()
    -- end)

    GetPhenotypeDataFields(data)

    data.Name = name
    data.Description = description
    data.Date = os.date("%Y-%m-%d %H:%M:%S")
    data.APIVersion = "v2"
    data.Author = author
    data.ModVersion = "1.1.0"
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


function LoadPhenotypeDataFields(data)
    local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
    if not BP_OblivionPlayerCharacter_C
    then
        print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
        return
    end
    local VCharacterPhenotypeData = BP_OblivionPlayerCharacter_C.PhenotypeData
    -- local VCharacterPhenotypeData = getCharacterPhenotypeData()
    if not VCharacterPhenotypeData then
        print("No instance of 'VCharacterPhenotypeData' was found.\n")
        return
    end

    sleep(delayTime)
    
    
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

sleep(delayTime)

    -- print("[RaceMenuUtilities] Assign HairColors")
    -- -- ExecuteInGameThread(function()
    -- if data.HairColors then
    --     -- VCharacterPhenotypeData.HairColors = {}
    --     for key, value in pairs(data.HairColors) do
    --         VCharacterPhenotypeData.HairColors.Add(key, FColor(value.R, value.G, value.B, value.A))
    --     end
    -- end                 
-- end)

sleep(delayTime)

    
    -- -- ExecuteInGameThread(function()
    -- if data.HairColorsL then
    --     print("[RaceMenuUtilities] Assign HairColorsL")
    --     -- VCharacterPhenotypeData.HairColorsL = {}
    --     for key, value in pairs(data.HairColorsL) do
    --         sleep(delayTime)
    --         ExecuteInGameThread(function()   
    --             print("Updating MorphTarget: " .. tostring(key) .. " = " .. tostring(value))
    --             VCharacterPhenotypeData.HairColorsL:Add(tonumber(key), {value.R, value.G, value.B, value.A})
    --         end)
    --     end
    -- end
-- end)

sleep(delayTime)

   
--     ExecuteInGameThread(function()
--     if data.SkinParameterDefinitions then 
--         print("[RaceMenuUtilities] Assign SkinParameterDefinitions")
--         VCharacterPhenotypeData.SkinParameterDefinitions = LoadAsset(data.SkinParameterDefinitions)
--     end
-- end)

sleep(delayTime)

--     print("[RaceMenuUtilities] Assign BodyProperties")
--     ExecuteInGameThread(function()
--     if data.BodyProperties and data.BodyProperties.BoneScalingMap then
--         -- VCharacterPhenotypeData.BodyProperties = {}
--         -- VCharacterPhenotypeData.BodyProperties.BoneScalingMap = {}
--         for key, value in pairs(data.BodyProperties.BoneScalingMap) do
--             VCharacterPhenotypeData.BodyProperties.BoneScalingMap.Add(FName(key), value)
--         end
--     end
-- end)

--     print("[RaceMenuUtilities] Assign FaceMaterialSlotOverrides")
--     ExecuteInGameThread(function()
--     if data.FaceMaterialSlotOverrides then
--         -- VCharacterPhenotypeData.FaceMaterialSlotOverrides = {}
--         for key, value in pairs(data.FaceMaterialSlotOverrides) do
--             VCharacterPhenotypeData.FaceMaterialSlotOverrides.Add(FName(key), LoadAsset(value))
--         end
--     end
-- end)

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

ExecuteInGameThread(function()
    BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
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


local function LoadCharacterData(name)
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

    -- -- Set Skin Colors
    -- if data.SkinColorsMap then
    --     for key, value in pairs(data.SkinColorsMap) do
    --         sleep(delayTime)
    --         local color = { R = value.R, G = value.G, B = value.B, A = value.A }
    --         SetSkinColorParameter(key, color)
    --     end
    -- end

    -- -- Set Skin Colors
    -- if data.SkinColorsMapL then
    --     for key, value in pairs(data.SkinColorsMapL) do
    --         sleep(delayTime)
    --         local fcolor = UKismetMathLibrary:Conv_LinearColorToColor(value, false)
    --         local color = { R = fcolor.R, G = fcolor.G, B = fcolor.B, A = fcolor.A}
    --         SetSkinColorParameter(key, color)
    --     end
    -- end

    sleep(delayTime)


    if data.FaceMaterialSlotOverrides then
        for key, value in pairs(data.FaceMaterialSlotOverrides) do
            sleep(delayTime)
            SetFaceMaterial(key, value)
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
            elseif assetType == "eyes" then
                printAndOutput("Setting Eyes...", OutputDevice)
                SetEyes(assetPath)
            elseif assetType == "face" then
                printAndOutput("Setting Base Face Mesh...", OutputDevice)
                SetBaseFaceMesh(assetPath)
            -- elseif assetType == "skin" then
            --     printAndOutput("Setting Skin Parameter...", OutputDevice)
            --     local parameterName = Parameters[3]
            --     local value = tonumber(Parameters[4])
            --     if not parameterName or not value then
            --         printAndOutput("Invalid parameters. Usage: rmu set skin <parameterName> <value>", OutputDevice)
            --         return false
            --     end
            --     SetSkinParameter(parameterName, value)
            -- elseif assetType == "color" then
            --     printAndOutput("Setting Skin Color Parameter...", OutputDevice)
            --     local parameterName = Parameters[3]
            --     local r = tonumber(Parameters[4])
            --     local g = tonumber(Parameters[5])
            --     local b = tonumber(Parameters[6])
            --     local a = tonumber(Parameters[7])
            --     if not parameterName or not r or not g or not b or not a then
            --         printAndOutput("Invalid parameters. Usage: rmu set color <parameterName> <r> <g> <b> <a>", OutputDevice)
            --         return false
            --     end
            --     SetSkinColorParameter(parameterName, { R = r, G = g, B = b, A = a })
            -- elseif assetType == "sex" then
            --     printAndOutput("Setting Sex...", OutputDevice)
            --     local sex = Parameters[3]
            --     if not sex then
            --         printAndOutput("Invalid parameters. Usage: rmu set sex <sex>", OutputDevice)
            --         return false
            --     end
            --     SetSex(sex)
            -- elseif assetType == "senescence" then
            --     printAndOutput("Setting Senescence Level...", OutputDevice)
            --     local value = tonumber(Parameters[3])
            --     if not value then
            --         printAndOutput("Invalid parameters. Usage: rmu set senescence <value>", OutputDevice)
            --         return false
            --     end
            --     SetSenescenceValue(value)
            -- elseif assetType == "race" then
            --     printAndOutput("Setting Race...", OutputDevice)
            --     SetRace(assetPath)
            -- elseif assetType == "preset" then
            --     printAndOutput("Setting preset...", OutputDevice)
            --     SetPreset(assetPath)
            -- elseif assetType == "character" then
            --     printAndOutput("Setting character...", OutputDevice)
            --     SetCharacter(assetPath)
            -- elseif assetType == "body" then
            --     printAndOutput("Setting body...", OutputDevice)
            --     SetBodySectionsOnMesh(assetPath)
            -- elseif assetType == "test" then
            --     printAndOutput("testing...", OutputDevice)
            --     RunTest(assetPath)
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
        else
            printAndOutput("Unknown command. Use 'rmu help' for a list of commands.\n", OutputDevice)
        end


-- end)
    return true
end)


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

-- function SetBaseFaceMesh(assetPath)
--     ExecuteInGameThread(function()
--         local VPhenotypeCustomizationSession = FindFirstOf("VPhenotypeCustomizationSession")
--         if not VPhenotypeCustomizationSession or not VPhenotypeCustomizationSession:IsValid() then
--             print("No instance of class 'VPhenotypeCustomizationSession' was found.")
--             return
--         end

--         local FaceMesh = LoadAsset(assetPath)
--         if not FaceMesh or not FaceMesh:IsValid() then
--             print("Failed to load face mesh asset: " .. assetPath)
--             return
--         end

--         print("Setting Base Face Mesh: " .. tostring(FaceMesh:GetFullName()))
--         VPhenotypeCustomizationSession:SetFaceBaseMesh(FaceMesh, true)
--     end)
-- end

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


-- function SetPreset(assetPath)
--     ExecuteInGameThread(function()
--         local VPhenotypeCustomizationSession = FindFirstOf("VPhenotypeCustomizationSession")
--         if not VPhenotypeCustomizationSession or not VPhenotypeCustomizationSession:IsValid() then
--             print("No instance of class 'VPhenotypeCustomizationSession' was found.")
--             return
--         end

--         local Preset = LoadAsset(assetPath)
--         if not Preset or not Preset:IsValid() then
--             print("Failed to load preset asset: " .. assetPath)
--             return
--         end

--         print("Setting Preset: " .. tostring(Preset:GetFullName()))
--         VPhenotypeCustomizationSession:ResetCharacterToPreset(Preset)
--     end)
-- end


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
    end)
end


-- function SetSkinColorParameter(parameterName, color)
--     ExecuteInGameThread(function()
--         local VPhenotypeCustomizationSession = FindFirstOf("VPhenotypeCustomizationSession")
--         if not VPhenotypeCustomizationSession or not VPhenotypeCustomizationSession:IsValid() then
--             print("No instance of class 'VPhenotypeCustomizationSession' was found.")
--             return
--         end

--         keyFName = FName(parameterName)
--         if not keyFName then
--             print("Failed to create FName from key: " .. tostring(parameterName))
--             return
--         end

--         print("Setting Skin Color Parameter: " .. tostring(keyFName) .. " = " .. tostring(color.R) .. ", " .. tostring(color.G) .. ", " .. tostring(color.B) .. ", " .. tostring(color.A))
--         VPhenotypeCustomizationSession:SetSkinColorParameter(keyFName, color, true)
--     end)
-- end


-- function SetSex(sex)
--     ExecuteInGameThread(function()
--         local VPhenotypeCustomizationSession = FindFirstOf("VPhenotypeCustomizationSession")
--         if not VPhenotypeCustomizationSession or not VPhenotypeCustomizationSession:IsValid() then
--             print("No instance of class 'VPhenotypeCustomizationSession' was found.")
--             return
--         end

--         print("Setting Sex: " .. tostring(sex))
--         VPhenotypeCustomizationSession:SetSex(sex, true)
--     end)
-- end


-- function SetSenescenceValue(value)
--     ExecuteInGameThread(function()
--         local VPhenotypeCustomizationSession = FindFirstOf("VPhenotypeCustomizationSession")
--         if not VPhenotypeCustomizationSession or not VPhenotypeCustomizationSession:IsValid() then
--             print("No instance of class 'VPhenotypeCustomizationSession' was found.")
--             return
--         end

--         print("Setting Senescence Value: " .. tostring(value))
--         VPhenotypeCustomizationSession:SetSenescenceValue(value, true)
--     end)
-- end


-- function SetRace(race)
--     ExecuteAsync(function()

--         -- local VPhenotypeCustomizationSession = FindFirstOf("VPhenotypeCustomizationSession")
--         -- if not VPhenotypeCustomizationSession or not VPhenotypeCustomizationSession:IsValid() then
--         --     print("No instance of class 'VPhenotypeCustomizationSession' was found.")
--         --     return
--         -- end

--         -- print("Setting Race: " .. tostring(race))
--         -- local RaceAsset = LoadAsset(race)
--         -- if not RaceAsset or not RaceAsset:IsValid() then
--         --     print("Failed to load race asset: " .. race)
--         --     return
--         -- end

--         -- VPhenotypeCustomizationSession:SetRace(RaceAsset, true)


--         local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
--         if not BP_OblivionPlayerCharacter_C
--         then
--             print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
--             return
--         end
--         -- local VCharacterPhenotypeData = BP_OblivionPlayerCharacter_C.PhenotypeData
--         -- -- local VCharacterPhenotypeData = getCharacterPhenotypeData()
--         -- if not VCharacterPhenotypeData then
--         --     print("No instance of 'VCharacterPhenotypeData' was found.\n")
--         --     return
--         -- end


--         ExecuteInGameThread(function()
--             local RaceAsset = LoadAsset(race)
--             if not RaceAsset or not RaceAsset:IsValid() then
--                 print("Failed to load race asset: " .. race)
--                 return
--             end
--             BP_OblivionPlayerCharacter_C:SetRace(RaceAsset)
--         end)

--         print("loaded " .. race)

        
       
--         BP_OblivionPlayerCharacter_C:RefreshAppearance(15)

--     end)
-- end

-- function SetBodySectionsOnMesh(assetPath)
--     ExecuteInGameThread(function()

--         local BP_OblivionPlayerCharacter_C = FindFirstOf("BP_OblivionPlayerCharacter_C")
--         if not BP_OblivionPlayerCharacter_C
--         then
--             print("No instance of 'BP_OblivionPlayerCharacter_C' was found.\n")
--             return
--         end

--         local Race = LoadAsset(assetPath)
--         if not Race or not Race:IsValid() then
--             print("Failed to load SkeletonAsset asset: " .. assetPath)
--             return
--         end


--         Race.FullBody

--         BP_OblivionPlayerCharacter_C:SetBodySectionsOnMesh(SkeletonAsset)
        
--         BP_OblivionPlayerCharacter_C:RefreshAppearance(15)
--     end)
-- end


-- function SetFaceMaterial(MaterialSlotName, Material)
--     ExecuteInGameThread(function()
--         local VPhenotypeCustomizationSession = FindFirstOf("VPhenotypeCustomizationSession")
--         if not VPhenotypeCustomizationSession or not VPhenotypeCustomizationSession:IsValid() then
--             print("No instance of class 'VPhenotypeCustomizationSession' was found.")
--             return
--         end

--         local MaterialAsset = LoadAsset(Material)
--         if not Material or not Material:IsValid() then
--             print("No instance of Material: " .. Material)
--             return
--         end
    

--         UVPhenotypeCustomizationSession:SetFaceSkinMaterial(MaterialSlotName, MaterialAsset, true)
--     end)
-- end

-- function SetCharacter(AVPairedCharacter)
--     ExecuteInGameThread(function()
--         local VPhenotypeCustomizationSession = FindFirstOf("VPhenotypeCustomizationSession")
--         if not VPhenotypeCustomizationSession or not VPhenotypeCustomizationSession:IsValid() then
--             print("No instance of class 'VPhenotypeCustomizationSession' was found.")
--             return
--         end

--         local character = LoadAsset(AVPairedCharacter)
--         if not character or not character:IsValid() then
--             print("Failed to load character asset: " .. AVPairedCharacter)
--             return
--         end

--         VPhenotypeCustomizationSession:StartFromCharacter(character, true)

--     end)
-- end


function LoadJson(name)
    local filePath = presetLocation .. name .. ".json"
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

-- function RunTest(assetPath)
--     ExecuteAsync(function()
--         local data = LoadJson(assetPath)
--         LoadPhenotypeDataFields(data)
--     end)
-- end



-- ---@class UVCharacterPhenotypeData : UVBaseAltarSaveData
-- ---@field FaceMorphsSource UVCharacterFaceMorphsSource
-- ---@field FaceBaseMesh USkeletalMesh
-- ---@field FaceMorphValuesMap TMap<FName, float>
-- ---@field Hair UVCharacterHairPiece_Hair
-- ---@field CustomisationHairIndex int32
-- ---@field Eyebrows UVCharacterHairPiece_Eyebrows
-- ---@field CustomisationEyebrowsIndex int32
-- ---@field Mustache UVCharacterHairPiece_Mustache
-- ---@field CustomisationMustacheIndex int32
-- ---@field Beard UVCharacterHairPiece_Beard
-- ---@field CustomisationBeardIndex int32
-- ---@field HairColors TMap<EVFacialHairType, FColor>
-- ---@field HairColorsL TMap<EVFacialHairType, FLinearColor>
-- ---@field SkinParameterDefinitions UVCharacterSkinParameterDefinitions
-- ---@field BodyProperties FBodyProperties
-- ---@field FaceMaterialSlotOverrides TMap<FName, UMaterialInterface>
-- ---@field SkinParametersMap TMap<FName, float>
-- ---@field SkinColorsMap TMap<FName, FColor>
-- ---@field SkinColorsMapL TMap<FName, FLinearColor>
-- ---@field SenescenceLevel int32
-- ---@field EyeMaterial UMaterialInterface
-- ---@field CustomisationEyeMaterialIndex int32
-- UVCharacterPhenotypeData = {}


-- ---@class AVPairedCharacter : AVPairedPawn
-- ---@field DockWarpTargetName FName
-- ---@field Race UTESRace
-- ---@field Sex ECharacterSex
-- ---@field VoiceType EVVoiceType
-- ---@field OnCharacterRaceChanged FVPairedCharacterOnCharacterRaceChanged
-- ---@field OnCharacterSexChanged FVPairedCharacterOnCharacterSexChanged
-- ---@field OnAppearanceRefreshedEnd FVPairedCharacterOnAppearanceRefreshedEnd
-- ---@field bUseDefaultRaceAndSexPreset boolean
-- ---@field PhenotypeData UVCharacterPhenotypeData
-- ---@field HumanoidHeadComponent UVHumanoidHeadComponent
-- ---@field HeadwearChildActorComponent UChildActorComponent
-- ---@field UpperBodyChildActorComponent UChildActorComponent
-- ---@field LowerBodyChildActorComponent UChildActorComponent
-- ---@field HandsChildActorComponent UChildActorComponent
-- ---@field FeetChildActorComponent UChildActorComponent
-- ---@field AmuletChildActorComponent UChildActorComponent
-- ---@field RightRingChildActorComponent UChildActorComponent
-- ---@field LeftRingChildActorComponent UChildActorComponent
-- ---@field CharacterBodyPairingComponent UVCharacterBodyPairingComponent
-- ---@field DockingPairingComponent UVDockingPairingComponent
-- ---@field HumanoidMotionWarpingComponent UMotionWarpingComponent
-- ---@field CharacterAppearancePairingComponent UVCharacterAppearancePairingComponent
-- ---@field EmotionBlendValueMultiplier float
-- ---@field bHasUndockingQueued boolean
-- ---@field InitialEquipmentMap TMap<EBipedModularBodySlot, FInitialEquipmentInfo>
-- ---@field RefreshMergedMeshTimerHandle FTimerHandle
-- AVPairedCharacter = {}


-- function AVPairedCharacter:WarpToDockingPosition() end
-- ---@param Timeout float
-- function AVPairedCharacter:WaitForRefreshAppearanceToComplete(Timeout) end
-- function AVPairedCharacter:UpdateRaceAudioSwitch() end
-- function AVPairedCharacter:UpdateGenderAudioSwitch() end
-- ---@param bUpdatePairedDockingState boolean
-- ---@param bSnapToMarker boolean
-- function AVPairedCharacter:SnapToStandingPosition(bUpdatePairedDockingState, bSnapToMarker) end
-- ---@param NewVoiceType EVVoiceType
-- function AVPairedCharacter:SetVoiceType(NewVoiceType) end
-- ---@param NewSex ECharacterSex
-- function AVPairedCharacter:SetSex(NewSex) end
-- ---@param NewRace UTESRace
-- function AVPairedCharacter:SetRace(NewRace) end
-- ---@param Components USkeletalMeshComponent
-- function AVPairedCharacter:SetBodySectionsOnMesh(Components) end
-- ---@param Selector EVCharacterRefreshSelector
-- function AVPairedCharacter:RefreshAppearanceAsync(Selector) end
-- ---@param Selector EVCharacterRefreshSelector
-- function AVPairedCharacter:RefreshAppearance(Selector) end
-- function AVPairedCharacter:ProcessPendingUndockingRequest() end
-- ---@param bIsWeaponDrawn boolean
-- function AVPairedCharacter:OnWeaponDrawnStateChanged(bIsWeaponDrawn) end
-- function AVPairedCharacter:OnStartDockingToHorse() end
-- function AVPairedCharacter:OnRaceOrSexChanged() end
-- ---@param Montage UAnimMontage
-- ---@param bInterrupted boolean
-- function AVPairedCharacter:OnFacialAnimationMontageDone(Montage, bInterrupted) end
-- ---@param Slot EBipedModularBodySlot
-- ---@param Properties FVCharacterBodyPartProperties
-- function AVPairedCharacter:OnBodyPartPropertiesChanged(Slot, Properties) end
-- ---@return boolean
-- function AVPairedCharacter:IsInDockingProcess() end
-- ---@return boolean
-- function AVPairedCharacter:IsDocked() end
-- ---@return boolean
-- function AVPairedCharacter:InitializeAppearanceFromForm() end
-- ---@return EVVoiceType
-- function AVPairedCharacter:GetVoiceType() end
-- ---@return AActor
-- function AVPairedCharacter:GetUsedDockActor() end
-- ---@return ECharacterSex
-- function AVPairedCharacter:GetSex() end
-- ---@return UTESRace
-- function AVPairedCharacter:GetRace() end
-- ---@return TMap<EBipedModularBodySlot, UTESForm>
-- function AVPairedCharacter:GetInitialEquipmentMap() end
-- ---@return AVPairedCreature
-- function AVPairedCharacter:GetHorse() end
-- ---@param Slot EBipedModularBodySlot
-- ---@return UChildActorComponent
-- function AVPairedCharacter:GetChildActorFromSlot(Slot) end
-- ---@param Names TArray<FName>
-- ---@return TMap<FName, float>
-- function AVPairedCharacter:GetBonesScale(Names) end
-- ---@param Name FName
-- ---@return float
-- function AVPairedCharacter:GetBoneScale(Name) end
-- ---@return EVBloodColor
-- function AVPairedCharacter:GetBloodColor() end
-- ---@param bSnapTransform boolean
-- function AVPairedCharacter:FinishDockingToRequestedDockActor(bSnapTransform) end
-- function AVPairedCharacter:ClearAllDockingTags() end
-- function AVPairedCharacter:CallTextureEffectBroadcastDelegate() end
-- ---@param Slot EBipedModularBodySlot
-- ---@param Properties FVCharacterBodyPartProperties
-- function AVPairedCharacter:ApplyBodyPartPropertiesToChildActor(Slot, Properties) end


-- ---@class UVPhenotypeCustomizationSession : UObject
-- ---@field LinkedCharacter AVPairedCharacter
-- ---@field Filter EVCharacterPhenotypeDataFilter
-- UVPhenotypeCustomizationSession = {}

-- ---@param InWorld UWorld
-- function UVPhenotypeCustomizationSession:StartFromScratch(InWorld) end
-- ---@param Character AVPairedCharacter
-- ---@param DestroyCharacterOnSessionEnd boolean
-- function UVPhenotypeCustomizationSession:StartFromCharacter(Character, DestroyCharacterOnSessionEnd) end
-- ---@param ParameterName FName
-- ---@param Value float
-- ---@param bShouldRefreshCharacter boolean
-- function UVPhenotypeCustomizationSession:SetSkinParameter(ParameterName, Value, bShouldRefreshCharacter) end
-- ---@param ParameterName FName
-- ---@param Value FColor
-- ---@param bShouldRefreshCharacter boolean
-- function UVPhenotypeCustomizationSession:SetSkinColorParameter(ParameterName, Value, bShouldRefreshCharacter) end
-- ---@param Sex ECharacterSex
-- ---@param bShouldRefreshCharacter boolean
-- function UVPhenotypeCustomizationSession:SetSex(Sex, bShouldRefreshCharacter) end
-- ---@param NewValue int32
-- ---@param bShouldRefreshCharacter boolean
-- function UVPhenotypeCustomizationSession:SetSenescenceValue(NewValue, bShouldRefreshCharacter) end
-- ---@param NewRace UTESRace
-- ---@param bShouldRefreshCharacter boolean
-- function UVPhenotypeCustomizationSession:SetRace(NewRace, bShouldRefreshCharacter) end
-- ---@param HairType EVFacialHairType
-- ---@param HairPiece UVCharacterHairPieceBase
-- ---@param CustomisationIndex int32
-- ---@param bShouldRefreshCharacter boolean
-- function UVPhenotypeCustomizationSession:SetHairPiece(HairType, HairPiece, CustomisationIndex, bShouldRefreshCharacter) end
-- ---@param MaterialSlotName FName
-- ---@param Material UMaterialInterface
-- ---@param bShouldRefreshCharacter boolean
-- function UVPhenotypeCustomizationSession:SetFaceSkinMaterial(MaterialSlotName, Material, bShouldRefreshCharacter) end
-- ---@param Name FName
-- ---@param Value float
-- ---@param bShouldRefreshCharacter boolean
-- function UVPhenotypeCustomizationSession:SetFaceMorphAxisValue(Name, Value, bShouldRefreshCharacter) end
-- ---@param FaceBaseMesh USkeletalMesh
-- ---@param bShouldRefreshCharacter boolean
-- function UVPhenotypeCustomizationSession:SetFaceBaseMesh(FaceBaseMesh, bShouldRefreshCharacter) end
-- ---@param Material UMaterialInterface
-- ---@param CustomisationIndex int32
-- ---@param bShouldRefreshCharacter boolean
-- function UVPhenotypeCustomizationSession:SetEyeMaterial(Material, CustomisationIndex, bShouldRefreshCharacter) end
-- ---@param Preset UVCharacterPhenotypePreset
-- function UVPhenotypeCustomizationSession:ResetCharacterToPreset(Preset) end
-- function UVPhenotypeCustomizationSession:RefreshCharacter() end
-- function UVPhenotypeCustomizationSession:EndSession() end

-- /Game/Dev/Phenotypes/PhenotypePreset_Dremora_f.PhenotypePreset_Dremora_f
-- "/Game/Forms/actors/race/Dremora.Dremora"


-- ---@param InPhysicsAsset UPhysicsAsset
-- function UGroomComponent:SetPhysicsAsset(InPhysicsAsset) end
-- ---@param InMeshDeformer UMeshDeformer
-- function UGroomComponent:SetMeshDeformer(InMeshDeformer) end
-- ---@param bEnable boolean
-- function UGroomComponent:SetHairLengthScaleEnable(bEnable) end
-- ---@param Scale float
-- function UGroomComponent:SetHairLengthScale(Scale) end
-- ---@param Asset UGroomAsset
-- function UGroomComponent:SetGroomAsset(Asset) end
-- ---@param bInEnableSimulation boolean
-- function UGroomComponent:SetEnableSimulation(bInEnableSimulation) end
-- ---@param InBinding UGroomBindingAsset
-- function UGroomComponent:SetBindingAsset(InBinding) end
-- function UGroomComponent:ResetSimulation() end
-- function UGroomComponent:ResetCollisionComponents() end
-- ---@param GroupIndex int32
-- ---@return UNiagaraComponent
-- function UGroomComponent:GetNiagaraComponent(GroupIndex) end
-- ---@return boolean
-- function UGroomComponent:GetIsHairLengthScaleEnabled() end
-- ---@param SkeletalMeshComponent USkeletalMeshComponent
-- function UGroomComponent:AddCollisionComponent(SkeletalMeshComponent) end


-- function AVPairedCharacter:WarpToDockingPosition() end
-- ---@param Timeout float
-- function AVPairedCharacter:WaitForRefreshAppearanceToComplete(Timeout) end
-- function AVPairedCharacter:UpdateRaceAudioSwitch() end
-- function AVPairedCharacter:UpdateGenderAudioSwitch() end
-- ---@param bUpdatePairedDockingState boolean
-- ---@param bSnapToMarker boolean
-- function AVPairedCharacter:SnapToStandingPosition(bUpdatePairedDockingState, bSnapToMarker) end
-- ---@param NewVoiceType EVVoiceType
-- function AVPairedCharacter:SetVoiceType(NewVoiceType) end
-- ---@param NewSex ECharacterSex
-- function AVPairedCharacter:SetSex(NewSex) end
-- ---@param NewRace UTESRace
-- function AVPairedCharacter:SetRace(NewRace) end
-- ---@param Components USkeletalMeshComponent
-- function AVPairedCharacter:SetBodySectionsOnMesh(Components) end
-- ---@param Selector EVCharacterRefreshSelector
-- function AVPairedCharacter:RefreshAppearanceAsync(Selector) end
-- ---@param Selector EVCharacterRefreshSelector
-- function AVPairedCharacter:RefreshAppearance(Selector) end
-- function AVPairedCharacter:ProcessPendingUndockingRequest() end
-- ---@param bIsWeaponDrawn boolean
-- function AVPairedCharacter:OnWeaponDrawnStateChanged(bIsWeaponDrawn) end
-- function AVPairedCharacter:OnStartDockingToHorse() end
-- function AVPairedCharacter:OnRaceOrSexChanged() end
-- ---@param Montage UAnimMontage
-- ---@param bInterrupted boolean
-- function AVPairedCharacter:OnFacialAnimationMontageDone(Montage, bInterrupted) end
-- ---@param Slot EBipedModularBodySlot
-- ---@param Properties FVCharacterBodyPartProperties
-- function AVPairedCharacter:OnBodyPartPropertiesChanged(Slot, Properties) end
-- ---@return boolean
-- function AVPairedCharacter:IsInDockingProcess() end
-- ---@return boolean
-- function AVPairedCharacter:IsDocked() end
-- ---@return boolean
-- function AVPairedCharacter:InitializeAppearanceFromForm() end
-- ---@return EVVoiceType
-- function AVPairedCharacter:GetVoiceType() end
-- ---@return AActor
-- function AVPairedCharacter:GetUsedDockActor() end
-- ---@return ECharacterSex
-- function AVPairedCharacter:GetSex() end
-- ---@return UTESRace
-- function AVPairedCharacter:GetRace() end
-- ---@return TMap<EBipedModularBodySlot, UTESForm>
-- function AVPairedCharacter:GetInitialEquipmentMap() end
-- ---@return AVPairedCreature
-- function AVPairedCharacter:GetHorse() end
-- ---@param Slot EBipedModularBodySlot
-- ---@return UChildActorComponent
-- function AVPairedCharacter:GetChildActorFromSlot(Slot) end
-- ---@param Names TArray<FName>
-- ---@return TMap<FName, float>
-- function AVPairedCharacter:GetBonesScale(Names) end
-- ---@param Name FName
-- ---@return float
-- function AVPairedCharacter:GetBoneScale(Name) end
-- ---@return EVBloodColor
-- function AVPairedCharacter:GetBloodColor() end
-- ---@param bSnapTransform boolean
-- function AVPairedCharacter:FinishDockingToRequestedDockActor(bSnapTransform) end
-- function AVPairedCharacter:ClearAllDockingTags() end
-- function AVPairedCharacter:CallTextureEffectBroadcastDelegate() end
-- ---@param Slot EBipedModularBodySlot
-- ---@param Properties FVCharacterBodyPartProperties
-- function AVPairedCharacter:ApplyBodyPartPropertiesToChildActor(Slot, Properties) end
