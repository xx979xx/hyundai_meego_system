/**
 * FileName: MWarningPopup.qml
 * Author: HYANG
 * Time: 2012-04
 *
 * - 2012-04 Initial Created by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

MComponent{
    id: idMWarningPopup
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property int textLineCount: 1       //# line count of text (1~2)

    property string titleText: ""       //# "Warning"
    property string firstContentText: ""          //# Text
    property string secondContentText: ""
   

    property string firstBtnText: ""            //# button Text

    signal firstBtnClicked()    //# when clicked button
    signal popupClicked()       //# when clicked popup
    signal hardBackKeyClicked() //# when pressed comma

    MouseArea{ anchors.fill: parent }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height:parent.height
        color: colorInfo.black
        opacity: 0.6
    }
    //****************************** # Preset Background #
    Image{
        id: idPopupBg
        x: 110; y: popupBgYHeight()
       // width: 1087; height: 385
        source: popupBgImage()
        MouseArea{
            anchors.fill: parent
            onClicked: popupClicked()
        }
    }

    function popupBgImage(){
        return imgFolderPopup+"popup_c_b.png"
    }

    function popupBgYHeight(){
        return 218-systemInfo.statusBarHeight
    }
    //****************************** # Preset Title Text #
    Image{
        x: 110+44; y: 218-systemInfo.statusBarHeight+35
        source: imgFolderPopup+"ico_warning.png"
    }

    //****************************** # Preset Title Text #
    Text{
        text: titleText
        x: 110+44+55; y: 218-systemInfo.statusBarHeight+35+20-44/2
        width: 942; height: 44
        font.pixelSize: 44
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey //"#B6C9FF"  //RGB(182, 201, 255)
    }

    //****************************** # Preset Title Text #
    Text{
        text: firstContentText
        x: 110+45; y: textLineCount==2? 218-systemInfo.statusBarHeight+165-32/2 : 218-systemInfo.statusBarHeight+189-32/2
        width: 996; height: 32
        font.pixelSize: 32
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
    }
    Text{
        id: secondText
        text: secondContentText
        x: 110+45; y: 218-systemInfo.statusBarHeight+165+46-32/2
        width: 996; height: 32
        font.pixelSize: 32
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: textLineCount==2
    }

    //****************************** # First Button #
    MButton{
        id: idFirstBtn
        x: 110+45+288; y: 218-systemInfo.statusBarHeight+165+46+61
        width: 420; height: 73
        focus: true
        bgImage: imgFolderPopup+"btn_popup_l_n.png"
        bgImageActive: imgFolderPopup+"btn_popup_l_s.png"
        bgImageFocus: imgFolderPopup+"btn_popup_l_f.png"
        bgImageFocusPress: imgFolderPopup+"btn_popup_l_fp.png"
        bgImagePress: imgFolderPopup+"btn_popup_l_p.png"

        firstText: firstBtnText
        firstTextX: 14; firstTextY: 33
        firstTextWidth: 394; firstTextHeight: 30
        firstTextSize: 30
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.subTextGrey
        firstTextPressColor: colorInfo.subTextGrey
        firstTextFocusPressColor: colorInfo.subTextGrey
        firstTextSelectedColor: colorInfo.subTextGrey

        onClickOrKeySelected:{
            firstBtnClicked()
        }
    }
    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}


