/* clientInteractionHandler script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Is called when E is pressed on an object, and that object's getVariable "isInteractable" == true
Calls the respective interact function, based off the object's getVariable "interactType"
Params: [interactObject]
*/

private ['_iObj'];

_iObj = this select 0;