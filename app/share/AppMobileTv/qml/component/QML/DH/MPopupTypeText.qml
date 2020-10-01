/**
 * FileName: MPopupTypeText.qml
 * Author: HYANG
 * Time: 2012-12
 *
 * - 2012-12-03 Initial Created by HYANG
 * - 2012-12-08 Add button number 1 ~ 4
 * - 2012-12-10 Wheel in button Add
 * - 2012-12-13 Add Text 2 Line in Button
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

MComponent{
    id: idMPopupTypeText
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    // # Popup Info
    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string popupBgImage: imgFolderPopup+"bg_type_a.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 208 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 304
    property int popupBgImageTopMargine: 18
    property int popupBtnCnt: 2    //# 1 or 2
    property int popupLineCnt: 3    //# 1 or 2 or 3

    // # Button Text/Image Info
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""
    property int popupButtonX: popupBgImageX + 780
    property int popupButton1Y: popupBgImageY + popupBgImageTopMargine
    property int popupButton2Y: popupBgImageY + popupBgImageTopMargine + popupButtonHeight
    property int popupButtonWidth: 295
    property int popupButtonHeight: popupBtnCnt == 1 ? 268 : 134
    property int popupButtonTextX: 832 - 780
    property int popupButtonText1Y: popupBtnCnt == 1 ? 152 - popupBgImageTopMargine : 85 - popupBgImageTopMargine
    property int popupButtonText2Y: popupBtnCnt == 2 ? 85 + 134 - popupBgImageTopMargine - 127 : 0
    property int popupButtonTextWidth: 210
    property int popupButtonTextHeight: 36
    property int popupButtonTextSize: 36
    property string popupButtonTextStyle: idAppMain.fontsB
    property string popupButtonTextHorizontalAlies: "Center"
    property string popupButtonTextColor: colorInfo.brightGrey

    // # Icon Image Info
    property int popupIconX: popupBtnCnt == 1 ? 778 - 780 : 774 - 780
    property int popupIcon1Y: popupBtnCnt == 1 ? 117 - popupBgImageTopMargine : 50 - popupBgImageTopMargine
    property int popupIcon2Y: popupBtnCnt == 2 ? 50 + 134 - popupBgImageTopMargine - 127 : 0
    property int popupIconWidth: 69
    property int popupIconHeight: 69
    property string popupIconImage: imgFolderPopup+"light.png"

    // # Text Info
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""
    property int popupTextSpacing: 44
    property int popupTextX: popupBgImageX + 78
    property int popupText1Y: popupLineCnt == 1 ? popupBgImageY + 152 - popupTextSize/2 : popupLineCnt == 2 ? popupBgImageY + 130 - popupTextSize/2 : popupLineCnt == 3 ? popupBgImageY + 108 - popupTextSize/2 : 0
    property int popupText2Y: popupLineCnt == 2 ? popupBgImageY + 130 + popupTextSpacing - popupTextSize/2 : popupLineCnt == 3 ? popupBgImageY + 108 + popupTextSpacing - popupTextSize/2 : 0
    property int popupText3Y: popupLineCnt == 3 ? popupBgImageY + 108 + popupTextSpacing + popupTextSpacing - popupTextSize/2 : 0
    property int popupTextWidth: 654
    property int popupTextHeight: 32
    property int popupTextSize: 32
    property string popupTextStyle: idAppMain.fontsR

    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal popupThirdBtnClicked();
    signal popupFourthBtnClicked();
    signal hardBackKeyClicked();

    function focusBtn1(){
        if(popupBtnCnt == 2 && idButton1.focus == false) idButton1.focus = true;
    }

    onVisibleChanged: {
        if(idMPopupTypeText.visible == false) return;
        focusBtn1()
    }

    property alias buttonFocus1: idButton1.focus;
    property alias buttonFocus2: idButton2.focus;

    // # Background mask click #
//    onClickOrKeySelected: {
//        if(pressAndHoldFlag == false){
//            popupBgClicked()
//        }
//    }

//    onClickReleased: {
//        if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
//    }

    // # Background mask #
    Rectangle{
        width: parent.width; height: parent.height+systemInfo.statusBarHeight
        y:0-systemInfo.statusBarHeight
        color: colorInfo.black
        opacity: 0.6

        MouseArea{
            anchors.fill: parent
        }
    }

    // # Popup image click #
    MButton{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        bgImage: popupBgImage
        bgImagePress: popupBgImage
//        onClickOrKeySelected: {
//            if(pressAndHoldFlag == false){
//                popupClicked();
//            }
//        }
//        onClickReleased: {
//            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
//        }
    }

    // # Popup Button
    MButton{
        id: idButton1
        x: popupButtonX
        y: popupButton1Y
        width: popupButtonWidth
        height: popupButtonHeight
        defaultImage: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : imgFolderPopup+"btn_type_a_02_n.png"
        //bgImage: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : imgFolderPopup+"btn_type_a_02_n.png"
        bgImagePress: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_p.png" : imgFolderPopup+"btn_type_a_02_p.png"
        bgImageFocus: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_f.png" : imgFolderPopup+"btn_type_a_02_f.png"
        focus: true

        fgImageX: popupIconX
        fgImageY: popupIcon1Y
        fgImageWidth: popupIconWidth
        fgImageHeight: popupIconHeight
        fgImage: popupIconImage
        fgImageVisible:  (showFocus && idButton1.activeFocus) ? true : false
	
        //KeyNavigation.down: popupBtnCnt == 1 ? idButton1 : idButton2
        onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true

        firstText: popupFirstBtnText
        firstTextX: popupButtonTextX
        firstTextY: popupButtonText1Y
        firstTextWidth: popupButtonTextWidth
        firstTextHeight: popupButtonTextHeight
        firstTextSize: popupButtonTextSize
        firstTextStyle: popupButtonTextStyle
        firstTextHorizontalAlies: popupButtonTextHorizontalAlies
        firstTextColor: popupButtonTextColor

        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                popupFirstBtnClicked()
            }
        }

        onClickReleased: {
            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
        }
    }

    MButton{
        id: idButton2
        x: popupButtonX
        y: popupButton2Y
        width: popupButtonWidth
        height: popupButtonHeight
        defaultImage: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_n.png" : ""
        //bgImage: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_n.png" : ""
        bgImagePress: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_p.png" : ""
        bgImageFocus: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_f.png" : ""
        visible: popupBtnCnt > 1

        fgImageX: popupIconX
        fgImageY: popupIcon2Y
        fgImageWidth: popupIconWidth
        fgImageHeight: popupIconHeight
        fgImage: popupIconImage
        fgImageVisible:  (showFocus && idButton2.activeFocus) ? true : false
        //KeyNavigation.up: idButton1
        //KeyNavigation.down: popupBtnCnt > 2 ? idButton3 : idButton2
        onWheelLeftKeyPressed: idButton1.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 2 ? idButton1.focus = true : ""

        firstText: popupSecondBtnText
        firstTextX: popupButtonTextX
        firstTextY: popupButtonText2Y
        firstTextWidth: popupButtonTextWidth
        firstTextHeight: popupButtonTextHeight
        firstTextSize: popupButtonTextSize
        firstTextStyle: popupButtonTextStyle
        firstTextHorizontalAlies: popupButtonTextHorizontalAlies
        firstTextColor: popupButtonTextColor

        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                popupSecondBtnClicked()
            }
        }

        onClickReleased: {
            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
        }
    }

    // # Text (firstText, secondText, thirdText, fourthText) #
    Text{
        id: idText1
        text: popupFirstText
        x: popupTextX
        y: popupText1Y
        width: popupTextWidth; height: popupTextHeight
        font.pixelSize: popupTextSize
        font.family: popupTextStyle
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        wrapMode: Text.Wrap
    }

    Text{
        id: idText2
        text: popupSecondText
        x: popupTextX;
        y: popupText2Y
        width: popupTextWidth; height: popupTextHeight
        font.pixelSize: popupTextSize
        font.family: popupTextStyle
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 1
    }

    Text{
        id: idText3
        text: popupThirdText
        x: popupTextX;
        y: popupText3Y
        width: popupTextWidth; height: popupTextHeight
        font.pixelSize: popupTextSize
        font.family: popupTextStyle
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt == 3
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }

    Connections{
        target: EngineListener

        onSetWheelKeyPressed:{
            if(wheelType == 0 /* Left */)
            {
                if(popupBtnCnt == 2)
                {
                    if(buttonFocus1 == false) buttonFocus1 = true;
                    else return;
                }
            }
            else /* Right */
            {
                if(popupBtnCnt == 2)
                {
                    if(buttonFocus2 == false) buttonFocus2 = true;
                    else return;
                }
            }
        }
    }

    onTuneEnterKeyPressed: {
        if(EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == true && EngineListener.m_ScreentSettingMode == true))
        {
            EngineListener.SetExternal()
            return;
        }
    }
}
