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
import MeeGo.Settings 0.1 as Settings

Item {
    id: screensaverItem
    width: parent.width
    height: childrenRect.height

    Settings.BacklightSetting {
        id: backlightSettings
    }

    Column{
        id: screensaverColumn
        anchors.centerIn: parent
        width: childrenRect.width
        spacing: 20

        Row {
            id: enabledRow
            spacing: 20

            Text {
                id: autoText
                text: qsTr("Screen Saver Enabled")
            }

            MeeGo.ToggleButton {
                id: enabledToggle
                on: true
                onToggled: {

                    if (!enabledToggle.on)
                        backlightSettings.screenSaverTimeout = 0
                    else
                        {
                        backlightSettings.screenSaverTimeout = 300
                        screensaverSlider.value = backlightSettings.screenSaverTimeout / 60
                    }
                }
            }
        }

        Column {
            id: sliderColumn
            visible: enabledToggle.on
            height: childrenRect.height

            Item {
                width: childrenRect.width
                height: sliderText.paintedHeight

                Text {
                    id: sliderText
                    text: qsTr("Screen Saver Timeout")
                }

                Text {
                    text: qsTr("%1 Minutes").arg(screensaverSlider.value)
                    anchors.left: sliderText.right
                    anchors.leftMargin: 10
                }
            }

            MeeGo.Slider {
                id: screensaverSlider
                width: 400
                min: 1
                max: 60
                value: 0
                textOverlayVisible: false

                onSliderChanged: {
                    backlightSettings.screenSaverTimeout = screensaverSlider.value * 60
                }
            }

            states: [
                State {
                    name: "visible"

                    PropertyChanges {
                        target: sliderColumn
                        height: childrenRect.height
                        visible: true
                        opacity: 1.0
                    }

                    when: { enabledToggle.on == true }
                },

                State {
                    name: "hidden"

                    PropertyChanges {
                        target: sliderColumn
                        visible: false
                        height: 0
                        opacity: 0
                    }

                    when: { enabledToggle.on == false }
                }
            ]

            transitions: [
                Transition {
                    SequentialAnimation {

                        NumberAnimation {
                            properties: "height"
                            duration: 200
                            easing.type: Easing.InCubic
                        }
                        NumberAnimation {
                            properties: "opacity"
                            duration: 350
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            ]
        }
    }

    Component.onCompleted: {
        enabledToggle.on = backlightSettings.screenSaverTimeout > 0
        screensaverSlider.value = backlightSettings.screenSaverTimeout / 60
    }
}
