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
import MeeGo.Connman 0.1

import "helper.js" as WifiHelper

MeeGo.AppPage {
    id: container
    pageTitle: qsTr("Connections")

    Component.onCompleted: {
        WifiHelper.connmanTechnologies["ethernet"] = qsTr("Ethernet");
        WifiHelper.connmanTechnologies["wifi"] = qsTr("Wi-Fi");
        WifiHelper.connmanTechnologies["bluetooth"] = qsTr("Bluetooth");
        WifiHelper.connmanTechnologies["cellular"] = qsTr("3G");
        WifiHelper.connmanTechnologies["wimax"] = qsTr("WiMAX");

        WifiHelper.connmanSecurityType["wpa"] = qsTr("WPA");
        WifiHelper.connmanSecurityType["rsn"] = qsTr("WPA2");
        WifiHelper.connmanSecurityType["wep"] = qsTr("WEP");
    }

    Flickable {
        id: contentArea
        anchors.fill: parent
        clip: true
        contentWidth: parent.width
        contentHeight: contents.height

        Column {
            id: contents
            width: parent.width
            move: Transition {
                NumberAnimation {
                    properties: "y"
                    easing.type: Easing.OutBounce
                }
            }
            add: Transition {
                NumberAnimation {
                    properties: "opacity"
                    easing.type: Easing.OutBounce
                }
            }

            Image {
                id: offlineArea
                source: "image://theme/settings/pulldown_box_2"
                width: parent.width
                Text {
                    id: airplaneLabel
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Airplane mode")
                    width: 100
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }

                MeeGo.ToggleButton {
                    id: airplaneToggle
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    on: networkListModel.offlineMode
                    onToggled: {
                        networkListModel.setOfflineMode(airplaneToggle.on);
                    }

                    Connections {
                        target: networkListModel
                        onOfflineModeChanged: {
                            airplaneToggle.on = networkListModel.offlineMode
                        }
                    }
                }
            }

            Image {
                id: networkConnectionsLabel
                width: parent.width
                source: "image://theme/settings/subheader"

                Text{
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Network connections");
                    font.pixelSize: theme_fontPixelSizeLarge
                    height: parent.height
                    width: parent.width
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Item {
                id: toggleSwitchArea
                width: parent.width
                height: technologiesGrid.height

                Image {
                    id: gridBackground
                    anchors.fill: technologiesGrid
                    source: "image://theme/settings/pulldown_box_2"
                }

                Grid {
                    id: technologiesGrid
                    width: parent.width
                    height: offlineArea.height * networkListModel.availableTechnologies.count / 2
                    columns: 2
                    Repeater {
                        model: networkListModel.availableTechnologies
                        delegate: Item {
                            width: technologiesGrid.width / 2
                            height: offlineArea.height
                            Text {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                text: WifiHelper.connmanTechnologies[modelData]
                                width: 100
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                            }

                           MeeGo.ToggleButton {
                                id: dtoggle
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                on: networkListModel.enabledTechnologies.indexOf(modelData) != -1
                                onToggled: {
                                    if(dtoggle.on) {
                                        networkListModel.enableTechnology(modelData);
                                    }
                                    else networkListModel.disableTechnology(modelData);
                                }

                                Connections {
                                    target: networkListModel
                                    onEnabledTechnologiesChanged: {
                                        console.log("["+modelData+"]: caught enabled tech signals changed")
                                        dtoggle.on = networkListModel.enabledTechnologies.indexOf(modelData) != -1
                                    }
                                }
                            }

                            Image {
                                source: "image://theme/icn_toolbar_button_divider"
                                height: parent.height
                                anchors.left: dtoggle.right
                                anchors.leftMargin: 5
                            }

                        }
                    }
                }
            }

            Timer {
                id:timer
                interval: 15000
                repeat: true
                running: true
                onTriggered: {
                    networkListModel.requestScan();
                }
            }

            NetworkListModel {
                id: networkListModel

                Component.onCompleted: {
                    networkListModel.requestScan();
                }
            }

            Image {
                id: availableNetworksLabel
                width: parent.width
                source: "image://theme/settings/subheader"
                Text{
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: qsTr("Available networks")
                    font.pixelSize: theme_fontPixelSizeLarge
                    height: parent.height
                    width: parent.width
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                MeeGo.Button {
                    text: qsTr("Add network")
                    anchors.right:  parent.right
                    anchors.rightMargin: 10
                    height: parent.height - 10
                    anchors.verticalCenter: parent.verticalCenter
                    //visible: false
                    onClicked: {
                        addNetworkDialog.show()
                    }

                    MeeGo.ModalDialog {
                        id: addNetworkDialog
                        showAcceptButton: true
                        showCancelButton: true
                        title: qsTr("Add network")

                        property string ssidHidden
                        property string securityHidden
                        property string securityPassphrase: ""

                        content: Column {
                            anchors.centerIn: parent
                            width: childrenRect.width

                            Row {
                                spacing: 10
                                height: childrenRect.height
                                Text {
                                    text: qsTr("Network name:")
                                    verticalAlignment: Text.AlignVCenter
                                    height: ssidEntry.height
                                }

                                MeeGo.TextEntry {
                                    id: ssidEntry
                                    onTextChanged: addNetworkDialog.ssidHidden = text
                                }
                            }

                            Row {
                                spacing: 10
                                height: childrenRect.height

                                Text {
                                    text: qsTr("Security type:")
                                    verticalAlignment: Text.AlignVCenter
                                    height: ssidEntry.height
                                }

                                MeeGo.DropDown {
                                    id: securityDropdown
                                    model: [ qsTr("none"), qsTr("WPA"), qsTr("WPA2"), qsTr("wep") ]
                                    payload: ["none", "wpa", "rsn", "wep"]
                                    selectedTitle: model[selectedIndex]
                                    selectedIndex: 0
                                    replaceDropDownTitle: true
                                    onTriggered: {
                                        addNetworkDialog.securityHidden = payload[selectedIndex]
                                    }
                                }
                            }
                            Row {
                                spacing: 10
                                height: childrenRect.height
                                visible: securityDropdown.selectedIndex > 0
                                Text {
                                    text: qsTr("Security passphrase:")
                                    verticalAlignment: Text.AlignVCenter
                                    height: ssidEntry.height
                                }

                                MeeGo.TextEntry {
                                    id: passPhraseEntry
                                    onTextChanged: addNetworkDialog.securityPassphrase = text
                                }

                            }
                        }
                        onAccepted: {
                            networkListModel.connectService(addNetworkDialog.ssidHidden,
                                                            addNetworkDialog.securityHidden, addNetworkDialog.securityPassphrase)
                        }
                    }
                }
            }

            Column {
                id: availableNetworksList
                width: parent.width

                Text {
                    visible: networkListModel.count == 0
                    text:  qsTr("No networks available")
                    font.pixelSize: theme_fontPixelSizeLarge
                    height: 50
                    width: parent.width
                    elide: Text.ElideRight
                }

                Repeater {
                    model: networkListModel
                    delegate: availableNetworkItem
                    visible: container.x == 0
                }
            }
        }
    }

    Component {
        id: availableNetworkItem
        WifiExpandingBox {
            listModel: networkListModel
            page: container
            width: availableNetworksList.width
            ssid: name
            networkItem: model.networkitemmodel
            currentIndex: model.index
            statusint: model.state
            hwaddy: deviceAddress
            security: model.security
            gateway: model.gateway
            ipaddy: model.ipaddress
            subnet: model.netmask
            method: model.method
            nameservers: model.nameservers
            defaultRoute:  model.defaultRoute
        }
    }
}

