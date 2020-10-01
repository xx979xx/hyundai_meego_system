/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass BottomToolBar
  \title BottomToolbar
  \section1 BottomToolbar
  \qmlcm This is a base qml for bottomToolBard widgets.

  \section2  API Properties

  \qmlproperty item contents
  \qmlcm this property holds the child widget of the BottomToolBar, most likely a BottomToolBarRow

  \qmlproperty bool fogClickable
  \qmlcm wether the ModalFog closes if the fog was clicked

  \qmlproperty bool fogMaskVisible
  \qmlcm hides the fog, but still maintains a invisible mouse area

  \section2 Signal

  \qmlproperty [signal] visible
  \qmlcm emitted on fully visibility

  \qmlproperty [signal] hidden
  \qmlcm emitted on completly hidden toolbar

  \qmlproperty [signal] showCalled
  \qmlcm notifies the children that the BottomToolBar is about to show

  \section2  Functions

  \qmlfn  show
  \qmlcm fades the BottomToolBar in

  \qmlfn hide
  \qmlcm fades the BottomToolBar out

  \section2 Example
  \qml

  \endqml
*/

import Qt 4.7

Item {
    id : bottomToolBarRow

    // API
    property alias leftContent: contentLeft.children
    property alias centerContent: contentCenter.children
    property alias rightContent: contentRight.children

    property int contentVerticalMargins: 5
    property int contentHorizontalMargins: 5
    property int spacing: 2

    anchors.fill: parent

    Row {
        id: contentLeft

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors {
            leftMargin: contentHorizontalMargins; rightMargin: contentHorizontalMargins;
            topMargin: contentVerticalMargins; bottomMargin: contentVerticalMargins
        }
        spacing: spacing

        visible: parent.visible
        opacity: visible ? 1 : 0    // force repaint
    }
    Row {
        id: contentCenter

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors {
            leftMargin: contentHorizontalMargins; rightMargin: contentHorizontalMargins;
            topMargin: contentVerticalMargins; bottomMargin: contentVerticalMargins
        }
        spacing: spacing

        visible: parent.visible
        opacity: visible ? 1 : 0    // force repaint
    }
    Row {
        id: contentRight

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors {
            leftMargin: contentHorizontalMargins; rightMargin: contentHorizontalMargins;
            topMargin: contentVerticalMargins; bottomMargin: contentVerticalMargins
        }
        spacing: spacing

        visible: parent.visible
        opacity: visible ? 1 : 0    // force repaint
    }
}

