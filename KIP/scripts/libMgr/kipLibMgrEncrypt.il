procedure(kipNetlistEncrypt( lib cell view )
	let( ( cvNewName viewSelected cvSelectedID cellCopyed cellCopyedTermOrder selectedCellCDFId encryptCellId encryptCellCDFId
			  encryptCellCDFSpectreList termOrderValue termOrderList encryptCellCDFSpectreListNew 
			  schWindowID encryptCVSchID cellCopyedSchID insDbObj sessionId encryptCellObj netlistDir encryptCellPath sessionOn )
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
       ;print(encryptCellCDFSpectreListNew)
       encryptCellCDFId->simInfo->spectre =  encryptCellCDFSpectreListNew 
	   cdfSaveCDF(encryptCellCDFId)
;Create Toplogy Schematic
       schWindowID = deNewCellView( lib cvNewName "schematic" "schematic" list(list(0 0) list(500 600)))
	   encryptCVSchID = ddGetObj(lib cvNewName "schematic")      
       cellCopyedSchID = dbOpenCellViewByType(lib cvNewName "schematic")
       ;insDbObj = dbCreateInstByMasterName( cellCopyedSchID lib cell "symbol" nil list(0,0) "R0")
	   insDbObj = schCreateInst( cellCopyedSchID viewSelected nil list(0,0) "R0")
;Ignore Popout Warnings
	   envSetVal("schematic" "srcFloatingIO"  'cyclic "ignored")
	   envSetVal("schematic" "srcFloatingInput"  'cyclic "ignored")
	   envSetVal("schematic" "srcFloatingOutput"  'cyclic "ignored")
       schHiCheckAndSave()
       hiCloseWindow(schWindowID)
	   envSetVal("schematic" "srcFloatingIO"  'cyclic "warning")
	   envSetVal("schematic" "srcFloatingInput"  'cyclic "warning")
	   envSetVal("schematic" "srcFloatingOutput"  'cyclic "warning")
;Generate Netlist       
       sevStartSession(?design nil ?lib lib ?cell cvNewName ?view "schematic")
       sessionId = asiGetCurrentSession()
       asiNetlist(sessionId)
;Delete Toplogy Schematic
       ddDeleteObj(encryptCVSchID)
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
	   sh("kip enc -i $NETLISTDIR/netlist_con -o $ENCRYPTCELLDIR/netlist_en -all -key -g ");> /dev/null 2>&1
       sh("cp $(dirname $(readlink -f $0))/kdskey $ENCRYPTCELLDIR")
       ;unsetShellEnvVar("NETLISTDIR")
       ;unsetShellEnvVar("ENCRYPTCELLDIR")
       ;unsetShellEnvVar("CELLVIEWNAME")
       sessionOn = sevSession(hiGetCurrentWindow())
       sevQuit(sessionOn)

	);end of let
);end of procedure


procedure(kipVerilogEncrypt( lib cell view )
	let(( cvNewName viewSelected cvSelectedId selectedCellCDFID selectedCellCDFSpectreList 
				encryptCellID encryptCellCDFID cvCopyID cvPath encryptCVPath )
		
	    cvNewName = strcat( cell "_en" )      	               
       	cvPath = strcat(dbFullLibPath( lib )  "/" cell)
       	encryptCVPath = strcat(dbFullLibPath( lib )  "/" cvNewName)
		;setShellEnvVar("CVNEWNAME" cvNewName)
       	setShellEnvVar("CVDIR" cvPath)
       	setShellEnvVar("ENCRYPTCVDIR" encryptCVPath)
        ;kip_path_full = strcat( getShellEnvVar("HOME") buildString(parseString( kip_path "~" )) )
		setShellEnvVar("KEY_PATH" strcat( kip_path "/scripts/encrypt/key_pairs/pubkey" ))
		sh("cp -r $CVDIR $ENCRYPTCVDIR")
		ddUpdateLibList()
		;sh("xmprotect -autoprotect -outdir $ENCRYPTCVDIR/veriloga -outname veriloga.va -overwrite $CVDIR/veriloga/veriloga.va")
		sh("echo $KEY_PATH")
		sh("kip prot $ENCRYPTCVDIR/veriloga/veriloga.va -file $ENCRYPTCVDIR/veriloga/veriloga.vap -autoprotect -key $KEY_PATH ")		;> /dev/null 2>&1
		sh("mv -f $ENCRYPTCVDIR/veriloga/veriloga.vap $ENCRYPTCVDIR/veriloga/veriloga.va ")
       	unsetShellEnvVar("CVDIR")
       	unsetShellEnvVar("ENCRYPTCVDIR")
		unsetShellEnvVar("KEY_PATH")
	);end of let
);end of procedure

procedure(kipQRCEncrypt( lib cell view )
	cvNewNameToADE = strcat( cell "_en" )
	libToADE = lib
	cellToADE = cell
	let( ( cvNewName viewSelected cvSelectedID cellCopyed cellCopyedTermOrder selectedCellCDFId encryptCellId encryptCellCDFId
			  encryptCellCDFSpectreList termOrderValue termOrderList encryptCellCDFSpectreListNew 
			  schWindowID encryptCVSchID cellCopyedSchID insDbObj sessionId encryptCellObj netlistDir encryptCellPath sessionOn )
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
       ;print(encryptCellCDFSpectreListNew)
       encryptCellCDFId->simInfo->spectre =  encryptCellCDFSpectreListNew 
	   cdfSaveCDF(encryptCellCDFId)
;Create Toplogy Schematic
       schWindowID = deNewCellView( lib cvNewName "schematic" "schematic" list(list(0 0) list(500 600)))
	   encryptCVSchID = ddGetObj(lib cvNewName "schematic")      
       cellCopyedSchID = dbOpenCellViewByType(lib cvNewName "schematic")
       ;insDbObj = dbCreateInstByMasterName( cellCopyedSchID lib cell "symbol" nil list(0,0) "R0")
	   insDbObj = schCreateInst( cellCopyedSchID viewSelected nil list(0,0) "R0")
;Ignore Popout Warnings
	   envSetVal("schematic" "srcFloatingIO"  'cyclic "ignored")
	   envSetVal("schematic" "srcFloatingInput"  'cyclic "ignored")
	   envSetVal("schematic" "srcFloatingOutput"  'cyclic "ignored")
       schHiCheckAndSave()
       hiCloseWindow(schWindowID)
	   envSetVal("schematic" "srcFloatingIO"  'cyclic "warning")
	   envSetVal("schematic" "srcFloatingInput"  'cyclic "warning")
	   envSetVal("schematic" "srcFloatingOutput"  'cyclic "warning")
	   simPrintInhConnAttributes=nil
	   configID = deNewCellView(lib cvNewName "config" "config" list(list(0 0) list(500 600) ))
	
	   ;ddDeleteObj(encryptCVSchID)
	   ;deDeleteObj(configID)
);end let
);end procedure
