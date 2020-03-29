procedure( kipADENetlistRun()
    let( (sessionName)
    sessionName = sevSession(hiGetCurrentWindow())
    sevNetlistFile(sessionName 'create)
    sevRun(sessionName)
    )    
)

procedure( kipADERun()
   
   procedure( kipFileMV(session status)
    println("Hello World!")
    printf("Session:%L \n Status:%L \n " session status)
    let((sessionObj simFileList)
    sessionObj = asiGetCurrentSession()
    simFileList = asiGetModelLibSelectionList(sessionObj)
    foreach( fileDirList simFileList
        fileDir = car(fileDirList)
        println(fileDir)
        fileIndex = int(nindex( fileDir "/netlist_en" ))
        fileDir = substring(fileDir 1 fileIndex-1)
        println(fileDir)
        setShellEnvVar("FILEDIR" fileDir)
        sh("rm -rf n$FILEDIR/netlist_en")
        sh("mv $FILEDIR/netlist_en.bak $FILEDIR/netlist_en")
        unsetShellEnvVar("FILEDIR") 
        ) ;for each
       ) ;for let
    )
    
 let( ( sessionName  sessionObj simFileList )
    sessionName = sevSession(hiGetCurrentWindow())
    sessionObj = asiGetCurrentSession()
     
    asiRegCallBackOnSimCompForDist(sessionObj 'kipFileMV)
    
    simFileList = asiGetModelLibSelectionList(sessionObj)
    ;print(simFileList)
    ;fileNumber = length(simFileList)
    ;declare(fileDirArray[fileNumber])
    
    foreach( fileDirList simFileList
        fileDir = car(fileDirList)
        println(fileDir)
        fileIndex = int(nindex( fileDir "/netlist_en" ))
        fileDir = substring(fileDir 1 fileIndex-1)
        println(fileDir)
        setShellEnvVar("FILEDIR" fileDir)
        sh("cp $FILEDIR/netlist_en $FILEDIR/netlist_en.bak")
        sh("~/scripts/spectre_decrypt -i $FILEDIR/netlist_en -o $FILEDIR/netlist_en -key $FILEDIR/kdskey")
        sh("spectre_encrypt -i $FILEDIR/netlist_en -o $FILEDIR/netlist_en_tmp -all -key 2")
        sh("rm -rf $FILEDIR/netlist_en")
        sh("mv $FILEDIR/netlist_en_tmp $FILEDIR/netlist_en")
        unsetShellEnvVar("FILEDIR")    
    );for each
    
    sevRun(sessionName)
 
    ;if(simSessionName then
    ;sh("rm -rf $FILEDIR/netlist_en")
    ;sh("mv $FILEDIR/netlist_en.bak $FILEDIR/netlist_en" )
    
    ;);if
    
    ) ;let 
);procedure


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




