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
;Generate Netlist       
       sevStartSession(?design nil ?lib lib ?cell cell ?view view)
       sessionId = asiGetCurrentSession()
       asiNetlist(sessionId)
;Encrypt Netlist
       encryptCellObj = ddGetObj( lib cellNewName )
       netlistDir = asiGetNetlistDir(sessionId)
       encryptCellPath = strcat(dbFullLibPath( lib )  "/" cellNewName)
       setShellEnvVar("NETLISTDIR" netlistDir)
       setShellEnvVar("ENCRYPTCELLDIR" encryptCellPath)
       sh("spectre_encrypt -i $NETLISTDIR/netlist -o $ENCRYPTCELLDIR/netlist_en -all")
       unsetShellEnvVar("NETLISTDIR")
       unsetShellEnvVar("ENCRYPTCELLDIR")

);end if
);end procedure
