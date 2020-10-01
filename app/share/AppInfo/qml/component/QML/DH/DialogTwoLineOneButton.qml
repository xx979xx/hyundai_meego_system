import Qt 4.7
import "../../system/DH" as MSystem

MComponent {
    id: idDlgTwoLineOneBtn
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string titleName: "input title name"
    property string messages1: "input messages 1"
    property string messages2: "input messages 2"
    property string messages3: ""
    property string messages4: ""
    property string button1: "Stop"

    signal button1Clicked();

    MSystem.SystemInfo{id:systemInfo}
    MSystem.ImageInfo{id:imageInfo}
    MSystem.ColorInfo{id:colorInfo}

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
    //**************************************** Dialog
    Image{
        x:107; y:124-systemInfo.statusBarHeight
        focus: true
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
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        //**************************************** Messages Line 1
        Item {
            x:100; y:185-18
            width:866; height:36
            Text {
                text: messages1 + messages3
                font.pixelSize: 36
                font.family: "HDBa1"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //**************************************** Messages Line 2
        Item {
            x:100; y:185-18+53
            width:866; height:36
            Text {
                text: messages2 + messages4
                font.pixelSize: 36
                font.family: "HDBa1"
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        //**************************************** Button1
        Button{
            id:btnStop
            x:297; y:185+53+69
            width: 470; height: 86
            focus: true
            bgImage: imgFolderPopup+"btn_popup_01_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_01_p.png"
            text: button1
            fontSize: 42
            fontName: "HDR"
            onClickOrKeySelected: {
                button1Clicked()
            }
        }
    }
}
