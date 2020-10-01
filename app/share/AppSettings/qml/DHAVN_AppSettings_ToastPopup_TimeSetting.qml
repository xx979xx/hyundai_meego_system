import QtQuick 1.1
import QmlPopUpPlugin 1.0
import PopUpConstants 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_General.js" as HM

Item{
    id: toastPopup

    x: 0; y: 93; width: 1280; height: 720 -93
    visible: false

    signal closePopUp(bool isReceivedEvent)

    function showPopUp()
    {
        toastPopup.visible = true
    }

    function hidePopUp()
    {
        toastPopup.visible = false
    }

    Connections{
        target: (toastPopup.visible) ? UIListener : null

        onSignalJogNavigation:
        {
            switch ( arrow )
            {
            case UIListenerEnum.JOG_UP:
            case UIListenerEnum.JOG_RIGHT:
            case UIListenerEnum.JOG_DOWN:
            case UIListenerEnum.JOG_LEFT:
            case UIListenerEnum.JOG_CENTER:
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                    toastPopup.closePopUp(true)
            }
            break
            }
        }
    }

    PopUpToast{
        id: toastTimeSetPopup
        y:-93
        icon_title: EPopUp.NONE_ICON
        listmodel: timeSettingModel
        bHideByTimer:false
    }

    MouseArea{
        id: popupArea
        anchors.fill: parent
        beepEnabled: false

        onClicked:
        {
            //console.log("[QML][TimeSetPopup]onClicked:")
            toastPopup.closePopUp(true)
        }
    }

    ListModel{
        id: timeSettingModel
        ListElement{ msg: QT_TR_NOOP("STR_SETTING_CLOCK_TIME_SETTING_COMPLETED") }
    }
}

