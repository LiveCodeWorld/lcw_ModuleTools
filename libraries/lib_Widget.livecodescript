script "lib_Widget"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_Widget
type: library
version: 0.2

/*
This library is the start of a library to help an authro create a script widget.
*/


--> Working on
-

--> Widget
-
function scriptwidget_ConstructName vName
   set the itemdelimiter to "|"
   delete item 1 of vName
   replace "|" with empty in vName
   put "com.livecode.widget." & tolower (vName) into wName
   return wName
end scriptwidget_ConstructName

getprop view_CreateScript   
   put the long id of the target into sGroup
   put the controlids of sGroup into cIDs
   repeat for each line cID in cIDs
      put the long id of control id cID of sGroup into sControl
      put the short name of sControl into cName
      put the rev_PropertyArray of sControl into revPropertyArray
      --
      delete variable revPropertyArray ["name"]
      delete variable revPropertyArray ["htmltext"]
      delete variable revPropertyArray ["id"]
      --
      put word 1 of sControl into cType
      put _CreateBit (cType, cName) into hBody
      put CR & _ConstructScriptBit (revPropertyArray) after hBody
      --
      put text_InitialCaps (cType) into cWord
      put cWord & cID into controlVarName
      --
      put "_Create" & controlVarName into hName
      put handler_Construct ("command", hName, hBody, true) into sHandler
      put sHandler & CR&CR after sScript
      --
      put "_" & controlVarName into fName
      put "return" && controlVarName into fBody
      put handler_Construct ("function", fName, fBody, true) into sHandler
      put sHandler & CR&CR after objectScript
      
      put merge ("## Create [[cName]] [[cWord]]") & CR after scriptBit
      put hName & CR after scriptBit
      put "put the result into" && controlVarName & CR&CR after scriptBit
      --
      put "local" && controlVarName & CR after localDeclarations
   end repeat
   delete char -1 of scriptBit
   --
   put _ConstructCreateHandler (scriptBit) & CR&CR before sScript
   put localDeclarations & CR&CR before sScript
   --
   put "--> Objects" & CR & "-" & CR after sScript
   put objectScript after sScript
   --
   return sScript
end view_CreateScript

private function _ConstructCreateHandler scriptBit
   put "if sHasCreatedControls then return false" & CR into sBody
   put CR & scriptBit & CR after sBody
   put CR & "put true into sHasCreatedControls" after scriptBit
   put handler_Construct ("command", "_CreateVisualControls", scriptBit, true) into sHandler
   return sHandler
end _ConstructCreateHandler

private function _CreateBit cType, cName
   put merge ("create [[cType]] '[[cName]]' in me") into scriptBit
   replace "'" with quote in scriptBit
   put CR & "put the long id of it into sControl" after scriptBit
   put CR & "--" after scriptBit   
   return scriptBit
end _CreateBit

private function _ConstructScriptBit revPropertyArray
   repeat for each key propName in revPropertyArray
      put revPropertyArray [propName] into propValue
      put merge ("set the [[propName]] of sControl to") && kwote (propValue) & CR after scriptBit
   end repeat
   put "--" & CR after scriptBit
   put "return sControl" & CR after scriptBit
   return scriptBit
end _ConstructScriptBit
