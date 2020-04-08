procedure(kipVerilogEncrypt( lib cell view )
	let(( cvNewName viewSelected cvPath encryptCVPath )
		
		cvNewName = strcat( cell "_en" )
		viewSelected = dbOpenCellViewByType( lib cell view  )
       	;cellSelectedId = ddGetObj( lib cell )
       	dbCopyCellView( viewSelected lib cvNewName view)
       	viewSelected = dbOpenCellViewByType( lib cell "symbol" ) 
       	cvCopyID = dbCopyCellView( viewSelected lib cvNewName "symbol" )               
       	cvPath = strcat(dbFullLibPath( lib )  "/" cell)
       	encryptCVPath = strcat(dbFullLibPath( lib )  "/" cvNewName)
       	setShellEnvVar("CVDIR" cvPath)
       	setShellEnvVar("ENCRYPTCVDIR" encryptCVPath)
		sh("xmprotect -autoprotect -outdir $ENCRYPTCVDIR/veriloga -outname veriloga.va -overwrite $CVDIR/veriloga/veriloga.va")
       	unsetShellEnvVar("CVDIR")
       	unsetShellEnvVar("ENCRYPTCVDIR")
	);end of let
);end of procedure
