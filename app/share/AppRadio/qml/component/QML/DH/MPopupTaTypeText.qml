/**
 * FileName: MPopupTypeText.qml
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

    property int popupTextX: popupBgImageX + 78
    property int popupTextSpacing: 44
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

    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal popupThirdBtnClicked();
    signal popupFourthBtnClicked();
    signal hardBackKeyClicked();

    //****************************** # Background mask click #
    onClickOrKeySelected: {
        popupBgClicked()
    }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    //****************************** # Popup image click #
    MButtonOnlyRadio{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        bgImage: popupBgImage
        bgImagePress: popupBgImage
        onClickOrKeySelected: popupClicked();
    }

    //****************************** # Popup Button #
    MButtonOnlyRadio{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + 18 //+25
        width: 288;
        height: popupBtnCnt == 1 ? 254 : popupBtnCnt == 2 ? 127 : popupBtnCnt == 3 ? 109 : 82
        bgImage: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_n.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_n.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_n.png" : ""
        bgImagePress: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_p.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_p.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_p.png" : ""
        bgImageFocus: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_f.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_f.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_f.png" : ""
        focus: true

        fgImageX: popupBtnCnt == 1 ? 778 - 780 : popupBtnCnt == 2 ? 767 - 780 : popupBtnCnt == 3 ? 766 - 780 : 763 - 780
        fgImageY: popupBtnCnt == 1 ? 117 - 25+7 : popupBtnCnt == 2 ? 50 - 25 : popupBtnCnt == 3 ? 44 - 25 : 31 - 25
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible
        KeyNavigation.down: popupBtnCnt == 1 ? idButton1 : idButton2
        onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : popupBtnCnt == 2 ? idButton2.focus = true : popupBtnCnt == 3 ? idButton3.focus = true : idButton4.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true

        firstText: popupFirstBtnText
        firstTextX: 832 - 780
        firstTextY: popupBtnCnt == 1 ? 152 - 25 : popupBtnCnt == 2 ? 85 - 25 : popupBtnCnt == 3 ? 77 - 25 : 66 - 25
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
        bgImage: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_n.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_n.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_n.png" : ""
        bgImagePress: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_p.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_p.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_p.png" : ""
        bgImageFocus: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_f.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_f.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_f.png" : ""
        visible: popupBtnCnt > 1

        fgImageX: popupBtnCnt == 2 ? 767 - 780 : popupBtnCnt == 3 ? 766 + 12 - 780 : 763 + 13 - 780
        fgImageY: popupBtnCnt == 2 ? 50 + 134 - 25 - 127 : popupBtnCnt == 3 ? 44 + 110 - 25 - 110 : 31 + 82 - 25 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible
        KeyNavigation.up: idButton1
        KeyNavigation.down: popupBtnCnt > 2 ? idButton3 : idButton2
        onWheelLeftKeyPressed: idButton1.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 2 ? idButton1.focus = true : idButton3.focus = true

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: popupBtnCnt == 2 ? 85 + 134 - 25 - 127 : popupBtnCnt == 3 ? 77 + 110 - 25 - 109 : 66 + 82 - 25 - 82
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
        fgImageVisible: focusImageVisible
        KeyNavigation.up: idButton2
        KeyNavigation.down: popupBtnCnt > 3 ? idButton4 : idButton3
        onWheelLeftKeyPressed: idButton2.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 3 ? idButton1.focus = true : idButton4.focus = true

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
        fgImageVisible: focusImageVisible
        KeyNavigation.up: idButton3
        onWheelLeftKeyPressed: idButton3.focus = true
        onWheelRightKeyPressed: idButton1.focus = true

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
    Text{
        id: idText1
        text: popupFirstText
        x: popupTextX
        y: popupLineCnt == 1 ? popupBgImageY + 152 - 32/2 : popupLineCnt == 2 ? popupBgImageY + 130 - 32/2 : popupLineCnt == 3 ? popupBgImageY + 108 - 32/2 : popupBgImageY + 86 - 32/2
        width: 654; height: 32
        font.pixelSize: 32
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
    }

    Text{
        id: idText2
        text: popupSecondText
        x: popupTextX;
        y: popupLineCnt == 2 ? popupBgImageY + 130 + popupTextSpacing - 32/2 : popupLineCnt == 3 ? popupBgImageY + 108 + popupTextSpacing - 32/2 : popupBgImageY + 86 + popupTextSpacing - 32/2
        width: 654; height: 32
        font.pixelSize: 32
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 1
    }

    Text{
        id: idText3
        text: popupThirdText
        x: popupTextX;
        y: popupLineCnt == 3 ? popupBgImageY + 108 + popupTextSpacing + popupTextSpacing - 32/2 : popupBgImageY + 86 + popupTextSpacing + popupTextSpacing - 32/2
        width: 654; height: 32
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
        width: 654; height: 32
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

