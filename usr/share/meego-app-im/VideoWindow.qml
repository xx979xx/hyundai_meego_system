/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.App.IM 0.1
import TelepathyQML 0.1

Item {
    id: videoWindow
    anchors.right: parent != undefined ? parent.right : window.right
    anchors.rightMargin: window.fullScreen ? 0 : 20
    anchors.top: parent ? parent.top : window.top
    anchors.topMargin: window.fullScreen ? 0 : 20
    width: getVideoWidth(window, pageContentItem)
    height: getVideoHeight(window, pageContentItem)
    opacity: 0

    property variant pageContentItem
    property int toolBarHeight : 0
    property bool showCameraVideo : true
    property alias videoIncoming : videoIncomingItem
    property alias videoOutgoing : videoOutgoingItem
    // when true, the small video window is used for the camera video
    property bool cameraWindowSmall : true

    /* Video Window position for the four corners, numbered like this:
       0 1
       2 3 */
    property int videoWindowPosition : 2
    // next variable contains target while drag and drop operation (-1 is no target)
    property int videoWindowPositionHighlight : -1
    // videoWindowSwap is updated for drag and drop operation (not related with swap camera feature)
    property bool videoWindowSwap : false
    property bool videoWasSent : false

    function videoAtBottom() {
        return videoWindowPosition & 2;
    }

    function videoAtRight() {
        return videoWindowPosition & 1;
    }

    function getVideoWidth(full, window) {
        if (full.fullScreen) {
            if (window.orientation == 1 || window.orientation == 3) {
                return window.height;
            }
            return window.width;
        }
        var cameraAspectRatio = getCameraAspectRatio();
        var width = window.width * 0.4;
        var height = window.height * 0.4;
        if (width / height > cameraAspectRatio) {
            width = height * cameraAspectRatio;
        }
        return width;
    }

    function getVideoHeight(full, window) {
        if (full.fullScreen) {
            if (window.orientation == 1 || window.orientation == 3) {
                return window.width - toolBarHeight;
            }
            return window.height - toolBarHeight;
        }
        var cameraAspectRatio = getCameraAspectRatio();
        var width = window.width * 0.4;
        var height = window.height * 0.4;
        if (width / height < cameraAspectRatio) {
            height = width / cameraAspectRatio;
        }
        return height;
    }

    Component.onDestruction: {
        if(window.callAgent != undefined) {
            window.callAgent.setOutgoingVideo(null);
            window.callAgent.setIncomingVideo(null);
        }
        console.log("enabled screen saver");
        window.inhibitScreenSaver = false;
    }

    Connections {
        target: window.callAgent
        onVideoSentChanged: {
            var sent = window.callAgent.videoSentOrAboutTo;
            if (sent != videoWasSent) {
                if (sent) {
                    console.log("inhibit screen saver");
                    window.inhibitScreenSaver = true;
                    window.playRecordingStartSound();
                }
                else {
                    console.log("enabled screen saver");
                    window.inhibitScreenSaver = false;
                    window.playRecordingStopSound();
                }
            }
            videoWasSent = sent;
        }
    }

    Connections {
        target: window
        onOrientationChanged: {
            window.callAgent.onOrientationChanged(window.orientation);
        }
    }

    states: [
        State {
            name: "fullscreen"
            when: window.fullScreen
            PropertyChanges {
                target: window
                showToolBarSearch: false
                fullContent: true
            }
        }
    ]

    Rectangle {
        anchors.fill: parent
        color: "#e6e6e6"

        BorderImage {
            source: "image://themedimage/widgets/common/menu/menu-background-shadow"
            anchors.margins: -4
            anchors.fill: parent
            border.left: 11
            border.top: 11
            border.bottom: 11
            border.right: 11
            visible: window.fullScreen
        }
    }

    VideoItem {
        id: videoIncomingItem
        size: Qt.size(parent.width, parent.height)
    }

    Image {
        id: audioCallImage
        visible: (window.callAgent != undefined && !window.callAgent.remoteVideoRender)
        source: "image://themedimage/widgets/apps/chat/call-fullscreen-default"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: !window.fullScreen ? parent.width / 2 : undefined
        height: !window.fullScreen ? parent.height / 2 : undefined

        Text {
            id: audioCallLabel
            anchors.top: parent.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            visible: window.fullScreen
            text: qsTr("Call with %1").arg(window.contactItem.data(AccountsModel.AliasRole));
            color: theme_buttonFontColor
            font.pixelSize: theme_fontPixelSizeLarge
        }
    }

    Item {
        id: videoOutgoingContainer
        /*
        x: videoAtRight() ? parent.width - width - 20 : 20
        y: videoAtBottom() ? parent.height - height - 20 : 20
        */
        anchors.bottom: videoAtBottom() ? parent.bottom : undefined
        anchors.bottomMargin: 20
        anchors.top: !videoAtBottom() ? parent.top : undefined
        anchors.topMargin: 20
        anchors.left: !videoAtRight() ? parent.left : undefined
        anchors.leftMargin: 20
        anchors.right: videoAtRight() ? parent.right: undefined
        anchors.rightMargin: 20
        //width: 176//160
        //height: 144//140
        //width: videoWindow.width / 4
        //height: videoWindow.height / 4
        width: getVideoWidth(window, videoWindow)
        height: getVideoHeight(window, videoWindow)
        visible : videoWindow.showCameraVideo

        function getVideoWidth(full, window) {
            if (!full.fullScreen) {
                return window.width / 4.0;
            }
            var cameraAspectRatio = getCameraAspectRatio();
            var width = window.width / 4.0;
            if (window.width / window.height > cameraAspectRatio) {
                width = window.height / 4.0 * cameraAspectRatio;
            }
            return width;
        }

        function getVideoHeight(full, window) {
            if (!full.fullScreen) {
                return window.height / 4.0;
            }
            var cameraAspectRatio = getCameraAspectRatio();
            var height = window.height / 4.0;
            if (window.width / window.height < cameraAspectRatio) {
                height = window.width / (cameraAspectRatio * 4.0);
            }
            return height;
        }

        Rectangle {
            anchors.margins: -3
            anchors.fill: parent
            color: "black"
        }

        VideoItem {
            id: videoOutgoingItem
            size: Qt.size(parent.width, parent.height)
        }

        MouseArea {
            id: videoOutgoingDAD
            anchors.fill: parent
            drag.target: videoOutgoingContainer
            drag.axis: Drag.XandYAxis
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: parent.parent.width - parent.width
            drag.maximumY: parent.parent.height - parent.height
            onPressed: {
                videoWindowPositionHighlight = -1;
                videoWindowSwap = false;
                videoOutgoingContainer.anchors.left = undefined;
                videoOutgoingContainer.anchors.right = undefined;
                videoOutgoingContainer.anchors.bottom = undefined;
                videoOutgoingContainer.anchors.top = undefined;
            }
            onMousePositionChanged: {
                var tmppos = videoOutgoingDAD.mapToItem(window, mouseX, mouseY)
                if (containedIn(tmppos.x, tmppos.y, moveMyVideoTargetTopLeftDropZone)) {
                    videoWindowSwap = false;
                    videoWindowPositionHighlight = 0;
                } else if (containedIn(tmppos.x, tmppos.y, moveMyVideoTargetTopRightDropZone)) {
                    videoWindowSwap = false;
                    videoWindowPositionHighlight = 1;
                } else if (containedIn(tmppos.x, tmppos.y, moveMyVideoTargetBottomLeftDropZone)) {
                    videoWindowSwap = false;
                    videoWindowPositionHighlight = 2;
                } else if (containedIn(tmppos.x, tmppos.y, moveMyVideoTargetBottomRightDropZone)) {
                    videoWindowSwap = false;
                    videoWindowPositionHighlight = 3;
                } else if (containedIn(tmppos.x, tmppos.y, moveMyVideoTargetCenterDropZone)) {
                    videoWindowSwap = true;
                    videoWindowPositionHighlight = -1;
                } else {
                    videoWindowSwap = false;
                    videoWindowPositionHighlight = -1;
                }
            }
            onReleased: {
                if (videoWindowSwap && window.callAgent.canSwapVideos()) {
                    cameraWindowSmall  = !cameraWindowSmall;
                    videoWindowSwap = false;
                    window.callAgent.setOutgoingVideo(cameraWindowSmall ? videoOutgoingItem : videoIncomingItem);
                    window.callAgent.setIncomingVideo(cameraWindowSmall ? videoIncomingItem : videoOutgoingItem);
                }

                if (videoWindowPositionHighlight != -1) {
                    videoWindowPosition = videoWindowPositionHighlight;
                    videoWindowPositionHighlight = -1;
                }

                // set the anchors
                if (videoAtBottom()) {
                    videoOutgoingContainer.anchors.bottom = videoOutgoingContainer.parent.bottom;
                } else {
                    videoOutgoingContainer.anchors.top = videoOutgoingContainer.parent.top;
                }
                if (videoAtRight()) {
                    videoOutgoingContainer.anchors.right = videoOutgoingContainer.parent.right;
                } else {
                    videoOutgoingContainer.anchors.left = videoOutgoingContainer.parent.left;
                }
            }

            function containedIn(x, y, obj) {
                var tmppos = obj.mapToItem(window, 0, 0);
                if (x >= tmppos.x && x <= (tmppos.x + obj.width) &&
                    y >= tmppos.y && y <= (tmppos.y + obj.height)) {
                    return true;
                }
                return false;
            }
        }
    }

    Image {
        id: moveMyVideoTargetTopLeft
        source: videoWindowPositionHighlight == 0 ?
                    "image://themedimage/widgets/apps/chat/move-video-background-highlight" :
                    "image://themedimage/widgets/apps/chat/move-video-background"
        width: videoOutgoingContainer.getVideoWidth(window, videoWindow)
        height: videoOutgoingContainer.getVideoHeight(window, videoWindow)
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible: videoOutgoingDAD.drag.active

        Item {
            id: moveMyVideoTargetTopLeftDropZone
            anchors.fill: parent
            anchors.margins: -40
            enabled: videoOutgoingDAD.drag.active
        }
    }

    Image {
        id: moveMyVideoTargetTopRight
        source: videoWindowPositionHighlight == 1 ?
                    "image://themedimage/widgets/apps/chat/move-video-background-highlight" :
                    "image://themedimage/widgets/apps/chat/move-video-background"
        width: videoOutgoingContainer.getVideoWidth(window, videoWindow)
        height: videoOutgoingContainer.getVideoHeight(window, videoWindow)
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        visible: videoOutgoingDAD.drag.active

        Item {
            id: moveMyVideoTargetTopRightDropZone
            anchors.fill: parent
            anchors.margins: -20
            enabled: videoOutgoingDAD.drag.active
        }
    }

    Image {
        id: moveMyVideoTargetBottomLeft
        source: videoWindowPositionHighlight == 2 ?
                    "image://themedimage/widgets/apps/chat/move-video-background-highlight" :
                    "image://themedimage/widgets/apps/chat/move-video-background"
        width: videoOutgoingContainer.getVideoWidth(window, videoWindow)
        height: videoOutgoingContainer.getVideoHeight(window, videoWindow)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible: videoOutgoingDAD.drag.active

        Item {
            id: moveMyVideoTargetBottomLeftDropZone
            anchors.fill: parent
            anchors.margins: -20
            enabled: videoOutgoingDAD.drag.active
        }
    }

    Image {
        id: moveMyVideoTargetBottomRight
        source: videoWindowPositionHighlight == 3 ?
                    "image://themedimage/widgets/apps/chat/move-video-background-highlight" :
                    "image://themedimage/widgets/apps/chat/move-video-background"
        width: videoOutgoingContainer.getVideoWidth(window, videoWindow)
        height: videoOutgoingContainer.getVideoHeight(window, videoWindow)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        visible: videoOutgoingDAD.drag.active

        Item {
            id: moveMyVideoTargetBottomRightDropZone
            anchors.fill: parent
            anchors.margins: -20
            enabled: videoOutgoingDAD.drag.active
        }
    }

    Image {
        id: moveMyVideoTargetCenter
        source: videoWindowSwap ?
                    "image://themedimage/widgets/apps/chat/move-video-background-highlight" :
                    "image://themedimage/widgets/apps/chat/move-video-background"
        width: videoOutgoingContainer.getVideoWidth(window, videoWindow)
        height: videoOutgoingContainer.getVideoHeight(window, videoWindow)
        anchors.centerIn: parent
        visible: videoOutgoingDAD.drag.active

        Item {
            id: moveMyVideoTargetCenterDropZone
            anchors.fill: parent
            anchors.margins: -20
            enabled: videoOutgoingDAD.drag.active
        }
    }

    IconButton {
        id: videoOutInfo

        visible: window.callAgent != undefined
        anchors.bottom: videoOutgoingContainer.bottom
        anchors.left: videoOutgoingContainer.left
        icon: "image://themedimage/widgets/common/button/button-info"
        iconDown: icon + "-pressed"
        hasBackground: false
        onClicked: {
            var map = mapToItem(window, height/2, width/2);
            var menu;
            var op1 = videoWindow.showCameraVideo ? qsTr("Minimize me") : qsTr("Maximize me");
            var op2 = window.callAgent.videoSentOrAboutTo ? qsTr("Disable camera") : qsTr("Enable camera");
            var op3 = window.callAgent.cameraSwappable() ? qsTr("Swap camera") : null;
            if (op3 == null) {
                menu = [op1, op2];
            } else {
                menu = [op1, op2, op3]
            }

            actionMenu.model = menu;
            actionMenu.payload = videoWindow;
            contextMenu.setPosition(map.x, map.y);
            contextMenu.show();
        }
    }

    ContextMenu {
        id: contextMenu
        width: 350
        content: ActionMenu {
            id: actionMenu
            onTriggered: {
                if (index == 0) {
                    //videoWindow.showCameraVideo = !videoWindow.showCameraVideo
                    payload.showCameraVideo = !payload.showCameraVideo
                } else if (index == 1) {
                    window.callAgent.videoSent = !window.callAgent.videoSentOrAboutTo;
                } else if (index == 2) {
                    window.callAgent.swapCamera();
                }

                // By setting the sourceComponent of the loader to undefined,
                // then the QML engine will destruct the context menu element
                // much like doing a c++ delete
                contextMenu.hide();
            }
        }
    }

    function getCameraAspectRatio() {
        //var cameraAspectRatio = 4.0 / 3.0;
        //var cameraAspectRatio = 352.0 / 288.0;
        var cameraAspectRatio = 320.0 / 240.0;
        if (window.orientation == 0 || window.orientation == 2) {
            cameraAspectRatio = 1.0 / cameraAspectRatio;
        }
        return cameraAspectRatio;
    }


    Behavior on anchors.rightMargin {
        NumberAnimation {
            duration: 500
        }
    }

    Behavior on anchors.topMargin {
        NumberAnimation {
            duration: 500
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 500
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 500
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 500
        }
    }

}
