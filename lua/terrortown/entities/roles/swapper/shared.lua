if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_swa.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(245, 48, 155, 255)

	self.abbr = "swa" -- abbreviation
	self.radarColor = Color(245, 48, 155) -- color if someone is using the radar
	self.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
	self.scoreKillsMultiplier = 1 -- multiplier for kill of player of another team
	self.scoreTeamKillsMultiplier = -8 -- multiplier for teamkill
	self.preventWin = true -- set true if role can't win (maybe because of own / special win conditions)
	self.defaultTeam = TEAM_JESTER -- the team name: roles with same team name are working together
	self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment

	self.conVarData = {
		pct = 0.15, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 5, -- minimum amount of players until this role is able to get selected
		credits = 1, -- the starting credits of a specific role
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		shopFallback = SHOP_DISABLED,
	}
end

hook.Add("TTTUlxDynamicRCVars", "TTTUlxDynamicSwaCVars", function(tbl)
	tbl[ROLE_SWAPPER] = tbl[ROLE_SWAPPER] or {}
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_entity_damage",
		checkbox = true,
		desc = "Can the swapper damage entities? (Def. 1)"
	})

	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_environmental_damage",
		checkbox = true,
		desc = "Can explode, burn, crush, fall, drown? (Def. 1)"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_respawn_health",
		slider = true,
		min = 0,
		max = 100,
		decimal = 0,
		desc = "Health swapper returns resurrects with (Def. 100)"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_respawn_delay",
		slider = true,
		min = 0,
		max = 60,
		decimal = 0,
		desc = "The respawn delay in seconds (Def. 0)"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_respawn_delay_post_death",
		checkbox = true,
		desc = "Should the respawn be delayed until the killer's death? (Def. 0)"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_dummy_cvar",
		slider = true,
		min = 0,
		max = 0,
		decimal = 0,
		desc = "###########################################################"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_dummy_cvar",
		slider = true,
		min = 0,
		max = 0,
		decimal = 0,
		desc = " # The following 2 settings affect the swappers killer"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_dummy_cvar",
		slider = true,
		min = 0,
		max = 0,
		decimal = 0,
		desc = " # Having more than 1 option below enabled will randomly - "
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_dummy_cvar",
		slider = true,
		min = 0,
		max = 0,
		decimal = 0,
		desc = " # - select between them whenever the Swapper dies."
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_killer_health",
		slider = true,
		min = 0,
		max = 100,
		decimal = 0,
		desc = "Health of swappers killer in new role (Def. 1)"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_killer_die",
		checkbox = true,
		desc = "Kill the swappers killer (Def. 0)"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_dummy_cvar",
		slider = true,
		min = 0,
		max = 0,
		decimal = 0,
		desc = "###########################################################"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_dummy_cvar",
		slider = true,
		min = 0,
		max = 0,
		decimal = 0,
		desc = " # The following settings affect the swapper when killed"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_dummy_cvar",
		slider = true,
		min = 0,
		max = 0,
		decimal = 0,
		desc = " # Having more than 1 option below enabled will randomly - "
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_dummy_cvar",
		slider = true,
		min = 0,
		max = 0,
		decimal = 0,
		desc = " # - select between them whenever the Swapper dies."
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_do_not_respawn",
		checkbox = true,
		desc = "Do not respawn the swapper (Def. 0)"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_respawn_same_team",
		checkbox = true,
		desc = "Should the swapper respawn in the same team? (Def. 1)"
	})
	table.insert(tbl[ROLE_SWAPPER], {
		cvar = "ttt2_swapper_respawn_opposite_team",
		checkbox = true,
		desc = "Should the swapper respawn in the opposite team? (Def. 0)"
	})

end)

