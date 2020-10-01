import QtQuick 1.0
import "DHAVN_AppFileManager_General.js" as HM
import "DHAVN_AppFileManager_Resources.js" as RES

Item
{
   id: pictureWidget

   /** Name of Folder */
   property string sNameFolder: "Download"

   /** Number of Picture in the Folder */
   property int iNumberPicture: 5

// modified by Dmitry 23.08.13
   /** Is it folder */
   property bool isFolder: true

   /** true - number of pictures more than 1, false -folder is empty or there is a 1 picture */
   property bool __picture_single: (pictureWidget.iNumberPicture <= 1) ? true : false

   property bool focus_visible: false //Added by Alexey Edelev 2012.10.15

   property alias thumbnailStatus: foto_pictureWidget.status//Added by Alexey Edelev 2012.10.25 Fix thumbnails issue
   property alias scrollingTicker: nameFolder.scrollingTicker	//added 20130621 for [KOR][ISV][83967][C] (aettie.ji)

   property int reloadCount: 0 // added by Dmitry 22.10.13 for ITS0195983

   /** Signal sent true when folder selected, Signal sent false when folder no selected */
   signal folderSelect()

   /** Signal sent true when file selected*/
   signal fileSelect()
   signal setTouchFocus() //added by aettie 2013.03.26 for Touch Focus rule
   function itemSelected()
   {
// removed by Dmitry 18.08.13 for ITS0184900
       if ( isFolder )
       {
           pictureWidget.folderSelect()
       }
       else
       {
	// modified by ravikanth 27-04-13
           pictureWidget.fileSelect()
       }
   }

   function itemLongPressed(isHWKeyPressed)
   {
       //Dummy handler
   }

   width: HM.const_PICTURE_WIDGET_ITEM_WIDTH
   height: HM.const_PICTURE_WIDGET_ITEM_HIGHT

   MouseArea
   {
      anchors.fill: parent

      onClicked:
      {
         setTouchFocus() // added by Dmitry 11.09.13 for ITS0183775
         pictureWidget.itemSelected()
      }
   }

   /** background */
   Image
   {
      id: background_pictureWidget
      anchors.top: parent.top
      anchors.left: parent.left
      // modified by Dmitry 12.10.13 for ITS0194846
      // next time please check folder behavior with unsupported images before modifiying this
      source: (!isFolder) ? (itemSupported ? RES.const_APP_FILE_MANAGER_PHOTO_BG_PHOTO_N : RES.const_APP_FILE_MANAGER_PHOTO_UNSUPPORTED_ICON)
                          : (itemSupported ? RES.const_APP_FILE_MANAGER_PHOTO_BG_FOLDER_N : RES.const_APP_FILE_MANAGER_PHOTO_UNSUPPORTED_FODLER)
   }


   Rectangle
   {
      anchors.fill: foto_pictureWidget
      color:"white"
      visible:(!__picture_cover_absent)
   }

   /** picture */
   Image
   {
      id: foto_pictureWidget
      anchors.top: background_pictureWidget.top
      anchors.topMargin: HM.const_PICTURE_WIDGET_COVER_MARGIN
      anchors.left: background_pictureWidget.left
      anchors.leftMargin: HM.const_PICTURE_WIDGET_COVER_MARGIN
      width: HM.const_PICTURE_WIDGET_COVER_WIDTH
      height: isFolder ? HM.const_PICTURE_WIDGET_COVER_FOLDER_HIGHT : HM.const_PICTURE_WIDGET_COVER_PHOTO_HIGHT
      fillMode: Image.Stretch // modified by eugene 2012.12.12 for New UX Photo #5-1
      visible: ( pictureWidget.__picture_cover_absent ) ? false : true
      // modified by Dmitry 12.10.13 for ITS0194846
      // next time please check folder behavior with unsupported images before modifiying this
      visible: itemSupported // modified by Dmitry 16.10.13 for ITS0194836
      source: itemThumbPicture1

// added by Dmitry 22.10.13 for ITS0195983
      onStatusChanged:
      {
         if (status == Image.Error)
         {
            if (reloadCount < 3)
            {
               source = ""
               reloadTimer.start()
            }
            else
            {
               reloadCount = 0
            }
         }
      }
   }

// modified by Dmitry 23.08.13

   /** name of Folder */
   Item
   {
     id: folder_name
     anchors.top: background_pictureWidget.top
     anchors.left: background_pictureWidget.left
     anchors.topMargin: HM.const_PICTURE_WIDGET_NAME_FOLDER_TOP_MARGIN - nameFolder.height / 2
     anchors.leftMargin: HM.const_PICTURE_WIDGET_NAME_FOLDER_LEFT_MARGIN

     width: HM.const_PICTURE_WIDGET_NAME_FOLDER_WIDTH
     height:nameFolder.paintedHeight
     clip: nameFolder.paintedWidth > width
     visible: isFolder
//modified 20130621 for [KOR][ISV][83967][C] (aettie.ji)
     DHAVN_AppFileManager_MarqueeText
     {
        id: nameFolder
//        property int textLength : StateManager.getStringWidth(text,HM.const_APP_FILE_MANAGER_FONT_HDB, HM.const_APP_FILE_MANAGER_PIXEL_SIZE_22);
        property int textLength : StateManager.getStringWidth(text,HM.const_APP_FILE_MANAGER_FONT_NEW_HDB, HM.const_APP_FILE_MANAGER_PIXEL_SIZE_22);

        scrollingTicker: pictureWidget.scrollingTicker 
        anchors.left: parent.left
        anchors.leftMargin: (parent.width > textLength)?  (parent.width - textLength)/2 : 5
        text: pictureWidget.sNameFolder + "(" +pictureWidget.iNumberPicture + ")"
        color: HM.const_APP_FILE_MANAGER_COLOR_BUTTON_GREY
        font.pointSize:  HM.const_APP_FILE_MANAGER_PIXEL_SIZE_22
       // font.family:  HM.const_APP_FILE_MANAGER_FONT_HDB
        font.family:  HM.const_APP_FILE_MANAGER_FONT_NEW_HDB
        
        width: parent.width - 10
     }
   }
   //{Added by Alexey Edelev 2012.10.15
   Image
   {
       id: focus_pictureWidget
       width: HM.const_APP_FILE_MANAGER_PICTURE_FILE_MANAGER_FOCUS_WIDTH
       height: HM.const_APP_FILE_MANAGER_PICTURE_FILE_MANAGER_FOCUS_HIGHT
       source: (pictureWidget.isFolder) ? RES.const_APP_FILE_MANAGER_PHOTO_BG_FOLDER_F
                                               : RES.const_APP_FILE_MANAGER_PHOTO_BG_PHOTO_F
       visible: pictureWidget.focus_visible
   }
   //}Added by Alexey Edelev 2012.10.15

// added by Dmitry 22.10.13 for ITS0195983
   Timer
   {
      id: reloadTimer
      running: false
      interval: 1000
      repeat: false

      onTriggered:
      {
         foto_pictureWidget.source = function() { return itemThumbPicture1 }
         reloadCount++
      }
   }
}
