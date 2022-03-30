globals [
  FrontierList
  PathList
  mainlist
  sizePath
  diagonalPath
  patch-data
  patchDistance
  xGoal
  yGoal
  index
  j
]
breed [starts start]
breed [goals goal]
to clean-up
  clear-all
  reset-ticks
end
to setup
  set mainlist []
  set FrontierList []
  set PathList []
  set sizePath 0.5
  set diagonalPath sqrt 2 / 2
  set patchDistance 0.5
  set xGoal 0
  set yGoal 0
  create-starts 1 [
    set color blue
    set heading 0
    set size 1
    set shape "person"
    set xcor -15
    set ycor -15
    if (xcor = xGoal and ycor = yGoal)
    [ stop]
    set FrontierList lput (list xcor ycor xcor ycor 0) FrontierList
   ]
    create-goals 1 [
    set color red
    set heading 0
    set size 1
    set shape "person"
    set xcor xGoal
    set ycor yGoal
  ]
end

to goes
  ask starts
  [
    ;setxy (random 20) (random 20)
    if (xcor = xGoal and ycor = yGoal) [
      stop]
    set FrontierList lput (list xcor ycor xcor ycor 0) FrontierList
  ]

  print FrontierList
end

to BFS

  ask starts
  [
    ;set pen-mode "up"
    if(xcor = xGoal and ycor = yGoal) [
      PathSolution
      stop]

    ;set pen-mode "left"
    if(empty? FrontierList) [stop]

    let front first FrontierList ; get avariable
    set FrontierList remove-item 0 FrontierList

    set PathList lput (front) PathList ; add front to Pathlist
    setxy (item 2 front) (item 3 front)
    set pen-mode "down"
    setxy (item 0 front) (item 1 front) ;move to
    set pen-mode "up"
    if (CheckLocation? xcor (ycor + sizePath) and  [pcolor] of patch-at-heading-and-distance 0 patchDistance != 9.9999)
    [
      set FrontierList lput (list xcor (ycor + sizePath) xcor ycor 0) FrontierList
    ]

    if (CheckLocation? (xcor + sizePath) (ycor + sizePath) and  [pcolor] of patch-at-heading-and-distance 45 patchDistance <= (sqrt 2 / 2))
    [
      set FrontierList lput (list (xcor + sizePath) (ycor + sizePath) xcor ycor 0) FrontierList
    ]

    if(CheckLocation? (xcor + sizePath) ycor and  [pcolor] of patch-at-heading-and-distance 90 patchDistance != 9.9999)
    [
      set FrontierList lput (list (xcor + sizePath) ycor xcor ycor 0) FrontierList
    ]

    if (CheckLocation? (xcor + sizePath) (ycor - sizePath) and  [pcolor] of patch-at-heading-and-distance 135 patchDistance <= (sqrt 2 / 2))
    [
      set FrontierList lput (list (xcor + sizePath) (ycor - sizePath) xcor ycor 0) FrontierList
    ]

    if(CheckLocation? xcor (ycor - sizePath) and  [pcolor] of patch-at-heading-and-distance 180 patchDistance != 9.9999)
    [
      set FrontierList lput (list xcor (ycor - sizePath) xcor ycor 0)FrontierList
    ]

    if (CheckLocation? (xcor - sizePath) (ycor - sizePath) and  [pcolor] of patch-at-heading-and-distance 225 patchDistance <= (sqrt 2 / 2))
    [
      set FrontierList lput (list (xcor - sizePath) (ycor - sizePath) xcor ycor 0) FrontierList
    ]

    if(CheckLocation? (xcor - sizePath) ycor and   [pcolor] of patch-at-heading-and-distance 270 patchDistance != 9.9999)
    [
      set FrontierList lput (list (xcor - sizePath) ycor xcor ycor 0)FrontierList

    ];[print  [pcolor] of patch-at-heading-and-distance 270 0.5 != 9.9999]

    if (CheckLocation? (xcor - sizePath) (ycor + sizePath) and  [pcolor] of patch-at-heading-and-distance 315 patchDistance <= (sqrt 2 / 2))
    [
      set FrontierList lput (list (xcor - sizePath) (ycor + sizePath) xcor ycor 0) FrontierList
    ]

  ]
end

