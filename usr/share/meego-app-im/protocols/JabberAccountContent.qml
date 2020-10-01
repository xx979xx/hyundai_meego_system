/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.App.IM 0.1

AccountContent {
    id: jabberAccountContent
    connectionManager: "gabble"
    protocol: "jabber"
    icon: "im-jabber"

    advancedOptionsComponent: Component {
        id: advancedOptions

        Item {
            id: mainArea
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: childrenRect.height

            property alias server: serverBox.text
            property alias encryption: encryptionBox.checked
            property alias resource: resourceBox.text
            property alias port: portBox.value
            property alias priority: priorityBox.value

            ContentRow {
                active: false
                height: childrenRect.height

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 10
                    height: childrenRect.height

                    TextCheckBox {
                        id: encryptionBox
                        anchors.margins: 10
                        anchors.left: parent.left
                        checked: false
                        text: qsTr("Require encryption")
                        font.bold: true
                    }

                    Grid {
                        anchors.margins: 10
                        anchors.left: parent.left
                        anchors.right: parent.right
                        columns: 2
                        spacing: 10

                        Text {
                            id: priorityLabel
                            text: qsTr("Priority:")
                            font.bold: true
                            height:  priorityBox.height
                            verticalAlignment: Text.AlignVCenter
                        }

                        SpinBox {
                            id: priorityBox
                            width: parent.width / 3
                        }

                        Text {
                            id: resourceLabel
                            text: qsTr("Resource:")
                            font.bold: true
                            height: resourceBox.height
                            verticalAlignment: Text.AlignVCenter
                        }

                        TextEntry {
                            id: resourceBox
                            width: parent.width / 3
                        }

                        Text {
                            id: serverLabel
                            text: qsTr("Server:")
                            font.bold: true
                            height: serverBox.height
                            verticalAlignment: Text.AlignVCenter
                        }

                        TextEntry {
                            id: serverBox
                            width: parent.width / 3
                        }

                        Text {
                            id: portLabel
                            text: qsTr("Port:")
                            font.bold: true
                            height: portBox.height
                            verticalAlignment: Text.AlignVCenter
                        }

                        SpinBox {
                            id: portBox
                            width: parent.width / 3
                        }
                    }
                }
            }
        }
    }

    onAboutToEditAccount: {
        // load the parameters
        advancedOptionsItem.server = wrapUndefined(accountHelper.accountParameter("server"), "string");
        advancedOptionsItem.encryption = wrapUndefined(accountHelper.accountParameter("require-encryption"), "bool");
        advancedOptionsItem.resource = wrapUndefined(accountHelper.accountParameter("resource"), "string");
        advancedOptionsItem.port = wrapUndefined(accountHelper.accountParameter("port"), "number");
        advancedOptionsItem.priority = wrapUndefined(accountHelper.accountParameter("priority"), "number");
    }

    onAboutToCreateAccount: {
        // advanced options only set if editting existing account
        if (edit) {
            if (advancedOptionsItem.server == "")
                accountHelper.unsetAccountParameter("server");
            else
                accountHelper.setAccountParameter("server", advancedOptionsItem.server);

            if (advancedOptionsItem.resource == "")
                accountHelper.unsetAccountParameter("resource");
            else
                accountHelper.setAccountParameter("resource", advancedOptionsItem.resource);

            accountHelper.setAccountParameter("require-encryption", advancedOptionsItem.encryption);
            accountHelper.setAccountParameter("port", advancedOptionsItem.port);
            accountHelper.setAccountParameter("priority", advancedOptionsItem.priority);
        }
    }
}
