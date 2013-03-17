/* clientHitEH script
Created: 04/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Adds hits to the Client_HitArray, to be processed by the client core loop. 
*/

private ['_hitee', '_hiter', '_dmg'];

_hitee = _this select 0;
_hiter = _this select 3;
_dmg = _this select 2;

_this select 2;