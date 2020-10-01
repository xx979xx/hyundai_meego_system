/**
 * BtDialOptionMenu.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MOptionMenu
{
    id: idBtDialOptionMenu
    linkedModels: dialListModel
    focus: true
    visible: true

    /* CarPlay */
    menu0TextColor: (true == projectionOn) ? colorInfo.disableGrey : colorInfo.subTextGrey

    /* LISTMODEL */
    ListModel {
        id: dialListModel

        ListElement { name:"";      opType: "" }
    }


    /* CONNECTIONS */
    Connections {
        target: UIListener

        onRetranslateUi: {
            idBtDialOptionMenu.linkedModels.get(0).name = stringInfo.str_Con_Menu_Setting
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        idBtDialOptionMenu.linkedModels.get(0).name = stringInfo.str_Con_Menu_Setting
    }

    onVisibleChanged: {
        if(true == idBtDialOptionMenu.visible) {
            idBtDialOptionMenu.linkedModels.get(0).name = stringInfo.str_Con_Menu_Setting
        }
    }

    onMenu0Click: {
        idMenu.off();

        if(9 < BtCoreCtrl.m_ncallState) {
            /* 통화중일 경우 진입 막음
             */
            MOp.showPopup("popup_bt_invalid_during_call");
        } /* CarPlay */
        else if(true == projectionOn) {
            MOp.showPopup("popup_Bt_enter_setting_during_CarPlay")
        }

        else {
            //settingCurrentIndex = 0;

            // Go to the settings
            btSettingsEnter = false;
            pushScreen("SettingsBtDeviceConnect", 503);
        }
    }

    onOptionMenuFinished: {
        if(true == visible) {
            idMenu.hide();
        }
    }

    onClickDimBG: {
        idMenu.hide();
    }
}
/* EOF */
