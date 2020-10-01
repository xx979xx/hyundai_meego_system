import Qt 4.7

import "../../system/DH" as MSystem
//import "../../../component/Dmb" as MDmb

MComponent {
    id: idDialogList1Btn
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight-83

    property string imageFolderPopup: imageInfo.imgFolderPopup
    property string cancelButtonVisible: "false"

    signal listClicked(int listIndex);
    signal buttonClicked();

    MSystem.SystemInfo{id:systemInfo}
    MSystem.ImageInfo{id:imageInfo}
    MSystem.ColorInfo{id:colorInfo}
    MDmb.DmbStringInfo{id:stringInfo }

    MouseArea{
        anchors.fill: parent
    }
    //**************************************** Background Black 80%
    Rectangle{
        id:bgDialog
        anchors.fill: parent
        color: colorInfo.black
        opacity: 0.8
    }
    //**************************************** Dialog
    FocusScope{
        id:dialog
        anchors.fill: parent
        focus: true
        Image{
            x:107; y:128-83
            focus: true
            source:imageFolderPopup+"bg_popup_d.png"
            //**************************************** Title Text
            Item{
                id: idTitleName
                x:36; y:52-21
                width:500; height:42
                //color: colorInfo.transparent
                Text {
                    text:stringInfo.strPOPUP_TITLE_SearchRange
                    font.pixelSize: 42
                    font.family: "HDR"
                    color: colorInfo.brightGrey
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            //**************************************** Title X button
            Button{
                id:btn
                x:955; y:15
                width:99; height:77
                bgImage: imageFolderPopup+"btn_close_n.png"
                bgImagePressed:imageFolderPopup+"btn_close_p.png"
                visible:cancelButtonVisible
                onClickOrKeySelected: {
                    buttonClicked();
                }
            }
            //**************************************** Body List Infomation
            ListModel {
                id: idAreaModel
                ListElement { name: "Current location";}
                ListElement { name: "Capital area";}
                ListElement { name: "Whole country";}
            }

            ListView {
                id: idAreaView

                x:42; y:130
                width:991; height: 90*3//31+43+33+43+78
                focus: true
                KeyNavigation.down: btnCancel
                opacity : 1
                clip: true
                //anchors.fill: parent
                model: idAreaModel
                delegate: idAreaDelegate
                orientation : ListView.Vertical
                highlightMoveSpeed: 9999999
            }

            Component {
                id: idAreaDelegate

                FocusScope {
                    id:delegate
                    focus: true
                    width:991; height: 90
                    Text {
                        id: txtArea;
                        x: 14; y: 31-18
                        text: name
                        font.pixelSize: 36
                        font.family: "HDR"
                        color: colorInfo.brightGrey
                    }
                    Image {
                        anchors.bottom: parent.bottom
                        source: imageFolderPopup+"list_line_989.png"
                    }

                    //**************************************** Active Focus Image
                    BorderImage {
                        id: idBGImage
                        x: -14; y: -9
                        source: (delegate.activeFocus)?imageFolderPopup+"bg_popup_03_f.png":""
                        width: parent.width+28; height: parent.height+9
                        border.left: 20; border.top: 20
                        border.right: 20; border.bottom: 20
                        visible: (inputMode == "jog")
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            uiListener.playAudioBeep()
                            listClicked(index);
                            delegate.focus = true
                            console.log("click: ", txtArea.text + index)
                        }
                    }
                    Keys.onPressed:{
                        if(event.key == Qt.Key_Return || event.key == Qt.Key_Enter){
                            listClicked(index);
                            console.log("click: ", txtArea.text + index)
                        }
                        else if(event.key == Qt.Key_Minus){
                            if(idAreaView.count == 0) return
                            idAreaView.decrementCurrentIndex()
                        }
                        else if(event.key == Qt.Key_Equal){
                            if(idAreaView.count == 0) return
                            idAreaView.incrementCurrentIndex()
                        }
                    }
                }
            }

            //**************************************** 1 Cancel Button
            Button{
                id: btnCancel
                x:297; y: 135+26+43+47+169
                width: 470; height: 86
                bgImage: imageFolderPopup+"btn_popup_01_n.png"
                bgImagePressed: imageFolderPopup+"btn_popup_01_p.png"
                text: stringInfo.strPOPUP_BUTTON_Cancel
                fontSize: 42
                fontName: "HDR"
                fontColor: colorInfo.brightGrey
                onClickOrKeySelected: {
                    buttonClicked();
                }
                KeyNavigation.up: idAreaView
            }
        }
    }

    // Loading Completed!!
    Component.onCompleted: {
        var i;
        for(i = 0; i < idAreaView.count; i++)
        {
            //console.log("["+i+"]:" + idAreaView.model.get(i).name);
            switch(i){
            case 0:{
                idAreaView.model.get(i).name = stringInfo.strPOUP_LIST_Search_CurrentLocation
                break;
            }
            case 1:{
                idAreaView.model.get(i).name = stringInfo.strPOUP_LIST_Search_Capital
                break;
            }
            case 2:{
                idAreaView.model.get(i).name = stringInfo.strPOUP_LIST_Search_WholeCountry
                break;
            }
            default:
                break;
            }
        }
    }
}

