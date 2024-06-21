script "Global | Module | Tree | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | Module | Tree | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this developer menu.
Full help text should be provided on the linked wiki.

Consider improving by creating with same menu_Target as no-developer menu is is based on.
*/

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

getprop menu_CheckTarget [mTarget]
   return exists (mTarget)
end menu_CheckTarget


--> Global | Module | Tree | Dev | Menu
-
on menu_SetViewCardBehavior viewObject
   lcw_Answer "Set the behavior of the views card to the stack 'behavior_ViewTemplateCard'?"
   put the card_Object of viewObject into cardObject
   set the behavior of cardObject to the long id of stack "behavior_ViewTemplateCard"
end menu_SetViewCardBehavior

on menu_RememberModuleStacks viewObject
   set the cursor to watch
   _SetModuleInfo shortModuleFolder, moduleFolder, moduleStackName, viewObject
   
   # Set module stackfiles
   put the folder_StackFileArray of viewObject into stackFileArray
   set the stackFile_Array of viewObject to stackFileArray
   save stack moduleStackName
   --
   module_ExportMenusAndStackFiles moduleFolder
   put the result into moduleArray
   
   # Check
   put project_GetArrayFromFolder (moduleFolder) into moduleArray
   display_Data moduleArray, moduleStackName, "Module Array"  
end menu_RememberModuleStacks

on menu_RememberProjectStacks viewObject
   put the project_Name of viewObject into projectName
   put project_GetFolder (projectName) into projectFolder
   if there is not a folder projectFolder then
      lcw_AnswerWarning "Cannot find a project folder for project:" && projectName
   end if
   
   # Construct and Store projectArray
   put project_ConstructArrayFromFolder (projectFolder) into projectArray
   project_StoreArray projectFolder, projectArray
   
   # Display
   display_ProjectLibs projectName
   display_GitRefreshProjectName projectName
end menu_RememberProjectStacks

private command _
end _

on menu_ModuleInfo viewObject
   put the module_Array of viewObject into moduleArray
   put moduleArray ["moduleName"] into moduleName
   put merge ("[[moduleName]],Module Array") into someTitle
   --
   display_Array moduleArray, someTitle
end menu_ModuleInfo

on menu_DisplayToolMenuTitles viewObject
   put view_ConstructToolMenu (viewObject)
end menu_DisplayToolMenuTitles

on _
end _

on submenu_ModuleMenu
   return "Global | Module | Menu"
end submenu_ModuleMenu
