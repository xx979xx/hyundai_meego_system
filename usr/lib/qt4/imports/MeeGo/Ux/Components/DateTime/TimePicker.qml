/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass TimePicker
  \title TimePicker
  \section1 TimePicker

  Offers controls to select time by hours and minutes. 12 and 24
  hours systems supported. If OK is clicked, the selected hours
  and minutes are stored and can be accessed through the properties.

  \section2  API properties
  \qmlproperty int hours
  \qmlcm Starting hours (input) and selected hours (output).
         This value is from 0-23, regardless of the value of hr24

  \qmlproperty int minutes
  \qmlcm  Starting minutes (input) and selected minutes (output)

  \qmlproperty string time
  \qmlcm contains the current hours and minutes separated by a colon
         and optionally followed by a "AM/PM" designation.  This property is
         only valid once a time has been picked

  \qmlproperty bool hr24
  \qmlcm set to true if 24 hour system should be used.  Default is false (12 hr am/pm)

  \qmlproperty int minutesIncrement

  \qmlcm sets the step width used to select minutes.  Default is 1

  \section2  Signals
  \qmlnone

  \section2 Functions
  \qmlnone

  \section2  Example
  \qml
      //a button labeled with the selected time
      Button {
          id: timeButton

          text: timePicker.time

          TimePicker {
              id: timePicker

              hr24: true
          }

          onClicked: {
              timePicker.show()
          }
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

ModalDialog {
    id: timePicker

    property bool hr24: false
    property int minutesIncrement: 1

    property int hours: 0
    property int minutes: 0
    property string time: ""

    title: qsTr("Pick a time")
    alignTitleCenter: true

    buttonWidth: tPicker.width / 2.5
    height: tPicker.height + decorationHeight
    width: tPicker.width

    // Input "use24" is true if displaying 24 hour time; "h" is from 0-23.
    // Return is 1-12.
    function toDisplayHours (use24, h) {
        if (use24) return h
        else if (h <= 0) return 12
        else if (h <= 12) return h
        else return (h - 12)
    }

    // Input "use24" is true if displaying 24 hour time; "h" is from 1-12; "am" is true if ante-meridian.
    // Return is 0-23.
    function fromDisplayHours (use24, h, am) {
        if (use24) return h
        else if (12 == h) return am?0:12
        else if (am) return h
        else return (h + 12)%24
    }

    //if hours is changed, check if the new value is within the allowed boundaries to catch wrong input
    onHoursChanged: {
        hours %= 24
        ampmToggleBox.on = (hours < 12)
        hourSpinner.setValue( toDisplayHours(hr24, hours))
    }

    //if minutes is changed, check if the new value is within the allowed boundaries to catch wrong input
    onMinutesChanged: {
        minutes %= 60
        minutesSpinner.setValue( minutes )
    }

    //on a switch between the 12 and 24 hour systems, some special cases have to be caught
    onHr24Changed: {
        if( hr24 ){ //switched from 12 to 24 hour system
            hourSpinner.min = 0
            hourSpinner.count = 24
        } else { //switched from 24 to 12 hour system
            hourSpinner.min = 1
            hourSpinner.count = 12
        }
        hourSpinner.setValue( toDisplayHours(hr24, hours))
    }

    onShowCalled:  {
        hourSpinner.setValue( toDisplayHours(hr24, hours))
        minutesSpinner.setValue( minutes )
    }

    // if ok button is clicked, store the selected time
    onAccepted:  {
        minutes = minutesSpinner.value
        var displayMinutes = ( minutes < 10 ? "0" : "" ) + minutes

        time = qsTr("%1:%2 %3").arg(hourSpinner.value).arg(displayMinutes).arg((hr24 ? "" : ampmToggleBox.label))

        hours = fromDisplayHours(hr24, hourSpinner.value, ampmToggleBox.on)
    }

    content: Item {
        id: tPicker

        clip: true
        width: 300
        height:  spinnerBox.height + ( hr24 ? 0 : ampmToggleBox.height )
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }

        Theme { id: theme }

        Item {
            id: spinnerBox

            anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
            height: 130
            width : tPicker.width

            Item {
                id: innerBox

                anchors.centerIn: parent
                height: spinnerBox.height
                width: spinnerBox.width - 20

                // spinner to select hours
                TimeSpinner {
                    id: hourSpinner

                    height: spinnerBox.height - anchors.bottomMargin - anchors.topMargin
                    incr: 1
                    pad: false
                    anchors { 
                        left: parent.left; right: parent.horizontalCenter; top: parent.top; bottom: parent.bottom;
                        leftMargin: 14; rightMargin: 14; topMargin: 14; bottomMargin: hr24 ? 14 : 0;
                    }
                } // hourSpinner

                // a colon between the spinners makes it look more like a time selector
                Item {
                    id: colonBox

                    height: spinnerBox.height
                    anchors.left: hourSpinner.right
                    anchors.right: minutesSpinner.left

                    Text {
                        id: colon

                        text: ":"
                        anchors.centerIn: parent
                        color: theme.fontColorNormal
                        font.pixelSize: theme.fontPixelSizeLargest3
                    }//colon
                }

                // spinner to select minutes
                TimeSpinner {
                    id: minutesSpinner

                    min: 0
                    incr: minutesIncrement
                    count: 60 / incr
                    pad: true
                    anchors { left: parent.horizontalCenter; right: parent.right; top: parent.top; bottom: parent.bottom;
                        leftMargin: 14; rightMargin: 14; topMargin: 14; bottomMargin: hr24 ? 14 : 0;
                    }
                } // minutesSpinner
            } // innerBox
        } // spinnerBox

        // used to choose between AM or PM time, if 12 hour system is active
        Item {
            id: ampmToggleBox
            property string label: (ampmToggle.on ? ampmToggle.onLabel : ampmToggle.offLabel);
            property alias on: ampmToggle.on

            anchors.top: spinnerBox.bottom
            width: tPicker.width
            height: ampmToggle.height + 28

            ToggleButton {
                id: ampmToggle

                visible: !hr24
                onLabel: qsTr("AM")
                offLabel: qsTr("PM")
                anchors.centerIn: parent

                on: (timePicker.hours < 12)

            }// ampmToggleBox
        }// ampmToggleBox
    }// timePicker

    TopItem { id: topItem }
}

