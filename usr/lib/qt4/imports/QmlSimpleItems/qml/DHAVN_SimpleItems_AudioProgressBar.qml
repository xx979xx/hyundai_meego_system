import Qt 4.7
import "DHAVN_SimpleItemsMediaProgressBar.js" as HM
import "DhAvnSimpleItemsResources.js" as RES

Item
{
   id: progressBar

   /** Short progress bar: 0 - normal size,
                           1 - short size and text in center
                           2 - short size and letf text (CD screen) */
   property int nShortSize: 0
   //width: nShortSize ? 759 : 1224   // removed by dongjin 2012.08.14 for CR12351 
   width: nShortSize ? 759 : 1280     // added by dongjin 2012.08.14 for CR12351

   /** Visible property for Cursor on progressbar */
   property bool bCursorVisible: true
   /** Visible property of progress bar */
   property bool bPrBarVisible: true
   /** Song name */
   property string sSongName: ""
   /** Album name */
   property string sAlbumName: ""
   /** Artist name */
   property string sArtistName: ""
   /** Files count text ("2/10" ) */
   property string sFilesCount: ""
   property bool bTuneTextColor: false

   property bool btextVisible: true

   /** Minimal value is always 0 */
   property int nCurrentTime: 0
   property int nTotalTime: 0

   /** Repeat status: 0 - none, 1 - all, 2 - one, 3 - album */
   property int nRepeatStatus: 0

   // { modified by kihyung 2012.07.05
   // Random status: false - disabled, true - enabled
   // property bool bRandomStatus: false
   /** Random status: 0 - none, 1 or 2 - all */
   property int nRandomStatus: 0
   // } modified by kihyung
   property bool bPrBarRandomVisible: true  // added by yongkyun.lee 20130224 for : ISV 73871

   /** Scan status: false - disabled, true - enabled
       will replace Random status icon */
   property bool bScanStatus: false

   // { added by kihyung 2012.06.30
   /** This private property is needed for proper displaying of repeat & random icon, when user press on it.**/
   property bool __randomPressed: false
   property bool __repeatPressed: false
   property bool __randomOutRange: false //added by shkim for ITS 198555
   property bool __repeatOutRange: false //added by shkim for ITS 198555
   // } added by kihyung

   //property string sMPstate: "" //added by changjin 2012.10.29 for ISV 61843
   property bool bSeekableMedia: true //added by changjin 2012.12.26 for ISV 61843
// added by Dmitry 05.05.13   
   property bool middleEast: false

   property bool mpDisc: false // added by cychoi 2013.05.28 for Smoke Test 35 fail

   property bool bDiscMuteState: false // added by cychoi 2013.06.02 for sound noise when dragged progress bar
   property bool bDragMuteState: false//added by edo.lee 2013.06.13

   property bool bPressed: false
   property bool bDraggable: true // added ITS 210706,7

   state: middleEast ? "middleEast" : "normal"

   states: [
      State {
         name: "middleEast"
         AnchorChanges { target: random_img; anchors.right:  parent.right; anchors.left: undefined }
         AnchorChanges { target: repeat_img; anchors.right:  parent.right; anchors.left: undefined }
         PropertyChanges { target: random_img; anchors.rightMargin: 1150 }
         PropertyChanges { target: repeat_img; anchors.rightMargin: 1062 }
      },
      State {
         name: "normal"
         AnchorChanges { target: random_img; anchors.left:  parent.left; anchors.right: undefined }
         AnchorChanges { target: repeat_img; anchors.left:  parent.left; anchors.right: undefined }
         PropertyChanges { target: random_img; anchors.leftMargin: 1062 }
         PropertyChanges { target: repeat_img; anchors.leftMargin: 1150 }
      }
   ]
// added by Dmitry 05.05.13

   function reset()
   {
      nCurrentTime = 0
      nTotalTime = 0
      sSongName = ""
      sArtistName = ""
      sAlbumName = ""
      sFilesCount = ""
   }

   signal changePlayingPosition(int second) // modified by kihyung for ITS 0177424 
   signal changeDragMuteState() // added by edo.lee 2013.06.13
   signal changeDiscMuteState() // added by cychoi 2013.06.02 for sound noise when dragged progress bar
   signal changeRepeatMode()
   signal changeRandomMode()
   signal beep()
   signal qmlLog(string Log); // added by oseong.kwon 2014.08.04 for show log

   // { added by oseong.kwon 2014.08.04 for show log
   function __LOG(Log)
   {
       qmlLog( "DHAVN_SimpleItems_AudioProgressBar.qml: " + Log );
   }
   // } added by oseong.kwon 2014.08.04

/** ============================================================= */
/** ===================== Private area ========================== */
/** ============================================================= */

   property int n_cur_time: 0
   // { removed by dongjin 2012.08.14 for CR12351
   //height: 90    
   //anchors.leftMargin: 29 
   //anchors.bottomMargin: ( nShortSize == 2 ) ? 150 : 100 
   // } removed by dongjin
   
   height: 98   // added by dongjin 2012.08.14 for CR12351 

   Component.onCompleted:
   {
      animateProgressBar(nCurrentTime) // modified by kihyung 2013.07.02 for ITS 0177424 
      nShortSize++; nShortSize--
   }


   onNCurrentTimeChanged: 
   {
      // modified by kihyung 2013.07.02 for ITS 0177424 
      if(!bPressed)
          animateProgressBar(nCurrentTime)
      // modified by kihyung 2013.07.02
   }

   // { added by kihyung 2013.06.24
   onNTotalTimeChanged:
   {
      if(mpDisc)
      {
          if(bDiscMuteState == true)
              changeDiscMuteState()
      }
      else
      {
          if(bDragMuteState == true)
              changeDragMuteState()  
      }
   }
   // } added by kihyung 2013.06.24

   // { modified by kihyung 2013.07.02 for ITS 0177424 
   function animateProgressBar(pos)
   {
       if ( pos < 0 )
       {
           n_cur_time = 0
           return
       }
   
       // { modified by cychoi 2015.06.17 update progress bar in seconds (not milliseconds)
       var posSec = Math.floor( pos / 1000 )
       var totalTimeSec = Math.floor( nTotalTime / 1000 )

       if ( posSec <= totalTimeSec )
       {
           selected_pb.width = bCursorVisible * ( cursor_image.sourceSize.width / 4 )
           if ( totalTimeSec )
           {
              selected_pb.width += ( posSec / totalTimeSec ) * ( bg_pb.width - bCursorVisible * cursor_image.sourceSize.width / 2 )
           }
       }
       // } modified by cychoi 2015.06.17

       n_cur_time = nCurrentTime
   }
   // } modified by kihyung 2013.07.02 for ITS 0177424
   
   // { commentted by kihyung 2012.06.30
   /*
   onBRandomStatusChanged:
   {
      random_img.opacity = 1
   }
   */
   // { commentted by kihyung

// modified by Dmitry 21.07.13 for ITS0180711
// Background image of progress bar
   Image
   {
      id: bg_pb
      anchors.left: textCurrentTime.right
      anchors.right: textTotalTime.left     // added by sangmin.seol 2014.04.02 for New Progressbar GUI
      anchors.leftMargin: 20                // added by sangmin.seol 2014.04.02 for New Progressbar GUI
      anchors.rightMargin: 20               // added by sangmin.seol 2014.04.02 for New Progressbar GUI
      //anchors.leftMargin: 114   // removed by dongjin 2012.08.14 for CR12351
      //anchors.leftMargin: 5     // added by dongjin 2012.08.14 for CR12351
      //anchors.right: textTotalTime.left
      //width : 996                         // removed by sangmin.seol 2014.04.02 for New Progressbar GUI
      //anchors.rightMargin: 114   // removed by dongjin 2012.08.14 for CR12351
      //anchors.rightMargin: 10    // added by dongjin 2012.08.14 for CR12351
      anchors.verticalCenter: parent.verticalCenter
      fillMode: Image.TileHorizontally
      source: bPrBarVisible? "/app/share/images/music/pgbar_bg_n.png" : ""
// modified by Dmitry 21.07.13 for ITS0180711
      onWidthChanged:
      {
         // modified by richard 2012.10.25 for navi slowness fix
         //selected_pb_animation.duration = 0
         animateProgressBar(nCurrentTime) 
      }
// Selected image of progress bar
      Image
      {
         id: selected_pb
         visible: bPrBarVisible
         anchors.left: parent.left
         anchors.verticalCenter: parent.verticalCenter
         fillMode: Image.TileHorizontally
         source: "/app/share/images/music/pgbar_bg_s.png"

         // modified by richard 2012.10.25 for navi slowness fix
	 /*
         NumberAnimation
         {
            id: selected_pb_animation
            target: selected_pb
            property: "width"
            //duration: 1000   // removed by dongjin 2012.08.14 for CR12351
            // modified by minho 20121030 for ISV 61713 moved animation as FF mode when enter Jukebox/USB first.
            // duration: 1012     // added by dongjin 2012.08.14 for CR12351
            duration: 0
            // modified by minho
         }
         */
// Cursor image on progress bar
         Image
         {
            anchors.right: cursor_image.horizontalCenter
            anchors.verticalCenter: cursor_image.verticalCenter
            source: "/app/share/images/music/pgbar_pointer.png"
            width: selected_pb.width > sourceSize.width ? sourceSize.width : selected_pb.width
         }
         Image
         {
            id: cursor_image
            anchors.right: parent.right
            anchors.rightMargin: -sourceSize.width / 2
            anchors.verticalCenter: parent.verticalCenter
            source: "/app/share/images/music/pgbar_pointer_circle.png"
            visible: bCursorVisible
         }
      }

      // { modified by kihyung 2013.07.09 for ITS 0178070 
      MouseArea
      {
         id: cursorMA
         anchors.left: parent.left
         anchors.right: parent.right
         anchors.top: parent.top
         anchors.topMargin: -50
         height: 100

         property int  lastFrameX
         property int  deltaX
         property int  lastTime
         property int  second
         property int  lastSecond // added by kihyung 2013.07.02 for ITS 0177424 
         property int  lastSecondOnTriggered // added by cychoi 2014.08.25 for twice changePlayingPosition signal calls
         property int  dragStartX // added by edo.lee 2013.06.29
 
    	 enabled: bPrBarVisible
         
         onPressed:
         {
             if(bDraggable)  // added ITS 210706,7
             {
                 __LOG("cursorMA onPressed " + mouseX)

                 bPressed = true
                 lastSecondOnTriggered = -1 // added by cychoi 2014.08.25 for twice changePlayingPosition signal calls
                 updateProgressBar( mouseX )
                 if(mpDisc)
                 {
                     bDiscMuteState = true
                     changeDiscMuteState()
                 }
                 else
                 {
                     //{modified by edo.lee 2013.06.29 for drag Mute
                     //bDragMuteState = true
                     //changeDragMuteState()
                     dragStartX = mouseX
                     //{modified by edo.lee 2013.06.29 for drag Mute
                 }
             }
             else
             {
                 changePlayingPosition(0);
             }
         }
         
         onReleased:
         {
            if(mouseX > -100 && bDraggable ) // added by Sergey 07.09.2013 for ITS#186722,188075 // modified ITS 210706,7
            {
                timerMA.stop()

                // { modified by kihyung 2013.08.29 for ITS 0186278
                if(mouseX < 0)
                {
                    second = 0;
                }
                else if(mouseX >= parent.width)
                {
                    second = (((parent.width - 1) / parent.width) * nTotalTime)
                    if(mpDisc)
                        second = Math.floor( second / 1000 ) * 1000
                }
                else
                {
                    second = ((mouseX / parent.width) * nTotalTime)
                    if(mpDisc)
                        second = Math.floor( second / 1000 ) * 1000
                }
                // } modified by kihyung 2013.08.29 for ITS 0186278

                // lastSecond = second
                __LOG("cursorMA onReleased [M:" + mouseX + ", W:" + parent.width + "], [S:" + second + ", T:" + nTotalTime + "]")
                // { modified by cychoi 2014.08.25 for twice changePlayingPosition signal calls
                if(second != lastSecondOnTriggered)
                {
                    changePlayingPosition(second)
                }
                lastSecondOnTriggered = -1
                // } modified by cychoi 2014.08.25
                
                if(mpDisc)
                {
                    bDiscMuteState = false
                    changeDiscMuteState()
                }
                else
                {
                    bDragMuteState = false
                    changeDragMuteState()
                }
            } // added by Sergey 07.09.2013 for ITS#186722,188075

            bPressed = false
         }
         
         onCanceled:
         {
            __LOG("cursorMA onCanceled " + mouseX)  
            
            bPressed = false
            if(mpDisc)
            {
               bDiscMuteState = false
               changeDiscMuteState()
            }
            // added by kihyung 2013.07.02 for crash when audio and video mode change during draging
            else 
            {
               bDragMuteState = false
               changeDragMuteState() 
            }
         }
         
         onPositionChanged: 
         {
            //{added by juanm 2013.07.26 for ITS_KOR_181816
            if( mouseX < -100)
            {
                __LOG("cursorMA mouse position changed too far - ignore : "+ mouseX)
                return;
            }
            //}added by junam

            if(bPressed)
            {
               updateProgressBar( mouseX )
               checkDragMute(mouseX)//added by edo.lee 2013.06.29
               // { removed by kihyung 2013.08.03
               /*
               // added by Dmitry 03.08.13
               if (mouseX > cursorMA.width)
                  bPressed = false;
               // added by Dmitry 03.08.13
               */
               // } removed by kihyung 2013.08.03               
            }
         }
         
		 //{added by edo.lee 2013.6.29 
         function checkDragMute(mX)
         {                  
			if( bPressed  && dragStartX != mouseX) //Math.abs(dragStartX - mouseX) > 10)
			{	
				bDragMuteState = true
				changeDragMuteState() 				                   
			}
         }
         
		 // { modified by kihyung 2013.08.03 for smoke test
         function updateProgressBar( mX )
         {
            if( bPrBarVisible && bSeekableMedia )
            {
                if ( mX >= 0 && mX <= parent.width )
                {
                    deltaX = Math.abs(lastFrameX - mouseX)
                    if(deltaX > 25) 
                    {
                        second = ( (mX / parent.width) * nTotalTime )
                        if(mpDisc) 
                            second = Math.floor( second / 1000 ) * 1000
                    }
                }
                else if(mX < 0)
                {
                    second = 0;
                }
                else if(mX > parent.width)
                {
                    second = nTotalTime - 10;
                }

                __LOG("cursorMA updateProgressBar [M:" + mouseX + ", W:" + parent.width + "], [S:" + second + ", T:" + nTotalTime + "]")

                if(second != lastSecond) 
                {
                    animateProgressBar(second)
                    lastSecond = second
                    timerMA.restart()
                }
            }
         }
		 // } modified by kihyung 2013.08.03 for smoke test         
         
         Timer
         {
             id: timerMA
  
             interval: 200
  
             onTriggered:
             {
                 __LOG("cursorMA onTriggered second: M:" + cursorMA.mouseX + ", S:" + cursorMA.lastSecond)
                 cursorMA.lastFrameX = cursorMA.mouseX
                 changePlayingPosition(cursorMA.lastSecond)
                 cursorMA.lastSecondOnTriggered = cursorMA.lastSecond // added by cychoi 2014.08.25 for twice changePlayingPosition signal calls
             }
         }
      }
      // { modified by kihyung 2013.07.09 for ITS 0178070 
   }

   // { removed by junggil 2012.08.15 for CR12316
   //onWidthChanged: updateTextPosiotion()
   //onNShortSizeChanged: updateTextPosiotion()
   // } removed by junggil
   function updateTextPosiotion()
   {
      if ( nShortSize == 1 )
      {
         textSongName.anchors.left = undefined
         textArtistName.anchors.left = undefined
         textArtistName.anchors.bottom = textSongName.top
      }
      else if ( nShortSize == 2 )
      {
         textSongName.anchors.left = progressBar.left
         textArtistName.anchors.left = textSongName.left
         textArtistName.anchors.bottom = textSongName.top
      }
      else
      {
         textSongName.anchors.left = progressBar.left
         textArtistName.anchors.left = textSongName.left
         textArtistName.anchors.bottom = textSongName.bottom
      }
   }

   // { modified by junggil 2012.08.15 for CR12316
   ////Song  name
   //Text
   //{
   //   id:textSongName
   //   visible:btextVisible
   //   anchors.left: parent.left
   //   anchors.top: parent.top
   //   anchors.topMargin: - 10
   //   text: sSongName
   //   font.pixelSize: 30
   //   color: bTuneTextColor ? "#800000" : "#FAFAFA"
   //}
   ////Album name
   //Text
   //{
   //   id: textArtistName
   //   visible: btextVisible
   //   anchors.left: textSongName.left
   //   anchors.top: parent.top
   //   anchors.topMargin: -46
   //   text: sArtistName
   //   font.pixelSize: 26
   //   font.family: "HDR"
   //   color: "#77797F"
   //}
   // Artist name
   Text
   {
      id: textArtistName
      visible: btextVisible
      width: 770
      anchors.left: parent.left
      anchors.leftMargin: 255
      anchors.top: parent.top
      anchors.topMargin: -110//-120 ys 2013.09.09 ITS-0188614
      text: sArtistName
      font.pixelSize: 32//40 ys 2013.09.09 ITS-0188614
      horizontalAlignment: Text.AlignHCenter
      //font.family: "HDR"
      font.family : HM.const_FONT_FAMILY_NEW_HDR
//modified by aettie 2013 08 07 for ITS 183095 
//modified by aettie 2013 08 09 coverflow tune text color spec changed
      color: bTuneTextColor ? "#7CBDFF" : "#FAFAFA"
      elide: Text.ElideRight // added by junggil 2012.08.31 for CR13022 [Jukebox] Title and Artist name in the Album view playback screen for lengthy file is not displaying correctly 
   }

   //Song  name
   Text
   {
      id: textSongName
      visible: btextVisible
      width: 770
      anchors.left: parent.left
      anchors.leftMargin: 255
      anchors.top: parent.top
      anchors.topMargin: -60
      text: sSongName
      font.pixelSize: 40 //32  ys 2013.09.09 ITS-0188614
      horizontalAlignment: Text.AlignHCenter
//modified by aettie 2013 08 07 for ITS 183095 
      color: bTuneTextColor ? "#7CBDFF" : "#FAFAFA"
      elide: Text.ElideRight // added by junggil 2012.08.31 for CR13022 [Jukebox] Title and Artist name in the Album view playback screen for lengthy file is not displaying correctly 
   }
   // } modified by junggil

    // Repeat icons
    Image
    {
       id: repeat_img
       anchors.top: progressBar.top
       // { modified by junggil 2012.08.15 for CR12316
       //anchors.topMargin: -75
       anchors.topMargin: -110
       // } modified by junggil
       anchors.left: progressBar.left
       anchors.leftMargin: 1150
       // { modified by kihyung 2012.06.30
       // source: nRepeatStatus == 1 ? "/app/share/images/general/ico_repeat_all_n.png" :
       //         nRepeatStatus == 2 ? "/app/share/images/general/ico_repeat_one_n.png" :
       //                              "/app/share/images/general/ico_repeat_all_d.png"
       source:(  bScanStatus == true                     )? "/app/share/images/general/ico_repeat_all_d.png" : // added by kihyung 2012.07.26 for CR 11894
              ( (nRepeatStatus == 1) && !__repeatPressed )? "/app/share/images/general/ico_repeat_all_n.png" :
              ( (nRepeatStatus == 2) && !__repeatPressed )? "/app/share/images/general/ico_repeat_one_n.png" :
              ( (nRepeatStatus == 3) && !__repeatPressed )? "/app/share/images/general/ico_repeat_folder_n.png" : //added by junam 2012.09.24 for CR12977
              ( (nRepeatStatus == 0) && __repeatPressed ) ? "/app/share/images/general/ico_repeat_all_n.png" :
              ( (nRepeatStatus == 1) && __repeatPressed ) ? "/app/share/images/general/ico_repeat_all_p.png" :
              ( (nRepeatStatus == 2) && __repeatPressed ) ? "/app/share/images/general/ico_repeat_one_p.png" :
              ( (nRepeatStatus == 3) && __repeatPressed ) ? "/app/share/images/general/ico_repeat_folder_p.png" : //ys-20130909 ITS 0187189 //added by junam 2012.09.24 for CR12977
                                                            "/app/share/images/general/ico_repeat_all_n.png"
       // } modifed by kihyung

       MouseArea
       {
          id: mouseArea_repeat_img
          anchors.fill: parent

          beepEnabled: false

          // { modified by kihyung 2013.08.08 for ITS 0181817
          onPressed: {
             __LOG("repeat onPressed")
             __repeatPressed = true
          }

          onReleased: {
             __LOG("repeat onReleased")
            //{ modified by shkim for ITS 198555
              beep()
            if(__repeatOutRange == false)
            {
                 changeRepeatMode()
            }
             __repeatPressed = false
             __repeatOutRange = false
            //} modified by shkim for ITS 198555
          }

          onCanceled: {
             __LOG("repeat onCanceled")
             __repeatPressed = false
             __repeatOutRange = false // added by shkim for ITS 198555
          }
          // } modified by kihyung 2013.08.08 for ITS 0181817
          //{ added by shkim for ITS 198555
          onExited:{
              __LOG("repeat press and drag")
              if(__repeatPressed == true)
                __repeatOutRange = true

              __repeatPressed = false
          }
          //} added by shkim for ITS 198555
       }
    }

   // Random status image
    Image
    {
       id: random_img
       visible: bPrBarRandomVisible // added by yongkyun.lee 20130224 for : ISV 73871
       anchors.top: progressBar.top
       // { modified by junggil 2012.08.15 for CR12316
       //anchors.topMargin: -75
       anchors.topMargin: -110
       // } modified by junggil
       anchors.left:progressBar.left
       anchors.leftMargin: 1062
       // { modified by kihyung 2012.06.30
       // source: bRandomStatus == false ? "/app/share/images/general/ico_shuffle_all_d.png" :
       //                                  "/app/share/images/general/ico_shuffle_all_n.png"
       source:( bScanStatus == true                     ) ? "/app/share/images/general/ico_shuffle_all_d.png" : // added by kihyung 2012.07.26 for CR 11894
              ( __randomPressed && (nRandomStatus == 0) ) ? "/app/share/images/general/ico_shuffle_all_p.png" :
              ( __randomPressed && (nRandomStatus == 1) ) ? "/app/share/images/general/ico_shuffle_all_p.png" :
              ( __randomPressed && (nRandomStatus == 2) ) ? "/app/share/images/general/ico_shuffle_all_p.png" :
              ( nRandomStatus == 0 ) ? "/app/share/images/general/ico_shuffle_all_d.png" :
              ( nRandomStatus == 1 ) ? "/app/share/images/general/ico_shuffle_all_n.png" :
              ( nRandomStatus == 2 ) ? "/app/share/images/general/ico_shuffle_all_n.png" :
                                       "/app/share/images/general/ico_shuffle_all_d.png"
       // } modified by kihyung

       MouseArea
       {
          id: mouseArea_random_img
          anchors.fill: parent

          beepEnabled: false

          // { modified by kihyung 2013.08.08 for ITS 0181817
          onPressed: {
             __randomPressed = true
          }
          onReleased: {
            //{ modified by shkim for ITS 198555
              beep()
            if(__randomOutRange == false)
            {
                 changeRandomMode()
            }
            __randomPressed = false
            __randomOutRange = false
            //} modified by shkim for ITS 198555

          }
          onCanceled: {
             __randomPressed = false
             __randomOutRange = false // added by shkim for ITS 198555
          }
          // } modified by kihyung 2013.08.08 for ITS 0181817
          //{ added by shkim for ITS 198555
          onExited:{
              __LOG("random press and drag")
              if(__randomPressed == true)
                __randomOutRange = true

              __randomPressed = false
          }
          //} added by shkim for ITS 198555
       }

//       SequentialAnimation on opacity {
//          running: bScanStatus
//          loops: Animation.Infinite
//          PropertyAnimation { to: 0; duration: 1000 }
//          PropertyAnimation { to: 0; duration: 300 }
//          PropertyAnimation { to: 1; duration: 1000 }
//       }
    }
// modified by Dmitry 21.07.13 for ITS0180711
// Current time
   Text
   {
      id: textCurrentTime
      anchors.left: parent.left
      //anchors.leftMargin: 20   // removed by dongjin 2012.08.14 for CR12351
      anchors.leftMargin: 1 //21    // modified by sangmin.seol 2014.04.02 for New Progressbar GUI  // added by dongjin 2012.08.14 for CR12351
      anchors.verticalCenter: bg_pb.verticalCenter
      //font.family: "HDR"   // removed by dongjin 2012.08.14 for CR12351
      //font.pixelSize: 28   // removed by dongjin 2012.08.14 for CR12351
    //  font.family: "HDB"     // added by dongjin 2012.08.14 for CR12351
      font.family : HM.const_FONT_FAMILY_NEW_HDB
      font.pixelSize: 32     // added by dongjin 2012.08.14 for CR12351
      horizontalAlignment: Text.AlignRight   // added by sangmin.seol 2014.04.02 for New Progressbar GUI      
      width: 156 //121 //text.length < 6 ? 103 : 150   // modified by sangmin.seol 2014.04.02 for New Progressbar GUI    // added by dongjin 2012.08.14 for CR12351
//[KR][ITS][183579][comment](aettie.ji) 20130809       
//      color: "#8db3ff"
      color: "#FAFAFA"
      text: convertTime( nCurrentTime )
   }

// Total time
   Text
   {
      id: textTotalTime
      anchors.right: parent.right
      anchors.rightMargin: 1 //21   // modified by sangmin.seol 2014.04.02 for New Progressbar GUI
      //anchors.left: parent.left
      //anchors.leftMargin: 21+121+996
      //anchors.leftMargin: 1164   // removed by dongjin 2012.08.14 for CR12351
      //anchors.rightMargin: 10     // added by dongjin 2012.08.14 for CR12351
      anchors.verticalCenter: bg_pb.verticalCenter
      horizontalAlignment: Text.AlignLeft   // added by sangmin.seol 2014.04.02 for New Progressbar GUI
      width: 156                            // added by sangmin.seol 2014.04.02 for New Progressbar GUI
      //font.family: "HDR"   // removed by dongjin 2012.08.14 for CR12351
      //font.pixelSize: 28   // removed by dongjin 2012.08.14 for CR12351
      //font.family: "HDB"     // added by dongjin 2012.08.14 for CR12351
      font.family : HM.const_FONT_FAMILY_NEW_HDB
      font.pixelSize: 32     // added by dongjin 2012.08.14 for CR12351
      //width: 103             // added by dongjin 2012.08.14 for CR12351
//[KR][ITS][183579][comment](aettie.ji) 20130809      
//      color: "#8db3ff"
      color: "#FAFAFA"
      text: convertTime( nTotalTime )
      visible: bPrBarVisible
   }
   
   // modified by richard 2012.10.25 for navi slowness fix
   //function convertTime( t )
   function convertTime( ms )
   {
      // { modified by cychoi 2015.07.10 for HMC new spec (time >= 1 hour - HH:MM:SS, time < 1 hour - MM:SS, wo leading zero)
      var t = Math.floor( ms / 1000 )
      var mm = Math.floor( t / 60 )
      var hh = 0
      var str
      var ss = t % 60
      if (mm > 59)
      {
         hh = Math.floor(mm / 60)
         mm = mm - hh * 60
         //if (hh < 10) {hh = '0' + hh} // wo leading zero
         if (mm < 10) {mm = '0' + mm}
         if (ss < 10) {ss = '0' + ss}
         str = hh + ':' + mm + ':' + ss
      }
      else
      {
         //if (mm < 10) {mm = '0' + mm} // wo leading zero
         if (ss < 10) {ss = '0' + ss}
         str = mm + ':' + ss
      }
      // } modified by cychoi 2015.07.10

      return str;
   }
// modified by Dmitry 21.07.13 for ITS0180711
}
