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
    width: 260
    height:125

    property alias buttonText: button.text
    property alias button2Text: button2.text
    property alias dialogTitle: title.text
    property alias menuHeight: contents.height
    property alias defaultText: textInput.defaultText
    property alias text: textInput.text

    property int minWidth: width
    property int maxCharactersCount: 50

    anchors.fill: parent
    signal button1Clicked
    signal button2Clicked

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

        x: (container.width - width) / 2
        y: (container.height - height) / 2
        width: contents.width + 40 //478
        height: contents.height + 40 //318

        Item {
            id: contents
            x: 20
            y: 20

            //autoresize
            width: {
                var buttonsWidth = button.width + button2.width + buttonBar.spacing;
                if (title.paintedWidth < buttonsWidth) {
                    if (buttonsWidth < minWidth)
                        return minWidth;
                    else
                        return buttonsWidth;
                }

                if (title.paintedWidth < minWidth)
                    return minWidth;
                else
                    return title.paintedWidth;
            }

            height: title.height + rectText.height + charsIndicator.height + buttonBar.height

            Text {
                id: title
                font.weight: Font.Bold
                font.pixelSize: 14

                anchors { left: parent.left;
                    right: parent.left;
                    top: parent.top;
                }
            }

            Rectangle {

                anchors { right: parent.right;
                    left: parent.left;
                    top: title.bottom;
                    topMargin: 15;
                    bottom: buttonBar.top;
                    bottomMargin: 15;
                }
                id: rectText;
                color: "white"
                //border.width: 1
                //focus: true

                //TEMPORARY WORKAROUND!
                //TextField's textChanged signal is not emitted.
                //UNCOMMENT THIS CODE WHEN TextField WILL BE FIXED
//                UX.TextField {
//                    id: textInput
//                    anchors.fill: parent;

//                    onTextChanged: {
//                        var string = textInput.text;
//                        charsIndicator.text = qsTr("%1/%2").arg(container.maxCharactersCount - string.length).arg(container.maxCharactersCount);
//                        if (string.length <= container.maxCharactersCount)
//                            return;
//                        var cursorPosition = textInput.cursorPosition;
//                        textInput.text = string.slice(0, container.maxCharactersCount);
//                        textInput.cursorPosition = cursorPosition > container.maxCharactersCount ? cursorPosition - 1 : cursorPosition;
//                    }
//                }

                //TEMPORARY WORKAROUND!
                //TextField's textChanged signal is not emitted.
                //REMOVE THIS CODE WHEN TextField WILL BE FIXED
                Loader {
                    id: textInput
                    anchors.fill: parent

                    sourceComponent: textInputComponent

                    property string text: item.text
                    property string defaultText: item.defaultText

                    onTextChanged: {
                        if (item.text == textInput.text)
                            return;
                        item.text = textInput.text;
                    }
                    onDefaultTextChanged: item.defaultText = textInput.defaultText

                    Connections {
                        target: textInput.item
                        onTextChanged: {
                            var string = textInput.item.text;
                            charsIndicator.text = qsTr("%1/%2").arg(container.maxCharactersCount - string.length).arg(container.maxCharactersCount);
                            if (string.length <= container.maxCharactersCount) {
                                textInput.text = string;
                                return;
                            }
                            var cursorPosition = textInput.item.cursorPosition;
                            textInput.item.text = string.slice(0, container.maxCharactersCount);
                            textInput.item.cursorPosition = cursorPosition > container.maxCharactersCount ? cursorPosition - 1 : cursorPosition;
                        }
                    }
                }
            }

            Text {
                id: charsIndicator
                font.italic: true

                anchors.right: parent.right
                anchors.top: rectText.bottom

                font.pixelSize: 10

                text: qsTr("%1/%2").arg(container.maxCharactersCount).arg(container.maxCharactersCount)
            }

            Row {
                id: buttonBar
                width: parent.width
                height: 40

                anchors {
                    bottom: parent.bottom;
                    right: parent.right;
                    left: parent.left;
                    //leftMargin: parent.width - (button.width + spacing + button2.width)
                }

                Button {
                    id: button
                    bgSourceUp: "image://theme/btn_blue_up"
                    bgSourceDn: "image://theme/btn_blue_dn"
                    active: textInput.text.length > 0
                    //anchors.left: parent.left
                    onClicked:if (active) container.button1Clicked();

                }

                Button {
                    id: button2
                    onClicked: container.button2Clicked();
                    anchors.right: parent.right
                }
            }
        }
    }

    //TEMPORARY WORKAROUND!
    //TextField's textChanged signal is not emitted.
    //UNCOMMENT THIS CODE WHEN TextField WILL BE FIXED
    Component {
        id: textInputComponent
        BorderImage {
            id: borderImage
            property alias text: edit.text
            property alias font: edit.font
            property alias readOnly: edit.readOnly
            property alias defaultText: fakeText.text
            property alias cursorPosition: edit.cursorPosition//new property

            signal textChanged

            border.top: 6
            border.bottom: 6
            border.left: 6
            border.right: 6

            height: 50
            source: (edit.focus && !readOnly) ? "image://themedimage/widgets/common/text-area/text-area-background-active" : "image://themedimage/widgets/common/text-area/text-area-background"
            clip: true

            opacity: readOnly ? 0.5 : 1.0

            onHeightChanged: {
                if( flick.contentHeight <= flick.height ){
                    flick.contentY = 0
                }
                else if( flick.contentY + flick.height > flick.contentHeight ){
                    flick.contentY = flick.contentHeight - flick.height
                }
            }

            Theme { id: theme }

            Flickable {
                id: flick

                function ensureVisible(r) {
                    if (contentX >= r.x){
                        contentX = r.x
                    } else if (contentX+width <= r.x+r.width) {
                        contentX = r.x+r.width-width
                    }

                    if (contentY >= r.y){
                        contentY = r.y
                    } else if (contentY+height <= r.y+r.height) {
                        contentY = r.y+r.height-height
                    }
                }

                anchors {
                    fill: parent
                    topMargin: 3      // this value is the hardcoded margin to keep the text within the backgrounds text field
                    bottomMargin: 3
                    leftMargin: 4
                    rightMargin: 4
                }
                contentWidth: edit.paintedWidth
                contentHeight: edit.paintedHeight

                flickableDirection: Flickable.VerticalFlick
                interactive: ( contentHeight > flick.height ) ? true : false

                clip: true

                TextField {
                    id: edit

                    width: flick.width
                    height: flick.height

//                    wrapMode: TextEdit.Wrap
//                    onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
//                    font.pixelSize: theme.fontPixelSizeNormal

                    onTextChanged: borderImage.textChanged()//Fix for TextField
                }

                Text {
                  id: fakeText

                  property bool firstUsage: true

                  anchors.fill: edit

                  font: edit.font
                  color: "slategrey"

                  visible: ( edit.text == ""  && !edit.focus && firstUsage )

                  Connections {
                      target: edit
                      onTextChanged: {
                          fakeText.visible = (edit.text == "" && fakeText.firstUsage);//Fix for TextField
                          fakeText.firstUsage = false;//Fix for TextField
                      }
                  }
              }
            }
        }
    }

}
