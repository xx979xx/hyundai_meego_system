/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Rectangle {
    id: noteButton
    smooth: true;

    property alias title: textElement.text
    property alias comment: textComment.text
    property bool checkBoxVisible: false
    property bool isNote : true
    property int checkBoxWidth: width/ 15
    property alias showGrip: gridView.visible

    signal noteSelected(string noteName)
    signal noteDeselected(string noteName)

    Row {
        id: rowElement;
        anchors.fill: parent
        width: parent.width;
        height: parent.height;

        Item {
            id:checkboxContainer
            opacity: checkBoxVisible
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left:parent.left
            width: checkBoxWidth

            MouseArea {
                anchors.fill:parent
                onClicked: {
                    checkbox.isChecked=!checkbox.isChecked
                    noteButton.color = checkbox.isChecked ?  Qt.rgba ( 230/255, 240/255, 255/255, 1) : "white";

                    if (checkbox.isChecked)
                    {
                        noteSelected(title);
                    }
                    else
                    {
                        noteDeselected(title);
                    }
                }
            }

            CheckBox {
                id:checkbox
                anchors.centerIn:parent

                MouseArea {
                    anchors.fill:parent
                    onClicked: {
                        checkbox.isChecked=!checkbox.isChecked
                        noteButton.color = checkbox.isChecked ?  Qt.rgba ( 230/255, 240/255, 255/255, 1) : "white";
                        if (checkbox.isChecked)
                        {
                            noteSelected(title);
                        }
                        else
                        {
                            noteDeselected(title);
                        }
                    }
                }
            }

            Rectangle {
                anchors.top: parent.top
                anchors.right:parent.right
                anchors.bottom: parent.bottom
                width:1
                color: Qt.rgba ( 189/255, 189/255, 189/255, 1) //THEME
            }
        }

        Column {
            id: textColumn;
            anchors.top: parent.top
            anchors.left: checkBoxVisible? checkboxContainer.right : parent.left;
            anchors.leftMargin:25
            anchors.right:gridView.left
            anchors.rightMargin: 10;
            height: parent.height


            Text {
                id: textElement
//                clip: true
                anchors.top: parent.top
                anchors.topMargin: 7
                anchors.left: parent.left;
                anchors.leftMargin: 40
                anchors.right: parent.right;
                height: parent.height /2
                font.pixelSize: theme_fontPixelSizeNormal
                text: qsTr("Text Element");
                wrapMode: Text.Wrap
            }

            Text {
                id: textComment
                anchors.left: parent.left;
                anchors.leftMargin: 43;
                anchors.bottom:parent.bottom
                width: parent.width
                height: parent.height / 2
                font.pixelSize: theme_fontPixelSizeSmall
                text: qsTr("Add some comments here");
                elide: Text.ElideRight
                color: theme_fontColorInactive
            }
        }

        Grid {
            id: gridView
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right;
            anchors.rightMargin: 10;
            columns:3
            rows:3
            spacing:3

            Repeater {
                model: 9

                Image {
                    width: 8;
                    height: 8;
                    smooth: true
                    source: "image://theme/settings/icn_brightness_low"
                }
            }
	}
    }

    Image {
        id: separator
        width: parent.width
        anchors.bottom: parent.bottom
        source: "image://theme/tasks/ln_grey_l"
    }
}
