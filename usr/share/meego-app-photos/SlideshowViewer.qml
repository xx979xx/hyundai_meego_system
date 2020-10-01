/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Media 0.1

Rectangle {
    id: slideshowViewer

    // public properties
    property variant model
    property int currentIndex: 0
    property alias delayMS: timer.interval
    property bool loop: false

    function stop() {
        timer.stop()
        slideshowStopped(currentIndex)
    }

    anchors.fill: parent
    color: "black"
    visible: false

    // "private" properties
    property bool init: true
    property bool first: false
    property bool halt: false
    property bool loopOnce: false

    signal slideshowStopped(int aFinalIndex)

    function loadImage(imageLoader) {
        imageLoader.sourceComponent = undefined
        var newIndex = currentIndex + 1
        if (newIndex >= model.count) {
            if (loop || loopOnce) {
                newIndex = 0
                currentIndex = -1
                loopOnce = false
            }
            else {
                halt = true
                return
            }
        }

        stricturl.setUrlUnencoded(model.getURIfromIndex(newIndex))
        imageLoader.sourceComponent = imageComponent
        imageLoader.item.source = stricturl.url
    }

    Component.onCompleted: {
        stricturl.setUrlUnencoded(model.getURIfromIndex(currentIndex))
        firstImageLoader.sourceComponent = imageComponent
        firstImageLoader.item.source = stricturl.url
        if (currentIndex + 1 >= model.count) {
            // if we start on the last image, loop to first once
            loopOnce = true
        }
        first = true
    }

    Component.onDestruction: {
        window.inhibitScreenSaver = false
    }

    Labs.StrictUrl {
        id: stricturl
    }

    Connections {
        target: window
        onIsActiveWindowChanged: {
            if (!window.isActiveWindow) {
                timer.pause()
            }
            else {
                timer.unpause()
            }
        }
    }

    Timer {
        id: timer
        interval: 3000
        repeat: true
        property int pauseCount: 0

        property bool paused: false

        function pause() {
            pauseCount++
            if (pauseCount == 1) {
                stop()
            }
        }

        function unpause() {
            pauseCount--
            if (pauseCount == 0) {
                start()
            }
        }

        onRunningChanged: {
            window.inhibitScreenSaver = running
        }

        onTriggered: {
            var count = model.count
            if (halt) {
                stop()
                slideshowStopped(currentIndex)
                return
            }

            var nextLoader
            if (first) {
                nextLoader = secondImageLoader
            }
            else {
                nextLoader = firstImageLoader
            }

            if (nextLoader.item.status == Image.Loading) {
                nextLoader.item.waiting = true
                pause()
                return
            }

            currentIndex++
            first = !first
        }
    }

    Loader {
        id: firstImageLoader
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }

    Loader {
        id: secondImageLoader
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }

    Component {
        id: imageComponent
        LimitedImage {
            opacity: 0
            visible: opacity != 0
            property bool waiting: false

            onStatusChanged: {
                if (init && status == Image.Ready) {
                    slideshowViewer.visible = true
                    init = false
                    timer.start()
                }
                else if (waiting && status == Image.Ready) {
                    currentIndex++
                    first = !first
                    waiting = false
                    timer.unpause()
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: stop()
    }

    states: [
        State {
            name: "showFirst"
            when: first
            PropertyChanges { target: firstImageLoader.item; opacity: 1 }
            PropertyChanges { target: secondImageLoader.item; opacity: 0 }
        },
        State {
            name: "showSecond"
            when: !first
            PropertyChanges { target: firstImageLoader.item; opacity: 0 }
            PropertyChanges { target: secondImageLoader.item; opacity: 1 }
        }
    ]

    transitions: [
        Transition {
            to: "showFirst"
            SequentialAnimation {
                PropertyAnimation { property: "opacity"; duration: 500 }
                ScriptAction { script: { loadImage(secondImageLoader) } }
            }
        },
        Transition {
            to: "showSecond"
            SequentialAnimation {
                PropertyAnimation { property: "opacity"; duration: 500 }
                ScriptAction { script: { loadImage(firstImageLoader) } }
            }
        }
    ]
}
