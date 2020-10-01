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

    property string fontSize: "0"
    signal buttonOKClicked()
    signal buttonCancelClicked()

    Rectangle {
        id: fog
        anchors.fill: parent
        color: "slategray"
        opacity: 0.8

        Behavior on opacity {
            PropertyAnimation { duration: 500 }
        }
    }

    /* This mousearea is to prevent clicks from passing through the fog */
    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: mainRect
        width: 300
        height: 200
        anchors.centerIn: parent
        focus: true

        Text {
            id: caption
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Pick font size")
            font.bold: true
        }

        ListModel {
            id: fontSizeModel

            ListElement {
                size: 8
            }

            ListElement {
                size: 9
            }

            ListElement {
                size: 10
            }

            ListElement {
                size: 11
            }

            ListElement {
                size: 12
            }

            ListElement {
                size: 14
            }

            ListElement {
                size: 16
            }

            ListElement {
                size: 18
            }

            ListElement {
                size: 20
            }

            ListElement {
                size: 22
            }

            ListElement {
                size: 24
            }

            ListElement {
                size: 26
            }

            ListElement {
                size: 28
            }

            ListElement {
                size: 36
            }

            ListElement {
                size: 48
            }

            ListElement {
                size: 72
            }
        }

        DropDown {
            id: comboBox
            anchors.top: caption.bottom;
            anchors.topMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            model: fontSizeModel
            height: 30
            focus: true
            smooth: true
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: comboBox.bottom
            anchors.topMargin: 20

            Button {
                id: okButton
                anchors.right: cancelButton.left
                anchors.rightMargin: 20
                text: qsTr("OK")
                x: 20
                width: 120
                height: 40
                smooth: true
                clip: true
                bgSourceUp: "image://theme/notes/btn_spelling_up"
                bgSourceDn: "image://theme/notes/btn_spelling_dn"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (okButton.active)
                            okButton.clicked(mouse);

                        container.fontSize = comboBox.selectedVal;
                        container.buttonOKClicked();
                    }

                    onPressed: if (okButton.active) okButton.pressed = true
                    onReleased: if (okButton.active) okButton.pressed = false
                }
            }

            Button {
                id: cancelButton
                anchors.right: parent.right
                anchors.rightMargin: 20
                text: qsTr("Cancel")
                width: 120
                height: 40
                smooth: true
                clip: true
                bgSourceUp: "image://theme/notes/btn_spelling_up"
                bgSourceDn: "image://theme/notes/btn_spelling_dn"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (cancelButton.active)
                            cancelButton.clicked(mouse);

                        container.fontSize = "0";
                        container.buttonCancelClicked();
                    }

                    onPressed: if (cancelButton.active) cancelButton.pressed = true
                    onReleased: if (cancelButton.active) cancelButton.pressed = false
                }
            }
        }
    }
}
