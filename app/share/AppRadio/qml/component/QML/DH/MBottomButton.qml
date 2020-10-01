/**
 * FileName: MBottomButton.qml
 * Author: HYANG
 * Time: 2012-06
 *
 * - 2012-06 Initial Created by HYANG
 * - 2012-06 Add added signal check/uncheck
 * - 2012-06 added button count 3
 * - 2012-07 Add added clickEvent of checkbox
 * - 2012-07 Add Enabled
 * - 2012-07-31 keynavigation modified, wheel added
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent{
    id: idMBottomButton
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: 114

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderRadio_Dab : imageInfo.imgFolderRadio_Dab
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    property int buttonCount: 4             //# Count of button (3 or 4)
    property string firstButtonText: ""     //# Text in Button
    property string secondButtonText: ""
    property string thirdButtonText: ""
    property string fourthButtonText: ""

    property bool firstDimCheckFlag: false  //# checkBox of Button Have/No
    property bool secondDimCheckFlag: false
    property bool thirdDimCheckFlag: false
    property bool fourthDimCheckFlag: false

    property bool firstEnabled: true        //# Enabled of Button On/Off
    property bool secondEnabled: true
    property bool thirdEnabled: true
    property bool fourthEnabled: true

    //****************************** # Signal #
    signal firstButtonClicked()
    signal secondButtonClicked()
    signal thirdButtonClicked()
    signal fourthButtonClicked()

    signal firstButtonCheckClicked()
    signal firstButtonUnCheckClicked()
    signal secondButtonCheckClicked()
    signal secondButtonUnCheckClicked()
    signal thirdButtonCheckClicked()
    signal thirdButtonUnCheckClicked()
    signal fourthButtonCheckClicked()
    signal fourthButtonUnCheckClicked()

//20121116 added by qutiguy - display check icon from controller.
    function toggleCheckInfo(value){
        if(value)
            thirdDimCheck.state ="on";
        else thirdDimCheck.state ="off";
    }
    function toggleCheckTa(value){
        if(value)
            fourthDimCheck.state ="on";
        else fourthDimCheck.state ="off";
    }


    //****************************** # Background Image #
    Image{
        x: 0; y: 0
        width: systemInfo.lcdWidth; height: 114
        source: imgFolderRadio_Dab+"bg_sls.png"
    }

    //****************************** # First Button #
    MButton {
        id: idFirstBtn
        x: buttonCount == 3? 171 : 14; y: 26
        width: 310; height: 71
        focus: firstEnabled? true : false
        bgImage: imgFolderRadio_Dab+"btn_dab_n.png"
        bgImagePress: imgFolderRadio_Dab+"btn_dab_p.png"
        bgImageFocusPress: imgFolderRadio_Dab+"btn_dab_fp.png"
        bgImageFocus: imgFolderRadio_Dab+"btn_dab_f.png"
        visible: buttonCount == 1 || buttonCount == 2 || buttonCount == 3 || buttonCount == 4
        mEnabled: firstEnabled

        firstText: firstButtonText
        firstTextX: 15
        firstTextY: 33
        firstTextWidth: firstDimCheckFlag? 224 : 280
        firstTextHeight: 32
        firstTextSize: 32
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        MDimCheck{
            id: firstDimCheck
            x: 15+224+11; y: 13
            width: 44; height: 44
            bgImage: imgFolderGeneral+"checkbox_uncheck.png"
            bgImageSelected: imgFolderGeneral+"checkbox_check.png"
            visible: firstDimCheckFlag
            state: (flagToggle==true)? "on" : "off"
            enabled: firstEnabled? true : false
            onClickOrKeySelected: {
                if(flagToggle) firstButtonCheckClicked()
                else if(!flagToggle) firstButtonUnCheckClicked()
            }
        }

        onClickOrKeySelected: {
            if(firstDimCheckFlag){ //# dimCheck On/Off
                if(firstDimCheck.state == "on"){
                    firstDimCheck.state = "off"
                    firstButtonUnCheckClicked()
                }
                else if(firstDimCheck.state == "off"){
                    firstDimCheck.state = "on"
                    firstButtonCheckClicked()
                }
            }
            firstButtonClicked()
        }

        onWheelLeftKeyPressed: {
            if(buttonCount != 4) idThirdBtn.focus = true
            else idFourthBtn.focus = true
        }
        onWheelRightKeyPressed: {
            idSecondBtn.focus = true
        }

        KeyNavigation.left: idFirstBtn  //(buttonCount != 4) ? idThirdBtn : idFourthBtn
        KeyNavigation.right: idSecondBtn
    }

    //****************************** # Second Button #
    MButton {
        id: idSecondBtn
        x: buttonCount == 3? 171+315 : 14+315; y: 26
        width: 310; height: 71
        focus: firstEnabled? false : secondEnabled? true : false
        bgImage: imgFolderRadio_Dab+"btn_dab_n.png"
        bgImagePress: imgFolderRadio_Dab+"btn_dab_p.png"
        bgImageFocusPress: imgFolderRadio_Dab+"btn_dab_fp.png"
        bgImageFocus: imgFolderRadio_Dab+"btn_dab_f.png"
        visible: buttonCount == 1 || buttonCount == 2 || buttonCount == 3 || buttonCount == 4
        mEnabled: secondEnabled

        firstText: secondButtonText
        firstTextX: 15
        firstTextY: 33
        firstTextWidth: secondDimCheckFlag? 224 : 280
        firstTextHeight: 32
        firstTextSize: 32
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        MDimCheck{
            id: secondDimCheck
            x: 15+224+11; y: 13
            width: 44; height: 44
            bgImage: imgFolderGeneral+"checkbox_uncheck.png"
            bgImageSelected: imgFolderGeneral+"checkbox_check.png"
            visible: secondDimCheckFlag
            state: (flagToggle==true)? "on" : "off"
            enabled: secondEnabled? true : false
            onClickOrKeySelected: {
                if(flagToggle) secondButtonCheckClicked()
                else if(!flagToggle) secondButtonUnCheckClicked()
            }
        }

        onClickOrKeySelected: {
            if(secondDimCheckFlag){ //# dimCheck On/Off
                if(secondDimCheck.state == "on"){
                    secondDimCheck.state = "off"
                    secondButtonUnCheckClicked()
                }
                else if(secondDimCheck.state == "off"){
                    secondDimCheck.state = "on"
                    secondButtonCheckClicked()
                }
            }
            secondButtonClicked()
        }

        onWheelLeftKeyPressed: {
           idFirstBtn.focus = true
        }
//20121116 modified by qutiguy - check whether Info-button is enable
//        onWheelRightKeyPressed: {
//            idThirdBtn.focus = true
//        }
        onWheelRightKeyPressed: {
            if(idThirdBtn.mEnabled){
                idThirdBtn.focus = true;
            }else{
                idFourthBtn.focus = true;
            }
        }

        KeyNavigation.left: idFirstBtn
//20121116 modified by qutiguy - check whether Info-button is enable
//        KeyNavigation.right: idThirdBtn
        KeyNavigation.right: thirdEnabled? idThirdBtn : fourthEnabled? idFourthBtn : idSecondBtn

    }

    //****************************** # Third Button #
    MButton {
        id: idThirdBtn
        x: buttonCount == 3? 171+315+315 : 14+315+315; y: 26
        width: 310; height: 71
        focus: firstEnabled? false : secondEnabled? false : thirdEnabled? true : false
        bgImage: imgFolderRadio_Dab+"btn_dab_n.png"
        bgImagePress: imgFolderRadio_Dab+"btn_dab_p.png"
        bgImageFocusPress: imgFolderRadio_Dab+"btn_dab_fp.png"
        bgImageFocus: imgFolderRadio_Dab+"btn_dab_f.png"
        visible: buttonCount == 1 || buttonCount == 2 || buttonCount == 3 || buttonCount == 4
        mEnabled: thirdEnabled

        firstText: thirdButtonText
        firstTextX: 15
        firstTextY: 33
        firstTextWidth: thirdDimCheckFlag? 224 : 280
        firstTextHeight: 32
        firstTextSize: 32
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        MDimCheck{
            id: thirdDimCheck
            x: 15+224+11; y: 13
            width: 44; height: 44
            bgImage: imgFolderGeneral+"checkbox_uncheck.png"
            bgImageSelected: imgFolderGeneral+"checkbox_check.png"
            visible: thirdDimCheckFlag
            state: (flagToggle==true)? "on" : "off"
            enabled: thirdEnabled? true : false
            onClickOrKeySelected: {
                if(flagToggle) thirdButtonCheckClicked()
                else if(!flagToggle) thirdButtonUnCheckClicked()
            }
        }

        onClickOrKeySelected: {
            if(thirdDimCheckFlag){ //# dimCheck On/Off
                if(thirdDimCheck.state == "on"){
                    thirdDimCheck.state = "off"
                    console.log("###>>###>>on>>off ")
                    thirdButtonUnCheckClicked()
                }
                else if(thirdDimCheck.state == "off"){
                    thirdDimCheck.state = "on"
                    console.log("###>>###>>off>>on ")
                    thirdButtonCheckClicked()
                }
            }
            thirdButtonClicked()
        }

        onWheelLeftKeyPressed: {
           idSecondBtn.focus = true
        }
        onWheelRightKeyPressed: {
            if(buttonCount != 4) idFirstBtn.focus = true
            else idFourthBtn.focus = true
        }

        KeyNavigation.left: idSecondBtn
        KeyNavigation.right: (buttonCount != 4) ? idThirdBtn : idFourthBtn

    }
    //****************************** # Fourth Button #
    MButton {
        id: idFourthBtn
        x: 14+315+315+315; y: 26
        width: 310; height: 71
        focus: firstEnabled? false : secondEnabled? false : thirdEnabled? false : fourthEnabled? true : false
        bgImage: imgFolderRadio_Dab+"btn_dab_n.png"
        bgImagePress: imgFolderRadio_Dab+"btn_dab_p.png"
        bgImageFocusPress: imgFolderRadio_Dab+"btn_dab_fp.png"
        bgImageFocus: imgFolderRadio_Dab+"btn_dab_f.png"
        visible: buttonCount == 1 || buttonCount == 2 || buttonCount == 4
        mEnabled: fourthEnabled
        firstText: fourthButtonText
        firstTextX: 15
        firstTextY: 33
        firstTextWidth: fourthDimCheckFlag? 224 : 280
        firstTextHeight: 32
        firstTextSize: 32
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        MDimCheck{
            id: fourthDimCheck
            x: 15+224+11; y: 13
            width: 44; height: 44
            bgImage: imgFolderGeneral+"checkbox_uncheck.png"
            bgImageSelected: imgFolderGeneral+"checkbox_check.png"
            visible: fourthDimCheckFlag
            state: (flagToggle==true)? "on" : "off"
            enabled: fourthEnabled? true : false
            onClickOrKeySelected: {
                if(flagToggle) fourthButtonCheckClicked()
                else if(!flagToggle) fourthButtonUnCheckClicked()
            }
        }

        onClickOrKeySelected: {
            if(fourthDimCheckFlag){ //# dimCheck On/Off
                if(fourthDimCheck.state == "on"){
                    fourthDimCheck.state = "off"
                    fourthButtonUnCheckClicked()
                }
                else if(fourthDimCheck.state == "off"){
                    fourthDimCheck.state = "on"
                    fourthButtonCheckClicked()
                }
            }
            fourthButtonClicked()
        }
//20121116 modified by qutiguy - check whether Info-button is enable
//        onWheelLeftKeyPressed: {
//           idThirdBtn.focus = true
//        }
        onWheelLeftKeyPressed: {
            if(idThirdBtn.mEnabled){
                idThirdBtn.focus = true;
            }else{
                idSecondBtn.focus = true;
            }
        }
        onWheelRightKeyPressed: {
           idFirstBtn.focus = true
        }

//20121116 modified by qutiguy - check whether Info-button is enable
//        KeyNavigation.left: idThirdBtn
        KeyNavigation.left: thirdEnabled? idThirdBtn : secondEnabled? idSecondBtn : firstEnabled? idFirstBtn : idFourthBtn
        KeyNavigation.right: idFourthBtn

    }
}

