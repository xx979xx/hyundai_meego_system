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
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight
    focus: true

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property string popupBgImage: imgFolderPopup+"bg_type_a.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 208
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 304

    property int popupTextX: popupBgImageX + 78
    property int popupTextSpacing: 44
    property int popupFirstTextY: popupLineCnt == 1 ? popupBgImageY + 152 - 32/2 : popupBgImageY + 130 - 32/2

    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""
    property string popupFourthText: ""

    property string popupFirstBtnText: ""
    property string popupFirstBtnText2Line: ""
    property string popupSecondBtnText: ""
    property string popupSecondBtnText2Line: ""

    property int popupBtnCnt: 2    //# 1 or 2
    property int popupLineCnt: 1    //# 1 or 2
    property int popupTopMargin: 18
    property bool popupLineWrap: false
    property bool popupXMTextSize: false
    property bool popupLineWidthExtension: false

    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    onVisibleChanged: {
        if(idMPopupTypeText.visible)
            idButton1.focus = true;
    }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    //****************************** # Popup image click #
    Image {
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
    }

    //****************************** # Popup Button #
    MButton{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + popupTopMargin
        width: 288
        height: popupBtnCnt == 1 ? 254 : 134
        bgImageZ: 1
        backGroundtopVisible: true
        bgImage: popupBtnCnt == 1 ? (idButton1.activeFocus ? imgFolderPopup+"btn_type_a_01_n.png" : imgFolderPopup+"btn_type_a_01_n.png") : (idButton2.activeFocus ? imgFolderPopup+"btn_type_a_02_n.png" : imgFolderPopup+"btn_type_a_02_n.png")
        bgImagePress: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_p.png" : imgFolderPopup+"btn_type_a_02_p.png"
        bgImageFocus: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_f.png" : imgFolderPopup+"btn_type_a_02_f.png"

        fgImageX: popupBtnCnt == 1 ? 778 - 780 : 774 - 780
        fgImageY: popupBtnCnt == 1 ? 117 - popupTopMargin : 50 - popupTopMargin
        fgImageZ: 2
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible

        firstText: popupFirstBtnText
        firstTextX: 832 - 780
        firstTextY: popupBtnCnt == 1 ? popupFirstBtnText2Line != "" ? 133 - popupTopMargin : 152 - popupTopMargin : popupFirstBtnText2Line != "" ? 66 - popupTopMargin : 85 - popupTopMargin
	firstTextZ: 3
        firstTextWidth: 210
        firstTextSize: popupFirstBtnText2Line != "" ? 32 : 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        secondText: popupFirstBtnText2Line
        secondTextX: 832 - 780
        secondTextY: popupBtnCnt == 1 ? 133 + 40 - popupTopMargin : 66 + 40 - popupTopMargin
        secondTextWidth: 210
        secondTextSize: 32
        secondTextStyle: systemInfo.font_NewHDB
        secondTextAlies: "Center"
        secondTextColor: colorInfo.brightGrey
        secondTextVisible: popupFirstBtnText2Line != ""

        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupBgImageY + popupTopMargin + 134
        width: 288
        height: 134
        bgImageZ: 1
        backGroundtopVisible: true
        bgImage: (idButton1.activeFocus ? imgFolderPopup+"btn_type_a_03_n.png" : imgFolderPopup+"btn_type_a_03_n.png")
        bgImagePress: imgFolderPopup+"btn_type_a_03_p.png"
        bgImageFocus: imgFolderPopup+"btn_type_a_03_f.png"
        visible: popupBtnCnt > 1

        fgImageX: 774 - 780
        fgImageY: 50 + 134 - popupTopMargin - 134
        fgImageZ: 2
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: popupSecondBtnText2Line != "" ? 66 + 40 + 94 - popupTopMargin - 134 : 85 + 134 - popupTopMargin - 134
	firstTextZ: 3
        firstTextWidth: 210
        firstTextSize: popupSecondBtnText2Line != "" ? 32 : 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        secondText: popupSecondBtnText2Line
        secondTextX: 832 - 780
        secondTextY:  66 + 40 + 94 + 40 - popupTopMargin - 134
        secondTextWidth: 210
        secondTextSize: 32
        secondTextStyle: systemInfo.font_NewHDB
        secondTextAlies: "Center"
        secondTextColor: colorInfo.brightGrey
        secondTextVisible: popupSecondBtnText2Line != ""

        onWheelLeftKeyPressed: idButton1.focus = true
        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }

    //****************************** # Text (firstText, secondText, thirdText, fourthText) #
    Text{
        id: idText1
        text: popupFirstText
        x: popupTextX
        y: (idText2.lineCount == 2) ? popupFirstTextY - 16 : popupFirstTextY
        width: (popupLineWidthExtension == true) ? 685 : 654
        height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        wrapMode : popupLineWrap == true ? Text.WordWrap : Text.Wrap
        lineHeight: popupLineWrap == true ? 0.75 : 1
    }

    Text{
        id: idText2
        text: popupSecondText
        x: popupTextX;
        y: popupLineCnt == 2 ? popupBgImageY + 130 + popupTextSpacing - 32/2 : popupLineCnt == 3 ? popupBgImageY + 108 + popupTextSpacing - 32/2 : popupBgImageY + 86 + popupTextSpacing - 32/2
        width: (popupLineWidthExtension == true) ? 685 : 654
        height: 32
        font.pixelSize: popupXMTextSize == true ? 50 : 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        wrapMode: popupLineWrap == true ? Text.WordWrap : Text.NoWrap
        lineHeight: popupLineWrap == true ? 0.75 : 1
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 1
    }

    Text{
        id: idText3
        text: popupThirdText
        x: popupTextX;
        y: popupLineCnt == 3 ? popupBgImageY + 108 + popupTextSpacing + popupTextSpacing - 32/2 : popupBgImageY + 86 + popupTextSpacing + popupTextSpacing - 32/2
        width: (popupLineWidthExtension == true) ? 685 : 654
        height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
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
        width: (popupLineWidthExtension == true) ? 685 : 654
        height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 3
    }

    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
