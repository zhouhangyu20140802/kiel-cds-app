procedure( kipCellViewEncrypt( lib cell view )

       cellNewName = strcat( cell "_en" )
       if( (view == "verilog" || view == "veriloga") then
       viewSelected = dbOpenCellViewByType( lib cell view  )
       ;cellSelectedId = ddGetObj( lib cell )
       dbCopyCellView( viewSelected lib cellNewName view)
       viewSelected = dbOpenCellViewByType( lib cell "symbol" ) 
       dbCopyCellView( viewSelected lib cellNewName "symbol")
               
;Encrypt Verilog
       cellPath = strcat(dbFullLibPath( lib )  "/" cell)
       encryptCellPath = strcat(dbFullLibPath( lib )  "/" cellNewName)
       setShellEnvVar("CELLDIR" cellPath)
       setShellEnvVar("ENCRYPTCELLDIR" encryptCellPath)
       sh("xmprotect -autoprotect -outdir $ENCRYPTCELLDIR/veriloga -outname veriloga.va -overwrite $CELLDIR/veriloga/veriloga.va")
       unsetShellEnvVar("CELLDIR")
       unsetShellEnvVar("ENCRYPTCELLDIR")
      else
;Create spectre view       
       viewSelected = dbOpenCellViewByType(lib cell "symbol")
       cellSelectedId = ddGetObj( lib cell )
       cellCopyed = dbCopyCellView(viewSelected lib cellNewName "spectre")
       cellCopyedTermOrder = cellCopyed->portOrder
;Spectre model CDF configeration:Component Parameters & Simulaiton Information
       selectedCellCDFId = cdfGetBaseCellCDF( cellSelectedId )
       encryptCellId = ddGetObj( lib cellNewName )
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
       schWindowID = deNewCellView( lib cellNewName "schematic" "schematic" list(list(0 0) list(500 600)))      
       cellCopyedSchID = dbOpenCellViewByType(lib cellNewName "schematic")
       insDbObj = dbCreateInstByMasterName( cellCopyedSchID lib cell "symbol" nil list(0,0) "R0") 
       schHiSaveCellView()
       ;hiFormClose(hiGetCurrentForm())
       hiCloseWindow(schWindowID)
;Generate Netlist       
       sevStartSession(?design nil ?lib lib ?cell cellNewName ?view "schematic")
       sessionId = asiGetCurrentSession()
       asiNetlist(sessionId)
;Encrypt Netlist
       encryptCellObj = ddGetObj( lib cellNewName )
       netlistDir = asiGetNetlistDir(sessionId)
       encryptCellPath = strcat(dbFullLibPath( lib )  "/" cellNewName)
       setShellEnvVar("NETLISTDIR" netlistDir)
       setShellEnvVar("ENCRYPTCELLDIR" encryptCellPath)
       setShellEnvVar("CELLVIEWNAME" cell) 
       ;sh("spectre_encrypt -i $NETLISTDIR/netlist -o $ENCRYPTCELLDIR/netlist_en -all")
       ;sh("echo $NETLISTDIR")
       sh("cat $NETLISTDIR/netlistHeader $NETLISTDIR/netlist > $NETLISTDIR/netlist_con")
       sh("cp $NETLISTDIR/netlist_con $NETLISTDIR/netlist_con_bak")
       sh("~/scripts/spectre_encrypt -i $NETLISTDIR/netlist_con -o $ENCRYPTCELLDIR/netlist_en -all -key -g")
       sh("cp ~/Encrypted/kdskey $ENCRYPTCELLDIR")
       ;unsetShellEnvVar("NETLISTDIR")
       ;unsetShellEnvVar("ENCRYPTCELLDIR")
       ;unsetShellEnvVar("CELLVIEWNAME")
       sessionOn = sevSession(hiGetCurrentWindow())
       sevQuit(sessionOn)

);end if
);end procedure
