script "lib_DisplayModule"
--> MetaData
-
license: GPLv3
name: lib_DisplayModule
type: library
version: 0.3


--> Display | Old
-
command display_OldViewFiles
   put view_ListOldShortPaths() into oldViewShortFiles
   --
   display_Data oldViewShortFiles, "Old Views", "Revolution"
   put the result into displayView
   display_SetInteractions displayView, "View | Old", "mDoubleUp_OldView"
   return displayView
end display_OldViewFiles

on mDoubleUp_OldView displayView, shortFile
   if char 1 of shortFile = "." then
      delete char 1 of shortFile
   end if
   --
   put view_OldFolder() & shortFile into oldViewFile
   if there is a stack oldViewFile then
      put the short name of stack oldViewFile into oldName
      delete stack oldName
      --
      go to stack oldViewFile
   else
      breakpoint
      --
      set the itemdelimiter to slash
      put oldViewFile into oldViewFolder
      put empty into item -1 of oldViewFolder
      finder_RevealFileOrFolder oldViewFolder
   end if
end mDoubleUp_OldView

function view_ListOldShortPaths
   put view_OldFolder() into oldViewFolder
   put files (oldViewFolder) into oldViewShortFiles
   sort lines of oldViewShortFiles
   return oldViewShortFiles
end view_ListOldShortPaths

function view_ListOldPaths
   put view_OldFolder() into oldViewFolder
   put file_ListLong (oldViewFolder) into oldViewFiles
   return oldViewFiles
end view_ListOldPaths

function view_OldFolder
   put the documents folder into oldViewFolder
   put "/My Revolution Enterprise/Plugins/opn_Plugins/opn_Components/views/" after oldViewFolder
   return oldViewFolder
end view_OldFolder


--> Display | Events
-
on mDouble_DisplayModuleFromStackName indexView, moduleStackName
   display_ModuleFromStackName moduleStackName
end mDouble_DisplayModuleFromStackName

on mDouble_DisplayModuleFromShortFolder displayView, shortModuleFolder
   if the array_View of displayView is not empty then
      put _SelectedShortFolder (displayView) into shortModuleFolder
   end if
   display_ModuleFromShortModuleFolder shortModuleFolder
end mDouble_DisplayModuleFromShortFolder

on mDouble_EditProp displayView, hName
   put the selected_Path of displayView into relPath
   replace comma with "/" in relPath
   --
   put the displayed_ModuleFolder of displayView into moduleFolder
   put moduleFolder & relPath into filePath
   --
   if there is a stack filePath then
      set the itemdelimiter to "."
      if item -1 of filePath = "livecode" then
         go to stack filePath
      else
         edit the script of stack filePath
      end if
   else
      put filePath
   end if
end mDouble_EditProp


--> Working on
-
command display_ModuleArray pProjectNames
   put env_ListShortModuleFolders (pProjectNames) into moduleNames
   put env_GetShortModuleArray (moduleNames) into moduleArray
   --
   put "false" into foldedArray ["Layout"]["folded"]
   put "true" into foldedArray ["View"]["folded"]
   --
   display_Data moduleArray, "Modules", "Environment", "", "", "", foldedArray
   put the result into displayView
   --
   display_SetInteractions displayView, "Module | List", "mDouble_DisplayModuleFromShortFolder"
   --
   return displayView
end display_ModuleArray

command display_ListModules pProjectNames
   put env_ListShortModuleFolders (pProjectNames) into moduleNames
   --
   display_Data moduleNames, "Modules", "Environment"
   put the result into displayView
   --
   display_SetInteractions displayView, "Module | List", "mDouble_DisplayModuleFromShortFolder"
   --
   return displayView
end display_ListModules

on mDoubleUp_Replace displayView
   put the displayed_Object of displayView into dObject
   if exists (dObject) is false then
      put word -1 of dObject into stackPath
      delete char 1 of stackPath
      delete char -1 of stackPath
      put the left_View of card 1 of stack stackPath into dObject
      breakpoint
   end if
   
   ## Construct viewName
   put _SelectedViewName (displayView) into viewName
   
   ## Old way based on lines
   -- put shortModuleFolder into viewName
   -- replace "_" with "|" in viewName
   
   put default_FirstStackControl (viewName) into tObject
   if exists (tObject) then
      set the view_Replacement of dObject to tObject
      -- set the control_Type [viewPathFragment] of tObject to viewPathFragment
   else
      breakpoint
   end if
end mDoubleUp_Replace

function _SelectedShortFolder displayView
   put _TidySelected (displayView) into shortModuleFolder
   replace comma with "_" in shortModuleFolder
   return shortModuleFolder
