import QtQuick 1.1
import QmlPopUpPlugin 1.0
import QmlHomeScreenDefPrivate 1.0
import PopUpConstants 1.0

PopUpText {
   id: popUp

   buttons: ViewControll.nPopUpType == EHSDefP.POPUP_MAX_BT_ANDROIDAUTO  ? yesNoBtnModel : buttonModel
   //focus_visible: ( focus_id == View.nFocusIndex ) && ViewControll.bFocusEnabled
   focus_id: EHSDefP.FOCUS_INDEX_POPUP
   //icon_title: EPopUp.WARNING_ICON
   //title: ""
   message: ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_MEDIA ) ? noMediaModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_VR_NOT_SUPPORT ) ? vrNotSupport :
            //( ViewControll.nPopUpType == EHSDefP.POPUP_IGN_OFF ) ? ignOffModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_SDCARD  ) ? noSDCARD :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_SDCARD_NOT_SUPPORT_PREMIUM20  ) ? noPREMIUM20 :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_IMAGE  ) ? noImageModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_IMAGE_IN_USB  ) ? noImageInUsbModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_IMAGE_IN_JBOX ) ? noImageInJboxModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_MUSIC  ) ? noMusicModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_MUSIC_IN_USB  ) ? noMusicInUsbModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_MUSIC_IN_JBOX ) ? noMusicInJboxModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_VIDEO  ) ? noVideoModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_VIDEO_IN_USB  ) ? noVideoInUsbModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_VIDEO_IN_JBOX ) ? noVideoInJboxModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_RESTRICTION ) ? restrictionPopUp :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NO_PHONE_CONNECTED ) ? noPhoneConnectedPopUp :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_NOT_USE_BLUELINK_PHONE ) ? notUseBluelinkPhone :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_LOCAL_IGN ) ? ignOffModel :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_LOCAL_BLUELINK ) ? waitInitBlueLink :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_LOCAL_DRS ) ? restrictionPopUp :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_DISABLE_BT_MUSIC ) ? btMusicDisable :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_HELP_NOT_SUPPORT ) ? vrNotSupport :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_CONNECTIVITY_DISCONNECTED ) ? connectivityDisconnected :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_CONNECTIVITY_DISABLE ) ? connectivityDisable :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_CONNECTIVITY_SETTINGS_DISABLE) ? connectivitySettingsDisable :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_SYSTEM_INFO_SETTINGS_DISABLE) ? systemInfoSettingsDisable :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_DISABLE_CONNECTIVITY_BLCALL ) ? connectivityDisableBLCall :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_DISABLE_CONNECTIVITY_BTCALL ) ? connectivityDisableBTCall :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_DISABLE_AV_CALL ) ? disableAVCall :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_DISABLE_AV_VR ) ? disableAVSiri :
            ( ViewControll.nPopUpType == EHSDefP.POPUP_MAX_BT_ANDROIDAUTO ) ? maxBtAndroidAuto : null
            //( ViewControll.nPopUpType == EHSDefP.POPUP_PREPARING ) ? preparing : null
   //STR_SDCARD_NOT_SUPPORT_PREMIUM20

   onBtnClicked: {
      //console.log( "DHAVN_AppHomeScreen_PopUp.qml::onBtnClicked: btnId = " + btnId )

       if ( ViewControll.nPopUpType == EHSDefP.POPUP_MAX_BT_ANDROIDAUTO ) {
           EngineListener.hideLocalPopup(UIListener.getCurrentScreen())

           if ( btnId == 0 ) {
               EngineListener.LaunchApplication( EHSDefP.APP_ID_BT_PHONE, -1, UIListener.getCurrentScreen(), ViewControll.GetDisplay() , "" );
           }
           else {
               EngineListener.LaunchApplication( EHSDefP.APP_ID_ANDROID_AUTO, -1, UIListener.getCurrentScreen(), ViewControll.GetDisplay() , "" );
           }
       }
       else {
           if( 0 == btnId ) EngineListener.hideLocalPopup(UIListener.getCurrentScreen())
       }
   }

   ListModel {
      id: systemInfoSettingsDisable
      ListElement { msg: QT_TR_NOOP("STR_SYSTEM_INFO_DISABLE") }
   }

   ListModel {
      id: maxBtAndroidAuto
      ListElement { msg: QT_TR_NOOP("STR_MAX_BT_AAP") }
   }

   ListModel {
      id: connectivitySettingsDisable
      ListElement { msg: QT_TR_NOOP("STR_CONNECTIVITY_SETTINGS_DISABLE") }
   }

   ListModel {
      id: connectivityDisconnected
      ListElement { msg: QT_TR_NOOP("STR_CONNECTIVITY_DISCONNECTED") }
   }

   ListModel {
      id: connectivityDisable
      ListElement { msg: QT_TR_NOOP("STR_CONNECTIVITY_DISABLE") }
   }

   ListModel {
       id: connectivityDisableBLCall
       ListElement { msg: QT_TR_NOOP("STR_CONNECTIVITY_DISABLE_BLCALL") }
   }

   ListModel {
       id: connectivityDisableBTCall
       ListElement { msg: QT_TR_NOOP("STR_CONNECTIVITY_DISABLE_BTCALL") }
   }

   ListModel {
       id: disableAVCall
       ListElement { msg: QT_TR_NOOP("STR_DISABLE_AV_CALL") }
   }

   ListModel {
       id: disableAVSiri
       ListElement { msg: QT_TR_NOOP("STR_DISABLE_AV_SIRI") }
   }

   ListModel {
      id: vrNotSupport
      ListElement { msg: QT_TR_NOOP("STR_VR_NOT_SUPPORT") }
   }

   ListModel {
      id: ignOffModel
      ListElement { msg: QT_TR_NOOP("STR_IGN_OFF") }
   }

   ListModel {
      id: noSDCARD
      ListElement { msg: QT_TR_NOOP("STR_NO_SDCARD") }
   }

   ListModel {
      id: noPREMIUM20
      ListElement { msg: QT_TR_NOOP("STR_SDCARD_NOT_SUPPORT_PREMIUM20") }
   }

   ListModel {
      id: noPhoneConnectedPopUp
      ListElement { msg: QT_TR_NOOP("STR_NO_PHONE_CONNECTED") }
   }

   ListModel {
      id: noMediaModel
      ListElement { msg: QT_TR_NOOP("STR_NO_MEDIA_FILE") }
   }

   ListModel {
      id: noImageModel
      ListElement { msg: QT_TR_NOOP("STR_NO_MEDIA_FILE") }
   }

   ListModel {
      id: noImageInJboxModel
      ListElement { msg: QT_TR_NOOP("STR_HOME_MEDIA_NO_IMAGE_IN_JUKEBOX") }
   }

   ListModel {
      id: noImageInUsbModel
      ListElement { msg: QT_TR_NOOP("STR_HOME_MEDIA_NO_IMAGE_IN_USB") }
   }

   ListModel {
      id: noMusicModel
      ListElement { msg: QT_TR_NOOP("STR_NO_MEDIA_FILE") }
   }

   ListModel {
      id: noMusicInJboxModel
      ListElement { msg: QT_TR_NOOP("STR_HOME_NO_MUSIC_FILE_IN_JBOX") }
   }

   ListModel {
      id: noMusicInUsbModel
      ListElement { msg: QT_TR_NOOP("STR_HOME_NO_MUSIC_FILE_IN_USB") }
   }

   ListModel {
      id: noVideoModel
      ListElement { msg: QT_TR_NOOP("STR_NO_MEDIA_FILE") }
   }

   ListModel {
      id: noVideoInJboxModel
      ListElement { msg: QT_TR_NOOP("STR_HOME_NO_VIDEO_FILE_IN_JBOX") }
   }

   ListModel {
      id: noVideoInUsbModel
      ListElement { msg: QT_TR_NOOP("STR_HOME_NO_VIDEO_FILE_IN_USB") }
   }

   ListModel {
      id: restrictionPopUp
      ListElement { msg: QT_TR_NOOP("STR_HOME_MEDIA_CAPTION_VIDEO_DISABLED_INFO") }
   }

   ListModel {
      id: buttonModel
      ListElement { msg: QT_TR_NOOP("STR_POPUP_OK"); btn_id: 0 }
   }

   ListModel {
      id: notButtonModel
   }

   ListModel {
      id: notUseBluelinkPhone
      ListElement { msg: QT_TR_NOOP("STR_HOME_NOT_USE_BLUELINK_PHONE") }
   }

   //ListModel {
//      id: preparing
//      ListElement { msg: QT_TR_NOOP("STR_HOME_PREPARING") }
//   }

   ListModel {
      id: waitInitBlueLink
      ListElement { msg: QT_TR_NOOP("STR_HOME_WAIT_INIT_BLUELINK_POPUP") }
   }

   ListModel {
      id: btMusicDisable
      ListElement { msg: QT_TR_NOOP("STR_HOME_BT_MUSIC_DISABLE") }
   }

   Component.onCompleted: setDefaultFocus( 0 )
}
