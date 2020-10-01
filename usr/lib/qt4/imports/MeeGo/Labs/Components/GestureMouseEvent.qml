import Qt 4.7
import MeeGo.Ux.Gestures 0.1

/*!
   \qmlclass GestureMouseEvent
   \title GestureMouseEvent
   \section1 GestureMouseEvent
         This is a transition component for mouse events from GestureMouseArea.

  \section2 API Properties

  \qmlproperty bool accepted
  \qmlcm 

  \qmlproperty int button
  \qmlcm 

  \qmlproperty int buttons
  \qmlcm the current mouseY value

  \qmlproperty int modifiers
  \qmlcm

  \qmlproperty bool wasHeld
  \qmlcm 
  
  \qmlproperty int x
  \qmlcm

  \qmlproperty int y
  \qmlcm
*/

QtObject 
{
  property bool accepted:true
  property int button: Qt.LeftButton
  property int buttons: Qt.LeftButton
  property int modifiers: Qt.NoModifier
  property bool wasHeld: false
  property int x: 0
  property int y: 0
}
