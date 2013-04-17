/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

clientSystemChatMessage script
Created: 18/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Shows a formatted systemChat message in the chat window.
Params: [strPrefix, strMessage]
*/

private ['_prefix', '_msg'];
_prefix = _this select 0;
_msg = _this select 1;

switch (_prefix) do
{
	case "i":
	{
		_prefix = localize "STR_MV_MSGPREFIX_INFO";
	};
	case "w":
	{
		_prefix = localize "STR_MV_MSGPREFIX_WARN";
	};
	case "e":
	{
		_prefix = localize "STR_MV_MSGPREFIX_ERROR";
	};
	case "s":
	{
		_prefix = localize "STR_MV_MSGPREFIX_SUCCESS";
	};
	case "f":
	{
		_prefix = localize "STR_MV_MSGPREFIX_FAIL";
	};
	case "n":
	{
		_prefix = localize "STR_MV_MSGPREFIX_NOTICE";
	};
};
// -- Post message
systemChat format ["%1: %2: %3", localize "STR_MISSION_NAMEABBR", _prefix, _msg];

// -- Play a notification sound
playSound "hints";