end _SelectedShortFolder

private function _SelectedViewName displayView
   put _TidySelected (displayView) into viewName
   replace comma with "|" in viewName
   return viewName
end _SelectedViewName

private function _TidySelected displayView
   put the selected_Path of displayView into sPath
   if item 1 of sPath is not "Layout" then
      if item 1 of sPath is not "View" then
         put "View," before sPath
      end if
   end if
   if item -1 of sPath is "Default" then
      delete item -1 of sPath
   end if
   return sPath
end _TidySelected

private function _ModuleStackPath shortModuleFolder
   put env_GetModuleFolder (shortModuleFolder) into moduleFolder
   put project_FirstStackPath (moduleFolder) into moduleHomeStackPath
   return moduleHomeStackPath
end _ModuleStackPath

command display_ReplaceWithModule tObject
   put env_ListShortModuleFolders() into moduleNames
   put env_GetShortModuleArray (moduleNames) into moduleArray
   put moduleArray ["View"] into prettyArray
   put moduleArray ["Layout"] into prettyArray ["Layout"]
   
   put the short name of tObject into shortName
   put false into fState ["Layout"]["folded"]
   --
   display_Data prettyArray, shortName, "Replace Object", "", false, "", fState
   put the result into displayView
   --
   display_SetInteractions displayView, "Replace | Tree", "mDoubleUp_Replace", "lcw_Tools"
   --
   put the rugged_Name of tObject into rObject
   set the displayed_Object of displayView to rObject
   --
   return displayView
end display_ReplaceWithModule


command module_CloseStackAndTools moduleStackName
   put display_FindView ("Module Tools", moduleStackName) into displayView
   put the stack_Name of displayView into displayStackName
   --
   -- delete stack moduleStackName
   -- delete stack displayStackName
   send ("delete stack" && kwote (moduleStackName)) to me in 2 ticks
   send ("delete stack" && kwote (displayStackName)) to me in 2 ticks
   --
   return displayView
end module_CloseStackAndTools


--> Display | Module
-
command display_ModuleFromStackName moduleStackName
   put the module_Folder of stack moduleStackName into moduleFolder
   display_ModuleFromFolder moduleFolder
end display_ModuleFromStackName

command display_ModuleFromShortModuleFolder shortModuleFolder
   put env_GetModuleFolder (shortModuleFolder) into moduleFolder
   --
   display_ModuleFromFolder moduleFolder
end display_ModuleFromShortModuleFolder

command display_Module mName, pShowTools, pMakeVisible
   put pMakeVisible is not false into pMakeVisible
   view_NormalizeName mName
   put default_FirstStackControl (mName) into mObject
   object_GoTo mObject, pMakeVisible
   
   if the shiftKey is "Down" or pShowTools is true then
      display_ModuleTools mName
   end if
end display_Module

command display_ModuleFromFolder moduleFolder
   -- put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
   put project_FirstStackPath (moduleFolder) into moduleHomeStackPath
   --
   go to stack moduleHomeStackPath
   --
   put the short name of stack moduleHomeStackPath into moduleName
   display_ModuleTools moduleName, false
   --
   return the result
end display_ModuleFromFolder


--> Display | Module | List
-
command display_ProjectModules projectName
   put project_ListModules (projectName) into moduleStackNames
   --
   display_Data moduleStackNames, projectName, "Modules"
   put the result into displayView
   --
   display_SetInteractions displayView, "Modules | Tree", "mDouble_DisplayModuleFromStackName"
   --
   put env_ConstructProjectFolder (projectName) into pProjectFolder
   --
   set the displayed_ProjectFolder of displayView to projectFolder
   set the displayed_ProjectName of displayView to projectName
   return displayView
end display_ProjectModules


--> Deps
-
function project_FirstStackPath projectFolder
   get folder_ListStackPaths (projectFolder)
   return line 1 of it
end project_FirstStackPath

function env_GetModuleFolder shortModuleFolder
   put env_GetModuleShortFolderArray (shortModuleFolder) into shortFolderArray
   return shortFolderArray ["moduleFolder"]
end env_GetModuleFolder

function env_GetModuleHomePath shortModuleFolder
   put env_GetModuleShortFolderArray (shortModuleFolder) into shortFolderArray
   return shortFolderArray ["homeStackPath"]
end env_GetModuleHomePath

function env_GetModuleShortFolderArray shortModuleFolder
   put env_GetModuleArray() into moduleArray
   put moduleArray ["active"][shortModuleFolder] into shortFolderArray
   return shortFolderArray
end env_GetModuleShortFolderArray

