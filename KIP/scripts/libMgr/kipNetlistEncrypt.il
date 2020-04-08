procedure(kipNetlistEncrypt( lib cell view )
	let( ( cvNewName viewSelected cvSelectedID cellCopyed selectedCellCDFId 
			encryptCellId encryptCellCDFId encryptCellCDFSpectreList termOrderValue termOrderList schWindowID cellCopyedSchID sessionId netlistDir encryptCellPath sessionOn )
;Create spectre view 
	   
	   cvNewName = strcat( cell "_en" )      
       viewSelected = dbOpenCellViewByType(lib cell "symbol")
       cvSelectedID = ddGetObj( lib cell )
       cellCopyed = dbCopyCellView(viewSelected lib cvNewName "spectre")
       cellCopyedTermOrder = cellCopyed->portOrder
;Spectre model CDF configeration:Component Parameters & Simulaiton Information
       selectedCellCDFId = cdfGetBaseCellCDF( cvSelectedID )
       encryptCellId = ddGetObj( lib cvNewName )
       encryptCellCDFId = cdfCreateUserCellCDF( encryptCellId )
       cdfCopyCDF( encryptCellId "baseCellData" selectedCellCDFId )
       encryptCellCDFId = cdfGetBaseCellCDF(encryptCellId)
       cdfCreateParam( encryptCellCDFId ?name "model" ?type "string" ?parseAsNumber "no" ?prompt "Model Name" ?storeDefault "no" ?parseAsCEL "yes"  ?defValue "" ) 
       encryptCellCDFSpectreList =  encryptCellCDFId->simInfo->spectre
       termOrderValue = cadr(member('termOrder encryptCellCDFSpectreList))
                    
       termOrderList = reverse( cons( termOrderValue '(termOrder) ) )
       encryptCellCDFSpectreListNew =  append( '(nil otherParameters model) termOrderList )
       print(encryptCellCDFSpectreListNew)
       encryptCellCDFId->simInfo->spectre =  encryptCellCDFSpectreListNew 
;Create Toplogy Schematic
       schWindowID = deNewCellView( lib cvNewName "schematic" "schematic" list(list(0 0) list(500 600)))      
       cellCopyedSchID = dbOpenCellViewByType(lib cvNewName "schematic")
       insDbObj = dbCreateInstByMasterName( cellCopyedSchID lib cell "symbol" nil list(0,0) "R0") 
       schHiCheckAndSave()
	   ;schHiSaveCellView()
       ;hiFormClose(hiGetCurrentForm())
       hiCloseWindow(schWindowID)
;Generate Netlist       
       sevStartSession(?design nil ?lib lib ?cell cvNewName ?view "schematic")
       sessionId = asiGetCurrentSession()
       asiNetlist(sessionId)
;Encrypt Netlist
       encryptCellObj = ddGetObj( lib cvNewName )
       netlistDir = asiGetNetlistDir(sessionId)
       encryptCellPath = strcat(dbFullLibPath( lib )  "/" cvNewName)
       setShellEnvVar("NETLISTDIR" netlistDir)
       setShellEnvVar("ENCRYPTCELLDIR" encryptCellPath)
       setShellEnvVar("CELLVIEWNAME" cell) 
       ;sh("spectre_encrypt -i $NETLISTDIR/netlist -o $ENCRYPTCELLDIR/netlist_en -all")
       ;sh("echo $NETLISTDIR")
       sh("cat $NETLISTDIR/netlistHeader $NETLISTDIR/netlist > $NETLISTDIR/netlist_con")
       sh("cp $NETLISTDIR/netlist_con $NETLISTDIR/netlist_con_bak")
       ;sh("~/scripts/spectre_encrypt -i $NETLISTDIR/netlist_con -o $ENCRYPTCELLDIR/netlist_en -all -key -g")
	   sh("kip enc -i $NETLISTDIR/netlist_con -o $ENCRYPTCELLDIR/netlist_en -all -key -g")
       sh("cp $(dirname $(readlink -f $0))/kdskey $ENCRYPTCELLDIR")
       ;unsetShellEnvVar("NETLISTDIR")
       ;unsetShellEnvVar("ENCRYPTCELLDIR")
       ;unsetShellEnvVar("CELLVIEWNAME")
       sessionOn = sevSession(hiGetCurrentWindow())
       sevQuit(sessionOn)

	);end of let
);end of procedure
