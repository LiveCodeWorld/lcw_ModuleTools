script "Global | Module | List | Line | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | Module | List | Line | Dev | Menu
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
private function _SelectedShortModuleFolder displayView
   if the tree_View of displayView is empty then
      put the selected_Line of displayView into shortModuleFolder
   else
      put the selected_Path of displayView into shortModuleFolder
      replace comma with "_" in shortModuleFolder
   end if
   return shortModuleFolder
end _SelectedShortModuleFolder

private function _SelectedModuleStackPath displayView
   if the tree_View of displayView is empty then
      put the selected_Line of displayView into shortModuleFolder
      put env_GetModuleHomePath (shortModuleFolder) into moduleStackPath
   else
      put the selected_Path of displayView into moduleName
      replace comma with "|" in moduleName
      put view_GetTemplateObject (moduleName) into viewObject
      --
      if exists (stack moduleName) then
         put the filename of stack moduleName into moduleStackPath
      else
         breakpoint
         exit to top
      end if
   end if
   return moduleStackPath
end _SelectedModuleStackPath

getprop menu_Target [tObject]
   put the display_View of tObject into displayView
   put displayView into LocalArray ["displayView"]
   --
   put _SelectedShortModuleFolder (displayView) into shortModuleFolder
   put _SelectedModuleStackPath (displayView) into moduleStackPath
   put the short name of stack moduleStackPath into LocalArray ["moduleName"]
   --   
   put the project_Name of stack moduleStackPath into LocalArray ["projectName"]
   put the project_Folder of stack moduleStackPath into LocalArray ["projectFolder"]
   put the module_Folder of stack moduleStackPath into LocalArray ["moduleFolder"]
   --
   return shortModuleFolder
end menu_Target

getprop moveModule_Param
   return LocalArray ["projectName"]
end moveModule_Param

getprop moveModule_Params
   return env_ListActiveProjects()
   return library_ListProjectNames()
end moveModule_Params


--> Global | Module | List | Line | Dev | Menu
-
on menu_MoveModule moduleShortFolder, newProjectName
   set the cursor to watch
   put LocalArray ["moduleName"] into moduleName
   put LocalArray ["projectName"] into oldProjectName
   put LocalArray ["projectFolder"] into oldProjectFolder
   put LocalArray ["moduleFolder"] into oldModuleFolder
   --
   put library_FetchProjectFolder (newProjectName) into newProjectFolder
   put module_GetFolder (moduleShortFolder, newProjectFolder) into newModuleFolder
   
   breakpoint
   
   ## Remove from memory
   module_RemoveFromMemory moduleName, oldProjectFolder
   
   ## Move folder
   revMoveFolder oldModuleFolder, newModuleFolder
   
   if the shiftKey is "Up" then
      ## Re-index and re-load
      project_ExportMenusAndStackFiles oldProjectFolder
      project_ExportMenusAndStackFiles newProjectFolder
   end if
   
   ## Refresh index views
   display_Project oldProjectName
   display_Project newProjectName   
   
   -- display_ProjectModules oldProjectName
   -- display_ProjectModules newProjectName   
end menu_MoveModule

private on _
end _

on menu_RenameModule shortModuleFolder
   breakpoint
   
   put LocalArray ["moduleName"] into oldModuleName
   put LocalArray ["projectName"] into projectName
   --
   put lcw_Ask ("Give this module a new name...", oldModuleName) into newModuleName
   module_Rename oldModuleName, newModuleName, projectName
   --
   display_ProjectLibs projectName
   display_ProjectModules projectName
end menu_RenameModule

on menu_ShowModule shortModuleFolder
   put env_GetModuleHomePath (shortModuleFolder) into moduleStackPath
   -- 
   toplevel stack moduleStackPath
   show stack moduleStackPath
   --
   put LocalArray ["displayView"] into displayView
   put globalLoc (the loc of displayView) into gLoc
   set the loc of stack moduleStackPath to gLoc
end menu_ShowModule