to UCS
  ask starts
  [
    ;set pen-mode "up"
    if(xcor = xGoal and ycor = yGoal) [
      PathSolution
      stop]

    ;set pen-mode "left"
    if(empty? FrontierList) [stop]

    ;print FrontierList

    let front first FrontierList ; get avariable
    set FrontierList remove-item 0 FrontierList


    set PathList lput (front) PathList ; add front to Pathlist
    setxy (item 2 front) (item 3 front)
    set pen-mode "down"
    setxy (item 0 front) (item 1 front) ;move to
    set pen-mode "up"



    if([pcolor] of patch-at-heading-and-distance 0 patchDistance != 9.9999)
    [
      ifelse(CheckLocation? xcor (ycor + sizePath))
      [
        ;print "CheckLocation"
        set FrontierList lput (list xcor (ycor + sizePath) xcor ycor (item 4 front + 1) ) FrontierList
      ]
      [
        let pos_s CheckLocationInFrontier? xcor (ycor + sizePath)
        if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s FrontierList))[
          ;print "CheckLocationInFrontier"
          set FrontierList replace-item pos_s FrontierList (list xcor (ycor + sizePath) xcor ycor (item 4 front + 1))
        ]
      ]
    ]

    if([pcolor] of patch-at-heading-and-distance 45 patchDistance <= (sqrt 2 / 2))
    [
      ifelse(CheckLocation? (xcor + sizePath) (ycor + sizePath))
      [
        print "CheckLocation"
        set FrontierList lput (list (xcor + sizePath) (ycor + sizePath) xcor ycor (item 4 front + 1) ) FrontierList
      ]
      [
        let pos_s CheckLocationInFrontier? (xcor + sizePath) (ycor + sizePath)
        if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s FrontierList))[
          print "CheckLocationInFrontier"
          set FrontierList replace-item pos_s FrontierList (list (xcor + sizePath) (ycor + sizePath) xcor ycor (item 4 front + 1))
        ]
      ]
    ]


    if([pcolor] of patch-at-heading-and-distance 90 patchDistance != 9.9999)
    [
      ifelse(CheckLocation? (xcor + sizePath) ycor)
      [
        ;print "CheckLocation"
        set FrontierList lput (list (xcor + sizePath) ycor xcor ycor (item 4 front + 1)) FrontierList
      ]
      [
        let pos_s CheckLocationInFrontier? (xcor + sizePath) ycor
        if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s FrontierList))[
          ;print "CheckLocationInFrontier"
          set FrontierList replace-item pos_s FrontierList (list (xcor + sizePath) ycor xcor ycor (item 4 front + 1))
        ]
      ]
    ]

      if([pcolor] of patch-at-heading-and-distance 135 patchDistance <= (sqrt 2 / 2))
    [
      ifelse(CheckLocation? (xcor + sizePath) (ycor - sizePath) )
      [
        print "CheckLocation"
        set FrontierList lput (list (xcor + sizePath) (ycor - sizePath) xcor ycor (item 4 front + 1)) FrontierList
      ]
      [
        let pos_s CheckLocationInFrontier? (xcor + sizePath) (ycor - sizePath)
        if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s FrontierList))[
          print "CheckLocationInFrontier"
          set FrontierList replace-item pos_s FrontierList (list (xcor + sizePath) (ycor - sizePath) xcor ycor (item 4 front + 1))
        ]
      ]
    ]

    if([pcolor] of patch-at-heading-and-distance 180 patchDistance != 9.9999)
    [
      ifelse(CheckLocation? xcor (ycor - sizePath))
      [
        ;print "CheckLocation"
        set FrontierList lput (list xcor (ycor - sizePath) xcor ycor (item 4 front + 1)) FrontierList
      ]
      [
        let pos_s CheckLocationInFrontier? xcor (ycor - sizePath)
        if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s FrontierList))[
          ;print "CheckLocationInFrontier"
          set FrontierList replace-item pos_s FrontierList (list xcor (ycor - sizePath) xcor ycor (item 4 front + 1))
        ]
      ]
    ]

     if([pcolor] of patch-at-heading-and-distance 225 patchDistance <= (sqrt 2 / 2))
    [
      ifelse(CheckLocation? (xcor - sizePath) (ycor - sizePath))
      [
        print "CheckLocation"
        set FrontierList lput (list (xcor - sizePath) (ycor - sizePath) xcor ycor (item 4 front + 1)) FrontierList
      ]
      [
        let pos_s CheckLocationInFrontier? (xcor - sizePath) (ycor - sizePath)
        if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s FrontierList))[
          print "CheckLocationInFrontier"
          set FrontierList replace-item pos_s FrontierList (list (xcor - sizePath) (ycor - sizePath) xcor ycor (item 4 front + 1))
        ]
      ]
    ]

    if([pcolor] of patch-at-heading-and-distance 270 patchDistance != 9.9999)
    [
      ifelse(CheckLocation? (xcor - sizePath) ycor)
      [
        ;print "CheckLocation"
        set FrontierList lput (list (xcor - sizePath) ycor xcor ycor (item 4 front + 1))FrontierList
      ]
      [

        let pos_s CheckLocationInFrontier? (xcor - sizePath) ycor
        if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s FrontierList))[
          ;print "CheckLocationInFrontier"
          set FrontierList replace-item pos_s FrontierList (list (xcor - sizePath) ycor xcor ycor (item 4 front + 1))
        ]
      ]
    ]

   if([pcolor] of patch-at-heading-and-distance 315 patchDistance <= (sqrt 2 / 2))
    [
      ifelse(CheckLocation? (xcor - sizePath) (ycor + sizePath))
      [
        print "CheckLocation"
        set FrontierList lput (list (xcor - sizePath) (ycor + sizePath) xcor ycor (item 4 front + 1))FrontierList
      ]
      [

        let pos_s CheckLocationInFrontier? (xcor - sizePath) (ycor + sizePath)
        if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s FrontierList))[
          print "CheckLocationInFrontier"
          set FrontierList replace-item pos_s FrontierList (list (xcor - sizePath) (ycor + sizePath) xcor ycor (item 4 front + 1))
        ]
      ]
    ]



    set FrontierList sort-by [ [list1 list2] -> item 4 list1 < item 4 list2 ] FrontierList
  ]
