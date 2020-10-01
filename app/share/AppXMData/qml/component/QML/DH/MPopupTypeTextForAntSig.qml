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

import QtQuick 1.1

MComponent{
    id: idMPopupTypeText
    x: 0; y: -systemInfo.statusBarHeight
    z: systemInfo.context_POPUP
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight
    focus: true

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property string popupBgImage: (popupBtnCnt < 3) ? imgFolderPopup+"bg_type_a.png" :  imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: (popupBtnCnt < 3) ? 208 : 171//208 - systemInfo.statusBarHeight : 171 - systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: (popupBtnCnt < 3) ? 304 : 379

    property int popupTextX: popupBgImageX + 78
    property int popupTextSpacing: 44
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""
    property string popupFourthText: ""

    property string popupFirstBtnText: ""
    property string popupFirstBtnText2Line: ""
    property string popupSecondBtnText: ""
    property string popupSecondBtnText2Line: ""
    property string popupThirdBtnText: ""
    property string popupThirdBtnText2Line: ""
    property string popupFourthBtnText: ""
    property string popupFourthBtnText2Line: ""

    property int popupBtnCnt: 2    //# 1 or 2 or 3 or 4
    property int popupLineCnt: 3    //# 1 or 2 or 3 or 4

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

    //****************************** # Popup BG image #
    Image{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
    }

    //****************************** # Popup Button #
    MButton{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + 18
        width: 295/*288*/;
        height: popupBtnCnt == 1 ? 268/*254*/ : popupBtnCnt == 2 ? 134/*127*/ : popupBtnCnt == 3 ? 116/*109*/ : 82
        bgImageButtonLine: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_n.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_n.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_n.png" : ""
        bgImagePress: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_p.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_p.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_p.png" : ""
        bgImageFocus: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_f.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_f.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_f.png" : ""
        focus: true

        //fgImageX: popupBtnCnt == 1 ? 773 - 780 : popupBtnCnt == 2 ? 767 - 780 : popupBtnCnt == 3 ? 766 - 780 : 763 - 780
        fgImageX: 774-780
        fgImageY: popupBtnCnt == 1 ? 117 - 25 : popupBtnCnt == 2 ? 50 - 18 : popupBtnCnt == 3 ? 44 - 25 : 31 - 25
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible
        KeyNavigation.down: popupBtnCnt == 1 ? idButton1 : idButton2
        onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : popupBtnCnt == 2 ? idButton2.focus = true : popupBtnCnt == 3 ? idButton3.focus = true : idButton4.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true

        DDScrollTicker{
            x: 832 - 780
            y: 0//popupBtnCnt == 1 ? popupFirstBtnText2Line != "" ? 133 - 25 : 152 - 25 : popupBtnCnt == 2 ? popupFirstBtnText2Line != "" ? 66 - 25 : 85 - 25 : popupBtnCnt == 3 ? popupFirstBtnText2Line != "" ? 58 - 25 : 77 - 25 : popupFirstBtnText2Line != "" ? 49 - 25 : 66 - 25
            width: 210
            height: parent.height//popupFirstBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
            text: popupFirstBtnText + " " + popupFirstBtnText2Line
            fontSize: popupFirstBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
            fontFamily: systemInfo.font_NewHDB
            color: colorInfo.brightGrey
            tickerEnable: true
            tickerFocus: idButton1.activeFocus
        }

//        firstText: popupFirstBtnText
//        firstTextX: 832 - 780
//        firstTextY: popupBtnCnt == 1 ? popupFirstBtnText2Line != "" ? 133 - 25 : 152 - 25 : popupBtnCnt == 2 ? popupFirstBtnText2Line != "" ? 66 - 25 : 85 - 25 : popupBtnCnt == 3 ? popupFirstBtnText2Line != "" ? 58 - 25 : 77 - 25 : popupFirstBtnText2Line != "" ? 49 - 25 : 66 - 25
//        firstTextWidth: 210
//        firstTextHeight: popupFirstBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
//        firstTextSize: popupFirstBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
//        firstTextStyle: systemInfo.font_NewHDB
//        firstTextAlies: "Center"
//        firstTextColor: colorInfo.brightGrey

//        DDScrollTicker{
//            x: 832 - 780
//            y: popupBtnCnt == 1 ? 133 + 40 - 25 : popupBtnCnt == 2 ? 66 + 40 - 25 : popupBtnCnt == 3 ? 58 + 40 - 25 :  49 + 36 - 25 - 4
//            width: 210
//            height: popupBtnCnt == 4 ? 28 : 32
//            text: popupFirstBtnText2Line
//            fontSize: popupBtnCnt == 4 ? 28 : 32
//            fontFamily: systemInfo.font_NewHDB
//            color: colorInfo.brightGrey
//            tickerEnable: true
//            tickerFocus: idButton1.activeFocus
//            visible: popupFirstBtnText2Line != ""
//        }

//        secondText: popupFirstBtnText2Line
//        secondTextX: 832 - 780
//        secondTextY: popupBtnCnt == 1 ? 133 + 40 - 25 : popupBtnCnt == 2 ? 66 + 40 - 25 : popupBtnCnt == 3 ? 58 + 40 - 25 :  49 + 36 - 25 - 4
//        secondTextWidth: 210
//        secondTextHeight: popupBtnCnt == 4 ? 28 : 32
//        secondTextSize: popupBtnCnt == 4 ? 28 : 32
//        secondTextStyle: systemInfo.font_NewHDB
//        secondTextAlies: "Center"
//        secondTextColor: colorInfo.brightGrey
//        secondTextVisible: popupFirstBtnText2Line != ""

        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }

        Keys.onUpPressed: {
            return;
        }
        Keys.onDownPressed: {
            return;
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupBtnCnt == 2 ? popupBgImageY + 18 + 134 : popupBtnCnt == 3 ? popupBgImageY + 25 + 109 - 7 : popupBgImageY + 25 + 82 - 7
        width: 295/*288*/;
        height: popupBtnCnt == 2 ? 134/*127*/ : popupBtnCnt == 3 ? 116/*109*/ : 82
        bgImageButtonLine: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_n.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_n.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_n.png" : ""
        bgImagePress: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_p.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_p.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_p.png" : ""
        bgImageFocus: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_f.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_f.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_f.png" : ""
        visible: popupBtnCnt > 1

        //fgImageX: popupBtnCnt == 2 ? 767 - 780 : popupBtnCnt == 3 ? 766 + 12 - 780 : 763 + 13 - 780
        fgImageX: 774-780
        fgImageY: popupBtnCnt == 2 ? 50 + 134 - 25 - 127 : popupBtnCnt == 3 ? 44 + 110 - 25 - 110 : 31 + 82 - 25 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible
        KeyNavigation.up: idButton1
        KeyNavigation.down: popupBtnCnt > 2 ? idButton3 : idButton2
        onWheelLeftKeyPressed: idButton1.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 2 ? idButton1.focus = true : idButton3.focus = true

        DDScrollTicker{
            x: 832 - 780
            y: 0//popupBtnCnt == 2 ? popupSecondBtnText2Line != "" ? 66 + 40 + 94 - 25 - 127 : 85 + 134 - 25 - 127 : popupBtnCnt == 3 ? popupSecondBtnText2Line != "" ? 58 + 40 + 70 - 25 - 109 : 77 + 110 - 25 - 109 : popupSecondBtnText2Line != "" ? 49 + 36 + 46 - 25 - 82 : 66 + 82 - 25 - 82
            width: 210
            height: parent.height//popupSecondBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
            text: popupSecondBtnText + " " + popupSecondBtnText2Line
            fontSize: popupSecondBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
            fontFamily: systemInfo.font_NewHDB
            color: colorInfo.brightGrey
            tickerEnable: true
            tickerFocus: idButton2.activeFocus
        }

//        firstText: popupSecondBtnText
//        firstTextX: 832 - 780
//        firstTextY: popupBtnCnt == 2 ? popupSecondBtnText2Line != "" ? 66 + 40 + 94 - 25 - 127 : 85 + 134 - 25 - 127 : popupBtnCnt == 3 ? popupSecondBtnText2Line != "" ? 58 + 40 + 70 - 25 - 109 : 77 + 110 - 25 - 109 : popupSecondBtnText2Line != "" ? 49 + 36 + 46 - 25 - 82 : 66 + 82 - 25 - 82
//        firstTextWidth: 210
//        firstTextHeight: popupSecondBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
//        firstTextSize: popupSecondBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
//        firstTextStyle: systemInfo.font_NewHDB
//        firstTextAlies: "Center"
//        firstTextColor: colorInfo.brightGrey

//        DDScrollTicker{
//            x: 832 - 780
//            y:  popupBtnCnt == 2 ? 66 + 40 + 94 + 40 - 25 - 127 : popupBtnCnt == 3 ? 58 + 40 + 70 + 40 - 25 - 109 : 49 + 36 + 46 + 36 - 25 - 82 - 4
//            width: 210
//            height: popupBtnCnt == 4 ? 28 : 32
//            text: popupSecondBtnText2Line
//            fontSize: popupBtnCnt == 4 ? 28 : 32
//            fontFamily: systemInfo.font_NewHDB
//            color: colorInfo.brightGrey
//            tickerEnable: true
//            tickerFocus: idButton2.activeFocus
//            visible: popupSecondBtnText2Line != ""
//        }

//        secondText: popupSecondBtnText2Line
//        secondTextX: 832 - 780
//        secondTextY:  popupBtnCnt == 2 ? 66 + 40 + 94 + 40 - 25 - 127 : popupBtnCnt == 3 ? 58 + 40 + 70 + 40 - 25 - 109 : 49 + 36 + 46 + 36 - 25 - 82 - 4
//        secondTextWidth: 210
//        secondTextHeight: popupBtnCnt == 4 ? 28 : 32
//        secondTextSize: popupBtnCnt == 4 ? 28 : 32
//        secondTextStyle: systemInfo.font_NewHDB
//        secondTextAlies: "Center"
//        secondTextColor: colorInfo.brightGrey
//        secondTextVisible: popupSecondBtnText2Line != ""

        onClickOrKeySelected: {
            popupSecondBtnClicked()
            if(!idButton1.activeFocus)
                idButton1.focus = true;
        }

        Keys.onUpPressed: {
            return;
        }
        Keys.onDownPressed: {
            return;
        }
    }

    MButton{
        id: idButton3
        x: popupBgImageX + 780
        y: popupBtnCnt == 3 ? popupBgImageY + 18 + 109 + 110 - 7 : popupBgImageY + 18 + 82 + 82 - 7;
        width: 295/*288*/;
        height: popupBtnCnt == 3 ? 110 : 82;
        bgImageButtonLine: popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_06_n.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_09_n.png" : ""
        bgImagePress: popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_06_p.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_09_p.png" : ""
        bgImageFocus: popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_06_f.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_09_f.png" : ""
        visible: popupBtnCnt > 2

        //fgImageX: popupBtnCnt == 3 ? 766 - 780 : 763 + 13 - 780
        fgImageX: 774-780
        fgImageY: popupBtnCnt == 3 ? 44 + 110 + 110 - 18 - 110 - 110 : 31 + 82 + 82 - 18 - 82 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible
        KeyNavigation.up: idButton2
        KeyNavigation.down: popupBtnCnt > 3 ? idButton4 : idButton3
        onWheelLeftKeyPressed: idButton2.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 3 ? idButton1.focus = true : idButton4.focus = true

        DDScrollTicker{
            x: 832 - 780
            y: 0//popupBtnCnt == 3 ? popupThirdBtnText2Line != "" ? 58 + 40 + 70 + 40 + 70 - 25 - 110 : 77 + 110 - 25 - 110 : popupThirdBtnText2Line != "" ? 49 + 36 + 46 + 36 + 46 - 25 - 82 - 82 : 66 + 82 + 82 - 25 - 82 - 82
            width: 210
            height: parent.height//popupThirdBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
            text: popupThirdBtnText + popupThirdBtnText2Line
            fontSize: popupThirdBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
            fontFamily: systemInfo.font_NewHDB
            color: colorInfo.brightGrey
            tickerEnable: true
            tickerFocus: idButton3.activeFocus
        }

//        firstText: popupThirdBtnText
//        firstTextX: 832 - 780
//        firstTextY: popupBtnCnt == 3 ? popupThirdBtnText2Line != "" ? 58 + 40 + 70 + 40 + 70 - 25 - 110 : 77 + 110 - 25 - 110 : popupThirdBtnText2Line != "" ? 49 + 36 + 46 + 36 + 46 - 25 - 82 - 82 : 66 + 82 + 82 - 25 - 82 - 82
//        firstTextWidth: 210
//        firstTextHeight: popupThirdBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
//        firstTextSize: popupThirdBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
//        firstTextStyle: systemInfo.font_NewHDB
//        firstTextAlies: "Center"
//        firstTextColor: colorInfo.brightGrey

//        DDScrollTicker{
//            x: 832 - 780
//            y:  popupBtnCnt == 3 ? 58 + 40 + 70 + 40 + 70 + 40 - 25 - 110 : 49 + 36 + 46 + 36 + 46 + 36 - 25 - 82 - 82 - 4
//            width: 210
//            height: popupBtnCnt == 4 ? 28 : 32
//            text: popupThirdBtnText2Line
//            fontSize: popupBtnCnt == 4 ? 28 : 32
//            fontFamily: systemInfo.font_NewHDB
//            color: colorInfo.brightGrey
//            tickerEnable: true
//            tickerFocus: idButton3.activeFocus
//            visible: popupThirdBtnText2Line != ""
//        }

//        secondText: popupThirdBtnText2Line
//        secondTextX: 832 - 780
//        secondTextY:  popupBtnCnt == 3 ? 58 + 40 + 70 + 40 + 70 + 40 - 25 - 110 : 49 + 36 + 46 + 36 + 46 + 36 - 25 - 82 - 82 - 4
//        secondTextWidth: 210
//        secondTextHeight: popupBtnCnt == 4 ? 28 : 32
//        secondTextSize: popupBtnCnt == 4 ? 28 : 32
//        secondTextStyle: systemInfo.font_NewHDB
//        secondTextAlies: "Center"
//        secondTextColor: colorInfo.brightGrey
//        secondTextVisible: popupThirdBtnText2Line != ""

        onClickOrKeySelected: {
            popupThirdBtnClicked()
            if(!idButton1.activeFocus)
                idButton1.focus = true;
        }

        Keys.onUpPressed: {
            return;
        }
        Keys.onDownPressed: {
            return;
        }
    }

    MButton{
        id: idButton4
        x: popupBgImageX + 780
        y: popupBgImageY + 18 + 82 + 82 + 82 - 7;
        width: 295/*288*/;
        height: 82;
        bgImageButtonLine: popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_10_n.png" : ""
        bgImagePress: popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_10_p.png" : ""
        bgImageFocus: popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_10_f.png" : ""
        visible: popupBtnCnt > 3

        //fgImageX: 763 - 780
        fgImageX: 774-780
        fgImageY: 31 + 82 + 82 + 82 - 18 - 82 - 82 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible
        KeyNavigation.up: idButton3
        onWheelLeftKeyPressed: idButton3.focus = true
        onWheelRightKeyPressed: idButton1.focus = true

        DDScrollTicker{
            x: 832 - 780
            y: 0//popupFourthBtnText2Line != "" ? 49 + 36 + 46 + 36 + 46 + 36 + 46 - 25 - 82 - 82 - 82 : 66 + 82 + 82 + 82 - 25 - 82 - 82 - 82
            width: 210
            height: parent.height//popupFourthBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
            text: popupFourthBtnText + popupFourthBtnText2Line
            fontSize: popupFourthBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
            fontFamily: systemInfo.font_NewHDB
            color: colorInfo.brightGrey
            tickerEnable: true
            tickerFocus: idButton4.activeFocus
        }

//        firstText: popupFourthBtnText
//        firstTextX: 832 - 780
//        firstTextY: popupFourthBtnText2Line != "" ? 49 + 36 + 46 + 36 + 46 + 36 + 46 - 25 - 82 - 82 - 82 : 66 + 82 + 82 + 82 - 25 - 82 - 82 - 82
//        firstTextWidth: 210
//        firstTextHeight: popupFourthBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
//        firstTextSize: popupFourthBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
//        firstTextStyle: systemInfo.font_NewHDB
//        firstTextAlies: "Center"
//        firstTextColor: colorInfo.brightGrey

//        DDScrollTicker{
//            x: 832 - 780
//            y: 49 + 36 + 46 + 36 + 46 + 36 + 46 + 36 - 25 - 82 - 82 - 82 - 4
//            width: 210
//            height: popupBtnCnt == 4 ? 28 : 32
//            text: popupFourthBtnText2Line
//            fontSize: popupBtnCnt == 4 ? 28 : 32
//            fontFamily: systemInfo.font_NewHDB
//            color: colorInfo.brightGrey
//            tickerEnable: true
//            tickerFocus: idButton4.activeFocus
//            visible: popupFourthBtnText2Line != ""
//        }

//        secondText: popupFourthBtnText2Line
//        secondTextX: 832 - 780
//        secondTextY: 49 + 36 + 46 + 36 + 46 + 36 + 46 + 36 - 25 - 82 - 82 - 82 - 4
//        secondTextWidth: 210
//        secondTextHeight: popupBtnCnt == 4 ? 28 : 32
//        secondTextSize: popupBtnCnt == 4 ? 28 : 32
//        secondTextStyle: systemInfo.font_NewHDB
//        secondTextAlies: "Center"
//        secondTextColor: colorInfo.brightGrey
//        secondTextVisible: popupFourthBtnText2Line != ""

        onClickOrKeySelected: {
            popupFourthBtnClicked()
            if(!idButton1.activeFocus)
                idButton1.focus = true;
        }

        Keys.onUpPressed: {
            return;
        }
        Keys.onDownPressed: {
            return;
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
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        //[ITS 191510]
        elide: {
            if(idAppMain.isDRSChange == true || idAppMain.isCallStart == true)
                Text.ElideNone;
            else if(idAppMain.isDRSChange == false || idAppMain.isCallStart == false)
                if(popupLineCnt == 1)
                   Text.ElideNone;
                else
                    Text.ElideRight;
        }
        wrapMode:  {
            if(idAppMain.isDRSChange == true || idAppMain.isCallStart == true)
                Text.Wrap;
            else if(idAppMain.isDRSChange == false || idAppMain.isCallStart == false)
                if(popupLineCnt == 1)
                    Text.Wrap;
                else
                    Text.NoWrap;
        }
    }

    Text{
        id: idText2
        text: popupSecondText
        x: popupTextX;
        y: popupLineCnt == 2 ? popupBgImageY + 130 + popupTextSpacing - 32/2 : popupLineCnt == 3 ? popupBgImageY + 108 + popupTextSpacing - 32/2 : popupBgImageY + 86 + popupTextSpacing - 32/2
        width: 654; height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 1
        lineHeight: 0.75
        //[ITS 191510]
        elide: {
            if(idAppMain.isDRSChange == true || idAppMain.isCallStart == true)
                Text.ElideNone;
            else if(idAppMain.isDRSChange == false || idAppMain.isCallStart == false)
                if(popupLineCnt >= 1)
                   Text.ElideNone;
                else
                    Text.ElideRight;
        }
        wrapMode:  {
            if(idAppMain.isDRSChange == true || idAppMain.isCallStart == true)
                Text.Wrap;
            else if(idAppMain.isDRSChange == false || idAppMain.isCallStart == false)
                if(popupLineCnt >= 1)
                    Text.Wrap;
                else
                    Text.NoWrap;
        }
    }

    Text{
        id: idText3
        text: popupThirdText
        x: popupTextX;
        y: popupLineCnt == 3 ? popupBgImageY + 108 + popupTextSpacing + popupTextSpacing - 32/2 : popupBgImageY + 86 + popupTextSpacing + popupTextSpacing - 32/2
        width: 654; height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        elide: Text.ElideRight
        visible: popupLineCnt > 2
    }

    Text{
        id: idText4
        text: popupFourthText
        x: popupTextX;
        y: popupBgImageY + 86 + popupTextSpacing + popupTextSpacing + popupTextSpacing - 32/2
        width: 654; height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        elide: Text.ElideRight
        visible: popupLineCnt > 3
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
