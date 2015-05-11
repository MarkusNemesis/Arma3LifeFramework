/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

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