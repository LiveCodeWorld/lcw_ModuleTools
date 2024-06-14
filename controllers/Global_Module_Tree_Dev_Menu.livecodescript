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

--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   return exists (mTarget)
end menu_CheckTarget


--> Global | Module | Tree | Dev | Menu
-
on submenu_ModuleMenu
   return "Global | Module | Menu"
end submenu_ModuleMenu

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

on _CreateStandAlone viewObject
   put LocalArray ["displayView"] into displayView
   --
   put the view_Name of viewObject into vName
   put view_GetTemplateObject (vName) into templateObject
   if exists (templateObject) is false then
      breakpoint
   end if
   
   put the stack_Name of templateObject into stackName
   clone stack stackName
   put it into clonedStack
   set the destroyStack of clonedStack to true
   set the destroyWindow of clonedStack to true
   
   put the long id of cd 1 of clonedStack into clonedTemplateCard
   put the long id of control 1 of clonedTemplateCard into clonedView
   
   set the imported_ViewBehaviors of clonedView to true
      
   display_ViewBehaviors clonedView, empty, clonedStack
end _CreateStandAlone
