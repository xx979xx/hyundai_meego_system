/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: container

    anchors.fill: parent
    property alias dialogTitle: title.text
    property alias email: emailAddress.text
    property alias message: message.text
    signal buttonSendClicked()
    signal buttonCancelClicked()


    Rectangle {
        id: fog

        anchors.fill: parent
        color: theme_dialogFogColor
        opacity: theme_dialogFogOpacity
        Behavior on opacity {
            PropertyAnimation { duration: theme_dialogAnimationDuration }
        }
    }

    /* This mousearea is to prevent clicks from passing through the fog */
    MouseArea {
        anchors.fill: parent
    }

    BorderImage {
        id: dialog

        border.top: 14
        border.left: 20
        border.right: 20
        border.bottom: 20

        source: "image://theme/notificationBox_bg"

        anchors.centerIn: parent

        width: contents.width + 40 //478
        height: contents.height + 10 //318

        Item {
            id: contents;
            anchors.centerIn: parent
            width: 450
            height: 360
            //focus: true;

            Column {
                id: mainColumn
                anchors.fill: parent
                anchors.margins: 10
                spacing: 15;

                Text {
                    anchors.left: parent.left
                    anchors.topMargin:10
                    id: title
                    text: qsTr("Title");
                    font.weight: Font.Bold
                    color: theme_dialogTitleFontColor
                }


                Row {
                    id: emailRow
                    height: 40
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.top: title.bottom
                    anchors.topMargin: 30
                    //focus: true

                    Rectangle {
                        anchors {
                            left: parent.left;
                            top: parent.top
                            bottom: parent.bottom
                            right: addContacts.left
                            rightMargin: 10
                        }
                        id: rectText;
                        height: parent.height
                        width: parent.width - addContacts.width - 20
                        color: "white"
                        //focus: true

                        TextEntry {
                            id: emailAddress
                            text: qsTr("Enter Email addresses");
                            opacity: 0.25
//                            font.italic: true
                            //focus: true
                            anchors.fill: parent

                            MouseArea {
                                anchors.fill: parent

                                onClicked:
                                {
                                    emailAddress.focus = true;
                                    if (emailAddress.opacity == 0.25)
                                    {
                                        emailAddress.text = "";
                                        emailAddress.font.italic = false;
                                        emailAddress.opacity = 1.0;
                                    }
                                }
                            }
                        }
                    }

                    Button {
                        id: addContacts
                        width: 40
                        height: 40
                        smooth:true;
                        bgSourceUp: "image://theme/contacts/icn_addnewcontact_up"
                        bgSourceDn: "image://theme/contacts/icn_addnewcontact_dn"

                        anchors { right: parent.right;
                            left: emailAddress.right
                            bottom: parent.bottom;
                            top: parent.top
                        }

                        onClicked:{
                            //implement functionality
                        }
                    }
                }

                Rectangle {
                    anchors {
                        left: parent.left;
                        top: emailRow.bottom
                        topMargin: 20
                        //bottom: parent.bottom
                        right:  parent.right
                        rightMargin: 10
                    }
                    id: rectMessage;
                    height: 140
                    width: parent.width
                    color: "white"
                    // focus: true

                    TextField {
                        id: message
                        text: qsTr("Add a message");
                        opacity: 0.25
//                        font.italic: true
                        anchors.fill: parent
                        height: parent.height
                        //focus: true

                        MouseArea {
                            anchors.fill: parent

                            onClicked:
                            {
                                message.focus = true;
                                if (message.opacity == 0.25)
                                {
                                    message.text = "";
                                    message.font.italic = false;
                                    message.opacity = 1.0
                                }
                            }
                        }
                    }
                }

                Row {
                    id: buttonsRow;
                    spacing: 20;
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: rectMessage.bottom
                    anchors.topMargin: 20
                    //anchors.bottom: parent.bottom
                    //anchors.bottomMargin: 20

                    Button {
                        id: sendButton
                        anchors.right: cancelButton.left;
                        anchors.rightMargin:20;
                        text: qsTr("Send");
                        width: 180; height: 60;
                        smooth:true;
                        bgSourceUp: "image://theme/btn_blue_up"
                        bgSourceDn: "image://theme/btn_blue_dn"

                        MouseArea {
                            anchors.fill: parent
                            onClicked:
                            {
                                if (sendButton.active)
                                {
                                    sendButton.clicked(mouse)
                                }
                                container.buttonSendClicked()
                                console.log("sendButton::")
                            }

                            onPressed: if (sendButton.active) sendButton.pressed = true
                            onReleased: if (sendButton.active) sendButton.pressed = false
                        }
                    }

                    Button {
                        id: cancelButton
                        anchors.right: parent.right;
                        text: qsTr("Cancel");
                        width: sendButton.width; height: sendButton.height;
                        smooth:true;

                        MouseArea {
                            anchors.fill: parent
                            onClicked:
                            {
                                if (cancelButton.active)
                                {
                                    cancelButton.clicked(mouse)
                                }

                                container.buttonCancelClicked()
                                console.log("cancelButton::")
                            }

                            onPressed: if (cancelButton.active) cancelButton.pressed = true
                            onReleased: if (cancelButton.active) cancelButton.pressed = false
                        }
                    }
                }
            }
        }
    }
}

