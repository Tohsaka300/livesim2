-- LLPractice beatmap loader
-- Part of Live Simulator: 2
-- See copyright notice in main.lua

local AquaShine, NoteLoader = ...
local JSON = require("JSON")

local LLPBeatmap = {
	Name = "LLPractice Beatmap",
	Extension = "llp"	-- Please rename the extension from .json to .llp to prevent confusion of SIF beatmap
}

--! @brief Loads LLPractice beatmap
--! @param file Table contains:
--!        - path relative to DEPLS save dir
--!        - absolute path
--!        - forward slashed and not contain trailing slash
--! @returns table with these data
--!          - notes_list is the SIF-compilant notes data
--!          - song_file is the song file handle (Source object) or nil
--! @note Modify `LLP_SIFT_DEFATTR` config to change default attribute
function LLPBeatmap.Load(file)
	local llp = JSON:decode(love.filesystem.read(file[1]..".llp"))
	local attribute = AquaShine.LoadConfig("LLP_SIFT_DEFATTR", 10)	-- Rainbow is default attribute
	local sif_map = {}
	
	for n, v in ipairs(llp.lane) do
		for a, b in ipairs(v) do
			local new_effect = 1
			local new_effect_val = 2
			
			if b.longnote then
				new_effect = 3
				new_effect_val = (b.endtime - b.starttime) / 1000
			end
			
			sif_map[#sif_map + 1] = {
				timing_sec = b.starttime / 1000,
				notes_attribute = attribute or 1,
				notes_level = 1,
				effect = new_effect,
				effect_value = new_effect_val,
				position = 9 - b.lane
			}
		end
	end
	
	table.sort(sif_map, function(a, b) return a.timing_sec < b.timing_sec end)
	
	return {
		notes_list = sif_map,
		song_file = AquaShine.LoadAudio("audio/"..llp.audiofile..".wav")
	}
end

return LLPBeatmap
