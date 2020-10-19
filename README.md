# ExileBountySystem
Bounty System for Exile Servers

Customizable features allowing bounty missions on your server. 

Mission type one is Bounty King where you are the target and your goal is to stay alive until the end of count down for a reward. If anyone kills you they get respect and a reward.

Mission type two is Bounty Mission where you are given a target and must kill them. If they survive the timer then they get a reward. If they are killed by anyone else you get a reduced reward. If you die they get a reduced reward, if they kill you they get a bigger reward.

Bounty King missions features a vehicle blocklist if you wish to not allow use of a certain type of vehicle when they are hunted.
Team Kills for Bounty King earn no rewards, you can only do one mission per group and can't get your teammates as targets.
Safezones, territories, map boundries and height limit are in place to stop running/abuse.
Customize the bounty missions in bounty_server\config.cpp

Showcase video: https://www.youtube.com/watch?v=Ki6m_W3upgw

This was developed on a test server with EXTDB2, no infistar and no battleye.


# Install Instructions:

### Client

**config.cpp**

Paste the contents into the top of your config file. Modify existing network message section if needed.
Add to Custom Code and Interaction Menus

**description.ext**

Paste the contents anywhere after `#include "RscDefines.hpp"` appears in your description.ext file

**initplayerlocal.sqf**

After `if (!hasInterface || isServer) exitWith {};` paste the upper contents of initplayerlocal.sqf found in the Client folder

If you are having trouble please view the example mission included.

### Server

**Code**

Overrides are found in customcode\server in the Client folder, simply pbo the server folder and place inside your servermod folder (such as @ExileServer)

**SQL**

No Modifications Needed

**Exile.ini**

No Modifications Needed


For support feel free to post in Exile Discord #support channel: https://discord.gg/cmMMHyJ

Unless something is broken or missing in this initial release I will not provide support or installation help, you are free to use this release as you wish.

Thank you!
