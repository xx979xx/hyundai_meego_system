/* 
 * /BT_arabic/Band/BtSettingsBand.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.DDSimpleBand
{
    id: idSettingsBand
    focus: true

    titleText: stringInfo.str_Bluetooth

    menuBtnFlag: "SettingsBtDeviceConnect" == idAppMain.state //(true == idMenu.loaded)  ? true : false
    menuBtnText: stringInfo.str_Menu


    /* Event handlers
     */
    Component.onCompleted: {
        console.log("# idSettingsBand.onCompleted");
    }

    Component.onDestruction: {
        console.log("# idSettingsBand.onDestruction");
    }

    onBackBtnClicked: {
        if(popupState == "" && (callViewState == "BACKGROUND" || callViewState == "IDLE")) {
            idSettingsViewContainer.backKeyHandler();
        }
    }

    onActiveFocusChanged: {
        if(true == idSettingsBand.activeFocus) {
            idVisualCue.setVisualCue(false, false, true, false);
        }
    }
}
/* EOF*/
