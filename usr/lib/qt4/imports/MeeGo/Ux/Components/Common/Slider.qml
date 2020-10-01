/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass Slider
  \title Slider
  \section1 Slider

  Displays a slider which can be used as input element. For example a volume control. The slider
  also has a progess bar.

  \section2 API properties
    \qmlproperty int min
    \qmlcm minimum value of the slider
    
    \qmlproperty int max
    \qmlcm maximum value of the slider
    
    \qmlproperty int value
    \qmlcm current value of the slider

    \qmlproperty bool pressed
    \qmlcm signals if the slider is pressed or tapped

    \qmlproperty real percentage
    \qmlcm used to calculate the width of the progress bar
    
    \qmlproperty bool textOverlayVertical
    \qmlcm used to check if the textoverlay needs to be laid out vertically or horizontally

    \qmlproperty bool textOverlayVisible
    \qmlcm makes the text overlay visible or invisible.

    \qmlproperty bool textOverlayAlwaysVisible
    \qmlcm makes the text overlay always visible if set to true, textOverlayVisible is then
    ignored. If set to false it will behave as textOverlayVisible dictates.

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
    Slider {
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
        centerItem.x = ((value - min) / (max - min)) * (fillArea.width - container.height / 4)
    }

    width: 200
    height: 40

    onWidthChanged: {
        if(value < min)
            value = min
        if(value > max)
            value = max
        centerItem.x = ((value - min) / (max - min)) * (fillArea.width - container.height / 4)

    }

    Component.onCompleted: {
        if(value < min)
            value = min
        if(value > max)
            value = max
        centerItem.x = ((value - min) / (max - min)) * (fillArea.width - container.height / 4)
    }

    ThemeImage {
        id: fillArea

        function setPosition( val ) {
            var clamped = val
            if( clamped < 0 ) {
                clamped = 0
            }
            if( clamped > fillArea.width ) {
                clamped = fillArea.width
            }
            value = min + ( clamped / fillArea.width ) * ( max - min )
            container.sliderChanged( value )
        }

        source: "image://themedimage/widgets/common/slider/slider-background"
        border.left:  6
        border.right: 6
        anchors.left: parent.left
        anchors.leftMargin: marker.width / 2 - centerItem.width / 2 //4
        anchors.right: parent.right
        anchors.rightMargin: marker.width / 2 - centerItem.width / 2 //4
        anchors.verticalCenter: parent.verticalCenter

        ThemeImage {
            id: progressBar

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            opacity: 0.5

            width: if( percentage < border.left + border.right ) {
                       return border.left + border.right
                   }else if( percentage > 100 ) {
                       return parent.width
                   }else {
                       return parent.width * percentage / 100
                   }

            border.left: 6
            border.right: 6
            source: "image://themedimage/widgets/common/slider/slider-bar"
        }

        //bar growing/shrinking with the marker to hightlight the range selected by the slider
        ThemeImage {
            id: sliderFill

            border.left: 6
            border.right: 6
            source: "image://themedimage/widgets/common/slider/slider-bar"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: marker.x + marker.width * 0.5
        }

        Item {
            id: centerItem

            width: parent.height
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
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

            anchors { bottom: marker.top; bottomMargin: 5; horizontalCenter: marker.horizontalCenter }
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
                text: value
            }
        }
    }

    GestureArea {
        id: gestureArea

        property int newPosition: 0
        property int startX: 0
        property bool slide: false
        property int markerOffset: 0
        property int markerLeft: marker.x + fillArea.anchors.leftMargin
        property int markerRight: markerLeft + marker.width
        property int markerCenter: markerLeft + marker.width / 2

        anchors.fill: parent

        Tap {
            onStarted:{
                gestureArea.startX = gesture.position.x
            }

            onFinished: {
                fillArea.setPosition( gestureArea.startX - fillArea.anchors.leftMargin )
            }
        }

        Pan {
            onStarted: {
                if( gestureArea.startX >= gestureArea.markerLeft && gestureArea.startX <= gestureArea.markerRight ) {
                    container.pressed = true
                    gestureArea.markerOffset = - ( gestureArea.startX - gestureArea.markerCenter )
                    gestureArea.slide = true
                }
            }
            onUpdated: {
                if( gestureArea.slide ) {
                    gestureArea.newPosition = gestureArea.startX + gesture.offset.x + gestureArea.markerOffset - fillArea.anchors.leftMargin;
                    fillArea.setPosition( gestureArea.newPosition )
                }
            }
            onFinished: {
                if( gestureArea.slide ) {
                    gestureArea.newPosition = gestureArea.startX + gesture.offset.x + gestureArea.markerOffset - fillArea.anchors.leftMargin;
                    fillArea.setPosition( gestureArea.newPosition )
                }
                container.pressed = false
                gestureArea.slide = false
            }
            onCanceled: {
                if( gestureArea.slide ) {
                    gestureArea.newPosition = gestureArea.startX + gesture.offset.x + gestureArea.markerOffset - fillArea.anchors.leftMargin;
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
