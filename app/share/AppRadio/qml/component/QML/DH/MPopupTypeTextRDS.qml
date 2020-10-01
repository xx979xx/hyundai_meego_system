/**
 * FileName: MPopupTypeTextRDS.qml
 * Author: HYANG
 * Time: 2012-12
 *
 * - 2012-12-03 Initial Created by HYANG
 * - 2012-12-08 Add button number 1 ~ 4
 * - 2012-12-10 Wheel in button Add
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

    property string popupBgImage: (popupBtnCnt < 3) ? imgFolderPopup+"bg_type_a.png" :  imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: (popupBtnCnt < 3) ? 208 - systemInfo.statusBarHeight : 171 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: (popupBtnCnt < 3) ? 304 : 379

    property int popupTextX: popupBgImageX + 57 //KSW 131023 //dg.jin 20140923 modify local TA 56 -> 61 //dg.jin 20141126 Ta popup modify 61 -> 62 //dg.jin 20150407 62 -> 57
    property int popupTextSpacing: 59 //KSW 131023
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""
    property string popupFourthText: ""

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""
    property string popupThirdBtnText: ""
    property string popupFourthBtnText: ""

    property int popupBtnCnt: 2     //# 1 or 2 or 3 or 4
    property int popupLineCnt: 4    //# 1 or 2 or 3 or 4
    property int popuplangId : 0 //KSW 131023

    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal popupThirdBtnClicked();
    signal popupFourthBtnClicked();
    signal hardBackKeyClicked();

    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeText.visible) {
            idButton1.forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeText.visible) {
            idButton1.forceActiveFocus();
        }
    }
    
    //****************************** # Background mask click #
    onClickOrKeySelected: {
        popupBgClicked()
    }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: showPopup ? 0.0 : 0.6
    }

    //****************************** # Popup image click #
    //KSW 131224 ITS/217144
    Image{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
        visible: showPopup ? false : true
    }

    //****************************** # Popup Button #
    MButtonOnlyRadio{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + 18 //+25
        width: 288;
        height: popupBtnCnt == 1 ? 254 : popupBtnCnt == 2 ? 127 : popupBtnCnt == 3 ? 109 : 82
        //20141001 popup focus error 2 button
        bgImage: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : popupBtnCnt == 2 ? ((showFocus && idButton1.activeFocus) ? "" : (imgFolderPopup+"btn_type_a_02_n.png")) : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_n.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_n.png" : ""
        bgImagePress: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_p.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_p.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_p.png" : ""
        bgImageFocus: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_f.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_f.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_f.png" : ""
        focus: true

        fgImageX: popupBtnCnt == 1 ? 778 - 780 : popupBtnCnt == 2 ? 767 - 780 + 7/*KSW 131023 + 7*/  : popupBtnCnt == 3 ? 766 - 780 : 763 - 780
        fgImageY: popupBtnCnt == 1 ? 117 - 25+7 : popupBtnCnt == 2 ? 50 - 25 + 7 /*KSW 131023 + 7*/ : popupBtnCnt == 3 ? 44 - 25 : 31 - 25
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: true == idButton1.activeFocus //focusImageVisible //KSW 131223 ITS/0216974
        KeyNavigation.down: popupBtnCnt == 1 ? idButton1 : idButton2
        onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.forceActiveFocus() : popupBtnCnt == 2 ? idButton2.forceActiveFocus() : popupBtnCnt == 3 ? idButton3.forceActiveFocus() : idButton4.forceActiveFocus()
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.forceActiveFocus() : idButton2.forceActiveFocus()

        firstText: popupFirstBtnText
        firstTextX: 832 - 780 - 1 //KSW 131023 - 1
        //dg.jin 20140923 modify local TA Cnt 1 25 -> 15 Cnt 2 19 -> 15
        firstTextY: popupBtnCnt == 1 ? 152 - 15  : popupBtnCnt == 2 ? 85 - 15/* KSW 131023 25 -> 19 */  : popupBtnCnt == 3 ? 77 - 25 : 66 - 25
        firstTextWidth: 210
        firstTextHeight: 36
        firstTextSize: 36
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButtonOnlyRadio{
        id: idButton2
        x: popupBgImageX + 780
        y: popupBtnCnt == 2 ? popupBgImageY + 25 + 127 : popupBtnCnt == 3 ? popupBgImageY + 25 + 109 : popupBgImageY + 25 + 82
        width: 288;
        height: popupBtnCnt == 2 ? 127 : popupBtnCnt == 3 ? 109 : 82
        //20141001 popup focus error 2 button
        bgImage: popupBtnCnt == 2 ? ((showFocus && idButton2.activeFocus) ? "" : (imgFolderPopup+"btn_type_a_03_n.png")) : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_n.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_n.png" : ""
        bgImagePress: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_p.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_p.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_p.png" : ""
        bgImageFocus: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_f.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_f.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_f.png" : ""
        visible: popupBtnCnt > 1

        fgImageX: popupBtnCnt == 2 ? 767 - 780 + 7/*KSW 131023 + 7*/ : popupBtnCnt == 3 ? 766 + 12 - 780 : 763 + 13 - 780
        fgImageY: popupBtnCnt == 2 ? 50 + 134 - 25 - 127 : popupBtnCnt == 3 ? 44 + 110 - 25 - 110 : 31 + 82 - 25 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: true == idButton2.activeFocus //focusImageVisible //KSW 131223 ITS/0216974
        KeyNavigation.up: idButton1
        KeyNavigation.down: popupBtnCnt > 2 ? idButton3 : idButton2
        onWheelLeftKeyPressed: idButton1.forceActiveFocus()
        onWheelRightKeyPressed: popupBtnCnt == 2 ? idButton1.forceActiveFocus() : idButton3.forceActiveFocus()

        firstText: popupSecondBtnText
        firstTextX: 832 - 780 - 1 //KSW 131023 -1
        //dg.jin 20140923 modify local TA Cnt 2 del -1 25 ->22
        firstTextY: popupBtnCnt == 2 ? 85 + 134 - 22 - 127 /*KSW 131023 - 1 */ : popupBtnCnt == 3 ? 77 + 110 - 25 - 109 : 66 + 82 - 25 - 82
        firstTextWidth: 210
        firstTextHeight: 36
        firstTextSize: 36
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }

    MButtonOnlyRadio{
        id: idButton3
        x: popupBgImageX + 780
        y: popupBtnCnt == 3 ? popupBgImageY + 25 + 109 + 110 : popupBgImageY + 25 + 82 + 82;
        width: 288;
        height: popupBtnCnt == 3 ? 110 : 82;
        bgImage: popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_06_n.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_09_n.png" : ""
        bgImagePress: popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_06_p.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_09_p.png" : ""
        bgImageFocus: popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_06_f.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_09_f.png" : ""
        visible: popupBtnCnt > 2

        fgImageX: popupBtnCnt == 3 ? 766 - 780 : 763 + 13 - 780
        fgImageY: popupBtnCnt == 3 ? 44 + 110 + 110 - 25 - 110 - 110 : 31 + 82 + 82 - 25 - 82 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: true == idButton3.activeFocus //focusImageVisible //KSW 131223 ITS/0216974
        KeyNavigation.up: idButton2
        KeyNavigation.down: popupBtnCnt > 3 ? idButton4 : idButton3
        onWheelLeftKeyPressed: idButton2.forceActiveFocus()
        onWheelRightKeyPressed: popupBtnCnt == 3 ? idButton1.forceActiveFocus() : idButton4.forceActiveFocus()

        firstText: popupThirdBtnText
        firstTextX: 832 - 780
        firstTextY: popupBtnCnt == 3 ? 77 + 110 - 25 - 110 : 66 + 82 + 82 - 25 - 82 - 82
        firstTextWidth: 210
        firstTextHeight: 36
        firstTextSize: 36
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        onClickOrKeySelected: {
            popupThirdBtnClicked()
        }
    }

    MButtonOnlyRadio{
        id: idButton4
        x: popupBgImageX + 780
        y: popupBgImageY + 25 + 82 + 82 + 82;
        width: 288;
        height: 82;
        bgImage: popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_10_n.png" : ""
        bgImagePress: popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_10_p.png" : ""
        bgImageFocus: popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_10_f.png" : ""
        visible: popupBtnCnt > 3

        fgImageX: 763 - 780
        fgImageY: 31 + 82 + 82 + 82 - 25 - 82 - 82 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: true == idButton4.activeFocus //focusImageVisible //KSW 131223 ITS/0216974
        KeyNavigation.up: idButton3
        onWheelLeftKeyPressed: idButton3.forceActiveFocus()
        onWheelRightKeyPressed: idButton1.forceActiveFocus()

        firstText: popupFourthBtnText
        firstTextX: 832 - 780
        firstTextY: 66 + 82 + 82 + 82 - 25 - 82 - 82 - 82
        firstTextWidth: 210
        firstTextHeight: 36
        firstTextSize: 36
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        onClickOrKeySelected: {
            popupFourthBtnClicked()
        }
    }

    //****************************** # Text (firstText, secondText, thirdText, fourthText) #
    //dg.jin 20141126 Ta popup modify
    Text{
        id: idText1
        text: popupFirstText
        x: popupTextX
        y: popupLineCnt == 1 ? popupBgImageY + 152 - 32/2 : popupLineCnt == 2 ? popupBgImageY + (popupBgImageHeight/2) - (idText1.height/2) /* KSW 131023 - 6 */ : popupLineCnt == 3 ? popupBgImageY + 108 - 32/2 : popupBgImageY + 86 - 32/2
        width: 685; //height: 244 //dg.jin 20150407 654 -> 685
        font.pointSize: 32
        font.family: systemInfo.hdr
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        style:Text.Sunken
        wrapMode: Text.Wrap
        elide: Text.ElideNone
    }

    Text{
        id: idText2
        text: popupSecondText
        //dg.jin 20140923 modify local TA 5 -> 4 6 -> 5
        x: popuplangId == 2 ? popupTextX - 4 : popupTextX - 5; //KSW 131023
        y: popupLineCnt == 2 ? popupBgImageY + 130 + popupTextSpacing - 32/2 : popupLineCnt == 3 ? popupBgImageY + 108 + popupTextSpacing - 32/2 : popupBgImageY + 86 + popupTextSpacing - 32/2
        width: 685; height: 32 //dg.jin 20150407 654 -> 685
        font.pixelSize: 32
        font.family: systemInfo.hdr//KSW 131023 systemInfo.hdb
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey //KSW 131023 colorInfo.subTextGrey
//        visible: popupLineCnt > 1
        visible: false  //dg.jin 20141126 Ta popup modify
    }

    Text{
        id: idText3
        text: popupThirdText
        x: popupTextX;
        y: popupLineCnt == 3 ? popupBgImageY + 108 + popupTextSpacing + popupTextSpacing - 32/2 : popupBgImageY + 86 + popupTextSpacing + popupTextSpacing - 32/2
        width: 685; height: 32   //dg.jin 20150407 654 -> 685
        font.pixelSize: 32
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 2
    }

    Text{
        id: idText4
        text: popupFourthText
        x: popupTextX;
        y: popupBgImageY + 86 + popupTextSpacing + popupTextSpacing + popupTextSpacing - 32/2
        width: 685; height: 32   //dg.jin 20150407 654 -> 685
        font.pixelSize: 32
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 3
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
