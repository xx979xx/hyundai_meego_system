/*
* Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1 as MeeGo
import MeeGo.Connman 0.1

Item {
    id: page
    width: parent.width
    height: timeDateItem.height

    Labs.TimezoneListModel {
        id: timezoneListModel
    }

    ClockModel {
        id: clockModel
    }

    Column {
        id: timeDateItem
        width: parent.width

        Image {
            id: whatTimeisItLabel
            width: parent.width
            source: "image://theme/settings/subheader"

            Text{
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: qsTr("What time it is");
                font.pixelSize: theme_fontPixelSizeLarge
                height: parent.height
                width: parent.width
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }

        Image {
            id: dateLabel
            source: "image://theme/pulldown_box"
            width: parent.width
            Text {
                id: dateLabelText
                text: clockModel.currentDate()
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 2
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: theme_fontPixelSizeLarge
                height: 100
                width: parent.width
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var coords = mapToItem(page.parent,mouseX,mouseY)
                    datePicker.show(coords.x,coords.y);
                }
            }
        }

        Image {
            id: timeLabel
            source: "image://theme/pulldown_box"
            width: parent.width

            Text {
                id: timeLabelText
                anchors.left: parent.left
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignVCenter
                text: clockModel.currentTime()
                font.pixelSize: theme_fontPixelSizeLarge
                height: parent.height
                width: parent.width - 10
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var coords = mapToItem(page.parent,mouseX,mouseY);
                    var date = new Date;
                    timePicker.hr24 = true
                    timePicker.hours = date.getHours();
                    timePicker.minutes = date.getMinutes();
                    timePicker.show(coords.x,coords.y);
                }
            }
        }

        Image {
            id: twelveHourToggle
            source: "image://theme/pulldown_box"
            width: parent.width

            Text {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: qsTr("24 hour clock")
                width: 100
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }

            MeeGo.ToggleButton {
                id: twentyfourhrtoggle
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                on: true //FIXME
                onToggled: {
                    //FIXME
                    //timeSettings.flag24 = twentyfourhrtoggle.on
                    //timeTimer.interval = 1000
                }
            }
        }

        Image {
            id: automagicTimeToggle
            source: "image://theme/pulldown_box"
            width: parent.width

            Text {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: qsTr("Set date and time automatically")
                width: 100
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }

            MeeGo.ToggleButton {
                id: autoTimeToggle
                on: clockModel.timeUpdates == "auto"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10

                onToggled: {
                    if (on)
                        clockModel.timeUpdates == "auto"
                    else
                        clockModel.timeUpdates == "manual"
                }
            }
        }


        Image {
            id: whereAreYouLabel
            width: parent.width
            source: "image://theme/settings/subheader"

            Text{
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: qsTr("Where you are");
                font.pixelSize: theme_fontPixelSizeLarge
                height: parent.height
                width: parent.width
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }

        Image {
            id: currentTz
            source: "image://theme/pulldown_box"
            width: parent.width

            Text {
                id: currentTzText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 10
		text: qsTr("Current Time Zone is %1").arg(clockModel.timezone)
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }

        Image {
            id: findMeToggle
            source: "image://theme/pulldown_box"
            width: parent.width

            Text {
                id: findMeText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: qsTr("Find me and keep my location updated")
                width: parent.width
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }

            MeeGo.ToggleButton {
                id: findMeToggleButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                on: clockModel.timezoneUpdates == "auto"
                onToggled: {
                    if (on)
                        clockModel.timezoneUpdates == "auto";
                    else
                        clockModel.timezoneUpdates == "manual";
                    currentTzText.text = qsTr("Current Time Zone is %1").arg(clockModel.timezone);
                }

                Connections {
                    target: clockModel
                    onTimezoneUpdatesChanged: {
                        findMeToggleButton.on = (clockModel.timezoneUpdates == "auto");
                    }
                }

            }
        }

        Image {
            id: manualTimezoneLabel
            width: parent.width
            source: "image://theme/settings/subheader"
            //visible: !findMeToggleButton.on
            Text{
                id: manualTimezoneLabelText
                anchors.left: parent.left
                anchors.leftMargin: 10
		text: qsTr("Manual Time Zone Selection");
                font.pixelSize: theme_fontPixelSizeLarge
                font.bold: true
                height: parent.height
                width: parent.width
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            MeeGo.Button {
                id: setTimeZoneButton
                height: 40
                // width: 180
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                //active: !findMeToggleButton.on
                //bgSourceUp: "image://theme/btn_blue_up"
                //bgSourceDn: "image://theme/btn_blue_dn"
                text: qsTr("Set Time Zone")
                //font.pixelSize: theme_fontSizeLargest
                //color: theme_buttonFontColor
                //visible: !findMeToggleButton.on

                onClicked: {
                    timezoneSelectLoader.source = "SetTimezoneMenu.qml"
                }

                Connections {
                    target: timezoneSelectLoader.item
                    onTriggered: {
                        clockModel.timezone = newTzTitle;
                        currentTzText.text = qsTr("Current Time Zone is ").arg(clockModel.timezone);
                        timeTimer.interval = 2000;
                        findMeToggleButton.on = (clockModel.timezoneUpdates == "auto");
                    }

                    onClose: {
                        timezoneSelectLoader.sourceComponent = undefined
                    }
                }
            }
        }
    }

    Timer {
        id: timeTimer
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            dateLabelText.text = clockModel.currentDate()
            timeLabelText.text = clockModel.currentTime();

            if(timeTimer.interval != 60000)
                timeTimer.interval = 60000
        }
    }

    MeeGo.TimePicker {
        id: timePicker
        parent: scene.container
        onAccepted: {
            var time = clockModel.time(timePicker.hours, timePicker.minutes);
            clockModel.setTime(time);
            autoTimeToggle.on = (clockModel.timeUpdates == "auto")
            timeTimer.interval = 1000
        }
    }

    MeeGo.DatePicker{
        id: datePicker
        parent: scene.container
        minYear: 1970
        onDateSelected: {
            clockModel.setDate(date);
            timeTimer.interval = 1000
        }
    }

    Loader {
        id: timezoneSelectLoader
        anchors.fill: parent
        width: parent.width
        height: parent.height
    }

}
