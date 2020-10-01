import Qt 4.7
import QtQuick 1.1 // added by Dmitry 03.05.13
// import QmlStatusBarWidget 2.0 // removed by kihyung 2012.12.15 for STATUSBAR_NEW
import QmlPopUpPlugin 1.0
//import QmlQwertyKeypadWidget 1.0 // removed by Dmitry 15.10.13 for ITS0195216
import QmlModeAreaWidget 1.0
import com.filemanager.defines 1.0
import com.filemanager.uicontrol 1.0
import AppEngineQMLConstants 1.0
import Qt.labs.gestures 2.0
import QmlStatusBar 1.0 //modified by edo.lee 2013.04.04
import QmlSimpleItems 1.0 // added by Dmitry 25.08.13

import "DHAVN_AppFileManager_General.js" as FM
import "DHAVN_AppFileManager_Resources.js" as RES  // [KOR][ISV][64532][C] by aettie 20130628

DHAVN_AppFileManager_FocusedItemNew
{
   id: mainScreen

   node_id: 0
   focus_default: 2 // default node_id to place focus, by default it's on content

   width: FM.const_APP_FILE_MANAGER_SCREEN_WIDTH
   height: FM.const_APP_FILE_MANAGER_SCREEN_HEIGHT

   focus: true
   focus_visible: true //added by aettie 2013.03.27 for Touch Focus
   property bool systemPopup: false // added by Dmitry 10.09.13 for ITS0182911
   property bool content_visible: false // added by Dmitry 03.10.13 for ITS0187937
   property bool blockKeys: false // added by Dmitry 06.11.13 for ISV94041
   property bool lockoutVisible: false // modified by cychoi 2015.06.25 for ITS 264719
   
   GestureArea { id: dummy; anchors.fill: parent } // added by Dmitry 09.10.13 for ITS0194630
   property int pressedHardKey: 0 //added by suilyou ITS 0194641
   property int currentLoaderCount: content_loader.item.count // modified for ITS 0216391
   // modified for ITS 0218316
   property string mode_area_text_folder_count: "0"
   property string mode_area_text_file_count: "0"
   property string mode_area_text: ""

   QmlStatusBar
   {
      id: statusBar
      x: 0;
      y: 0;
      z: 10
      width: 1280;
      height: 93;
      homeType: "button"
      middleEast: EngineListener.middleEast //[ME][ITS][177647][minor](aettie.ji)
   }

   // { added by cychoi 2015.07.16 for ITS 266352
   function onShowLockout(bOn)
   {
       EngineListener.qmlLog("onShowLockout = " + bOn)

       if(lockoutVisible == bOn) return // added by cychoi 2015.09.23 for ITS 269113

       if(bOn)
       {
           if((UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_FRONT) && EngineListener.IsSwapDCEnabled() ||
              (UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_REAR) && !EngineListener.IsSwapDCEnabled())
               return

           // { moved by cychoi 2016.01.05 for ITS 271037
           if (options_menu.status == Loader.Ready && options_menu.item.visible)
               options_menu.item.quickHide()
           // } moved by cychoi 2016.01.05
   
           lockoutVisible = true // modified by cychoi 2015.06.25 for ITS 264719
           mainScreen.focus_default = 1 // added by cychoi 2015.12.16 for ITS 270846
           mAreaWidget.showFocus()
       }
       else
       {
           lockoutVisible = false // modified by cychoi 2015.06.25 for ITS 264719
           if(StateManager.rootState == false || mainScreen.currentLoaderCount > 0) // added by cychoi 2015.09.23 for ITS 269112
           {
               mAreaWidget.hideFocus()
               // { added by cychoi 2015.09.23 for ITS 269113
               if (mainScreen.currentLoaderCount == 0)
                   mainScreen.focus_default = 4
               else
                   mainScreen.focus_default = 2 // return focus to content
               mainScreen.setDefaultFocus()
               // } added by cychoi 2015.09.23 for ITS 269113
           }
       }
   }
   // } added by cychoi 2015.07.16

   Connections
   {
       target: EngineListener
       onRetranslateUi:
       {
           LocTrigger.retrigger()
       }

       onDefaultFocus:
       {
           mainScreen.log("Set default focus")
           // { modified by cychoi 2015.11.03 for ITS 269955
           if(screen == UIListener.getCurrentScreen())
           {
               if(StateManager.editModeLaunchFromMP() == true)
               {
                   EngineListener.qmlLog("onDefaultFocus #1")
                   focus_default = 3
                   StateManager.setEditModeLaunchFromMP(false);
               }
               else
               {
                   EngineListener.qmlLog("onDefaultFocus #2")
                   // {added by Michael.Kim 2014.01.25 for ITS 221044
                   if (focus_default == 4)
                       focus_default = 2
                   // }added by Michael.Kim 2014.01.25 for ITS 221044
               }

               systemPopup = false // added by Dmitry 10.09.13 for ITS0182911
               blockKeys = false // added by Dmitry 06.11.13 for ISV94041
               mainScreen.setDefaultFocus() //modify by youngsim.jo VI 15MY ISV 99509
           }
           else
           {
               if(StateManager.editModeLaunchFromMP() == true)
               {
                   StateManager.setEditModeLaunchFromMP(false);
               }
           }
           // } modified by cychoi 2015.11.03
       }

       onHideMenu:
       {
          if (UIListener.getCurrentScreen() == screen)
          {
// removed by Dmitry 08.10.13 for ITS0194416
              if (options_menu.status == Loader.Ready && options_menu.item.visible)
                  options_menu.item.quickHide() // modified by Sergey 02.08.2103 for ITS#181512
          }
       }

// added by Dmitry 08.10.13 for ITS0194416
       onShowContent:
       {
          if (UIListener.getCurrentScreen() == screen)
          {
              content_visible = show
          }
       }
// added by Dmitry 08.10.13 for ITS0194416

       // mofdified for ISV 89536
       onHideVideoMenu:
       {
          if ( UIControl.currentFileType == UIDef.FILE_TYPE_VIDEO )
          {
              if (options_menu.status == Loader.Ready && options_menu.item.visible)
                  options_menu.item.hide()
          }
       }
       //added by suilyou ITS 0194641 START
       onChangedJogKeyPressed:
       {
           pressedHardKey = EngineListener.getJogKeyPressed
           EngineListener.qmlLog("onChangedHardKeyPressed =" + pressedHardKey)
       }
       onChangedJogKeyReleased:
       {
           pressedHardKey = EngineListener.getJogKeyReleased
           EngineListener.qmlLog("onChangedHardKeyReleased =" + pressedHardKey)
       }
       //added by suilyou ITS 0194641 END
       // { modified by cychoi 2015.12.16 for ITS 270846 //{added for DHPE IMAGE DRS 2015.03.26
       onPhotoDRSMode:
       {
           if (UIListener.getCurrentScreen() == screen)
           {
               onShowLockout(show) // modified by cychoi 2015.07.16 for ITS 266352
           }
       } 
       // } modified by cychoi 2015.12.16 //}added for DHPE IMAGE DRS 2015.03.26
   }

   Image
   {
       id: bg
       y: 0
       source: "/app/share/images/general/bg_main.png" //20131025 GUI fix
   }

   DHAVN_AppFileManager_FocusedItemNew
   {
      id: modeArea
      anchors.top: statusBar.bottom
      height: mAreaWidget.height
      node_id: 1

      links: ( currentLoaderCount > 0 ) ? [-1, 2, -1, -1] : ( navigator.visible ? [-1, 4, -1, -1] : [-1, -1, -1, -1] ) // modified for ITS 0216391

      onShowFocus:
      {
         mAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP)
         mAreaWidget.showFocus()
      }

      onHideFocus:
      {
          if(!lockoutVisible) // added by cychoi 2016.01.21 for ITS 271265
              mAreaWidget.hideFocus()
      }

      QmlModeAreaWidget
      {
          id: mAreaWidget
          anchors.top: modeArea.top // modified by Dmitry 21.08.13 for ITS0184685

          focus_id: 0
          modeAreaModel: mode_area_model
          isFMMode : true //added for ITS 241667 2014.06.30

          property string name: "ModeArea"
          property int showState: StateManager.showCountState
          mirrored_layout: EngineListener.middleEast // added by aettie 20130514 for mode area layout mirroring
          bAutoBeep: false // added by Sergey 19.11.2013 for beep issue
          onQmlLog: EngineListener.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log
          onBeep: UIListener.ManualBeep(); // added by Sergey 19.11.2013 for beep issue
          is_lockoutMode: lockoutVisible // modified by cychoi 2015.06.25 for ITS 264719 //added for DHPE IMAGE DRS 2015.03.26
          
          function backHandler()
          {
              // {added by Michael.Kim 2014.01.25 for ITS 221044
              if (currentLoaderCount == 0 && focus_default == 4)
                  focus_default = 2
              // }added by Michael.Kim 2014.01.25 for ITS 221044
              // { added by cychoi 2015.11.03 for ITS 269955
              else if (focus_default == 3)
                  focus_default = 2 // return focus to content
              // } added by cychoi 2015.11.03
              UIControl.modeAreaEventHandler(UIDef.MODE_AREA_EVENT_BACK_PRESSED)
          }

          ListModel
          {
              id: mode_area_model

              /** Title */
              property string text: UIControl.modeAreaTitle
              property int const_FONT_SIZE_UP_BUTTON: 40
	      property bool image_type_visible: false // added by eugene 2012.12.12 for NewUX - Photo #5-2
	      property bool isFolder: false // added by eugene 2012.12.12 for NewUX - Photo #5-2
	      property bool isListMode:true // added by eugene 2012.12.12 for NewUX - Photo #5-2
              property bool counter_visible: false
              property bool right_text_visible: false
              property int mode_area_counter_number: 0
              property int mode_area_counter_total: 0
	       // [KOR][ISV][64532][C] by aettie 20130628
           // modified for ITS 0218316 // modified by hyejin.noh 20140625 for ISV 100798
              property string icon: mode_area_right_text != "" ? ( (isFolder && (content_loader.focus_visible || (options_menu.status == Loader.Ready && options_menu.item.visible)) )? RES.const_FOLDER_IMAGE_ICON_IMG :
                                                                                                               (UIControl.currentFileType == UIDef.FILE_TYPE_PICTURE)? RES.const_PHOTO_IMAGE_ICON_IMG : RES.const_VIDEO_IMAGE_ICON_IMG ) : ""
              property bool right_text_visible_f: ( content_loader.focus_visible || !right_text_visible || mode_area_text_folder_count == "0" ||
                                                                                    (options_menu.status == Loader.Ready && options_menu.item.visible) ) ? false : true  // modified by hyejin.noh 20140625 for ISV 100798
              property string icon_cat_folder: mode_area_right_text != "" ? RES.const_FOLDER_IMAGE_ICON_IMG : ""
              property string mode_area_right_text_f: mode_area_text_folder_count

              property string mode_area_right_text: ( content_loader.focus_visible || (options_menu.status == Loader.Ready && options_menu.item.visible) )? mode_area_text : mode_area_text_file_count
              // modified by hyejin.noh 20140625 for ISV 100798
              property string mb_text: QT_TR_NOOP("STR_SETTING_SYSTEM_DISPLAY");
              property bool mb_visible: StateManager.isMenuVisible // modified by Dmitry 15.04.13 for ISV79935
              property string file_count : UIControl.modeAreaFileCount; // added by yungi 2013.03.08 for New UX FileCount
          }

          onModeArea_BackBtn:
          {
              mainScreen.log("onModeArea_BackBtn");
              mAreaWidget.backHandler();
              backHandlerTimer.start(); //Added by Alexey Edelev 2012.10.04. CR14212
          }

          onModeArea_RightBtn:
          {
              UIControl.modeAreaEventHandler( UIDef.MODE_AREA_EVENT_EDIT_PRESSED )
          }

          onModeArea_MenuBtn:
          {
              UIControl.handleMenuKey()
          }

          Component.onCompleted:
          {
              TitleProvider.titleWidth = titleWidth
              TitleProvider.font = titleFont
          }

          onShowStateChanged:
          {
              switch (showState)
              {
                  case 0:
                  {
                      mode_area_model.image_type_visible = false // added by eugene 2012.12.12 for NewUX - Photo #5-2
                      mode_area_model.right_text_visible = false
                      mode_area_model.counter_visible = false
                  }
                  break

                  case 1:
                  {
                      mode_area_model.image_type_visible = true // added by eugene 2012.12.12 for NewUX - Photo #5-2
                      mode_area_model.right_text_visible = true
                      mode_area_model.counter_visible = false
                  }
                  break

                  case 2:
                  {
                      mode_area_model.image_type_visible = true // added by eugene 2012.12.12 for NewUX - Photo #5-2
                      mode_area_model.right_text_visible = false
                      mode_area_model.counter_visible = true
                  }
                  break
              }
          }
      }
   }

    DHAVN_AppFileManager_FocusedLoaderNew
    {
        id: content_loader
        node_id: 2

        links: !EngineListener.middleEast ? [4, -1, -1, 3] : [4, -1, 3, -1]

        anchors.top: !navigator.visible ? modeArea.bottom : navigator.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        visible: (content_loader.status == Loader.Ready && content_visible && !lockoutVisible) // modified by cychoi 2015.07.30 for ITS 267218 // modified by Dmitry 15.10.13 for ITS0195216

        source:
        {
            var value

            switch ( UIControl.contentMode )
            {
                case UIDef.CONTENT_MODE_LIST:
                    value = UIControl.currentFileType == UIDef.FILE_TYPE_VIDEO ?
                             "DHAVN_AppFileManager_VideoList.qml" :
                             "DHAVN_AppFileManager_PictureList.qml"
                    break;

                case UIDef.CONTENT_MODE_FILEMANAGER:
                    value = UIControl.currentFileType == UIDef.FILE_TYPE_VIDEO ?
                              "DHAVN_AppFileManager_VideoFileManager.qml" :
                              "DHAVN_AppFileManager_PictureFileManager.qml"
                    break

                default:
                    value = ""
            }
            return value
        }
    }

