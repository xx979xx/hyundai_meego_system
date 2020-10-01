/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1

ModalDialog {
    id: dialog

    property string username
    property string password
    property string serviceName
    property Item loginOwner

    showAcceptButton: true
    showCancelButton: true

    //: "Sign in" button text displayed in sync account login dialog.
    acceptButtonText: qsTr("Sign in")
    //: "Cancel" button text displayed in sync account login dialog.
    cancelButtonText: qsTr("Cancel")
    //: The argument is the name of the remote sync service (e.g. Google, Yahoo!, etc).
    title: qsTr("Sign in to your %1 account").arg(serviceName)
    content: Column {

        anchors.centerIn: parent
        width: 400
        spacing: 10

        TextEntry {
            id: usernameField
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width - 10

            //: Username example text.  Note: do not translate "example.com"!
            property string example: qsTr("(ex: foo@example.com)")

            //: Sync account username (e.g. foo.bar@yahoo.com) login field label, where arg 1 is an example, which may or not be visible.
            defaultText: qsTr("Username %1").arg(example)
            text: username
            inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoAutoUppercase

            // Set up an e-mail address validator
            //
            // THIS REGULAR EXPRESSION DOES NOT COVER SOME RARE E-MAIL ADDRESS
            // CORNER CASES.
            //
            textInput.validator: RegExpValidator {
//                        regExp: /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
                regExp: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,4}$/
            }

            Keys.onTabPressed: {
                passwordField.textInput.focus = true;
            }
            Keys.onReturnPressed: {
                accepted();  // Simulate pressing the sign-in button.
            }
        }

        TextEntry {
            id: passwordField
            anchors.horizontalCenter: parent.horizontalCenter
            width: usernameField.width

            //: Sync account password login field label
            defaultText: qsTr("Password")
            text: password
            inputMethodHints: Qt.ImhNoAutoUppercase

            textInput.echoMode: TextInput.Password

            Keys.onTabPressed: {
                usernameField.textInput.focus = true;
            }
            Keys.onReturnPressed: {
                accepted();  // Simulate pressing the sign-in button.
            }
        }
    }

    onAccepted: {
        if (usernameField.text != "") {
            if (usernameField.textInput.acceptableInput) {
                // Sign in

                // Done entering login information.  Now execute the desired action.
                loginOwner.executeOnSignin(usernameField.text, passwordField.text);

                // Close the Dialog.
                //container.destroy();
                dialog.hide();
            } else {
                // Display the sample username again.
                usernameField.text = ""
            }
        }
    }

    onRejected: {
        popPage();
    }

    Component.onCompleted: {
        dialog.show()
    }
}

