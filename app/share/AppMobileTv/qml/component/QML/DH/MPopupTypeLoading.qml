/**
 * FileName: MPopupTypeLoading.qml
 * Author: HYANG
 * Time: 2012-12
 *
 * - 2012-12-04 Initial Created by HYANG
 * - 2012-12-12 Add Text-LineNumber3, ButtonNumber2, Text2Line in Button by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComponent{
    id: idMPopupTypeLoading
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    // # Popup Info
    property string imgFolderPopup: imageInfo.imgFolderPopup    
    property string popupBgImage: imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 171-systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 79
    property int popupBgImageTopMargine: 18

    // # Button Text/Image Info
    property int popupButtonX: popupBgImageX + 780
    property int popupButtonY: popupBgImageY + popupBgImageTopMargine
    property int popupButtonWidth: 295
    property int popupButtonHeight: 343
    property int popupButtonTextX: 832 - 780
    property int popupButtonTextY: 189 - popupBgImageTopMargine
    property int popupButtonTextWidth: 210
    property int popupButtonTextHeight: 36
    property int popupButtonTextSize: 36
    property string popupButtonTextStyle: idAppMain.fontsB
    property string popupButtonTextHorizontalAlies: "Center"
    property string popupButtonTextColor: colorInfo.subTextGrey

    // # Icon Image Info
    property int popupIconX: 778 - 780
    property int popupIconY: 154 - popupBgImageTopMargine
    property int popupIconWidth: 69
    property int popupIconHeight: 69
    property string popupIconImage: imgFolderPopup+"light.png"

    // # Loading Image Info
    property int popupLoadingImageX: popupBgImageX + popupTextLeftMargine + 309
    property int popupLoadingImageY: popupBgImageY + 60
    property int popupLoadingImageWidth: 76
    property int popupLoadingImageHeight: 76

    // # Text Info
    property string popupFirstBtnText: ""
    property int popupTextLeftMargine: 57
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""
    property int popupTextSpacing: 44
    property int popupTextX: popupBgImageX + popupTextLeftMargine
    property int popupText1Y: popupLoadingImageY + 148 - popupTextSize/2
    property int popupText2Y: popupText1Y + popupTextSpacing
    property int popupText3Y: popupText2Y + popupTextSpacing
    property int popupTextWidth: 710
    property int popupTextHeight: 32
    property int popupTextSize: 32
    property string popupTextStyle: idAppMain.fontsR
    property string popupTextVerticalAlies : "Center"
    property string popupTextHorizontalAlies: "Center"


    property int popupBtnCnt: 1  //# 1
    property int popupLineCnt: 3 //# 1 or 2 or 3
    property int loadingImageNumber: 1

    function focusBtn1(){
        if(popupBtnCnt >= 2 && idButton1.focus == false) idButton1.focus = true;
    }

    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    // # Background mask click #
//    onClickOrKeySelected: {
//        if(pressAndHoldFlag == false){
//            popupBgClicked()
//        }
//    }

//    onClickReleased: {
//        if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
//    }

    Timer {
        id: idLoadingPopupTimer
        interval: 100
        running: true
        repeat: true
        onTriggered:
        {
//                console.debug("[QML]  MPopupTypeLoading :: idLoadingPopupTimer:  loadingImageNumber = "+ loadingImageNumber)
            idLoadingImage.source = imgFolderPopup + "loading/loading_"+ loadingImageNumber +".png"

            loadingImageNumber++;

            if(loadingImageNumber == 17)
            {
                loadingImageNumber = 1;
            }
        }
    }

    onVisibleChanged: {
//        console.debug("[QML]  MPopupTypeLoading :: onVisibleChanged:  visible = "+ visible)
        if(idMPopupTypeLoading.visible == true)
        {
//            loadingImageNumber = 1;
            focusBtn1()
            idLoadingPopupTimer.start();
        }
        else
        {
             loadingImageNumber = 1;
            idLoadingPopupTimer.stop();
        }
    }

    // # Background mask
    Rectangle{
        width: parent.width; height: parent.height+systemInfo.statusBarHeight
        y:0-systemInfo.statusBarHeight
        color: colorInfo.black
        opacity: 0.6

        MouseArea{
            anchors.fill: parent
        }
    }

    // # Popup image click
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

    // # Loading Image
    Image {
        id: idLoadingImage
        x: popupLoadingImageX
        y: popupLoadingImageY
        width: popupLoadingImageWidth;
        height: popupLoadingImageHeight
//        source: imgFolderPopup + "loading/loading_1.png";
//        visible: idLoadingImage.on
//        property bool on: parent.visible;
//        NumberAnimation on rotation { running: idLoadingImage.on; from: 0; to: 360; loops: Animation.Infinite; duration: 2400 }
    }

    // # Popup Button
    MButton{
        id: idButton1
        x: popupButtonX
        y: popupButtonY
        width: popupButtonWidth
        height: popupButtonHeight
        //bgImage: imgFolderPopup+"btn_type_b_01_n.png"
        defaultImage: imgFolderPopup+"btn_type_b_01_n.png"
        bgImagePress: imgFolderPopup+"btn_type_b_01_p.png"
        bgImageFocus: imgFolderPopup+"btn_type_b_01_f.png"
        visible: popupBtnCnt == 1
        focus: true

        fgImageX: popupIconX
        fgImageY: popupIconY
        fgImageWidth: popupIconWidth
        fgImageHeight: popupIconHeight
        fgImage: popupIconImage
        fgImageVisible:  (showFocus && idButton1.activeFocus) ? true : false

        firstText: popupFirstBtnText
        firstTextX: popupButtonTextX
        firstTextY: popupButtonTextY
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

    // # Text
    Text{
        id: idText1
        text: popupFirstText
        x: popupTextX
        y: popupText1Y
        width: popupTextWidth
        height: popupTextHeight
        font.pixelSize: popupTextSize
        font.family: popupTextStyle
        verticalAlignment: { MDmbOperation.getVerticalAlignment(popupTextVerticalAlies) }
        horizontalAlignment: { MDmbOperation.getHorizontalAlignment(popupTextHorizontalAlies) }
        color: popupButtonTextColor
    }

    Text{
        id: idText2
        text: popupSecondText
        x: popupTextX;
        y: popupText2Y
        width: popupTextWidth
        height: popupTextHeight
        font.pixelSize: popupTextSize
        font.family: popupTextStyle
        verticalAlignment: { MDmbOperation.getVerticalAlignment(popupTextVerticalAlies) }
        horizontalAlignment: { MDmbOperation.getHorizontalAlignment(popupTextHorizontalAlies) }
        color: popupButtonTextColor
        visible: popupLineCnt > 1
    }

    Text{
        id: idText3
        text: popupThirdText
        x: popupTextX;
        y: popupText3Y
        width: popupTextWidth
        height: popupTextHeight
        font.pixelSize: popupTextSize
        font.family: popupTextStyle
        verticalAlignment: { MDmbOperation.getVerticalAlignment(popupTextVerticalAlies) }
        horizontalAlignment: { MDmbOperation.getHorizontalAlignment(popupTextHorizontalAlies) }
        color: popupButtonTextColor
        visible: popupLineCnt == 3
    }

    // # Hard Back
    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
