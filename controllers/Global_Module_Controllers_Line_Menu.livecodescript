script "Global | Module | Controllers | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Module | Controllers | Line | Menu
type: controller
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/


--> Variables
-
local LocalArray


--> Menu | Props
-
getprop menu_Target [tObject]
   put the display_View of tObject into displayView
   return displayView
end menu_Target

function _GetControllerPath displayView
   put item 1 of the selected_Path of displayView into shortFolder
   put item 2 of the selected_Path of displayView into shortFile
   put the displayed_ModuleFolder of displayView into moduleFolder
   --
   put moduleFolder & shortFolder & slash & shortFile into stackPath
   return stackPath
end _GetControllerPath


--> Global | Module | Controllers | Line | Menu
-
on menu_EditScript displayView
   put _GetControllerPath (displayView) into cPath
   --
   edit the script of stack cPath
end menu_EditScript

on menu_NewModuleController dView
   put the title_Text of dView into moduleStackName
   --
   ask_CreateModuleMenu moduleStackName, dView
   --
   display_ModuleTools moduleStackName
end menu_NewModuleController

on menu_FixMenuName displayView
   put _GetControllerPath (displayView) into cPath
   put the name of stack cPath into mController
   --
   ask_FixMenuControllerStackName mController
   put the result into newStackName
end menu_FixMenuName

private on _
end _

on menu_Refresh dView
   put the title_Text of dView into moduleStackName
   display_ModuleTools moduleStackName
end menu_Refresh
   
