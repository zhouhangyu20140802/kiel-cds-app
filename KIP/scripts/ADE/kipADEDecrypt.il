procedure( kipFileDecrypt( fileDir )
     let(    (fileIndex)
;Netlist files decrypt
		if(nindex( fileDir "/netlist_en" ) != nil then
            ;Create Netlist File Dir
			fileIndex = int(nindex( fileDir "/netlist_en" ))
        		fileDir = substring(fileDir 1 fileIndex-1)
             ;Create Key File Dir
             keyIndex = int(nindex( fileDir "/netlist" ))
             keyDir = strcat( substring(fileDir 1 keyIndex-1) "/key" )
        		setShellEnvVar("FILEDIR" fileDir)
             setShellEnvVar("KEYDIR" keyDir)
             ;Blockchain write
             sh("kteam use $FILEDIR")
             ;Netlist Decrypted   
        		sh("cp $FILEDIR/netlist_en $FILEDIR/.netlist_en.bak")
        		sh("kip dec -i $FILEDIR/netlist_en -o $FILEDIR/netlist_de -key $KEYDIR/kdskey > /dev/null 2>&1")
        		sh("spectre_encrypt -i $FILEDIR/netlist_de -o $FILEDIR/.netlist_en_tmp -all -key 2 > /dev/null 2>&1")
        		sh("rm -rf $FILEDIR/netlist_de")
        		sh("mv $FILEDIR/.netlist_en_tmp $FILEDIR/netlist_en")
        		unsetShellEnvVar("FILEDIR")
            unsetShellEnvVar("KEYDIR")
			);end if
;Verilog files decrypt
		if(nindex( fileDir "/veriloga.va" ) != nil then
			fileIndex = int(nindex( fileDir "/veriloga.va" ))
        		fileDir = substring(fileDir 1 fileIndex-1)
        		println(fileDir)
        		setShellEnvVar("FILEDIR" fileDir)
			;kip_path_full = strcat( getShellEnvVar("HOME") buildString(parseString( kip_path "~" )) )
			setShellEnvVar("KEY_PATH" strcat( kip_path "/scripts/encrypt/key_pairs/prikey" ))
        		sh("cp $FILEDIR/veriloga.va $FILEDIR/.veriloga.va.bak")
        		sh("kip deprot $FILEDIR/veriloga.va -file $FILEDIR/.veriloga.vad -key $KEY_PATH ");> /dev/null 2>&1
        		sh("xmprotect -autoprotect -language vlog -outdir $FILEDIR -outname .veriloga.vap $FILEDIR/.veriloga.vad ");> /dev/null 2>&1
			sh("rm -rf $FILEDIR/.veriloga.vad")
        		sh("rm -rf $FILEDIR/xmprotect.log")
			sh("mv -f $FILEDIR/.veriloga.vap $FILEDIR/veriloga.va ")
        		unsetShellEnvVar("FILEDIR")
			unsetShellEnvVar("KEY_PATH")
			);end if
		);end let
);end procedure
