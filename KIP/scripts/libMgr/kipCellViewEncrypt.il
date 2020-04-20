procedure( kipCellViewEncrypt( lib cell view )
     
;Encrypt Verilog
	if(( view == "verilog" || view == "veriloga") then
       kipVerilogEncrypt( lib cell view)
	)
;Encrypt Schematic Netlist
	if(( view == "schematic" ) then
       kipNetlistEncrypt( lib cell view)
	)

;Encrypt QRC Netlist
	if(( view == "config" ) then 
		kipQRCEncrypt( lib cell view)
	)

);end procedure
