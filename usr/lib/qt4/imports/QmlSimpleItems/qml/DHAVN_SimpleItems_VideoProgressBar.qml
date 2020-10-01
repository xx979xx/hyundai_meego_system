import Qt 4.7

Item
{
   id: progressBar

   /** Visible property for Cursor on progressbar */
   property bool bCursorVisible: true
   /** Visible property of progress bar */
   property bool bPrBarVisible: true
   /** main name */
   property string sName: ""
   /** sybname */
   property string sSubName: ""
   /** Files count text ("2/10" ) */
   property string sFilesCount: ""
   /** change color of text to RED */
   property bool bTuneTextColor: false
   /** Minimal value is always 0 */
   /** Current time can be more then total time */
   property int nCurrentTime: 0
   /** Total time, any integer value */
   property int nTotalTime: 0
   /** Repeat status: 0 - none, 1 - all, 2 - file, 3 - folder */
   property int nRepeatStatus: 0
   /** Random status: 0 - disabled, 1 - all, 2 - folder */
   property int nRandomStatus: 0
   /** Disable mouse interaction */
   property bool bEnabled: true

   signal changePlayingPosition()
   signal playingDone()

/** ============================================================= */
/** ===================== Private area ========================== */
/** ============================================================= */

   width: 1224
   height: bPrBarVisible ? 90 : 58
   anchors.left: parent.left
   anchors.leftMargin: 29

   Component.onCompleted:
   {
      animateProgressBar()
   }

   onNCurrentTimeChanged: animateProgressBar()

   function animateProgressBar()
   {
      if ( nCurrentTime < 0 )
         return

      if ( nCurrentTime == 0 )
         selected_pb_animation.duration = 0

      if ( nCurrentTime <= nTotalTime )
      {
         selected_pb_animation.to = bCursorVisible * ( cursor_image.sourceSize.width / 4 )
         if ( nTotalTime )
            selected_pb_animation.to += ( nCurrentTime / nTotalTime ) *
                                        ( bg_pb.width - bCursorVisible * cursor_image.sourceSize.width / 2 )
         selected_pb_animation.restart()
      }

      selected_pb_animation.duration = 1000

      if ( nCurrentTime > 0 && nCurrentTime == nTotalTime )
         playingDone()
   }

// Background image of progress bar
   Image
   {
      id: bg_pb
      anchors.left: textCurrentTime.right
      anchors.leftMargin: 13
      anchors.right: textTotalTime.left
      anchors.rightMargin: 13
      anchors.verticalCenter: textCurrentTime.verticalCenter
      visible: bPrBarVisible
      fillMode: Image.TileHorizontally
      source: "/app/share/images/music/pgbar_bg_n.png"

// Selected image of progress bar
      Image
      {
         id: selected_pb
         anchors.left: parent.left
         anchors.verticalCenter: parent.verticalCenter
         fillMode: Image.TileHorizontally
         source: "/app/share/images/music/pgbar_bg_s.png"

         NumberAnimation
         {
            id: selected_pb_animation
            target: selected_pb
            property: "width"
            duration: 1000
         }

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

      MouseArea
      {
         enabled: bEnabled
         anchors.left: parent.left
         anchors.right: parent.right
         anchors.verticalCenter: parent.verticalCenter
         height: cursor_image.sourceSize.height
         onClicked: updateProgressBar( mouseX )
         onPositionChanged: updateProgressBar( mouseX )
         function updateProgressBar( mX )
         {
            if ( mX >= 0 && mX <= parent.width )
            {
               selected_pb_animation.duration = 0
               nCurrentTime = ( mX / parent.width * nTotalTime )
               changePlayingPosition()
            }
         }
      }
   }

// Repeat / Random icons
   Image
   {
      anchors.right: bPrBarVisible ? progressBar.right : textCurrentTime.left
      anchors.rightMargin: 10
      anchors.verticalCenter: textMainName.verticalCenter
      source: ( nRepeatStatus == 1 ) ? "/app/share/images/music/icon_play_repeat_all.png" :
              ( nRepeatStatus == 2 ) ? "/app/share/images/music/icon_play_repeat_one.png" :
              ( nRepeatStatus == 3 ) ? "/app/share/images/music/icon_play_repeat_folder.png" :
              ( nRandomStatus == 1 ) ? "/app/share/images/music/icon_play_shuffle_all.png" :
              ( nRandomStatus == 2 ) ? "/app/share/images/music/icon_play_shuffle_folder.png" :
              ""
   }

// Main name
   Text
   {
      id: textMainName
      anchors.top: progressBar.top
      anchors.left: progressBar.left
      text: bPrBarVisible == false ? sName + "  " + sSubName :
            sSubName ? sName + " / " + sSubName : sName
      font.pixelSize: 28
      color: bTuneTextColor ? "#800000" : "#fafafa"
   }

// Files count text
   Text
   {
      text: sFilesCount
      anchors.top: progressBar.top
      anchors.right: bg_pb.right
      color: bTuneTextColor ? "#800000" : "#9e9e9e"
      font.pixelSize: 25
   }

   onBPrBarVisibleChanged:
   {
      if ( bPrBarVisible )
      {
         textCurrentTime.anchors.right = undefined
         textCurrentTime.anchors.verticalCenter = undefined
         textCurrentTime.anchors.left = progressBar.left
         textCurrentTime.anchors.bottom = progressBar.bottom
      }
      else
      {
         textCurrentTime.anchors.left = undefined
         textCurrentTime.anchors.bottom = undefined
         textCurrentTime.anchors.right = progressBar.right
         textCurrentTime.anchors.verticalCenter = textMainName.verticalCenter
      }

      selected_pb_animation.duration = 0
      animateProgressBar()
   }

// Current time
   Text
   {
      id: textCurrentTime
      anchors.left: progressBar.left
      anchors.bottom: progressBar.bottom
      anchors.bottomMargin: bPrBarVisible ? 26 : 20
      font.pixelSize: 25
      color: "#9e9e9e"
      text: convertTime( nCurrentTime )
   }

// Total time
   Text
   {
      id: textTotalTime
      anchors.right: progressBar.right
      anchors.bottom: progressBar.bottom
      anchors.bottomMargin: 26
      font.pixelSize: 25
      color: "#9e9e9e"
      text: convertTime( nTotalTime )
      visible: bPrBarVisible
   }

   function convertTime( t )
   {
      var hour = Math.floor( t / 3600 )
      t = t % 3600
      var min = Math.floor( t / 60 )
      var sec = t % 60
      var str = min + ":" + sec
      str = str.replace( /^(\d):/, "0" + min + ":" )
      str = str.replace( /:(\d)$/, ":0" + sec )
      str = hour + ":" + str
      return str
   }
}
