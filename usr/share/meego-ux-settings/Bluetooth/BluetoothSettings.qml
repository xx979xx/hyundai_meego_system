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

MeeGo.AppPage{
    id: container
    pageTitle: qsTr("Bluetooth")

    BluetoothDevicesModel {
        id: bluetoothModel
        discoverableTimeout: 180 ///three minutes
    }

    Flickable {
        id: contentArea
        //parent: container.content
        anchors.fill: parent
        clip: true
        contentWidth: parent.width
        contentHeight: contents.height

        Column {
            id: contents
            width: parent.width

            Image {
                width: parent.width
                source: "image://theme/settings/subheader"
                visible: !bluetoothModel.adapterPresent
                Text{
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("No bluetooth adapter present");
                    font.pixelSize: theme_fontPixelSizeLarge
                    height: parent.height
                    width: parent.width
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Column {
                width: parent.width
                visible: bluetoothModel.adapterPresent

                Image {
                    id: offlineArea
                    source: "image://theme/settings/pulldown_box_2"
                    width: parent.width
                    Text {
                        id: airplaneLabel
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: qsTr("Bluetooth")
                        width: 100
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                    }

                    MeeGo.ToggleButton {
                        id: poweredToggleButton
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        on: bluetoothModel.powered
                        onToggled: {
                            bluetoothModel.powered = poweredToggleButton.on;
                            addNewDeviceButton.active = poweredToggleButton.on;
                        }

                        Connections {
                            target: bluetoothModel
                            onPoweredChanged: {
                                if(!bluetoothModel.powered) discoverableTimer.stop();
                                poweredToggleButton.on = bluetoothModel.powered;
                            }
                        }
                    } 
                }

                Image {
                    id: bluetoothToggleGrid
                    width: parent.width
                    source: "image://theme/settings/pulldown_box_2"

                    Text {
                        id: discoverableLabel
                        text: qsTr("Discoverable")
                        width: 100
                        height: parent.height
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        property int timeRemaining: bluetoothModel.discoverableTimeout
                        states: [
                            State {
                                PropertyChanges {
                                    target: discoverableLabel
                                    text: qsTr("Discoverable for %1 seconds").arg(timeRemaining)
                                }
                                when: bluetoothModel.discoverable && discoverableLable.timeRemaining > 0
                            }
                        ]

                        Timer {
                            id: discoverableTimer
                            interval: 5000
                            repeat: true
                            onTriggered: {
                                timeRemaining -= 5
                            }
                        }

                    }

                    MeeGo.ToggleButton {
                        id: visibilityToggleButton
                        anchors.right: parent.right;
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        on: bluetoothModel.discoverable
                        onToggled: {
                            bluetoothModel.discoverable = visibilityToggleButton.on
                        }

                        Connections {
                            target: bluetoothModel
                            onDiscoverableChanged: {
                                visibilityToggleButton.on = bluetoothModel.discoverable
                                if(bluetoothModel.discoverable) discoverableTimer.start();
                                else discoverableTimer.stop();
                            }
                        }
                    }
                }

                Image {
                    id: devicesLabel
                    width: parent.width
                    source: "image://theme/settings/subheader"

                    Text{
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: qsTr("Paired devices");
                        font.pixelSize: theme_fontPixelSizeLarge
                        height: parent.height
                        width: parent.width
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    MeeGo.Button {
                        id: addNewDeviceButton
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Add device")
                        height: parent.height / 1.5
                        //width: 200
                        onClicked: {
                            if (poweredToggleButton.on)
                                addPage(nearbyDevicesComponent);
                        }
                    }
                }



                Component {
                    id: nearbyDevicesComponent
                    NearbyDevices { }
                }

                Column {
                    id: deviceList
                    width: parent.width
                    spacing: 2
                    Repeater {
                        model: bluetoothModel
                        delegate: BluetoothDeviceExpandingBox {
                            name: model.name
                            width: deviceList.width
                            hwaddy: model.address
                            dbuspath: model.path
                            uuids: model.profiles
                            bluetoothdevicemodel: bluetoothModel

                            Connections {
                                target: bluetoothModel
                                onDevicePaired: {
                                    console.log("new paired device address:" + device.address + "==" + model.address)
                                    if(device.address == model.address){
                                        expanded=true;
                                        device.trusted = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
