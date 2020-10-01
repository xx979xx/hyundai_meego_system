/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass BottomToolBar
  \title BottomToolBar
  \section1 BottomToolBar
  \qmlcm This is a generic BottomToolBar.

  \section2  API Properties

  \qmlproperty item content
  \qmlcm this property holds the child widget of the BottomToolBar,
  most likely a BottomToolBarRow.

  \section2 Signal

  \qmlproperty [signal] active
  \qmlcm emitted on fully visibility

  \qmlproperty [signal] inactive
  \qmlcm emitted on completly hidden toolbar
  
  \section2  Functions

  \qmlfn show
  \qmlcm fades the BottomToolBar in

  \qmlfn hide
  \qmlcm fades the BottomToolBar out

  \section2 Example
  \qml
  
  \endqml

*/

import Qt 4.7

Item {
    id : bottomToolBar

    // API
    property alias content: bottomToolBarSurface.children

    signal active
    signal inactive

    function show(){
        visible = true

        background.extend = true
        focus = true
    }

    function hide(){
        background.opened = false
        background.extend = false
        focus = false
    }

    anchors.left: parent.left
    anchors.right: parent.right
    y: (background.extend) ? parent.height - height : parent.height
    clip: true
    height: 64
    visible: false

    Behavior on y {
        PropertyAnimation {
            easing.type: Easing.InOutQuad
            duration: (background.opened) ? 0 : theme.dialogAnimationDuration
        }
    }

    onYChanged: {
        if(bottomToolBar.visible){
            if( bottomToolBar.y == parent.height ){
                visible = false
                inactive()
            }
            else if( bottomToolBar.y == parent.height - height ){
                active()
                background.opened = true
            }
        }
    }

    Theme { id: theme }

    ThemeImage {
        id: background

        property bool extend: false   // hidden from extern
        property bool opened: false

        anchors.fill: parent
        source: "image://themedimage/widgets/common/action-bar/action-bar-background"
        opacity: 1
    }

    // this item only sets up an orientation point for the content.
    // if autoCenter is off, origin is up left, otherwise it's centered.
    // This would be much better if the bottomToolBarSurface could adjust to its child size...
    // but none of the usual ways work.
    Item {
        id: bottomToolBarSurface
        anchors.fill: parent
    }
}

