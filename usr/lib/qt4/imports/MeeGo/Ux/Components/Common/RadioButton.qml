/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass RadioButton
   \title RadioButton
   \section1 RadioButton
   This is a radio button. The group property has to be set and it needs to be added to a \l {RadioGroup}.
   All radio buttons in a group need unique values.

   \section2 API properties

      \qmlproperty bool checked
      \qmlcm holds the checked state. Only to be altered by RadioGroup.

      \qmlproperty variant value
      \qmlcm holds the buttons value. It has to be set unique within its group.

      \qmlproperty QtObject group
      \qmlcm holds the group the button belongs to.

      \qmlproperty real height
      \qmlcm the buttons height. By default it will be the height of the buttons image.

      \qmlproperty real width
      \qmlcm the buttons width. By default it's set to cover the image and text.

      \qmlproperty alias text
      \qmlcm provides access to the text displayable next to the button.

      \qmlproperty alias font
      \qmlcm provides access to the font of the text displayable next to the button.

  \section2 Signals
  \qmlnone

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
      RadioGroup { id: radioGroup }

      RadioButton {
         id: radioButton

         group: radioGroup
         value: 1

         Component.onCompleted: { radioGroup.add( radioButton ) }
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Ux.Gestures 0.1

Item {
    id: root

    property bool checked: false
    property variant value
    property QtObject group
    property alias text: radioText.text
    property alias font: radioText.font

    width: image.sourceSize.width + radioText.width + 10
    height: image.sourceSize.height

    ThemeImage {
        id: image

        width: height
        height: parent.height
        source: root.checked ? "image://themedimage/widgets/common/radio-button/radio-button-background-active" :
                               "image://themedimage/widgets/common/radio-button/radio-button-background"
        smooth:  true
    }

    GestureArea {
        id: gestureArea
        anchors.fill: parent
        
        Tap {
	   onStarted: {	      
              image.source = bgSourceDn
	      container.pressed = true
	   }
	   onCanceled: {
              image.source = bgSourceUp
              container.pressed = false
	   }
	   onFinished: {
             if (!checked && group) { group.check(root); }
	   }
	}
    }

    Text {
        id: radioText

        anchors.left: image.right
        anchors.leftMargin: 10

        anchors.verticalCenter: image.verticalCenter

        font.pixelSize: theme.fontPixelSizeNormal
        //elide:  Text.ElideRight
    }

    Theme {id: theme }

    onGroupChanged: {
        if (group) { group.add(root); }
    }
}//end of radiobutton
