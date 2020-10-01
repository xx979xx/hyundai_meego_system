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
import "../../system/DH" as MSystem

MComponent{

    id:idEditMode

    property int buttonNumber: 4
    width:250; height: systemInfo.contentAreaHeight
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    property string buttonText1: "Btn1Line"
    property string buttonText2: "Btn2Line"
    property string buttonText3: "Btn3Line"
    property string buttonText4: "Btn4Line"

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
        source: imgFolderGeneral+"bg_edit_mode.png"
    }

    MButton{
        id: editButton1
        x: 28
        y: (buttonNumber == 3) ? 79 : 9
        width: 214
        height: 129
        bgImage: imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"

        firstText: buttonText1
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64
        firstTextSize: 32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: idAppMain.fontsB
        firstTextHorizontalAlies: "Center"
        firstTextEnabled: buttonEnabled1
        firstTextDisableColor: "#42454A"

        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                if(idAppMain.state == "AppDmbENGMode")
                {
                    editButton1.focus = true;
                }
                clickButton1()
            }
        }

        onClickReleased: {
            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
        }

//        KeyNavigation.down: editButton2
        Keys.onPressed: {
            if(idAppMain.isWheelRight(event)) { editButton2.focus = true }
            //else if(idAppMain.isWheelLeft(event)){ editButton4.focus = true } //remove 2012-12-10 jyjeon : if one page, no wrapping around (ISV 64311)
        }
    }

    MButton{
        id: editButton2
        x: 28
        focus: true
        anchors.top: editButton1.bottom
        anchors.topMargin: 5
        width: 214
        height: 129
        bgImage: imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"

        firstText: buttonText2
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64
        firstTextSize: 32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: idAppMain.fontsB
        firstTextHorizontalAlies: "Center"
        firstTextEnabled: buttonEnabled2
        firstTextDisableColor: "#42454A"

        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                if(idAppMain.state == "AppDmbENGMode")
                {
                    editButton2.focus = true;
                }
                clickButton2()
            }
        }

        onClickReleased: {
            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
        }

//        KeyNavigation.up: buttonEnabled1==true? editButton1 : editButton2
//        KeyNavigation.down: buttonEnabled3==true? editButton3 : editButton2

        Keys.onPressed: {
            if(idAppMain.isWheelLeft(event)){              
                //# Focus move when Enable/Disable - KEH (20130305)
                if(buttonEnabled1 == true) editButton1.focus = true
                else editButton2.focus = true
            }
            else if(idAppMain.isWheelRight(event)) {              
                //# Focus move when Enable/Disable - KEH (20130305)
                if(buttonEnabled3 == true) editButton3.focus = true
                else editButton4.focus = true
            }
        }
    }

    MButton{
        id: editButton3
        x: 28
        anchors.top: editButton2.bottom
        anchors.topMargin: 5
        width: 214
        height: 129
        bgImage: imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"

        firstText: buttonText3
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64
        firstTextSize: 32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: idAppMain.fontsB
        firstTextHorizontalAlies: "Center"
        firstTextEnabled: buttonEnabled3
        firstTextDisableColor: "#42454A"

        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                if(idAppMain.state == "AppDmbENGMode")
                {
                    editButton3.focus = true;
                }
                clickButton3()
            }
        }

        onClickReleased: {
            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
        }

//        KeyNavigation.up: editButton2
//        KeyNavigation.down: (buttonNumber==3) ? editButton3 : editButton4

        Keys.onPressed: {
            if(idAppMain.isWheelLeft(event)){
                editButton2.focus = true
            }
            else if(idAppMain.isWheelRight(event)) {
                if(buttonNumber == 3){
                    editButton1.focus
                }else if(buttonNumber == 4){
                    editButton4.focus = true
                } // End if
            } // End if
        }
    }

    MButton{
        id: editButton4
        x: 28
        anchors.top: editButton3.bottom
        anchors.topMargin: 5
        visible: (buttonNumber == 4) ? true : false
        width: 214
        height: 129
        bgImage: imgFolderGeneral+"btn_edit_mode_n.png"
        bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
        bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"

        firstText: buttonText4
        firstTextWidth: 202
        firstTextX: 6
        firstTextY: 64
        firstTextSize:32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: idAppMain.fontsB
        firstTextHorizontalAlies: "Center"
        firstTextEnabled: buttonEnabled4
        firstTextDisableColor: "#42454A"

        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                if(idAppMain.state == "AppDmbENGMode")
                {
                    editButton4.focus = true;
                }
                clickButton4()
            }
        }

        onClickReleased: {
            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
        }

//        KeyNavigation.up:editButton3

        Keys.onPressed: {
            if(idAppMain.isWheelLeft(event))
            {
                if(buttonEnabled3 == true){
                    editButton3.focus = true
                }
                else{
                    editButton2.focus = true
                }
            }
            //else if(idAppMain.isWheelRight(event)) { editButton1.focus = true } //remove 2012-12-10 jyjeon : if one page, no wrapping around(ISV 64311)
        }
    }

    onButtonEnabled1Changed:{
        //if(buttonEnabled1 == false)
            setFocusLastPosition()
    }
    onButtonEnabled2Changed:{
        //if(buttonEnabled2 == false)
            setFocusLastPosition()
    }
    onButtonEnabled3Changed:{
        //if(buttonEnabled3 == false)
            setFocusLastPosition()
    }
    onButtonEnabled4Changed:{
        //if(buttonEnabled4 == false)
            setFocusLastPosition()
    }

    function setFocusLastPosition()
    {
        if(buttonEnabled1 == true)
            editButton1.focus = true;
        else if(buttonEnabled2 == true)
            editButton2.focus = true;
        else if(buttonEnabled3 == true)
            editButton3.focus = true;
        else if(buttonEnabled4 == true)
            editButton4.focus = true;
    }

    function getFocusLastPosition()
    {
        if(buttonEnabled1 == true && editButton1.focus == true){
            return "button1";
        }else if(buttonEnabled2 == true && editButton2.focus == true){
            return "button2";
        }else if(buttonEnabled3 == true && editButton3.focus == true){
            return "button3";
        }else if(buttonEnabled4 == true && editButton4.focus == true){
            return "button4";
        }
        return ""
    }

    function syncLastFocusPosition(lastPosion)
    {
        switch(lastPosion)
        {
            case "button1" : { editButton1.focus = true; break; }
            case "button2" : { editButton2.focus = true; break; }
            case "button3" : { editButton3.focus = true; break; }
            case "button4" : { editButton4.focus = true; break; }
            default:
            {
                setFocusLastPosition();
                break;
            }
        }
    }

    Component.onCompleted:{
        setFocusLastPosition();
    }

}
