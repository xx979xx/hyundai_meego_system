import Qt 4.7
import MeeGo.Ux.Gestures 0.1 as Gesture
/*!
   \qmlclass mouseArea
   \title mouseArea
   \section1 mouseArea
         this is a transition component for using Gestures as a MouseArea.
	 There is no need to change the API and the usage of your MouseArea,
         just switch from MouseArea to mouseArea QML element.
	 all the signals have instead of an MouseEvent the parameters available:
	    int mouseX
	    int mouseY
	    bool wasHeld
	 as a replacement for them.

  \section2 API Properties
  \qmlproperty bool enabled
  \qmlcm determine wheather the area is enabled or not
  \qmlproperty int mouseX.
  \qmlcm the current mouseX value
  \qmlproperty int mouseY
  \qmlcm the current mouseY value
  \qmlproperty bool pressed
  \qmlcm determine if the mouseArea was pressed
  \qmlproperty bool hoverEnabled
  \qmlcm if set to true, the mouseArea will signal any hover activity
  
  \section2 Signals
  \qmlfn onCanceled
  \qmlcm emitted if.
        \param int mouseX
        \qmlpcm x of the mouse event \endparam
        \param int mouseY
        \qmlpcm x of the mouse event \endparam
        \param int wasHeld
        \qmlpcm true Tap is on hold \endparam
  \qmlfn onClicked
  \qmlcm emitted if.
        \param int mouseX
        \qmlpcm x of the mouse event \endparam
        \param int mouseY
        \qmlpcm x of the mouse event \endparam
        \param int wasHeld
        \qmlpcm true Tap is on hold \endparam
  \qmlfn onDoubleClicked
  \qmlcm emitted if a double click was recognized.
        \param int mouseX
        \qmlpcm x of the mouse event \endparam
        \param int mouseY
        \qmlpcm x of the mouse event \endparam
        \param int wasHeld
        \qmlpcm true Tap is on hold \endparam
  \qmlfn onEntered
  \qmlcm emitted if the the area is hovered.
        \param int mouseX
        \qmlpcm x of the mouse event \endparam
        \param int mouseY
        \qmlpcm x of the mouse event \endparam
        \param int wasHeld
        \qmlpcm true Tap is on hold \endparam
  \qmlfn onExited
  \qmlcm emitted if the hover is exited.
        \param int mouseX
        \qmlpcm x of the mouse event \endparam
        \param int mouseY
        \qmlpcm x of the mouse event \endparam
        \param int wasHeld
        \qmlpcm true Tap is on hold \endparam
  \qmlfn onPositionChanged
  \qmlcm emitted if the positionChanged.
        \param int mouseX
        \qmlpcm x of the mouse event \endparam
        \param int mouseY
        \qmlpcm x of the mouse event \endparam
        \param int wasHeld
        \qmlpcm true Tap is on hold \endparam
  \qmlfn onPressandHold
  \qmlcm emitted if pressed and hold.
        \param int mouseX
        \qmlpcm x of the mouse event \endparam
        \param int mouseY
        \qmlpcm x of the mouse event \endparam
        \param int wasHeld
        \qmlpcm true Tap is on hold \endparam
  \qmlfn onPressed
  \qmlcm emitted if the area was pressed.
        \param int mouseX
        \qmlpcm x of the mouse event \endparam
        \param int mouseY
        \qmlpcm x of the mouse event \endparam
        \param int wasHeld
        \qmlpcm true Tap is on hold \endparam
  \qmlfn onReleased
  \qmlcm emitted if the area was released.
        \param int mouseX
        \qmlpcm x of the mouse event \endparam
        \param int mouseY
        \qmlpcm x of the mouse event \endparam
        \param int wasHeld
        \qmlpcm true Tap is on hold \endparam

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
    import MeeGo.Labs.Components 0.1

    mouseArea {
      id: mouseArea
      anchors.fill: parent

      onClicked: {
	  aProperty = true
	  aObject.x = mouseX
	  aObject.y = mouseY
      }

      onPressAndHold: {
	  aProperty = false
	  aObject.x = mouseX
	  aObject.y = mouseY
      }
    }
  \endqml
*/
Item {
    id: mouseArea

    property bool enabled: true
    property bool hoverEnabled: false
    property bool isPressed: false

    property int mouseX: 0
    property int mouseY: 0

    signal clicked( variant mouse )
    signal pressed( variant mouse )
    signal doubleClicked( variant mouse )
    signal released( variant mouse )
    signal entered( variant mouse )
    signal exited( variant mouse )
    signal positionChanged( variant mouse )
    signal pressAndHold( variant mouse )

    function setPressed( x, y ) {
        mouseX = x
        mouseY = y
        isPressed = true

        var mouse = gestureMouseEvent.createObject(parent)
        mouse.x = x
        mouse.y = y
        mouse.wasHeld = false
        pressed( mouse )
    }
    function setClicked( x, y ) {
        mouseX = x
        mouseY = y
        isPressed = true
        var mouse = gestureMouseEvent.createObject(parent)
        mouse.x = x
        mouse.y = y
        mouse.wasHeld = false
        clicked( mouse )
    }
    function setDoubleClicked( x, y ) {
        mouseX = x
        mouseY = y
        isPressed = true
        var mouse = gestureMouseEvent.createObject(parent)
        mouse.x = x
        mouse.y = y
        mouse.wasHeld = false
        doubleClicked( mouse )
    }
    function setClickAndHold( x, y ) {
        mouseX = x
        mouseY = y
        isPressed = true
        var mouse = gestureMouseEvent.createObject(parent)
        mouse.x = x
        mouse.y = y
        mouse.wasHeld = true
        pressAndHold( mouse )
    }
    function setReleased( x, y ) {
        mouseX = x
        mouseY = y
        isPressed = false
        var mouse = gestureMouseEvent.createObject(parent)
        mouse.x = x
        mouse.y = y
        mouse.wasHeld = false
        released( mouse )
    }
    function setEnter( x, y ) {
        mouseX = x
        mouseY = y
        if( hoverEnabled ) {
            var mouse = gestureMouseEvent.createObject(parent)
            mouse.x = x
            mouse.y = y
            mouse.wasHeld = false
            entered( mouse )
        }
    }
    function setExit( x, y ) {
        mouseX = x
        mouseY = y
        isPressed = false
        if( hoverEnabled ) {
            var mouse = gestureMouseEvent.createObject(parent)
            mouse.x = x
            mouse.y = y
            mouse.wasHeld = false
            exited( mouse )
        }
    }
    function setPositionChanged( x, y ) {
        mouseX = x
        mouseY = y
        var mouse = gestureMouseEvent.createObject(parent)
        mouse.x = x
        mouse.y = y
        mouse.wasHeld = false
        positionChanged( mouse )
    }

    Component {
        id: gestureMouseEvent;
        GestureMouseEvent {}
    }

    Gesture.GestureArea {
        id: gestureMouseArea
        anchors.fill: parent
        
        Gesture.Tap {
            when: mouseArea.enabled
            onStarted: {
                mouseArea.setEnter( gesture.position.x, gesture.position.y )
                mouseArea.setPressed( gesture.position.x, gesture.position.y )
            }
            onCanceled: {
                mouseArea.setReleased( gesture.position.x, gesture.position.y )
                mouseArea.setExit( gesture.position.x, gesture.position.y )
            }
            onFinished: {
                mouseArea.setClicked( gesture.position.x, gesture.position.y );
                mouseArea.setExit( gesture.position.x, gesture.position.y )
            }
        }

        Gesture.TapAndHold {
            when: mouseArea.enabled
            onStarted: {
                mouseArea.setEnter( gesture.position.x, gesture.position.y )
                mouseArea.setPressed( gesture.position.x, gesture.position.y )
                mouseArea.setClickAndHold( gesture.position.x, gesture.position.y )
            }
            onCanceled: {
                mouseArea.setReleased( gesture.position.x, gesture.position.y )
                mouseArea.setExit( gesture.position.x, gesture.position.y )
            }
            onFinished: {
                mouseArea.setClickAndHold( gesture.position.x, gesture.position.y );
                mouseArea.setExit( gesture.position.x, gesture.position.y )
            }
        }

        Gesture.Pan {
            when: mouseArea.enabled
            onStarted: {
                mouseArea.setEnter( mouseArea.mouseX + gesture.delta.x, mouseArea.mouseY + gesture.delta.y )
            }
            onUpdated: {
                mouseArea.setPositionChanged(  mouseArea.mouseX + gesture.delta.x, mouseArea.mouseY + gesture.delta.y )
            }
            onCanceled: {
                mouseArea.setExit(  mouseArea.mouseX + gesture.delta.x, mouseArea.mouseY + gesture.delta.y  )
            }
            onFinished: {
                mouseArea.setExit(  mouseArea.mouseX + gesture.delta.x, mouseArea.mouseY + gesture.delta.y  )
            }
        }

        Gesture.Pinch {
            when: mouseArea.enabled
            onStarted: {
               //nop
            }
            onCanceled: {
               //nop
            }
            onFinished: {
               //nop
            }
        }

        Gesture.Swipe {
            when: mouseArea.enabled
            onStarted: {
                mouseArea.setEnter()
            }
            onCanceled: {
                mouseArea.setExit( gesture.position.x, gesture.position.y )
            }
            onFinished: {
                mouseArea.setExit( gesture.position.x, gesture.position.y )
            }
        }

    }
}
