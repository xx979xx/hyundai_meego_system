/**
 * FileName: MBand.qml
 * Author: HYANG
 * Time: 2012-04
 *
 * - 2012-04 Initial Created by HYANG
 *   (tab count changed only one, BT Tab added)
 */

import QtQuick 1.0
import "../System" as MSystem
import "../Component" as MComp

MComponent {
    id: idMBand
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral
    property string imgFolderModeArea : imageInfo.imgFolderModeArea
    //property string imgFolderXMData : imageInfo.imgFolderXMData
    property alias bandSubButton : idSubKey
    property alias bandSub1Button: idSub1Key
    property alias bandSub2Button: idSub2Key
    property alias backKeyButton: idBackKey
    property alias bandLogSaveKey: idLogSaveKey
    property alias bandSubButtonWidth: idSubKey.width;
    property alias bandSub1ButtonWidth: idSub1Key.width;
    property alias bandSub2ButtonWidth: idSub2Key.width;
    property alias bandSubButtonTextSize: idSubKey.firstTextSize
    property alias bandSub1ButtonTextSize: idSub1Key.firstTextSize
    property alias bandSub2ButtonTextSize: idSub2Key.firstTextSize
    property alias bandSubButtonfirstTextX: idSubKey.firstTextX
    property alias bandSubButtonfirstTextWidth: idSubKey.firstTextWidth
    property alias bandSub2ButtonfirstTextWidth: idSub2Key.firstTextWidth

    property string titleText: "" //[user control] Title`s Label Text
    property string subTitleText: "" //[user control] Sub Title`s Label Text
    property string subKeyText: ""   //[user control] subKey`s Text
    property string subKey1Text: ""
    property string subKey2Text: ""
    property string logSaveKeyText: ""
    property string signalText: ""  //[user control]
    property int curListNumber: 0  //[user control] current item number of list
    property int totListNumber: 0  //[user control] total item number of list

    property bool signalTextFlag: false   //[user control] signal Text On/Off
    property bool listNumberFlag: false   //[user control] list number On/Off
    property bool tabBtnFlag: false  //[user control] BandTab button On/Off
    property bool subBtnFlag: false //[user control] Left button of backkey is On/Off (List button)
    property bool subBtnFlag1: false
    property bool subBtnFlag2: false
    property bool logSaveBtnFlag: false
    property string selectedApp: "" //[user control] "BT" | "XMData" etc...
    property bool titleFavoriteImg: false   //[user control] star image

    property string selectedBand: ""
    property string firstTabText: ""    //[user control] Text in band button


    //****************************** # Signal (when button clicked) #
    signal subKeyClicked();
    signal subKey1Clicked();
    signal subKey2Clicked();
    signal backKeyClicked();
    signal logSaveKeyClicked();

    //****************************** # Band Background Image #
    Image{
        x: 0; y: 0
        source: imgFolderModeArea+"bg_title.png"
    }

    //****************************** # Active Band Tab Button #
    MButtonTouch{
        id: firstTabBtn
        x: 0; y: 0
        buttonName: firstTabText
        width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight
        bgImage: ""/*selectedApp=="BT"? imgFolderModeArea+"btn_title_bt_01_s.png" : imgFolderModeArea+"btn_title_media_01_s.png"*/
        bgImagePress: "" /*selectedApp=="BT"? imgFolderModeArea+"btn_title_bt_01_s.png" : imgFolderModeArea+"btn_title_media_01_s.png"*/
        visible: tabBtnFlag


        firstText: firstTabText
        firstTextX: 15; firstTextY: 132-systemInfo.statusBarHeight
        firstTextWidth: selectedApp=="BT"? 184 : 149
        firstTextSize: 30
        firstTextStyle: "HDB"
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        onClickOrKeySelected: {}
    }

    Image{
        source: "" /*titleFavoriteImg? imgFolderXMData+"ico_title_fav.png" : ""*/
        x: 25; y: 104-systemInfo.statusBarHeight
        width: 48; height: 48
        visible: titleFavoriteImg
    }

    //****************************** # Title Text #
    Text{
        id: txtTitle
        text: titleText
        x: titleFavoriteImg? 25+58 : 45;
        y: 129-systemInfo.statusBarHeight-40/2
        width: txtTitle.paintedWidth//830;
        height: 40
        font.pixelSize: 25
        font.family: UIListener.getFont(true)/*"HDB"*/
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: !tabBtnFlag
    }

    //****************************** # Sub Title Text #
    Text{
        id: txtSubTitle
        text: subTitleText
        x: titleFavoriteImg? 25+58+txtTitle.paintedWidth+23 : 45+txtTitle.paintedWidth+23;
        y: 129-systemInfo.statusBarHeight-26/2
        width: 830-txtTitle.paintedWidth-23; height: 26
        font.pixelSize: 26
        font.family: UIListener.getFont(false)/*"HDR"*/
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.dimmedGrey
        elide: Text.ElideRight
        visible: !tabBtnFlag
    }

    //****************************** # List Number Text #
    Text{
        id: txtListNumber
        text: curListNumber+"/"+totListNumber
        x: subBtnFlag? 875 : 993; y: 129-systemInfo.statusBarHeight-30/2
        width: 146; height: 30
        font.pixelSize: 30
        font.family: UIListener.getFont(true)/*"HDB"*/
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color:  "#7CBDFF" //RGB(124,189,255)
        visible: listNumberFlag
    }

    //****************************** # Signal Text(TEST) #
    Text{
        id: txtSignal
        text: signalText
        x: subBtnFlag? 675 : 793; y: 129-systemInfo.statusBarHeight-30/2
        width: 350; height: 30
        font.pixelSize: 30
        font.family: UIListener.getFont(true)/*"HDB"*/
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color:  "#7CBDFF" //RGB(124,189,255)
        visible: signalTextFlag
    }
    //****************************** # SubKey1 button #
    MButtonTouch{
        id: idLogSaveKey
        x: 510/*580*/ ; y: 0
        width: 150; height: 73
        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""
        visible: logSaveBtnFlag
        onClickOrKeySelected: {
            logSaveKeyClicked()
        }

        firstText: logSaveKeyText
        firstTextX: 0/*9*/; firstTextY: 37
        firstTextWidth:  150/*103*/
        firstTextSize: 23
        firstTextStyle: "HDB"
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
    }
    //****************************** # SubKey1 button #
    MButtonTouch{
        id: idSub1Key
        x: 680/*580*/ ; y: 0
        width: 150; height: 73
        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""
        visible: subBtnFlag1
        onClickOrKeySelected: {
            subKey1Clicked()
        }

        firstText: subKey1Text
        firstTextX: 0/*9*/; firstTextY: 37
        firstTextWidth:  150/*103*/
        firstTextSize: 23
        firstTextStyle: "HDB"
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
    }
    //****************************** # SubKey2 button #
    MButtonTouch{
        id: idSub2Key
        x: 830/*780*/ ; y: 0
        width: 180; height: 73
        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""
        visible: subBtnFlag2
        onClickOrKeySelected: {
            subKey2Clicked()
        }

        firstText: subKey2Text
        firstTextX: 0/*9*/; firstTextY: 37
        firstTextWidth:  150/*160*//*103*/
        firstTextSize: 30
        firstTextStyle: "HDB"
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
    }

    //****************************** # SubKey button #
    MButtonTouch{
        id: idSubKey
        x: selectedApp=="XMData"? 1038-72 : 980 -21 /*1038*/; y: 0
        width: selectedApp=="XMData"? 193 : 180/*121*/; height: 73
        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""
        visible: subBtnFlag
        onClickOrKeySelected: {
            subKeyClicked()
        }

        firstText: subKeyText
        firstTextX: 9; firstTextY: 15/*37*/
        firstTextWidth: selectedApp=="XMData"? 174 : 160/*103*/
        firstTextSize: 30
        firstTextStyle: "HDB"
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
    }
    //****************************** # BackKey button #
    MButtonTouch{
        id: idBackKey
        x: 1038+121-21; y: 0
        width: 141; height: 72
        bgImage: imgFolderNewGeneral + "btn_title_back_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_back_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_back_f.png"
        fgImage: ""
        fgImageActive: ""



        onClickOrKeySelected: {
            backKeyClicked()
        }
    }
}
