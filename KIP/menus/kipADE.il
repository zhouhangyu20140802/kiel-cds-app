hiCreateMenu( "kipMainMenu" '( ( "label" "KIP" ) ) )
hiCreateMenuItem( "kipCreateNetlistMenu" "simple" '(("label" "Create Netlist") /*("callback" ("kipLibMgrCallback"))*/) )
hiAddMenuItems( "kipMainMenu" "LCV" '( "kipCreateNetlistMenu"))
hiAddMenuItems("menuBar" "" '( "kipMainMenu" ))
