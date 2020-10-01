/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass TextEntry
  \title TextEntry
  \section1 TextEntry
  \qmlcm The TextEntry is a text entry for single lines of text.
         It will turn scrollable if the text is too big for the text field.

  \section2 API Properties

  \qmlproperty alias acceptableInput
  \qmlcm See the corresponding QML TextInput property

  \qmlproperty alias cursorPosition
  \qmlcm See the corresponding QML TextInput property

  \qmlproperty alias defaultText
  \qmlcm sets a defaultText in case the input is empty.

  \qmlproperty alias echoMode
  \qmlcm See the corresponding QML TextInput property

  \qmlproperty alias font
  \qmlcm provides access to the font used for the text

  \qmlproperty alias inputMask
  \qmlcm See the corresponding QML TextInput property

  \qmlproperty alias inputMethodHints

  \qmlcm provides access to the inputMethodHints of the input.

  \qmlproperty alias readOnly
  \qmlcm sets the input to read only. The text can not be altered if set to true

  \qmlproperty alias text
  \qmlcm provides access to the inputted text

  \qmlproperty alias validator
  \qmlcm See the corresponding QML TextInput property

  \qmlproperty alias textFocus
  \qmlcm Provides access to the focus property of the TextInput element.

  \qmlproperty int horizontalMargins
  \qmlcm defines the horizintal margins for the text. Default is 6 (borderimage border).

  \section2 Signals
  \qmlproperty [signal] textChanged
  \qmlcm emitted when the text has changed

  \qmlproperty [signal] accepted
  \qmlcm emitted when an enter was pressed and the input is in an acceptable state

  \section2 Functions

  \qmlfn positionAt(int)
  \qmlcm See the corresponding QML TextInput function

  \section2 Example
  \qml
    TextEntry {
        id: textEntry


        text: "Type here."
   }
  \endqml
*/

import Qt 4.7
import MeeGo.Ux.Gestures 0.1
import MeeGo.Ux.Components.Common 0.1


BorderImage {
    id: container

    property alias acceptableInput: input.acceptableInput
    property alias cursorPosition: input.cursorPosition
    property alias defaultText: fakeText.text
    property alias echoMode: input.echoMode
    property alias font: input.font
    property alias inputMask: input.inputMask
    property alias inputMethodHints: input.inputMethodHints
    property alias readOnly: input.readOnly
    property alias text: input.text
    property alias validator: input.validator
    property alias color: input.color
    property alias textFocus: input.focus
    property int horizontalMargins: 6

    //TODO: remove this, it breaks encapsulation
    property alias textInput: input

    signal textChanged
    signal accepted

    function positionAt(x) {
        return input.positionAt(x)
    }

    border.top: 6
    border.bottom: 6
    border.left: 6
    border.right: 6

    height: 50
    source: (input.focus && !readOnly) ? "image://themedimage/widgets/common/text-area/text-area-background-active" : "image://themedimage/widgets/common/text-area/text-area-background"
    clip: true

    opacity: readOnly ? 0.5 : 1.0

    Theme{ id: theme }
    
    onFocusChanged: {
        input.focus = focus
    }

    GestureArea {     // this ensures the text gets focus when only the BorderImage is clicked
        anchors.fill: parent
        acceptUnhandledEvents: true

        Tap {
            onStarted: {
                 container.focus = true
            }
        }
    }

    TextInput {
        id: input

        x: horizontalMargins

        width: parent.width - horizontalMargins * 2

        anchors.verticalCenter: parent.verticalCenter

        font.pixelSize: theme.fontPixelSizeLarge

        onTextChanged: {
            container.textChanged()
        }
        
        onAccepted: {
            container.accepted()
        }

        CCPContextArea {
            editor: parent
            visible: !input.readOnly
        }
    }

    Text {
        id: fakeText

        x: horizontalMargins

        width: parent.width - horizontalMargins * 2
        clip: true
        anchors.verticalCenter: parent.verticalCenter

        font: input.font
        color: input.color
        opacity: 0.6

        visible: ( input.text == ""  && !input.focus ) || ( input.text == "" && input.readOnly )

        Connections {
            target: input
            onTextChanged: {
                fakeText.visible = (input.text == "")
            }
        }
    }

    TopItem { id: topItem }

    Connections {
        target: mainWindow
        onVkbHeight: {
            if( window ) {
                if( input.activeFocus && height > 0 ) {
                    window.adjustForVkb( mapToItem( topItem.topItem, 0, container.height * 2 ).y, width, height )
                }
            }
        }
    }
}
