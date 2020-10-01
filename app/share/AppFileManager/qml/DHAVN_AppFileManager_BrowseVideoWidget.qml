import QtQuick 1.0

import "DHAVN_AppFileManager_Resources.js" as RES
import "DHAVN_AppFileManager_General.js" as FM

Item
{
   id: root

   /** Name of File */
   property string name: ""

   /** Is file selected? */
   property bool selected: false

   /** Is file played?*/
   property bool played: false

   /** Is it folder */
   property bool isFolder: true

   /** Item pressed */
   property bool focus_pressed: false

   property bool focus_visible: true // modified by Dmitry 20.07.13
   //modified bt aettie.ji 20130925 ux fix
   property alias scrollingTicker: widget_text.scrollingTicker//Added by Alexey Edelev 2012.10.06 fix text scrolling

   property bool item_focused : false; //added by aettie for focused text color 20131002

   /** Signal sent true when folder selected, Signal sent false when folder no selected */
   signal folderSelect()

   signal fileSelect()
   signal setTouchFocus() //added by aettie 2013.03.26 for Touch Focus rule

   function itemSelected()
   {
      setTouchFocus(); //added by aettie 2013.03.26 for Touch Focus rule
      if( isFolder )
      {
         folderSelect()
      }
      else
      {
         fileSelect()
      }
      focus_pressed = false;  
   }
// modified by Dmitry 16.08.13 for ITS0184683
   function itemPressed(status)
   {
      focus_pressed = status;
   }
   width: parent.width
   height:  FM.const_APP_FILE_MANAGER_VIDEOWIDGET_HEIGHT // modified by Dmitry 02.08.13
   //moved for List Focus Image 20131029
   Image
   {
      id: lineList
      y:110
      anchors.left:parent.left
      source: !UIControl.editButton ? RES.const_APP_FILE_MANAGER_VIDEOWIDGET_EDIT_LIST_LINE_URL
                                    : RES.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_LINE_URL
   }
// modified by Dmitry 20.07.13
   Image
   {
      id: itemPressed
      anchors.left: parent.left
      //added for List Focus Image 20131029
      anchors.top: lineList.top
      anchors.topMargin: -111
      anchors.leftMargin: !UIControl.editButton ? FM.const_APP_FILE_MANAGER_VIDEOWIDGET_EDIT_LIST_LEFT_MARGIN
                                                : FM.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_LEFT_MARGIN
      source: !UIControl.editButton ? RES.const_APP_FILE_MANAGER_VIDEOWIDGET_EDIT_LIST_02_P_URL
                                       : RES.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_VIDEO_P_URL //modified by aettie 2013.03.05 for New UX
      visible: focus_pressed && focus_visible
   }
// modified by Dmitry 20.07.13

// modified by Dmitry 26.07.13
   Image
   {
      id: thumbnail_image
      anchors.left: parent.left
      anchors.leftMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_FRAME_LEFT_MARGIN
      anchors.top: parent.top
      anchors.topMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_FRAME_TOP_MARGIN
      source: isFolder ? RES.const_APP_FILE_MANAGER_VIDEOWIDGET_ICO_LIST_FOLDER_URL :
                         itemThumbPicture1 == "" ? RES.const_APP_FILE_MANAGER_VIDEOWIDGET_BG_USB_VIDEO_URL : itemThumbPicture1 // modified by Dmitry 22.08.13
      height: 87
      width: 154
   }
// modified by Dmitry 25.07.13

   AnimatedImage  //modified by lyg 2012.08.23  UX Video(Teleca) #18
   {
      id: icon_play

      visible: !isFolder
      playing: EngineListener.videoPlaying // modified by Dmitry 12.07.13 for ISV85006
      anchors { left: thumbnail_image.left; top: thumbnail_image.top }
      anchors.leftMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_ICON_PLAY_LEFT_MARGIN
      anchors.topMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_ICON_PLAY_TOP_MARGIN
      source: played ? RES.const_APP_FILE_MANAGER_VIDEOWIDGET_ICON_PLAY_URL  //modified by lyg 2012.08.23 UX Video(Teleca) #18
                     : RES.const_APP_FILE_MANAGER_VIDEOWIDGET_ICO_VIDEO_URL
   }

   Item
   {
     id: scrolledLabel

     anchors.left: thumbnail_image.left
     anchors.top: thumbnail_image.top
     anchors.leftMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_TEXT_LEFT_MARGIN
     anchors.topMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_TEXT_TOP_MARGIN - widget_text.height/2
     width: !UIControl.editButton ? FM.const_APP_FILE_MANAGER_VIDEOWIDGET_TEXT_EDIT_WIDTH
                                  : FM.const_APP_FILE_MANAGER_VIDEOWIDGET_TEXT_WIDTH
     height:widget_text.paintedHeight
     clip: widget_text.paintedWidth > width
   //modified bt aettie.ji 20130925 ux fix

     DHAVN_AppFileManager_VideoList_MarqueeText
     {
        id: widget_text
        anchors.left: parent.left
        anchors.top: parent.top
        text: root.name 
//modified by aettie for focused text color 20131002
        color: (played && !item_focused)? FM.const_APP_FILE_MANAGER__COLOR_BLUE
                     : FM.const_APP_FILE_MANAGER__COLOR_BRIGHT_GREY
//        font.family: FM.const_APP_FILE_MANAGER_FONT_HDR 

        fontFamily: played? FM.const_APP_FILE_MANAGER_FONT_NEW_HDB :
                                  FM.const_APP_FILE_MANAGER_FONT_NEW_HDR
        fontSize: FM.const_APP_FILE_MANAGER_PIXEL_SIZE_40
        //scrollingTicker: scrollingTicker
        width: parent.width
     }
   }
// modified by Dmitry 26.07.13
//moved for List Focus Image 20131029
   MouseArea
   {
      id: mouse_area
      anchors.fill: parent
      onClicked:
      {
         root.itemSelected()
      }

// added by Dmitry 20.07.13
      onPressed: focus_pressed = true
      onReleased: focus_pressed = false
      onCanceled: focus_pressed = false
// added by Dmitry 20.07.13
   }
}
