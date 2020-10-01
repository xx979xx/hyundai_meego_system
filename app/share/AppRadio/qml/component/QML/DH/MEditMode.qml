/**
 * FileName: MEditMode.qml
 * Author: David.Bae
 * Time: 2012-04-02
 *
 * - 2012-04-02 Initial Crated by Problem Kang
 */

import Qt 4.7
import "../../system/DH" as MSystem

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

    //------------------------------ background Image # by WSH
    Image{
        anchors.fill: parent
        source:imgFolderGeneral+"bg_edit_mode.png"
    }

    MButton{
        id:editButton1
        x:28
        y:buttonNumber==3?79:9
        focus:true
        width:214
        height:129
        bgImage:imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText1
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64
        firstTextSize: 32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"

        onClickOrKeySelected: {
            clickButton1()
        }
        KeyNavigation.down:editButton2
        // Updated jog_V1.3 (looping O) ------------------------------
        Keys.onPressed: {
            if(idAppMain.isWheelLeft(event)){ editButton4.focus = true }
            else if(idAppMain.isWheelRight(event)) { editButton2.focus = true }
        }
        //------------------------------ Updated jog_V1.3 (looping O) # by WSH
    }

    MButton{
        id:editButton2
        x:28
        anchors.top:editButton1.bottom
        anchors.topMargin: 5
        width:214
        height:129
        bgImage:imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText2
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64
        firstTextSize:32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"

        onClickOrKeySelected: {
            clickButton2()
        }
        KeyNavigation.up:editButton1
        KeyNavigation.down:editButton3
        // Updated jog_V1.3 (looping O) ------------------------------
        Keys.onPressed: {
            if(idAppMain.isWheelLeft(event)){ editButton1.focus = true }
            else if(idAppMain.isWheelRight(event)) { editButton3.focus = true }
        }
        //------------------------------ Updated jog_V1.3 (looping O) # by WSH
    }

    MButton{
        id:editButton3
        x:28
        anchors.top:editButton2.bottom
        anchors.topMargin: 5
        width:214
        height:129
        bgImage:imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText3
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64
        firstTextSize:32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"

        onClickOrKeySelected: {
            clickButton3()
        }
        KeyNavigation.up:editButton2
        KeyNavigation.down:buttonNumber==3?editButton3:editButton4

        // Updated jog_V1.3 (looping O) ------------------------------
        Keys.onPressed: {
            if(idAppMain.isWheelLeft(event)){
                editButton2.focus = true
            }
            else if(idAppMain.isWheelRight(event)) {
                if(buttonNumber==3){
                    editButton1.focus
                }else if(buttonNumber==4){
                    editButton4.focus = true
                } // End if
            } // End if
        }
        //------------------------------ Updated jog_V1.3 (looping O) # by WSH
    }

    MButton{
        id:editButton4
        x:28
        anchors.top:editButton3.bottom
        anchors.topMargin: 5
        visible:buttonNumber==3?false:true
        width:214
        height:129
        bgImage:imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"
        bgImageFocusPress: imgFolderGeneral+"btn_edit_mode_fp.png"

        firstText: buttonText4
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64
        firstTextSize:32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"

        onClickOrKeySelected: {
            clickButton4()
        }
        KeyNavigation.up:editButton3

        // Updated jog_V1.3 (looping O) ------------------------------
        Keys.onPressed: {
            if(idAppMain.isWheelLeft(event)){ editButton3.focus = true }
            else if(idAppMain.isWheelRight(event)) { editButton1.focus = true }
        }
        //------------------------------ Updated jog_V1.3 (looping O) # by WSH
    }
}
