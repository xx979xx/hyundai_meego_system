/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass Label
  \title Label
  \section1 Label
  \qmlcm This is a theme conform label, displaying a text.

  \section2  API Properties
  \qmlproperty alias color
  \qmlcm provides access to the label's color

  \qmlproperty alias smooth
  \qmlcm bool, true if the text should be smoothed

  \qmlproperty bool elideText
  \qmlcm bool, true if the text should elide if it's to long

  \qmlproperty alias text
  \qmlcm provides access to the label's text string

  \qmlproperty alias textFormat
  \qmlcm provides access to the label's text format

  \qmlproperty alias wrapMode
  \qmlcm provides access to the label's wrap mode

  \qmlproperty alias font
  \qmlcm provides access to the label's font

  \qmlproperty string background
  \qmlcm sets the source for the background image

  \section2 Signal
  \qmlnone

  \section2  Functions
  \qmlnone

  \section2 Example
  \qml
	Label {
		id: myLabel
		text: qsTr("Label")
		width: 200
		height: 50
	}
  \endqml

*/

import Qt 4.7

ThemeImage {
    id : container

    // API
    property alias color: labelText.color
    property alias smooth: labelText.smooth
    property bool elideText: false
    property alias text: labelText.text
    property alias textFormat: labelText.textFormat
    property alias wrapMode: labelText.wrapMode
    property alias font: labelText.font
	
    property string background : "image://themedimage/widgets/common/menu/menu-background"

    source: background

    width: 210
    height: 60
    visible: true
    opacity:  1
    clip: true

    Theme { id: theme }

    // the button's text
    Text {
        id: labelText

        width:  parent.width - 20
        height:  parent.height - 4
        anchors.centerIn: parent
        clip: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: theme.fontPixelSizeLargest
        elide: if( elideText ){ Text.ElideRight }else { Text.ElideNone }
    }
}

