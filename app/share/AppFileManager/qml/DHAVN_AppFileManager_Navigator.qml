import QtQuick 1.1 // modified by Dmitry 03.05.13
import QmlBottomAreaWidget 1.0
import com.filemanager.uicontrol 1.0

import "DHAVN_AppFileManager_General.js" as FM
import "DHAVN_AppFileManager_Resources.js" as RES

DHAVN_AppFileManager_FocusedItemNew
{
   id: root
   node_id: 4
   height: FM.const_APP_FILE_MANAGER_NAVIGATOR_HEIGHT
   width: FM.const_APP_FILE_MANAGER_SCREEN_WIDTH

   property bool focus_pressed: false
 //added by aettie.ji 2013.09.04 JAT_ITS_188339
   property bool scrollingTicker: EngineListener.scrollingTicker


   function itemSelected()
   {
       // {added by Michael.Kim 2014.02.26 for focus lost issue
       if (mainScreen.focus_default == 4 && mainScreen.currentLoaderCount == 0)
           mainScreen.focus_default = 2
       // }added by Michael.Kim 2014.02.26 for focus lost issue
       if(!StateManager.ShouldChangePath()) // modified by ravikanth 01-09-13 for ITS 0186509
           UIControl.modeAreaEventHandler(UIDef.MODE_AREA_EVENT_BACK_PRESSED)
   }

   onJogPressed:
   {
       focus_pressed = true;
   }

   onJogSelected:
   {
       focus_pressed = false;
       root.itemSelected()
   }
// added by Dmitry 16.08.13 for ITS0184683
   onJogCancelled:
   {
      focus_pressed = false;
   }

   Image
   {
      id: bg_navi
      anchors.fill:parent
      mirror: EngineListener.middleEast // added by Dmitry 25.08.13
      source: RES.const_BG_FOLDER_NAVIGATION_N 
      visible: !naviPressed.visible && !naviFocused.visible
   }
   Image
   {
      id: naviPressed
      anchors.fill:parent
      mirror: EngineListener.middleEast // added by Dmitry 25.08.13
      source: RES.const_BG_FOLDER_NAVIGATION_P
      visible: mouse_area.pressed || (focus_pressed&&root.focus_visible)
   }
   Image
   {
       id: naviFocused
       anchors.fill:parent
       mirror: EngineListener.middleEast // added by Dmitry 25.08.13
       source: RES.const_BG_FOLDER_NAVIGATION_F 
       visible: root.focus_visible && !(mouse_area.pressed || focus_pressed) 
   }

   Image
   {
      id: ico_folder
      LayoutMirroring.enabled: EngineListener.middleEast 
      anchors.top:parent.top
      anchors.topMargin: FM.const_APP_FILE_MANAGER_NAVIGATOR_ICO_FOLDER_TOP_MARGIN
      anchors.left:parent.left
      anchors.leftMargin: FM.const_APP_FILE_MANAGER_NAVIGATOR_ICO_FOLDER_LEFT_MARGIN
 
      source: "/app/share/images/photo/ico_folder.png"
   }
 
   //modified by aettie.ji 2013.09.04 JAT_ITS_188339

   
     DHAVN_AppFileManager_VideoList_MarqueeText
     {
        id: path_text
        scrollingTicker: root.scrollingTicker && naviFocused.visible

          anchors.top: parent.top
          anchors.left: parent.left
          anchors.topMargin: FM.const_APP_FILE_MANAGER_NAVIGATOR_TEXT_TOP_MARGIN - height/2
          anchors.leftMargin: FM.const_APP_FILE_MANAGER_NAVIGATOR_TEXT_LEFT_MARGIN
        
        text: TitleProvider.titleText 
        
        color: FM.const_APP_FILE_MANAGER__COLOR_BRIGHT_GREY
        
        fontSize:  FM.const_APP_FILE_MANAGER__PIXEL_SIZE_30
        fontFamily:  FM.const_APP_FILE_MANAGER_FONT_NEW_HDR 
        
        width: FM.const_APP_FILE_MANAGER_NAVIGATOR_WIDTH 

        LayoutMirroring.enabled: EngineListener.middleEast
        LayoutMirroring.childrenInherit: true
        //added by nhj 2013.10.07 middleeast
     }
   MouseArea
   {
      id: mouse_area
      anchors.fill: parent
      beepEnabled: false //added by Michael.Kim 2014.07.09 for 242612
      onClicked:
      {
         UIListener.ManualBeep(); //added by Michael.Kim 2014.07.09 for 242612
         root.itemSelected()
      }
   }
    //added by aettie.ji 2013.09.04 JAT_ITS_188339
    Connections
    {
        target:EngineListener
        onTickerChanged:
        {
            EngineListener.qmlLog("onTickerChanged ticker(fileManager option) : " + ticker);
            root.scrollingTicker = ticker;
        }
    }

}
