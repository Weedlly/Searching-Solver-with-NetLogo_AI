globals [

  sizePath
  patch-data
  patchDistance

  xGoal
  yGoal

  xStart
  yStart

  mainFrontierList
  mainPathList

  FinishAgentList
  FirstTime

  numberOfDFS
  numberOfBFS
  numberOfUCS
  numberOfA*

  indexDFS
  indexBFS
  indexUCS
  indexA*

  BFSagentList
  DFSagentList
  A*agentList
  UCSagentList

  countStepDFS
  countStepBFS
  countStepA*
  countStepUCS
]


breed [Starts Start]
breed [goals goal]
to clean-up
  clear-all-plots
  clear-patches
  clear-drawing
  clear-turtles
  reset-ticks
end
to setup
  set FinishAgentList[]
  set mainPathList []
  set mainFrontierList []
  set sizePath 1
  set patchDistance 1
  set xGoal 0
  set yGoal -2

  set FirstTime 0


  set DFSagentList []
  set BFSagentList []
  set A*agentList []
  set UCSagentList []

  set indexDFS 0
  set indexBFS 0
  set indexA* 0
  set indexUCS 0

  create-Starts DFSagents [
    set DFSagentList lput ( Start indexDFS )  DFSagentList
    set color blue

    set heading 0
    set size 1
    set shape "person"
    set xStart 0
    set yStart  0
    while [(xStart = 0 and yStart = 0 ) or  pcolor = 9.9999 ] [
      set xStart (random 16)
      set xcor xStart
      set yStart (random 16)
      set ycor yStart
    ]

    set mainFrontierList lput (list xStart yStart xStart yStart) mainFrontierList
    set mainPathList lput (list) mainPathList
    set indexDFS (indexDFS + 1)
    set countStepDFS 0

  ]

  set numberOfDFS indexDFS

  create-Starts BFSagents [
    set BFSagentList lput ( Start (indexBFS + numberOfDFS) ) BFSagentList
    set color pink

    set heading 0
    set size 1
    set shape "arrow"

    set xStart 0
    set yStart  0
    while [(xStart = 0 and yStart = 0 ) or  pcolor = 9.9999 ] [
      set xStart (random 16)
      set xcor xStart
      set yStart (random -16)
      set ycor yStart
    ]

    set mainFrontierList lput (list xStart yStart xStart yStart 0) mainFrontierList
    set mainPathList lput (list) mainPathList
    set indexBFS (indexBFS + 1)
    set countStepBFS 0

   ]

  set numberOfBFS indexBFS

  create-Starts A*agents [
    set A*agentList lput ( Start (indexA* + numberOfDFS + numberOfBFS) )  A*agentList
    set color green

    set heading 0
    set size 1
    set shape "box"

    set xStart 0
    set yStart  0
    while [(xStart = 0 and yStart = 0 ) or  pcolor = 9.9999 ] [
      set xStart (random -16)
      set xcor xStart
      set yStart (random  -16)
      set ycor yStart
    ]

    set mainFrontierList lput (list xStart yStart xStart yStart 0) mainFrontierList
    set mainPathList lput (list) mainPathList
    set indexA* (indexA* + 1)
    set countStepA* 0
   ]
  set numberOfA* indexA*

  create-Starts UCSagents [
    set UCSagentList lput ( Start (indexUCS + numberOfA* + numberOfDFS + numberOfBFS) ) UCSagentList
    set color yellow
    set heading 0
    set size 1
    set shape "bug"
    set xStart 0
    set yStart  0
    while [(xStart = 0 and yStart = 0 ) or  pcolor = 9.9999 ] [
      set xStart (random -16)
      set xcor xStart
      set yStart (random  16)
      set ycor yStart
    ]

    set mainFrontierList lput (list xStart yStart xStart yStart 0) mainFrontierList
    set mainPathList lput (list) mainPathList
    set indexUCS (indexUCS + 1)
    set countStepUCS 0

   ]

  set numberOfUCS indexUCS


  set indexDFS 0
  set indexBFS 0
  set indexA* 0
  set indexUCS 0

  create-goals 1 [
    set color red
    set heading 0
    set size 1
    set shape "house"
    set xcor xGoal
    set ycor yGoal
  ]
  tick
  do-plots
