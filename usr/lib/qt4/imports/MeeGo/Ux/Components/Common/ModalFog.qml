/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass ModalFog
  \title ModalFog
  \section1 ModalFog
  \qmlcm This is a base qml for modal widgets. It retrieves the TopItem to cover the
         current screen and provides a transparent fog to visually disable the widgets
         in the back. It provides the complete in and out fading as well as the
         basic signals.

  \section2 Important
  \qmlcm The z-value is set to 0 by default and must not be changed. This is important for the stacking of multiple
  overlay items. It will be reset to 0 on each show().

  \section2  API Properties

  \qmlproperty item modalSurface
  \qmlcm this property holds the child widget of the ModalFog e.g. the dialog window

  \qmlproperty bool autoCenter
  \qmlcm centers the content widget. 'anchors.centerIn: parent' has to be set as well in the
  content widget

  \qmlproperty bool fogClickable
  \qmlcm wether the ModalFog closes if the fog was clicked

  \qmlproperty bool fogMaskVisible
  \qmlcm hides the fog, but still maintains a invisible mouse area

  \qmlproperty Item theme
  \qmlcm reveals the theme object to the child widgets

  \qmlproperty int  contentVerticalCenterOffset
  \qmlcm DEPRECATED: corrects the position vertically. This is intended to keep the menubar completely visible.

  \section2 Signal

  \qmlproperty [signal] accepted
  \qmlcm emitted on 'OK' clicked.

  \qmlproperty [signal] rejected
  \qmlcm emitted on 'Cancel' clicked.

  \qmlproperty [signal] showCalled
  \qmlcm notifies the children that the ModalFog is about to show up

  \qmlproperty [signal] fogHideFinished
  \qmlcm DEPRECATED: notifies the children that the ModalFog is hidden

  \qmlproperty [signal] closed
  \qmlcm notifies the children that the ModalFog is hidden

  \section2  Functions

  \qmlfn  show
  \qmlcm fades the ModalFog in

  \qmlfn hide
  \qmlcm fades the ModalFog out

  \section2 Example
  \qmlnone
*/

import Qt 4.7
import MeeGo.Ux.Gestures 0.1
import MeeGo.Ux.Components.Common 0.1

Item {
    id: fogContainer

    // API
    property alias modalSurface : modalSurface.children
    property bool autoCenter: false
    property bool fogClickable: true
    property Item targetContainer: null

    property bool fogMaskVisible: true
    property alias theme: theme

    // general dialog signals
    signal rejected
    signal accepted
    signal showCalled
    signal fogHideFinished
    signal closed

    function show(){
        showCalled()
        visible = true
        fadeIn.running = true
        focus = true
        // This ensures the ModalFog item is always on z = 0. This is very important for stacking of multiple overlay items!
        z = 0
    }

    function hide(){
        fadeOut.running = true
        focus = false
    }

    // this updates the top most item on visibility change
    onVisibleChanged: {
        if (targetContainer != null) {
            // order is extremely important! 1.fog 2.container!
            fog.parent = targetContainer;
            fogContainer.parent = targetContainer;
        } else {
            topItem.calcTopParent()     // force an update to get the current top most item
            // order is extremely important! 1.fog 2.container!
            fog.parent = topItem.topItem;
            fogContainer.parent = topItem.topItem;
        }
        // Note: We want to enable setting the size of dialogs with width and height,
        // but that will change the fogContainers size as well. So fog had to be
        // linked to the top most item directly.
    }

    anchors.centerIn: autoCenter? parent : undefined

    visible: false
    opacity:  0

    TopItem { id: topItem }

    Theme { id: theme }

    Item {
        id: fog
        anchors.fill: parent
        visible: fogContainer.visible

        Rectangle {
            id: grey
            property bool closeOnFogClick: true

            anchors.fill: parent
            color: theme.dialogFogColor

            // to have the same fading as the fogContainer
            opacity: 0.5 * fogContainer.opacity
            visible: fogMaskVisible
        }

        GestureArea {
            id: gestureArea
            anchors.fill: parent
            acceptUnhandledEvents: true
            Tap {
                onFinished: {
                    if(fogContainer.fogClickable){
                        fogContainer.hide()
                        fogContainer.rejected()
                    }
                }
            }
        }
    }

    // this item only sets up an orientation point for the content.
    // if autoCenter is off, origin is up left, otherwise it's centered.
    // This would be much better if the modalsurface could adjust to its child size...
    // but none of the usual ways work.
    Item {
        id: modalSurface

        anchors.centerIn: autoCenter ? fog : undefined

        width: fogContainer.width
        height:  fogContainer.height

        Component.onCompleted:{
            if( !autoCenter ){
                x = 0
                y = 0
            }
        }
    }

    PropertyAnimation{
        id: fadeOut

        running:  false
        target: fogContainer
        property: "opacity"
        from: 1
        to: 0
        duration: theme.dialogAnimationDuration

        onCompleted: {
            visible = false
            fogContainer.fogHideFinished()
            fogContainer.closed()
        }
    }

    PropertyAnimation{
        id: fadeIn

        running:  false
        target: fogContainer
        property: "opacity"
        from: 0
        to: 1
        duration: theme.dialogAnimationDuration
    }
}

