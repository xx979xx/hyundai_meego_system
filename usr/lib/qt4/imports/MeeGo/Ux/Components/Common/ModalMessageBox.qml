/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass ModalMessageBox
  \title ModalMessageBox
  \section1 ModalMessageBox
  \qmlcm The ModalMessageBox is the base component for message boxes.

  \section2 API Properties
  \qmlproperty Item content
  \qmlcm the content can be added here

  \qmlproperty string title
  \qmlcm title of the message box

  \qmlproperty string text
  \qmlcm message text

  \qmlproperty int width
  \qmlcm width of buttons

  \qmlproperty int height
  \qmlcm height of buttons

  \qmlproperty bool fogClickable
  \qmlcm sets the fog clickable

  \section2 Signals
  \qmlproperty [signal] accepted
  \qmlcm emitted on 'OK' clicked.

  \qmlproperty [signal] rejected
  \qmlcm emitted on 'Cancel' clicked.

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
    ModalMessageBox {
        id: messageBox

       text: "Any kind of message can be displayed here. More text. Click ok or cancel."

       title: "Example Message Box"
   }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

ModalDialog{
    id: messageBox

    property alias text: textField.text

    fogClickable: false

    content: Flickable{
        id: flickArea

        anchors.fill: parent
        clip: true
        flickableDirection: Flickable.VerticalFlick
        interactive: ( textField.height > height )
        contentHeight: textField.height

        Item {
            id: textBox

            anchors.left: parent.left
            anchors.right:  parent.right
            anchors.leftMargin: 20
            anchors.rightMargin: 20

            height:  ( textField.height < flickArea.height ) ? flickArea.height : textField.height

            Text {
                id: textField

                font.pixelSize: theme.fontPixelSizeNormal
                color: "black" // theme.buttonFontColor

                anchors.left: parent.left
                anchors.right:  parent.right
                anchors.verticalCenter: parent.verticalCenter

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: ""

                Theme{ id: theme }
            }

            // This resets the flickables content position to ensure text is psoitioned correctly on height changes.
            onHeightChanged: flickArea.contentY = 0
        }
    }
}
