﻿script "Global | Replace | Tree | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Replace | Tree | Line | Menu
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
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target


--> Global | Replace | Tree | Line | Menu
-
on menu_Experiment displayView
   put displayView
end menu_Experiment


--> Deps
-
