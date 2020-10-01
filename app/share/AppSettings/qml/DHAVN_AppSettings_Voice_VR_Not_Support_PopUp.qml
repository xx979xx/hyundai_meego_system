import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.settings.defines 1.0
import com.settings.variables 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES

DHAVN_AppSettings_FocusedItem{
    id: root

    signal closePopUp(bool isYesPressed, int popup_type)

    x:0; y:0; width: 1280; height: 720

    name: "VRNotSupportPopUp"
    default_x: 0
    default_y: 0

    PopUpText{
        id: popup

        property int focus_x: 0
        property int focus_y: 0
        property string name: "PopUpText"
        focus_id: 0
        z: 10000

        //title: QT_TR_NOOP("STR_SETTING_INITIALIZE_RESET")
        message: messageModel
        buttons: buttonModel

        onBtnClicked:
        {
            switch ( btnId )
            {
            case "OkId":
            {
                closePopUp(true,Settings.SETTINGS_VR_NOT_SUPPORT_POPUP)
            }
            break
            }
        }
    }

    ListModel{
        id: buttonModel

        ListElement{
            msg: QT_TR_NOOP("STR_POPUP_OK")
            btn_id: "OkId"
        }
    }

    ListModel{
        id: messageModel
        ListElement{
            msg: QT_TR_NOOP("STR_SETTING_VOICE_VR_NOT_SUPPORT")
        }
    }
}
