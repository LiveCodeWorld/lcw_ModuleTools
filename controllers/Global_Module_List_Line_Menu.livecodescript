script "Global | Module | List | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Module | List | Line | Menu
type: controller
version: 0.2

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray


--> Events
-
on mDouble_DisplayModuleFromShortFolder displayView, shortModuleFolder
   if the tree_View of displayView is not empty then
      put _SelectedShortFolder (displayView) into shortModuleFolder
   end if
   display_ModuleFromShortModuleFolder shortModuleFolder
end mDouble_DisplayModuleFromShortFolder


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


--> Global | Module | List | Line | Menu
-
/*
See also "Global | Modules | Tree | Line | Menu"
*/

on menu_RevealModuleFolder shortModuleFolder
   put LocalArray ["moduleFolder"] into moduleFolder
   if moduleFolder is empty then
      answer warning "Module folder is empty!"
      breakpoint
      exit to top
   end if
   
   finder_Reveal moduleFolder
end menu_RevealModuleFolder

private on _
end _

on menu_DisplayModule shortModuleFolder
   display_ModuleFromShortModuleFolder shortModuleFolder
end menu_DisplayModule

on menu_DisplayModuleTools shortModuleFolder
   put LocalArray ["moduleName"] into moduleName
   --
   display_ModuleTools moduleName, true
end menu_DisplayModuleTools

private on __
end __

on submenu_Dev
   return menu_DevTitle()
end submenu_Dev
