import Qt 4.7

import "../../system/DH" as MSystem

Item {
    id: idDlgThreeLine
    width: systemInfo.lcdWidth;
    height: systemInfo.lcdHeight-systemInfo.statusBarHeight

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string titleName: "input title name"
    property string messages1: "input messages 1"
    property string messages2: "input messages 2"
    property string messages3: "input messages 3"

    MSystem.SystemInfo{id:systemInfo}
    MSystem.ImageInfo{id:imageInfo}
    MSystem.ColorInfo{id:colorInfo}

    signal dlgClicked()

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
        id: idDialog
        x: 107; y: 194-systemInfo.statusBarHeight
        width: 1066; height: 306
        source:imgFolderPopup+"bg_popup_a.png"
        //****************************************  Title Text
        Item {
            x: 36; y: 52-21
            width: 500; height: 42
            Text {
                text: titleName
                font.pixelSize: 42
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        //**************************************** Messages Line 1
        Item {
            x: 100; y: 148-18
            width: 866; height: 36
            Text {
                text: messages1
                font.pixelSize: 36
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //**************************************** Messages Line 2
        Item {
            x: 100; y: 148+51-17
            width: 866; height: 36
            Text {
                text: messages2
                font.pixelSize: 36
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //**************************************** Messages Line 3
        Item {
            x: 100; y: 148+51+51-17
            width: 866; height: 36
            Text {
                text: messages3
                font.pixelSize: 36
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
