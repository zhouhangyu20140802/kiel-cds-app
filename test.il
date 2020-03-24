procedure( Func()
   let(()
      printf("In Func\n")
   )
)



;procedure(Kiel(_args)
;let( (TrMenuItemOne TrMenuItemTwo) 
;        TrMenuItemOne = hiCreateMenuItem( ?name 'TrMenuItemOne ?itemText "One" ?callback "println(\"bull\")" )
;        TrMenuItemTwo = hiCreateMenuItem( ?name 'TrMenuItemTwo ?itemText "Two" ?callback "println(\"shit\")" )
;        list(hiCreatePulldownMenu( 'TrPulldownMenu "Example Menu" '(TrMenuItemOne TrMenuItemTwo) ))
;))
 /*
 let((viewtype)
        foreach(viewtype list("maskLayout" "layout" "schematic")
        when( get( deGetAppInfo(viewtype) 'userMenuTrigger )!=nil deUnRegUserTriggers(viewtype))
        deRegUserTriggers(viewtype nil 'Kiel)
        ) ;end of foreach
 
 );end of let
*/


;if( member( 'TrPulldownMenu hiGetBannerMenus( window(1)) )) != nil then
    ;hiDeleteBannerMenu( window(1) 99 )
;else 
    ;hiInsertBannerMenu()  
       


        ;else 
        ;hiInsertBannerMenu( window(1) Kiel(0) 66 )                     
;        );end if 


;menuList = hiGetBannerMenu( window(1) )
;if( hiGetMenuItems(TrPulldownMenu) !=nil then 
;    hiInsertBannerMenu( window(1) 'TrPulldownMenu 999 )
;else
;   hiDeleteBannerMenu( window(1) 'TrPulldownMenu )
;   hiInsertBannerMenu( window(1) 'TrPulldownMenu 999 )







;one = 1
;two = '(2,3)
;three = '(2,1)
;evenMoreNumbers = cons( 1 append( two three ) )
;print(evenMoreNumbers)

/*result = nil
result = cons( 3 cons( 2 cons( 1 result ) ) )
reverse( result )
print( result )*/

/*left = '( 1 2 3 )
right = '( 4 5 6 )
left = cons( cons( left right) left )
println(left)*/

;ins = geOpen(
;    ?lib    "test"
;   ?cell    "lnaSimple
;   ?view    "schematic"
;  ?mode    "r"   
;)

;ins~>  


;println(append( left right ))
;println(append( right left ))
;println(cons( left right ))
;println(cons( right left ))
