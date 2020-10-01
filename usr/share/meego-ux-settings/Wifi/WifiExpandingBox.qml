/*
* Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Settings 0.1
import MeeGo.Connman 0.1
import MeeGo.Components 0.1 as MeeGo

import "helper.js" as WifiHelper

MeeGo.ExpandingBox {
    id: container

    property int containerHeight: 80
    height: containerHeight

    //expandedHeight: detailsItem.height
    property NetworkListModel listModel: null
    property QtObject networkItem: null
    property Item page: null
    property int currentIndex
    property string ssid: ""
    property string status: ""
    property int statusint: 0
    property string ipaddy: ""
    property string subnet: ""
    property string gateway: ""
    property string dns: ""
    property string hwaddy: ""
    property string security: ""
    property string method: ""
    property variant nameservers: []

    /// TODO FIXME: this is bad but connman doesn't currently expose a property to indicate whether
    /// a service is the default route or not:
    property bool defaultRoute: false

    Component.onCompleted: {
        WifiHelper.connmanSecurityType["wpa"] = qsTr("WPA");
        WifiHelper.connmanSecurityType["rsn"] = qsTr("WPA2");
        WifiHelper.connmanSecurityType["wep"] = qsTr("WEP");
        WifiHelper.connmanSecurityType["ieee8021x"] = qsTr("RADIUS");
        WifiHelper.connmanSecurityType["psk"] = qsTr("WPA2");
        WifiHelper.connmanSecurityType["none"] = "";

        WifiHelper.IPv4Type["dhcp"] = qsTr("DHCP")
        WifiHelper.IPv4Type["static"] = qsTr("Static")
    }

    onSecurityChanged: {
        securityText.text = WifiHelper.connmanSecurityType[container.security]
    }

    Row {
        spacing: 10
        anchors.top:  parent.top
        anchors.topMargin: 10
        height: container.containerHeight

        Image {
            id: checkbox
            //anchors.verticalCenter: parent.verticalCenter
            source:  "image://theme/btn_tickbox_dn"
            visible:  container.defaultRoute
        }

        Rectangle {
            id: checkboxFiller
            anchors.fill:  checkbox
            //anchors.verticalCenter: parent.verticalCenter
            color: "transparent"
            visible:  !checkbox.visible
        }


        Image {
            id: signalIndicator
            source: "image://theme/icn_networks"

            states:  [
                State {
                    when: statusint >= NetworkItemModel.StateReady
                    PropertyChanges {
                        target: signalIndicator
                        source: "image://theme/icn_networks_connected"
                    }
                },
                State {
                    when: statusint < NetworkItemModel.StateReady
                    PropertyChanges {
                        target: signalIndicator
                        source: "image://theme/icn_networks"
                    }
                }

            ]
        }

        Column {
            spacing: 5
            width: childrenRect.width
            Text {
                id: mainText
                text: status == "" ? ssid:(ssid + " - " + status)
            }

            Text {
                id: securityText
            }
        }
    }




    onStatusintChanged: {

        if(statusint == NetworkItemModel.StateIdle) {
            status = ""

        }
        else if(statusint == NetworkItemModel.StateFailure) {
            status = qsTr("Failed to Connect")
        }
        else if(statusint == NetworkItemModel.StateAssociation) {
            status = qsTr("Associating")

        }
        else if(statusint == NetworkItemModel.StateConfiguration) {
            status = qsTr("Configuring")

        }
        else if(statusint == NetworkItemModel.StateReady) {
            status = qsTr("Connected")

        }
        else if(statusint == NetworkItemModel.StateOnline) {
            status = qsTr("Connected")
        }
        else {
            console.log("state type: " + statusint + "==" + NetworkItemModel.StateIdle)
        }

        if(statusint == NetworkItemModel.StateIdle || statusint == NetworkItemModel.StateFailure ) {
            detailsComponent = passwordArea
        }
        else if(statusint == NetworkItemModel.StateReady || statusint == NetworkItemModel.StateOnline) {
            detailsComponent = detailsArea
            expanded = false
        }

    }

    /*onExpandedChanged: {
    if(expanded && security == "none" && statusint < NetworkItemModel.StateReady) {
			listModel.connectService(ssid, security, "");
		}
	}*/

    Component {
        id: removeConfirmAreaComponent
        Column {
            id: removeConfirmArea
            width: parent.width
            spacing: 10
            Component.onCompleted: {
                console.log("height: !!!! " + height)
            }

            Text {
                text: qsTr("Do you want to remove %1 ?  This action will forget any passwords and you will no longer be automatically connected to %2").arg(networkItem.name).arg(networkItem.name);
                wrapMode: Text.WordWrap
                height: paintedHeight
                width: parent.width
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                height: childrenRect.height

                MeeGo.Button {
                    id: yesDelete
                    text: qsTr("Yes, Delete")
                    width: removeConfirmArea.width / 6
                    height: 50
                    onClicked: {
                        networkItem.passphrase=""
                        networkItem.removeService();
                        container.expanded = false;
                        container.detailsComponent = passwordArea
                    }
                }
                MeeGo.Button {
                    id: noSave
                    text: qsTr("No, Save")
                    width: removeConfirmArea.width / 6
                    height: 50
                    onClicked: {
                        container.expanded = false;
                        container.detailsComponent = detailsArea
                    }
                }
            }
        }
    }

    Component {
        id: detailsArea
        Grid {
            id: settingsGrid
            spacing: 15
            columns: 2
            anchors.top: parent.top
            width: parent.width
            height: childrenRect.height

	    property bool editable: container.networkItem.method != "dhcp" && container.networkItem.type != "cellular"

            MeeGo.Button {
                id: disconnectButton
                text: qsTr("Disconnect")
                height: 50
                width: parent.width / 3
                onClicked: {
                    networkItem.disconnectService();
                    container.expanded = false;
                }
            }

            MeeGo.Button {
                id: removeConnection
                text: qsTr("Remove connection")
                height: 50
                width: parent.width / 3
                elideText: true
                onClicked: {
                    container.detailsComponent = removeConfirmAreaComponent
                }

            }

            Text {
                text: qsTr("Connect by:")
            }

            MeeGo.DropDown {
                id: dropdown
                width: parent.width / 3
                property string method
                visible: container.networkItem.type != "cellular"
                model: [ WifiHelper.IPv4Type["dhcp"], WifiHelper.IPv4Type["static"] ]
                payload: [ WifiHelper.IPv4Type["dhcp"], WifiHelper.IPv4Type["static"] ]
                selectedIndex: networkItem.method == "dhcp" ? 0:1
                replaceDropDownTitle: true
                onTriggered: {
                    dropdown.method = index == 0 ? "dhcp":"static"
                }

                Connections {
                    target: networkItem
                    onMethodChanged: {
                        dropdown.selectedIndex = networkItem.method == "dhcp" ? 0:1
                    }
                }
            }

            Text {
                width: parent.width / 3
                text: WifiHelper.IPv4Type["dhcp"]
                visible: container.networkItem.type == "cellular"
            }

			Text {
				width: parent.width / 3
				text: qsTr("IP Address:")
			}

			Text {
				text: container.ipaddy
				visible:  !editable
				width: parent.width / 3
			}

			MeeGo.TextEntry {
				id: ipaddyEdit
				width: parent.width / 3
				text: container.ipaddy
				visible: editable
				//textInput.inputMask: "000.000.000.000;_"
			}

			Text {
				width: parent.width / 3
				text: qsTr("Subnet mask:")
			}

			Text {
				text: container.subnet
				visible:  !editable
				width: parent.width / 3
			}

			MeeGo.TextEntry {
				id: subnetEdit
				width: parent.width / 3
				text: container.subnet
				visible: editable
				//textInput.inputMask: "000.000.000.000;_"
			}
			Text {
				width: parent.width / 3
				text: qsTr("Gateway")
			}

			Text {
				text: container.gateway
				visible:  !editable
				width: parent.width / 3
			}

			MeeGo.TextEntry {
				id: gatewayEdit
				width: parent.width / 3
				text: container.gateway
				visible: editable
				//textInput.inputMask: "000.000.000.000;_"
			}
			Text {
				text: qsTr("DNS:")
			}
			Grid {
				id: nameserverstextedit
				width: parent.width
				//height: 20
				columns: 2
				Repeater {
					model: container.nameservers
					delegate: Text {
						width: nameserverstextedit.width / 3
						text: modelData
					}
				}

			}
			Text {
				width: parent.width / 3
				text: qsTr("Hardware address:")
				visible: container.networkItem.type != "cellular"
			}

			Text {
				width: parent.width / 3
				text: container.hwaddy
				visible: container.networkItem.type != "cellular"
			}

			Labs.GConfItem {
				id: connectionsHacksGconf
				defaultValue: false
				key: "/meego/ux/settings/connectionshacks"
			}

			Text {
				visible: connectionsHacksGconf.value
				width: parent.width / 3
				text: qsTr("Security: ")
			}
			Text {
				visible: connectionsHacksGconf.value
				width: parent.width / 3
				text: container.networkItem.security
			}

			Text {
				visible: connectionsHacksGconf.value
				width: parent.width / 3
				text: qsTr("Strength: ")
			}
			Text {
				visible: connectionsHacksGconf.value
				width: parent.width / 3
				text: container.networkItem.strength
			}

			MeeGo.Button {
				id: applyButton
				text: qsTr("Apply")
				elideText: true
				height: 50
				width: parent.width / 3
				onClicked: {
					networkItem.method = dropdown.method
					networkItem.ipaddress = ipaddyEdit.text
					networkItem.netmask = subnetEdit.text
					networkItem.gateway = gatewayEdit.text
				}
			}

			MeeGo.Button {
				id: cancelButton
				text: qsTr("Cancel")
				height: 50
				width: parent.width / 3
				elideText: true
				onClicked: {
					container.expanded = false;
				}
			}
		}

	}

    Component {
        id: passwordArea
        Item {
            id: passwordGrid
            width: parent.width
            height: childrenRect.height

            property bool passwordRequired: container.networkItem.type == "wifi" && container.security != "none" && container.security != "ieee8021x"

            Column {
                width:  parent.width
                spacing: 10
                Row {
                    height: childrenRect.height
                    spacing: 10

                    MeeGo.TextEntry {
                        id: passwordTextInput
                        textInput.echoMode: TextInput.Normal
                        visible: passwordGrid.passwordRequired
                        defaultText: qsTr("Type password here")
                        width: passwordGrid.width / 2
                        text: container.networkItem.passphrase
                        textInput.inputMethodHints: Qt.ImhNoAutoUppercase

                    }

                    MeeGo.Button {
                        id: setupButton
                        height: 50

                        text:  qsTr("Setup")
                        visible: container.networkItem.type == "cellular"
                        onClicked: {
                           addPage(cellularSettings)
                        }
                    }

                    MeeGo.Button {
                        id: connectButtonOfAwesome
                        height: 50

                        text: qsTr("Connect")
                        onClicked: {
                            if(container.networkItem.type == "wifi") {
                                container.networkItem.passphrase = passwordTextInput.text;
                                container.listModel.connectService(container.ssid, container.security, passwordTextInput.text)
                            }
                            else {
                                container.networkItem.connectService();
                            }
                        }
                    }
                }

                Row {
                    height: childrenRect.height
                    spacing: 10
                    MeeGo.CheckBox {
                        id: showPasswordCheckbox
                        visible: passwordGrid.passwordRequired
                        isChecked: true
                        onIsCheckedChanged: {
                            if(isChecked) passwordTextInput.textInput.echoMode = TextInput.Normal
                            else passwordTextInput.textInput.echoMode = TextInput.Password
                        }
                    }

                    Text {
                        visible: passwordGrid.passwordRequired
                        text: qsTr("Show password")
                        width: 100
                        height: showPasswordCheckbox.height
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
		}
    }

    Component {
        id: cellularSettings
        CellularSettings {
            networkItem: container.networkItem
        }
    }
}



