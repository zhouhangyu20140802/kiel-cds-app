procedure( kipIPUploadCallback(menuName lib cell view file category)
       let(( ipPath )
       
           ipPath = strcat(dbFullLibPath( lib )  "/" cell)
           setShellEnvVar("IPPATH" ipPath)
           sh("kteam initIp $IPPATH")
           unsetShellEnvVar("IPPATH")        
       
       )       
       
         
);end of procedure
