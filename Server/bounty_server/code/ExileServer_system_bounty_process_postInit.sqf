private["_entries"];
diag_log "Bounty Server Starting initialization";

ExileBountyKings = [];
ExileBountyBounties = [];
ExileBountyWatcher = -1;
ExileBountyWatcherKing = -1;
ExileBountyFlop = 0;


//[300, ExileServer_system_bounty_loop, [], true] call ExileServer_system_thread_addtask;
[10, ExileServer_system_bounty_loop, [], true] call ExileServer_system_thread_addtask;

diag_log "Bounty Server Initialization completed";