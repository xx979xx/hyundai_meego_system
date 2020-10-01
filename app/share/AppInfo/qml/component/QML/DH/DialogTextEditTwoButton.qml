import Qt 4.7

import "../../system/DH" as MSystem

MComponent {
    id: idDlgTextEditTwoBtn
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight-systemInfo.statusBarHeight
    focus: true

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property string titleName: "input title name"
    property string messages1: "input messages 1"
    property string button1: "Ok"
    property string button2: "Cancel"

    signal button1Clicked()
    signal button2Clicked()

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
        source:imgFolderPopup+"bg_popup_c.png"
        focus: true
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
        //**************************************** Messages Text
        Flickable {
             id: flick
             x:100; y:164-18
             width:866; height: 53*4
             contentX:100; contentY: 164-18
             contentWidth: idTextInput.paintedWidth
             contentHeight: idTextInput.paintedHeight
             flickableDirection: Flickable.VerticalFlick;
             boundsBehavior : Flickable.DragOverBounds//Flickable.StopAtBounds
             clip: true

             function ensureVisible(r)
             {
                 if (contentX >= r.x)
                     contentX = r.x;
                 else if (contentX+width <= r.x+r.width)
                     contentX = r.x+r.width-width;
                 if (contentY >= r.y)
                     contentY = r.y;
                 else if (contentY+height <= r.y+r.height)
                     contentY = r.y+r.height-height;
             }

            TextEdit{
                id:idTextInput
                width:866; height: 53*4
                text: messages1
                font.pixelSize: 36
                font.family: "HDBa1"
                color: colorInfo.brightGrey
                activeFocusOnPress: false
                cursorVisible: false
                readOnly: true
                wrapMode: TextEdit.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        VScrollBar {
            x:flick.x+flick.width; y:flick.y+9
            scrollArea: flick;
            height: flick.height-9; width: 8
        }


        //**************************************** Button 1
        Button{
            id: idButton1
            x:165; y:165+53+53+53+55
            width: 81+207+81; height: 86
            focus: true
            bgImage: imgFolderPopup+"btn_popup_02_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_02_p.png"
            text: button1
            fontSize: 42
            fontName: "HDR"
            fontColor: colorInfo.brightGrey
            onClickOrKeySelected:{
                button1Clicked()
            }
            onWheelRightKeyPressed: idButton2.focus = true
            KeyNavigation.right: idButton2
        }
        //**************************************** Button2
        Button{
            id: idButton2
            x:165+81+207+81; y:165+53+53+53+55
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
            onWheelLeftKeyPressed:idButton1.focus = true
            KeyNavigation.left: idButton1
        }
    }
}
