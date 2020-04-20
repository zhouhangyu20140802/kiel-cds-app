procedure( kipADENetlistRun()
    let( (sessionName)
    sessionName = sevSession(hiGetCurrentWindow())
    sevNetlistFile(sessionName 'create)
    sevRun(sessionName)
    )    
)

procedure( kipADERun()
 simFileList = asiGetModelLibSelectionList(asiGetCurrentSession()) 

 let( ( sessionName  sessionObj netlistFileList fileDir fileSection )
    
	sessionName = sevSession(hiGetCurrentWindow())
    sessionObj = asiGetCurrentSession()
    ;simFileList = asiGetModelLibSelectionList(sessionObj) 
    asiRegCallBackOnSimComp(sessionObj 'kipFileMV)
        
	netlistFileList = setof( x simFileList (nindex( car(x) "/veriloga.va") == nil))
    foreach( fileDirList simFileList
        fileDir = car(fileDirList)	
        ;println(fileDir)
  		kipFileDecrypt(fileDir)
    );end each
	
	asiRemoveAllModelLibSelection(sessionObj)
	foreach(	fileDirList netlistFileList
		fileDir = car(fileDirList)
		fileSection = cadr(fileDirList)
		asiAddModelLibSelection( sessionObj fileDir fileSection )
	)
	    
    sevRun(sessionName)

	);let 
);procedure


procedure( dataTrans(list)
	list = simFileList
)

procedure( kipFileMV(session status)
	
    let((sessionObj fileDir fileSection)
	;dataTrans(simFilelist)
    sessionObj = asiGetCurrentSession()
    ;simFileList = asiGetModelLibSelectionList(sessionObj)
    foreach( fileDirList simFileList
        fileDir = car(fileDirList)		
	    if(nindex( fileDir "/netlist_en" ) != nil then
			fileIndex = int(nindex( fileDir "/netlist_en" ))
        		fileDir = substring(fileDir 1 fileIndex-1)
        		println(fileDir)
        		setShellEnvVar("FILEDIR" fileDir)
        		sh("rm -rf $FILEDIR/netlist_en")
	        sh("mv $FILEDIR/.netlist_en.bak $FILEDIR/netlist_en")
        		unsetShellEnvVar("FILEDIR")
			);end if

	    if(nindex( fileDir "/veriloga.va" ) != nil then
			fileIndex = int(nindex( fileDir "/veriloga.va" ))
        		fileDir = substring(fileDir 1 fileIndex-1)
        		println(fileDir)
        		setShellEnvVar("FILEDIR" fileDir)
        		sh("rm -rf $FILEDIR/veriloga.va")
	        sh("mv $FILEDIR/.veriloga.va.bak $FILEDIR/veriloga.va")
        		unsetShellEnvVar("FILEDIR")
			);end if
  
        ) ;end each
	;asiLoadState(sessionObj ?option 'cellview)
	asiRemoveAllModelLibSelection(sessionObj)
	foreach(	fileDirList simFileList
		fileDir = car(fileDirList)
		fileSection = cadr(fileDirList)
		asiAddModelLibSelection( sessionObj fileDir fileSection )
			);end each
 	asiUnRegCallBackOnSimComp(sessionObj 'kipFileMV)
       ) ;end let
    );end procedure
   

procedure( kipADEStop()
 let( (sessionName)
    sessionName = sevSession(hiGetCurrentWindow())
    sevStopEngine(sessionName)
    )  
)

procedure( kipADENetlistCreate()
 let( ( sessionName ) 
    sessionName = sevSession(hiGetCurrentWindow())
    sevNetlistFile(sessionName 'create)
    )  
)

procedure( kipADENetlistDisplay()
 let( ( sessionName )
    sessionName = sevSession(hiGetCurrentWindow())
    sevNetlistFile(sessionName 'd)
    ) 
)

procedure( kipADENetlistRecreate()
    let( ( sessionName )
    sessionName = sevSession(hiGetCurrentWindow())
    sevNetlistFile(sessionName 'recreate)
    ) 
)

procedure( kipADENetlistEncryptCreate()
   kipADEEncrypt()
)




