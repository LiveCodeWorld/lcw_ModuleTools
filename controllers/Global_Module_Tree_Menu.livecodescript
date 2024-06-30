script "Global | Module | Tree | Menu"
--> MetaData
-
license: GPLv3
name: Global | Module | Tree | Menu
target: indexView
type: controller
version: 0.2


--> Menu | Props
-
local LocalArray

getprop menu_Target [tObject]
   put the display_View of tObject into displayView
   --
   if exists (displayView) then
      put the displayed_Object of displayView into viewObject
      put displayView into LocalArray ["displayView"]
   else
      put the module_ViewObject of tObject into viewObject
      if exists (viewObject) is false then
         return tObject
      end if
   end if
   --
   return viewObject
end menu_Target

getprop menu_CheckTarget [viewObject]
   if exists (viewObject) is false then return false
   
   put the stack_Name of viewObject into moduleName
   put the module_Folder of viewObject into moduleFolder
   put _GetClonedStackNames (viewObject) into clonedStackNames
   --
   put clonedStackNames into LocalArray ["clonedStackNames"]
   put moduleName into LocalArray ["moduleName"]
   put moduleFolder into LocalArray ["moduleFolder"]
   --
   return true
end menu_CheckTarget

command _importMenus viewObject
   put the module_Controllers of viewObject into cObjects
   repeat for each line cObject in cObjects
      if exists (cObject) is false then 
         breakpoint
         next repeat
      end if
      
      if word 1 of cObject is not "stack" then
         breakpoint
         next repeat
      end if
      
      put the stack_Name of cObject into cStackName
      put cStackName && "Dep"
      
      clone cObject
      put it into clonedBehaviorStack
      set the name of clonedBehaviorStack to newName
   end repeat
end _importMenus

private function _GetClonedStackNames viewObject
   put the openstacks into sNames
   put the stack_Name of viewObject into stackName
   put stackName && "*" into someFilter
   filter sNames with someFilter
   --
   replace "|" with ":" in sNames
   return sNames
end _GetClonedStackNames

getprop disabled_SelectModule
   if the selobj is empty then
      return false
   else
      return "delete"
   end if
end disabled_SelectModule

getprop disabled_DeselectModule
   if the selobj is empty then
      return "delete"
   else
      return false
   end if
end disabled_DeselectModule

getprop disabled_SetViewCardBehavior [viewObject]
   if exists (stack "behavior_ViewTemplateCard") is false then return true
   --
   put the card_Object of viewObject into templateCardObject
   put the behavior of templateCardObject into bObject
   if exists (bObject) is false then return false
   
   put the name of stack "behavior_ViewTemplateCard" into defaultBehaviorStack
   put the name of bObject = defaultBehaviorStack into behaviorIsSet
   return behaviorIsSet
end disabled_SetViewCardBehavior

private command _SetModuleInfo @shortModuleFolder, @moduleFolder, @moduleStackName, viewObject
   put the module_ShortFolder of viewObject into shortModuleFolder
   put the view_Name of viewObject into moduleStackName
   if exists (stack moduleStackName) is false then
      put LocalArray ["displayView"] into displayView
      lcw_AnswerWarning "Cannot local module stack '[[moduleStackName]]!", displayView, moduleStackName
   end if
   put the module_Folder of viewObject into moduleFolder
end _SetModuleInfo


--> Global | Module | Tree | Menu
-
on menu_ModuleHelp
   put LocalArray ["moduleName"] into moduleName
   draft_ModuleHelp moduleName
end menu_ModuleHelp

on menu_ModuleStackTools viewObject, moduleStackName
   replace ":" with "|" in moduleStackName
   --
   display_ModuleTools moduleStackName
end menu_ModuleStackTools

on menu_CloneModule viewObject
   put LocalArray ["moduleName"] into moduleName
   if exists (stack moduleName) is false then
      breakpoint
      lcw_AnswerWarning "No such stack!"
   end if
   --
   stack_Clone moduleName
   put the result into clonedStack
   set the original_ModuleName of clonedStack to moduleName
   put the stack_Name of clonedStack into cStackName
   --
   display_CloneTools cStackName
end menu_CloneModule

getprop disabled_CloneModule
   put LocalArray ["moduleName"] into moduleName
   return exists (stack moduleName) is false
end disabled_CloneModule

private on _
end _

on menu_InsertMenuGroup sView
   put the menubar_View of sView into mGroup
   --
   menubar_Insert sView
end menu_InsertMenuGroup

getprop disabled_InsertMenuGroup [sView]
   put the menubar_View of sView into mGroup
   if exists (mGroup) then
      return "delete"
   else
      return false
   end if
end disabled_InsertMenuGroup

on menu_DeleteMenuGroup sView
   put the menubar_View of sView into mGroup
   --
   menubar_Delete mGroup
end menu_DeleteMenuGroup

