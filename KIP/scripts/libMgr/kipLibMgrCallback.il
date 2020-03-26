procedure( kipLibMgrCallback(menuName lib cell view file category)
       ;printf("%s %s %s %s %s %s\n" menuName lib cell view file category)
       ;printf("%s\n" lib)
       
       encryptViewList = '(
        "schematic"
         "layout"
         "verilog"
         "veriloga"       
       )
;Check the right view type       
;      prog( (view encryptViewList)
;          if( !member( view encryptViewList ) then
;            printf( "Please select the right source." )
;            exit()
;            );end if 
;       );end prog

;       if( !viewSelected
;           printf("There is no symbol in this cellview. Please create one.")       
 ;      )
       
       kipCellViewEncrypt( lib cell view )
         
);end of procedure
