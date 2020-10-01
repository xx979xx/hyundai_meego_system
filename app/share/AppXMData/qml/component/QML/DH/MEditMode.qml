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
import QtQuick 1.1

MComponent{

    id:idEditMode

    property int buttonNumber: 4
    width:256; height: systemInfo.contentAreaHeight
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

    onButtonEnabled1Changed: {
        checkFocus();
    }
    onButtonEnabled2Changed: {
        checkFocus();
    }
    onButtonEnabled3Changed: {
        checkFocus();
    }
    onButtonEnabled4Changed: {
        checkFocus();
    }

    //------------------------------ background Image # by WSH
    Image{
        anchors.fill: parent
        source:imageInfo.imgFolderGeneral+"bg_edit_mode.png"
    }

    MButton{
        id:editButton1
        x:30
        y:buttonNumber==3?79:9
        focus:true
        width:214
        height:129
        bgImage:imageInfo.imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imageInfo.imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imageInfo.imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText1
        firstTextX: 6
        firstTextSize: 31
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.font_NewHDB
        firstTextDisableColor: colorInfo.disableGrey
        enabled: buttonEnabled1 // <<----- Added by WSH (130103)

        onClickOrKeySelected: {
            clickButton1()
        }
        Keys.onPressed: {
            if(idAppMain.isWheelRight(event)) {
                if(buttonEnabled2)
                    editButton2.focus = true;
                else if(buttonEnabled3)
                    editButton3.focus = true;
                else if(buttonEnabled4)
                    editButton4.focus = true;
            }



            //else if(idAppMain.isWheelLeft(event)){ editButton4.focus = true } //remove 2012-12-10 jyjeon : if one page, no wrapping around (ISV 64311)
        }
        //------------------------------ Updated jog_V1.3 (looping O) # by WSH
    }

    MButton{
        id:editButton2
        x:30
        anchors.top:editButton1.bottom
        anchors.topMargin: 5
        width:214
        height:129
        bgImage:imageInfo.imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imageInfo.imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imageInfo.imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_edit_mode_fp.png"

        Text {
            id: idText2Line2
//            x: 30; y: -6
//            width: 135
//            height: parent.height
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 10
            text: buttonText2
            font.pixelSize:31
            font.family: systemInfo.font_NewHDB
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            opacity: buttonEnabled2 ? 1 : 0.5
            wrapMode: Text.Wrap
            lineHeight: 0.75
        }

//        firstText: buttonText2
//        firstTextX: 30//6
//        firstTextSize: 32
//        firstTextColor: colorInfo.brightGrey
//        firstTextStyle: systemInfo.font_NewHDB
//        firstTextDisableColor: "#42454A" // RGB(66,69,74) by WSH (130107)
//        enabled: buttonEnabled2

        onClickOrKeySelected: {
            clickButton2()
        }
//        KeyNavigation.up:editButton1
//        KeyNavigation.down:editButton3
        // Updated jog_V1.3 (looping O) ------------------------------
        Keys.onPressed: {
            if(idAppMain.isWheelLeft(event)){
                if(buttonEnabled1)
                    editButton1.focus = true;
            }
            else if(idAppMain.isWheelRight(event)) {
                if(buttonEnabled3)
                    editButton3.focus = true;
                else if(buttonEnabled4)
                    editButton4.focus = true;

            }
        }
        //------------------------------ Updated jog_V1.3 (looping O) # by WSH
    }

    MButton{
        id:editButton3
        x:30
        anchors.top:editButton2.bottom
        anchors.topMargin: 5
        focus:true
        width:214
        height:129
        bgImage:imageInfo.imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imageInfo.imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imageInfo.imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText3
        firstTextX: 6
        firstTextSize: 31
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.font_NewHDB
        firstTextDisableColor: colorInfo.disableGrey
        enabled: buttonEnabled3 // <<----- Added by WSH (130103)

        onClickOrKeySelected: {
            clickButton3()

            idList.focus = true;
        }
        Keys.onPressed: {
            if(idAppMain.isWheelLeft(event)){
                if(buttonEnabled2)
                    editButton2.focus = true;
                else if(buttonEnabled1)
                    editButton1.focus = true;
            }
            else if(idAppMain.isWheelRight(event)) {
                if(buttonNumber==3){
                }else if(buttonNumber==4){
                    if(buttonEnabled4)
                        editButton4.focus = true;
                } // End if
            } // End if
        }
    }

    MButton{
        id:editButton4
        x:30
        anchors.top:editButton3.bottom
        anchors.topMargin: 5
        visible:buttonNumber==3?false:true
        width:214
        height:129
        bgImage:imageInfo.imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imageInfo.imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imageInfo.imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText4
        firstTextX: 6
        firstTextSize:31
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.font_NewHDB
        enabled: buttonEnabled4 // <<----- Added by WSH (130103)

        onClickOrKeySelected: {
            clickButton4()
        }
        Keys.onPressed: {
            if(idAppMain.isWheelLeft(event)){
                if(buttonEnabled3)
                    editButton3.focus = true;
                else if(buttonEnabled2)
                    editButton2.focus = true;
                else if(buttonEnabled1)
                    editButton1.focus = true;
            }
        }
    }

    function checkFocus(){
        if(buttonEnabled1)
            editButton1.focus = true;
        else
            editButton2.focus = true;
    }
}
