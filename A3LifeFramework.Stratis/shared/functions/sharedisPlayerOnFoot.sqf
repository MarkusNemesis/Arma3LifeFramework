/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

sharedisPlayerOnFoot script
Created: 29/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Returns TRUE if the passed object is a player, and iskindof 'man' (Thus, not in a vehicle).
Params: [_obj]
Return: true/false is player on foot.
*/

private ['_Obj', '_return'];
_obj = _this select 0;
_return = false;
if (isplayer _obj && _obj isKindOf "Man") then {_return = true;};

_return