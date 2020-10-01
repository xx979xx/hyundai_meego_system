/**
 * FileName: MPopupTypeToast.qml
 * Author: HYANG
 * Time: 2012-12
 *
 * - 2012-12-03 Initial Created by HYANG
 * - 2012-12-08 Add Loading ToastPopup by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

MComponent{
    id: idMPopupTypeToast
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property string popupBgImage: imgFolderPopup+"bg_type_c.png"
    property int popupBgImageX: 250
    property int popupBgImageY: 454-systemInfo.statusBarHeight
    property int popupBgImageWidth: 780
    property int popupBgImageHeight: 208

    property int popupTextX: popupBgImageX + 34
    property int popupTextSpacing: 60
    property string popupFirstText: ""
    property string popupSecondText: ""

    property int popupLineCnt: 1    //# 1 or 2
    property bool popupLoadingFlag: false

    signal popupClicked();
    signal popupBgClicked();
    signal hardBackKeyClicked();

    //****************************** # Background mask click #
    onClickOrKeySelected: {
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

    //****************************** # Loading Image #
    Image {
        id: idLoadingImage
        x: popupBgImageX + 34 + 318
        y: popupBgImageY + 36
        width: 76; height: 76
        source: imgFolderPopup + "loading/loading_01.png";
        visible: idLoadingImage.on && (popupLoadingFlag == true)
        property bool on: parent.visible;
        NumberAnimation on rotation { running: idLoadingImage.on; from: 360; to: 0; loops: Animation.Infinite; duration: 2400 }
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
        font.family: idAppMain.fonts_HDR
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: "Wrap"
        color: colorInfo.brightGrey
    }

    Text{
        id: idText2
        text: popupSecondText
        x: popupTextX;
        y: popupBgImageY + 73 + popupTextSpacing - 36/2
        width: 712; height: 36
        font.pixelSize: 36
        font.family: idAppMain.fonts_HDR
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: popupLineCnt > 1
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
