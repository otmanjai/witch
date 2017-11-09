!     --------------------------------------------------------
!     THIS FORTRAN SOURCE FILE WAS GENERATED USING FORTRAN-IT.
!     --------------------------------------------------------
!     Generation time: 10/10/2017 5:24:59 PM
!     Author         : 
!     Device Name    : RABIEMSI
!     Project Name   : TRIGLAV_Project.fip
!     --------------------------------------------------------
      
      
      program MAIN
         implicit none
         INTEGER LG(35), NG, TMP, i, NFI, iFlag, iLayerID, l, iError
         integer nCount, iDummy
         character(len=80) :: cText, cWITCHInp, cELEMInp, cJoinedOutput
         character(len=50), allocatable :: caJoinFileList(:)
!     LayerID stores the ID of the TRIGA core z-axis cell layer that is
!     is going to be processed.

      ! For command line argument's purpose.
      character(len=30) :: cArg, cForm
      NFI = 20
      iLayerID = 0
         cWITCHInp = 'WITCH'
         cELEMInp = 'ELEM'        
      if (iargc() .gt. 0) then
         
         do i=1, iargc(), 1
            call getarg(i, cArg)
            if (trim(cArg) .eq. '-in') then
               if((i+1) .gt. iargc()) then
                  print*, ' Fatal Error: Invalid argument(s) input!'
                  stop
               endif
               call getarg(i+1, cArg)
               cWITCHInp = trim(cArg)
            elseif (trim(cArg) .eq. '-elem-in') then
               if((i+1) .gt. iargc()) then
                  print*, ' Fatal Error: Invalid argument(s) input!'
                  stop
               endif
               call getarg(i+1, cArg)
               cELEMInp = trim(cArg)
            elseif (trim(cArg) .eq. '-clean') then
               goto 51
            elseif (trim(cArg) .eq. '-join-tapes') then
               if((i+1) .gt. iargc()) then
                  print*, ' Fatal Error: Incomplete argument(s) input!'
                  stop
               endif
               call getarg(i+1, cArg)
               read(cArg,'(I2)',iostat=iError) nCount
               if(iError .ne. 0) then
                  print*, ' Fatal Error: Invalid argument(s) input!'
                  stop
               endif
               allocate(caJoinFileList(nCount))
               if((i+2) .gt. iargc()) then
                  print*, ' Fatal Error: Incomplete argument(s) input!'
                  stop
               endif
               call getarg(i+2, cArg)
               read(cArg,'(A)',iostat=iError) cJoinedOutput
               if(iError .ne. 0) then
                  print*, ' Fatal Error: Invalid argument(s) input!'
                  stop
               endif
               do l=1, nCount, 1
                  call getarg(i+2+l,cArg)
                  read(cArg,'(I10)',err=19) iDummy
                  goto 99
19             print*, ' Fatal Error: Core layer ID list should ',
     &                  'be a list of integers.'
                  stop
99                continue
                  write(cArg,'(I10.10)') iDummy
                  caJoinFileList(l) = trim(cArg)
               enddo
               call TXSJOINER(nCount,caJoinFileList,cJoinedOutput)
               goto 60
            elseif (trim(cArg) .eq. '-layer-id') then
               if((i+1) .gt. iargc()) then
                  print*, ' Fatal Error: Invalid argument(s) input!'
                  stop
               endif
               call getarg(i+1,cArg)
               read (cArg,'(I2)',err=16) iLayerID
               goto 17
16             print*, ' Fatal Error: Core layer ID should ',
     &                  'be an integer.'
               stop
