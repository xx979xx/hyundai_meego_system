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
import Qt.labs.gestures 2.0

Rectangle {
    id: photoViewer
    anchors.centerIn: parent
    color: "black"

    property variant appPage
    property alias model: photoListView.model
    property alias initialIndex: photoListView.initialIndex
    property alias currentItem: photoListView.currentItem
    property alias count: photoListView.count

    property bool fullscreen: false
    property variant slideshow

    signal slideshowStopped()

    function startSlideshow() {
        if (!slideshow)
            slideshow = slideshowComponent.createObject(photoViewer)
    }

    signal clickedOnPhoto()
    signal currentItemChanged()
    signal pressAndHoldOnPhoto(variant mouse, variant instance)

    function showPhotoAtIndex(index) {
        if (index < photoListView.count) {
            photoThumbnailView.positionViewAtIndex(index,ListView.Center);
            photoListView.positionViewAtIndex(index,ListView.Center);
            photoListView.currentIndex = index;
        }
    }

    function showNextPhoto() {
        photoListView.incrementCurrentIndex();
    }

    function showPrevPhoto() {
        photoListView.decrementCurrentIndex();
    }

    function rotateRightward() {
        photoListView.rotateDuration = 300
        photoListView.currentItem.photoRotate = (photoListView.currentItem.photoRotate + 1) % 4;
    }

    function rotateLeftward() {
        photoListView.rotateDuration = 300
        photoListView.currentItem.photoRotate = (photoListView.currentItem.photoRotate + 3) % 4;
    }

    ListView {
        id: photoListView
        cacheBuffer: photoViewer.width
        anchors.fill: parent
        clip: true
        snapMode:ListView.SnapOneItem
        orientation: ListView.Horizontal
        spacing: 30
        focus: true
        pressDelay: 0
        property int rotateDuration: 0
        property int initialIndex: 0

        signal startingSlideshow()

        delegate: Flickable {
            id: dinstance
            width: photoViewer.width
            height: photoViewer.height
            property alias imageExtension: extension
            property variant centerPoint

            onWidthChanged: {
                restorePhoto();
            }
            onHeightChanged: {
                restorePhoto();
            }

            contentWidth: {
                if (photoRotate == 0 || photoRotate == 2) {
                    image.width * image.scale > width ? image.width * image.scale : width
                }
                else {
                    image.height * image.scale > width ? image.height * image.scale : width
                }
            }

            contentHeight:{
                if (photoRotate == 0 || photoRotate == 2) {
                    image.height * image.scale > height ? image.height * image.scale : height
                }
                else {
                    image.width * image.scale > height ? image.width * image.scale : height
                }
            }

            clip: true
            property string ptitle: title
            property bool pfavorite: favorite
            property string pitemid: itemid
            property string pthumburi: thumburi
            property string pcreation: creationtime
            property string pcamera: camera
            property string puri: uri

            property int photoRotate: 0

            function updateImage() {
                stricturl.setUrlUnencoded(uri)
                fullImage.source = stricturl.url
            }

            onPhotoRotateChanged: {
                saveTimer.restart()
            }

            Component.onDestruction: {
                if (saveTimer.running) {
                    saveTimer.stop()
                    extension.saveInfo()
                }
            }

            Labs.StrictUrl {
                id: stricturl
            }

            Timer {
                id: saveTimer
                interval: 2000
                onTriggered: {
                    extension.saveInfo()
                }
            }

            // thumbnail image
            Image {
                id: image
                source: thumburi
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                width: dinstance.width
                height: dinstance.height
                transformOrigin: Item.Center
                visible: fullImage.opacity != 1
                asynchronous: true
                smooth: rotation % 90 == 0
            }

            // full res image
            LimitedImage {
                id: fullImage
                anchors.centerIn: parent
                width: dinstance.width
                height: dinstance.height
                transformOrigin: Item.Center
                opacity: 0
                visible: opacity != 0
                property bool show: false
                property bool load: false
                smooth: scale < 1.5 && (rotation % 90 == 0)

                onStatusChanged: {
                    if (status == Image.Ready) {
                        show = true
                    }
                }

                states: [
                    State {
                        name: "showFull"
                        when: fullImage.show
                        PropertyChanges {
                            target: fullImage
                            opacity: 1
                        }
                    }
                ]

                transitions: [
                    Transition {
                        reversible: true
                        PropertyAnimation {
                            properties: "opacity"
                            duration: 500
                        }
                    }
                ]

                Component.onCompleted: {
                    if (index == photoListView.currentIndex) {
                        if (photoListView.moving) {
                            load = true
                        }
                        else {
                            stricturl.setUrlUnencoded(uri)
                            source = stricturl.url
                        }
                    }
                }

                Connections {
                    target: photoListView
                    onMovementEnded: {
                        if (fullImage.load) {
                            stricturl.setUrlUnencoded(uri)
                            fullImage.source = stricturl.url
                            fullImage.load = false
                        }
                    }

                    onStartingSlideshow: {
                        stricturl.setUrlUnencoded(uri)
                        fullImage.source = stricturl.url
                   }

                    onCurrentIndexChanged: {
                        if (index == photoListView.currentIndex) {
                            if (photoListView.moving) {
                                fullImage.load = true
                            }
                            else {
                                stricturl.setUrlUnencoded(uri)
                                fullImage.source = stricturl.url
                            }
                        }
                    }
                }
            }

            Labs.ImageExtension {
                id: extension
                source: uri
                userOrientation: photoRotate

                Component.onCompleted: {
                    photoRotate = orientation
                }
            }

            Connections {
                target: photoListView
                onCurrentItemChanged: {
                    if (currentItem == dinstance) {
                        // don't set viewed if we're already looking at last viewed
                        if (allPhotosModel.filter != 2) {
                            photoViewer.model.setViewed(pitemid)
                        }
                    }
                }
            }

            states: [
                State {
                    name: "upright"
                    when: photoRotate == 0
                    PropertyChanges {
                        target: image
                        rotation: 0
                        width: dinstance.width
                        height: dinstance.height
                    }
                    PropertyChanges {
                        target: fullImage
                        rotation: 0
                        width: dinstance.width
                        height: dinstance.height
                    }
                },
                State {
                    name: "rightward"
                    when: photoRotate == 1
                    PropertyChanges {
                        target: image
                        rotation: 90
                        width: dinstance.height
                        height: dinstance.width
                    }
                    PropertyChanges {
                        target: fullImage
                        rotation: 90
                        width: dinstance.height
                        height: dinstance.width
                    }
                },
                State {
                    name: "upsidedown"
                    when: photoRotate == 2
                    PropertyChanges {
                        target: image
                        rotation: 180
                        width: dinstance.width
                        height: dinstance.height
                    }
                    PropertyChanges {
                        target: fullImage
                        rotation: 180
                        width: dinstance.width
                        height: dinstance.height
                    }
                },
                State {
                    name: "leftward"
                    when: photoRotate == 3
                    PropertyChanges {
                        target: image
                        rotation: 270
                        width: dinstance.height
                        height: dinstance.width
                    }
                    PropertyChanges {
                        target: fullImage
                        rotation: 270
                        width: dinstance.height
                        height: dinstance.width
                    }
                }
            ]

            transitions: [
                Transition {
                    reversible: true
                    SequentialAnimation {
                        ParallelAnimation {
                            PropertyAnimation {
                                properties: "width,height"
                                duration: photoListView.rotateDuration
                            }

                            RotationAnimation {
                                id: rotateAnimation
                                direction: RotationAnimation.Shortest
                                duration: photoListView.rotateDuration
                            }
                        }

                        ScriptAction {
                            script: photoListView.rotateDuration = 0
                        }
                    }
                }
            ]
            function restorePhoto() {
                //   image.sourceSize.width = 1024;
                //   image.scale = 1;
                if (photoRotate == 0 || photoRotate == 2) {
                    image.width = dinstance.width;
                    image.height = dinstance.height;
                }
                else {
                    image.width = dinstance.height;
                    image.height = dinstance.width;
                }
            }

            GestureArea {
                anchors.fill: parent

                Tap {
                    onFinished: photoViewer.clickedOnPhoto()
                }

                TapAndHold {
                    onFinished: {
                        // map from window to item coordinates
                        var map = window.mapToItem(dinstance, gesture.position.x, gesture.position.y)
                        photoViewer.pressAndHoldOnPhoto(map, dinstance);
                    }
                }

                Pinch {
                    onStarted: {
                        dinstance.interactive = false;
                        photoListView.interactive = false;
                        dinstance.centerPoint = topItem.topItem.mapToItem(dinstance, gesture.centerPoint.x, gesture.centerPoint.y);
                    }

                    onUpdated: {
                        var cw = dinstance.contentWidth;
                        var ch = dinstance.contentHeight;
                        image.scale = Math.max(0.25, Math.min(10.0, image.scale * gesture.scaleFactor))
                        fullImage.scale = image.scale;
                        if (fullImage.scale < 1.0) {
                            dinstance.contentX =  0;
                            dinstance.contentY =  0;
                        }
                        else {
                            dinstance.contentX =  (dinstance.centerPoint.x + dinstance.contentX )/ cw * dinstance.contentWidth - dinstance.centerPoint.x;
                            dinstance.contentY = (dinstance.centerPoint.y + dinstance.contentY)/ ch * dinstance.contentHeight - dinstance.centerPoint.y;
                        }
                    }

                    onFinished: {
                        dinstance.interactive = fullImage.scale > 1;
                        photoListView.interactive = true;
                    }
                }
            }
        }
        Component.onCompleted: {
            // start the timer the first time.
            hideThumbnailTimer.start();
            showPhotoAtIndex(initialIndex)
        }

        property variant previousTimestamp
        property int flickCount: 0
        property bool movementCausedByFlick: false

        onFlickStarted: {
            var t = (new Date()).getTime();
            if (t - previousTimestamp < 1000) {
                flickCount++;
                if (flickCount > 2)
                    photoThumbnailView.show = true;
            }
            else flickCount = 1

            previousTimestamp = t;
            movementCausedByFlick = true;
            if (photoThumbnailView.show)
                hideThumbnailTimer.restart();
        }

        onMovementEnded: {
            if (!movementCausedByFlick) {
                currentIndex = indexAt(contentX + width/2, contentY + height/2);
            }
            else {
                var i = indexAt(contentX + width/2, contentY + height/2);
                if (currentIndex != i)
                {
                    currentIndex = i;
                }
            }
            movementCausedByFlick = false;

            photoListView.currentItem.updateImage();
        }

        onCurrentItemChanged: {
            photoViewer.currentItemChanged()
        }
    }

    Component {
        id: slideshowComponent

        SlideshowViewer {
            id: slideshow
            model: photoViewer.model
            currentIndex: photoListView.currentIndex

            onSlideshowStopped: {
                showPhotoAtIndex(aFinalIndex)
                photoViewer.slideshowStopped()
                slideshow.destroy()
                photoViewer.slideshow = undefined
            }
        }
    }

    ListView {
        id: photoThumbnailView
        cacheBuffer: photoViewer.width / 3

        width: Math.min(120 * count, photoViewer.width)
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: ListView.Horizontal
        height: 100

        focus: true
        clip: true
        currentIndex: photoListView.currentIndex
        model: photoViewer.model
        property bool show: false
        spacing: 2
        opacity: 0
        visible: opacity != 0
        onShowChanged: {
            // start the timer
            if (show == true) {
                hideThumbnailTimer.start();
            }
            else {
                hideThumbnailTimer.stop();
            }
        }
        onMovementStarted: hideThumbnailTimer.restart()
        onMovementEnded: hideThumbnailTimer.restart()

        delegate: Image {
            id: thumbnail
            width: 100
            height: 100
            source: thumburi
            fillMode: Image.PreserveAspectCrop
            clip: true

            GestureArea {
                anchors.fill: parent

                Tap {
                    onFinished: {
                        photoListView.positionViewAtIndex(index, ListView.Center)
                        photoListView.currentIndex = index
                        hideThumbnailTimer.restart()
                    }
                }
            }
        }

        states: [
            State {
                name: "fullscreen-mode"
                when: photoViewer.fullscreen
                PropertyChanges {
                    target: photoThumbnailView
                    anchors.topMargin: 5
                }
            },
            State {
                name: "toolbar-mode"
                when: !photoViewer.fullscreen
                PropertyChanges {
                    target: photoThumbnailView
                    anchors.topMargin: 5 + window.statusBar.height + appPage.toolbarHeight
                }
            }
        ]

        transitions: [
            Transition {
                from: "fullscreen-mode"
                to: "toolbar-mode"
                reversible: true
                PropertyAnimation {
                    property: "anchors.topMargin"
                    duration: 250
                    easing.type: "OutSine"
                }
            }
        ]
    }

    Timer {
        id: hideThumbnailTimer;
        interval: 3000; running: false; repeat: false
        onTriggered: {
            if (photoThumbnailView.moving) {
                restart()
            }
            else {
                photoThumbnailView.show = false;
            }
        }
    }

    states: [
        State {
            name: "showThumbnail"
            when: photoThumbnailView.show
            PropertyChanges { target: photoThumbnailView; opacity: 1.0 }
        },
        State {
            name: "hideThumbnail"
            when: photoThumbnailView.show == false
            PropertyChanges { target: photoThumbnailView; opacity: 0}
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation {
                property:"opacity"
                duration: 400
            }
        }
    ]
}
