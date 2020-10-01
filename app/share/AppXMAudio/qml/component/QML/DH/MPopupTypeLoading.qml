/**
 * FileName: MPopupTypeLoading.qml
 * Author: HYANG
 * Time: 2012-12
 *
 * - 2012-12-04 Initial Created by HYANG
 * - 2012-12-12 Add Text-LineNumber3, ButtonNumber2, Text2Line in Button by HYANG
 */

import QtQuick 1.1

MComponent{
    id: idMPopupTypeLoading
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property string popupBgImage: popupLineCnt < 3 ? imgFolderPopup+"bg_type_a.png" : imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: popupLineCnt < 3 ? 208-systemInfo.statusBarHeight : 171-systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: popupLineCnt < 3 ? 304 : 379

    property int popupTextX: popupBgImageX + 57
    property int popupTextSpacing: 44
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""

    property string popupFirstBtnText: ""
    property string popupFirstBtnText2Line: ""
    property string popupSecondBtnText: ""
    property string popupSecondBtnText2Line: ""

    property int popupBtnCnt: 1  //# 0 or 1 or 2
    property int popupLineCnt: 2    //# 1 or 2 or 3

    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    //****************************** # Popup image click #
    MButton{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        bgImage: popupBgImage
        bgImagePress: popupBgImage
    }

    //****************************** # Loading Image #
    Image {
        id: idLoadingImage
        x: popupBtnCnt == 0 ? popupBgImageX + 57 + 439 : popupBgImageX + 57 + 309 ;
        y: popupLineCnt < 3 ? popupBgImageY + 50 : popupBgImageY + 60
        width: 100; height: 100
        source: imgFolderPopup + "loading/loading_01.png";
        visible: idLoadingImage.on
        property bool on: parent.visible;
        NumberAnimation on rotation { running: idLoadingImage.on; from: 360; to: 0; loops: Animation.Infinite; duration: 2400 }
    }

    //****************************** # Popup Button #
    MButton{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + 25
        width: 288
        bgImageZ: 1
        backGroundtopVisible: true
        height: popupLineCnt < 3 ? popupBtnCnt == 1 ? 254 : 127 : popupBtnCnt == 1 ? 329 : 164
        bgImage: popupLineCnt < 3 ? popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : imgFolderPopup+"btn_type_a_02_n.png" : popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_n.png" : imgFolderPopup+"btn_type_b_02_n.png"
        bgImagePress: popupLineCnt < 3 ? popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_p.png" : imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_p.png" : imgFolderPopup+"btn_type_b_02_p.png"
        bgImageFocus: popupLineCnt < 3 ? popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_f.png" : imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_f.png" : imgFolderPopup+"btn_type_b_02_f.png"
        visible: popupBtnCnt == 1 || popupBtnCnt == 2
        focus: true

        fgImageX: popupLineCnt < 3 ? popupBtnCnt == 1 ? 773 - 780 : 767 - 780 : popupBtnCnt == 1 ? 778 - 780 : 773 - 780
        fgImageY: popupLineCnt < 3 ? popupBtnCnt == 1 ? 117 - 25 : 50 - 25 : popupBtnCnt == 1 ? 154 - 25 : 72 - 25
        fgImageZ: 2
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage:  popupBtnCnt == 0 ? "" : imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible

        firstText: popupFirstBtnText
        firstTextX: 832 - 780
        firstTextY: popupLineCnt < 3 ? popupBtnCnt == 1 ? popupFirstBtnText2Line != "" ? 133 - 25 : 152 - 25 :  popupFirstBtnText2Line != "" ? 66 - 25 : 85 - 25 : popupBtnCnt == 1 ?  popupFirstBtnText2Line != "" ? 170 - 25 : 189 - 25 : popupFirstBtnText2Line != "" ? 88 - 25 : 107 - 25
        firstTextZ: 3
        firstTextWidth: 210
        firstTextSize: popupFirstBtnText2Line != "" ? 32 : 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        secondText: popupFirstBtnText2Line
        secondTextX: 832 - 780
        secondTextY: popupLineCnt < 3 ? popupBtnCnt == 1 ? 133 + 40 - 25 : 66 + 40 - 25 : popupBtnCnt == 1 ? 170 + 40 - 25 : 88 + 40 - 25
        secondTextWidth: 210
        secondTextSize: 32
        secondTextStyle: systemInfo.font_NewHDB
        secondTextAlies: "Center"
        secondTextColor: colorInfo.brightGrey
        secondTextVisible: popupFirstBtnText2Line != ""

        onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupLineCnt < 3 ? popupBgImageY + 25 + 127 : popupBgImageY + 25 + 164
        width: 288
        height:  popupLineCnt < 3 ? 127 : 164
        bgImageZ: 1
        backGroundtopVisible: true
        bgImage: popupLineCnt < 3 ? popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_n.png" : "" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_n.png" : ""
        bgImagePress: popupLineCnt < 3 ? popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_p.png" : "" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_p.png" : ""
        bgImageFocus: popupLineCnt < 3 ? popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_f.png" : "" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_f.png" : ""
        visible: popupBtnCnt == 2
        focus: true

        fgImageX: popupLineCnt < 3 ? 767 - 780 : 773 - 780
        fgImageY: popupLineCnt < 3 ? 50 + 134 - 25 - 127 : 72 + 164 - 25 - 164
        fgImageZ: 2
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage:  popupBtnCnt == 0 ? "" : imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: popupLineCnt < 3 ? popupSecondBtnText2Line != "" ? 66 + 40 + 94 - 25 - 127 : 85 + 134 - 25 - 127 : popupSecondBtnText2Line != "" ? 88 + 40 + 124 - 25 - 164 : 107 + 164 - 25 - 164
        firstTextZ: 3
        firstTextWidth: 210
        firstTextSize: popupSecondBtnText2Line != "" ? 32 : 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        secondText: popupSecondBtnText2Line
        secondTextX: 832 - 780
        secondTextY: popupLineCnt < 3 ? 66 + 40 + 94 + 40 - 25 - 127 : 88 + 40 + 124 + 40 - 25 - 164
        secondTextWidth: 210
        secondTextSize: 32
        secondTextStyle: systemInfo.font_NewHDB
        secondTextAlies: "Center"
        secondTextColor: colorInfo.brightGrey
        secondTextVisible: popupSecondBtnText2Line != ""

        onWheelLeftKeyPressed: idButton1.focus = true
        onWheelRightKeyPressed: idButton1.focus = true
        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }

    //****************************** # Text (firstText, secondText, thirdText, fourthText) #
    Text{
        id: idText1
        text: popupFirstText
        x: popupTextX
        y: popupLineCnt == 1 ? popupBgImageY + 50 + 170 - 32/2 : popupLineCnt == 2 ? popupBgImageY + 50 + 148 - 32/2 : popupBgImageY + 60 + 148 - 32/2
        width: popupBtnCnt == 0 ? 439 + 541 : 309 + 401;
        height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDB
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
    }

    Text{
        id: idText2
        text: popupSecondText
        x: popupTextX;
        y: popupLineCnt == 2 ? popupBgImageY + 50 + 148 + popupTextSpacing - 32/2 : popupBgImageY + 60 + 148 + popupTextSpacing - 32/2
        width: popupBtnCnt == 0 ? 439 + 541 : 309 + 401;
        height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDB
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 1
    }

    Text{
        id: idText3
        text: popupThirdText
        x: popupTextX;
        y: popupBgImageY + 60 + 148 + popupTextSpacing + popupTextSpacing - 32/2
        width: popupBtnCnt == 0 ? 439 + 541 : 309 + 401;
        height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDB
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: popupLineCnt == 3
    }

    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
