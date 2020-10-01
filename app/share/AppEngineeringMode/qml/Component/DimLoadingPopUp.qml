/**
 * FileName: MLoadingPopup.qml
 * Author: HYANG
 * Time: 2012-04
 *
 * - 2012-04 Initial Created by HYANG
 */

import QtQuick 1.0
import "../System" as MSystem

MComponent{
    id: idMLoadingPopup
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string popupName

    property int textLineCount: 2

    property string firstContentText: ""          //# Text
    property string secondContentText: ""
    property string addSecondContentText: ""
    property string thirdContentText: ""

    property string firstBtnText: ""            //# button Text

    signal firstBtnClicked()
    signal popupClicked()
    signal hardBackKeyClicked()

    //MouseArea{ anchors.fill: parent }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height:parent.height
        color: colorInfo.black
        opacity: 0.7
    }
    //****************************** # Preset Background #
    Image{
        id: idPopupBg
        x: 110; y: popupBgYHeight()
       // width: 1087; height: 385
        source: popupBgImage()
        //        MouseArea{
        //            anchors.fill: parent
        //            onClicked: popupClicked()
        //        }
    }

    function popupBgImage(){
        if(textLineCount==1) return imgFolderPopup+"popup_etc_01_bg.png"
        else if(textLineCount==2) return imgFolderPopup+"popup_etc_02_bg.png"
        else if(textLineCount==3) return imgFolderPopup+"popup_etc_03_bg.png"
    }

    function popupBgYHeight(){
        if(textLineCount==1) return 258-systemInfo.statusBarHeight
        else if(textLineCount==2) return 216-systemInfo.statusBarHeight
        else if(textLineCount==3) return 174-systemInfo.statusBarHeight
    }
    //**************************************** Loading Image
    Image {
        id: idImageContainer
        x: 110+45+288+173 ; y: textLineCount==2? idPopupBg.y+55 : idPopupBg.y+65
        width: 74; height: 74
        source: imgFolderPopup + "loading/loading_01.png";
        visible: idImageContainer.on
        property bool on: parent.visible;
        NumberAnimation on rotation { running: idImageContainer.on; from: 360; to: 0; loops: Animation.Infinite; duration: 2400 }
    }
    //****************************** # Preset Title Text #
    Text{
        text: firstContentText
        x: 110+45; y: firstTextYHeight()
        width: 996; height: 32
        font.pixelSize: 32
        font.family: UIListener.getFont(true)/*"HDB"*/
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
    }
    Text{
        id: secondText
        text: secondContentText + "<font color=#7CBDFF>" + addSecondContentText + "</font>"
        x: 110+45; y: textLineCount==2? idPopupBg.y+55+122+46-32/2 : idPopupBg.y+65+140+46-32/2
        width: 996; height: 32
        font.pixelSize: 32
        font.family: UIListener.getFont(true)/*"HDB"*/
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
    }
    Text{
        text: thirdContentText
        x: 110+45; y: idPopupBg.y+65+140+46+46-32/2
        width: 996; height: 32
        font.pixelSize: 32
        font.family: UIListener.getFont(true)/*"HDB"*/
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "#7CBDFF" //RGB(124,189,255)
    }

    function firstTextYHeight(){
        if(textLineCount==1) return idPopupBg.y+65+143-32/2
        else if(textLineCount==2) return idPopupBg.y+55+122-32/2
        else if(textLineCount==3) return idPopupBg.y+65+140-32/2
    }
    //****************************** # First Button #
    MButton{
        id: idFirstBtn
        x: 110+45+288; y: textLineCount==2? idPopupBg.y+55+122+46+49 : idPopupBg.y+65+140+46+46+61
        width: 420; height: 73
        focus: true
        bgImage: imgFolderPopup+"btn_popup_l_n.png"
        bgImageActive: imgFolderPopup+"btn_popup_l_s.png"
        bgImageFocus: imgFolderPopup+"btn_popup_l_f.png"
        bgImageFocusPress: imgFolderPopup+"btn_popup_l_fp.png"
        bgImagePress: imgFolderPopup+"btn_popup_l_p.png"
        visible: textLineCount != 1

        firstText: firstBtnText
        firstTextX: 14; firstTextY: 33
        firstTextWidth: 394; firstTextHeight: 30
        firstTextSize: 30
        firstTextStyle: "HDB"
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


