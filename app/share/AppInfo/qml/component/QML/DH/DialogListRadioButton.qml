import Qt 4.7

import "../../system/DH" as MSystem

MComponent {
    id: idDlgListRadioBtn
    width: systemInfo.lcdWidth;
    height: systemInfo.lcdHeight-systemInfo.statusBarHeight

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string radioCheckList: ""
    property string titleName: "Screen Size"
    property ListModel listModel: idModel
    property string button: "Cancel"

    signal listClicked(int listIndex);
    signal buttonClicked()

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
    FocusScope{
        id:dialog
        x:107; y:128-systemInfo.statusBarHeight
        focus: true

        Image{
            source:imgFolderPopup+"bg_popup_d.png"
        }

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

        //**************************************** List Model(TestValue)
        ListModel {
            id: idModel
            ListElement { name: "1";}
            ListElement { name: "2";}
            ListElement { name: "3";}
            ListElement { name: "4";}
        }
        //**************************************** ListView
        FocusScope {
            id: idListViewItem
            x:42; y:130
            width:991; height: 5+26+43+47+169
            focus: true
            ListView {
                id: idListView
                clip: true
                focus: true
                anchors.fill: parent
                model: listModel
                delegate: idDelegate
                orientation : ListView.Vertical
                Keys.onPressed: {
                    if(idAppMain.isWheelLeft(event)){
                        if(idListView.count == 0) return
                        idListView.decrementCurrentIndex();
                    }else if(idAppMain.isWheelRight(event)) {
                        if(idListView.count == 0) return
                        idListView.incrementCurrentIndex();
                    }
                }
            }
            VScrollBar {
                x:idListView.x+idListView.width+9; y:idListView.y+9
                scrollArea: idListView;
                height: idListView.height-9; width: 8
            }
            //**************************************** Delegate
            Component {
                id: idDelegate
                MComponent {
                    id: delegate
                    width:991-9; height: 90
                    focus: true
                    Text {
                        id: idTextName;
                        y: 47-18-10
                        text: name
                        font.pixelSize: 36
                        font.family: "HDR"
                        color: colorInfo.brightGrey
                        wrapMode: Text.Wrap
                    }
                    Image {
                        y: 90
                        source: imgFolderPopup+"list_line_989.png"
                    }
                    RadioButton {
                        id: idRadioBtn
                        x:945; y:21
                        width: 49; height: 50
                        active: radioCheckList == idTextName.text
                    }
                    //**************************************** Active Focus Image
                    BorderImage {
                        id: idBGImage
                        x: -16; y: -9
                        source: (delegate.activeFocus)?imgFolderPopup+"bg_popup_03_f.png":""
                        width: parent.width+32; height: parent.height+9
                        border.left: 20; border.top: 20
                        border.right: 20; border.bottom: 20
                        visible: (inputMode == "jog")
                    }
                    onClickOrKeySelected: {
                        radioCheckList=idTextName.text
                        uiListener.playAudioBeep()
                        listClicked(index);
                        console.log("click: ", idTextName.text + index)
                    }
                }
            }
            KeyNavigation.down: idButton
        }
        //**************************************** Button
        Button{
            id: idButton
            x:297; y: 135+26+43+47+169
            width: 470; height: 86
            bgImage: imgFolderPopup+"btn_popup_01_n.png"
            bgImagePressed: imgFolderPopup+"btn_popup_01_p.png"
            text: button
            fontSize: 42
            fontName: "HDR"
            fontColor: colorInfo.brightGrey
            KeyNavigation.up: idListViewItem
            onClickOrKeySelected: {
                buttonClicked()
            }
        }

    }
}
