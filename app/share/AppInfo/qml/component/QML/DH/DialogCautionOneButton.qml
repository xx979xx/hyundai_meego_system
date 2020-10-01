/**
 * FileName: DialogCautionOneButton.qml
 * Author: Hyang
 * Time: 2011-12-30
 **/

import Qt 4.7
import "../../system/DH" as MSystem

MComponent {
    id: idDlgCautionTwoLineOneBtn
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight    

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property int lineCount: 3       //Line Number Input
    property string firstText: ""   //First Line Text Input
    property string secondText: ""  //Second Line Text Input
    property string buttonText: ""  //Button`s Text Input

    property int dialogY: 0
    property int dialogHeight: 0
    property int cautionY: 0
    property int buttonY: 0
    property int firstTextY: 0
    property int secondTextY: 0
    property int thirdTextY: 0

    signal button1Clicked();
    signal hardBackKeyClicked();

    MSystem.SystemInfo{id:systemInfo}
    MSystem.ImageInfo{id:imageInfo}
    MSystem.ColorInfo{id:colorInfo}

    //**************************************** Dialog Size Control Function
    function dialogBackgroundByLineCount(){
        if(lineCount == 1){
            dialogY = 194-systemInfo.statusBarHeight
            dialogHeight = 306
            cautionY = dialogY+32
            buttonY = dialogY+32+106+54
            firstTextY = 32+106-36
            return imgFolderPopup+"bg_popup_e.png"
        }
        else if(lineCount == 2){
            dialogY = 158-systemInfo.statusBarHeight
            dialogHeight = 382
            cautionY = dialogY+39
            buttonY = dialogY+39+106+60+54
            firstTextY = 39+106-36
            secondTextY = 39+106+60-36
            return imgFolderPopup+"bg_popup_f.png"
        }
        else if(lineCount == 3){
            dialogY = 123-systemInfo.statusBarHeight
            dialogHeight = 456
            cautionY = dialogY+48
            buttonY = dialogY+48+106+60+60+54
            firstTextY = 48+106-36
            secondTextY = 48+106+60-36
            thirdTextY = 48+106+60+60-36
            return imgFolderPopup+"bg_popup_g.png"
        }
    }
    //**************************************** Under Screen Disable
    MouseArea{ anchors.fill: parent }
    //**************************************** Background Black 80%
    Rectangle{
        id:bgDialog
        width:systemInfo.lcdWidth; height:systemInfo.subMainHeight
        anchors.fill: parent
        color: colorInfo.black
        opacity: 0.8
    }
    //**************************************** Dialog Background Image
    Image{
        x: 107; y: dialogY
        width: 1066; height: dialogHeight
        source: dialogBackgroundByLineCount()
    }    
    //**************************************** Caution Image
    Image {
        x: 107+89+415; y: cautionY
        width: 62; height: 55
        source: imgFolderPopup + "icon_popup_caution.png"
    }
    //**************************************** Text
    Item{
        x: 107+89; y: dialogY
        width: 415+476; height: 100
        //------------------------------------ First Text
        Text {
            y: firstTextY
            text: firstText
            font.pixelSize: 36
            font.family: "HDBa1"
            color: colorInfo.brightGrey
            anchors.horizontalCenter: parent.horizontalCenter
            visible: lineCount == 1 || lineCount == 2 || lineCount == 3
        }
        //------------------------------------ Second Text
        Text {
            y: secondTextY
            text: secondText
            font.pixelSize: 36
            font.family: "HDBa1"
            color: colorInfo.brightGrey
            anchors.horizontalCenter: parent.horizontalCenter
            visible: lineCount == 2 || lineCount == 3
        }
        //------------------------------------ Third Text
        Text {
            y: thirdTextY
            text: "AsdfasdfasD"//thirdText
            font.pixelSize: 36
            font.family: "HDBa1"
            color: colorInfo.brightGrey
            anchors.horizontalCenter: parent.horizontalCenter
            visible: lineCount == 3
        }
    }
    //**************************************** Button Text
    Button{
        id: button1
        x: 107+297; y: buttonY
        width: 470; height: 86
        focus: true
        bgImage: imgFolderPopup+"btn_popup_01_n.png"
        bgImagePressed: imgFolderPopup+"btn_popup_01_p.png"
        text: buttonText
        fontSize: 42
        fontName: "HDR"
        onClickOrKeySelected: {
            button1.forceActiveFocus()
            button1Clicked()
        }
    }
    //------------------------------------ Hard Key (Back Key)
    onBackKeyPressed: {
        button1.forceActiveFocus()
        hardBackKeyClicked()
    }    
}
