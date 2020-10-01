import Qt 4.7

import "../../system/DH" as MSystem

MComponent {
    id: idDlgTwoLineTwoBtn
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight-systemInfo.statusBarHeight

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string titleName: "input title name"
    property string messages1: "input messages 1"
    property string messages2: "input messages 2"
    property string button1: "Ok"
    property string button2: "Cancel"

    signal button1Clicked();
    signal button2Clicked();

    MSystem.SystemInfo{id:systemInfo}
    MSystem.ImageInfo{id:imageInfo}
    MSystem.ColorInfo{id:colorInfo}

    //**************************************** Under Screen Disable
    MouseArea{ anchors.fill: parent }
    //**************************************** Background Black 80%
    Rectangle{
        id:bgDialog
        width:systemInfo.lcdWidth;
        height:systemInfo.lcdHeight-systemInfo.statusBarHeight;
        anchors.fill: parent
        color: colorInfo.black
        opacity: 0.8
    } // End Rectangle

    //**************************************** Dialog
    FocusScope{
        x:107; y:124-systemInfo.statusBarHeight
        focus: true
        Image{
            source:imgFolderPopup+"bg_popup_b.png"
        }
        //**************************************** Title Text
        Text {
            x:36; y:52-21
            width:500; height:42
            text:titleName
            font.pixelSize: 42
            font.family: "HDR"
            color: colorInfo.brightGrey
        }
        //**************************************** Messages Line 1
        Text {
            text: messages1
            x:100; y:185-18
            width:866; height:36
            font.pixelSize: 36
            font.family: "HDBa1"
            color: colorInfo.brightGrey
        }
        //**************************************** Messages Line 2
        Text {
            x:100; y:185-18+53
            width:866; height:36
            text: messages2
            font.pixelSize: 36
            font.family: "HDBa1"
            color: colorInfo.brightGrey
        }
        //**************************************** Button 1
        Button{
            id: idButton1
            x:165; y:185+53+69
            width: 81+207+81; height: 86
            focus: true
            bgImage: imgFolderPopup+"btn_popup_02_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_02_p.png"
            text: button1
            fontSize: 42
            fontName: "HDR"
            fontColor: colorInfo.brightGrey
            onClickOrKeySelected: {
                button1Clicked()
            }
            onWheelLeftKeyPressed: {
                idButton1.focus = true
            }
            onWheelRightKeyPressed: {
                idButton2.focus = true
            }
            KeyNavigation.left: idButton1
            KeyNavigation.right: idButton2
        }
        //**************************************** Button 2
        Button{
            id: idButton2
            x:165+81+207+81; y:185+53+69
            width: 81+207+81; height: 86
            bgImage: imgFolderPopup+"btn_popup_02_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_02_p.png"
            text: button2
            fontSize: 42
            fontName: "HDR"
            fontColor: colorInfo.brightGrey
            onClickOrKeySelected: {
                button2Clicked()
            }
            onWheelLeftKeyPressed: {
                idButton1.focus = true
            }
            onWheelRightKeyPressed: {
                idButton2.focus = true
            }
            KeyNavigation.left: idButton1
            KeyNavigation.right: idButton2
        }
    }
}
