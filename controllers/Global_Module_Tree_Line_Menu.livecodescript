﻿script "Global | Module | Tree | Line | Menu"
--> MetaData
-
license: GPLv3
name: Global | Module | Tree | Line | Menu
type: controller
version: 0.2

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Menu | Init
-
local LocalArray

getprop menu_Target [tObject]
   put the display_View of tObject into displayView
   put the displayed_Object of displayView into viewObject
   put the top_Line of tObject into shortFolder
   --
   put shortFolder into LocalArray ["shortFolder"]
   put displayView into LocalArray ["displayView"]
   --
   return viewObject
end menu_Target

getprop disabled_Library [viewObject]
   return LocalArray ["shortFolder"] is not "Libraries"
end disabled_Library

getprop disabled_Library [viewObject]
   return LocalArray ["shortFolder"] is not "Libraries"
end disabled_Library

getprop disabled_Controller [viewObject]
   return LocalArray ["shortFolder"] is not "Controllers"
end disabled_Controller

getprop disabled_Module [viewObject]
   return LocalArray ["Modules"] is not "Models"
end disabled_Module

getprop disabled_Model [viewObject]
   return LocalArray ["shortFolder"] is not "Models"
end disabled_Model

getprop disabled_View [viewObject]
   return LocalArray ["shortFolder"] is not "Views"
end disabled_View

private function _GetMenu menuBit
   put the long id of me into myController
   put merge ("Global | Module | [[menuBit]] | Line | Menu") into gMenuTitle
   return gMenuTitle
end _GetMenu

private function _SelectedLine
   put LocalArray ["displayView"] into displayView
   return the selected_Line of displayView
end _SelectedLine

private function _FilePath
   put LocalArray ["displayView"] into displayView
   put the displayed_ModuleFolder of displayView into mFolder
   put the selected_Path of displayView into pathBit
   replace comma with slash in pathBit
   --
   put mFolder & pathBit into sFile
   return sFile
end _FilePath

private function _ModuleFolder
   put LocalArray ["displayView"] into displayView
   put the displayed_ModuleFolder of displayView into mFolder
   return mFolder
end _ModuleFolder

getprop disabled_TrashMenu [viewObject]
   return LocalArray ["shortFolder"] is not "controllers"
end disabled_TrashMenu

getprop disabled_Behavior [viewObject]
   return LocalArray ["shortFolder"] is not "Behaviors"
end disabled_Behavior

getprop disabled_RemoveBehavior [viewObject]
   return LocalArray ["shortFolder"] is not "Behaviors"
end disabled_RemoveBehavior


--> Global | Module | Tree | Line | Menu
-
on menu_TrashMenu viewObject
   put _FilePath() into stackPath
   put the short name of stack stackPath into mName
   --
   put LocalArray ["displayView"] into displayView
   lcw_Answer "Trash Menu '[[mName]]?", displayView, mName
   --
   module_TrashStack stackPath
   --
   put the title_Text of displayView into moduleName
   display_ModuleTools moduleName
   -- put the project_Name of stack moduleName into projectName
   -- display_Project projectName, true
   -- display_GitRefreshProjectName projectName
end menu_TrashMenu

on menu_RemoveBehavior viewObject
   put the behavior_Objects of viewObject into bObjects
   put _FilePath() into sFile
   --
   if exists (stack sFile) then
      put the name of stack sFile into bObject
      line_Delete bObject, bObjects
      put bObjects
   else
      breakpoint
   end if
end menu_RemoveBehavior

on menu_ViewProperty viewObject 
   put LocalArray ["viewProp"] into viewProp
   --
   put the viewProp of viewObject
end menu_ViewProperty

on _
end _

on submenu_Controller
   return _GetMenu ("Controllers")
end submenu_Controller

on submenu_Library
   return _GetMenu ("Lib")
end submenu_Library

on submenu_Model
   return _GetMenu ("Model")
end submenu_Model

on submenu_View
   return _GetMenu ("View")
end submenu_View

on submenu_Behavior
   return _GetMenu ("Behavior")
end submenu_Behavior


