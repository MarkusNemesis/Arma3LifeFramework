/* clientInteractableAwareness script
Created: 16/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 'reveal's to the player all typically interactable objects within interact distance (5 m)
*/

private ['_nTargs'];

// -- Gets all near objects/targets
_nTargs = player nearEntities 5; // TODO limit this to certain class types, based off what will be typically interactable with.

// -- Debugging
//diag_log format ["MV: clientInteractableAwareness: %1", _nTargs];

// -- iterate through the objects and 'reveal' only those which are interactable.
{
    if (_x getVariable "isInteractable" && _x != player) then {player reveal [_x, 4];};
    // May not be resource wise to check if the player already knowsabout these objects. 
} foreach _nTargs;