/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Media 0.1
import QtMultimediaKit 1.1
import MeeGo.App.Video.VideoPlugin 1.0
import MeeGo.Sharing 0.1
import MeeGo.Sharing.UI 0.1

Window {
    id: window

    property string labelAppName: qsTr("Videos")
    property string topicAll: qsTr("All")
    property string topicAdded: qsTr("Recently added")
    property string topicViewed: qsTr("Recently viewed")
    property string topicUnwatched: qsTr("Unwatched")
    property string topicFavorites: qsTr("Favorites")

    property string labelVideoTitle: ""
    property string labelConfirmDelete: qsTr("Delete")
    property string labelCancel: qsTr("Cancel")
    property string videoSearch: ""
    property string videoSource: ""
    property string favoriteColor: "#ff8888"
    property string currentVideoID: ""
    property bool currentVideoFavorite: false
    property string labelPlay: qsTr("Play")
    property string labelFavorite: qsTr("Favorite")
    property string labelUnFavorite: qsTr("Unfavorite")
    property string labelcShare: qsTr("Share")
    property string labelDelete: qsTr("Delete")
    property string labelMultiSelect:qsTr("Select multiple videos")
    property bool multiSelectMode: false

    property int animationDuration: 500
    property int videoIndex: 0

    property int videoToolbarHeight: 55
    property int videoThumblistHeight: 75
    property int videoListState: 0
    property bool showVideoToolbar: false
    property bool videoCropped: false
    property bool playing: false
    property bool isLandscape: (window.inLandscape || window.inInvertedLandscape)

    signal cmdReceived(string cmd, string cdata)

    Timer {
        id: startupTimer
        interval: 2000
        repeat: false
    }
    
    Component.onCompleted: {
        switchBook( landingScreenContent )
        startupTimer.start();
    }

    // an editor model, used to do things like tag arbitrary items as favorite/viewed
    property variant editorModel: VideoListModel {
        type:VideoListModel.Editor
        limit: 0
        sort: VideoListModel.SortByDefault
    }

    property variant masterVideoModel: VideoListModel {
        type:VideoListModel.ListofAll
        limit: 0
        sort: VideoListModel.SortByTitle
        onTotalChanged: {
            topicAll = qsTr("All (%1 videos)").arg(masterVideoModel.total);
        }
        onItemAvailable: {
            window.cmdReceived("playVideo", identifier);
        }
    }

    overlayItem: Item {
        id: globalItems
        z: 1000
        anchors.fill: parent

        ShareObj {
            id: shareObj
            shareType: MeeGoUXSharingClientQmlObj.ShareTypeVideo
            onSharingComplete: {
                if(multiSelectMode)
                {
                    masterVideoModel.clearSelected();
                    shareObj.clearItems();
                    multiSelectMode = false;
                }
            }
        }

        TopItem { id: topItem }
    }

    QmlDBusVideo {
        id: dbusControl
    }

    QmlSetting{
        id: settings
        organization: "MeeGo"
        application:"meego-app-video"
    }

    Connections {
        target: mainWindow
        onCall: {
            if(parameters[0] == "playVideo")
                masterVideoModel.requestItem(parameters[1]);
            else if(parameters[0] == "play")
                window.cmdReceived(parameters[0], "");
            else if(parameters[0] == "pause")
                window.cmdReceived(parameters[0], "");
        }
    }

    Component {
        id: landingScreenContent
        LandingPage {
        }
    }  

    Component {
        id: detailViewContent
        DetailPage {
        }
    }
}

