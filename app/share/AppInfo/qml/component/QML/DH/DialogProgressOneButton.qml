import Qt 4.7

import "../../system/DH" as MSystem

Item {
    id: idDlgProgressOneBtn
    width: systemInfo.lcdWidth;
    height: systemInfo.lcdHeight-systemInfo.statusBarHeight

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string titleName: "input title name"
    property string messages1: "input messages 1"
    property string messages2: "input messages 2"
    property string messages3: ""
    property string button1: "Ok"

    signal button1Clicked()

    MSystem.SystemInfo{id:systemInfo}
    MSystem.ImageInfo{id:imageInfo}
    MSystem.ColorInfo{id:colorInfo}

    //**************************************** Under Screen Disable
    MouseArea{ anchors.fill: parent }
    //**************************************** Background Black 80%
    Rectangle{
        id: bgDialog
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
        //**************************************** Messages Line 1
        Item{
            x:203 + 94; y: 173 - 18
            width:470; height:36
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
        Item{
            x:203 + 94; y: 173 +66- 18
            width:470; height:36
            Text {
                text: messages2 + messages3
                font.pixelSize: 36
                font.family: "HDBa1"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //**************************************** ProgressBar
        ProgressBar {
            x: 203; y: 173+66+40
            width: 661; height: 13
            //source: imgFolderPopup + "progress_bg.png"
            //source: imgFolderPopup + "progress_bar.png"
        }
        //**************************************** Button 1
        Button{
            id:btnStop
            x:297; y:173+66+40+57
            width: 470; height: 86
            focus: true
            bgImage: imgFolderPopup+"btn_popup_01_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_01_p.png"
            text: button1
            fontSize: 42
            fontName: "HDR"
            onClicked: {
                button1Clicked()
            }
        }
    }
}
