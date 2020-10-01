import Qt 4.7
import Qt.labs.gestures 2.0
import "DHAVN_SimpleItemsMediaProgressBar.js" as HM
import "DhAvnSimpleItemsResources.js" as RES

Item
{
   id: progressBar

   property bool pressed: false
   property int const_MUSIC_PLAYER_FULLSCREEN : 0
   property int const_MUSIC_PLAYER_NOT_FULLSCREEN : 1
   property int const_VIDEO_PLAYER : 2
   property int const_SOUND_THERAPY : 3

   /**true - Full Screen ProgressBar, false - ProgressBar for CD player*/

   /**sstate: const_MUSIC_PLAYER_FULLSCREEN, const_MUSIC_PLAYER_NOT_FULLSCREEN,
              const_VIDEO_PLAYER, const_SOUND_THERAPY*/
   property int sState: progressBar.const_MUSIC_PLAYER_FULLSCREEN

   /* Repeat type property */
   property int const_REPEAT_OFF:       0
   property int const_REPEAT_FILE:      1
   property int const_REPEAT_FOLDER:    2

   property int iRepeatMode: progressBar.const_REPEAT_OFF

   property int iTotalTime: 0
   property int iCurrentTime: 0
   property int __iCurrentTime: iCurrentTime
   property bool __saveBStartRunning: bStartRunning
   property bool visiblehide:true
   property bool hideProgresBar : false;

   /**play tracks random*/
   property bool bRandom: true
   property bool bScan: false

   property string sText1: ""
   property string sText2: ""
   property string sNumber: ""
   property bool bChanging: false

   property bool bInteractive: true

   property bool bStartRunning: true

   /** true - item is focused, false - not focused */
   property bool bFocused: false

   /** true - if the cursor was moved manually */
   property bool __bCursorMoved: false

   property bool bPointerVisible: true

   /**resources*/
   property url __icon_play_random: RES.const_URL_IMG_MUSIC_RANDOM_PLAY
   property url __icon_play_repeat_file: RES.const_URL_IMG_MUSIC_REPEAT_FILE_PLAY
   property url __icon_play_repeat_folder: RES.const_URL_IMG_MUSIC_REPEAT_FOLDER_PLAY
   property url __icon_play_scan: RES.const_URL_IMG_MUSIC_SCAN_PLAY
   property url __pgbar_bg_s: RES.const_URL_IMG_MUSIC_PRBAR_BACKGROUND_PLAYED
   property url __pgbar_bg_n: RES.const_URL_IMG_MUSIC_PRBAR_BACKGROUND_NOT_PLAYED
   property url __pgbar_pointer_circle: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_CIRCLE
   property url __pgbar_pointer_1: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_1
   property url __pgbar_pointer_2: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_2
   property url __pgbar_pointer_3: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_3
   property url __pgbar_pointer_4: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_4
   property url __pgbar_pointer_5: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_5
   property url __pgbar_pointer_6: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_6
   property url __pgbar_pointer_7: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_7
   property url __pgbar_pointer_8: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_8
   property url __pgbar_pointer_9: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_9
   property url __pgbar_pointer_10: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_10
   property url __pgbar_pointer_11: RES.const_URL_IMG_MUSIC_PRBAR_POINTER_11

   /**Signals*/
   signal playingDone();                                      /**finish playing*/
   signal changePlayingPosition (int seconds);                /**user changed playing position*/
   signal cursorPressed(int seconds);                         /**user pressed cursor button*/
   signal cursorReleased(int seconds);                        /**user released cursor button*/

   function __convertTime( value )
   {
     var hour = Math.floor( value / ( 60 * 60 ) )
     var minute = Math.floor( value / 60 - hour * 60 )
     var second = Math.floor( value - minute * 60 - hour * 3600 )
     var ret = ( sState == progressBar.const_VIDEO_PLAYER )
             ? ( hour + ":" + ( ( minute < 10 ) ? "0" : "" ) + minute + ":" + ( ( second < 10 ) ? "0" : "" ) + second )
             : ( ( ( minute < 10 ) ? "0" : "" ) + minute + ":" + ( ( second < 10 ) ? "0" : "" ) + second )

     return ret
   }

   function incrementValue()
   {
      if ( iCurrentTime < iTotalTime )
      {
         iCurrentTime++
         changePlayingPosition( iCurrentTime )
      }
   }

   function decrementValue()
   {
       if ( iCurrentTime > 0 )
       {
          iCurrentTime--
          changePlayingPosition( iCurrentTime )
       }
   }
   
   width: ( sState != progressBar.const_MUSIC_PLAYER_NOT_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_FULLSCREEN_WIDTH
                                                                      : HM.const_TEXT_PROGRESS_BAR_NOT_FULLSCREEN_WIDTH;
   height: ( sState != progressBar.const_MUSIC_PLAYER_NOT_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_FULLSCREEN_HEIGHT
                                                                       : HM.const_TEXT_PROGRESS_BAR_NOT_FULLSCREEN_HEIGHT;

   /** focus */
   Rectangle
   {
      id: focus_rect
      anchors.centerIn: progress_bar_item
      height: progress_bar_item.height + 5
      width: progress_bar_item.width + 5
      color: RES.const_FOCUSED_ITEM_COLOR
      visible: progressBar.bFocused
      radius: 10
      //z: RES.const_FOCUSED_ITEM_Z
   }

   Item
   {
      id: current_time_item

      width: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_CURRENT_TIME_WIDTH
                                                          : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_CURRENT_TIME_WIDTH
                                                                                                            : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_CURRENT_TIME_WIDTH
                                                                                                                                                                        : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_CURRENT_TIME_WIDTH))
      height: HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_HEIGHT
      x: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_CURRENT_TIME_LEFT_MARGIN
                                                      : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_CURRENT_TIME_LEFT_MARGIN
                                                                                                        : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_CURRENT_TIME_LEFT_MARGIN
                                                                                                                                                                    : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_CURRENT_TIME_LEFT_MARGIN ) )
      anchors.bottom: progressBar.bottom

      /**current time text*/
      Text
      {
         id: current_time_text
         horizontalAlignment: Text.AlignRight
         font.pixelSize: ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_SIZE_TEXT_24PT
                                                                       : HM.const_FONT_SIZE_TEXT_SUN_FONT
         color: HM.const_COLOR_TEXT_PROGRESS_BLUE
        // font.family: HM.const_FONT_FAMILY_HDR
         font.family: HM.const_FONT_FAMILY_NEW_HDR
         y: ( current_time_item.height - current_time_text.height ) / 2
      }
   }
   Binding
   {
       target: current_time_text
       property: "text"
       value: __convertTime( iCurrentTime )
   }

   Item
   {
      id: progress_bar_item

      visible: (hideProgresBar) ? false : true;

      width: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_PROGRESSBAR_ITEM_WIDTH
                                                          : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_PROGRESSBAR_ITEM_WIDTH
                                                                                                            : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH
                                                                                                                                                                        : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH))
      x: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_PROGRESSBAR_ITEM_LEFT_MARGIN
                                                      :( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_PROGRESSBAR_ITEM_LEFT_MARGIN
                                                                                                       : (  ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_PROGRESSBAR_ITEM_LEFT_MARGIN
                                                                                                                                                                    : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_PROGRESSBAR_ITEM_LEFT_MARGIN ) )
      height: current_time_item.height
      anchors.bottom: progressBar.bottom

      Item
      {
         id: highlight
         height: HM.const_TEXT_PROGRESS_BAR_HIGHLIGHT_ITEM_HEIGHT
         width: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2
                                                                           : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2
                                                                                                                             : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2
                                                                                                                                                                                         : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2))
         anchors.verticalCenter: progress_bar_item.verticalCenter
         anchors.horizontalCenter: progress_bar_item.horizontalCenter

         Rectangle
         {
            height: HM.const_TEXT_PROGRESS_BAR_HIGHLIGHT_ITEM_HEIGHT
            color: HM.const_COLOR_TEXT_DIMMED_GREY
            anchors.verticalCenter: parent.verticalCenter
            width: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2
                                                                : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2
                                                                                                                  : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2
                                                                                                                                                                              : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2))
         }
      }

      Rectangle
      {
         height: HM.const_TEXT_PROGRESS_BAR_HIGHLIGHT_ITEM_HEIGHT
         color: HM.const_COLOR_TEXT_PROGRESS_BLUE
         anchors.verticalCenter: parent.verticalCenter
         width: cursor.x + cursor.width / 2
         x: highlight.x
      }

      Item
      {
         id: slider
         visible: (visiblehide)? true:false

         Image
         {
            id: pointer_1
            x: ( pointer_3.visible ) ? pointer_2.x - pointer_1.width : cursor.x
            source: progressBar.__pgbar_pointer_1
         }

         Image
         {
            id: pointer_2
            x: ( pointer_3.visible ) ? pointer_3.x - pointer_2.width : cursor.x + pointer_2.width
            source: progressBar.__pgbar_pointer_2
            visible: cursor.x > 0 ? true : false
         }

         Image
         {
            id: pointer_3
            x: ( pointer_4.visible ) ? pointer_4.x - pointer_3.width : cursor.x + pointer_3.width
            source: progressBar.__pgbar_pointer_3
            visible: cursor.x > 10 ? true : false
         }

         Image
         {
            id: pointer_4
            x: ( pointer_5.visible ) ? pointer_5.x - pointer_4.width : cursor.x + pointer_4.width
            source: progressBar.__pgbar_pointer_4
            visible: cursor.x > 20 ? true : false
         }

         Image
         {
            id: pointer_5
            x: ( pointer_6.visible ) ? pointer_6.x - pointer_5.width : cursor.x + pointer_5.width
            source: progressBar.__pgbar_pointer_5
            visible: cursor.x > 30 ? true : false
         }

         Image
         {
            id: pointer_6
            x: ( pointer_7.visible ) ? pointer_7.x - pointer_6.width : cursor.x + pointer_6.width
            source: progressBar.__pgbar_pointer_6
            visible: cursor.x > 40 ? true : false
         }

         Image
         {
            id: pointer_7
            x: ( pointer_8.visible ) ? pointer_8.x - pointer_7.width : cursor.x + pointer_7.width
            source: progressBar.__pgbar_pointer_7
            visible: cursor.x > 50 ? true : false
         }

         Image
         {
            id: pointer_8
            x: ( pointer_9.visible ) ? pointer_9.x - pointer_8.width : cursor.x + pointer_8.width
            source: progressBar.__pgbar_pointer_8
            visible: cursor.x > 60 ? true : false
         }

         Image
         {
            id: pointer_9
            x: ( pointer_10.visible ) ? pointer_10.x - pointer_9.width : cursor.x + pointer_9.width
            source: progressBar.__pgbar_pointer_9
            visible: cursor.x > 70 ? true : false
         }

         Image
         {
            id: pointer_10
            x: ( pointer_11.visible ) ? pointer_11.x - pointer_10.width : cursor.x + pointer_10.width
            source: progressBar.__pgbar_pointer_10
            visible: cursor.x > 80 ? true : false
         }

         Image
         {
            id: pointer_11
            x: cursor.x + pointer_11.width
            source: progressBar.__pgbar_pointer_11
            visible: cursor.x > 90 ? true : false
         }

         Image
         {
            id: cursor
            x: ( progressBar.__iCurrentTime * highlight.width / ( progressBar.iTotalTime ) ) - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN
            height: HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_HEIGHT
            source: progressBar.__pgbar_pointer_circle

            GestureArea
            {
               anchors.fill: parent

               Pan
               {
                  onFinished:
                  {
                    progressBar.pressed = false
                  }

                  onUpdated:
                  {
                     if( progressBar.bInteractive )
                     {
                       if( gesture.delta.x > 0 )
                       {
                         progressBar.pressed = true
                         cursor.x += gesture.delta.x

                         if( ( cursor.x + HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN ) >= highlight.width )
                         {
                           cursor.x = highlight.width - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN
                         }
                       }
                       else if( gesture.delta.x < 0 )
                       {
                         progressBar.pressed = true
                         cursor.x += gesture.delta.x

                         if( (cursor.x + HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN ) <= ( highlight.x ) )
                         {
                           cursor.x = - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN
                         }
                       }

                       __bCursorMoved = true //this flag indicates that we have changed cursor position manually
                       iCurrentTime = ( cursor.x + HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN ) * iTotalTime / highlight.width
                       __iCurrentTime = iCurrentTime
                       current_time_text.text = __convertTime( iCurrentTime )
                    }
                  }
               }
            }

            MouseArea
            {
               anchors.fill: parent
               onPressed:
               {
                  if( progressBar.bInteractive )
                  {
                    __saveBStartRunning = bStartRunning
                    bStartRunning = false
                    cursor_animation.stop()
                    /**send signal cursorPressed*/
                    cursorPressed( ( cursor.x + HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN) * iTotalTime / highlight.width )
                  }
               }

               onReleased:
               {
                  if( progressBar.bInteractive )
                  {
                    bStartRunning = __saveBStartRunning
                    if (cursor_animation.running)
                    {
                      cursor_animation.start()
                    }

                    /**send signal cursorReleased*/
                    cursorReleased( ( cursor.x + HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN) * iTotalTime / highlight.width )

                    /**send signal playingDone*/
                    if( cursor.x >= ( highlight.width - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN ) )
                    {
                      playingDone()
                    }
                 }
               }

               onMousePositionChanged:
               {
                  if( progressBar.bInteractive )
                  {
                    /**send signal changePlayingPosition*/
                    changePlayingPosition( ( cursor.x + HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN) * iTotalTime / highlight.width )
                  }
               }
            }

            NumberAnimation
            {
              id: cursor_animation
              target: cursor
              property: "x"
            }

            Binding
            {
               target: cursor_animation
               property: "running"
               value: bStartRunning
            }

            Binding
            {
               target: cursor_animation
               property: "duration"
               value: ( iTotalTime - __iCurrentTime ) * 1000
            }

            Binding
            {
               target: cursor_animation
               property: "to"
               value: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3
                                                               : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3
                                                                                                                 : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3
                                                                                                                                                                             : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3))
            }
         }
      }
   }

   Item
   {
      id: total_time_item

      visible: (hideProgresBar) ? false : true;

      width: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_TOTAL_TIME_WIDTH
                                                          : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_TOTAL_TIME_WIDTH
                                                                                                            : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_TOTAL_TIME_WIDTH
                                                                                                                                                                        : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_TOTAL_TIME_WIDTH ) )
      height: HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_HEIGHT
      anchors.bottom: progressBar.bottom
      anchors.left: progress_bar_item.right
      anchors.leftMargin: HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_TOTAL_TIME_LEFT_MARGIN

      /**total time text*/
      Text
      {
         id: total_time_text

         text: __convertTime( iTotalTime )
         horizontalAlignment: Text.AlignLeft
         font.pixelSize: ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_SIZE_TEXT_24PT
                                                                       : HM.const_FONT_SIZE_TEXT_SUN_FONT
         color: HM.const_COLOR_TEXT_GREY
       //  font.family: HM.const_FONT_FAMILY_HDR
         font.family: HM.const_FONT_FAMILY_NEW_HDR
         y: ( current_time_item.height - current_time_text.height ) / 2
      }
   }

   Item
   {
      id: random_item

      x: progress_bar_item.x + progress_bar_item.width - highlight.x - random_image.width
      width: random_image.width
      height: random_image.height
      y: ( sState == progressBar.const_VIDEO_PLAYER ) ? progress_bar_item.y - HM.const_TEXT_PROGRESS_BAR_VIDEO_REPEAT_ITEM_TOP_MARGIN
                                                      : ( ( sState == progressBar.const_SOUND_THERAPY ) ? progress_bar_item.y - HM.const_TEXT_PROGRESS_BAR_VIDEO_REPEAT_ITEM_TOP_MARGIN
                                                                                                        : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? progress_bar_item.y - random_item.height
                                                                                                                                                                    : progress_bar_item.y - random_item.height ) )

      Image
      {
         id: random_image
         source: progressBar.__icon_play_random
         visible: bRandom
      }
   }

   Item
   {
      id: repeat_item

      width: repeat_image.width
      height: repeat_image.height
      anchors.right: random_item.left
      anchors.rightMargin: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_REPEAT_ITEM_RIGHT_MARGIN
                                                                        : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_SOUND_THERAPY_REPEAT_ITEM_RIGHT_MARGIN
                                                                                                                          : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_REPEAT_ITEM_RIGHT_MARGIN
                                                                                                                                                                                      : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_REPEAT_ITEM_RIGHT_MARGIN ) )
      y: ( sState == progressBar.const_VIDEO_PLAYER ) ? progress_bar_item.y - HM.const_TEXT_PROGRESS_BAR_VIDEO_REPEAT_ITEM_TOP_MARGIN
                                                      : ( ( sState == progressBar.const_SOUND_THERAPY ) ? progress_bar_item.y - HM.const_TEXT_PROGRESS_BAR_VIDEO_REPEAT_ITEM_TOP_MARGIN
                                                                                                        : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? progress_bar_item.y - repeat_item.height
                                                                                                                                                                    : progress_bar_item.y - repeat_item.height ) )


      Image
      {
         id: repeat_image

         source:
         {
             if (iRepeatMode == progressBar.const_REPEAT_FILE)
             {
                return progressBar.__icon_play_repeat_file
             }
             else
             {
                 return progressBar.__icon_play_repeat_folder
             }
         }

         visible:
         {
             if (iRepeatMode ==  progressBar.const_REPEAT_FILE || iRepeatMode ==  progressBar.const_REPEAT_FOLDER)
             {
                 return true;
             }
             else
             {
                 return false;
             }
         }
      }
   }

   Item
   {
      id: scan_item

      width: scan_image.width
      height: scan_image.height
      anchors.right: repeat_item.left

      anchors.rightMargin: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_REPEAT_ITEM_RIGHT_MARGIN
                                                                        : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_SOUND_THERAPY_REPEAT_ITEM_RIGHT_MARGIN
                                                                                                                          : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_REPEAT_ITEM_RIGHT_MARGIN
                                                                                                                                                                                      : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_REPEAT_ITEM_RIGHT_MARGIN ) )
      y: ( sState == progressBar.const_VIDEO_PLAYER ) ? progress_bar_item.y - HM.const_TEXT_PROGRESS_BAR_VIDEO_REPEAT_ITEM_TOP_MARGIN
                                                      : ( ( sState == progressBar.const_SOUND_THERAPY ) ? progress_bar_item.y - HM.const_TEXT_PROGRESS_BAR_VIDEO_REPEAT_ITEM_TOP_MARGIN
                                                                                                        : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? progress_bar_item.y - scan_item.height
                                                                                                                                                                    : progress_bar_item.y - scan_item.height ) )

      SequentialAnimation
      {
         id: anim

         loops: Animation.Infinite
         running: ( bScan == true );

         NumberAnimation
         {
            target: scan_image
            property: "visible"
            from: 0
            to: 1
            duration: 500
         }

         NumberAnimation
         {
            target: scan_image
            property: "visible"
            from: 1
            to: 0
            duration: 500
          }
      }


      Image
      {
         id: scan_image
         source: progressBar.__icon_play_scan
         visible: bScan
      }
   }


   Item
   {
      id: text1_item

      width: ( sState == progressBar.const_VIDEO_PLAYER ) ? current_time_item.width
                                                          : ( ( sState == progressBar.const_SOUND_THERAPY ) ? text1.width + HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_TEXT1_RIGHT_MARGIN
                                                                                                            : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? text1.width + HM.const_TEXT_PROGRESS_BAR_TEXT1_RIGHT_MARGIN
                                                                                                                                                                        : text1.width + HM.const_TEXT_PROGRESS_BAR_TEXT1_RIGHT_MARGIN ) )
      height: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_SIZE_TEXT_BUTTON_FONT
                                                           : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_SIZE_TEXT_26PT
                                                                                                             : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_SIZE_TEXT_BUTTON_FONT
                                                                                                                                                                         : HM.const_FONT_SIZE_TEXT_36PT ) )
      x: ( sState == progressBar.const_VIDEO_PLAYER ) ? current_time_item.x
                                                      : ( ( sState == progressBar.const_SOUND_THERAPY ) ? current_time_item.x
                                                                                                       : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_CURRENT_TIME_LEFT_MARGIN
                                                                                                                                                                   : current_time_item.x - HM.const_TEXT_PROGRESS_BAR_TEXT1_LEFT_MARGIN ) )
      y: ( sState == progressBar.const_VIDEO_PLAYER ) ? current_time_item.y - HM.const_FONT_SIZE_TEXT_BUTTON_FONT
                                                      : ( ( sState == progressBar.const_SOUND_THERAPY ) ? current_time_item.y - HM.const_FONT_SIZE_TEXT_26PT
                                                                                                        : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? current_time_item.y - HM.const_FONT_SIZE_TEXT_BUTTON_FONT
                                                                                                                                                                    : 0 ) )


      Text
      {
         id: text1

         visible: true
         text: progressBar.sText1
         horizontalAlignment: Text.AlignLeft
         font.pixelSize: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_SIZE_TEXT_BUTTON_FONT
                                                                      : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_SIZE_TEXT_26PT
                                                                                                                        : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_SIZE_TEXT_BUTTON_FONT
                                                                                                                                                                                   : HM.const_FONT_SIZE_TEXT_36PT ) )
         color: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_COLOR_TEXT_BRIGHT_GREY
                                                             : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_COLOR_TEXT_BRIGHT_GREY
                                                                                                               : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? ( bChanging ? HM.const_COLOR_TEXT_PROGRESS_RED :HM.const_COLOR_TEXT_BRIGHT_GREY)
                                                                                                                                                                           : HM.const_COLOR_TEXT_DIMMED_GREY ) )
        // font.family: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_FAMILY_NEW_HDB
        //                                                           :( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_FAMILY_HDR
        //                                                                                                            : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_FAMILY_HDB
        //                                                                                                                                                                        : HM.const_FONT_FAMILY_HDR ) )
         font.family: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_FAMILY_NEW_HDB
                                                                   :( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_FAMILY_NEW_HDR
                                                                                                                    : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_FAMILY_NEW_HDB
                                                                                                                                                                                : HM.const_FONT_FAMILY_NEW_HDR ) )
      }
   }

   Item
   {
      id: text2_item

      width: text2.width
      height: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_SIZE_TEXT_BUTTON_FONT
                                                           : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_SIZE_TEXT_26PT
                                                                                                             : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_SIZE_TEXT_INDEX_FONT
                                                                                                                                                                         : HM.const_FONT_SIZE_TEXT_52PT ) )
      x: ( sState == progressBar.const_VIDEO_PLAYER ) ? text1_item.x + text1.width
                                                      : ( ( sState == progressBar.const_SOUND_THERAPY ) ? text1_item.x + text1_item.width
                                                                                                        : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? text1_item.x + text1_item.width
                                                                                                                                                                    : current_time_item.x ) )
      y: ( sState == progressBar.const_VIDEO_PLAYER ) ? text1_item.y
                                                      : ( ( sState == progressBar.const_SOUND_THERAPY ) ? text1_item.y
                                                                                                        : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? current_time_item.y - HM.const_FONT_SIZE_TEXT_INDEX_FONT
                                                                                                                                                                    : text1_item.y + text1_item.height + HM.const_TEXT_PROGRESS_BAR_TEXT1_BOTTOM_MARGIN ) )


       Text
       {
          id: text2

          visible: true
          text: progressBar.sText2
          horizontalAlignment: Text.AlignLeft
          font.pixelSize: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_SIZE_TEXT_BUTTON_FONT
                                                                       :( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_SIZE_TEXT_26PT
                                                                                                                        : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_SIZE_TEXT_INDEX_FONT
                                                                                                                                                                                    : HM.const_FONT_SIZE_TEXT_52PT ) )
          color: ( sState == progressBar.const_VIDEO_PLAYER ) ? ( bChanging ? HM.const_COLOR_TEXT_PROGRESS_RED : HM.const_COLOR_TEXT_PROGRESS_BLUE)
                                                              : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_COLOR_TEXT_BRIGHT_GREY
                                                                                                                : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ?( bChanging ? HM.const_COLOR_TEXT_PROGRESS_RED : HM.const_COLOR_TEXT_DIMMED_GREY)
                                                                                                                                                                           : HM.const_COLOR_TEXT_WHITE ) )
        //  font.family: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_FAMILY_HDR
        //                                                            : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_FAMILY_HDB
        //                                                                                                              : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_FAMILY_HDR
        //                                                                                                                                                                          : HM.const_FONT_FAMILY_HDR ) )
          font.family: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_FAMILY_NEW_HDR
                                                                    : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_FAMILY_NEW_HDB
                                                                                                                      : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_FAMILY_NEW_HDB
                                                                                                                                                                                  : HM.const_FONT_FAMILY_NEW_HDR ) )
      }
   }

   Item
   {
      id: number_item

      width: number.width
      height: ( sState == progressBar.const_VIDEO_PLAYER ) ? number.height
                                                           : ( ( sState == progressBar.const_SOUND_THERAPY ) ? number.height
                                                                                                           : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? number.height
                                                                                                                                                                       : number.height ) )
      x: random_item.x+random_item.width-number.width
      anchors.bottom: random_item.top

      Text
      {
         id: number

         visible: ((sState == progressBar.const_VIDEO_PLAYER)||(sState ==progressBar.const_MUSIC_PLAYER_FULLSCREEN )) ? true : false
         text: progressBar.sNumber
         horizontalAlignment: Text.AlignRight
         font.pixelSize: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_SIZE_TEXT_SUN_FONT
                                                                      :( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_SIZE_TEXT_SUN_FONT
                                                                                                                       : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_SIZE_TEXT_SUN_FONT
                                                                                                                                                                                   : HM.const_FONT_SIZE_TEXT_SUN_FONT ) )
         color: ( sState == progressBar.const_VIDEO_PLAYER ) ? ( bChanging ? HM.const_COLOR_TEXT_PROGRESS_RED : HM.const_COLOR_TEXT_GREY)
                                                             : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_COLOR_TEXT_BRIGHT_GREY
                                                                                                               :( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? ( bChanging ? HM.const_COLOR_TEXT_PROGRESS_RED : HM.const_COLOR_TEXT_DIMMED_GREY)
                                                                                                                                                                          : HM.const_COLOR_TEXT_DIMMED_GREY ) )
      //   font.family: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_FAMILY_HDR
      //                                                             : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_FAMILY_HDR
      //                                                                                                               : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_FAMILY_HDR
         font.family: ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_FONT_FAMILY_NEW_HDR
                                                                   : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_FONT_FAMILY_NEW_HDR
                                                                                                                     : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_FONT_FAMILY_NEW_HDR
                                                                                                                                                                                 : HM.const_FONT_FAMILY_NEW_HDR ) )
                                                                                                                                                                                 
      }
   }

   onSStateChanged:
   {
      highlight.width = ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2
                                                                    : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2
                                                                                                                      : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2
                                                                                                                                                                                  : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 2))
      cursor_animation.running =  false
      cursor_animation.duration = ( iTotalTime - __iCurrentTime ) * 1000
      cursor_animation.to = ( ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3
                                                                         : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3
                                                                                                                           : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3
                                                                                                                                                                                       : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3 ) ) )
      cursor_animation.running = bStartRunning
      cursor.x = ( progressBar.__iCurrentTime * highlight.width / ( progressBar.iTotalTime ) ) - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN
   }

   onICurrentTimeChanged:
   {
      cursor_animation.running =  false
      cursor_animation.duration = ( iTotalTime - iCurrentTime ) * 1000
      cursor_animation.to = ( ( sState == progressBar.const_VIDEO_PLAYER ) ? HM.const_TEXT_PROGRESS_BAR_VIDEO_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3
                                                                         : ( ( sState == progressBar.const_SOUND_THERAPY ) ? HM.const_TEXT_PROGRESS_BAR_SOUND_THERAPY_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3
                                                                                                                           : ( ( sState == progressBar.const_MUSIC_PLAYER_FULLSCREEN ) ? HM.const_TEXT_PROGRESS_BAR_MUSIC_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3
                                                                                                                                                                                       : HM.const_TEXT_PROGRESS_BAR_MUSIC_NOT_FULLSCREEN_PROGRESSBAR_ITEM_WIDTH - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN * 3 ) ) )



      if ( __bCursorMoved )
      {
         //cursor position was changed manually
         __bCursorMoved = false
      }
      else
      {
         //change cursor position according to current time
          //{ Changed by Radhakrushna for #ITS 0178180 on dated 2013.07.11

          if ( progressBar.iTotalTime != 0 )
            cursor.x = ( progressBar.iCurrentTime * highlight.width / ( progressBar.iTotalTime ) ) //- HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN
         else
            cursor.x = highlight.width //- HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN

          if(bPointerVisible)
              cursor.x = cursor.x - HM.const_TEXT_PROGRESS_BAR_CURRENT_TIME_RIGHT_MARGIN

         //} #ITS 0178180 on dated 2013.07.11
      }
      __iCurrentTime = iCurrentTime
      cursor_animation.running = bStartRunning
   }

   onBStartRunningChanged:
   {
      timer.running = bStartRunning
      __iCurrentTime = iCurrentTime
   }

   Timer
   {
       id: timer
       interval: HM.const_TIMER_INTERVAL
       repeat: true
       running: true
       onTriggered:
       {
          if( progressBar.bStartRunning == true && progressBar.iCurrentTime < progressBar.iTotalTime )
          {
              progressBar.iCurrentTime++;
          }
          else
          {
              timer.running = false
              playingDone();
          }
       }
   }
 }
