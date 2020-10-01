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
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComponent{
    id: idMPopupTypeToast
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    // # Popup Info
    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string popupBgImage: (idAppMain.languageType == 2/*KO*/) ? imgFolderPopup+"bg_type_c.png" : imgFolderPopup+"bg_type_f.png"
    property int popupBgImageX: 250
//    property int popupBgImageY:(idAppMain.languageType == 2/*KO*/) ? 454-systemInfo.statusBarHeight : 404-systemInfo.statusBarHeight
    property int popupBgImageY:(idAppMain.languageType == 2/*KO*/) ? ((y==0) ? 454-systemInfo.statusBarHeight : 454) : ((y==0) ? 404-systemInfo.statusBarHeight : 404)
    property int popupBgImageWidth: 780
    property int popupBgImageHeight:(idAppMain.languageType == 2/*KO*/) ? 208 : 258

    // # Text Info
    property int popupTextPreY: popupBgImageY + 73 + popupTextSpacing - (idText1.paintedHeight/2)
    property int popupTextX: (idAppMain.languageType == 2/*KO*/) ? popupBgImageX + 34*4 + 34/2 : popupBgImageX + 34*4 - 34/2
    property int popupTextY: (idAppMain.languageType == 2/*KO*/) ? popupTextPreY - 30 : popupTextPreY
    property int popupTextWidth: (idAppMain.languageType == 2/*KO*/) ? 712 - (34*6) : 712 - (34*5)
    //property int popupTextX: (idAppMain.languageType == 2/*KO*/) ? popupBgImageX + 34*4 + 34 : popupBgImageX + 34*2 - 34/2
    //property int popupTextY: (idAppMain.languageType == 2/*KO*/) ? popupTextPreY - 30 : popupTextPreY
    //property int popupTextWidth: (idAppMain.languageType == 2/*KO*/) ? 712 - (34*7) : 712
    property int popupTextSpacing: 60
    property string popupFirstText: ""
    property string popupFirstTextHAlignment: "Center"// "Center", "Left", "Right"
    property string popupFirstTextVAlignment: "Center"
    property string popupSecondText: ""

    signal popupClicked();
    signal popupBgClicked();
    signal hardBackKeyClicked();

    // # Background mask click
    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            popupBgClicked()
        }
    }

    // # Background mask
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0
    }

    // # Popup image click
    MButton{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        bgImage: popupBgImage
        bgImagePress: popupBgImage
        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                popupClicked();
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
        y: popupTextY
        width: popupTextWidth
        height: idText1.paintedHeight
        font.pixelSize: 36
        font.family: idAppMain.fontsR
        verticalAlignment: { MDmbOperation.getVerticalAlignment(popupFirstTextHAlignment) }
        horizontalAlignment: { MDmbOperation.getHorizontalAlignment(popupFirstTextVAlignment) }
        color: colorInfo.brightGrey
        wrapMode: Text.Wrap
    }

    // # Hard Back
    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
