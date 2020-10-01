/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Column {
    anchors.left: parent.left
    anchors.right: parent.right
    height: childrenRect.height

    Item {
        id: spacing1
        width: 10
        height: 10
    }

    Item {
        width: parent.width
        height: childrenRect.height
        Item {
            id: centerItem
            width: childrenRect.width + cancelButton.anchors.margins
            height: childrenRect.height
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: updateButton
                anchors {
                    left: parent.left
                    top: parent.top
                }

                text: qsTr("Update")
                textColor: theme_buttonFontColor
                bgSourceUp: "image://themedimage/widgets/common/button/button-default"
                bgSourceDn: "image://themedimage/widgets/common/button/button-default-pressed"

                onClicked: accountContent.createAccount()
            }

            Button {
                id: cancelButton
                anchors {
                    leftMargin: 10
                    left: updateButton.right
                    top: parent.top
                }

                text: qsTr("Cancel")
                textColor: theme_buttonFontColor
                bgSourceUp: "image://themedimage/widgets/common/button/button-negative"
                bgSourceDn: "image://themedimage/widgets/common/button/button-negative-pressed"

                // reset the values to the ones previously set
                onClicked: accountContent.prepareAccountEdit()
            }
        }
    }

    Item {
        id: spacing2
        width: 10
        height: 10
    }

    Item {
        width: parent.width
        height: childrenRect.height

        Button {
            id: deleteAccountButton
            anchors.horizontalCenter: parent.horizontalCenter

            text: qsTr("Delete account")
            textColor: theme_buttonFontColor
            bgSourceUp: "image://themedimage/widgets/common/button/button-negative"
            bgSourceDn: "image://themedimage/widgets/common/button/button-negative-pressed"

            // TODO: maybe it would be good to ask if the user really
            // wants to remove the account?
            onClicked: messageBox.show();
        }
    }

    ModalMessageBox {
        id: messageBox
        parent: window

        height: 300
        width: 400

        text: qsTr("Are you sure to delete this account?")

        title: qsTr("Delete account")
        showAcceptButton: true
        showCancelButton: true
        fogClickable: false
        fogMaskVisible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        onAccepted: {
            accountContent.removeAccount();
            hide();
        }
        onRejected: {
            hide();
        }
    }
}
