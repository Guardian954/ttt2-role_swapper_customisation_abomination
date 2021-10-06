local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[SWAPPER.name] = "Swapper"
L["info_popup_" .. SWAPPER.name] = [[You are the swapper, now go get killed!]]
L["body_found_" .. SWAPPER.abbr] = "They were a Swapper!?"
L["search_role_" .. SWAPPER.abbr] = "This person was a Swapper!?"
L["target_" .. SWAPPER.name] = "Swapper"
L["ttt2_desc_" .. SWAPPER.name] = [[The swapper is a Jester role that will steal its killers identity when killed and resurrect their killer as the new swapper!]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_role_swapper_respawn_opposite"] = "You were killed but will respawn with a random opposite role of your killer: {role}!"
L["ttt2_role_swapper_respawn_same"] = "You were killed but will respawn with the role of your killer: {role}!"
L["ttt2_role_swapper_respawn_dead"] = "You were killed and unfortunately you rolled death so you wont resurrect :("
L["ttt2_role_swapper_killer_respawn_false"] = "You killed the Swapper and must now pay with your life >:( "
L["ttt2_role_swapper_killer_respawn_true"] = "You killed the Swapper and must now live in their shoes with {hp} health!"