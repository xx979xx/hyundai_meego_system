import Qt 4.7

import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Import.js" as TYPES
import QmlPopUpPlugin 1.0
import Qt.labs.gestures 2.0

Loader
{
   id: system_popup
   signal closePopUp()
   signal popup_Response( int target, variant res )
   property QtObject str_list;
   property bool focus_visible: false
   property int  screenOffsetY: 0
   property int timer_flag:0

   property bool ignoreautoclose: false
//   MouseArea//GestureArea
//   {
//      anchors.fill: parent
//      z: -1
//      Pan
//      {
//         onUpdated: { focus_visible = false }
//      }
//   }

   z: 1000

   function showPopup( struct )
   {
      system_popup.showPopUpInContext( struct )
   }

   anchors.fill: parent
   visible: false

   ListModel { id: popup_txt_model; property string title; property int type; property bool useAnimation; property bool statusbar;/*property int __wrapMode; property int __elideMode;*/ }
   ListModel { id: popup_btn_model; property bool statusbar; }
   ListModel { id: popup_list_model; property string title; property int location_x; property int location_y; property int map_x; property int map_y;property bool statusbar;property ListModel listmodel: ListModel{} }

   CPopUp
   {
      id: controller

      function clearPopupData()
      {
         console.log("[SystemPopUp] CPopUp:clearPopupData")
          system_popup.visible = false;
          system_popup.focus_visible = false;
          system_popup.sourceComponent = undefined;
          popup_txt_model.title = "";
          popup_txt_model.type = -1;
          popup_txt_model.useAnimation=-1;
          popup_txt_model.clear();
          popup_list_model.clear();
          popup_list_model.location_x=-1;
          popup_list_model.location_y=-1;
          popup_list_model.map_x=-1;
          popup_list_model.map_y=-1;
          popup_btn_model.clear();
      }

      onCloseSystemPopup:
      {
         clearPopupData();
      }

      onShowPopup_MessageBox:
      {
         clearPopupData()
         popup_txt_model.set( 0, {"msg": message } );
         popup_txt_model.type = size;
         system_popup.sourceComponent = popupToast/*popupMsgBox*/;
         system_popup.visible = true
      }

      onShowPopup_Toast:
      {
          clearPopupData();
          //popup_txt_model.set( 0, {"msg": message } );
          popup_txt_model.set( 0, {"msg": args[0] } );
          popup_txt_model.statusbar= args[1]
          system_popup.sourceComponent = popupToast;
          system_popup.visible = true
      }

      onShowPopup_Text:
      {
          var i = -1;
         clearPopupData()
         /* Input parameter: args <<
                  title <<       [0]
                  message <<     [1]
                  btn_count <<   [2]
                  button[0] <<   [3]
                  button[1] <<   [4]
                  button[2] <<   [5]
                  button[3];     [6] */
         popup_txt_model.title = args[0]
         console.log( "[SystemPopUp] CPopUp:onShowPopup_Text title:" + popup_txt_model.title )
         popup_txt_model.append( {"msg": args[1] } );
         console.log( "[SystemPopUp] CPopUp:onShowPopup_Text message:" + popup_txt_model.get(0).msg )

         console.log( "[SystemPopUp] CPopUp:onShowPopup_Text btn_count:" + args[2] )
         for ( i = 3; i < 3 + parseInt(args[2]); i++ )
         {
            popup_btn_model.append( { "msg":args[i], "btn_id": i-1 } )
            console.log( "[SystemPopUp] CPopUp:onShowPopup_Text btn[" + i + "]:" + popup_btn_model.get(i - 3).msg )
         }
//         popup_txt_model.__wrapMode = args[i++];
//         popup_txt_model.__elideMode = args[i];
         console.log( "[SystemPopUp] CPopUp:onShowPopup_Text animation" + args[i] )
         if(args[i++] == 1) popup_txt_model.useAnimation = false // no animation 1
         popup_txt_model.statusbar = args[i]
         system_popup.sourceComponent = popupText;
         system_popup.visible = true
      }

      // SANGWOO_TEMP NAVI START
      onShowNaviPopup_Text:
      {
          var i = -1;
         clearPopupData()
         /* Input parameter: args <<
                  title <<       [0]
                  message <<     [1]
                  btn_count <<   [2]
                  button[0] <<   [3]
                  button[1] <<   [4]
                  button[2] <<   [5]
                  button[3];     [6] */
         popup_txt_model.title = args[0]
         console.log( "[SystemPopUp] CPopUp:onShowNaviPopup_Text title:" + popup_txt_model.title )
         popup_txt_model.append( {"msg": args[1] } );
         console.log( "[SystemPopUp] CPopUp:onShowNaviPopup_Text message:" + popup_txt_model.get(0).msg )

         console.log( "[SystemPopUp] CPopUp:onShowNaviPopup_Text btn_count:" + args[2] )
         for ( i = 3; i < 3 + parseInt(args[2]); i++ )
         {
            popup_btn_model.append( { "msg":args[i], "btn_id": i-1 } )
            console.log( "[SystemPopUp] CPopUp:onShowNaviPopup_Text btn[" + i + "]:" + popup_btn_model.get(i - 3).msg )
         }
//         popup_txt_model.__wrapMode = args[i++];
//         popup_txt_model.__elideMode = args[i];
         console.log( "[SystemPopUp] CPopUp:onShowNaviPopup_Text animation" + args[i] )
         if(args[i++] == 1) popup_txt_model.useAnimation = false // no animation 1
         popup_txt_model.statusbar = args[i]


         popup_txt_model.append( {"traffic_icon": args[++i] } );
          console.log( "[SystemPopUp] CPopUp:onShowPopup_Text traffic_icon" + args[i] )
         popup_txt_model.append( {"road_icon": args[++i] } );
         console.log( "[SystemPopUp] CPopUp:onShowPopup_Text road_icon" + args[i] )
         popup_txt_model.append( {"road_number": args[++i] } );
         console.log( "[SystemPopUp] CPopUp:onShowPopup_Text road_number" + args[i] )
         //  TEMP MODIFY //
         //system_popup.sourceComponent = popupText;
         system_popup.sourceComponent = popupNaviText;

         system_popup.visible = true
      }
      // SANGWOO_TEMP NAVI STOP
      onShowPopup_CustomText:
      {
         var i;
         clearPopupData()
         /* Input parameter: args
                  title                [0]
                  button count         [1]
                     button text       [2-5]
                  message count        [6]
                  --- msg struct ---   [7-22]
                     message           [+0]
                     pixel size        [+1]
                     color             [+2]
                     spacing           [+3] */
         popup_txt_model.title = args[0]
         console.log( "[SystemPopUp] CPopUp:onShowPopup_CustomText title:" + popup_txt_model.title )

         console.log( "[SystemPopUp] CPopUp:onShowPopup_Text btn_count:" + args[1] )
         for ( i = 2; i < 2 + parseInt(args[1]); i++ )
         {
            popup_btn_model.append( { "msg":args[i], "btn_id": i } )
            console.log( "[SystemPopUp] CPopUp:onShowPopup_CustomText btn[" + i + "]:" + popup_btn_model.get(i-2).msg )
         }

         console.log( "[SystemPopUp] CPopUp:onShowPopup_Text txt_count:" + args[6] )
         for ( i = 7; i < 7 + parseInt(args[6]) * 4; i+=4 )
         {
            popup_txt_model.append( { "msg": args[i],
                                      "txt_pixelsize": undefined,
                                      "txt_color": undefined,
                                      "txt_spacing": undefined } )

            if ( args[ i + 1 ] ) popup_txt_model.set((i-7)/4, { "txt_pixelsize": args[ i + 1 ] })
            if ( args[ i + 2 ] ) popup_txt_model.set((i-7)/4, { "txt_color": args[ i + 2 ] })
            if ( args[ i + 3 ] ) popup_txt_model.set((i-7)/4, { "txt_spacing": args[ i + 3 ] })

            console.log( "[SystemPopUp] CPopUp:onShowPopup_CustomText msg[" + i + "]:" + popup_txt_model.get((i-7)/4).msg )
            console.log( "[SystemPopUp] CPopUp:onShowPopup_CustomText txt_pixelsize[" + i + "]:" + popup_txt_model.get((i-7)/4).txt_pixelsize )
            console.log( "[SystemPopUp] CPopUp:onShowPopup_CustomText txt_color[" + i + "]:" + popup_txt_model.get((i-7)/4).txt_color )
            console.log( "[SystemPopUp] CPopUp:onShowPopup_CustomText txt_spacing[" + i + "]:" + popup_txt_model.get((i-7)/4).txt_spacing )
         }

         system_popup.sourceComponent = popupCustomText;
         system_popup.visible = true
      }

      onShowPopup_XMAlert:
      {
          clearPopupData()
          /* Input parameter: args <<
                   head        <<      [0]
                   contents <<     [1]
                   date         <<     [2]
                   x                <<     [3]
                   y                <<     [4]
                   btn1         <<     [5]
                   btn2         <<     [6]
                   map_x     <<     [7]
                   map_y     <<     [8]
*/

          popup_list_model.append({"head": args[0]});
          console.log( "[SystemPopUp] CPopUp:onShowPopup_XMAlert head:" + popup_list_model.get(0).head )
          popup_list_model.append({"contents": args[1]});
          console.log( "[SystemPopUp] CPopUp:onShowPopup_XMAlert contents:" + popup_list_model.get(1).contents )
          popup_list_model.append({"date": args[2]});
          console.log( "[SystemPopUp] CPopUp:onShowPopup_XMAlert date:" + popup_list_model.get(2).date )
          popup_list_model.location_x = args[3];
          popup_list_model.location_y = args[4];

//          popup_btn_model.append( { "msg":args[5], "btn_id": 3 } )
//          console.log( "CPopUp:onShowPopup_XMAlert btn1_txt:" + popup_btn_model.get(0).msg )
//          popup_btn_model.append( { "msg":args[6], "btn_id": 4 } )
//          console.log( "CPopUp:onShowPopup_XMAlert btn2_txt:" + popup_btn_model.get(1).msg )
          for (var i = 5; i < 7; i++ )
          {
             popup_btn_model.append( { "msg":args[i], "btn_id": i-3 } )
             console.log( "[SystemPopUp] CPopUp:onShowPopup_XMAlert btn[" + i-3 + ":" + popup_btn_model.get(i - 5).msg
                         + " btn_id :" + popup_btn_model.get(i - 5).btn_id);
          }
          popup_list_model.map_x = args[7];
          popup_list_model.map_y = args[8];
          popup_list_model.statusbar = args[9];
          system_popup.sourceComponent = popupXMAlert;
          system_popup.visible = true
      }

      onShowPopup_Warning:
      {
         clearPopupData()
         /* Input parameter: args <<
                  title <<       [0]
                  message <<     [1]
                  btn_count <<   [2]
                  button[0] <<   [3]
                  button[1] <<   [4]
                  button[2] <<   [5]
                  button[3];     [6] */
         popup_txt_model.title = args[0]
         console.log( "[SystemPopUp] CPopUp:onShowPopup_Warning title:" + popup_txt_model.title )
         popup_txt_model.append( {"msg": args[1] } );
         console.log( "[SystemPopUp] CPopUp:onShowPopup_Text message:" + popup_txt_model.get(0).msg )

         console.log( "[SystemPopUp] CPopUp:onShowPopup_Warning btn_count:" + args[2] )
         for (var i = 3; i < 3 + parseInt(args[2]); i++ )
         {
            popup_btn_model.append( { "msg":args[i], "btn_id": i-1 } )
            console.log( "[SystemPopUp] CPopUp:onShowPopup_Warning btn[" + i + ":" + popup_btn_model.get(i - 3).msg )
         }
          popup_txt_model.statusbar = args[i];
          console.log( "[SystemPopUp] CPopUp:onShowPopup_Warning statusbar:" + args[i] )
         system_popup.sourceComponent = popupWarning;
         system_popup.visible = true
      }

      onShowPopup_List:
      {
         clearPopupData()
         /* Input parameter: args <<
                  title     <<  [0]
                  list size <<  [1]
                  list      <<  [2]...[ list size ]
                  btn_count <<  [ list size + 1 ]
                  button[0] <<  [ list size + 2 ]
                  button[1] <<  [ list size + 3 ]
                  button[2] <<  [ list size + 4 ]
                  button[3] <<  [ list size + 5 ] */
         popup_list_model.title = args[0]
         console.log( "[SystemPopUp] CPopUp:onShowPopup_List title:" + popup_list_model.title )
         console.log( "[SystemPopUp] CPopUp:onShowPopup_List list size:" + args[1] )

         var i = 2;

         for ( i; i < 2 + parseInt( args[1] ); i++ )
         {
            popup_list_model.listmodel.append( { "name": args[i] } );
            console.log( "[SystemPopUp] CPopUp:onShowPopup_List list item[" + i + "] = " + args[i] )
         }

         console.log( "[SystemPopUp] CPopUp:onShowPopup_List btn_count:" + args[i] )
         for (var j = ( i + 1 ); j < ( i + 1 ) + parseInt(args[ i ] ); j++ )
         {
            popup_btn_model.append( { "msg": args[j], "btn_id": j - 1 } )
         }
         popup_list_model.statusbar = args[i];
         system_popup.sourceComponent = popupList;
         system_popup.visible = true
      }

      onPopup_Response: system_popup.popup_Response( target, res );

      onStartPopupTimer:
      {
          popup_close_timer.stop();
          popup_close_timer.interval = timeout;
          popup_close_timer.running = true;
          controller.setSharedMemData(0);
      }
      onStopPopupTimer:
      {
            popup_close_timer.stop();

      }

      onSetignoreAutoClose:  // SANGWOO ignore
      {
          console.log( "[SystemPopUp] CPopUp:onSetignoreAutoClose ignore :" + ignore )
          ignoreautoclose = ignore;

      }

   }

   Connections
   {
      target: UIListener
      onSignalPopupJogNavigation:
      {
          if( system_popup.visible == true ) focus_visible = true;
      }
      onSignalJogNavigation:
      {
          if( system_popup.visible == true ) focus_visible = true;
      }
   }

   /** Message box popup */
   Component
   {
      id: popupMsgBox
      Item
      {
         DHAVN_PopUp_Dimmed
         {
            message: popup_txt_model
            typePopup: popup_txt_model.type
            onClosed:
            {
                controller.responseButton( 0 );
                controller.clearPopupData();
            }
            offset_y: system_popup.screenOffsetY;
         }
      }
   }

   /** Text popup with buttons */
   Component
   {
      id: popupCustomText
      DHAVN_PopUp_Text
      {
         title: popup_txt_model.title
         message: popup_txt_model
         buttons: popup_btn_model
         content_size : popup_txt_model.get(0).txt_pixelsize
         onBtnClicked: controller.responseButton( btnId )
         focus_visible: system_popup.focus_visible
         offset_y: system_popup.screenOffsetY;
         statusbar_visible: popup_txt_model.statusbar == 1 ? true : false
         onStopCloseTimer: {
             console.log("[SystemPopUp] PopUp_PopUps CustomText onStopPopUpTimer")
             popup_close_timer.running = false;
         }
//         _wrapMode: popup_txt_model.__wrapMode
//         _elideMode: popup_txt_model.__elideMode
      }
   }

   /** Custom Text popup with buttons */
   Component
   {
      id: popupText
      DHAVN_PopUp_Text
      {
         title: popup_txt_model.title
         message: popup_txt_model
         buttons: popup_btn_model
         onBtnClicked: {
             console.log("S[SystemPopUp] PopUp_PopUps  popupText onBtnClicked");
             controller.responseButton( btnId )
         }
         focus_visible: system_popup.focus_visible
         offset_y: system_popup.screenOffsetY;
         statusbar_visible: popup_txt_model.statusbar == 1 ? true : false
         _useAnimation: {
             if (_useAnimation)
                popup_txt_model.useAnimation;
             else
                 false;
         }
         onStopCloseTimer: {
             console.log("S[SystemPopUp] PopUp_PopUps  popupText onStopPopUpTimer");
             popup_close_timer.running = false;
             controller.setSharedMemData(1);
             console.log("[SystemPopUp] PopUp_PopUps  popupText setSharedMemData " + controller.getSharedMemData());
         }
         onRestartCloseTimer: {
             console.log("[SystemPopUp] PopUp_PopUps  popupText onRestartCloseTimer");
             popup_close_timer.running = true;
             controller.setSharedMemData(0);
             console.log("[SystemPopUp] PopUp_PopUps  popupText setSharedMemData " + controller.getSharedMemData());
         }
         // restart timer 2013.09.23
         onResetTimerPopupText: {
             console.log("[SystemPopUp] PopUp_PopUps  popupText onResetTimerPopupText");
            // console.log("SUILYOU SANGWOO DHAVN_PopUp_PopUps  popupText popup_close_timer.running " + popup_close_timer.running);
            // timer_flag = controller.getSharedMemData();
            // console.log("SUILYOU SANGWOO DHAVN_PopUp_PopUps  popupText onResetTimerPopupText timer_flag " + timer_flag);
             if(popup_close_timer != null && popup_close_timer.running == true)
             popup_close_timer.restart()
         }
      }
   }

   // SANGWOO_TEMP NAVI START
   Component
   {
      id: popupNaviText
      //DHAVN_PopUp_Text
      DHAVN_PopUp_NaviText
      {
         title: popup_txt_model.title
         message: popup_txt_model
         buttons: popup_btn_model
         onBtnClicked: {
             console.log("[SystemPopUp] PopUp_PopUps  popupNaviText onBtnClicked");
             controller.responseButton( btnId )
         }
         focus_visible: system_popup.focus_visible
         offset_y: system_popup.screenOffsetY;
         statusbar_visible: popup_txt_model.statusbar == 1 ? true : false
         _useAnimation: {
             if (_useAnimation)
                popup_txt_model.useAnimation;
             else
                 false;
         }
         onStopCloseTimer: {
             console.log("[SystemPopUp] PopUp_PopUps  popupNaviText onStopPopUpTimer");
             popup_close_timer.running = false;
             controller.setSharedMemData(1);
             console.log("[SystemPopUp] PopUp_PopUps  popupNaviText setSharedMemData " + controller.getSharedMemData());
         }
         onRestartCloseTimer: {
             console.log("[SystemPopUp] PopUp_PopUps  popupNaviText onRestartCloseTimer");
             popup_close_timer.running = true;
             controller.setSharedMemData(0);
             console.log("[SystemPopUp] PopUp_PopUps  popupNaviText setSharedMemData " + controller.getSharedMemData());
         }
         // restart timer 2013.09.23
         onResetTimerPopupText: {
             console.log("[SystemPopUp] PopUp_PopUps  popupNaviText onResetTimerPopupText");
            // console.log("SUILYOU SANGWOO DHAVN_PopUp_PopUps  popupNaviText popup_close_timer.running " + popup_close_timer.running);
            // timer_flag = controller.getSharedMemData();
            // console.log("SUILYOU SANGWOO DHAVN_PopUp_PopUps  popupNaviText onResetTimerPopupText timer_flag " + timer_flag);
             if(popup_close_timer != null && popup_close_timer.running == true)
             popup_close_timer.restart()
         }
      }
   }
   // SANGWOO_TEMP NAVI END


   /** Warning popup with buttons */
   Component
   {
      id: popupWarning
      DHAVN_PopUp_Text
      {
         icon_title: 1
         title: popup_txt_model.title
         message: popup_txt_model
         buttons: popup_btn_model
         onBtnClicked: controller.responseButton( btnId )
         focus_visible: system_popup.focus_visible
         offset_y: system_popup.screenOffsetY;
         statusbar_visible: popup_txt_model.statusbar == 1 ? true : false
      }
   }

   /** List popup with buttons */
   Component
   {
      id: popupList
      DHAVN_PopUp_ListAndButtons
      {
         title: popup_list_model.title
         listmodel: popup_list_model.listmodel
         buttons: popup_btn_model
         onBtnClicked: controller.responseButton( btnId )
         focus_visible: system_popup.focus_visible
         statusbar_visible: popup_list_model.statusbar == 1 ? true : false
         offset_y: system_popup.screenOffsetY;
      }
   }

   Component
   {
       id:popupToast
       DHAVN_PopUp_Toast
       {
           listmodel:popup_txt_model
           statusbar_visible: popup_txt_model.statusbar == 1 ? true : false
//           onClosed:
//           {
//               controller.responseButton( 0 );
//               controller.clearPopupData();
//           }
      //     offset_y: system_popup.screenOffsetY;
       }
   }
   /** popup XM Alert */
   Component
   {
      id: popupXMAlert
      DHAVN_PopUp_XM_Alert
      {
        // title: popup_list_model.title
         listmodel: popup_list_model
         buttons: popup_btn_model
         onBtnClicked: controller.responseButton( btnId )
         focus_visible: system_popup.focus_visible
         offset_y: system_popup.screenOffsetY;
         map_location_x: popup_list_model.location_x
         map_location_y: popup_list_model.location_y
         map_view_x: popup_list_model.map_x
         map_view_y: popup_list_model.map_y
         statusbar_visible: popup_list_model.statusbar == 1 ? true : false
      }
   }

   Timer
   {
       id: popup_close_timer
       interval: 0
       running: false
       onTriggered:
       {
           timer_flag = controller.getSharedMemData();
           console.log("[SystemPopUp] popup_close_timer onTriggered SharedMemData " + timer_flag)
           //if(timer_flag == 1 )
           if(timer_flag == 1 || ignoreautoclose == true)
               return;
           controller.responseButton(1)
           controller.clearPopupData();
       }
       onRunningChanged: {
           console.log("[SystemPopUp] popup_close_timer onRunningChanged" + running)
           if(running == false)
               popup_close_timer.stop()
       }

   }

   function showPopUpInContext( popup_show_t, app_id )
   {
      controller.showPopUp(popup_show_t);
      screenOffsetY = controller.getScreenOffsetY( app_id );
   }

   function hidePopUpInContext(bPressedButton)
   {
      if( !bPressedButton )
         controller.responseButton(0)

      console.log("[SystemPopUp] hidePopUpInContext ")
      controller.clearPopupData()
      popup_close_timer.running = false;
      popup_close_timer.interval = 0;
      ignoreautoclose = false; // SANGWOO ignore
   }
   function closePopUpInContext()
   {
       console.log("[SystemPopUp] closePopUpInContext ")
       controller.clearPopupData()
   }
}
