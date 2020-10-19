 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private["_entries"];
diag_log "Bounty Server Starting initialization";

ExileBountyKings = [];
ExileBountyBounties = [];
ExileBountyWatcher = -1;
ExileBountyWatcherKing = -1;
ExileBountyFlop = 0;

[300, ExileServer_system_bounty_loop, [], true] call ExileServer_system_thread_addtask;

diag_log "Bounty Server Initialization completed";