end

to PathSolution
  set index last PathList
  while [index  != first PathList]
  [
    foreach PathList [
      s -> if(( item 2 index  = item 0 s ) and (item 3 index  = item 1 s ))[
        ask patch item 0 s item 1 s [set pcolor red]
        set index s
      ]
    ]
  ]

end

to-report CheckLocation? [num1 num2]
   ifelse (limit? num1 num2 = true and NotExpaned? num1 num2 = true and notInFrontier? num1 num2 = true) [report true][report false]
end

to-report CheckLocationInFrontier? [num1 num2]
  ifelse (limit? num1 num2 = true and NotExpaned? num1 num2 = true and notInFrontier? num1 num2 = false)
  [
    foreach FrontierList [
      s ->  ifelse( item 0 s = num1 and item 1 s = num2)  [report position s FrontierList][]
    ]
  ][report -1]
end

to-report limit? [num1 num2]
   ifelse (num1 >= -16 and num1 <= 16 and num2 >= -16 and num2 <= 16) [report true][report false]
end

to-report NotExpaned? [num1 num2]
  foreach PathList [
    s ->  ifelse( item 0 s = num1 and item 1 s = num2)  [report  false][]
  ]
  report true
end


to-report notInFrontier? [num1 num2]
  foreach FrontierList [
    s ->  ifelse( item 0 s = num1 and item 1 s = num2)  [report  false][]
  ]
  report true
end

to expaned
  foreach mainlist [
    s  ->  show first s
  ]
end

to goe
   ask turtles [
    if pcolor = white ;; if own pcolor patch = green
      [ move-to one-of patches with [ pcolor = "white" ] ]
   forward random 5
  ]
end
to go;
  ask turtles
  [
    ifelse [pcolor] of patch-ahead 1 = 9.9999
      [lt random-float 360]
        [fd 1 ]
      print xcor
  print ycor

  ]
  ask patches[
    set plabel "1"
  ]
  tick
end




to load-patch-data

  ifelse ( file-exists? "File IO Patch Data.txt" )
  [
    set patch-data []
    file-open "File IO Patch Data.txt"

    ; Read in all the data in the file
    while [ not file-at-end? ]
    [

    ]

    user-message "File loading complete!"

    ; Done reading in patch information.  Close the file.
    file-close
  ]
  [ user-message "There is no File IO Patch Data.txt file in current directory!" ]
end

to load-own-patch-data
  let file user-file

  if ( file != false )
  [
    set patch-data []
    file-open file

    while [ not file-at-end? ]
      [ set patch-data sentence patch-data (list (list file-read file-read file-read)) ]

    user-message "File loading complete!"
    file-close
  ]
  show-patch-data
end

to show-patch-data
  clear-patches
  clear-turtles
  ifelse ( is-list? patch-data )
    [ foreach patch-data [ three-tuple -> ask patch first three-tuple item 1 three-tuple [ set pcolor last three-tuple ] ] ]
    [ user-message "You need to load in patch data first!" ]
  display
end

to save-patch-data
  let file user-new-file

  if ( file != false )
  [
    file-open file
    ask patches
    [
      file-write pxcor
      file-write pycor
      file-write pcolor
    ]
    file-close
  ]
end
