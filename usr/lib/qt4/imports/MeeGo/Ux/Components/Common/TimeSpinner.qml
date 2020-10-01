/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass TimeSpinner
  \title TimeSpinner
  \section1 TimeSpinner

  The TimeSpinner uses a path view to display a circular list which displays
  a range of numbers. Per default the TimeSpinner displays the numbers 1 to 12
  to let the user pick an hour, but given the appropriate values it can display
  any range.

  \section2  API properties
  \qmlproperty int min
  \qmlcm offset used to simulate that the numbers in the path view begin with a certain number instead of zero

  \qmlproperty int incr
  \qmlcm sets the step width used to display only certain numbers in the path view

  \qmlproperty int count
  \qmlcm sets the count of numbers in the path view.

  \qmlproperty int value
  \qmlcm contains the currently displayed number

  \qmlproperty bool pad
  \qmlcm if true, numbers containing only a single digit get a zero as prefix. Since the TimeSpinner was
         designed to display hours or minutes, there is no padding to match three or more digits.

  \section2  Signals
  \qmlnone

  \section2  Functions
  \qmlfn displayValue
  \qmlcm calculates a displayed number by combining the index with the incr property and the min property.
         This function is meant for internal use only.
        \param int index
        \qmlcm the index of the number to be calculated. \endparam
        \retval int
        \qmlcm the calculated number \endretval

  \qmlfn setValue
  \qmlcm sets the path view to display the entry which contains the given number by calculating it's index
         and setting it as the current index.
        \param int newValue
        \qmlcm the entry to be displayed. \endparam

  \section2  Example
  \qml
  //a TimeSpinner to select minutes
  TimeSpinner {
      id: minutesSpinner

      //set the spinner to display the numbers 0 to 59
      min: 0
      count: 60

      //use padding to display 0,...,9 as 00,...,09
      pad: true

      anchors.fill: parent
  }
  \endqml
*/

import Qt 4.7
import MeeGo.Ux.Gestures 0.1

Rectangle {
    id: outer

    property int min: 1
    property int incr: 1
    property int count: 12
    property int value: ( tsview.currentIndex * incr ) + min
    property bool pad: false

    function displayValue(index) {
        var n = (index * incr) + min

        if (pad && n < 10)
            return "0" + n
        else
            return n
    }

    function setValue( newValue ) {
        tsview.currentIndex = ( newValue - min) / incr
    }

    Theme { id: theme }

    Component {
        id: tsdelegate

        Text {
            id: delegateText

            font.pixelSize: if( theme.fontPixelSizeNormal < height - 4 ) {
                                return theme.fontPixelSizeLarge
                            }else{
                                return height - 4
                            }
            text: displayValue(index)
            height: timeSpinner.itemHeight //font.pixelSize + 10
            color: "#A0A0A0"
            verticalAlignment: "AlignVCenter"

            GestureArea {
                id: delegateArea

                height:  parent.height
                width:  timeSpinner.width
                anchors.centerIn: parent

                Tap {
                    onStarted:  {
                        tsview.currentIndex = index
                    }
                }
            }

            states: [
                State {
                    name: "active"
                    when:  text == ( tsview.currentIndex * incr ) + min
                    PropertyChanges { target: delegateText; font.bold: true; color: theme.fontColorNormal; font.pixelSize: theme.fontPixelSizeLargest3;height:60}
                }
            ]
        }
    }

    Item {
        id: timeSpinner

        property real itemHeight: height / ( tsview.pathItemCount + 1 ) //30

        clip: true
        anchors.fill: parent
        focus: true

        ThemeImage {
            id: bgImage

            source: "image://themedimage/images/pickers/timespinbg"
            anchors.fill: parent
            opacity: 0.5
        }

        GestureArea {
            id: blocker
            anchors.fill: timeSpinner
            acceptUnhandledEvents: true
            Tap{}
            TapAndHold{}
            Pan{}
        }

        PathView {
            id: tsview

            anchors.fill: timeSpinner

            model: outer.count
            delegate: tsdelegate
            path:  Path {
                startX: tsview.width / 2
                startY: 0 //5
                PathLine {
                    x: tsview.width / 2
                    y: tsview.height
                }
            }

            pathItemCount: 3
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5

            dragMargin: tsview.width/2

            BorderImage {
                id: innerBgImage

                source: "image://themedimage/images/pickers/timespinhi"
                anchors.fill: parent
                opacity:0.25
            }
        }
    }

    MouseArea {
        id: flickableArea

        property int firstY: 0

        anchors.fill: parent

        onPressed: {
            firstY = mouseY;
        }

        //react on vertical mouse movement to flick the path view
        onMousePositionChanged: {
            if( flickableArea.pressed ) {
                if( mouseY - firstY > 20 ) {
                    firstY = mouseY;
                    tsview.decrementCurrentIndex();
                }else if( mouseY - firstY < -20 ) {
                    firstY = mouseY;
                    tsview.incrementCurrentIndex();
                }
            }
        }
    }
}

