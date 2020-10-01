/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass IconButton
   \title IconButton
   \section1 IconButton
   This is a button with released and pressed state images. Additionally icons for the
   pressed and released state can be set and which are show centered on the button.

   \section2 API properties

      \qmlproperty string icon
      \qmlcm sets the default icon displayed on the button.

      \qmlproperty string iconDown
      \qmlcm sets the icon displayed on the button in pressed state.

      \qmlproperty bool iconFill
      \qmlcm determines wheather the icon should fill the button automatically

      \qmlproperty property alias iconFillMode
      \qmlcm the fillMode of the icon, default is Image.PreserveAspectFit

      \qmlproperty bool hasBackground
      \qmlcm If true the properties bgSourceUp and bgSourceDown are used to
             render the background of the Iconbutton.

      \qmlproperty string bgSourceUp
      \qmlcm path to an image file used for released state.

      \qmlproperty string bgSourceDn
      \qmlcm path to an image file used for pressed state.

      \qmlproperty bool active
      \qmlcm stores if the button is clickable.

      \qmlfn bool pressed
      \qmlcm stores if the button is currently pressed. Intended as read-only.

  \section2 Signals

      \qmlproperty [signal] clicked
      \qmlcm emitted if the button is active and clicked.
        \param variant mouse
        \qmlpcm contains mouse event data. \endparam

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
      IconButton {
         id: myButton

         icon: "myImage.png"
         iconDown: "myImagePressed.png"
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Ux.Gestures 0.1
import MeeGo.Ux.Components.Common 0.1

Item {
    id: container

    property string icon: ""
    property string iconDown: ""
    property bool iconFill: false
    property alias iconFillMode: image.fillMode

    property bool hasBackground: true
    property string bgSourceUp: "image://themedimage/widgets/common/button/button"
    property string bgSourceDn: "image://themedimage/widgets/common/button/button-pressed"

    property bool active: true
    property bool pressed: false

    signal clicked()

    // lower the button's opacity to mark it inactive
    opacity: active ? 1.0 : 0.5

    width: ( icon != "" ) ? image.sourceSize.width : 160
    height: ( icon != "" ) ? image.sourceSize.height : 80
    clip: true

    Theme { id: theme }

    // iconsButtons Background Image    
    ThemeImage {

        id: bgImage

        visible: hasBackground

        source: bgSourceUp
        anchors.fill: parent

        states: [
            State {
                name: "pressed"
                when: container.pressed
                PropertyChanges {
                    target: bgImage
                    source: bgSourceDn
                }
            }
        ]
    }    

    Image {
        id: image

        anchors.centerIn: parent
        width: iconFill ? container.width : sourceSize.width
        height: iconFill ? container.height : sourceSize.height
        source: icon
        fillMode: Image.PreserveAspectFit

        // if the button didn't get width or height, set them so that they at least cover the icon
        Component.onCompleted: {
            if ( container.width == 0 )
                container.width = image.paintedWidth + 20;

            if ( container.height == 0 )
                container.height = image.paintedHeight + 20;
        }

        states: [
            State {
                name: "pressed"
                when: container.pressed
                PropertyChanges {
                    target: image
                    source: iconDown == "" ? icon : iconDown
                }
            }
        ]
    }

    GestureArea {
        id: gestureArea

        anchors.fill: hasBackground ? bgImage : image

        Tap {
	    when: container.enabled
	    onStarted: {
                 container.pressed = true
	    }
            onCanceled: {
                container.pressed = false
	    }
	    onFinished: {
                container.clicked()
                container.pressed = false
	    }
        }
        TapAndHold {
            when: container.enabled
            onStarted: {
                container.pressed = true
            }
            onCanceled: {
                container.pressed = false
            }
            onFinished: {
                container.clicked()
                container.pressed = false
            }
        }
    }
}
