# TTT2 Swapper Role
A port of of the Swapper from Custom Roles for TTT

This has been made for fun for my server and bugs may exist but feel free to report them.

**Swapper** 
- Swaps roles and all equipment with their killer on death. Their killer is then given a set health as the new swapper.

  **General Swapper Convars**
  
	CreateConVar("ttt2_swapper_entity_damage", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_environmental_damage", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_respawn_delay", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_respawn_delay_post_death", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt2_swapper_respawn_health", "100", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	**Killer ConVars**  
	It will randomly select between these 2 if more than 1 are active
	
	CreateConVar("ttt2_swapper_killer_health", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	
	CreateConVar("ttt2_swapper_killer_die", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	**Swapper ConVars**  
	It will randomly select between these 3 if more than 1 are active
	
	CreateConVar("ttt2_swapper_do_not_respawn", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	
	CreateConVar("ttt2_swapper_respawn_same_team", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	
	CreateConVar("ttt2_swapper_respawn_opposite_team", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
