procedure( kipCellViewEncrypt( lib cell view )
     
;Encrypt Verilog
	if(( view == "verilog" || view == "veriloga") then
       kipVerilogEncrypt( lib cell view)
	)
;Encrypt Netlist
	if(( view == "schematic" || view == "layout" || view == "maskLayout") then
       kipNetlistEncrypt( lib cell view)
	)

);end procedure
