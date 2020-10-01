import QtQuick 1.1
import "../system" as MSystem

MComponent{
    id:idAVMCalibCmd
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.StringInfo {id:stringInfo}

    focus: true

    property string reInputTxt : "Re-input" //STR_CAMERA_CALIB6
    property string updateTxt : "Update" //STR_CAMERA_CALIB7

    Component.onCompleted: {
        reInputBtn.focus = true;
        //For AutoTest
        UIListener.SendAutoTestSignal()
    }

    // x, y coordinate Area
    Item {
        //color: "green"
        x:0; y:610
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            onReleased: { //onClicked: {
                canCon.sendPointXY(mouse.x, mouse.y);
            }
        }
    }

    //Re-input btn
    MButton {
        id: reInputBtn
        x:12; y: 622
        width: 310; height: 66

        focus: true

        bgImage:systemInfo.imageInternal+"btn_dab_n.png"
        bgImagePress:systemInfo.imageInternal+"btn_dab_p.png"
        bgImageActive:bgImagePress
        bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
        firstText: reInputTxt
        firstTextSize: systemInfo.btnFontSize

        onClickOrKeySelected: {
            canCon.selectAVMCalCmd(2); //re-enter
        }

        KeyNavigation.right: updateBtn
        onWheelLeftKeyPressed: updateBtn.forceActiveFocus()
        onWheelRightKeyPressed: updateBtn.forceActiveFocus()
    }

    //update btn
    MButton {
        id: updateBtn
        x:946+12; y: reInputBtn.y
        width: reInputBtn.width; height: reInputBtn.height
        bgImage:systemInfo.imageInternal+"btn_dab_n.png"
        bgImagePress:systemInfo.imageInternal+"btn_dab_p.png"
        bgImageActive:bgImagePress
        bgImageFocus: systemInfo.imageInternal+"bg_camera_tab_f.png"
        firstText: updateTxt
        firstTextSize: systemInfo.btnFontSize

        onClickOrKeySelected: {
            canCon.selectAVMCalCmd(1); //update
        }

        KeyNavigation.left: reInputBtn
        onWheelLeftKeyPressed: reInputBtn.forceActiveFocus()
        onWheelRightKeyPressed: reInputBtn.forceActiveFocus()
    }


}
