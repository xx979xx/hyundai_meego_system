/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass InfoBar
   \title InfoBar
   \section1 InfoBar
   This is a info box. When hidden it has height zero. When you call show() it will extend and show up,
   showing the message you set to 'text'. This is a rich text component.

   \section2 API properties

      \qmlproperty string text
      \qmlcm sets the text displayed on the info box.

      \qmlproperty real width
      \qmlcm real, defines the width of the info box.

  \section2 Signals
  \qmlnone

  \section2 Functions
  \qmlfn  show
  \qmlcm shows the InfoBar

  \qmlfn hide
  \qmlcm hides the InfoBar

  \section2 Example
  \qml
      InfoBar {
         id: info

         text: "Hello world!"

         Component.onCompleted: show()
      }
  \endqml
*/

import Qt 4.7

Item{
    id: infoBar

    property alias text: textBox.text
    property int verticalMargins: 5
    property int horizontalMargins: 10
    property int animationTime: 200

    function show(){
        disappear.running = false
        showUp.running = true
    }

    function hide(){
        showUp.running  = false
        disappear.running = true
    }

    clip: true

    width: 200
    height: 0

    ThemeImage {
        anchors.fill: parent

        source: "image://themedimage/widgets/common/infobar/infobar-background"
    }

    Text{
        id: textBox

        anchors.centerIn: parent

        width: parent.width - horizontalMargins * 2

        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        textFormat: Text.RichText

        font.bold: true
        font.pixelSize: theme.fontPixelSizeSmall

        opacity: 0
    }

    SequentialAnimation{
        id: showUp
        NumberAnimation {
            target: infoBar
            property: "height"
            to: textBox.height + infoBar.verticalMargins * 2
            duration: animationTime
        }
        NumberAnimation {
            target: textBox
            property: "opacity"
            to: 1
            duration: animationTime
        }
    }

    SequentialAnimation{
        id: disappear
        NumberAnimation {
            target: textBox
            property: "opacity"
            to: 0
            duration: animationTime / 2
        }
        NumberAnimation {
            target: infoBar
            property: "height"
            to: 0
            duration: animationTime
        }
    }

    Theme { id: theme }
}
