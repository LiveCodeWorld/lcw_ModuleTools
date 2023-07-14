script "Global | Module | Model | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Module | Model | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   put _ModuleObject (tObject) into vObject
   if exists (vObject) is false then return empty
   --
   put the displayed_Data of vObject into LocalArray ["displayed_Data"]
   put the module_ModelNames of vObject into LocalArray ["module_ModelNames"]
   --
   return vObject
end menu_Target

private function _ModuleObject tObject
   put the display_View of tObject into dView
   -- put the ix_View of tObject into vObject
   if exists (dView) is true then
      put the displayed_Object of dView into vObject
   else
      put the view_Object of tObject into vObject
   end if
   return vObject
end _ModuleObject

getprop importData_Param [vObject]
   put LocalArray ["displayed_Data"]["modelName"] into modelName
   if modelName is empty then
      put the view_ModelName of vObject into modelName
   end if
   return modelName
end importData_Param

getprop importData_Params [vObject]
   return LocalArray ["module_ModelNames"]
end importData_Params

getprop displayModelData_Params [vObject]
   return LocalArray ["module_ModelNames"]
end displayModelData_Params

getprop deleteModelData_Params [vObject]
   return LocalArray ["module_ModelNames"]
end deleteModelData_Params

getprop disabled_DisplayModelData [vObject]
   return LocalArray ["module_ModelNames"] is empty
end disabled_DisplayModelData

getprop disabled_ImportData [vObject]
   return LocalArray ["module_ModelNames"] is empty
end disabled_ImportData

getprop disabled_DeleteModelData [vObject]
   return LocalArray ["module_ModelNames"] is empty
end disabled_DeleteModelData


--> Global | Module | Model | Menu
-
on menu_ImportData vObject, modelName
   put the module_Model [modelName] of vObject into sTableData
   --
   set the displayed_Data [modelName] of vObject to sTableData
   --
   if the shiftKey is "Down" then
      display_ModuleModel vObject, modelName
   end if
end menu_ImportData

on menu_ExportData vObject
   ask_ExportModuleData vObject, true
end menu_ExportData

on menu_DeleteModelData vObject, modelName
   put the module_ModelFile [modelName] of vObject into mFile
   lcw_Answer "Delete file '[[modelName]]?", vObject, modelName
   --
   revDeleteFile mFile
end menu_DeleteModelData

private on _
end _

on menu_RevealDataFolder vObject
   put the module_ModelFolder of vObject into moduleModelFolder
   finder_Reveal moduleModelFolder
end menu_RevealDataFolder

on menu_DisplayModelData vObject, modelName
   display_ModuleModel vObject, modelName
end menu_DisplayModelData

private on __
end __

on menu_ShowDisplayedData vObject
   put the displayed_Data of vObject into dArray
   put the view_ModelName of vObject into modelName
   --
   display_Data dArray, modelName, "displayed_Data"
end menu_ShowDisplayedData

on menu_SaveData vObject
   dispatch "save_Data" to vObject
   get the result
   --
   put the displayed_Data of vObject into testData
   display_Data testData, mName, "displayed_Data"
end menu_SaveData

on menu_ClearData vObject
   dispatch "clear_Data" to vObject
end menu_ClearData
