/**
 * FileName: MBand.qml
 * Author: HYANG
 * Time: 2012-02-13
 *
 * - 2012-02-13 Initial Crated by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

FocusScope {
    id: idMBand
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight
    focus: true
    property bool backBtnShowFocus : true
    state: "normal"

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string titleText: "" //[user control] Title`s Label Text
    property bool isArab: false

    //****************************** # Signal (when button clicked) #
    signal backKeyClicked();

    //****************************** # Band Background Image #
    Rectangle {
       x: 0; y: 0
       anchors.fill: parent
       color: "black"
    }

    Image {
        x: 0; y: 0
        source: imgFolderGeneral+"bg_title.png"
    }

    //****************************** # Title Text #
    Text {
        id: txtTitle
        text: titleText
        x: 46
        y: 129-systemInfo.statusBarHeight-26/2
        width: 830; height: 26
        font.pixelSize: 40
        font.family: "DH_HDB"
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }

    //****************************** # BackKey button #
    MButton {
        id: idBackKey
        x: systemInfo.backKeyX
        y: 0
        width: systemInfo.widthBackKey; height: systemInfo.heightBackKey
        bgImage: imgFolderGeneral+"btn_title_back_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_back_p.png"
        bgImageFocusPress: imgFolderGeneral+"btn_title_back_fp.png"
        bgImageFocus: imgFolderGeneral+"btn_title_back_f.png"
        focus: true
        showFocus: backBtnShowFocus
        onClicked: backKeyClicked()  //onClickOrKeySelected: backKeyClicked()
    }

    states: [
        State {
            name: "normal"; when: idMBand.isArab==false
            PropertyChanges {target: txtTitle; x:46}
            PropertyChanges {target: txtTitle; horizontalAlignment:Text.AlignLeft}
            PropertyChanges {target: idBackKey; x:systemInfo.backKeyX}
            PropertyChanges {target: idBackKey; bgImage:imgFolderGeneral+"btn_title_back_n.png"}
            PropertyChanges {target: idBackKey; bgImagePress:imgFolderGeneral+"btn_title_back_p.png"}
            PropertyChanges {target: idBackKey; bgImageFocusPress:imgFolderGeneral+"btn_title_back_fp.png"}
            PropertyChanges {target: idBackKey; bgImageFocus:imgFolderGeneral+"btn_title_back_f.png"}
        },
        State {
            name: "reverse"; when: idMBand.isArab==true
            PropertyChanges {target: txtTitle; x:systemInfo.lcdWidth - 46 - txtTitle.width}
            PropertyChanges {target: txtTitle; horizontalAlignment:Text.AlignRight}
            PropertyChanges {target: idBackKey; x: 3}
            PropertyChanges {target: idBackKey; bgImage:imgFolderGeneral+"arab/btn_title_back_n.png"}
            PropertyChanges {target: idBackKey; bgImagePress:imgFolderGeneral+"arab/btn_title_back_p.png"}
            PropertyChanges {target: idBackKey; bgImageFocusPress:imgFolderGeneral+"arab/btn_title_back_p.png"}
            PropertyChanges {target: idBackKey; bgImageFocus:imgFolderGeneral+"arab/btn_title_back_f.png"}
        }

    ]
}
