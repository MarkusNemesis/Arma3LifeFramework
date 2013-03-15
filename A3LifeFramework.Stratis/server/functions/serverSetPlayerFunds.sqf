/* serverGetPlayerFunds.sqf script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Sets the player's on-hand money.
Params: [pObj]
*/

(_this select 0) setVariable ["Money", _this select 1, true];
(_this select 0) setVariable ["MoneyServer", _this select 1, true];