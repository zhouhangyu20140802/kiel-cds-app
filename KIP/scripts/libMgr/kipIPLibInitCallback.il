procedure( kipIPLibInitCallback(menuName lib cell view file category)
       let(( ipLibraryPath )
       
           ipLibraryPath = dbFullLibPath(lib)
           setShellEnvVar("IPLIBRARYPATH" ipLibraryPath)
           sh("kteam initLib $IPLIBRARYPATH")
           unsetShellEnvVar("IPLIBRARYPATH")        
       
       )       
       
         
);end of procedure
