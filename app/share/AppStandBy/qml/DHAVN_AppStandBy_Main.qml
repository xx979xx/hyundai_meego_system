import QtQuick 1.1
import StandByAppConstants 1.0
import AppEngineQMLConstants 1.0
import QmlStatusBar 1.0
import "DHAVN_AppStandBy_General.js" as General
import "DHAVN_AppStandBy_Images.js" as Images

Image
{
    id: idStandByMain
   source: Images.BACKGROUND_IMAGE

   property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
   property bool focusVisible: true
   property bool autoDisappear: vehicleVariant == 0 ? false : true      // default value DH: false, KH/VI/DHPE: true
   property int focusIndex: 0
   property bool jogPressed: false
   property bool isNaviPresent : EngineListener.CheckNaviStatus()
   property int cv: UIListener.GetCountryVariantFromQML()
   property int langID: EngineListener.GetLanguageID()
   property bool isMainScreen: true
   property bool bLaunchApp: false
   property bool jogCenterPressed: false
   property bool runPressTimer: false
   property bool maClicked: false
   property bool maReleased: false
   property bool maPressed: false
   property bool sigEmergency: false
   property int clicked_btn_id: -1
   property int evvVariant: EngineListener.CheckEvvStatus()            //  0. DH       1. 15MY     2. DHPE

   //y: -93

   QmlStatusBar {
       id: statusBar
       x: 0; y: 0; z:10000; width: 1280; height: 93
       homeType: "none"
       middleEast: (langID == 20 ) ? true : false
   }

   function getLang()
   {
       langID = EngineListener.GetLanguageID()
   }


   Image
   {
       id: messageBG
       source: Images.MESSAGE_BG_IMAGE
       anchors.top: statusBar.bottom
       anchors.horizontalCenter: parent.horizontalCenter
       Image
       {
           id: cautionIcon
           source: Images.CAUTION_ICON
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top: parent.top
           anchors.topMargin: General.const_APP_SETTINGS_CAUTIONICON_TOP_MARGIN
       }

       Text /** Message */
       {
           id: msgText
           anchors.top: parent.top
           anchors.topMargin: General.const_APP_SETTINGS_CAUTIONTEXT_TOP_MARGIN
           anchors.horizontalCenter: parent.horizontalCenter
           width: 1040
           height: 380
           font.pixelSize: vehicleVariant == 1 ? 30 : 32
           font.family: General.FONT_REGULAR
           text: (isNaviPresent ? ( cv != 2 ? (qsTranslate( "main", "STR_STANDBY_MESSAGE" ) + EngineListener.empty)
                                            : (qsTranslate( "main", "STR_STANDBY_MESSAGE_CHINA" ) + EngineListener.empty) )
                             : (qsTranslate( "main", "STR_STANDBY_MESSAGE_NO_NAVI" )+ EngineListener.empty))
           color: vehicleVariant == 1 ?  General.const_COLOR_TEXT_COMMON_GREY : General.const_COLOR_TEXT_BRIGHT_GREY
           verticalAlignment: Text.AlignVCenter
           horizontalAlignment: Text.AlignHCenter
           wrapMode: Text.WordWrap
       }
   }

   Row /** Buttons */
   {
      layoutDirection: langID == 20 ? Qt.RightToLeft : Qt.LeftToRight
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: messageBG.bottom
      anchors.topMargin: General.const_APP_SETTINGS_BUTTONS_MARGIN
      spacing: General.const_APP_SETTINGS_BUTTON_SPACING

      Repeater
      {
         model: ListModel
         {
            id: buttons
            ListElement /** CONST.const_BUTTON_AGREE */
            {
               msg: "STR_STANDBY_BTN_AGREE"
               btn_id: CONST.BUTTON_AGREE
               bDis:  false     // 초기값이 활성화
               bPressed: false
            }
            ListElement /** CONST.const_BUTTON_LANGUAGE */
            {
                msg: "STR_STANDBY_BTN_LANGUAGE"
               btn_id:  CONST.BUTTON_LANGUAGE
               bDis:  false
               bPressed: false
            }
//            ListElement /** CONST.const_BUTTON_USER_GUIDE */
//            {
//                msg: "STR_STANDBY_BTN_USER_GUIDE"
//               btn_id: CONST.BUTTON_USER_GUIDE
//               bDis:  true
//               bPressed: false
//            }
         }

         delegate: Image /** Button background image */
         {
            width: sourceSize.width
            height: sourceSize.height
            source: !focusVisible ? Images.STANDBY_BUTTON_N
                    : ( bPressed || ( focusIndex == index && jogPressed )) && !bDis ? Images.STANDBY_BUTTON_P
                    : ( focusIndex == index ) && !bDis ? Images.STANDBY_BUTTON_F
                    : Images.STANDBY_BUTTON_N

            Text /** Text on button */
            {
                anchors.centerIn: parent
                width: 572; height: sourceSize.height
                color: vehicleVariant == 1 ? (bDis ? General.const_COLOR_TEXT_DISABLE_GREY
                                                            :  focusIndex == index ? General.const_COLOR_TEXT_BRIGHT_GREY : General.const_COLOR_TEXT_COMMON_GREY )
                            : bDis ? General.const_APP_SETTINGS_COLOR_TEXT_BLACK : General.const_COLOR_TEXT_BRIGHT_GREY
                font.pixelSize: General.const_APP_SETTINGS_FONT_SIZE_TEXT_32PT
                font.family: General.FONT_BOLD
                wrapMode: Text.WordWrap; textFormat: Text.RichText
                text: qsTranslate("main", msg).length > 17
                    ? "<div style=\"line-height:36px\">" + qsTranslate( "main", msg)  + EngineListener.empty + "</div>" : qsTranslate( "main", msg)  + EngineListener.empty
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea
            {
               id: mouseArea
               enabled: mergeMain.focusIndex == General.const_APP_STANDBYCLOCK_FOCUSINDEX_STANDBY_MAIN && !bDis && !bLaunchApp//  && isMainScreen  && !bLaunchApp
               anchors.fill: parent
               noClickAfterExited: true
               onClicked:
               {
                   bLaunchApp = true
                   btn_id == CONST.BUTTON_LANGUAGE ? focusIndex = 1 : focusIndex = 0
                   if ( runPressTimer ) {
                       maClicked = true
                       clicked_btn_id = btn_id
                       return;
                   }
                   hide_screen_timer.stop()
                   buttons.set( CONST.BUTTON_AGREE, { bPressed: false } )
                   buttons.set( CONST.BUTTON_LANGUAGE, { bPressed: false } )
//                   buttons.set( CONST.BUTTON_USER_GUIDE, { bPressed: false } )
                   maPressed = false
                   btn_id == CONST.BUTTON_LANGUAGE ? focusIndex = 1 : focusIndex = 0
//                   btn_id == CONST.BUTTON_LANGUAGE ? focusIndex = 0 :
//                                    btn_id == CONST.BUTTON_AGREE ? focusIndex = 1 : focusIndex = 2
                   EngineListener.LaunchApplication( btn_id, UIListener.getCurrentScreen() );
                   EngineListener.playAudioBeep();
               }
               onPressed:
               {
                   hide_screen_timer.stop()
                   maPressed = true
                   EngineListener.setTime( true );
                   if ( btn_id == CONST.BUTTON_AGREE ) buttons.set( CONST.BUTTON_AGREE, { bPressed: true } )
                   else if ( btn_id == CONST.BUTTON_LANGUAGE )  buttons.set( CONST.BUTTON_LANGUAGE, { bPressed: true } )
//                   else if ( btn_id == CONST.BUTTON_USER_GUIDE ) buttons.set( CONST.BUTTON_USER_GUIDE, { bPressed: true } )
                   runPressTimer = true
                   press_timer.restart()
//                   btn_id == CONST.BUTTON_LANGUAGE ? focusIndex = 0 :
//                                    btn_id == CONST.BUTTON_AGREE ? focusIndex = 1 : focusIndex = 2
               }
               onExited:
               {
                   maReleased = true
                   if ( !runPressTimer ) {
                       maReleased = false
                       buttons.set( CONST.BUTTON_AGREE, { bPressed: false } )
                       buttons.set( CONST.BUTTON_LANGUAGE, { bPressed: false } )
//                       buttons.set( CONST.BUTTON_USER_GUIDE, { bPressed: false } )
                   }
               }
               onReleased:
               {
                   hide_screen_timer.restart()
               }
            }
         }
      }
   }

   // press image timer
   Timer
   {
      id: press_timer
      interval: 500
      repeat: false
      onTriggered:
      {
          if ( mergeMain.focusIndex != General.const_APP_STANDBYCLOCK_FOCUSINDEX_STANDBY_MAIN ) return;
          runPressTimer = false
          if ( maClicked ) {
              buttons.set( CONST.BUTTON_AGREE, { bPressed: false } )
              buttons.set( CONST.BUTTON_LANGUAGE, { bPressed: false } )
//              buttons.set( CONST.BUTTON_USER_GUIDE, { bPressed: false } )
              maPressed = false
              clicked_btn_id == CONST.BUTTON_LANGUAGE ? focusIndex = 1 :focusIndex = 0
//              clicked_btn_id == CONST.BUTTON_LANGUAGE ? focusIndex = 0 :
//                               clicked_btn_id == CONST.BUTTON_AGREE ? focusIndex = 1 : focusIndex = 2
              EngineListener.LaunchApplication( clicked_btn_id, UIListener.getCurrentScreen() );
              maClicked = false
          }
          else if ( maReleased ){
              maReleased = false
              buttons.set( CONST.BUTTON_AGREE, { bPressed: false } )
              buttons.set( CONST.BUTTON_LANGUAGE, { bPressed: false } )
//              buttons.set( CONST.BUTTON_USER_GUIDE, { bPressed: false } )
          }
      }
   }

   // Auto disapear agreement screen ( 5 sec )
   Timer
   {
      id: hide_screen_timer
      interval: General.const_APP_SETTINGS_AUTO_DISAPPEAR * 2            // DH, KH, VI 전향지 10초
      repeat: false
      onTriggered:
      {
//          if ( (cv > 1 && cv < 6) || cv > 6 ) return;     // 내수/북미만 적용 => 모든 향지 적용으로 사양 변경. 2013.11.20
         if ( autoDisappear )
             {
            EngineListener.LaunchApplication( CONST.BUTTON_AGREE, UIListener.getCurrentScreen()  );
         }
      }
   }

   Connections
   {
       target: EngineListener

       onSignalFg:
       {
           langID = EngineListener.GetLanguageID()
           buttons.set( CONST.BUTTON_AGREE, { bPressed: false } )
           buttons.set( CONST.BUTTON_LANGUAGE, { bPressed: false } )
           jogPressed = false
       }

       onSetAutoDisappear:
       {
           autoDisappear = disappear
       }

        onRetranslateUI: getLang();

        onSignalSetLanguage: {
            if ( mainScreen ) {
                idLangLoader.source = ""
                idLangLoader.visible = false
            }
            else {
                idLangLoader.source =  "DHAVN_AppStandBy_Language.qml"
                idLangLoader.visible = true;
            }
            isMainScreen = mainScreen;//setLang();
            jogPressed = false
        }

        onSignalSetDefaultFocus: {
            focusIndex = 0;
        }

        onSignalAutoDisappearTimer:
        {
            if ( screenId != UIListener.getCurrentScreen() )  return;
           {
              if( status ) {
                  autoDisappear = true
                  hide_screen_timer.restart();
              }
              else {
                  hide_screen_timer.stop();
              }
           }
        }
        onSignalEmergency:
        {
            if(evvVariant != 2){ // preceed when not in case DHPE
                sigEmergency = bEmergen
                bLaunchApp = false;
                focusIndex = 0;
                buttons.set( CONST.BUTTON_LANGUAGE, { bDis: true } )
                 buttons.set( CONST.BUTTON_AGREE, { bDis: false } )
     //           buttons.set( CONST.BUTTON_USER_GUIDE, { bDis: true } )
            }
        }

        onSignalLoadingCompleted:
        {
            jogPressed = false
           buttons.set( CONST.BUTTON_AGREE, { bDis: false } )
           buttons.set( CONST.BUTTON_LANGUAGE, { bDis: false } )
//           buttons.set( CONST.BUTTON_USER_GUIDE, { bDis: false } )
        }
        onSetLaunchApp:
        {
            bLaunchApp = launchApp;
        }
        onSignalJog:
        {
            if ( bLaunchApp || /*!isMainScreen &&*/ mergeMain.focusIndex != General.const_APP_STANDBYCLOCK_FOCUSINDEX_STANDBY_MAIN ) return;
            if ( screenId != UIListener.getCurrentScreen() )  return;
            if ( status == 0 )
            {
                if ( focusIndex < 0 ) focusIndex = 1
                else
                {
                    switch ( arrow )
                    {
                        case UIListenerEnum.JOG_WHEEL_LEFT:
                        {
                            if ( sigEmergency ) {
                                return;
                            }
                            if( langID == 20 )
                            {
                               if ( focusIndex < (buttons.count - 1 ) )
                                   focusIndex++;
                               else
                                   focusIndex = 0
                            }
                            else
                            {
                                if ( focusIndex > 0 )
                                    focusIndex--
                                else
                                    focusIndex = buttons.count-1
                            }
                            hide_screen_timer.restart();
                        }
                            break
                        case UIListenerEnum.JOG_WHEEL_RIGHT:
                        {
                            if ( sigEmergency ) {
                                return;
                            }
                            if( langID == 20 )
                            {
                               if ( focusIndex  > 0 )
                                   focusIndex--;
                               else
                                   focusIndex = buttons.count - 1
                            }
                            else
                            {
                                if ( focusIndex < (buttons.count - 1 ) )
                                    focusIndex++;
                                else
                                    focusIndex = 0
                            }
                            hide_screen_timer.restart();
                        }
                            break
                        case UIListenerEnum.JOG_LEFT:
                        {
                            if( langID == 20 )
                            {
                               if ( focusIndex < (buttons.count - 1 ) )
                                   focusIndex++;
                               else
                                   focusIndex == 0
                            }
                            else
                            {
                                if ( focusIndex > 0 )
                                    focusIndex--
                                else
                                    focusIndex = buttons.count-1
                            }
                            hide_screen_timer.stop();
                        }
                            break
                        case UIListenerEnum.JOG_RIGHT:
                        {
                            if( langID == 20 )
                            {
                               if ( focusIndex  > 0 )
                                   focusIndex--;
                               else
                                   focusIndex = buttons.count - 1
                            }
                            else
                            {
                                if ( focusIndex < (buttons.count - 1 ) )
                                    focusIndex++;
                                else
                                    focusIndex = 0
                            }
                            hide_screen_timer.stop();
                        }
                            break
                        case UIListenerEnum.JOG_CENTER:
                        {
                            jogPressed = true;
                            jogCenterPressed = true
                            hide_screen_timer.stop();
                        }
                    }
                }
            }
            else if ( status == 1)
            {
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_CENTER:
                    {
                        if ( !jogCenterPressed ) return;
                        jogCenterPressed = false
                        jogPressed = false;
                        if((focusIndex > -1 ) && (focusIndex < buttons.count) && !buttons.get(focusIndex).bDis )
                        {
                            hide_screen_timer.stop();
                            EngineListener.LaunchApplication( buttons.get(focusIndex).btn_id, UIListener.getCurrentScreen() );
                        }
                        break
                    }
                    default:
                        hide_screen_timer.restart();
                }
            }
            else if ( status == 4 && arrow == UIListenerEnum.JOG_CENTER  ) {
                jogPressed = false;
            }
        }
   }

   Connections
   {
       target: UIListener
       onSignalShowSystemPopup:
       {
           focusVisible = false
       }
       onSignalHideSystemPopup:
       {
           focusVisible = true
       }
   }

    Loader
    {
        id: idLangLoader
        anchors.fill: parent
        source: "DHAVN_AppStandBy_Language.qml"
        visible: !isMainScreen
    }
}
