/**
 * FileName: MPopupTypeToast.qml
 * Author: HYANG
 * Time: 2012-12
 *
 * - 2012-12-03 Initial Created by HYANG
 * - 2012-12-08 Add Loading ToastPopup by HYANG
 */

import QtQuick 1.1

MComponent{
    id: idMPopupTypeToast
    x: 0; y: -systemInfo.statusBarHeight
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight
    focus: true

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property string popupBgImage: imgFolderPopup+"bg_type_c.png"
    property int popupBgImageX: 250
    property int popupBgImageY: 454
    property int popupBgImageWidth: 780
    property int popupBgImageHeight: 208

    property int popupTextX: popupBgImageX + 34
    property int popupTextSpacing: 60
    property string popupFirstText: ""
    property string popupSecondText: ""

    property int popupLineCnt: 1    //# 1 or 2
    property bool popupLoadingFlag: false

    property bool upKeyPressed : idAppMain.upKeyPressed;
    property bool downKeyPressed : idAppMain.downKeyPressed;
    property bool rightKeyPressed : idAppMain.rightKeyPressed;
    property bool leftKeyPressed : idAppMain.leftKeyPressed;

    signal popupClicked();
    signal popupBgClicked();
    signal hardBackKeyClicked();
    signal prevKeyClicked();
    signal nextKeyClicked();
    signal wheel8DirectionClicked();

    //****************************** # Background mask click #
    onClickOrKeySelected: {
        if(idAppMain.isJogEnterLongPressed != true)
            popupBgClicked()
    }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0
    }

    //****************************** # Popup image click #
    MButton{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        bgImage: popupBgImage
        bgImagePress: popupBgImage
        onClickOrKeySelected: popupClicked();
    }

    //****************************** # Text (firstText, secondText) #
    Text{
        id: idText1
        text: popupFirstText
        x: popupTextX
        y: popupLineCnt == 1 ? (popupLoadingFlag == true)? popupBgImageY + 36 + 112 -36/2 : popupBgImageY + 103 - 36/2 : popupBgImageY + 73 - 36/2
        width: 712;
        height: 36
        font.pixelSize: 36
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        wrapMode: Text.WordWrap
        lineHeight: 0.85
    }

    Text{
        id: idText2
        text: popupSecondText
        x: popupTextX;
        y: idText1.lineCount == 2 ? popupBgImageY + 73 + popupTextSpacing : popupBgImageY + 73 + popupTextSpacing - 36/2
        width: 712; height: 36
        font.pixelSize: 36
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: popupLineCnt > 1
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: { hardBackKeyClicked(); }

    // SEEK/TRACK H/U or SWRC, Tune knob - prev operation
    onSeekPrevKeyPressed: { prevKeyClicked(); }
    onSWRCSeekPrevKeyPressed: { prevKeyClicked(); }
    onSeekPrevLongKeyPressed: { prevKeyClicked(); }
    onTuneLeftKeyPressed: { prevKeyClicked(); }

    // SEEK/TRACK H/U or SWRC, Tune knob - next operation
    onSeekNextKeyPressed: { nextKeyClicked(); }
    onSWRCSeekNextKeyPressed: { nextKeyClicked(); }
    onSeekNextLongKeyPressed: { nextKeyClicked(); }
    onTuneRightKeyPressed: { nextKeyClicked(); }

    // Wheel Left/Right - CCP
    onWheelLeftKeyPressed: { prevKeyClicked(); }
    onWheelRightKeyPressed: { nextKeyClicked(); }
}