// added by Dmitry 25.08.13
    Loader
    {
       id: scrollLoader
       sourceComponent: (content_loader.status == Loader.Ready) ? scroll : undefined

       LayoutMirroring.enabled: EngineListener.middleEast
       anchors.top: content_loader.top
       anchors.right: content_loader.right
       anchors.bottom: content_loader.bottom
       visible: content_visible // modified by Dmitry 03.10.13 for ITS0187937

       Component
       {
          id: scroll

          VerticalScrollBar
          {
             LayoutMirroring.enabled: EngineListener.middleEast

             anchors.top: parent.top
             anchors.right: parent.right
             anchors.bottom: parent.bottom
             anchors.topMargin: content_loader.item.scrollBarTopMargin
// modified by Dmitry 27.08.13
             anchors.rightMargin: UIControl.editButton ? FM.const_APP_FILE_MANAGER_SCROLL_RIGHT_MARGIN :
                                                         FM.const_APP_FILE_MANAGER_SCROLL_RIGHT_MARGIN + (FM.const_APP_FILE_MANAGER_RIGHT_BOTTOMAREA_WIDTH - 10 ) // modified by Michael.Kim 2014.02.18 for ITS 225685
             anchors.bottomMargin: FM.const_APP_FILE_MANAGER_LIST_BOTTOM_MARGIN

             position: content_loader.item.visibleArea.yPosition
             pageSize: content_loader.item.visibleArea.heightRatio
             visible: content_loader.item.count > 0 && pageSize < 1
          }
       }
    }
