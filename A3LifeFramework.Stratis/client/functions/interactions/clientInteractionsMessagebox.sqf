/* clientInteractionsMessagebox script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Creates a pop-up alert message, using the passed severity and text variables.
Params: Severity, Text
*/
Client_isMessageBox = true;
createdialog "ui_messageBox1";
ctrlsettext [1997, _this select 0];
ctrlsettext [1998, _this select 1];