getprop disabled_DeleteMenuGroup [sView]
   put the menubar_View of sView into mGroup
   if exists (mGroup) then
      return false
   else
      return "delete"
   end if
end disabled_DeleteMenuGroup

on menu_ShowMenu sView
   put the menubar_View of sView into mGroup
   --
   menuBar_ToggleShowMenu mGroup
end menu_ShowMenu

getprop disabled_ShowMenu [sView]
   put the menubar_View of sView into mGroup
   if exists (mGroup) then
      return false
   else
      return "delete"
   end if
end disabled_ShowMenu

getprop checked_ShowMenu [sView]
   put the menubar_View of sView into mGroup
   if exists (mGroup) is false then return false
   --
   put the show_Menu of mGroup into sBoolean
   return sBoolean
end checked_ShowMenu

private on __
end __

on menu_AddBrowser viewObject
   put the stack_Name of viewObject into moduleName
   put the card_Object of viewObject into cObject
   --
   put the name of cObject into oName
   lcw_Answer "Add browser View to [[var]]", viewObject, oName
   
   # Create browser
   put view_GetTemplateObject ("View|Browser") into browserView
   copy browserView to cObject
   put it into copiedBrowser
   put the behavior of copiedBrowser into bObject
   
   # Tidy
   -- could simply have created browser and set behaviors
   choose browse tool
   set the opaque of copiedBrowser to true
   
   # Set metadata
   set the module_ViewMetaData [false] of copiedBrowser to moduleName
   set the name of copiedBrowser to moduleName
   set the card_Margin of cObject to 12
   set the backgroundcolor of cObject to "green"
   
   # Add browser behavior to module behaviors
   put the module_Behaviors of viewObject into moduleBehaviors
   line_Add bObject, moduleBehaviors
   set the behavior_Objects of copiedBrowser to moduleBehaviors
   
   dispatch "LayoutCard" to cObject
   lcw_Notify "Copied browser to this card!"
   --
   put the behavior of copiedBrowser into mBehavior
   edit the script of mBehavior
end menu_AddBrowser

-- getprop disabled_AddBrowser [viewObject]
   put the card_Object of viewObject into cObject
   put the childControlIDs of cObject into cIDS
   return cIDS is not empty
end disabled_AddBrowser

on menu_SetModuleMenus sView
   put the menubar_View of sView into mGroup
   --
   put the stack_Name of sView into moduleName
   put "View|Keepass" into moduleName
   --
   put the module_ControllerStackNames of stack moduleName into mTitles
   put the module_MenuTitle of stack moduleName into defaultMenu
   line_Delete defaultMenu, mTitles
   put defaultMenu & CR & mTitles into moduleMenuTitles
   --
   put lineOffset (" | Help | Menu", moduleMenuTitles) into lineNum
   if lineNum > 0 then
      put line lineNum of moduleMenuTitles into helpTitle
      delete line lineNum of moduleMenuTitles
      put CR & helpTitle after moduleMenuTitles
   end if
   --
   set the menubar_Titles of mGroup to moduleMenuTitles
end menu_SetModuleMenus

private on ___
end ___

on menu_CreateModuleMenu viewObject
   put LocalArray ["moduleName"] into moduleName
   put LocalArray ["displayView"] into displayView
   --
   ask_CreateModuleMenu moduleName, displayView
   --
   -- module_CreateMenu moduleStackName, pGlobalMenuTitle, pControllerScript
end menu_CreateModuleMenu

on menu_CloseModuleStack viewObject, moduleStackName
   replace ":" with "|" in moduleStackName
   --
   module_CloseStackAndTools moduleStackName
end menu_CloseModuleStack

getprop disabled_CloseModuleStack
   if LocalArray ["clonedStackNames"] is empty then
      return true
   else
      return false
   end if
end disabled_CloseModuleStack

getprop closeModuleStack_Params
   return LocalArray ["clonedStackNames"]
end closeModuleStack_Params

getprop disabled_ModuleStackTools
   if LocalArray ["clonedStackNames"] is empty then
      return "delete"
   else
      return false
   end if
end disabled_ModuleStackTools

private on ____
end ____

on menu_DisplayModuleMenus viewObject
   set the cursor to watch
   _SetModuleInfo shortModuleFolder, moduleFolder, moduleStackName, viewObject
   
   put project_GetArrayFromFolder (moduleFolder) into moduleArray
   display_Data moduleArray, moduleStackName, "Module Array"  
end menu_DisplayModuleMenus

private on ____
end ____

on menu_RevealModuleFolder
   put LocalArray ["moduleFolder"] into moduleFolder
   finder_Reveal moduleFolder
end menu_RevealModuleFolder

on menu_Refresh viewObject
   put the view_Name of viewObject into moduleStackName
   display_ModuleTools moduleStackName
end menu_Refresh

on submenu_Dev
   return menu_DevTitle ("Global | Module | Tree | Menu")
end submenu_Dev
