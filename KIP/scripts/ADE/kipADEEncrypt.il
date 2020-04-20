procedure(kipADEEncrypt()
	   let((sessionNanme sessionID netlistDir encryptCellPath sessionOn) 
	   sessionName = sevSession(hiGetCurrentWindow())
    	   sessionID = asiGetCurrentSession()
	   simPrintInhConnAttributes=nil
	   asiNetlist(sessionID)
       netlistDir = asiGetNetlistDir(sessionID)
       encryptCellPath = strcat(dbFullLibPath( libToADE )  "/" cvNewNameToADE)
       setShellEnvVar("NETLISTDIR" netlistDir)
       setShellEnvVar("ENCRYPTCELLDIR" encryptCellPath)
       setShellEnvVar("CELLVIEWNAME" cellToADE) 
       ;sh("spectre_encrypt -i $NETLISTDIR/netlist -o $ENCRYPTCELLDIR/netlist_en -all")
       ;sh("echo $NETLISTDIR")
       sh("cat $NETLISTDIR/netlistHeader $NETLISTDIR/netlist > $NETLISTDIR/netlist_con")
       sh("cp $NETLISTDIR/netlist_con $NETLISTDIR/netlist_con_bak")
       ;sh("~/scripts/spectre_encrypt -i $NETLISTDIR/netlist_con -o $ENCRYPTCELLDIR/netlist_en -all -key -g")
	   sh("kip enc -i $NETLISTDIR/netlist_con -o $ENCRYPTCELLDIR/netlist_en -all -key -g ");> /dev/null 2>&1
       sh("cp $(dirname $(readlink -f $0))/kdskey $ENCRYPTCELLDIR")
       ;unsetShellEnvVar("NETLISTDIR")
       ;unsetShellEnvVar("ENCRYPTCELLDIR")
       ;unsetShellEnvVar("CELLVIEWNAME")
       sessionOn = sevSession(hiGetCurrentWindow())
       sevQuit(sessionOn)	

);end let
);end procedure
