/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

clientInteractionATM script
Created: 26/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs when a player interacts with an ATM.
Params: [ATMobject]
*/

disableSerialization;
//
private ['_atm', '_pInv', '_pwBalance', '_pbBalance','_fno', '_iRange'];
_atm = _this select 0;
_iRange = (missionNamespace getVariable "INT_RANGE");
_pInv = player getVariable "Inventory";
// -- Get player's balances
_pwBalance = (["Money", _pInv] call MV_Shared_fnc_SearchInventory) select 1;//player getVariable "money";
_pbBalance = player getVariable "bankmoney";

createDialog "ui_atmInteract";

// -- Set the text on the stxt controls.
((findDisplay 1412) displayctrl 2020) ctrlSetStructuredText (composeText ['Your Wallet:', lineBreak, '$', str _pwBalance]);
((findDisplay 1412) displayctrl 2021) ctrlSetStructuredText (composeText ['Your Bank:', lineBreak, '$', str _pbBalance]);

// -- init UI namespace variables
uiNamespace setVariable ['atm_cmdWithdraw', false];
uiNamespace setVariable ['atm_cmdDeposit', false];
diag_log "ATM UI init done. Running loop.";
while {!isnull (findDisplay 1412)} do
{
	if (_fNo < diag_frameno) then // -- Run once per frame.
	{
		if (_atm distance player > _iRange) exitwith {closeDialog 0;}; // -- user somehow moved beyond the interaction range of the ATM
		if (uiNamespace getVariable 'atm_cmdWithdraw') then
		{
			uiNamespace setVariable ['atm_cmdWithdraw', false];
			// -- Deposit the entered value into the player's account. Validated first of course!
			private ['_qty'];
			_qty = round (parseNumber ctrlText 2019);
			if (_qty < 1 || _qty > _pbBalance) exitwith {["ERROR", localize "STR_MV_INT_FAILATMTRANSACTION"] spawn MV_Client_fnc_int_MessageBox;};
			// -- Send server message.
			["atmAction", [netID player ,_qty, 'withdraw']] call MV_Client_fnc_SendServerMessage;
			closeDialog 0;
		};
		
		if (uiNamespace getVariable 'atm_cmdDeposit') then
		{
			uiNamespace setVariable ['atm_cmdDeposit', false];
			//
			private ['_qty'];
			_qty = round (parseNumber ctrlText 2019);
			if (_qty < 1 || _qty > _pwBalance) exitwith {["ERROR", localize "STR_MV_INT_FAILATMTRANSACTION"] spawn MV_Client_fnc_int_MessageBox;};
			// -- Send server message.
			["atmAction", [netID player ,_qty, 'deposit']] call MV_Client_fnc_SendServerMessage;
			closeDialog 0;
		};
	};
	
	// -- Leave last
	_fNo = diag_frameno;
};