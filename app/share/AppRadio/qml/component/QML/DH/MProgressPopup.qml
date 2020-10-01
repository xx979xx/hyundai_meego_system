import QtQuick 1.0
import "../../system/DH" as MSystem

Item{
    id : idMProgressPopup

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    //--------------------- Progress Info(Property) #
    property string imgFolderPopup: imageInfo.imgFolderPopup
    property int popupX : 110
    property int popupY : 216-systemInfo.statusBarHeight
    property int popupWidth : 1087
    property int popupHeight : 385
    property int textX : 45
    property int textY : 0
    property string progressFirstText : ""
    property string progressSecondText : ""
    property int totalCnt : 0
    property int delCnt : 0
    property int persent : ((totalCnt-delCnt)/totalCnt)*100
    property real moveBarWidth: persent*(661/100)

    signal cancelClicked()

    //--------------------- Dim Background #
    Rectangle{
        width: parent.width; height:parent.height
        color: colorInfo.black
        opacity: 0.6
    } // End Rectangle

    //--------------------- Popup Image #
    Image{
        x: popupX; y: popupY
        width: popupWidth; height: popupHeight
        source: imgFolderPopup+"popup_etc_02_bg.png"
    } // End Image

    //--------------------- Frist Text #
    MText{
        id: idFristText
        mTextX: popupX + 45; mTextY: popupY+105
        mText: progressFirstText
        mTextSize: 32
        mTextWidth : 996
        mTextColor: colorInfo.subTextGrey
        mTextAlies: "Center"
    } // End MText

    //--------------------- Second Text #
    MText{
        id: idSecondText
        mTextX: idFristText.mTextX; mTextY: idFristText.mTextY+46
        mText: progressSecondText
        mTextSize: 32
        mTextWidth : 996
        mTextColor: colorInfo.subTextGrey
        mTextAlies: "Center"
    } // End MText
    //--------------------- Progress Bg Image #
    Image {
        id: imgProgressBg
        x: popupX + 212; y: popupY + 214
        source: imgFolderPopup+"progress_n.png"
    } // End Image
    //--------------------- Progress Fg Image #
    Image{
        id: imgProgressFg
        x: popupX+212; y: popupY+214
        width: moveBarWidth
        source: imgFolderPopup+"progress_s.png"
    } // End Image
    //--------------------- Button #
    MButton{
        x: imgProgressBg.x+121; y: imgProgressBg.y+58
        width: 420; height:73
        buttonWidth: width; buttonHeight: height
        focus: true

        bgImage: imgFolderPopup+"btn_popup_l_n.png"
        bgImagePress : imgFolderPopup+"btn_popup_l_p.png"
        bgImageFocus : imgFolderPopup+"btn_popup_l_f.png"
        bgImageFocusPress: imgFolderPopup+"btn_popup_l_fp.png"

        firstText: "Cancel"
        firstTextSize: 30
        firstTextX: 14
        firstTextY: 33
        firstTextWidth: 420-(firstTextX*2)
        firstTextHeight: firstTextSize+4
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.subTextGrey

        onClickOrKeySelected: cancelClicked()
    } // End MButton
} // End Item
