import Qt 4.7

import "../../system/DH" as MSystem

FocusScope {
    id: idDlgOneLineTwoBtn
    width: systemInfo.lcdWidth;
    height: systemInfo.lcdHeight-systemInfo.statusBarHeight
    focus: true
    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string titleName: "input title name"
    property string messages1: "input messages 1"
    property string button1: "OK"
    property string button2: "Cancel"
    property string button3: "OFF"

    signal button1Clicked()
    signal button2Clicked()
    signal button3Clicked()

    MSystem.SystemInfo{id:systemInfo}
    MSystem.ImageInfo{id:imageInfo}
    MSystem.ColorInfo{id:colorInfo}

    //**************************************** Under Screen Disable
    MouseArea{ anchors.fill: parent }
    //**************************************** Background Black 80%
    Rectangle{
        id:bgDialog
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight-systemInfo.statusBarHeight
        color: colorInfo.black
        opacity: 0.8
    }
    //**************************************** Dialog
    Image{
        x:107
        y:124-systemInfo.statusBarHeight
        focus: true
        source:imgFolderPopup+"bg_popup_b.png"
        //**************************************** Title Text
        Item{
            x:36; y:52-21
            width:500; height:42
            Text {
                text:titleName
                font.pixelSize: 42
                font.family: "HDR"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        //****************************************  Messages Line 1
        Item{
            x:252; y:203-18
            width:562; height:36;
            Text {
                text: messages1
                font.pixelSize: 36
                font.family: "HDBa1"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //****************************************  Button 1
        Button{
            id: idBtn1
            x:48; y:203+83
            width: 322; height: 86
            focus: true
            bgImage: imgFolderPopup+"btn_popup_03_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_03_p.png"
            text: button1
            fontSize: 42
            fontName: "HDR"
            onClickOrKeySelected: {
                button1Clicked()
            }
            KeyNavigation.right: idBtn2
        }
        //**************************************** Button2
        Button{
            id: idBtn2
            x: 48+322+3; y:203+83
            width: 322; height: 86
            bgImage: imgFolderPopup+"btn_popup_03_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_03_p.png"
            text: button2
            fontSize: 42
            fontName: "HDR"
            onClickOrKeySelected: {
                button2Clicked()
            }
            KeyNavigation.left: idBtn1
            KeyNavigation.right: idBtn3
        }
        //**************************************** Button3
        Button{
            id: idBtn3
            x: 48+322+3+322+3; y:203+83
            width: 322; height: 86
            bgImage: imgFolderPopup+"btn_popup_03_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_03_p.png"
            text: button3
            fontSize: 42
            fontName: "HDR"
            onClickOrKeySelected: {
                button3Clicked()
            }
            KeyNavigation.left: idBtn2
        }
    }
}

