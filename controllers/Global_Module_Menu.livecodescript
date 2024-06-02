script "Global | Module | Menu"
--> MetaData
-
license: GPLv3
name: Global | Module | Menu
type: controller
version: 0.2


--> Menu | Props
-
local LocalArray

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

getprop menu_CheckTarget [mTarget]
   if exists (mTarget) then
      return true
   else
      return false
   end if
end menu_CheckTarget

-- getprop disabled_EditMenu [viewObject]
   put _GetModuleMenuTitle() into gMenuTitle
   if menu_Exists (gMenuTitle) then
      return false
   else
      return true
   end if
end disabled_EditMenu

-- getprop disabled_EditModuleBehavior [viewObject]
   put _GetModuleBehaviorName() into bStackName
   if exists (stack bStackName) then
      return false
   else
      return true
   end if
end disabled_EditModuleBehavior

private function _GetModuleBehaviorName
   put LocalArray ["moduleStackName"] into moduleStackName
   put project_DefaultBehaviorName (moduleStackName) into bStackName
   return bStackName
end _GetModuleBehaviorName

private function _GetModuleMenuTitle
   put LocalArray ["moduleStackName"] into moduleStackName
   put module_ConstructGlobalMenuTitle (moduleStackName) into gMenuTitle
   return gMenuTitle
end _GetModuleMenuTitle

private function _GetModuleFolder
   put LocalArray ["moduleStackName"] into moduleName
   put the stack_Folder of stack moduleName into moduleFolder
   return moduleFolder
end _GetModuleFolder


--> Global | Module | Menu
-
on menu_SaveModule dView
   put LocalArray ["viewObject"] into viewObject
   put the stack_Name of viewObject into sName
   --
   lcw_Answer "Save stack '[[var]]'?", viewObject, sName
end menu_SaveModule

private on _
end _

on menu_ModuleProperties
   put LocalArray ["viewObject"] into viewObject
   --
   display_ObjectProperties viewObject
end menu_ModuleProperties

on menu_ModuleStackProperties
   put LocalArray ["viewObject"] into viewObject
   put the stack_Object of viewObject into stackObject
   --
   display_ObjectProperties stackObject
end menu_ModuleStackProperties

on menu_RefreshMenubar
   put LocalArray ["viewObject"] into viewObject
   put the stack_Name of viewObject into stackName
   
   # Need to reset the menubar to have it update
   put the defaultMenuBar into tOriginalDefaultMenuBar
   
   set the menuBar of stack stackName to empty
   set the defaultMenuBar to ide_DefaultMenuGroup()
   --
   -- set the menuBar of this stack to tOriginalMenuBar
   -- set the defaultMenuBar to tOriginalDefaultMenuBar
end menu_RefreshMenubar

private on __
end __

on menu_DisplayCreateScript
   put LocalArray ["viewObject"] into viewObject
   put the view_Name of viewObject into vName
   --
   put the view_CreateScript of viewObject into viewCreateScript
   display_Text viewCreateScript, vName, "Create Script"
   put the result into dView
   --
   display_SetMenu dView, "Global | Widget | Script | Menu"
   return dView
end menu_DisplayCreateScript

on menu_CreateWidgetStack dView
   put LocalArray ["viewObject"] into viewObject
   put the view_Name of viewObject into vName
   put scriptwidget_ConstructName (vName) into wName
   --
   put lcw_Ask ("Choose a name for this widget..", wName, "Create Widget", dView) into wName
   if exists (stack wName) then
      lcw_AnswerWarning "Stack '[wName]' already exists!", dView, wName
   end if
   --
   put the behavior of viewObject into bObject
   put the script of bObject into bScript
   put the view_CreateScript of viewObject into viewCreateScript
   put word 1 to -1 of bScript & CR&CR & viewCreateScript into wScript
   --
   create script only stack wName
   set the script of stack wName to wScript
   --
   edit the script of stack wName
end menu_CreateWidgetStack

on menu_TestScriptOnlyWidget cardObject
   put LocalArray ["viewObject"] into viewObject
   put the view_Name of viewObject into vName
   put scriptwidget_ConstructName (vName) into wName
   --
   put lcw_Ask ("Choose a name for this widget..", wName, "Create Widget", cardObject) into wName
   --
   create stack
   create widget as wName
end menu_TestScriptOnlyWidget

private on ___
end ___

on menu_ExportModuleJson displayView
   put _GetModuleFolder() into moduleFolder
   if there is not a folder moduleFolder then
      breakpoint
      exit to top
   end if
   
   project_ExportMenusAndStackFiles moduleFolder
   put the result into projectArray
   --
   -- put _GetStackName (displayView) into moduleName
   -- display_Data projectArray, moduleName, "Module Array"  
end menu_ExportModuleJson

on menu_CreateModuleMenu displayView
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   put _GetModuleMenuTitle() into gMenuTitle
   put menu_GetGlobalController (gMenuTitle) into mController
   if exists (mController) then
      put module_ConstructGlobalMenuTitle (moduleStackName & "|Test") into gMenuTitle
      ask_CreateModuleMenu moduleStackName, displayView, gMenuTitle
   else
      ask_CreateModuleMenu moduleStackName, displayView
   end if
   --
   put the result into mController
   if exists (mController) then
      edit the script of mController
   end if
end menu_CreateModuleMenu

on menu_EditModuleMenu displayView
   put _GetModuleMenuTitle() into gMenuTitle
   menu_Edit gMenuTitle
   --
   menu_Edit "Global | Module | Menu"
   menu_Edit "Global | Module | Tree | Menu"
end menu_EditModuleMenu

private on _
end _

on menu_EditModuleBehavior
   put _GetModuleBehaviorName() into bStackName
   edit the script of stack bStackName
end menu_EditModuleBehavior

on menu_CreateModuleBehavior
   put LocalArray ["moduleStackName"] into moduleStackName
   put project_DefaultBehaviorName (moduleStackName) into maybeBehaviorStackName
   put the module_Folder of stack moduleStackName into moduleFolder
   --
   put lcw_Ask ("What name would you like for this modules behavior?", maybeBehaviorStackName) into behaviorStackName
   --
   module_CreateBehavior moduleFolder, behaviorStackName
   put the result into moduleBehaviorStackPath
   --
   edit the script of stack moduleBehaviorStackPath
   --
   display_ModuleTools moduleStackName
end menu_CreateModuleBehavior

on menu_RenameModule
   put LocalArray ["moduleStackName"] into oldModuleName
   --
   put the project_Folder of stack oldModuleName into projectFolder
   put the project_Name of stack oldModuleName into projectName
   put lcw_Ask ("Give this module a new name...", oldModuleName) into newModuleName
   --
   module_Rename oldModuleName, newModuleName, projectName
   --
   display_ProjectLibs projectName
end menu_RenameModule

on menu_RemoveFromMemory displayView
   put LocalArray ["moduleStackName"] into moduleName
   put the project_Folder of stack moduleName into projectFolder
   --
   module_RemoveFromMemory moduleName, projectFolder
end menu_RemoveFromMemory

private on __
end __

on submenu_Tools
   return "Global | Module | Tree | Menu"
end submenu_Tools

on submenu_CreateModule
   return "Global | View | Card | Create | Menu"
end submenu_CreateModule

on submenu_Dev
   return menu_DevTitle ("Global | Module | Menu")
end submenu_Dev
