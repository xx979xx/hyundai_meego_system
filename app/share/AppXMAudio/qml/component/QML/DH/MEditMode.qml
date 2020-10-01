/**
 * FileName: MEditMode.qml
 * Author: David.Bae
 * Time: 2012-04-02
 *
 * - 2012-04-02 Initial Crated by Problem Kang
 * - 2013-01-03 Updated Component (MComponent.qml) by WSH
 * - 2013-01-03 Added property (firstTextEnabled) by WSH
 */

import Qt 4.7

MComponent{
    id:idEditMode

    property int buttonNumber: 4
    width:250; height: systemInfo.contentAreaHeight
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    property string buttonText1 : "Btn1Line"
    property string buttonText2 : "Btn2Line"
    property string buttonText3 : "Btn3Line"
    property string buttonText4 : "Btn4Line"

    property alias buttonEnabled1: editButton1.mEnabled;
    property alias buttonEnabled2: editButton2.mEnabled;
    property alias buttonEnabled3: editButton3.mEnabled;
    property alias buttonEnabled4: editButton4.mEnabled;

    signal clickButton1()
    signal clickButton2()
    signal clickButton3()
    signal clickButton4()

    //------------------------------ Focus position as EditButton
    function setfocusPosition(editButtonNum){
        if(editButtonNum == 1) editButton1.focus = true;
        else editButton2.focus = true;
    }

    //------------------------------ background Image # by WSH
    Image{
        anchors.fill: parent
        source:imageInfo.imgFolderGeneral+"bg_edit_mode.png"
    }

    MButton{
        id: editButton1
        x: 28
        y: (buttonNumber==3) ? 79 : 9
        width: 214
        height: 129

        bgImage:imageInfo.imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imageInfo.imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imageInfo.imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText1
        firstTextX: 6
        firstTextY: 64
        firstTextWidth: 202
        firstTextSize: 32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextEnabled: buttonEnabled1
        firstTextDisableColor: "#42454A"

        onClickOrKeySelected: {
            clickButton1()
        }

        onWheelRightKeyPressed: editButton2.focus = true
    }

    MButton{
        id: editButton2
        x: 28
        y: editButton1.y+134
        width: 214
        height: 129
        focus: true

        bgImage:imageInfo.imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imageInfo.imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imageInfo.imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText2
        firstTextX: 6
        firstTextY: (buttonfirsttextCount.lineCount == 2) ? 40 : 64
        firstTextWidth: 202
        firstTextSize: 32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextEnabled: buttonEnabled2
        firstTextDisableColor: "#42454A"
        firstTextWrapMode: true

        onClickOrKeySelected: {
            clickButton2()
        }

        onWheelLeftKeyPressed: {
            if(buttonEnabled1==true) editButton1.focus = true
            else editButton2.focus = true
        }
        onWheelRightKeyPressed: {
            if(buttonEnabled3==true) editButton3.focus = true
            else editButton4.focus = true
        }
    }

    MButton{
        id: editButton3
        x: 28
        y: editButton1.y+134+134
        width: 214
        height: 129

        bgImage:imageInfo.imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imageInfo.imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imageInfo.imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText3
        firstTextX: 6
        firstTextY: (buttonfirsttextCount.lineCount == 2) ? 40 : 64
        firstTextWidth: 202
        firstTextSize: 32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextEnabled: buttonEnabled3
        firstTextDisableColor: "#42454A"
        firstTextWrapMode: true

        onClickOrKeySelected: {
            clickButton3()
        }

        onWheelLeftKeyPressed: { editButton2.focus = true }
        onWheelRightKeyPressed: {
            if(buttonEnabled4==true){ editButton4.focus = true; }
            else{ editButton3.focus = true }
        }
    }

    MButton{
        id: editButton4
        x: 28
        y: editButton1.y+134+134+134
        width: 214
        height: 129
        visible: (buttonNumber==3) ? false : true

        bgImage:imageInfo.imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imageInfo.imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imageInfo.imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText4
        firstTextX: 6
        firstTextY: 64
        firstTextWidth: 202
        firstTextSize: 32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextEnabled: buttonEnabled4
        firstTextDisableColor: "#42454A"

        onClickOrKeySelected: {
            clickButton4()
        }

        onWheelLeftKeyPressed: {
            if(buttonEnabled3==true) editButton3.focus = true
            else editButton2.focus = true
        }
    }
}
