import Qt 4.7

import "../../system/DH" as MSystem

Item {
    id: idDlgThreeLineThreeBtn
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight-systemInfo.statusBarHeight

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property string titleName: "input title name"
    property string messages1: "input messages 1"
    property string messages2: "input messages 2"
    property string messages3: "input messages 3"
    property string button1: "Ok"
    property string button2: "Cancel"
    property string button3: "Close"

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
        x:107; y:124-systemInfo.statusBarHeight
        source:imgFolderPopup+"bg_popup_b.png"
        //**************************************** Title Text
        Item {
            x:36; y:52-21
            width:500; height:42
            Text {
                text:titleName
                font.pixelSize: 42
                font.family: "HDR"
                color: colorInfo.brightGrey
            }
        }
        //**************************************** Messages Line 1
        Item {
            x:100; y:164-18
            width:866; height:36
            Text {
                text: messages1
                font.pixelSize: 36
                font.family: "HDBa1"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //**************************************** Messages Line 2
        Item {
            x:100; y:164+53-18
            width:866; height:36
            Text {
                text: messages2
                font.pixelSize: 36
                font.family: "HDBa1"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //**************************************** Messages Line 3
        Item {
            x:100; y:164+53+53-18
            width:866; height:36
            Text {
                text: messages3
                font.pixelSize: 36
                font.family: "HDBa1"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //**************************************** Button 1
        Button{
            id: idButton1
            x:48; y:165+53+53+55
            width: 322; height: 86
            bgImage: imgFolderPopup+"btn_popup_03_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_03_p.png"
            text: button1
            fontSize: 42
            fontName: "HDR"
            fontColor: colorInfo.brightGrey
            onClicked: {
                button1Clicked()
            }
        }
        //**************************************** Button 2
        Button{
            id: idButton2
            x:48+322+3; y:165+53+53+55
            width: 322; height: 86
            bgImage: imgFolderPopup+"btn_popup_03_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_03_p.png"
            text: button2
            fontSize: 42
            fontName: "HDR"
            fontColor: colorInfo.brightGrey
            onClicked: {
                button2Clicked()
            }
        }
        //**************************************** Button 3
        Button{
            id: idButton3
            x:48+322+3+322+3; y:165+53+53+55
            width: 322; height: 86
            bgImage: imgFolderPopup+"btn_popup_03_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_03_p.png"
            text: button3
            fontSize: 42
            fontName: "HDR"
            fontColor: colorInfo.brightGrey
            onClicked: {
                button3Clicked()
            }
        }
    }
}
