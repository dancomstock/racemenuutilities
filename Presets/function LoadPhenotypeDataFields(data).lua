function LoadPhenotypeDataFields(data)
    local VCharacterPhenotypeData = getCharacterPhenotypeData()
    if not VCharacterPhenotypeData then
        print("No instance of 'VCharacterPhenotypeData' was found.\n")
        return
    end

    -- Assign FaceMorphsSource
    if data.FaceMorphsSource then
        VCharacterPhenotypeData.FaceMorphsSource = LoadAsset(data.FaceMorphsSource)
    end

    -- Assign FaceBaseMesh
    if data.FaceBaseMesh then
        VCharacterPhenotypeData.FaceBaseMesh = LoadAsset(data.FaceBaseMesh)
    end

    -- Assign FaceMorphValuesMap
    if data.FaceMorphValuesMap then
        VCharacterPhenotypeData.FaceMorphValuesMap = {}
        for key, value in pairs(data.FaceMorphValuesMap) do
            VCharacterPhenotypeData.FaceMorphValuesMap[FName(key)] = value
        end
    end

    -- Assign Hair
    if data.Hair then
        VCharacterPhenotypeData.Hair = LoadAsset(data.Hair)
    end
    if data.CustomisationHairIndex then
        VCharacterPhenotypeData.CustomisationHairIndex = data.CustomisationHairIndex
    end

    -- Assign Eyebrows
    if data.Eyebrows then
        VCharacterPhenotypeData.Eyebrows = LoadAsset(data.Eyebrows)
    end
    if data.CustomisationEyebrowsIndex then
        VCharacterPhenotypeData.CustomisationEyebrowsIndex = data.CustomisationEyebrowsIndex
    end

    -- Assign Mustache
    if data.Mustache then
        VCharacterPhenotypeData.Mustache = LoadAsset(data.Mustache)
    end
    if data.CustomisationMustacheIndex then
        VCharacterPhenotypeData.CustomisationMustacheIndex = data.CustomisationMustacheIndex
    end

    -- Assign Beard
    if data.Beard then
        VCharacterPhenotypeData.Beard = LoadAsset(data.Beard)
    end
    if data.CustomisationBeardIndex then
        VCharacterPhenotypeData.CustomisationBeardIndex = data.CustomisationBeardIndex
    end

    -- Assign HairColors
    if data.HairColors then
        VCharacterPhenotypeData.HairColors = {}
        for key, value in pairs(data.HairColors) do
            VCharacterPhenotypeData.HairColors[key] = FColor(value.R, value.G, value.B, value.A)
        end
    end

    -- Assign HairColorsL
    if data.HairColorsL then
        VCharacterPhenotypeData.HairColorsL = {}
        for key, value in pairs(data.HairColorsL) do
            VCharacterPhenotypeData.HairColorsL[key] = FLinearColor(value.R, value.G, value.B, value.A)
        end
    end

    -- Assign SkinParameterDefinitions
    if data.SkinParameterDefinitions then
        VCharacterPhenotypeData.SkinParameterDefinitions = LoadAsset(data.SkinParameterDefinitions)
    end

    -- Assign BodyProperties
    if data.BodyProperties and data.BodyProperties.BoneScalingMap then
        VCharacterPhenotypeData.BodyProperties = {}
        VCharacterPhenotypeData.BodyProperties.BoneScalingMap = {}
        for key, value in pairs(data.BodyProperties.BoneScalingMap) do
            VCharacterPhenotypeData.BodyProperties.BoneScalingMap[FName(key)] = value
        end
    end

    -- Assign FaceMaterialSlotOverrides
    if data.FaceMaterialSlotOverrides then
        VCharacterPhenotypeData.FaceMaterialSlotOverrides = {}
        for key, value in pairs(data.FaceMaterialSlotOverrides) do
            VCharacterPhenotypeData.FaceMaterialSlotOverrides[FName(key)] = LoadAsset(value)
        end
    end

    -- Assign SkinParametersMap
    if data.SkinParametersMap then
        VCharacterPhenotypeData.SkinParametersMap = {}
        for key, value in pairs(data.SkinParametersMap) do
            VCharacterPhenotypeData.SkinParametersMap[FName(key)] = value
        end
    end

    -- Assign SkinColorsMap
    if data.SkinColorsMap then
        VCharacterPhenotypeData.SkinColorsMap = {}
        for key, value in pairs(data.SkinColorsMap) do
            VCharacterPhenotypeData.SkinColorsMap[FName(key)] = FColor(value.R, value.G, value.B, value.A)
        end
    end

    -- Assign SkinColorsMapL
    if data.SkinColorsMapL then
        VCharacterPhenotypeData.SkinColorsMapL = {}
        for key, value in pairs(data.SkinColorsMapL) do
            VCharacterPhenotypeData.SkinColorsMapL[FName(key)] = FLinearColor(value.R, value.G, value.B, value.A)
        end
    end

    -- Assign SenescenceLevel
    if data.SenescenceLevel then
        VCharacterPhenotypeData.SenescenceLevel = data.SenescenceLevel
    end

    -- Assign EyeMaterial
    if data.EyeMaterial then
        VCharacterPhenotypeData.EyeMaterial = LoadAsset(data.EyeMaterial)
    end
    if data.CustomisationEyeMaterialIndex then
        VCharacterPhenotypeData.CustomisationEyeMaterialIndex = data.CustomisationEyeMaterialIndex
    end

    print("Phenotype data loaded into VCharacterPhenotypeData.")
end