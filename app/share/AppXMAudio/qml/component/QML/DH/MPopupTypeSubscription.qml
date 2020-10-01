/**
 * FileName: idMPopupTypeEPG.qml
 * Author: HYANG
 * Time: 2013-1
 *
 * - 2013-1-02 Initial Created by HYANG
 */

import QtQuick 1.1

MComponent{
    id: idMPopupTypeSubscription
    x: 0; y: -systemInfo.statusBarHeight
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight
    focus: true

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string imgFolderSettings: imageInfo.imgFolderSettings

    property string popupBgImage: imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 171
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 379

    property int popupTopMargin: 18
    property int popupTextX: popupBgImageX + 69
    property int popupTextSpacing: 47
    property int popupTextY: popupBgImageY + 68
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""
    property string popupFourthText: ""
    property string popupFifthText: ""
    property string popupSixthText: ""
    property string popupSeventhText: ""
    property string popupEighthText: ""
    property string popupNinthText: ""
    property string popupTenthText: ""

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 2    //# 1 or 2
    property bool secondBtnEnable: false

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
    Image{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
    }

    //****************************** # Text (firstText, secondText, thirdText, fourthText, FifthText) #
    Text{
        id: idFirstText
        text: popupFirstText
        x: popupTextX; y: popupTextY - (24/2)
        width: 336; height: 24
        font.pixelSize: 18
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }

    Text{
        id: idSecondText
        text: popupSecondText
        x: popupTextX; y: popupTextY - (24/2) + 36
        width: 336; height: 24
        font.pixelSize: 18
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }

    Text{
        id: idThirdText
        text: popupThirdText
        x: popupTextX; y: popupTextY - (24/2) + 36 + 36
        width: 336; height: 24
        font.pixelSize: 18
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }

    Text{
        id: idFourthText
        text: popupFourthText
        x: popupTextX; y: popupTextY - (24/2) + 36 + 36 + 36
        width: 336; height: 24
        font.pixelSize: 18
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }

    Text{
        id: idFifthText
        text: popupFifthText
        x: popupTextX + 362; y: popupTextY - (24/2)
        width: 336; height: 24
        font.pixelSize: 18
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }

    Text{
        id: idSixthText
        text: popupSixthText
        x: popupTextX + 362; y: popupTextY - (24/2) + 36
        width: 336; height: 24
        font.pixelSize: 18
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }

    Text{
        id: idSeventhText
        text: popupSeventhText
        x: popupTextX + 362; y: popupTextY - (24/2) + 36 + 36
        width: 336; height: 24
        font.pixelSize: 18
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }

    Text{
        id: idEighthText
        text: popupEighthText
        x: popupTextX + 362; y: popupTextY - (24/2) + 36 + 36 + 36
        width: 336; height: 24
        font.pixelSize: 18
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }

    Image{
        id: idDivide
        x: popupTextX-22; y: popupTextY + 36 + 36 + 36 + 43
        //width: 741; height: 2
        source: imageInfo.imgFolderPopup + "divide.png"
    }

    Text{
        id: idNinthText
        text: popupNinthText
        x: popupTextX; y: popupTextY - (24/2) + 36 + 36 + 36 + 43 + 43
        width: 698; height: 32
        font.pixelSize: 24
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
    }

    Text{
        id: idTenthText
        text: popupTenthText
        x: popupTextX; y: popupTextY - (24/2) + 36 + 36 + 36 + 43 + 43 + 46
        width: 698; height: 32
        font.pixelSize: 24
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        wrapMode: Text.WordWrap
        lineHeight: 0.75
    }

    //****************************** # Popup Button #
    MButton{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + popupTopMargin
        width: 288
        height: 171
        bgImageZ: 1
        backGroundtopVisible: true
        bgImage: (idButton2.activeFocus ? imgFolderPopup+"btn_type_b_02_n.png" : imgFolderPopup+"btn_type_b_02_n.png")
        bgImagePress: imgFolderPopup+"btn_type_b_02_p.png";
        bgImageFocus: imgFolderPopup+"btn_type_b_02_f.png"
        visible: popupBtnCnt == 2
        focus: true

        fgImageX: 773 - 780
        fgImageY: 72 - popupTopMargin
        fgImageZ: 2
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible

        firstText: popupFirstBtnText
        firstTextX: 832 - 780
        firstTextY: 107 - 18
        firstTextZ: 3
        firstTextWidth: 210
        firstTextSize: 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        onWheelRightKeyPressed: (secondBtnEnable == false) ? null : idButton2.focus = true
        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupBgImageY + popupTopMargin + 171
        width: 288
        height: 165
        bgImageZ: 1
        backGroundtopVisible: true
        bgImage: (secondBtnEnable == false) ? imgFolderPopup+"btn_type_b_03_d.png" : (idButton1.activeFocus ? imgFolderPopup+"btn_type_b_03_n.png" : imgFolderPopup+"btn_type_b_03_n.png")
        bgImagePress: imgFolderPopup+"btn_type_b_03_p.png"
        bgImageFocus: imgFolderPopup+"btn_type_b_03_f.png"
        visible: popupBtnCnt == 2
        mEnabled: secondBtnEnable

        fgImageX: 773 - 780
        fgImageY: 72 + 164 - popupTopMargin - 171
        fgImageZ: 2
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: 107 + 164 - 171 - 18
        firstTextZ: 3
        firstTextWidth: 210
        firstTextSize: 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: (secondBtnEnable == false) ? colorInfo.disableGrey : colorInfo.brightGrey

        onWheelLeftKeyPressed: idButton1.focus = true
        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }

    onVisibleChanged: {
        if(idRadioPopupSubscriptionStatus.visible == true)
        {
            idButton1.focus = true;
        }
    }

    onSecondBtnEnableChanged: {
        if(idRadioPopupSubscriptionStatus.visible == false) return;

        if(idButton2.activeFocus == true && secondBtnEnable == false)
        {
            //console.log("Subscription Status -> onSecondBtnEnableChanged 1 ------> "+secondBtnEnable+" "+idButton1.activeFocus+" "+idButton2.activeFocus);
            idButton1.focus = true;
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