// added by Dmitry 25.08.13

    DHAVN_AppFileManager_BottomBar
    {
        id: bottom_bar
        node_id: 3

        anchors.top: modeArea.bottom

        links: !EngineListener.middleEast ? [1, -1, 2, -1] : [1, -1, -1, 2]

        LayoutMirroring.enabled: EngineListener.middleEast
        anchors.right: parent.right
        visible: UIControl.bottomBarMode && !lockoutVisible // added by cychoi 2015.07.16 for ITS 266351
    }

    DHAVN_AppFileManager_FocusedLoaderNew
    {
        id: navigator
        node_id: 4

        links: !EngineListener.middleEast ? ( (currentLoaderCount > 0 ) ? [1, 2, -1, 3] : [1, -1, -1, 3] )
                                          : ( (currentLoaderCount > 0 ) ? [1, 2, 3, -1] : [1, -1, 3, -1] ) // modified for ITS 0216391

        LayoutMirroring.enabled: EngineListener.middleEast
        anchors.top: modeArea.bottom
        anchors.right: parent.right

        source: visible ? "DHAVN_AppFileManager_Navigator.qml" : ""
        visible: !StateManager.rootState && !UIControl.bottomBarMode && content_visible && !lockoutVisible // modified by cychoi 2015.06.25 for ITS 264719 // modified by Dmitry 03.10.13 for ITS0187937
    }

