/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass VerticalSlider
  \title VerticalSlider
  \section1 VerticalSlider

  Displays a slider which can be used as input element. For example a volume control. The slider
  also has a progess bar.

  \section2 API properties
    \qmlproperty int min
    \qmlcm minimum value of the slider

    \qmlproperty int max
    \qmlcm maximum value of the slider

    \qmlproperty int value
    \qmlcm current value ot the slider

    \qmlproperty real percentage
    \qmlcm used to calculate the width of the progress bar

    \qmlproperty bool textOverlayVertical
    \qmlcm used to check if the textoverlay needs to be laid out vertically or horizontally

    \qmlproperty bool textOverlayVisible
    \qmlcm makes te text overlay visible or invisible.

    \qmlproperty alias markerSize
    \qmlcm sets the width and height of the position marker. Default value is the size of
           the image used for the marker.

  \section2 Signals
    \qmlproperty [signal] sliderChanged
    \qmlcm is emitted when the value of the sliders changed
        \param int value
        \qmlpcm the new value \endparam

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
    VerticalSlider {
        id: mySlider

        min: 0
        max: 100
        value: 50

    }
  \endqml

*/

import Qt 4.7
import MeeGo.Ux.Gestures 0.1
import MeeGo.Ux.Components.Common 0.1

Item {
    id: container

    property int min: 0
    property int max: 100
    property int value: 0
    property real percentage: 0
    property bool textOverlayVertical: false
    property bool textOverlayVisible: true
    property bool textOverlayAlwaysVisible: false
    property alias markerSize: marker.width
    property bool pressed: false

    signal sliderChanged(int sliderValue)

    onValueChanged: {
        if(value < min)
            value = min
        if(value > max)
            value = max

        centerItem.y = (( ( max - value ) - min) / (max - min)) * (fillArea.height - container.width / 4)
    }

    width: 40
    height: 200

    onHeightChanged: {
        if(value < min)
            value = min
        if(value > max)
            value = max

        centerItem.y = ((value - min) / (max - min)) * (fillArea.height - container.width / 4)
    }


    ThemeImage {
        id: fillArea

        function setPosition( val ) {
            var clamped = val
            if( clamped < 0 ) {
                clamped = 0
            }
            if( clamped > fillArea.height ) {
                clamped = fillArea.height
            }
            value =  min + ( ( fillArea.height - clamped ) / fillArea.height ) * ( max - min )
            container.sliderChanged( value )
        }

        source: "image://themedimage/widgets/common/slider/slider-background-vertical"

        anchors.bottom: parent.bottom
        anchors.bottomMargin: marker.height / 2
        anchors.top: parent.top
        anchors.topMargin: marker.height / 2
        anchors.horizontalCenter: parent.horizontalCenter

        ThemeImage {
            id: progressBar

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            height: if( percentage < border.bottom + border.top ) {
                       return border.bottom + border.top
                   }else if( percentage > 100 ) {
                       return parent.height
                   }else {
                       return parent.height * percentage / 100
                   }

            source: "image://themedimage/widgets/common/slider/slider-bar-vertical"
            opacity: 0.5
        }

        //bar growing/shrinking with the marker to hightlight the range selected by the slider
        ThemeImage {
            id: sliderFill

            source: "image://themedimage/widgets/common/slider/slider-bar-vertical"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: centerItem.bottom
        }

        Item {
            id: centerItem

            y: parent.height - height
            width: parent.width
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //marks the actual position on the slider
        Image {
            id: marker

            anchors.centerIn: centerItem
            source: "image://themedimage/widgets/common/slider/slider-handle"
            width: sourceSize.width
            height: width
            smooth: true
        }

        //shows the selected value while the slider is dragged or clicked
        Item {
            id: textoverlay

            anchors { right: marker.left; rightMargin: 5; verticalCenter: marker.verticalCenter }
            width: overlaytext.width * 1.25
            height: overlaytext.height * 1.25
            visible: textOverlayAlwaysVisible
            opacity: (textOverlayVisible || textOverlayAlwaysVisible) ? 1 : 0 // Workaround: setting visible to textOverlayVisible in state has repaints issues

            rotation: container.textOverlayVertical? 90 : 0

            Rectangle {
                id: overlaybackground

                radius: container.textOverlayVertical ? height * 0.25 : width * 0.25
                anchors.fill: parent
                color: "#68838B"
            }

            Text {
                id: overlaytext

                anchors.centerIn: overlaybackground
                text: container.value
            }
        }
    }

    GestureArea {
        id: gestureArea

        property int newPosition: 0
        property int startY: 0
        property bool slide: false
        property int markerOffset: 0
        property int markerTop: marker.y + fillArea.anchors.topMargin
        property int markerBottom: markerTop + marker.height
        property int markerCenter: markerTop + marker.height / 2

        anchors.fill: parent

        Tap {
            onStarted:{
                gestureArea.startY = gesture.position.y
            }

            onFinished: {
                fillArea.setPosition( gestureArea.startY - fillArea.anchors.topMargin )
            }
        }

        Pan {
            onStarted: {
                if( gestureArea.startY >= gestureArea.markerTop && gestureArea.startY <= gestureArea.markerBottom ) {
                    container.pressed = true
                    gestureArea.markerOffset = - ( gestureArea.startY - gestureArea.markerCenter )
                    gestureArea.slide = true
                }
            }
            onUpdated: {
                if( gestureArea.slide ) {
                    gestureArea.newPosition = gestureArea.startY + gesture.offset.y + gestureArea.markerOffset - fillArea.anchors.topMargin;
                    fillArea.setPosition( gestureArea.newPosition )
                }
            }
            onFinished: {
                if( gestureArea.slide ) {
                    gestureArea.newPosition = gestureArea.startY + gesture.offset.y + gestureArea.markerOffset - fillArea.anchors.topMargin;
                    fillArea.setPosition( gestureArea.newPosition )
                }
                container.pressed = false
                gestureArea.slide = false
            }
            onCanceled: {
                if( gestureArea.slide ) {
                    gestureArea.newPosition = gestureArea.startY + gesture.offset.y + gestureArea.markerOffset - fillArea.anchors.topMargin;
                    fillArea.setPosition( gestureArea.newPosition )
                }
                container.pressed = false
                gestureArea.slide = false
            }
        }
    }


    states: [
        State {
            name: "marker"
            PropertyChanges {
                target: textoverlay
                visible: true
            }
            when: container.pressed
        }
    ]
}
