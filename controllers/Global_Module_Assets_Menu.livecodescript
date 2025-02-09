script "Global | Module | Assets | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Module | Assets | Menu
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
   put the displayed_Object of tObject into sObject
   if exists (sObject) then return sObject
   
   return tObject
end menu_Target

getprop menu_CheckTarget [browserView]
   if exists (browserView) is false then
      return false
   else
      put the module_ShortHtmlFiles of browserView into LocalArray ["module_ShortHtmlFiles"]
      return true
   end if
end menu_CheckTarget


--> Global | Module | Assets | Menu
-
on menu_EditHtml browserView, shortHtmlFile
   put the module_HtmlFile [shortHtmlFile] of browserView into localFile
   -- atom_DisplayFile localFile
   code_EditFile localFile
end menu_EditHtml

getprop editHtml_Params
   put LocalArray ["module_ShortHtmlFiles"] into shortFiles
   return shortFiles
end editHtml_Params

private on _
end _

on menu_StopWatchingEverything
   watch_Stop
end menu_StopWatchingEverything

on menu_WatchFile browserView, shortHtmlFile
   put the module_HtmlFile [shortHtmlFile] of browserView into localFile
   put watch_ListShortWatchFiles (LocalWatchName) into shortWatchFiles
   
   if shortHtmlFile is among the lines of shortWatchFiles then
      watch_StopWatchingFile localFile, LocalWatchName
   else
      watch_Files localFile, LocalWatchName
   end if
end menu_WatchFile

getprop watchFile_Param
   put watch_ListShortWatchFiles (LocalWatchName) into shortWatchFiles
   return shortWatchFiles
end watchFile_Param

getprop watchFile_Params
   put LocalArray ["module_ShortHtmlFiles"] into shortFiles
   return shortFiles
end watchFile_Params

on menu_WatchFiles browserView, someBoolean
   if someBoolean is false then
      watch_Stop LocalWatchName
   else
      put the project_HtmlFiles of browserView into filesToWatch
      watch_Files filesToWatch, LocalWatchName
   end if
end menu_WatchFiles

getprop disabled_WatchFiles
   put LocalArray ["module_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_WatchFiles

private on __
end __

on menu_DisplayLocalFile browserView, shortHtmlFile
   put the module_HtmlFile [shortHtmlFile] of browserView into localFile
   --
   if there is a file localFile then
      set the browser_File of browserView to localFile
   else
      breakpoint
   end if
end menu_DisplayLocalFile

getprop displayLocalFile_Params
   put LocalArray ["module_ShortHtmlFiles"] into shortFiles
   return shortFiles
end displayLocalFile_Params

getprop disabled_DisplayLocalFile
   put LocalArray ["module_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_DisplayLocalFile

on menu_DisplayHtmlText browserView, shortHtmlFile
   put the module_HtmlFile [shortHtmlFile] of browserView into someHTML
   set the htmltext of browserView to someHTML
end menu_DisplayHtmlText

getprop displayHtmlText_Params
   put LocalArray ["module_ShortHtmlFiles"] into shortFiles
   return shortFiles
end displayHtmlText_Params

getprop disabled_DisplayHtmlText
   put LocalArray ["module_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_DisplayHtmlText

on menu_DisplayInBrowser browserView, shortHtmlFile
   put the module_HtmlFile [shortHtmlFile] of browserView into localFile
   launch localFile with "/Applications/Firefox.app"
   -- launch url ("file:///" & localFile) with "/Applications/Firefox.app"
end menu_DisplayInBrowser

getprop displayInBrowser_Params
   put LocalArray ["module_ShortHtmlFiles"] into shortFiles
   return shortFiles
end displayInBrowser_Params

getprop disabled_DisplayInBrowser
   put LocalArray ["module_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_DisplayInBrowser

private on ___
end ___

on menu_XtermAssetFolder sView
   put the module_AssetFolder of sView into assetFolder
   --
   display_XtermAtFolder assetFolder
end menu_XtermAssetFolder

on menu_ModuleAssetFolder browserView
   put the module_AssetFolder of browserView into assetFolder
   finder_Reveal assetFolder
end menu_ModuleAssetFolder

on menu_ProjectAssetFolder browserView
   put the project_AssetFolder of browserView into assetFolder
   finder_Reveal assetFolder
end menu_ProjectAssetFolder

private on ____
end ____

on menu_CreateHtmlFile browserView
   put lcw_Ask ("What file name would you like for the new HTML file?", "xxx.html") into shortHtmlFile
   put the module_HtmlFile [shortHtmlFile] of browserView into localFile
   if there is a file localFile then
      display_Text localFile
      answer warning merge ("There is already a file named '[[shortHtmlFile]]' in the modules asset folder! Do you want to overwrite it?") with "Yes" or "Cancel"
      if it is "Cancel" then exit to top
   end if
   
   put the clipboarddata ["text"] into maybeText
   put maybeText into url ("file:" & localFile)
   atom_DisplayFile localFile
end menu_CreateHtmlFile

on menu_TrashAssets sView
   put the module_AssetFolder of sView into assetFolder
   --
   lcw_Answer "Move asset folder to trash?", sView
   --
   revDeleteFolder assetFolder
   create folder assetFolder
end menu_TrashAssets
