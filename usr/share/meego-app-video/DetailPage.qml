import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Media 0.1
import QtMultimediaKit 1.1
import MeeGo.App.Video.VideoPlugin 1.0
import MeeGo.Sharing 0.1
import MeeGo.Sharing.UI 0.1
import "functions.js" as Code

AppPage {
    id: detailPage
    anchors.fill: parent
    pageTitle: labelAppName
    property bool infocus: true
    onActivated : { infocus = true; }
    onDeactivated : { infocus = false; }

    property variant resourceManager: ResourceManager {
        name: "player"
        type: ResourceManager.VideoApp
        onStartPlaying: {
            video.play();
        }
        onStopPlaying: {
            video.pause();
        }
    }

    ModalDialog {
        id: deleteItemDialog
        title: labelDelete
        acceptButtonText: labelConfirmDelete
        cancelButtonText: labelCancel
        onAccepted: {
            masterVideoModel.destroyItemByID(currentVideoID);
        }
        content: Item {
            id: contentItem
            anchors.fill: parent
            clip: true
            Text{
                id: titleText
                text : labelVideoTitle
                anchors.top: parent.top
                width:  parent.width
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                text: qsTr("If you delete this, it will be removed from your device")
                anchors.top:titleText.bottom
                width:  parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: theme_fontPixelSizeMedium
            }
        }
    }

    Connections {
        target: window
        onCmdReceived: {
            if(infocus)
            {
                console.log("Detail Remote Call: " + cmd + " " + cdata);

                if (cmd == "playVideo")
                {
                    var itemid;
                    if(masterVideoModel.isURN(cdata))
                        itemid = masterVideoModel.getIDfromURN(cdata);
                    else
                        itemid = cdata;

                    if(itemid != "")
                    {
                        /* need to filter on all */
                        masterVideoModel.filter = VideoListModel.FilterAll

                        if(itemid != videoThumbnailView.currentItem.mitemid)
                        {
                            showVideoToolbar = false;
                            fullScreen = true;
                            videoThumbnailView.show(false);
                            videoThumbnailView.currentIndex = masterVideoModel.itemIndex(itemid);
                            currentVideoID = videoThumbnailView.currentItem.mitemid;
                            currentVideoFavorite = videoThumbnailView.currentItem.mfavorite;
                            videoSource = videoThumbnailView.currentItem.muri;
                            labelVideoTitle = videoThumbnailView.currentItem.mtitle;
                            video.source = videoSource;
                        }
                        Code.play();
                    }
                }
                else if (cmd == "play")
                {
                    Code.play();
                }
                else if (cmd == "pause")
                {
                    Code.pause();
                }
            }
        }
    }

    ContextMenu {
        id: contextMenu
        property alias model: contextActionMenu.model
        property variant shareModel: []
        content: ActionMenu {
            id: contextActionMenu
            onTriggered: {
                shareObj.clearItems();
                if (model[index] == labelDelete)
                {
                    // Delete
                    deleteItemDialog.show();
                    contextMenu.hide();
                }
                else
                {
                    // Share
                    shareObj.clearItems();
                    shareObj.addItem(videoSource) // URI
                    var svcTypes = shareObj.serviceTypes;
                    for (x in svcTypes) {
                        if (model[index] == svcTypes[x]) {
                            shareObj.showContext(model[index], contextMenu.x, contextMenu.y);
                            break;
                        }
                    }
                    contextMenu.hide();
                }
            }
        }
    }

    Item {
        id: detailItem
        anchors.fill: parent
        property alias videoThumbList: videoThumbnailView

        Component.onCompleted: {
            window.disableToolBarSearch = true;
            detailPage.lockOrientationIn = "landscape";
            video.source = videoSource;
            Code.play();
            fullScreen = window.fullScreen;
            if(fullScreen)
                showVideoToolbar = false;
            else
                showVideoToolbar = true;
        }

        Component.onDestruction: {
            detailPage.lockOrientationIn = "noLock";
        }

        MediaPreviewStrip {
            id: videoThumbnailView
            model: masterVideoModel
            width: parent.width
            showText: false
            itemSpacing: 0
            anchors.top: parent.top
            anchors.topMargin: window.statusBar.height + detailPage.toolbarHeight
            anchors.horizontalCenter: parent.horizontalCenter
            currentIndex: videoIndex
            z: 1000
            onClicked: {
                Code.playNewVideo(payload);
            }
        }
        states: [
            State {
                name: "showtoolbar-mode"
                when: !fullScreen
                PropertyChanges {
                    target: videoThumbnailView
                    anchors.topMargin: window.statusBar.height + detailPage.toolbarHeight
                }
            },
            State {
                name: "hidetoolbar-mode"
                when: fullScreen
                PropertyChanges {
                    target: videoThumbnailView
                    anchors.topMargin: 0
                }
            }
        ]

        transitions: [
            Transition {
                from: "showtoolbar-mode"
                to: "hidetoolbar-mode"
                reversible: true
                PropertyAnimation {
                    property: "anchors.topMargin"
                    duration: 250
                    easing.type: "OutSine"
                }
            }
        ]

        Rectangle {
            id: videorect
            anchors.fill: parent
            color: "black"
            Video {
                id: video
                anchors.bottom: parent.bottom
                width: screenWidth
                height: screenHeight
                autoLoad: true
                onStopped: {
                    videoThumbnailView.show(true);
                    if(fullScreen)
                        exitFullscreen();
                }
                onError: {
                    Code.changestatus(VideoListModel.Stopped);
                }
                Connections {
                    target: window
                    onWindowActiveChanged: {
                        if (!window.isActive && video.playing && !video.paused)
                        {
                            if (fullScreen)
                                exitFullscreen();
                            Code.pause();
                        }
                    }
                }
            }
            MouseArea {
                anchors.fill:parent
                onClicked:{
                    if(fullScreen)
                        Code.exitFullscreen();
                    else
                        Code.enterFullscreen();
                    videoThumbnailView.hide();
                }
                onPressAndHold: {
                    var map = mapToItem(topItem.topItem, mouseX, mouseY);
                    var sharelist = shareObj.serviceTypes;
                    contextMenu.model = sharelist.concat(labelDelete);
                    topItem.calcTopParent()
                    contextMenu.setPosition( map.x, map.y );
                    contextMenu.show();
                }
            }
        }

        MediaToolbar {
            id: videoToolbar
            anchors.bottom: parent.bottom
            width: parent.width
            showprev: true
            showplay: true
            shownext: true
            showprogressbar: true
            showvolume: true
            showfavorite: true
            isfavorite: currentVideoFavorite
            onPrevPressed: Code.playPrevVideo();
            onPlayPressed: Code.play();
            onPausePressed: Code.pause();
            onNextPressed: Code.playNextVideo();
            Connections {
                target: video
                onPositionChanged: {
                    var msecs = video.duration - video.position;
                    videoToolbar.remainingTimeText = Code.formatTime(msecs/1000);
                    videoToolbar.elapsedTimeText = Code.formatTime(video.position/1000);
                }
            }
            onSliderMoved: {
                if (video.seekable) {
                    progressBarConnection.target = null
                    video.position = video.duration * videoToolbar.sliderPosition;
                    progressBarConnection.target = video
                }
            }
            Connections {
                id: progressBarConnection
                target: video
                onPositionChanged: {
                    if (video.duration != 0) {
                        videoToolbar.sliderPosition = video.position/video.duration;
                    }
                }
            }
            onFavoritePressed: {
                currentVideoFavorite = isfavorite;
                masterVideoModel.setFavorite(currentVideoID, currentVideoFavorite);
            }
            states: [
                State {
                    name: "showVideoToolbar"
                    when: showVideoToolbar
                    PropertyChanges {
                        target: videoToolbar
                        height: window.videoToolbarHeight
                        opacity:1
                    }
                },
                State {
                    name: "hideVideoToolbar"
                    when: !showVideoToolbar
                    PropertyChanges {
                        target: videoToolbar
                        height: 0
                        opacity: 0
                    }
                }
            ]

            transitions: [
                Transition {
                    reversible: true
                    ParallelAnimation{
                        PropertyAnimation {
                            target:videoToolbar
                            property: "height"
                            duration: 250

                        }

                        PropertyAnimation {
                            target: videoToolbar
                            property: "opacity"
                            duration: 250
                        }
                    }
                }
            ]
        }
    }
    TopItem { id: topItem }
}