end

to do-plots
  set-current-plot "RESCUE THE PRINCESS"
  if(countStepDFS > 0) [set-current-plot-pen "pen-0" set-plot-pen-interval 1 plot countStepDFS]

  if(countStepBFS > 0) [set-current-plot-pen "pen-1" set-plot-pen-interval 1 plot countStepBFS]

  if(countStepA* > 0) [set-current-plot-pen "pen-2" set-plot-pen-interval 1 plot countStepA*]

  if(countStepUCS > 0) [set-current-plot-pen "pen-3" set-plot-pen-interval 1 plot countStepUCS]
end

to ALL
  if (length FinishAgentList = ( numberOfDFS + numberOfBFS + numberOfA* + numberOfUCS)) [
    show countStepDFS
    show countStepBFS
    show countStepA*
    show countStepUCS
    stop]
  ;DFS
  tick
  foreach  DFSagentList [ s -> ask s
  [
    ifelse(xcor = xGoal and ycor = yGoal) [
      set FinishAgentList lput indexDFS FinishAgentList
      set FinishAgentList remove-duplicates FinishAgentList
      set indexDFS (indexDFS + 1)
      if ( indexDFS = numberOfDFS) [set indexDFS 0]
    ] [
        if(empty? (item indexDFS mainFrontierList)) [stop]

        let tmp[]
        ifelse (FirstTime < numberOfDFS)[
          set tmp lput (item indexDFS mainFrontierList ) tmp
          set FirstTime (FirstTime + 1)
        ][
          set tmp (item indexDFS mainFrontierList )
          ]

        let front (first tmp) ; get avariable

        set tmp remove-item 0 tmp

        let tmpPathList []
        set tmpPathList (item indexDFS mainPathList ) ;DFS
        set tmpPathList lput (front) tmpPathList ; add front to Pathlist

        set mainPathList replace-item indexDFS mainPathList tmpPathList

        setxy (item 2 front) (item 3 front)
        set pen-mode "down"
        setxy (item 0 front) (item 1 front)
        set pen-mode "up"
        set countStepDFS countStepDFS + 1

        do-plots
        set mainFrontierList replace-item indexDFS mainFrontierList tmp

        if(CheckLocation? xcor (ycor + sizePath) indexDFS and  [pcolor] of patch-at-heading-and-distance 0 patchDistance != 9.9999)
        [
          set tmp insert-item 0 tmp (list xcor (ycor + sizePath) xcor ycor)]
        if (CheckLocation? (xcor + sizePath) (ycor + sizePath) indexDFS and  [pcolor] of patch-at-heading-and-distance 45 patchDistance <= (sqrt 0.5))
        [
          set tmp insert-item 0 tmp (list (xcor + sizePath) (ycor + sizePath) xcor ycor)
        ]
        if(CheckLocation? (xcor + sizePath) ycor indexDFS and  [pcolor] of patch-at-heading-and-distance 90 patchDistance != 9.9999)
        [
          set tmp insert-item 0 tmp (list (xcor + sizePath) ycor xcor ycor)]
         if (CheckLocation? (xcor + sizePath) (ycor - sizePath) indexDFS and  [pcolor] of patch-at-heading-and-distance 135 patchDistance <= (sqrt 0.5))
        [
          set tmp insert-item 0 tmp (list (xcor + sizePath) (ycor - sizePath) xcor ycor)
        ]
        if(CheckLocation? xcor (ycor - sizePath) indexDFS and  [pcolor] of patch-at-heading-and-distance 180 patchDistance != 9.9999)
        [
          set tmp insert-item 0 tmp (list xcor (ycor - sizePath) xcor ycor)]
        if (CheckLocation? (xcor - sizePath) (ycor - sizePath) indexDFS and  [pcolor] of patch-at-heading-and-distance 225 patchDistance <= (sqrt 0.5))
        [
          set tmp insert-item 0 tmp (list (xcor - sizePath) (ycor - sizePath) xcor ycor)
        ]
        if(CheckLocation? (xcor - sizePath) ycor indexDFS and   [pcolor] of patch-at-heading-and-distance 270 patchDistance != 9.9999)
        [
          set tmp insert-item 0 tmp (list (xcor - sizePath) ycor xcor ycor)]
        if (CheckLocation? (xcor - sizePath) (ycor + sizePath) indexDFS and  [pcolor] of patch-at-heading-and-distance 315 patchDistance <= (sqrt 0.5))
        [
          set tmp insert-item 0 tmp (list (xcor - sizePath) (ycor + sizePath) xcor ycor)
        ]

        set mainFrontierList replace-item indexDFS mainFrontierList tmp
        set indexDFS (indexDFS + 1)
        if ( indexDFS = numberOfDFS) [set indexDFS 0]
      ]
    ]
  ]
  ;BFS

  foreach  BFSagentList [ s -> ask s
    [
      let indexInFrontPath ( indexBFS + numberOfDFS ) ; get index

      ifelse(xcor = xGoal and ycor = yGoal) [
        set FinishAgentList lput indexInFrontPath FinishAgentList
        set FinishAgentList remove-duplicates FinishAgentList
        set indexBFS (indexBFS + 1)
        if ( indexBFS = numberOfBFS) [set indexBFS 0]
      ]

      [
        if(empty? (item indexInFrontPath mainFrontierList)) [stop]
        let tmp[]
        ifelse (FirstTime < ( numberOfDFS + numberOfBFS))[
          set tmp lput (item indexInFrontPath mainFrontierList) tmp
          set FirstTime (FirstTime + 1)
        ]
        [
          set tmp (item indexInFrontPath mainFrontierList )
        ]
        let front first tmp ; get avariable
        set tmp remove-item 0 tmp

        let tmpPathList []
        set tmpPathList (item indexInFrontPath mainPathList ) ;BFS
        set tmpPathList lput (front) tmpPathList

        set mainPathList replace-item indexInFrontPath mainPathList tmpPathList

        ;setxy (first front) (item 1 front)
        setxy (item 2 front) (item 3 front)
        set pen-mode "down"
        setxy (item 0 front) (item 1 front) ;move to
        set pen-mode "up"
        set countStepBFS countStepBFS + 1

        do-plots
        set mainFrontierList replace-item indexInFrontPath mainFrontierList tmp

        if (CheckLocation? xcor (ycor + sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 0 patchDistance != 9.9999)
        [
          set tmp lput (list xcor (ycor + sizePath) xcor ycor 0) tmp
        ]

        if (CheckLocation? (xcor + sizePath) (ycor + sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 45 patchDistance <= (sqrt 0.5))
        [
          set tmp lput (list (xcor + sizePath) (ycor + sizePath) xcor ycor 0) tmp
        ]

        if(CheckLocation? (xcor + sizePath) ycor indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 90 patchDistance != 9.9999)
        [
          set tmp lput (list (xcor + sizePath) ycor xcor ycor 0) tmp
        ]

        if (CheckLocation? (xcor + sizePath) (ycor - sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 135 patchDistance <= (sqrt 0.5))
        [
          set tmp lput (list (xcor + sizePath) (ycor - sizePath) xcor ycor 0) tmp
        ]

        if(CheckLocation? xcor (ycor - sizePath) ( indexBFS + numberOfDFS ) and  [pcolor] of patch-at-heading-and-distance 180 patchDistance != 9.9999)
        [
          set tmp lput (list xcor (ycor - sizePath) xcor ycor 0) tmp
        ]

        if (CheckLocation? (xcor - sizePath) (ycor - sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 225 patchDistance <= (sqrt 0.5))
        [
          set tmp lput (list (xcor - sizePath) (ycor - sizePath) xcor ycor 0) tmp
        ]

        if(CheckLocation? (xcor - sizePath) ycor indexInFrontPath and [pcolor] of patch-at-heading-and-distance 270 patchDistance != 9.9999)
        [
          set tmp lput (list (xcor - sizePath) ycor xcor ycor 0) tmp
        ]

        if (CheckLocation? (xcor - sizePath) (ycor + sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 315 patchDistance <= (sqrt 0.5))
        [
          set tmp lput (list (xcor - sizePath) (ycor + sizePath) xcor ycor 0) tmp
        ]
        set mainFrontierList replace-item indexInFrontPath mainFrontierList tmp
        set indexBFS (indexBFS + 1)
        if ( indexBFS = numberOfBFS) [set indexBFS 0]
      ]
    ]
  ]


  ;A*
   foreach  A*agentList [ s -> ask s
  [
     let indexInFrontPath (indexA* + numberOfDFS + numberOfBFS) ; get index

     ifelse (xcor = xGoal and ycor = yGoal) [
      set FinishAgentList lput indexInFrontPath FinishAgentList
      set FinishAgentList remove-duplicates FinishAgentList
      set indexA* (indexA* + 1)
      if ( indexA* = numberOfA*) [set indexA* 0]
    ]
    [

        if(empty?  (item indexInFrontPath mainFrontierList)) [stop]

        let indexMinNode -1
        let tmp[]

        ifelse (FirstTime < (numberOfA* + numberOfDFS + numberOfBFS))[
          set tmp lput (item indexInFrontPath mainFrontierList ) tmp
          set indexMinNode ( findIndexOfMinNode tmp)
          set FirstTime (FirstTime + 1)
        ][
          set tmp (item indexInFrontPath mainFrontierList )

          set indexMinNode ( findIndexOfMinNode tmp)
        ]

        if(indexMinNode = -1) [
          stop
        ]

        let minCostNode item indexMinNode tmp
        set tmp remove-item (findIndexOfMinNodeInFrontier (first minCostNode)  (item 1 minCostNode) (last minCostNode) tmp) tmp

        let front (list (first minCostNode) (item 1 minCostNode) xcor ycor (last minCostNode))
        let pastCost (last minCostNode)

        let tmpPathList []
        set tmpPathList (item indexInFrontPath mainPathList ) ;A*
        set tmpPathList lput (front) tmpPathList ; add front to Pathlist


        set mainFrontierList replace-item indexInFrontPath mainFrontierList tmp

        setxy (item 2 minCostNode) (item 3 minCostNode)
        set pen-mode "down"
        setxy (item 0 minCostNode) (item 1 minCostNode)
        set pen-mode "up"
        set countStepA* countStepA* + 1


        do-plots
        if(CheckLocation? xcor (ycor + sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 0 patchDistance != 9.9999)
        [
          set tmp insert-item 0 tmp (list xcor (ycor + sizePath) xcor ycor ( pastCost + 1))]
        if(CheckLocation? (xcor + sizePath) ycor indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 90 patchDistance != 9.9999)
        [
          set tmp insert-item 0 tmp (list (xcor + sizePath) ycor xcor ycor ( pastCost + 1))]
        if(CheckLocation? xcor (ycor - sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 180 patchDistance != 9.9999)
        [
          set tmp insert-item 0 tmp (list xcor (ycor - sizePath) xcor ycor ( pastCost + 1))]
        if(CheckLocation? (xcor - sizePath) ycor indexInFrontPath and [pcolor] of patch-at-heading-and-distance 270 patchDistance != 9.9999)
        [
          set tmp insert-item 0 tmp (list (xcor - sizePath) ycor xcor ycor ( pastCost + 1))]

        if (CheckLocation? (xcor + sizePath) (ycor + sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 45 patchDistance <= (sqrt 0.5))
        [
          set tmp insert-item 0 tmp (list (xcor + sizePath) (ycor + sizePath) xcor ycor ( pastCost + sqrt(2)))
        ]
        if (CheckLocation? (xcor + sizePath) (ycor - sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 135 patchDistance <= (sqrt 0.5))
        [
          set tmp insert-item 0 tmp (list (xcor + sizePath) (ycor - sizePath) xcor ycor ( pastCost + sqrt(2)))
        ]

        if (CheckLocation? (xcor - sizePath) (ycor - sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 225 patchDistance <= (sqrt 0.5))
        [
          set tmp insert-item 0 tmp (list (xcor - sizePath) (ycor - sizePath) xcor ycor ( pastCost + sqrt(2)))
        ]
        if (CheckLocation? (xcor - sizePath) (ycor + sizePath) indexInFrontPath and  [pcolor] of patch-at-heading-and-distance 315 patchDistance <= (sqrt 0.5))
        [
          set tmp insert-item 0 tmp (list (xcor - sizePath) (ycor + sizePath) xcor ycor ( pastCost + sqrt(2)))
        ]


        set mainFrontierList replace-item indexInFrontPath mainFrontierList tmp

        set indexA* (indexA* + 1)
        if ( indexA* = numberOfA*) [set indexA* 0]
    ]
   ]
  ]
  ;UCS
  foreach  UCSagentList [ s -> ask s
    [
    let indexInFrontPath (indexUCS + numberOfA* + numberOfDFS + numberOfBFS) ; get index

    ifelse(xcor = xGoal and ycor = yGoal) [
      set FinishAgentList lput indexInFrontPath FinishAgentList
      set FinishAgentList remove-duplicates FinishAgentList
      set indexUCS (indexUCS + 1)
      if ( indexUCS = numberOfUCS) [set indexUCS 0]
    ]
    [
      if(empty? item indexInFrontPath mainFrontierList) [stop]
      let tmp[]
      ifelse (FirstTime < (numberOfUCS + numberOfA* + numberOfDFS + numberOfBFS))
      [
          set tmp lput (item indexInFrontPath mainFrontierList) tmp
          set FirstTime (FirstTime + 1)
      ]
      [
          set tmp (item indexInFrontPath mainFrontierList )
      ]

        let front first tmp ; get avariable
        set tmp remove-item 0 tmp

        let tmpPathList []
        set tmpPathList (item indexInFrontPath mainPathList ) ;UCS
        set tmpPathList lput (front) tmpPathList

        set mainPathList replace-item indexInFrontPath mainPathList tmpPathList ; add front to Pathlist

        setxy (item 2 front) (item 3 front)
        set pen-mode "down"
        setxy (item 0 front) (item 1 front) ;move to
        set pen-mode "up"
        set countStepUCS countStepUCS + 1

        do-plots
        set mainFrontierList replace-item indexInFrontPath mainFrontierList tmp

        if([pcolor] of patch-at-heading-and-distance 0 patchDistance != 9.9999)
        [
          ifelse(CheckLocation? xcor (ycor + sizePath) indexInFrontPath)
          [
            set tmp insert-item 0 tmp (list xcor (ycor + sizePath) xcor ycor (item 4 front + 1) )
          ]
          [
            let pos_s CheckLocationInFrontier? xcor (ycor + sizePath) indexInFrontPath
            if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s tmp))[
              set tmp replace-item pos_s tmp (list xcor (ycor + sizePath) xcor ycor (item 4 front + 1))
            ]
          ]
        ]

        if([pcolor] of patch-at-heading-and-distance 45 patchDistance <= (sqrt 2 / 2))
        [
          ifelse(CheckLocation? (xcor + sizePath) (ycor + sizePath) indexInFrontPath)
          [
            set tmp insert-item 0 tmp (list (xcor + sizePath) (ycor + sizePath) xcor ycor (item 4 front + 1) )
          ]
          [
            let pos_s CheckLocationInFrontier? (xcor + sizePath) (ycor + sizePath) indexInFrontPath
            if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s tmp))[
              set tmp replace-item pos_s tmp (list (xcor + sizePath) (ycor + sizePath) xcor ycor (item 4 front + 1))
            ]
          ]
        ]


        if([pcolor] of patch-at-heading-and-distance 90 patchDistance != 9.9999)
        [
          ifelse(CheckLocation? (xcor + sizePath) ycor indexInFrontPath)
          [
            set tmp insert-item 0 tmp (list (xcor + sizePath) ycor xcor ycor (item 4 front + 1))
          ]
          [
            let pos_s CheckLocationInFrontier? (xcor + sizePath) ycor indexInFrontPath
            if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s tmp))[
              set tmp replace-item pos_s tmp (list (xcor + sizePath) ycor xcor ycor (item 4 front + 1))
            ]
          ]
        ]

        if([pcolor] of patch-at-heading-and-distance 135 patchDistance <= (sqrt 2 / 2))
        [
          ifelse(CheckLocation? (xcor + sizePath) (ycor - sizePath) indexInFrontPath)
          [
            set tmp insert-item 0 tmp (list (xcor + sizePath) (ycor - sizePath) xcor ycor (item 4 front + 1))
          ]
          [
            let pos_s CheckLocationInFrontier? (xcor + sizePath) (ycor - sizePath) indexInFrontPath
            if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s tmp))[
              set tmp replace-item pos_s tmp (list (xcor + sizePath) (ycor - sizePath) xcor ycor (item 4 front + 1))
            ]
          ]
        ]

        if([pcolor] of patch-at-heading-and-distance 180 patchDistance != 9.9999)
        [
          ifelse(CheckLocation? xcor (ycor - sizePath) indexInFrontPath)
          [
            set tmp insert-item 0 tmp (list xcor (ycor - sizePath) xcor ycor (item 4 front + 1))
          ]
          [
            let pos_s CheckLocationInFrontier? xcor (ycor - sizePath) indexInFrontPath
            if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s tmp))[
              set tmp replace-item pos_s tmp (list xcor (ycor - sizePath) xcor ycor (item 4 front + 1))
            ]
          ]
        ]

        if([pcolor] of patch-at-heading-and-distance 225 patchDistance <= (sqrt 2 / 2))
        [
          ifelse(CheckLocation? (xcor - sizePath) (ycor - sizePath) indexInFrontPath)
          [
            set tmp insert-item 0 tmp (list (xcor - sizePath) (ycor - sizePath) xcor ycor (item 4 front + 1))
          ]
          [
            let pos_s CheckLocationInFrontier? (xcor - sizePath) (ycor - sizePath) indexInFrontPath
            if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s tmp))[
              set tmp replace-item pos_s tmp (list (xcor - sizePath) (ycor - sizePath) xcor ycor (item 4 front + 1))
            ]
          ]
        ]

        if([pcolor] of patch-at-heading-and-distance 270 patchDistance != 9.9999)
        [
          ifelse(CheckLocation? (xcor - sizePath) ycor indexInFrontPath)
          [
            set tmp insert-item 0 tmp (list (xcor - sizePath) ycor xcor ycor (item 4 front + 1))
          ]
          [

            let pos_s CheckLocationInFrontier? (xcor - sizePath) ycor indexInFrontPath
            if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s tmp))[
              set tmp replace-item pos_s tmp (list (xcor - sizePath) ycor xcor ycor (item 4 front + 1))
            ]
          ]
        ]

        if([pcolor] of patch-at-heading-and-distance 315 patchDistance <= (sqrt 2 / 2))
        [
          ifelse(CheckLocation? (xcor - sizePath) (ycor + sizePath) indexInFrontPath)
          [
            set tmp insert-item 0 tmp (list (xcor - sizePath) (ycor + sizePath) xcor ycor (item 4 front + 1))
          ]
          [

            let pos_s CheckLocationInFrontier? (xcor - sizePath) (ycor + sizePath) indexInFrontPath
            if(pos_s != -1 and (item 4 front + 1) < item 4 (item pos_s tmp))[
              set tmp replace-item pos_s tmp (list (xcor - sizePath) (ycor + sizePath) xcor ycor (item 4 front + 1))
            ]
          ]
        ]
        set tmp sort-by [ [list1 list2] -> item 4 list1 < item 4 list2 ] tmp
        set mainFrontierList replace-item indexInFrontPath mainFrontierList tmp
        set indexUCS (indexUCS + 1)
        if ( indexUCS = numberOfUCS) [set indexUCS 0]
      ]
    ]
  ]
