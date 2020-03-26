procedure( kipADENetlistRun()
    let( (sessionName)
    sessionName = sevSession(hiGetCurrentWindow())
    sevNetlistAndRun(sessionName)
    )    
)

procedure( kipADERun()
 let( (sessionName)
    sessionName = sevSession(hiGetCurrentWindow())
    sevRun(sessionName)
    )  
)

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




