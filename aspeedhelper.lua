local mp = require "mp"

local st2enabled = mp.get_property_native("speed") > 1
local rbenabled = mp.get_property_native("speed") < 1

local function GetAudioFilterTable()
    local aft = mp.get_property_native("af", {})
    return aft, #aft
end

local function ChangeAudioFilterParams(afname, aflabel, afenabled, afparamt)
    local aft, aftc = GetAudioFilterTable()

    if aft == nil or aftc == 0 then return end

    for i = 1, aftc do
        if aft[i].name == afname and aft[i].label == aflabel then
            aft[i].enabled = afenabled
            if not afparamt == nil then
                aft[i].params = afparamt
            end
            break
        end
    end

    mp.set_property_native("af", aft)
end

local function AddAudioFilter(afname, aflabel, afenabled, afparamt)
    local aft, aftc = GetAudioFilterTable()

    local alreadyexists = false
    for i = 1, aftc do
        if aft[i].name == afname and aft[i].label == aflabel then
            alreadyexists = true
            break
        end
    end

    if alreadyexists == true then return end

    aft[aftc+1] = {
        name = afname,
        label = aflabel,
        enabled = afenabled,
        params = afparamt,
    }

    mp.set_property_native("af", aft)
end

local function PrintAudioFilterInfo(afname, aflabel)
    local aft, aftc = GetAudioFilterTable()

    if aft == nil or aftc == 0 then return end

    for i = 1, aftc do
        if aft[i].name == afname and aft[i].label == aflabel then
            print("Name: "..tostring(aft[i].name).." | Label: "..tostring(aft[i].label).." | Enabled: "..tostring(aft[i].enabled))
            local afparamst = aft[i].params
            --if not #afparamst == 0 then
                print("Parameters:")
                for i2 = 1, #afparamst do
                    print(tostring(afparamst[i2]))
                end
            --end
            break
        end
    end
end

local function AudioFilterExists(afname)
    local aft, aftc = GetAudioFilterTable()

    if aft == nil or aftc == 0 then return false end

    local exists = false
    for i = 1, aftc do
        if aft[i].name == afname then
            exists = true
            break
        end
    end

    return exists
end

local function AudioFilterExistsWithLabel(afname, aflabel)
    local aft, aftc = GetAudioFilterTable()

    if aft == nil or aftc == 0 then return false end

    local exists = false
    for i = 1, aftc do
        if aft[i].name == afname and aft[i].label == aflabel then
            exists = true
            break
        end
    end

    return exists
end

local function ChangedSpeed(_, value)
    if mp.get_property_native("audio-pitch-correction") == false or value == 1 then
        if st2enabled then
            ChangeAudioFilterParams("scaletempo2", "st2", false, nil)
            st2enabled = false
        end
        if rbenabled then
            ChangeAudioFilterParams("rubberband", "rb", false, nil)
            rbenabled = false
        end
        return
    end

    if value > 1 then
        if rbenabled then
            ChangeAudioFilterParams("rubberband", "rb", false, nil)
            rbenabled = false
        end
        if not st2enabled then
            ChangeAudioFilterParams("scaletempo2", "st2", true, nil)
            st2enabled = true
        end
    else
        if st2enabled then
            ChangeAudioFilterParams("scaletempo2", "st2", false, nil)
            st2enabled = false
        end
        if not rbenabled then
            ChangeAudioFilterParams("rubberband", "rb", true, nil)
            rbenabled = true
        end
    end
end

if AudioFilterExists("scaletempo2") or AudioFilterExists("rubberband") then
    print("Filter(s) used by this script already exists in the filter chain!")
    print("This script may not work correctly!")
end

AddAudioFilter("scaletempo2", "st2", st2enabled, {["min-speed"]="0", ["max-speed"]="0"})
AddAudioFilter("rubberband", "rb", rbenabled, {channels="together"})

local function AudioPitchCorrection(_, value)
    if value == false then
        ChangeAudioFilterParams("scaletempo2", "st2", false, nil)
        ChangeAudioFilterParams("rubberband", "rb", false, nil)
    else
        ChangeAudioFilterParams("scaletempo2", "st2", mp.get_property_native("speed") > 1, nil)
        ChangeAudioFilterParams("rubberband", "rb", mp.get_property_native("speed") < 1, nil)
    end
end

mp.observe_property("speed", "number", ChangedSpeed)
mp.observe_property("audio-pitch-correction", "bool", AudioPitchCorrection)