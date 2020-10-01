/**
 * SettingsBTPinCodeChange.qml
 *
 */
import QtQuick 1.1
import "../../../../../QML/DH_arabic" as MComp
import "../../../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MComp.MComponent
{
    id: idSettingsBtPINCodeChange
    x: 0
    y: 0
    width: systemInfo.lcdWidth;
    height: systemInfo.subMainHeight
    focus:true

    // PROPERTIES
    property string changeLockNum: ""


    function backKeyHandler() {
        popScreen(315);
    }

    /* EVENT handlers */
    onBackKeyPressed: {
        idSettingsBtPINCodeChange.backKeyHandler();
    }

    /* WIDGETS */
    Image  {
        source: ImagePath.imgFolderGeneral + "bg_main.png"
        y: -93
    }

    MouseArea {
        anchors.fill: parent
        beepEnabled: false
    }

    MComp.DDSimpleBand  {
        id: idPincodeBand
        titleText: stringInfo.str_Passkey_Title

        onBackBtnClicked: {
            idSettingsBtPINCodeChange.backKeyHandler();
        }

        KeyNavigation.down: idSettingsBtPinCodeKeypad
    }

    Text {
        text: stringInfo.str_Passkey_Message
        x: 275
        y: 199 - systemInfo.statusBarHeight
        width: 720
        height: 32
        color: colorInfo.brightGrey
        horizontalAlignment: "AlignHCenter"
        font.pointSize: 32
        font.family: stringInfo.fontFamilyRegular    //"HDR"
    }

    SettingsBTPinCodeKeypad {
        id: idSettingsBtPinCodeKeypad
        x: 280
        y: 125
        focus: true

        KeyNavigation.up: idPincodeBand
    }
}
/* EOF */
