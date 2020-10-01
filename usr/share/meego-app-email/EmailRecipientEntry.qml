/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Components 0.1

BorderImage {
    id: background

    property alias model: repeater.model
    property alias text: input.text
    property alias defaultText: recipientListLabel.text

    border.top: 10
    border.bottom: 10
    border.left: 10
    border.right: 10

    height: flickable.height + 20
    source: "image://theme/email/frm_textfield_l"

    function complete () {
        if (text != "") {
            background.model.append ({name:"", email:text});
        }
    }

    Text {
        id: recipientListLabel
        x: 10
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: theme.fontPixelSizeLarge
        color: "slategrey"

        visible: input.text == "" && repeater.model.count == 0
    }

    Flickable {
        id: flickable

        x: 10
        y: 10

        width: parent.width - 20
        contentWidth: width
        contentHeight: recipientEntry.height
        height: recipientEntry.height < 75 ? recipientEntry.height : 75

        interactive: recipientEntry.height > 75
        clip: true

        function ensureVisible (rY, rHeight) {
            if (contentY >= rY)
                contentY = rY;
            else if (contentY + height <= rY + rHeight)
                contentY = rY + rHeight - height;

            if (contentY > height) {
                contentY = 0;
            }
        }

        Item {
            id: recipientEntry

            width: parent.width
            height: flow.height < 35 ? 35 : flow.height;

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    input.visible = true;
                    input.forceActiveFocus ();
                }
            }

            Flow {
                id: flow

                width: parent.width
                spacing: 10

                Repeater {
                    id: repeater

                    EmailAddress {
                        emailAddress: email
                        givenName: name

                        onClicked: {
                            var i;

                            // this will delete the first instance.
                            for (i = 0; i < repeater.model.count; i++) {
                                if (repeater.model.get(i).email == emailAddress) {
                                    repeater.model.remove(i);
                                    break;
                                }
                            }
                        }
                    }
                }

                Item {
                    id: padding

                    width: input.width
                    height: 35

                    TextEntry {
                        id: input
                        visible: false

                        anchors.verticalCenter: parent.verticalCenter
                        inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoAutoUppercase

                        function addEmailAddress () {
                            if (text != "") {
                                background.model.append ({name:"", email:text});
                                text = "";
                                flickable.ensureVisible (parent.y, parent.height);
                            }
                        }

                        Keys.onSpacePressed: {
                            addEmailAddress ();
                            event.accepted = true;
                        }

                        Keys.onReturnPressed: {
                            addEmailAddress ();
                            event.accepted = true;
                        }

                        Keys.onPressed: {
                            if (event.key == Qt.Key_Backspace) {
                                if (text == "") {
                                    var count = background.model.count;
                                    if (count != 0) {
                                        background.model.remove (count - 1);
                                        event.accepted = true;
                                    }
                                }
                            } else if (event.key == Qt.Key_Comma || event.key == Qt.Key_Semicolon) {
                                addEmailAddress ();
                                event.accepted = true;
                            }
                            flickable.ensureVisible (parent.y, parent.height);
                        }
                    }
                }
            }
        }
    }
}
