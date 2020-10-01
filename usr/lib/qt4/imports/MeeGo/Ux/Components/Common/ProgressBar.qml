/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass ProgressBar
   \title ProgressBar
   \section1 ProgressBar
   This is a progress bar with a customizable size to show the progress of a running process.

   \section2 API properties

      \qmlproperty real percentage
      \qmlcm sets the text displayed on the button.

      \qmlproperty alias fontColor
      \qmlcm provides access to the font color of the text which displays the percentage over
             the unfilled area.

      \qmlproperty alias fontColorFilled
      \qmlcm provides access to the font color of the text which displays the percentage over
             the filled area.

  \section2 Signals
  \qmlnone

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
      ProgressBar {
         id: progressBar

         percentage: 50.5
      }
  \endqml
*/

import Qt 4.7

//Rectangle {
BorderImage{
    id: container

    property real percentage: 50
    property alias fontColor: backText.color
    property alias fontColorFilled: filledText.color

    width: 210
    height: 60

    clip:  true

    border.left:   4
    border.top:    4
    border.bottom: 4
    border.right:  4

    source: "image://themedimage/widgets/common/progress-bar/progress-bar-backgound"

    Theme { id: theme }

    BorderImage{
        id: progressBar

        property real progressPercentage: (container.percentage < 0) ? (0) : ( ( container.percentage > 100) ? 100 : container.percentage )

        clip:  true

        border.left:   4
        border.top:    4
        border.bottom: 4
        border.right:  4

        source: "image://themedimage/widgets/common/progress-bar/progress-bar-fill"

        anchors { top: container.top; bottom: container.bottom; left: parent.left }

        width: parent.width * progressPercentage / 100

        z: 1

        Text {
            id: filledText

            x: backText.x
            y: backText.y

            width: container.width
            height: container.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: theme.fontPixelSizeLarge
            color: theme.fontColorProgressFilled

            text: qsTr("%1%").arg( parseInt( progressBar.progressPercentage ) )
        }
    }

    Text {
        id: backText

        anchors.centerIn: container

        width: container.width
        height: container.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        z: 0

        font.pixelSize: theme.fontPixelSizeLarge
        color: theme.fontColorProgress

        text: qsTr("%1%").arg( parseInt( progressBar.progressPercentage ) )
    }
}
