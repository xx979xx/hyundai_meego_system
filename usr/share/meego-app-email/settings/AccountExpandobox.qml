/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1
import "settings.js" as Settings

Expandobox {
    // ugly workaround to index name collision in
    // DropDown onSelectionChanged signal
    property int listIndex: -1

    Component.onCompleted: { listIndex = index }
    barContent: Component {
        Item {
            Image {
                id: icon
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                source: { switch (model.preset) {
                    case "4":
                        return "image://themedimage/icons/services/aim";
                    case "2":
                        return "image://themedimage/icons/services/gmail"
                    case "5":
                        return "image://themedimage/icons/services/msmail"
                    case "1":
                        return "image://themedimage/icons/services/generic"
                    case "3":
                        return "image://themedimage/icons/services/yahoo"
                    default:
                        return "image://themedimage/icons/services/generic"
                    }
                }
            }
            Text {
                id: label
                anchors.left: parent.left
                anchors.right: togglebutton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 100
                font.pixelSize: theme.fontPixelSizeLarge
                elide: Text.ElideRight
                color: theme.fontColorNormal
                function unique(provider) {
                    var providers = new Array();
                    for (var i = 0; i < accountSettingsModel.rowCount(); i++) {
                        var description = accountSettingsModel.dataWrapper(i, 33);
                        if (typeof providers[description] === 'undefined')
                            providers[description] = 1;
                        else
                            providers[description] += 1;
                    }
                    return providers[provider] == 1;
                }
                text: {
                    if (unique(model.description)) {
                        return model.description;
                    } else {
                        return qsTr("%1 - %2").arg(model.address).arg(model.description);
                    }
                }
            }
            ToggleButton {
                id: togglebutton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                on: model.enabled
                onOnChanged: accountSettingsModel.setDataWrapper(index, on, 34)
            }
        }
    }
    content: Component {
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: column.height
            color: "#eaf6fb"
        Column {
            id: column
            anchors.left: parent.left
            anchors.right: parent.right

            ControlGroup {
                children: [
                Item { width: 1; height: 1; },   // spacer
                TextControl {
                    label: qsTr("Account description")
                    Component.onCompleted: setText(model.description)
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 33)
                },
                TextControl {
                    label: qsTr("Your name")
                    Component.onCompleted: setText(model.name)
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 35)
                },
                TextControl {
                    label: qsTr("Email address")
                    Component.onCompleted: setText(model.address)
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhEmailCharactersOnly
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 36)
                },
                PasswordControl {
                    label: qsTr("Password")
                    Component.onCompleted: setText(model.password)
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 37)
                },
                Item { width: 1; height: 1; }   // spacer
                ]
            }
            ControlGroup {
                title: qsTr("Receiving settings")
                subtitle: qsTr("You may need to contact your email provider for these settings.")
                children: [
                Item { width: 1; height: 1; },   // spacer
                DropDownControl {
                    label: qsTr("Server type")
                    model: Settings.serviceModel
                    selectedIndex: model.recvType
                    onTriggered: accountSettingsModel.setDataWrapper(listIndex, index, 38)
                },
                TextControl {
                    label: qsTr("Server address")
                    Component.onCompleted: setText(model.recvServer)
                    inputMethodHints: Qt.ImhNoAutoUppercase
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 39)
                },
                TextControl {
                    label: qsTr("Port")
                    Component.onCompleted: setText(model.recvPort)
                    inputMethodHints: Qt.ImhDigitsOnly
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 40)
                },
                DropDownControl {
                    label: qsTr("Security")
                    model: Settings.encryptionModel
                    selectedIndex: model.recvSecurity
                    onTriggered: accountSettingsModel.setDataWrapper(listIndex, index, 41)
                },
                TextControl {
                    label: qsTr("Username")
                    Component.onCompleted: setText(model.recvUsername)
                    inputMethodHints: Qt.ImhNoAutoUppercase
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 42)
                },
                PasswordControl {
                    label: qsTr("Password")
                    Component.onCompleted: setText(model.recvPassword)
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 43)
                },
                Item { width: 1; height: 1; }   // spacer
                ]
            }
            ControlGroup {
                title: qsTr("Sending settings")
                subtitle: qsTr("You may need to contact your email provider for these settings.")
                children: [
                Item { width: 1; height: 1; },   // spacer
                TextControl {
                    label: qsTr("Server address")
                    Component.onCompleted: setText(model.sendServer)
                    inputMethodHints: Qt.ImhNoAutoUppercase
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 44)
                },
                TextControl {
                    label: qsTr("Port")
                    Component.onCompleted: setText(model.sendPort)
                    inputMethodHints: Qt.ImhDigitsOnly
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 45)
                },
                DropDownControl {
                    label: qsTr("Authentication")
                    model: Settings.authenticationModel
                    selectedIndex: model.sendAuth
                    onTriggered: accountSettingsModel.setDataWrapper(listIndex, index, 46)
                },
                DropDownControl {
                    label: qsTr("Security")
                    model: Settings.encryptionModel
                    selectedIndex: model.sendSecurity
                    onTriggered: accountSettingsModel.setDataWrapper(listIndex, index, 47)
                },
                TextControl {
                    label: qsTr("Username")
                    Component.onCompleted: setText(model.sendUsername)
                    inputMethodHints: Qt.ImhNoAutoUppercase
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 48)
                },
                PasswordControl {
                    label: qsTr("Password")
                    Component.onCompleted: setText(model.sendPassword)
                    onTextChanged: accountSettingsModel.setDataWrapper(index, text, 49)
                },
                Item { width: 1; height: 1; }   // spacer
                ]
            }
            Item { width: 1; height: 20; }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 45
                width: 300
                text: qsTr("Delete Account")
                bgSourceUp: "image://theme/btn_red_up"
                bgSourceDn: "image://theme/btn_red_dn"
                onClicked: { verifyDelete.show(); }
            }
            Item { width: 1; height: 20; }
        }
        }
    }
    ModalMessageBox {
        id: verifyDelete
        acceptButtonText: qsTr ("Yes")
        cancelButtonText: qsTr ("Cancel")
        title: qsTr ("Delete account")
        text: qsTr ("Are you sure you want to delete this account?")
        onAccepted: {
            settingsPage.accountSettingsModel.deleteRow(index);
        }
    }
}