end

to-report CheckLocation? [num1 num2 num3]
   ifelse (limit? num1 num2 = true and NotExpaned? num1 num2 num3 = true and notInFrontier? num1 num2 num3 = true) [report true][report false]
end

to-report limit? [num1 num2]
   ifelse (num1 > -16 and num1 < 16 and num2 > -16 and num2 < 16) [report true][report false]
end

to-report NotExpaned? [num1 num2 num3]
  let tmp (item num3 mainPathList )
  foreach tmp [
    s ->  ifelse( first s = num1 and (item 1 s) = num2)  [report  false][]
  ]
  report true
end

to-report CheckLocationInFrontier? [num1 num2 num3]
  let tmp (item num3 mainFrontierList )
  ifelse (limit? num1 num2 = true and NotExpaned? num1 num2 num3 = true and notInFrontier? num1 num2 num3 = false)
  [
    foreach tmp [
      s ->  ifelse( item 0 s = num1 and item 1 s = num2)  [report position s tmp][]
    ]
  ][report -1]
end

to-report notInFrontier? [num1 num2 num3]
  let tmp (item num3 mainFrontierList)
  foreach tmp [
    s ->  ifelse( first s = num1 and (item 1 s) = num2)  [report  false][]
  ]
  report true
end

to-report findIndexOfMinNodeInFrontier [num1 num2 num3 list1]
  let i 0
  foreach list1 [
    s  ->  ifelse num1 = (first s) and  num2 = (item 1 s) and num3 = (last s) [report i][set  i (i + 1)]
  ]
