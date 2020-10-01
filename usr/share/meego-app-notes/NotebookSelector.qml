/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.Notes 0.1

Item {
    id: container
    anchors.fill: parent

    signal notebookSelected(string newNotebookName)
    signal escapePressed()
    signal buttonOKClicked(string newNotebookName)
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
        height: 200
        anchors.centerIn: parent
        focus: true

        ListView {
            id:listView
            height: 200
            width: mainRect.width
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            property int index: 0
            property string selectedNotebook: qsTr("Everyday Notes (default)")

            model: notebooksModel
            delegate: Item {
                height: 25
                width: mainRect.width
                anchors.horizontalCenter: parent.horizontalCenter

                property int index: model.index

                Text {
                    id: delegateText
                    anchors.centerIn: parent
                    text: model.name
                    color: "white"
                }

                Keys.onReturnPressed: {
                    listView.selectedNotebook = delegateText.text;
                    container.notebookSelected(listView.selectedNotebook);
                }

                Keys.onEscapePressed: container.escapePressed()

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView.currentIndex = index;
                        listView.highlight = listView.highlighter;
                        listView.selectedNotebook = delegateText.text;
                    }

                    onDoubleClicked: {
                        listView.selectedNotebook = delegateText.text;
                        container.notebookSelected(listView.selectedNotebook);
                    }
                }
            }

            highlight: Rectangle {
                id: highlighter
                color: "lightsteelblue"
                width: listView.width
            }

            focus: true
            highlightFollowsCurrentItem: true

            header: Item {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 25

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Pick a notebook")
                    color: "white"
                    font.bold: true
                }
            }

            Keys.onReturnPressed: container.notebookSelected(selectedNotebook)
        }
    }
}
