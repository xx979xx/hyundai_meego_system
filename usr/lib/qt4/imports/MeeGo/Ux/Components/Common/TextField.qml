/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass TextField
  \title TextField
  \section1 TextField
  \qmlcm The TextField is a text entry for multiple lines of text.
         It will turn scrollable if the text is too big for the text field.

  \section2 API Properties

  \qmlproperty alias cursorPosition
  \qmlcm See the corresponding QML TextEdit property

  \qmlproperty alias defaultText
  \qmlcm sets a defaultText in case the TextField is emtpy

  \qmlproperty alias font
  \qmlcm the texts font item

  \qmlproperty alias readOnly
  \qmlcm sets the text read only. The text can not be altered if set to true.

  \qmlproperty alias text
  \qmlcm the text fields text

  \qmlproperty alias textFormat

  \qmlcm See the corresponding QML TextEdit property.

  \section2 Signals
  \qmlproperty [signal] textChanged
  \qmlcm emitted when the text has changed

  \qmlproperty [signal] cursorRectangleChanged
  \qmlcm emitted when the cursor bounding box (position or size) has changed

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
    TextField {
        id: textField

        text: "Type here."
   }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

ThemeImage {
    id: container

    property alias defaultText: fakeText.text
    property alias cursorPosition: edit.cursorPosition
    property alias font:           edit.font
    property alias readOnly:       edit.readOnly
    property alias text:           edit.text
    property alias textFormat:     edit.textFormat
    property alias contentHeight:  flick.contentHeight
    property alias color:          edit.color

    signal textChanged
    signal cursorRectangleChanged

    height: 50
    source: (edit.focus && !readOnly) ? "image://themedimage/widgets/common/text-area/text-area-background-active" : "image://themedimage/widgets/common/text-area/text-area-background"
    clip: true

    opacity: readOnly ? 0.5 : 1.0

    onFocusChanged: {
        edit.focus = focus
    }

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

        TextEdit {
            id: edit

            width: flick.width
            height: flick.height

            wrapMode: TextEdit.Wrap
            onCursorRectangleChanged: {
                flick.ensureVisible(cursorRectangle)
                container.cursorRectangleChanged()
            }   
            font.pixelSize: theme.fontPixelSizeNormal
            Keys.forwardTo: container

            onTextChanged: {
                container.textChanged()
            }

            onPaintedSizeChanged: {
                if( window ) {
                    if( edit.activeFocus && window.currentVkbHeight > 0 ) {
                        window.updateVkbShift( mapToItem( topItem.topItem, 0, edit.cursorRectangle.y + edit.cursorRectangle.height * 3 ).y )
                    }
                }
            }

            CCPContextArea {
                editor: edit
                visible: !edit.readOnly
            }
        }
        
        Text {
            id: fakeText

            anchors.fill: edit

            font: edit.font
            color: edit.color
            opacity: 0.6
            wrapMode: TextEdit.Wrap

            visible: ( edit.text == "" && !edit.focus ) ||( edit.text == "" && edit.readOnly )

            Connections {
                target: edit
                onTextChanged: {
                    fakeText.visible = (edit.text == "")
                }
            }
        }
    }

    TopItem{ id: topItem }

    Connections {
        target: mainWindow
        onVkbHeight: {
            if( window ) {
                if( edit.activeFocus && height > 0 ) {
                    window.adjustForVkb( mapToItem( topItem.topItem, 0, edit.cursorRectangle.y + edit.cursorRectangle.height * 3 ).y, width, height )
                }
            }
        }
    }
}