// removed by Dmitry 15.10.13 for ITS0195216
//    DHAVN_AppFileManager_FocusedLoaderNew
//    {
//       id: key_pad_loader
//       node_id: 7
//       focusable: false

//       links: [-1, -1, -1, -1]
//       anchors.top: modeArea.bottom
//       anchors.left: parent.left

//       visible: false

//       Connections
//       {
//           target: key_pad_loader.item

//           onTextEntered:
//           {
//               UIControl.keyPadEventHandler( UIDef.KEYPAD_EVENT_TEXT_ENERED, str )
//               key_pad_loader.visible = false
//           }
//       }
//    }
// removed by Dmitry 15.10.13 for ITS0195216

    DHAVN_AppFileManager_FocusedLoaderNew
    {
       id: options_menu

       node_id: 5
       links: [-1, -1, -1, -1] // use focus_default to move focus to options menu

       y: 0
    }

    DHAVN_AppFileManager_PopUpLoader
    {
        id: popup_loader
        node_id: 6
        links: [-1, -1, -1, -1] // use focus_default to move focus to popups

        y: 0 //modified by aettie.ji 2013.02.01 for new status bar
        z: 10
    }

   Timer
   {
       id: backHandlerTimer
       running: false
       repeat: false
       interval: 100
       onTriggered: backHandlerTimer.stop();
   }

   Connections
   {
       target: EngineListener

       onKeyEvent:
       {
           switch ( nEventKey )
           {
               case CommonDef.FILEMANAGER_EVT_KEY_BACK:
               {
                  if (nStatus == CommonDef.FILEMANAGER_EVT_KEY_STATUS_PRESSED && UIListener.getCurrentScreen() == screen)
                  {
                      if (popup_loader.item && popup_loader.item.visible)
                      {
                          if(popup_loader.popup_type == UIDef.POPUP_TYPE_COPYING)
                          {
                              popup_loader.item.closePopup();
                              UIControl.popupEventHandler(UIDef.POPUP_EVENT_COPY_PROGRESS_CLOSE);
                          }
                          else
                          {
                              popup_loader.item.closePopup();
                          }
                          return;
                      }

                      if (options_menu.status == Loader.Ready && options_menu.item.visible)
                      {
                          options_menu.item.hide()
                          return;
                      }

                      mAreaWidget.backHandler()
                  }
               }
               break

               case CommonDef.FILEMANAGER_EVT_KEY_MENU:
               {
                   if (popup_loader.item && popup_loader.item.visible)
                   {
                       return;
                   }
// added by aettie 2013.08.01 for ITS 181900
//                   if (nStatus == CommonDef.FILEMANAGER_EVT_KEY_STATUS_RELEASED &&
//                       UIListener.getCurrentScreen() == screen)
                   if (nStatus == CommonDef.FILEMANAGER_EVT_KEY_STATUS_PRESSED &&
                       UIListener.getCurrentScreen() == screen)
                   {
                       if (lockoutVisible) return // added by cychoi 2015.12.21 for ITS 270924
                       UIControl.handleMenuKey()
                   }
               }
               break

               default:
               {
                   mainScreen.log("Unknown key event " + nEventKey)
               }
           }
       }

// modified by Dmitry 17.08.13 for ITS0185033
       onSignalJogNavigation:
       {
          if ((UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_FRONT) && !EngineListener.IsSwapDCEnabled() ||
              (UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_REAR) && EngineListener.IsSwapDCEnabled() ||
              (EngineListener.getCloneMode() == 2 || EngineListener.getCloneMode() == 1) ||
                  (arrow == UIListenerEnum.JOG_CENTER && status == UIListenerEnum.KEY_STATUS_CANCELED))//added for ITS 235782 2014.04.25
          {
              // added by Michael.Kim 2014.05.22 for ITS 237777
             if((options_menu.status == Loader.Ready && options_menu.item.visible) && (arrow == UIListenerEnum.JOG_CENTER)) return
             if (blockKeys) return // added by Dmitry 06.11.13 for ISV94041
             if (options_menu.status == Loader.Ready && options_menu.item.visible)
                options_menu.item.hide()
             else
             {
                if (popup_loader.status == Loader.Ready && popup_loader.item.visible || systemPopup) return; // modified by Dmitry 10.09.13 for ITS0182911
                if(!backHandlerTimer.running)
                {
                    if (arrow == UIListenerEnum.JOG_CENTER && mainScreen.focus_node.node_id != 2) return; // added by Dmitry for ITS0204926
                    if (!mainScreen.setDefaultFocus())
                        mainScreen.handleJogEvent(arrow, status);
                }
             }
          }
       }
// modified by Dmitry 17.08.13 for ITS0185033

// added by Dmitry 06.11.13 for ISV94041
       onFormatting:
       {
          // modified by Dmitry 07.11.13
          if (UIControl.currentDevice == UIDef.DEVICE_JUKEBOX)
              blockKeys = started
       }

       // { added by cychoi 2015.09.23 for ITS 269113
       onSignalShowLocalPopup:
       {
          if( display == UIListener.getCurrentScreen()) // added by cychoi 2015.11.03 for ITS 269995
          {
             mAreaWidget.is_popup_shown = true
          }
       }
       
       onSignalHideLocalPopup:
       {
          if( display == UIListener.getCurrentScreen()) // added by cychoi 2015.11.03 for ITS 269995
          {
             if(!systemPopup) // added by cychoi 2016.01.21 for ITS 271265
                 mAreaWidget.is_popup_shown = false
          }
       }
       // } added by cychoi 2015.09.23
   }

   Connections
   {
       target: UIListener // modified by lssanh 2013.03.28 list focus on popup
       onSignalJogNavigation:
       {
           if ( popup_loader.visible) return 
           if (blockKeys) return// added by Dmitry 06.11.13 for ISV94041
           if (options_menu.status == Loader.Ready && options_menu.item.visible) return; // modified by Dmitry 03.05.13
           if (lockoutVisible) return // modified by cychoi 2015.06.25 for ITS 264719 //added for DHPE IMAGE DRS 2015.03.26
           if (!backHandlerTimer.running)
           {
               // added by cychoi 2015.06.19 for ITS 264268
               if(EngineListener.processJogDirectionKey(arrow, status))
               {
                   // Jog Direction Key already cancelled, just return;
                   return
               }

               mainScreen.handleJogEvent(arrow, status);
           }
       }
// added by Dmitry 10.09.13 for ITS0182911
       onSignalShowSystemPopup:
       {
          if(systemPopup == true) return // added by cychoi 2015.09.23 for ITS 269113
          mainScreen.handleJogEvent(UIListenerEnum.JOG_CENTER, UIListenerEnum.KEY_STATUS_CANCELED);//added for ITS 249300 2014.11.13
          systemPopup = true // modified by Michael.Kim 2014.10.20 for ITS 249091
          mAreaWidget.is_popup_shown = true // added by cychoi 2015.09.23 for ITS 269113
          if (options_menu.status == Loader.Ready && options_menu.item.visible)
             options_menu.item.quickHide()
          popup_loader.onShowSystemPopup(); //added by Michael.Kim 2013.09.26 for ITS 191681
          // systemPopup = true
          hideFocus()
       }

       onSignalHideSystemPopup:
       {
          systemPopup = false // modified by Michael.Kim 2014.10.20 for ITS 249091
          mAreaWidget.is_popup_shown = false // added by cychoi 2015.09.23 for ITS 269113
          popup_loader.onHideSystemPopup(); //added by Michael.Kim 2013.09.26 for ITS 191681
          //systemPopup = false
          showFocus()
       }
// added by Dmitry 10.09.13 for ITS0182911
   }

   Connections
   {
       target: UIControl

        onMenuPressed:
        {
            EngineListener.qmlLog("UIControl menuPressed")
            // added by Michael.Kim 2013.10.02 for ITS 192988
            mainScreen.log("Menu key pressed")
            if (options_menu.status == Loader.Ready)
            {
                if (options_menu.item.visible){
                    options_menu.item.hide()
                }
                else{
                    EngineListener.cancelJogDirectionKey()
                    options_menu.item.show()
                }
            }
            else
            {
                // @todo-fix the gesture focus lost in option menu on next launch
                options_menu.source = "" // modified on 09-09-13 for ITS 0188621
                options_menu.source = "DHAVN_AppFileManager_OptionsMenu.qml"
                if (options_menu.status == Loader.Ready)
                {
                    if (!options_menu.item.visible){
                        EngineListener.cancelJogDirectionKey()
                        options_menu.item.show()
                    }
                    else{
                        options_menu.item.hide()
                    }
                }
            }
            // }added by Michael.Kim 2013.10.02 for ITS 192988
        }

// removed by Dmitry 15.10.13 for ITS0195216
//       onShowKeyPad:
//       {
//           mainScreen.log("onShowKeyPad");
//           StateManager.isMenuVisible = false // added by Dmitry 15.04.13 for ISV79935
//           key_pad_loader.visible = true
//       }

//       onHideKeyPad:
//       {
//           mainScreen.log("onHideKeyPad");
//           key_pad_loader.item.clearText();
//           StateManager.isMenuVisible = true // added by Dmitry 15.04.13 for ISV79935
//           key_pad_loader.visible = false
//       }
// removed by Dmitry 15.10.13 for ITS0195216
       onResetFocusOnEmtyModel:
       {
           if(navigator.visible && !systemPopup) // modified by Michael.Kim 2014.10.20 for ITS 249091
           {
               navigator.grabFocus(navigator.node_id)
           }
       }

       // { added by cychoi 2015.09.07 for ITS 268407 & ITS 268412
       onSetFocusToContent:
       {
           if (mainScreen.currentLoaderCount == 0)
               mainScreen.focus_default = 4
           else
               mainScreen.focus_default = 2 // return focus to content
           mainScreen.setDefaultFocus()
       }
       // } added by cychoi 2015.09.07
   }

   Connections
   {
       target: StateManager

       onShowTotalItems:
       {
           // modified for ITS 0218316
           if(infoText != "")
           {
               mode_area_text_folder_count = folderCount
               mode_area_text_file_count = fileCount
           }
           else
           {
               mode_area_text_folder_count = "0"
               mode_area_text_file_count = "0"
           }

           mode_area_text = infoText
           //mode_area_model.mode_area_right_text = infoText
           mode_area_model.isFolder = m_isFolder
       }

// added by Dmitry 03.10.13 for ITS0187937
       onShowContent:
       {
          content_visible = show
       }

       // { added by cychoi 2015.11.03 for ITS 269955
       onMoveFocusToBottom:
       {
           EngineListener.qmlLog("onEditModeFromMP focus_default = " + mainScreen.focus_default)
           if(mainScreen.focus_default == 3)
           {
               return
           }

           focus_default = 3
           mainScreen.setDefaultFocus()
       }
       // } added by cychoi 2015.11.03
   }
   //added by suilyou ITS 0194641 START
   MouseArea
   {
       id:id_mouseArea_block_filter
       anchors.fill: parent
       z:100000
       enabled: pressedHardKey != 0 ? (EngineListener.getCloneState4QML() ? true : false ) : false
       onEnabledChanged: {
           if(enabled==true)
               EngineListener.qmlLog("Touch Blocking HardKeyPressing")
           else
               EngineListener.qmlLog("NO Touch Blocking HardKeyPressing")
       }
   }
   //added by suilyou ITS 0194641 END
   //{added for DHPE IMAGE DRS 2015.03.26
   Rectangle
   {
       id: lockoutRect

       anchors.fill:content_loader
       anchors.left: parent.left
       visible: lockoutVisible // added by cychoi 2015.06.25 for ITS 264719
       color: "black"

       Image
       {
           id: lockoutImg

           anchors.left: parent.left
           anchors.leftMargin: 562
           anchors.top: parent.top
           anchors.topMargin: !navigator.visible ? FM.const_APP_FILE_MANAGER_LOCKOUT_ICON_TOP_OFFSET
                                                 : FM.const_APP_FILE_MANAGER_LOCKOUT_ICON_N_TOP_OFFSET
           source: "/app/share/images/general/ico_block_image.png"
       }

       Text
       {
           width: parent.width
           horizontalAlignment:Text.AlignHCenter
           anchors.top: lockoutImg.bottom
           text: qsTranslate(FM.const_APP_FILE_MANAGER_LANGCONTEXT,"STR_MEDIA_IMAGE_DRIVING_REGULATION") + LocTrigger.empty
           font.pointSize: 32
           color: "white"
       }
   }
   //}added for DHPE IMAGE DRS 2015.03.26

    // { added by cychoi 2015.07.16 for ITS 266352
    Component.onCompleted:
    {
        if(StateManager.getIsLockoutMode() == lockoutVisible)
            return

        onShowLockout(StateManager.getIsLockoutMode())
    }
    // } added by cychoi 2015.07.16
}
