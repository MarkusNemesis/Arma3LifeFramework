/* clientInteractableAwareness script
Created: 16/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 'reveal's to the player all typically interactable objects within interact distance
*/

private ['_nTargs', '_iRange'];
_iRange = _this select 0;
// -- Gets all near objects/targets
_nTargs = player nearEntities 5; // TODO limit this to certain class types, based off what will be typically interactable with. OR convert back to 'lineIntersectsWith' when it gets fixed.

// -- Debugging
//diag_log format ["MV: clientInteractableAwareness: %1", _nTargs];

// -- iterate through the objects and 'reveal' only those which are interactable.
{
    if (_x getVariable "isInteractable" && _x != player) then {player reveal [_x, _iRange];};
    // May not be resource wise to check if the player already knowsabout these objects. 
} foreach _nTargs;