17             continue
            elseif (trim(cArg) .eq. '-info' .or.
     &              trim(cArg) .eq. '-help' .or.
     &              trim(cArg) .eq. '/?') then
               print*
               print*, ' W I T C H '
               print*, ' WIMS-INTEGRATED TRIGA CORE',
     &                 ' HOMOGENISATION CODE'
               print*, ' A code for TRIGA core homogenisation.',
     &                 ' See code '
               print*, ' manual for more details.'
               print*
               print*, ' Universiti Sains Malaysia'
               print*, ' Malaysian Nuclear Agency'
               print*, ' October, 2017.'
               print*
               print*, ' Usage: witch [-in input_name]',
     &                 ' [-elem-in elem_name] [-clean]',
     &                 ' [-layer-id'
               print*, '              layerid][-join-tapes fcount',
     &                 ' txsout layeridlist]'
               print*
               print*, ' OPTIONS'
               print*
               print*,  ' -clean        Removes  junk/un-used  file(s)',
     &                  ' generated by the previous'
               print*,  '               WITCH code run.'
               print*,  ' -in           Specifies the input file',
     &                  ' name.'
               print*,  ' -elem-in      Specifies the fuel element ',
     &                  'input file name.'
               print*,  ' -layer-id     Specifies the layer ID of ',
     &                  'current reactor core layer.'
               print*,  ' -join-tapes   Join all core layer tape',
     &                  ' into a single tape.'
               print*
               print*, ' VARIABLES'
               print*
               print*, ' input_name    The code input file name',
     &                 ' without .INP extension.'
               print*, ' elem_name     The  UZrH  fuel  element  input',
     &                 ' file  name  without .INP'
               print*, '               extension.'
           print*, ' layerid       An  integer  value specifying the',
     &                 ' ID of the reactor core'
               print*, '               layer.'
               print*, ' fcount        An  integer  value ',
     &                 'specifying  the number',
     &                 ' of tapes to be'
               print*, '               joined.'
               print*, ' txsout        A string value specifying',
     &                 ' the name of the joined tape.'
               print*, ' layeridlist   A  list  of integers  that',
     &                 ' represents the  list  of core'
               print*, '               layer tapes',
     &                 ' to be joined.  The integer list count ',
     &                 'should'
               print*, '               not exceed fcount.'
               print*
               print*,  ' **If the user does not specify',
     &                  ' input_name or ',
     &                  'elem_name, their'
               print*,  '   default value  will be used  instead;  ',
     &                  'input_name=WITCH and'
               print*,  '   elem_name=ELEM.'
               print*
               stop
            endif
         enddo
      elseif(iargc() .eq. 0) then
         cWITCHInp = 'WITCH'
         cELEMInp = 'ELEM'      
      endif
      print*
      print*, ' The input file is ',
     &   trim(cWITCHInp) // '.INP', '.'
      print*, ' The fuel element file is ',
     &   trim(cELEMInp) // '.INP', '.'
     
         open(unit=20, file=trim(cWITCHInp) // '.INP', err=13,
     &       status='OLD')
         goto 14
13       print*, ' Fatal Error: Could not load ',
     &      trim(cWITCHInp), '.INP'
         stop
14         continue
         call rasearch(20, 0, '$* MACROGROUP', 13, cText, iFlag)
         if (iFlag .gt. 0) goto 11
         read (NFI,*) NG
         write(cForm,'(I2,A2)') NG, 'I5'
         read (NFI,*) (LG(i),i=1,NG)
c         read (NFI,'('//cForm//')') (LG(i),i=1,NG)
         close(unit=20)
         goto 12
11       print*, ' MACROGROUP card is not found in ',
     &       trim(cWITCHInp) // '.INP.'
          print*, ' Default option, N-GROUP=', 4
         NG = 4
         LG(1) = 5
         LG(2) = 10
         LG(3) = 21
         LG(4) = 32    
         
12       continue

!        Begin your code here...
         call TRSTART(cWITCHInp, cELEMInp)
         call WITRIG(cWITCHInp, cELEMInp)
         print*, ' Launching WIMS code in 3 seconds...'
         call sleep(1)
         print*, ' Launching WIMS code in 2 seconds...'
         call sleep(1)
         print*, ' Launching WIMS code in 1 second...'
         call sleep(1)
         print*
         call LOOXSB()
         call XSWOUT(NG, LG, 0, cWITCHInp, iLayerID)
         
            print*
            print'(A,I2.2)', '  Macrogroup Count    : ', NG
            print'(A,$)',    '  Last Macrogroup No. : '
            do i=1, NG, 1
               print'(I2.2,A1,$)', LG(i), ' '
            enddo
            print*
            if(iLayerID .ne. 0) then
               print'(A,I10.10)', '  Layer ID            : ', iLayerID
            endif
            print*
      print*, ' WITCH was successfully executed. The TRIGA',
     &        ' cross section'
     
      if(iLayerID .eq. 0) then
         print*, ' tape (WITCH-XSWOUT.TXS) has  been saved to ',
     &        'current direc-'    
      else
         write(cText,'(I10.10)') iLayerID
         print*, ' tape (', trim(cText), '.TXS) has  been saved to ',
     &        'current direc-'         
      endif

      print*, ' tory.'
      print*  
         goto 51
50    print*
      print*, ' Fatal Error: The last macrogroup number format is',
     &           'incorrect.'
51    print*, ' Cleaning current directory...'  
      call system('del /q Wimi* WITCH-OUT.OUT'
     &          //        ' WIMS-IN.$$$ WIMS-OUT.$$$ *.TMP')
      call system('del /q FORT.*')
      call sleep(2)
      print*, ' WITCH has completed its job.'
      print*
60    print*, ' STOP:   W I T C H - OCT/17 - S T O P   (END JOB READ)'
      end program


