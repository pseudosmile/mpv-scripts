local script_enabled = true
local skip_categories = "sponsor,selfpromo,interaction,intro,filler,preview"


--DO NOT EDIT ANYTHING BELOW THIS LINE, UNLESS YOU KNOW WHAT YOU ARE DOING!

local sponsorblock_categories = {
    ["sponsor"] = "Sponsor",
    ["selfpromo"] = "Unpaid/Self Promotion",
    ["interaction"] = "Interaction Reminder",
    ["intro"] = "Intermission/Intro Animation",
    ["outro"] = "Endcards/Credits",
    ["preview"] = "Preview/Recap",
    ["music_offtopic"] = "Non-Music",
    ["filler"] = "Filler"
}

local seg_table = {}
local seg_table_count = 0

function skip_segments(name, pos)

    if pos == nil or seg_table_count == 0 then return end

    for i = 1, seg_table_count do
        seg_start = seg_table[i][1]
        seg_end = seg_table[i][2]

        if pos >= seg_start and pos < seg_end then
            mp.set_property("time-pos", seg_end)
        end
    end
    
end

function file_loaded()

    chapter_list = mp.get_property_native("chapter-list")
    chapter_list_count = #chapter_list

    seg_table = {}
    seg_table_count = 0

    start_defined = false
    range_start = 0
    for i = 1, chapter_list_count do
        chapter = chapter_list[i]
        chapter_title = chapter["title"]
        chapter_time = chapter["time"]

        should_skip = false

        for category in string.gmatch(skip_categories, "([^,]+)") do
            if chapter_title:match("%[SponsorBlock]: "..sponsorblock_categories[category]) then
                should_skip = true
                break
            end
        end

        if should_skip then
            if start_defined == false then
                range_start = chapter_time
                start_defined = true
            end
        else
            if start_defined then
                seg_table[seg_table_count+1] = {range_start, chapter_time}
                seg_table_count = seg_table_count + 1
    
                range_start = 0
                start_defined = false
            end
        end

        if i == chapter_list_count and start_defined then
            seg_table[seg_table_count+1] = {range_start, mp.get_property_native("duration")}
            seg_table_count = seg_table_count + 1
    
            range_start = 0
            start_defined = false
        end
    end

end

if script_enabled then
    if skip_categories ~= "" then
        selftestpassed = true

        for category in string.gmatch(skip_categories, "([^,]+)") do
            validcategoryfound = false
            
            for valid_category in pairs(sponsorblock_categories) do
                if valid_category == category then
                    validcategoryfound = true
                    break
                end
            end

            if validcategoryfound == false then
                selftestpassed = false
                break
            end
        end

        if selftestpassed then
            mp.observe_property("time-pos", "native", skip_segments)
            mp.register_event("file-loaded", file_loaded)
        else
            error("Invalid skip category specified in skip categories! Please fix the skip categories and run mpv again.")
        end
    else
        error("No skip categories specified! Please fix the skip categories and run mpv again.")
    end
end