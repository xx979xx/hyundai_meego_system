/**
 * FileName: MAnnouncementPopup.qml
 * Author: HYANG
 * Time: 2012-04
 *
 * - 2012-04 Initial Created by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

MComponent{
    id: idMAnnouncementPopup
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property string firstContentText: ""          //# Text
    property string secondContentText: ""
    property string firstBtnText: ""            //# button Text
    property string secondBtnText: ""
    property string thirdBtnText: ""

    signal firstBtnClicked()
    signal secondBtnClicked()
    signal thirdBtnClicked()
    signal hardBackKeyClicked()

    MouseArea{ anchors.fill: parent }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height:parent.height
        color: colorInfo.black
        opacity: 0.6
    }
    //****************************** # Popup Background #
    Image{
        x: 110; y: 216-systemInfo.statusBarHeight
        width: 1087; height: 385
        source: imgFolderPopup+"popup_etc_02_bg.png"
    }

    //****************************** # Content Text #
    Text{
        text: firstContentText
        x: 110+45; y: 216+111-60/2-systemInfo.statusBarHeight
        width: 995; height: 60
        font.pixelSize: 60
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
    }
    Text{
        text: secondContentText
        x: 110+45; y: 216+111+86-32/2-systemInfo.statusBarHeight
        width: 995; height: 32
        font.pixelSize: 32
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
    }

    //****************************** # First Button #
    MButton{
        id: idFirstBtn
        x: 110+22; y: 216+272-systemInfo.statusBarHeight
        width: 347; height: 73
        focus: true
        bgImage: imgFolderPopup+"btn_popup_s_n.png"
        bgImageActive: imgFolderPopup+"btn_popup_s_s.png"
        bgImageFocus: imgFolderPopup+"btn_popup_s_f.png"
        bgImageFocusPress: imgFolderPopup+"btn_popup_s_fp.png"
        bgImagePress: imgFolderPopup+"btn_popup_s_p.png"

        firstText: firstBtnText
        firstTextX: 10; firstTextY: 36
        firstTextWidth: 327; firstTextHeight: 30
        firstTextSize: 30
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.subTextGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey

        onClickOrKeySelected:{
            firstBtnClicked()
        }
        KeyNavigation.right: idSecondBtn
    }

    //****************************** # Second Button #
    MButton{
        id: idSecondBtn
        x: 110+22+347; y: 216+272-systemInfo.statusBarHeight
        width: 347; height: 73
        bgImage: imgFolderPopup+"btn_popup_s_n.png"
        bgImageActive: imgFolderPopup+"btn_popup_s_s.png"
        bgImageFocus: imgFolderPopup+"btn_popup_s_f.png"
        bgImageFocusPress: imgFolderPopup+"btn_popup_s_fp.png"
        bgImagePress: imgFolderPopup+"btn_popup_s_p.png"

        firstText: secondBtnText
        firstTextX: 10; firstTextY: 36
        firstTextWidth: 327; firstTextHeight: 30
        firstTextSize: 30
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.subTextGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey

        onClickOrKeySelected:{
            secondBtnClicked()
        }
        KeyNavigation.left: idFirstBtn
        KeyNavigation.right: idThirdBtn
    }

    //****************************** # Third Button #
    MButton{
        id: idThirdBtn
        x: 110+22+347+347; y: 216+272-systemInfo.statusBarHeight
        width: 347; height: 73
        bgImage: imgFolderPopup+"btn_popup_s_n.png"
        bgImageActive: imgFolderPopup+"btn_popup_s_s.png"
        bgImageFocus: imgFolderPopup+"btn_popup_s_f.png"
        bgImageFocusPress: imgFolderPopup+"btn_popup_s_fp.png"
        bgImagePress: imgFolderPopup+"btn_popup_s_p.png"

        firstText: thirdBtnText
        firstTextX: 10; firstTextY: 36
        firstTextWidth: 327; firstTextHeight: 30
        firstTextSize: 30
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.subTextGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey

        onClickOrKeySelected:{
            thirdBtnClicked()
        }
        KeyNavigation.left: idSecondBtn
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}


