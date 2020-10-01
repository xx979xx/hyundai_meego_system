import Qt 4.7
import QtQuick 1.0
import "../DHAVN_VP_CONSTANTS.js" as CONST
import AppEngineQMLConstants 1.0

DHAVN_VP_FocusedItem
{
   id: root

   property ListModel menu_model: ListModel{}
   property int selected_item: 0
   property bool isLeftBg: true
   // { modified by ravikanth 22-03-13
   property bool isRightBg: false
   property bool isBottomBg: false
   property bool isTopBg: false
   // } modified by ravikanth 22-03-13
   property alias currentPageLoop : list_view.currentPageLoop //added by Michael.Kim 2013.08.22 for ITS 185733
//added by aettie 20130906
   property bool scrollingTicker: EngineListenerMain.scrollingTicker

   signal selectItem( int item )
   signal itemFocused( int item ) // added by Sergey 19.10.2013 for ITS#196877
   signal focusMoved ( bool isMenuFocused )
   signal signalItemFlicked(int index) // added by yungi 2014.02.03 for ITS 223313

   width: 550 + 30 // modified by ravikanth 13-03-13
   // { modified by junggil 2012.08.29 for NEW UX caption settings
   //height: 720 - 93 -(166 - 93)
   height: 720 - 93 -(166 - 93 + 15)
   // } modified by junggil

   name: "Menu"
   default_x: 0
   default_y: 0
//added by aettie 20130906
    Connections
    {
        target:EngineListenerMain
        onTickerChanged:
        {
            EngineListenerMain.qmlLog("VP_Menu onTickerChanged ticker : " + ticker);
            root.scrollingTicker = ticker;
        }
    }

   Component
   {
      id: item_delegate

      Item
      {
         id: item
         anchors.left: parent.left
         anchors.leftMargin: 43


         function jogSelect(bManualBeep) // modified by cychoi 2013.12.13 for ITS 215607 do beep on click
         {
            if(!is_dimmed)
            {
               root.selected_item = index
               selectItem( index )
               list_view.handleTouchEvent( index, focus_visible, UIListenerEnum.JOG_LEFT ) // added by wspark 2013.04.03 for ISV 78422
			   // removed by Sergey 20.08.2013 for ITS#184640 
               root.moveFocus( (EngineListenerMain.middleEast ? -1 : 1), 0 ) // modified by ravikanth 05-07-13 for ITS 0177377 // modified by Sergey 16.11.2013 for ITS#209528, 209529

               // { modified by cychoi 2013.12.13 for ITS 215607 do beep on click
               if(bManualBeep)
               {
                   EngineListenerMain.ManualBeep(); // commented by cychoi 2013.12.06 for ITS 212885 no beep on jog enter //added by junam 2013.06.08 for add manual beep
               }
               // } modified by cychoi 2013.12.13
            }
         }

         // { added by Sergey 19.10.2013 for ITS#196877
         function jogFocused()
         {
             if(!is_dimmed)
             {
                 root.selected_item = index;
                 root.itemFocused( index );
             }
         }
         // } added by Sergey 19.10.2013 for ITS#196877

         property bool pressed: false
         property bool selected: index == selected_item
//         property bool is_dimmed: isDimmed === true
         property bool is_dimmed: isDimmed == true  //modified by aettie.ji 2012.11.12
         property bool  list_focus_visible:  root.focus_visible

         onList_focus_visibleChanged:
         {
             if( list_focus_visible == false)
             {
                    pressed = false
             }
         }

         height: 89 // modified by cychoi 2014.02.28 for UX & GUI fix
         width: parent.width
         z: selected ? 10 : 0

         Image
         {
            id: line_id

            anchors.left: parent.left
            // { modified by cychoi 2014.02.28 for UX & GUI fix
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -3
            source: "/app/share/images/general/line_menu_list.png"
            visible: (!list_view.focus_visible || ((index != list_view.currentIndex) && (index < list_view.count))) ? true : false
            // } modified by cychoi 2014.02.28
         }


         // { moved by Sergey 19.11.2013 for ITS#209528
         Image
         {
            id: image_f_id
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: -9
            source: "/app/share/images/general/bg_menu_tab_l_f.png"
            visible: ( (index == list_view.currentIndex) && list_view.focus_visible )
         }
         // } moved by Sergey 19.11.2013 for ITS#209528

         Image 
         {
            id: image_p_id

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: -9
            source: "/app/share/images/general/bg_menu_tab_l_p.png"
            visible: (mouse_area.pressed || item.pressed) && !is_dimmed
         }

		// moved by Sergey 19.11.2013 for ITS#209528

         Item
         {
           id: scrolledLabel
           height:parent.height
           //width: isCheckNA  ? 400 : 479 // modified by ravikanth 13-03-13
           anchors.right:isCheckNA  ? image_checkbox.left : parent.right
           anchors.rightMargin:isCheckNA  ? 20 : 0
           anchors.left: parent.left
           anchors.leftMargin: 23 // 42 // modified by cychoi 2013.12.30 for marquee text on DVD Setting
           anchors.bottom: parent.bottom
           anchors.bottomMargin: 43 - text_id.height / 2
           clip: true
	   //added by aettie 20130906
           property bool tickerMove:image_f_id.visible

           DHAVN_VP_MenuMarquee_Text // modified by Sergey 07.10.2013 
           {
                id: text_id

                scrollingTicker: root.scrollingTicker && parent.tickerMove
                text: qsTranslate( "main", QT_TR_NOOP(name) ) + LocTrigger.empty
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin:0
                color: item.is_dimmed ? "#5B5B5B": ( selected ? ((index == list_view.currentIndex)
                        ? CONST.const_FONT_COLOR_BRIGHT_GREY : CONST.const_FONT_COLOR_RGB_BLUE_TEXT)
                        : CONST.const_FONT_COLOR_BRIGHT_GREY )
		     //modified bt aettie.ji 20130925 ux fix
				fontFamily: item.is_dimmed ? CONST.const_FONT_FAMILY_NEW_HDR :( (selected && (index != list_view.currentIndex)) ? CONST.const_FONT_FAMILY_NEW_HDB : CONST.const_FONT_FAMILY_NEW_HDR) // modified by Sergey 16.11.2013 for ITS#209529
                fontSize: 40 
                width: isCheckNA ? 435 : 479 // parent.width // modified by cychoi 2013.12.30 for marquee text on DVD Setting
           }
         }

         Image
         {
            id: image_checkbox
            anchors.verticalCenter:parent.verticalCenter
            anchors.left:parent.left
            anchors.leftMargin:479
            anchors.rightMargin: 12
            source: (isChekedState) ? "/app/share/images/general/checkbox_check.png" : "/app/share/images/general/checkbox_uncheck.png"
            visible: isCheckNA
         }


         MouseArea
         {
            id: mouse_area

            anchors.fill: parent

            beepEnabled: false

            onClicked:
            {
                item.jogSelect(true) // modified by cychoi 2013.12.13 for ITS 215607 do beep on click
				// removed by Sergey 20.08.2013 for ITS#184640 
            }
         }
      }
   }
//  removed by raviaknth 15-03-13

   onFocus_visibleChanged:
   {
       isLeftBg = focus_visible
       focusMoved(focus_visible)
   }

   DHAVN_VP_FocusedList
   {
      id: list_view

      width: parent.width

      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.topMargin: 11// or 9
      anchors.bottomMargin: 11// or 9
      cacheBuffer: 10000
      clip:true

      model: menu_model
      delegate: item_delegate
//      highlight: item_highlight // modified by raviaknth 15-03-13
      defaultFocusIndex: root.selected_item // modified by Sergey 20.08.2013 for ITS#184640 
	  // removed by Sergey 20.08.2013 for ITS#184640 

      name: "MenuList"
      focus_x: 0
      focus_y: 0


	 // { added by Sergey 19.10.2013 for ITS#196877
      onFocusElement:
      {
          list_view.currentItem.jogFocused();
      }
      // } added by Sergey 19.10.2013 for ITS#196877

      // modified by Dmitry 15.05.13
      onJogSelected:
      {
         EngineListenerMain.qmlLog("onJogSelected")
         switch ( status )
         {
            case UIListenerEnum.KEY_STATUS_PRESSED:
            {
               EngineListenerMain.qmlLog("UIListenerEnum.KEY_STATUS_PRESSED")
               list_view.currentItem.pressed = true
            }
            break

            case UIListenerEnum.KEY_STATUS_RELEASED:
            {
               EngineListenerMain.qmlLog("UIListenerEnum.KEY_STATUS_RELEASED")
               list_view.currentItem.pressed = false
               list_view.currentItem.jogSelect(false) // modified by cychoi 2013.12.13 for ITS 215607 do beep on click
               root.moveFocus( (EngineListenerMain.middleEast ? -1 : 1), 0 ) // modified by Sergey 16.11.2013 for ITS#209528, 209529
            }
            break
         }
      }

      onIndexFlickSelected: signalItemFlicked(index) // added by yungi 2014.02.03 for ITS 223313
   }
// modified by Dmitry 15.05.13

   Image
      {
         y: 32
         x: 588
         source: "/app/share/images/general/scroll_menu_bg.png"
         //visible: true //( list_view.count > 6 )
         visible: list_view.count > 6 ? true : false    //modified by aettie.ji 2012.11.12 for New UX

         Item
         {
            height: list_view.visibleArea.heightRatio * 478
            y: 478 * list_view.visibleArea.yPosition
            Image
            {
               y: -parent.y
               source: "/app/share/images/general/scroll_menu.png"
            }
            width: parent.width
            clip: true
         }
      }

	// removed by Sergey 16.05.2013

   Component.onCompleted:
   {
      list_view.currentIndex = -1
   }
}
