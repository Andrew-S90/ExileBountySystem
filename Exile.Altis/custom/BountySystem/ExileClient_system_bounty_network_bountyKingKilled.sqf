
private ["_poptabs","_respect"];

_poptabs = _this select 0;
_respect = _this select 1;

ExileClientPlayerScore = ExileClientPlayerScore + (parseNumber _respect);

["SuccessTitleAndText", ["BountyKing", format["You killed the king! You have been rewarded %1 poptabs and %2 respect",(parseNumber _poptabs) call ExileClient_util_addCommas,(parseNumber _respect) call ExileClient_util_addCommas]]] call ExileClient_gui_toaster_addTemplateToast;