end

to-report findIndexOfMinNode [list1]
  let i 0
  let minVal 999
  let index -1
  foreach list1 [
    s  ->  ifelse ((last s) + EuclideanDistance first s item 1 s) < (minVal)
    [
     let o ((last s) + EuclideanDistance first s item 1 s)
     set minVal ((last s) + EuclideanDistance first s item 1 s)
     set index i
     set i (i + 1)
    ]
    [
      set  i (i + 1)]
  ]
  report index
end

to-report EuclideanDistance [num1 num2]
  report sqrt((num1 - xGoal) * (num1 - xGoal) + (num2 - yGoal) * (num2 - yGoal))
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
@#$#@#$#@
GRAPHICS-WINDOW
272
12
775
516
-1
-1
15.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
15
46
110
79
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
16
142
111
175
NIL
clean-up
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
16
198
111
231
NIL
show-patch-data
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
16
253
131
286
NIL
load-own-patch-data
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
15
90
111
123
NIL
ALL
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1116
239
1288
272
A*agents
A*agents
0
100
5.0
1
1
NIL
HORIZONTAL

SLIDER
1114
132
1286
165
DFSagents
DFSagents
0
100
5.0
1
1
NIL
HORIZONTAL

SLIDER
1114
186
1286
219
BFSagents
BFSagents
0
100
5.0
1
1
NIL
HORIZONTAL

SLIDER
1117
287
1289
320
UCSagents
UCSagents
0
100
5.0
1
1
NIL
HORIZONTAL

PLOT
797
102
1049
384
RESCUE THE PRINCESS
time
number of step
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-0" 1.0 0 -13791810 true "" ""
"pen-1" 1.0 0 -2064490 true "" ""
"pen-2" 1.0 0 -11085214 true "" ""
"pen-3" 1.0 0 -1184463 true "" ""
"pen-4" 1.0 0 -6459832 true "" ""
"pen-5" 1.0 0 -1184463 true "" ""
"pen-6" 1.0 0 -10899396 true "" ""
"pen-7" 1.0 0 -13840069 true "" ""
"pen-8" 1.0 0 -14835848 true "" ""
"pen-9" 1.0 0 -11221820 true "" ""
"pen-10" 1.0 0 -13791810 true "" ""
"pen-11" 1.0 0 -13345367 true "" ""
"pen-12" 1.0 0 -8630108 true "" ""
"pen-13" 1.0 0 -5825686 true "" ""
"pen-14" 1.0 0 -2064490 true "" ""

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
