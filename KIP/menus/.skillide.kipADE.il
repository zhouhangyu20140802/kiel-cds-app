hiCreateMenuItem( "kipCreateNetlistMenu" "simple" '(("label" "Create Netlist") /*("callback" ("kipLibMgrCallback"))*/) )
hiCreateMenu( "kipMainMenu" '( ( "label" "KIP" ) ) )

hiAddMenuItems( "kipMainMenu" "LCV" '( "kipCreateNetlistMenu"))
hiAddMenuItems("menuBar" "" '( "kipMainMenu" ))
