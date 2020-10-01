import QtQuick 1.0
import QmlPopUpPlugin 1.0
import PopUpConstants 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_General.js" as HM

Item{
    id: toastPopup

    x: 0; y: 93; width: 1280; height: 720 -93
    visible: false

    function showPopUp()
    {
        toastPopup.visible = true
    }

    function hidePopUp()
    {
        toastPopup.visible = false
    }

    PopUpText{
        id: popup
        y: -93
        z: 10000
        message: messageModel
        icon_title: EPopUp.LOADING_ICON
    }

    ListModel{
        id: messageModel
        ListElement{
            msg: QT_TR_NOOP("STR_SETTING_SYSTEM_JUKEBOX_FORMATTING")
        }
    }    
}

