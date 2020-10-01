import Qt 4.7

import "../../system/DH" as MSystem


Item {
    id: idDlgThreeList
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight-systemInfo.statusBarHeight

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string titleName: "input title name"
    property string messages1: "input messages 1"
    property string messages2: "input messages 2"
    property string messages3: "input messages 3"

    signal dlgClicked()

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
        x:107; y:128-systemInfo.statusBarHeight
        focus: true
        source:imgFolderPopup+"bg_popup_b.png"
        //**************************************** Title Text
        Item{
            id: idTitleName
            x:36; y:52-21
            width:500; height:42
            Text {
                text: titleName
                font.pixelSize: 42
                font.family: "HDR"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        //**************************************** Messages Line 1
        Item {            
            x:42; y:147-18
            width:991; height: 90
            Text {
                text: messages1
                font.pixelSize: 36
                font.family: "HDR"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
            }
            Image {
                anchors.bottom: parent.bottom
                source: imgFolderPopup+"list_line_989.png"
            }
        }
        //**************************************** Messages Line 2
        Item {           
            x:42; y:147+90-18
            width:991; height: 90
            Text {
                text: messages2
                font.pixelSize: 36
                font.family: "HDR"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
            }
            Image {
                anchors.bottom: parent.bottom
                source: imgFolderPopup+"list_line_989.png"
            }
        }
        //**************************************** Messages Line 3
        Item {            
            x:42; y:147+90+90-18
            width:991; height: 90
            Text {
                text: messages3
                font.pixelSize: 36
                font.family: "HDR"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}


