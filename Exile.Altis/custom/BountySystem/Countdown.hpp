 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
#define ST_RIGHT 0x01

class BountyTimer 
{
	idd = -1;
	onLoad = "uiNamespace setVariable ['BountyTimer', _this select 0]";
	onUnload = "uiNamespace setVariable ['BountyTimer', objNull]";
	onDestroy = "uiNamespace setVariable ['BountyTimer', objNull]";
	fadein = 0;
	fadeout = 0;
	duration = 10e10;
	movingEnable = 0;
	controlsBackground[] = {};
	objects[] = {};
	class controls 
	{
		class BountyBackground
		{
			type = 0;
			idc = 4300;
			//x = 0.8 * safezoneW + safezoneX;
			//y = 0.164 * safezoneH + safezoneY;
			//w = 0.124687 * safezoneW;
			//h = 0.042 * safezoneH;
			x = "46.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-6 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "2.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorBackground[]={0.050000001,0.050000001,0.050000001,0.19999999};
			style = 48;
			text = "\A3\ui_f\data\igui\rscingameui\rscunitinfo\gradient_ca.paa";
			colorText[] = {0.050000001,0.050000001,0.050000001,0.19999999};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class Bounty_Icon: BountyBackground
		{
			type = 0;
			idc = 4301;
			x = "46.6 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-5.9 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "1 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			style = 48;
			text = "custom\BountySystem\bountyking_red.paa";
			colorText[] = {1,1,1,1};
		};
		class BountyText 
		{
			idc = 4302;
			x = "47.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-6.1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "6 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			shadow = 1;
			colorBackground[] = { 1, 1, 1, 0 };
			colorText[] = {1,0,0,1};
			font = "PuristaBold";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			size = "0.025 * safezoneH";
			type = 13;
			style = 2;
			text="Bounty King";
			class Attributes {
				align="left";
				color = "#ff0000";//#5fe60c
			};
		};
		class SurviveText: BountyText 
		{
			idc = 4303;
			x = "46.6 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-4.9 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "8 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			shadow = 1;
			colorBackground[] = { 1, 1, 1, 0 };
			colorText[] = {1,1,1,1};
			font = "PuristaSemibold";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			size = "0.02 * safezoneH";
			type = 13;
			style = 2;
			text="You are the target, Survive!";
			class Attributes {
				align="left";
				color = "#ffffff";//#5fe60c
			};
		};
		class TimerText 
		{
			idc = 4304;
			x = "53.7 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-5.9 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "3 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			shadow = 1;
			colorBackground[] = { 0, 0, 0, 0 }; // make the last number in the array 0 to get rid of the background
			font = "PuristaBold";
			size = "0.0225 * safezoneH";
			type = 13;
			style = 2;
			text="0:00";
			class Attributes {
				align="left";
				color = "#ffffff";//#5fe60c
			};
		};
		/*class BountyBar 
		{
			onLoad = "_this spawn {params ['_ctrlProgress'];_ctrlProgress progressSetPosition 0.8; _ctrlProgress ctrlSetTextColor [1,0.65,0,1];}";
			idc = 4305;
			x = "46.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-3.75 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "0.25 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			shadow = 1;
			colorBar[] = { 1, 1, 1, 1 }; // make the last number in the array 0 to get rid of the background
			size = "0.0225 * safezoneH";
			type = 8;
			style = 0;
			colorFrame[] = {0,0,0,0};
			texture = "#(argb,8,8,3)color(1,1,1,1)";
		};*/
	};
};


#define ST_RIGHT 0x01

class LowerBountyTimer 
{
	idd = -1;
	onLoad = "uiNamespace setVariable ['LowerBountyTimer', _this select 0]";
	onUnload = "uiNamespace setVariable ['LowerBountyTimer', objNull]";
	onDestroy = "uiNamespace setVariable ['LowerBountyTimer', objNull]";
	fadein = 0;
	fadeout = 0;
	duration = 10e10;
	movingEnable = 0;
	controlsBackground[] = {};
	objects[] = {};
	class controls 
	{
		//Lower Bar
		class LowerBackground
		{
			type = 0;
			colorBackground[]={0.050000001,0.050000001,0.050000001,0.19999999};
			style = 48;
			text = "\A3\ui_f\data\igui\rscingameui\rscunitinfo\gradient_ca.paa";
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			idc = 5300;
			x = "46.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-3.25 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "2.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorText[] = {1,0.65,0,0.19999999};
		};
		class LowerBounty_Icon: LowerBackground
		{
			type = 0;
			style = 48;
			colorText[] = {1,1,1,1};
			idc = 5301;
			x = "46.6 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-3.15 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "1 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			text = "custom\BountySystem\bounty_white.paa";
		};
		class LowerBountyText
		{
			shadow = 1;
			colorBackground[] = { 1, 1, 1, 0 };
			colorText[] = {1,0,0,1};
			font = "PuristaBold";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			size = "0.025 * safezoneH";
			type = 13;
			style = 2;
			idc = 5302;
			x = "47.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-3.35 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "6 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			text="Hunted!";
			class Attributes 
			{
				align="left";
				color = "#ffffff";//#5fe60c
			};
		};
		class LowerSurviveText: LowerBountyText 
		{
			idc = 5303;
			x = "46.6 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-2.15 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "8 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			text="Protect Elmoblatch!";
			shadow = 1;
			colorBackground[] = { 1, 1, 1, 0 };
			colorText[] = {1,1,1,1};
			font = "PuristaSemibold";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			size = "0.02 * safezoneH";
			type = 13;
			style = 2;
			class Attributes {
				align="left";
				color = "#ffffff";//#5fe60c
			};
		};
		class LowerTimerText 
		{
			shadow = 1;
			colorBackground[] = { 0, 0, 0, 0 }; 
			font = "PuristaBold";
			size = "0.0225 * safezoneH";
			type = 13;
			style = 2;
			idc = 5304;
			x = "53.7 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-3.15 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "3 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			text="0:00";
			class Attributes 
			{
				align="center";
				color = "#ffffff";//#5fe60c
			};
		};
		class LowerBountyBar 
		{
			//onLoad = "_this spawn {params ['_ctrlProgress'];_ctrlProgress progressSetPosition 0.8; _ctrlProgress ctrlSetTextColor [1,0.65,0,1];}";
			idc = 5305;
			x = "46.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "-1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "0.25 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			shadow = 1;
			colorBar[] = { 1, 1, 1, 1 }; // make the last number in the array 0 to get rid of the background
			size = "0.0225 * safezoneH";
			type = 8;
			style = 0;
			colorFrame[] = {0,0,0,0};
			texture = "#(argb,8,8,3)color(1,1,1,1)";
		};
	};
};