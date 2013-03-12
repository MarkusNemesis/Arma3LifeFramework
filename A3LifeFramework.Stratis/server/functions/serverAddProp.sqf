/* serverAddProp script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Adds the prop to the prop array
*/

waituntil {time > 3};
Server_InitPropsArray set [count Server_InitPropsArray, _this];
