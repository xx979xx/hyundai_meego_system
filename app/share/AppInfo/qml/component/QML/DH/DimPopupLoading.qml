import Qt 4.7
import "../../system/DH" as MSystem

Item{
    id: idDimPopup
    x: 265; y:333-systemInfo.statusBarHeight
    width: 750; height: 190

    property string imgFolderPopup : imageInfo.imgFolderPopup
    property string imgFolderSettings : imageInfo.imgFolderSettings
    property string messages1: "input messages"

    signal dlgClicked()

    MSystem.SystemInfo { id:systemInfo }
    MSystem.ColorInfo { id:colorInfo }
    MSystem.ImageInfo { id:imageInfo }

    //************************ Under Screen Disable ***// 20120103-KEH
    MouseArea{
        x: -265; y: -(333-systemInfo.statusBarHeight)
        width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    }

    //**************************************** Background Image
    Image {
        source: imgFolderPopup + "popup_bg_dim.png"
    }
    //**************************************** Loading Image
    Image {
        id: idImageContainer
        x:70; y:70
        width:52; height:52
        source: imgFolderSettings + "loading_s_01.png";
        visible: idImageContainer.on
        property bool on: parent.visible;
        NumberAnimation on rotation { running: idImageContainer.on; from: 360; to: 0; loops: Animation.Infinite; duration: 2400 }
    }
    //**************************************** Messages Line 1
    Label {
        text: messages1
        txtAlign: "Center"
        fontSize: 34
        fontColor: colorInfo.brightGrey
    }
/* Bluetooth Setting Test
    Item{//Debug code
        visible:debugCode
        Rectangle{
            width:200
            height:20
            Text{text:"bluetoothServiceChangedOk";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected02 = false
                    idSettingsBtDialogPopup.popupSelected021 = true
                }
            }
        }

        Rectangle{
            width:200
            height:20
            y:25
            Text{text:"bluetoothServiceChangedNG";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected022 = true
                    changeServiceSwitch()
                }
            }
        }

        Rectangle{
            width:200
            height:20
            y:25+25
            Text{text:"bluetoothDiscoverableChangedOk";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected02 = false
                    idSettingsBtDialogPopup.popupSelected021 = true
                }
            }
        }

        Rectangle{
            width:200
            height:20
            y:25+25+25
            Text{text:"bluetoothDiscoverableChangedNG";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected022 = true
                    changeDiscoverableSwitch()
                }
            }
        }

        Rectangle{
            width:200
            height:20
            y:25+25+25+25
            Text{text:"bluetoothAutoConnChangedOk";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected02 = false
                    idSettingsBtDialogPopup.popupSelected021 = true
                }
            }
        }

        Rectangle{
            width:200
            height:20
            y:25+25+25+25+25
            Text{text:"bluetoothAutoConnChangedNG";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected02 = false
                    idSettingsBtDialogPopup.popupSelected022 = true
                    selectAutoConnList=subSelectAutoConnList

                }
            }
        }

        Rectangle{
            width:200
            height:20
            x:250
            Text{text:"BluetoothInitializeRecentCallHistoryOK";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected01 = false
                    idSettingsBtDialogPopup.popupSelected011 = true
                }
            }
        }

        Rectangle{
            width:200
            height:20
            x:250
            y:25
            Text{text:"BluetoothInitializeRecentCallHistoryNG";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected01 = false
                    idSettingsBtDialogPopup.popupSelected012 = true
                }
            }
        }

        Rectangle{
            width:200
            height:20
            x:250
            y:25+25
            Text{text:"BluetoothInitializePhoneBookOK";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected01 = false
                    idSettingsBtDialogPopup.popupSelected011 = true
                }
            }
        }

        Rectangle{
            width:200
            height:20
            x:250
            y:25+25+25
            Text{text:"BluetoothInitializePhoneBookNG";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected01 = false
                    idSettingsBtDialogPopup.popupSelected012 = true
                }
            }
        }

        Rectangle{
            width:200
            height:20
            x:250
            y:25+25+25+25
            Text{text:"BluetoothInitializePairedDeviceOK";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected01 = false
                    idSettingsBtDialogPopup.popupSelected011 = true
                }
            }
        }

        Rectangle{
            width:200
            height:20
            x:250
            y:25+25+25+25+25
            Text{text:"BluetoothInitializePairedDeviceNG";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected01 = false
                    idSettingsBtDialogPopup.popupSelected012 = true
                }
            }
        }

        Rectangle{
            width:200
            height:20
            x:250+250

            Text{text:"BluetoothInitializeAllOK";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected04 = false
                    idSettingsBtDialogPopup.popupSelected041 = true
                }
            }
        }

        Rectangle{
            width:200
            height:20
            x:250+250
            y:25
            Text{text:"BluetoothInitializeAllNg";color: "Red"}
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    idSettingsBtDialogPopup.popupSelected04 = false
                    idSettingsBtDialogPopup.popupSelected042 = true
                }
            }
        }
    }*/
} // End FocusScope