if SERVER then
	-- When the Swapper dies, they [do not respawn, respawn as same role, respawn as opposite role], and the killer [dies, becomes a Jester, something else]
	-- General Swapper ConVars
	CreateConVar("ttt2_swapper_dummy_cvar", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_entity_damage", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_environmental_damage", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_respawn_delay", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_respawn_delay_post_death", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	-- Killer ConVars
	CreateConVar("ttt2_swapper_killer_health", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_killer_die", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	-- Swapper ConVars
	CreateConVar("ttt2_swapper_respawn_health", "100", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_do_not_respawn", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_respawn_same_team", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_respawn_opposite_team", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	

	local function SwapperRevive(ply, role)
		ply:Revive(GetConVar("ttt2_swapper_respawn_delay"):GetInt(), function()
			ply:SetHealth(GetConVar("ttt2_swapper_respawn_health"):GetInt())
			ply:SetRole(ply.newrole, ply.newteam)
			ply:ResetConfirmPlayer()

			SendFullStateUpdate()
		end)
	end

		-- Function to hand everyone their new weapons
	local function SwapWeapons(victim, attacker)
		-- Sort out the attacker first
		-- Strip all the attackers weapons
		for i = 1, #attacker.weapons do
			swapperRole.StripPlayerWeaponAndAmmo(attacker, attacker.weapons[i])
		end

		-- Give the attacker all their victims gear
		for i = 1, #victim.weapons do
			swapperRole.GivePlayerWeaponAndAmmo(attacker, victim.weapons[i])
		end
		attacker:SelectWeapon("weapon_zm_improvised")

		-- Next is the victim
		-- Strip all equipment from the victim
		for i = 1, #victim.weapons do
			local weapon = victim.weapons[i]
			swapperRole.StripPlayerWeaponAndAmmo(victim, weapon)
		end

		-- Give the victim all their attackers gear
		for i = 1, #attacker.weapons do
			local weapon = attacker.weapons[i]
			swapperRole.GivePlayerWeaponAndAmmo(victim, weapon)
		end
		victim:SelectWeapon("weapon_zm_improvised")

		timer.Simple(0.1, function()
			attacker.weapons = {}
			victim.weapons = {}
		end)
	end

	hook.Add("TTT2JesterModifyList", "AddSwapperToJesterList", function(jesterTable)
		local players = player.GetAll()

		for i = 1, #players do
			local ply = players[i]

			if ply:GetSubRole() ~= ROLE_SWAPPER then continue end

			jesterTable[#jesterTable + 1] = ply
		end
	end)

	-- Hide the swapper as a normal jester to the traitors
	hook.Add("TTT2SpecialRoleSyncing", "TTT2RoleSwapper", function(ply, tbl)
		if ply and not ply:HasTeam(TEAM_TRAITOR) or ply:GetSubRoleData().unknownTeam or GetRoundState() == ROUND_POST then return end

		for swapper in pairs(tbl) do
			if not swapper:IsTerror() or swapper == ply then continue end

			if ply:GetSubRole() ~= ROLE_SWAPPER and swapper:GetSubRole() == ROLE_SWAPPER then
				if not swapper:Alive() then continue end

				if ply:GetTeam() ~= TEAM_JESTER then
					tbl[swapper] = {ROLE_JESTER, TEAM_JESTER}
				else
					tbl[swapper] = {ROLE_SWAPPER, TEAM_JESTER}
				end
			end
		end
	end)

	hook.Add("TTT2ModifyRadarRole", "TTT2ModifyRadarRoleSwapper", function(ply, target)
		if ply:HasTeam(TEAM_TRAITOR) and target:GetSubRole() == ROLE_SWAPPER then
			return ROLE_JESTER, TEAM_JESTER
		end
	end)

	-- Swapper doesnt deal or take any damage in relation to players
	hook.Add("PlayerTakeDamage", "SwapperNoDamage", function(ply, inflictor, killer, amount, dmginfo)
		if swapperRole.ShouldTakeNoDamage(ply, killer, ROLE_SWAPPER) or swapperRole.ShouldDealNoDamage(ply, killer, ROLE_SWAPPER) then
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)

			return
		end
	end)

	-- Check if the swapper can damage entities or be damaged by environmental effects
	hook.Add("EntityTakeDamage", "SwapperEntityNoDamage", function(ply, dmginfo)
		if swapperRole.ShouldDealNoEntityDamage(ply, dmginfo, ROLE_SWAPPER) or swapperRole.ShouldTakeEnvironmentalDamage(ply, dmginfo, ROLE_SWAPPER) then
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)

			return
		end
	end)

	-- Grab the weapons tables before the player loses them
	hook.Add("DoPlayerDeath", "SwapperItemGrab", function(victim, attacker, dmginfo)
		if victim:GetSubRole() == ROLE_SWAPPER and IsValid(attacker) and attacker:IsPlayer() then
			victim.weapons = swapperRole.GetPlayerWeapons(victim)
			attacker.weapons = swapperRole.GetPlayerWeapons(attacker)
		end
	end)

	hook.Add("PlayerDeath", "SwapperDeath", function(victim, infl, attacker)
		if victim:GetSubRole() == ROLE_SWAPPER and IsValid(attacker) and attacker:IsPlayer() then
			if victim == attacker then return end -- Suicide so do nothing

			victim.newrole, victim.newteam = swapperRole.GetRespawnRole(victim, attacker)

			-- Handle the killers swap to his new life of swapper
			attacker:SetRole(ROLE_SWAPPER)
			local health = GetConVar("ttt2_swapper_killer_health"):GetInt()
			local outcome = swapperRole.GetKillerOutcome(killer)

			print("Outcome is: " ..tostring(outcome))

			if outcome == "dead" then
				attacker:Kill()
				LANG.Msg(attacker, "ttt2_role_swapper_killer_respawn_false", nil, MSG_MSTACK_ROLE)
			elseif outcome == "alive" then
				LANG.Msg(attacker, "ttt2_role_swapper_killer_respawn_true", {hp = health}, MSG_MSTACK_ROLE)
				attacker:SetHealth(health)
			elseif outcome == "none" then
				LANG.Msg(attacker, "ttt2_role_swapper_killer_respawn_true", {hp = health}, MSG_MSTACK_ROLE)
				attacker:SetHealth(1) 
			end
		
			attacker:PrintMessage(HUD_PRINTCENTER, "You killed the Swapper!")

			-- start the jester confetti
			net.Start("NewConfetti")
			net.WriteEntity(ply)
			net.Broadcast()

			if victim.newrole == dead then return end

			-- Handle the swappers new life as a new role
			if GetConVar("ttt2_swapper_respawn_delay_post_death"):GetBool() and health > 0 then
				hook.Add("PostPlayerDeath", "SwapperWaitForKillerDeath_" .. victim:SteamID64(), function(deadply)
					if not IsValid(attacker) or not IsValid(victim) then return end

					if deadply ~= attacker then return end

					SwapperRevive(victim)

					hook.Remove("PostPlayerDeath", "SwapperWaitForKillerDeath_" .. victim:SteamID64())
				end)
			else
				SwapperRevive(victim)
			end

			timer.Simple(0, function()
				SwapWeapons(victim, attacker)
			end)
		end
	end)

	-- reset hooks at round end
	hook.Add("TTTEndRound", "SwapperEndRoundReset", function()
		local plys = player.GetAll()

		for i = 1, #plys do
			hook.Remove("PostPlayerDeath", "SwapperWaitForKillerDeath_" .. plys[i]:SteamID64())
		end
	end)
end
