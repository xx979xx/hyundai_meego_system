import QtQuick 1.1//Changed by Alexey Edelev 2012.10.15
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

   /** true - folder selected, false - folder no selected */
   property bool selected: false

   /** true - check box is visible, false - check box is invisible */
   property bool checkVisible: true

   /** true - number of pictures more than 1, false -folder is empty or there is a 1 picture */
   property bool __picture_single: (pictureWidget.iNumberPicture <= 1) ? true : false

   property bool focus_visible: false//Added by Alexey Edelev 2012.10.15
   property bool fileSelected: false // added by Michael.Kim 2014.11.14 for ITS 252495

   property alias thumbnailStatus: foto_pictureWidget.status//Added by Alexey Edelev 2012.10.25 Fix thumbnails issue
   //added 20130621 for [KOR][ISV][83967][C] (aettie.ji)
   property alias scrollingTicker: nameFolder.scrollingTicker

   property int reloadCount: 0 // added by Dmitry 22.10.13 for ITS0195983

   property bool mirrorLayout: false // modified for ITS 0210303
   function checked()
   {
       if(checkbox_pictureWidget.visible) // modified by ravikanth 27-04-13
           pictureWidget.valueChanged( !pictureWidget.selected );
   }

   function itemSelected()
   {
       if (checkVisible)
       {
           pictureWidget.checked()
       }
       else
       {
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
   }

   function itemLongPressed(isHWKeyPressed)
   {
      // commented by ravikanth 03-09-13 logpress functionality removal
      // { modified by ravikanth 08-04-13
      // { removed by eunhye 2013.03.22 for No CR
      /*if(!checkVisible && itemSupported)
      {
         if(isHWKeyPressed) {
             UIListener.ManualBeep();
         }

         if ( isFolder )
         {
             folderOperation()
         }
         else
         {
             fileOperation()
         }
      }*/
      // } removed by eunhye 2013.03.22 for No CR
      // } modified by ravikanth 08-04-13
   }

   /** Signal sent true when checkbox is marked. Signal sent false when checkbox is no marked */
   signal valueChanged( bool value);

   /** Signal sent true when folder selected, Signal sent false when folder no selected */
   signal folderSelect()

   /** Signal sent true when file selected*/
   signal fileSelect()

   signal folderOperation()

   signal fileOperation()

   signal setTouchFocus() //added by aettie 2013.03.26 for Touch Focus rule
   width: HM.const_PICTURE_WIDGET_ITEM_WIDTH
   height: HM.const_PICTURE_WIDGET_ITEM_HIGHT

   MouseArea
   {
      id: widget_mouse_area
      anchors.fill: parent
      beepEnabled: false
      enabled: !lockoutRect.visible //added for DHPE IMAGE DRS 2015.03.26

        onClicked:
        {
            // { modified by ravikanth 27-04-13
            if(!pictureWidget.fileSelected) { // modified by Michael.Kim 2014.11.14 for ITS 252495
                setTouchFocus() //added by aettie 2013.03.26 for Touch Focus rule
                EngineListener.MBeep()
                if(!checkVisible)
                {
                    if ( isFolder )
                    {
                        pictureWidget.folderSelect()
                    }
                    else
                    {
                        pictureWidget.fileSelect()
                    }
                }
                else
                {
                    if(checkbox_pictureWidget.visible)
                    {
                        pictureWidget.valueChanged( !pictureWidget.selected );
                        UIControl.setModeAreaCount("("+ gridView.model.getFileURLCount() +")"); //added by yungi 2013.03.08 for New UX FileCount
                    }
                }
                // } modified by ravikanth 27-04-13
            }
        }

        onPressAndHold:{
            if(!pictureWidget.fileSelected) { // modified by Michael.Kim 2014.11.14 for ITS 252495
                setTouchFocus();
                itemLongPressed();
            }
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

   /** checkbox */
   Image
   {
       id: checkbox_pictureWidget
       anchors.top: background_pictureWidget.top
       anchors.left: background_pictureWidget.left
       anchors.topMargin: HM.const_PICTURE_WIDGET_CHECKBOX_TOP_MARGIN
       anchors.leftMargin: mirrorLayout ? HM.const_PICTURE_WIDGET_CHECKBOX_LEFT_MARGIN_MIDDLE_EAST : HM.const_PICTURE_WIDGET_CHECKBOX_LEFT_MARGIN // modified for ITS 0210303
       source: ( selected || UIControl.selectAllEnabled ) ? RES.const_APP_FILE_MANAGER_PHOTO_CHECKBOX_CHECK
                        : RES.const_APP_FILE_MANAGER_PHOTO_CHECKBOX_UNCHECK
       visible: ( !itemSupported && !isFolder) ? false : checkVisible  // modified by ravikanth 27-04-13

       MouseArea
       {
         anchors.fill: parent
         onClicked:
         {
            pictureWidget.valueChanged( !pictureWidget.selected );
            UIControl.setModeAreaCount("("+ gridView.model.getFileURLCount() +")"); // modified by ravikanth 04-04-13 ITS 160984
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
 //modified by aettie.ji 2013.09.04 JAT_ITS_188339
     DHAVN_AppFileManager_VideoList_MarqueeText
     {
        id: nameFolder
        property int textLength : StateManager.getStringWidth(text,HM.const_APP_FILE_MANAGER_FONT_NEW_HDB, HM.const_APP_FILE_MANAGER_PIXEL_SIZE_22);
        scrollingTicker: pictureWidget.scrollingTicker 

        anchors.left: parent.left
        anchors.leftMargin: (parent.width > textLength)?  (parent.width - textLength)/2 : 5
        text: pictureWidget.sNameFolder + "(" +pictureWidget.iNumberPicture + ")"
        color: HM.const_APP_FILE_MANAGER_COLOR_BUTTON_GREY
        fontSize:  HM.const_APP_FILE_MANAGER_PIXEL_SIZE_22
        fontFamily:  HM.const_APP_FILE_MANAGER_FONT_NEW_HDB
        
        width: parent.width - 10
     }
     /*
     //Text
    // {
     //   id: nameFolder
      //  anchors.centerIn: parent
       // text: pictureWidget.sNameFolder + "(" +
        //      +pictureWidget.iNumberPicture + ")"
       // color: HM.const_APP_FILE_MANAGER_COLOR_BUTTON_GREY
        // { modified by edo.lee 2012.11.29 New UX
        //font.pixelSize:  HM.const_APP_FILE_MANAGER_PIXEL_SIZE_22
      //  font.pointSize:  HM.const_APP_FILE_MANAGER_PIXEL_SIZE_22
        // } modified by edo.lee
      //  font.family:  HM.const_APP_FILE_MANAGER_FONT_HDB
     //}*/
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
