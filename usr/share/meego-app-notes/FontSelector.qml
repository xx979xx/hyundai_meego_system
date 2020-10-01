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

    signal fontSelected(string fontName)
    signal buttonOKClicked(string fontName)
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
        color: "lightblue"
        width: 260
        height: 280
        focus: true
        anchors.centerIn: parent

        ListView {
            id:listView
            height: 200
            width: mainRect.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            property int index: 0;
            property string selectedFont: fontNames[0];
            property variant fontNames: ["Times New Romans", "Helvetica",
                "Courier", "Arial", "Lucida"]

            ListModel {
                id: fontModel

                ListElement {
                    name: "Times New Romans"
                    index: 0
                }

                ListElement {
                    name: "Helvetica"
                    index: 1
                }

                ListElement {
                    name: "Courier"
                    index: 2
                }

                ListElement {
                    name: "Arial"
                    index: 3
                }

                ListElement {
                    name: "Lucida"
                    index: 4
                }
            }

            model: fontModel
            delegate: Item {
                height: 25
                width: mainRect.width
                anchors.horizontalCenter: parent.horizontalCenter

                property int index: model.index;

                Text {
                    anchors.centerIn: parent
                    text: model.name;
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView.currentIndex = index;
                        listView.highlight = listView.highlighter;
                    }

                    onDoubleClicked: container.fontSelected(listView.selectedFont)
                }
            }

            highlight: Rectangle {
                id: highlighter;
                color: "lightsteelblue";
                width: listView.width
            }

            focus: true
            highlightFollowsCurrentItem: true

            header:Item {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 25

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Pick a font")
                    color: "white"
                    font.bold: true
                }
            }

            onCurrentIndexChanged: selectedFont = fontNames[currentIndex]
            Keys.onReturnPressed: {
                container.fontSelected(selectedFont);
                console.log("onReturnPressed");
            }
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: listView.bottom
            anchors.topMargin: 20

            Button {
                id: okButton
                anchors.right: cancelButton.left
                anchors.rightMargin: 20
                text: qsTr("OK")
                x: 20;
                width: 100
                height: 40
                smooth:true
                clip: true
                bgSourceUp: "image://theme/notes/btn_spelling_up"
                bgSourceDn: "image://theme/notes/btn_spelling_dn"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (okButton.active)
                            okButton.clicked(mouse);
                        container.buttonOKClicked(listView.selectedFont);
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
                width: 100
                height: 40
                smooth:true
                clip: true
                bgSourceUp: "image://theme/notes/btn_spelling_up"
                bgSourceDn: "image://theme/notes/btn_spelling_dn"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (cancelButton.active)
                            cancelButton.clicked(mouse);
                        container.buttonCancelClicked();
                    }

                    onPressed: if (cancelButton.active) cancelButton.pressed = true
                    onReleased: if (cancelButton.active) cancelButton.pressed = false
                }
            }
        }
    }
}
