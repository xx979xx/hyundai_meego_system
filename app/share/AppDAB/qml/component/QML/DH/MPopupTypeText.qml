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

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property string popupBgImage: imgFolderPopup+"bg_type_a.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 208 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 304

    property int popupTextX: popupBgImageX + 78
    property int popupTextSpacing: 44  

    property string popupFirstText: ""

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 2    //# 1 or 2
    property int popupTopMargin: 18

    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    //****************************** # Background mask click #
    onClickOrKeySelected: {
        popupBgClicked()
    }

    //****************************** # StatusBar Dim #
    Rectangle{
        x: 0; y: -systemInfo.statusBarHeight
        height: systemInfo.statusBarHeight;
        width: systemInfo.lcdWidth
        color: colorInfo.black
        opacity: 0.6
        MouseArea{
            anchors.fill: parent;
        }
    }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    //****************************** # Popup image click #
    //    MButton{
    //        x: popupBgImageX; y: popupBgImageY
    //        width: popupBgImageWidth; height: popupBgImageHeight
    //        bgImage: popupBgImage
    //        bgImagePress: popupBgImage
    //        onClickOrKeySelected: popupClicked();
    //    }

    Image{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
    }

    //****************************** # Popup Button #
    MButton{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + popupTopMargin
        width: 288;
        height: popupBtnCnt == 1 ? 268 : 134 //254 : 134
        //   bgImage: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : imgFolderPopup+"btn_type_a_02_n.png"
        bgImagePress: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_p.png" : imgFolderPopup+"btn_type_a_02_p.png"
        bgImageFocus: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_f.png" : imgFolderPopup+"btn_type_a_02_f.png"
         bgImageTop: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : imgFolderPopup+"btn_type_a_02_n.png"
        focus: true

        fgImageX: popupBtnCnt == 1 ? 778 - 780 : 774 - 780
        fgImageY: popupBtnCnt == 1 ? 117 - popupTopMargin : 50 - popupTopMargin

        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: idButton1.activeFocus == true;
        KeyNavigation.down: popupBtnCnt == 1 ? idButton1 : idButton2
       // onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true

        firstText: popupFirstBtnText
        firstTextX: 832 - 780
        firstTextY: popupBtnCnt == 1 ? 152 - popupTopMargin : 85 - popupTopMargin
        firstTextWidth: 210
        firstTextSize: idButton1.firstTextPaintedHeight < 72 ? 36 : 32
        firstTextStyle: idAppMain.fonts_HDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextWrapMode: true

        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupBgImageY + popupTopMargin + 134
        width: 288;
        height: 134
        //   bgImage: imgFolderPopup+"btn_type_a_03_n.png"
        bgImagePress: imgFolderPopup+"btn_type_a_03_p.png"
        bgImageFocus: imgFolderPopup+"btn_type_a_03_f.png"
        bgImageTop: imgFolderPopup+"btn_type_a_03_n.png"
        visible: popupBtnCnt > 1

        fgImageX: 774 - 780
        fgImageY: 50 + 134 - popupTopMargin - 134

        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: idButton2.activeFocus == true;
        KeyNavigation.up: idButton1
        KeyNavigation.down: idButton2
        onWheelLeftKeyPressed: idButton1.focus = true      

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: 85 + 134 - popupTopMargin - 134
        firstTextWidth: 210       
        firstTextSize: idButton2.firstTextPaintedHeight < 72 ? 36 : 32
        firstTextStyle: idAppMain.fonts_HDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextWrapMode: true

        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }

    //****************************** # Text (firstText, secondText, thirdText, fourthText) #
    Text{
        id: idText1
        text: popupFirstText
        x: popupTextX
        y: popupBgImageY  //popupFirstTextY
        width: 654; height: popupBgImageHeight
        font.pixelSize: 32
        font.family: idAppMain.fonts_HDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        wrapMode : Text.Wrap
    }

    //    Text{
    //        id: idText2
    //        text: popupSecondText
    //        x: popupTextX;
    //        y: popupBgImageY + 130 + popupTextSpacing - 32/2
    //        width: 654; height: 32
    //        font.pixelSize: 32
    //        font.family: idAppMain.fonts_HDR
    //        horizontalAlignment: Text.AlignLeft
    //        verticalAlignment: Text.AlignVCenter
    //        color: colorInfo.subTextGrey
    //        visible: popupLineCnt > 1
    //    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }

    onVisibleChanged: {
        if(visible){
            idButton1.focus = true;
        }
    }

    //************************ Function ***//
    function giveFocus(focusPosition){
        if(focusPosition == 1) idButton1.focus = true
        else if(focusPosition == 2) idButton2.focus = true
        // else if(focusPosition == "contents")
    }
}
