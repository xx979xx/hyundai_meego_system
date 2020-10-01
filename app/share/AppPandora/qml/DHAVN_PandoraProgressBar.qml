
import Qt 4.7

Item
{
   id: progressBar
   width: 1280

   property bool bCursorVisible: false

   /** Minimal value is always 0 */
   property int nCurrentTime: 0
   property int nTotalTime: 0

/** ============================================================= */
/** ===================== Private area ========================== */
/** ============================================================= */

   property int n_cur_time: 0
   height: 98

   Component.onCompleted:
   {
      animateProgressBar(nCurrentTime)
   }


   onNCurrentTimeChanged:
   {
       animateProgressBar(nCurrentTime)
   }

   function animateProgressBar(pos)
   {
       if ( pos < 0 )
       {
           n_cur_time = 0
           return
       }

       if ( pos <= nTotalTime )
       {
           selected_pb.width = bCursorVisible * ( cursor_image.sourceSize.width / 4 )
           if ( nTotalTime )
           {
              selected_pb.width += ( pos / nTotalTime ) * ( bg_pb.width - bCursorVisible * cursor_image.sourceSize.width / 2 )
           }
       }

       n_cur_time = nCurrentTime
   }

// Background image of progress bar
   Image
   {
      id: bg_pb
      anchors.left: textCurrentTime.right
      anchors.leftMargin: 5
      anchors.right: textTotalTime.left
      anchors.rightMargin: 10
      anchors.verticalCenter: parent.verticalCenter
      fillMode: Image.TileHorizontally
      source: "/app/share/images/music/pgbar_bg_n.png"

      onWidthChanged:
      {
         animateProgressBar(nCurrentTime)
      }
// Selected image of progress bar
      Image
      {
         id: selected_pb
         visible: true
         anchors.left: parent.left
         anchors.verticalCenter: parent.verticalCenter
         fillMode: Image.TileHorizontally
         source: "/app/share/images/music/pgbar_bg_s.png"


// Cursor image on progress bar
         Image
         {
            anchors.right: cursor_image.horizontalCenter
            anchors.verticalCenter: cursor_image.verticalCenter
            source: bCursorVisible ? "/app/share/images/music/pgbar_pointer.png" : ""
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
   }


// Current time
    Text
   {
      id: textCurrentTime
      anchors.left: parent.left
      anchors.leftMargin: 70 //21 modified by wonseok.heo for ITS 268670
      anchors.verticalCenter: bg_pb.verticalCenter
      font.family : "NewHDB"
      font.pixelSize: 32
      width: text.length < 6 ? 103 : 150
      color: "#FAFAFA"
      text: convertTime( nCurrentTime )
   }

// Total time
   Text
   {
      id: textTotalTime
      anchors.right: parent.right
      anchors.rightMargin: 70 //10 modified by wonseok.heo for ITS 268670
      anchors.verticalCenter: bg_pb.verticalCenter
      font.family : "NewHDB"
      font.pixelSize: 32
      color: "#FAFAFA"
      text: convertTime( nTotalTime )
   }

   function convertTime( ms )
   {
      var t = ms//Math.floor( ms / 1000 )
      var mm = Math.floor( t / 60 )
      var hh = 0
      var str
      var ss = t % 60
      if (mm > 59)
      {
         hh = Math.floor(mm / 60)
         mm = mm - hh * 60
         if (hh < 10) {hh = hh} // modified by wonseok.heo for 271460
         if (mm < 10) {mm = '0' + mm}
         if (ss < 10) {ss = '0' + ss}
         str = hh + ':' + mm + ':' + ss
      }
      else
      {
         if (mm < 10) {mm = mm} // modified by wonseok.heo for 271460
         if (ss < 10) {ss = '0' + ss}

         str = mm + ':' + ss
      }

      return str;
   }
}
