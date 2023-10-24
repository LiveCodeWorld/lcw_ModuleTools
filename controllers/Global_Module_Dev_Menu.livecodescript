script "Global | Module | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | Module | Dev | Menu
type: controller
author: David Bovill
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
   put the title_Text of displayView into moduleStackName
   --
   if exists (control 1 of cd 1 of stack moduleStackName) then
      put the long id of control 1 of cd 1 of stack moduleStackName into viewObject
   end if
   --
   put displayView into LocalArray ["displayView"]
   put moduleStackName into LocalArray ["moduleStackName"]
   put viewObject into LocalArray ["viewObject"]
   --
   return displayView
end menu_Target


--> Global | Module | Dev | Menu
-
on menu_DisplayModuleTools
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   display_ModuleTools moduleStackName
end menu_DisplayModuleTools

on menu_RemoveModuleMenu displayView
   put _GetModuleMenuTitle() into gMenuTitle
   lcw_Answer merge ("Are you sure you want to remove the default menu '[[gMenuTitle]]' for this module from the global database?"), gMenuTitle
   --
   menu_RemoveGlobalController gMenuTitle
   put the result into mController
   if exists (mController) then
      get the script of mController
      if gMenuTitle is among the lines of it then
         edit the script of mController
      end if
   end if
end menu_RemoveModuleMenu

on menu_RevealModuleFolder
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   put the module_Folder of stack moduleStackName into moduleFolder
   --
   finder_Reveal moduleFolder
end menu_RevealModuleFolder

on _
end _

on menu_OpenModule
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   go to stack moduleStackName
end menu_OpenModule

on menu_CloseModuleStack
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   module_CloseStackAndTools moduleStackName
end menu_CloseModuleStack

on _
end _

on menu_EditModuleToolMenu
   menu_Edit "Global | Module | Tree | Menu"
   menu_Edit "Global | Module | Menu"
end menu_EditModuleToolMenu

on menu_SetModuleBehavior
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   put the module_Folder of stack moduleStackName into moduleFolder
   put module_ConstructBehaviorPath (moduleStackName, moduleFolder) into bPath
   --
   if there is a stack bPath then
      put LocalArray ["viewObject"] into viewObject
      --
      set the behavior of viewObject to the long id of stack bPath
      put the behavior of viewObject into bObject
      edit the script of bObject
   end if
end menu_SetModuleBehavior

on _
end _

on menu_ResetMenus
   put LocalArray ["viewObject"] into viewObject
   put LocalArray ["displayView"] into displayView
   --
   put view_ConstructToolMenu (viewObject) into mTitles
   set the title_Menu of displayView to mTitles
end menu_ResetMenus
