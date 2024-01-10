local oldspeed = 1
local speed = 1


local function resetfastforwardspeed()
    speed = 1
    mp.osd_message("FF: Speed reset!")
end

mp.register_script_message("fastforwardresetspeed", resetfastforwardspeed)


local function addfastforwardspeed(value)
    speed = speed + value
    mp.osd_message("FF: Speed set to "..speed.."x")
end

mp.register_script_message("fastforwardaddspeed", addfastforwardspeed)


local function fastforward(table)
    if table == nil then return end

    if table["event"] == "down" then
        oldspeed = mp.get_property_native("speed")
        mp.set_property_native("speed", speed)
        mp.osd_message("FF: "..speed.."x")
    elseif table["event"] == "up" then
        mp.set_property_native("speed", oldspeed)
        mp.osd_message("FF: "..oldspeed.."x")
    end
end

mp.add_key_binding("ö", "fastforward", fastforward, {repeatable=false, complex=true})