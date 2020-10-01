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

   /** true - check box is visible, false - check box is invisible */
   property bool checkVisible: true

   /** Is it folder */
   property bool isFolder: true

   /** Item pressed */
   property bool focus_pressed: false

   property alias scrollingTicker: widget_text.scrollingTicker//Added by Alexey Edelev 2012.10.06 fix text scrolling

   property bool focus_visible: true // modified by Dmitry 20.07.13

   property bool item_focused : false; //added by aettie for focused text color 20131002

//{Commented by Alexey Edelev 2012.10.08
//   // { added by junggil 2012.10.04 for CR13505 Media Apps - delta UIS 2.15 to 2.17  
//   /** Is it focused list */
//   property bool isFocusedList: false
//
//   /** Focused index of list */
//   property int focusedListIndex: 0
//   // } added by junggil
//}Commented by Alexey Edelev 2012.10.08

   function checked()
   {
        valueChanged(!root.selected)
   }

   function itemSelected()
   {
      if (!checkVisible)
      {
         if( isFolder )
         {
            folderSelect()
         }
         else
         {
            fileSelect()
         }
      }
      else  root.checked()

      focus_pressed = false; //added 20130621 for [KOR][ISV][85816][B] (aettie.ji)
   }
// modified by Dmitry 16.08.13 for ITS0184683
   function itemPressed(status)
   {
      focus_pressed = status;
   }
   
   /** Signal sent true when folder selected, Signal sent false when folder no selected */
   signal valueChanged( bool value);

   signal folderSelect()

   signal fileSelect()

   signal folderOperation()

   signal fileOperation()

   signal setTouchFocus() 
   width: parent.width
   height: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_HEIGHT // modified by Dmitry 02.08.13
   //moved for List Focus Image 20131029
   Image
   {
      id: lineList
      y: 110 
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
                                    : RES.const_APP_FILE_MANAGER_VIDEOWIDGET_LIST_VIDEO_P_URL
      visible: focus_pressed 
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

   AnimatedImage  //modified by lyg 2012.08.23  UX Video(Teleca) #18
   {
      id: icon_play
//{ added by yongkyun.lee 20130204 for : ISV 70321
      //visible:  !icon_play1.visible // modified by ravikanth 11-04-13
      visible: true //20131115 GUI fix
//} added by yongkyun.lee 20130204 
      playing: EngineListener.videoPlaying // modified by Dmitry 12.07.13 for ISV85006
      anchors { left: thumbnail_image.left; top: thumbnail_image.top }
      anchors.leftMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_ICON_PLAY_LEFT_MARGIN
      anchors.topMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_ICON_PLAY_TOP_MARGIN
      source: played? RES.const_APP_FILE_MANAGER_VIDEOWIDGET_ICON_PLAY_URL : "" //20131115 GUI fix //modified by lyg 2012.09.07 CR 11850
   }
/*
//{added by lyg 2012.09.07 CR 11850
   Image  
   {
          id: icon_play1
//{ added by yongkyun.lee 20130204 for : ISV 70321
          //visible: !isFolder && !played           
          visible: !played  || check_item.visible // modified by ravikanth 11-04-13
//} added by yongkyun.lee 20130204 
          anchors { left: thumbnail_image.left; top: thumbnail_image.top }
          anchors.leftMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_ICON_PLAY_LEFT_MARGIN
          anchors.topMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_ICON_PLAY_TOP_MARGIN
          source: RES.const_APP_FILE_MANAGER_VIDEOWIDGET_ICO_VIDEO_URL
   }
//}added by lyg 2012.09.07 CR 11850
*/
   Item
   {
     id: scrolledLabel

     anchors.left: thumbnail_image.left
     anchors.top: thumbnail_image.top
     anchors.leftMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_TEXT_LEFT_MARGIN
     anchors.topMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_TEXT_TOP_MARGIN - widget_text.height/2
     width: !UIControl.editButton  ?  FM.const_APP_FILE_MANAGER_VIDEOWIDGET_TEXT_EDIT_WIDTH
                                                     :  FM.const_APP_FILE_MANAGER_VIDEOWIDGET_TEXT_WIDTH

     height:widget_text.paintedHeight
     clip: widget_text.paintedWidth > width

     DHAVN_AppFileManager_VideoList_MarqueeText
     {
        id: widget_text
        anchors.left: parent.left
        anchors.top: parent.top
        text: root.name 
	//added by aettie for focused text color 20131002
        color: (played && !item_focused) ? FM.const_APP_FILE_MANAGER__COLOR_BLUE
	                                 : FM.const_APP_FILE_MANAGER__COLOR_BRIGHT_GREY
//        font.family: FM.const_APP_FILE_MANAGER_FONT_HDR 
   //modified bt aettie.ji 20130925 ux fix
        fontFamily: played? FM.const_APP_FILE_MANAGER_FONT_NEW_HDB :
                                  FM.const_APP_FILE_MANAGER_FONT_NEW_HDR
        fontSize: FM.const_APP_FILE_MANAGER_PIXEL_SIZE_40
        //scrollingTicker: scrollingTicker
        width: parent.width
     }
   }
// modified by Dmitry 26.07.13

   MouseArea
   {
      id: mouse_area
      anchors.fill: parent
      beepEnabled: false
      onClicked:
      {
         if(EngineListener.videoPlayRequested()) // added by cychoi 2015.07.09 for ITS 265832
            return;
         setTouchFocus();
         EngineListener.MBeep()
         if (!checkVisible)
         {
            if( isFolder )
            {
               folderSelect()
            }
            else
            {
               fileSelect()
            }
         }
         else
         {
            valueChanged(!root.selected)
            UIControl.setModeAreaCount("("+ listView.model.getFileURLCount() +")"); //added by yungi 2013.03.08 for New UX FileCount
         }
      }

// added by Dmitry 20.07.13
      onPressed: 
      {
         if(EngineListener.videoPlayRequested()) // added by cychoi 2015.07.09 for ITS 265832
            return;
         focus_pressed = true
      }
      onReleased: focus_pressed = false
      onCanceled: focus_pressed = false
// added by Dmitry 20.07.13
   }

   Image
   {
      id: check_item

      anchors { left: parent.left; top: parent.top }
      anchors.leftMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_CHECK_LEFT_MARGIN
      anchors.topMargin: FM.const_APP_FILE_MANAGER_VIDEOWIDGET_CHECK_TOP_MARGIN

      width: sourceSize.width
      height: sourceSize.height
      
      // modified by ravikanth on 13-09-13 for ITS 0188110
      source: ( selected || UIControl.selectAllEnabled ) ? RES.const_APP_FILE_MANAGER_VIDEOWIDGET_CHECKBOX_CHECK_URL :
                 RES.const_APP_FILE_MANAGER_VIDEOWIDGET_CHECKBOX_UNCHECK_URL
      visible: checkVisible
   }
//moved for List Focus Image 20131029
}
