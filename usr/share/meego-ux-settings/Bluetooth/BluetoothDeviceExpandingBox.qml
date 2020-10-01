/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1 as MeeGo
import MeeGo.Settings 0.1
import MeeGo.Bluetooth 0.1
import MeeGo.Connman 0.1

MeeGo.ExpandingBox {
    id: container
    detailsComponent: capabilitiesComponent

    property int containerHeight: 80

    height: containerHeight

    property string name: ""
    property bool connected: false
    property string dbuspath: ""
    property string hwaddy: "XX:XX:XX:XX:XX:XX"
    property variant uuids: []
    property BluetoothDevicesModel bluetoothdevicemodel
    property BluetoothDevice device: bluetoothdevicemodel.device(dbuspath)

    visible: device.paired

    Image {
        id: bluetoothIcon
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
        source: container.device.icon != "" ? "image://meegotheme/icons/settings/"+container.device.icon: "image://meegotheme/icons/settings/device-bluetooth-default"
        height: container.containerHeight - 20
        fillMode: Image.PreserveAspectFit
        onStatusChanged: {
            console.log("icon: " + container.device.icon)
            if(status == Image.Error) {
                source = "image://image://systemicon/device-bluetooth-default"
            }
        }
    }

    Text {
        id: mainText
        anchors.margins: 10
        anchors.top: parent.top
        anchors.left: bluetoothIcon.right
        text: name
    }

    Component {
        id: audioButtonComponent
        MeeGo.Button {
            width: parent.width
            height: 50
            text: connected ? qsTr("Disconnect audio"): qsTr("Connect audio")
            property bool connected: container.device.audioConnected

            onConnectedChanged: {
                if(connected){
                    text = qsTr("Disconnect audio")
                }

                else{
                    text = qsTr("Connect audio")
                }
            }

            onClicked: {
                if(connected) {
                    container.device.disconnectAudio();
                }
                else {
                    container.device.connectAudio();
                }
            }
        }
    }

    Component {
        id: inputButtonComponent
        MeeGo.Button {
            width: parent.width
            height: 50
            text: connected ? qsTr("Disconnect input device"): qsTr("Connect input device")
            elideText: true
            property bool connected: container.device.inputConnected

            Connections {
                target: container.device
                onInputConnectedChanged: {
                    console.log("Input connected changed (in qml land)");
                    connected = isConnected

                    if(connected){
                        text = qsTr("Disconnect input device")
                    }

                    else{
                        text = qsTr("Connect input device")
                    }
                }
            }

            onClicked: {
                if(connected) {
                    container.device.disconnect();
                }
                else {
                    container.device.connectInput();
                }
            }
        }
    }

    Component {
        id: panButtonComponent
        MeeGo.Button {
            width: parent.width
            height: 50
            text: connected ? qsTr("Disconnect internet"): qsTr("Connect internet")
            elideText: true
            property bool connected: networkItem.state >= NetworkItemModel.StateReady
            property NetworkItemModel networkItem: networkListModel.service(container.device.name)

            onClicked: {
                connected ? networkItem.disconnectService() : networkItem.connectService()
            }

            NetworkListModel {
                id: networkListModel

                onCountChanged: {
                    networkItem = networkListModel.service(container.device.name)
                }
            }
        }
    }


    Component {
        id: capabilitiesComponent
        Item {
            id: capabilitiesItem

            width: parent.width
            height: profileButtonsColumn.height + removeButton.height
            anchors.horizontalCenter: parent.horizontalCenter

            Component.onCompleted: {
                console.log("getting device for " + dbuspath)
                container.device = bluetoothdevicemodel.device(dbuspath)
            }

            Connections {
                target: container
                onUuidsChanged: {
                    profileButtonsColumn.populateList();
                }
            }

            onHeightChanged: {
                console.log("bt expanding area height changed " + height)
            }
            Row {
                height: childrenRect.height
                spacing: 10
                Column {
                    id: profileButtonsColumn
                    width: capabilitiesItem.width / 2 - 10
                    property Item audioItem: null
                    property Item napItem: null
                    property Item inputItem: null

                    Text {
                        text: qsTr("Connect actions")
                        height: 50
                        width: 200

                        Component.onCompleted: {
                            console.log("text created first!!! " + container.device.name)
                            profileButtonsColumn.populateList();
                        }
                    }

                    function populateList() {
                        console.log("device: "+ name)
                        var list = container.device.profiles;
                        var count=0
                        if(audioItem) audioItem.destroy()
                        audioItem = null;
                        if(napItem) napItem.destroy()
                        napItem = null;
                        if(inputItem) inputItem.destroy()
                        inputItem = null;

                        for(var i=0;i < list.length;i++) {
                            console.log(container.device.name + ": " + list[i])
                            if(audioItem == null && (list[i] == "00001108-0000-1000-8000-00805f9b34fb" ||
                                             list[i] == "0000110b-0000-1000-8000-00805f9b34fb")) {
                                //audio
                                audioItem = audioButtonComponent.createObject(profileButtonsColumn);
                                audioItem.parent = profileButtonsColumn
                                count ++;
                            }
                            else if(napItem == null && list[i] == "00001116-0000-1000-8000-00805f9b34fb") {
                                //internets nap profile
                                napItem = panButtonComponent.createObject(profileButtonsColumn);
                                napItem.parent = profileButtonsColumn
                                count ++;
                            }
                            else if(inputItem == null && list[i] == "00001124-0000-1000-8000-00805f9b34fb") {
                                //input profile
                                inputItem = inputButtonComponent.createObject(profileButtonsColumn);
                                inputItem.parent = profileButtonsColumn
                                count ++;
                            }
                        }

                        profileButtonsColumn.visible = (count > 0)
                    }
                }
                Column {
                    id: manageColumn
                    width: capabilitiesItem.width / 2 - 10
                    Text {
                        text: qsTr("Manage")
                        height: 50
                        width: parent.width
                    }

                    MeeGo.Button {
                        id: removeButton
                        text: qsTr("Remove")
                        height: 50
                        width: parent.width
                        elideText: true

                        onClicked: {
                            device.unpair();
                        }
                    }

                    Text {
                        visible: btHacksGconf.value
                        height: 50
                        width: parent.width
                        text: qsTr("Properties")
                    }

                    Text {
                        visible: btHacksGconf.value
                        text: qsTr("Paired: %1").arg(container.device.paired)
                        height: 50
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        visible: btHacksGconf.value
                        text: qsTr("Hardware address: %1").arg(container.hwaddy)
                        height: 50
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        visible: btHacksGconf.value
                        text: qsTr("Icon: %1").arg(container.device.icon)
                        height: 50
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        visible: btHacksGconf.value
                        text: qsTr("UUIDs: %1").arg(container.uuids)
                        height: 100
                        wrapMode: Text.WrapAnywhere
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                    }

                    Labs.GConfItem {
                        id: btHacksGconf
                        defaultValue: false
                        key: "/meego/ux/settings/bluetoothhacks"
                    }
                }
            }
        }
    }
}


