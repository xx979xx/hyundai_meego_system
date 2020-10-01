import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import MeeGo.Media 0.1
import QtMultimediaKit 1.1
import MeeGo.App.Video.VideoPlugin 1.0
import MeeGo.Sharing 0.1
import MeeGo.Sharing.UI 0.1
import "functions.js" as Code

AppPage {
    id: landingPage
    anchors.fill: parent
    pageTitle: labelAppName
    property bool infocus: true

    onActivated : {
        infocus = true;
        if(currentVideoID != "")
            editorModel.setPlayStatus(currentVideoID, VideoListModel.Stopped);
        window.disableToolBarSearch = false;
        window.fullScreen = false;
        window.lockOrientationIn = "noLock";
        fullScreen = false;
        showVideoToolbar = false;
    }
    onDeactivated : { infocus = false; }

    Labs.ApplicationsModel {
        id: appsModel
        directories: [ "/usr/share/meego-ux-appgrid/applications", "/usr/share/applications", "~/.local/share/applications" ]
    }

    ModalDialog {
        id: deleteItemDialog
        title: labelDelete
        acceptButtonText: labelConfirmDelete
        cancelButtonText: labelCancel
        property variant payload
        onPayloadChanged:{
            contentItem.title = payload.mtitle;
        }
        onAccepted: {
            masterVideoModel.destroyItemByID(payload.mitemid);
        }
        content: Item {
            id: contentItem
            anchors.fill: parent
            property alias title : titleText.text
            clip: true
            Text{
                id: titleText
                text : qsTr("Video name")
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

    ModalDialog {
        id: deleteMultipleItemsDialog
        property int deletecount: 0
        title: (deletecount < 2)?qsTr("Permanently delete this video?"):qsTr("Permanently delete these %1 videos?").arg(deletecount)
        acceptButtonText: labelConfirmDelete
        cancelButtonText:labelCancel
        onAccepted: {
            masterVideoModel.destroyItemsByID(masterVideoModel.getSelectedIDs());
            masterVideoModel.clearSelected();
            shareObj.clearItems();
            multiSelectMode = false;
        }
        content: Item {
            anchors.fill: parent
            clip: true
            Text {
                text: qsTr("If you delete these, they will be removed from your device")
                anchors.verticalCenter:parent.verticalCenter
                width:  parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: theme_fontPixelSizeMedium
            }
        }
    }

    function playvideo(payload)
    {
        videoIndex = payload.mindex;
        currentVideoID = payload.mitemid;
        currentVideoFavorite = payload.mfavorite;
        videoSource = payload.muri;
        window.fullScreen = true;
        labelVideoTitle = payload.mtitle;
        window.addPage(detailViewContent);
    }

    Connections {
        target: window
        onSearch: {
            videoSearch = needle;
            landingView.opacity = 0;
            masterVideoModel.search = videoSearch;
            if(masterVideoModel.filter != VideoListModel.FilterSearch)
                masterVideoModel.filter = VideoListModel.FilterSearch
            videoListState = (videoListState + 1)%2;
        }
    }

    Connections {
        target: window
        onCmdReceived: {
            if(infocus)
            {
                console.log("Landing Remote Call: " + cmd + " " + cdata);

                if (cmd == "playVideo")
                {
                    var itemid;
                    if(masterVideoModel.isURN(cdata))
                        itemid = masterVideoModel.datafromURN(cdata, MediaItem.ID);
                    else
                        itemid = cdata;

                    if(itemid != "")
                    {
                        /* need to filter on all */
                        masterVideoModel.filter = VideoListModel.FilterAll

                        videoIndex = masterVideoModel.itemIndex(itemid);
                        var title;
                        var uri;
                        if(masterVideoModel.isURN(cdata))
                        {
                            title = masterVideoModel.getTitlefromURN(cdata);
                            uri = masterVideoModel.getURIfromURN(cdata);
                        }
                        else
                        {
                            title = masterVideoModel.getTitlefromID(cdata);
                            uri = masterVideoModel.getURIfromID(cdata);
                        }

                        currentVideoID = itemid;
                        currentVideoFavorite = masterVideoModel.isFavorite(itemid);
                        videoSource = uri;
                        fullScreen = false;
                        labelVideoTitle = title;
                        window.addPage(detailViewContent);
                    }
                }
            }
        }
    }

    ContextMenu {
        id: contextMenu
        property alias payload: contextActionMenu.payload
        property alias model: contextActionMenu.model
        property int mouseX
        property int mouseY
        content: ActionMenu {
            id: contextActionMenu
            property variant payload: undefined
            onTriggered: {
                shareObj.clearItems();
                if (model[index] == labelPlay)
                {
                    // Play
                    landingPage.playvideo(payload);
                    contextMenu.hide();
                }
                else if ((model[index] == labelFavorite)||(model[index] == labelUnFavorite))
                {
                    // Favorite/unfavorite
                    Code.changeItemFavorite(payload);
                    contextMenu.hide();
                }
                else if (model[index] == labelDelete)
                {
                    // Delete
                    deleteItemDialog.payload = payload;
                    deleteItemDialog.show();
                    contextMenu.hide();
                }
                else if (model[index] == labelMultiSelect)
                {
                    // multi select mode on
                    multiSelectMode = true;
                    contextMenu.hide();
                }
                else if (model[index] == labelcShare)
                {
                    // Share
                    shareObj.clearItems();
                    shareObj.addItem(payload.muri) // URI
                    shareObj.showContextTypes(contextMenu.mouseX, contextMenu.mouseY)
                }
            }
        }
    }
    Connections {
        target: masterVideoModel
        onTotalChanged: {
            topicAll = qsTr("All (%1 videos)").arg(masterVideoModel.total);
            window.actionMenuModel = [topicAll, topicAdded, topicViewed, topicUnwatched, topicFavorites];
        }
    }
    actionMenuModel: [topicAll, topicAdded, topicViewed, topicUnwatched, topicFavorites]
    actionMenuPayload: ["all", "added", "viewed", "unwatched", "favorites"]
    onActionMenuTriggered: {
        selectView(selectedItem);
    }

    function selectView(selectedItem) {
        if (selectedItem == "all") {
            landingView.opacity = 0;
            if(masterVideoModel.filter != VideoListModel.FilterAll)
            {
                masterVideoModel.filter = VideoListModel.FilterAll
                masterVideoModel.sort = VideoListModel.SortByTitle;
            }
        }else if(selectedItem == "added") {
            landingView.opacity = 0;
            if(masterVideoModel.filter != VideoListModel.FilterAdded)
            {
                masterVideoModel.filter = VideoListModel.FilterAdded
                masterVideoModel.sort = VideoListModel.SortByAddedTime;
            }
        }else if(selectedItem == "viewed") {
            landingView.opacity = 0;
            if(masterVideoModel.filter != VideoListModel.FilterViewed)
            {
                masterVideoModel.filter = VideoListModel.FilterViewed
                masterVideoModel.sort = VideoListModel.SortByAccessTime;
            }
        }else if(selectedItem == "unwatched") {
            landingView.opacity = 0;
            if(masterVideoModel.filter != VideoListModel.FilterUnwatched)
            {
                masterVideoModel.filter = VideoListModel.FilterUnwatched
                masterVideoModel.sort = VideoListModel.SortByTitle;
            }
        }else if(selectedItem == "favorites") {
            landingView.opacity = 0;
            if(masterVideoModel.filter != VideoListModel.FilterFavorite)
            {
                masterVideoModel.filter = VideoListModel.FilterFavorite
                masterVideoModel.sort = VideoListModel.SortByTitle;
            }
        }else if(selectedItem == "search") {
            landingView.opacity = 0;
            masterVideoModel.search = videoSearch;
            if(masterVideoModel.filter != VideoListModel.FilterSearch)
            {
                masterVideoModel.filter = VideoListModel.FilterSearch
                masterVideoModel.sort = VideoListModel.SortByTitle;
            }
        }
        videoListState = (videoListState + 1)%2;
    }

    Item {
        id: landingItem
        anchors.fill: parent

        Item {
            id: landingView
            opacity: 0
            anchors.fill: parent
            Rectangle {
                id: globalbgsolid
                anchors.fill: parent
                color: "black"
            }

            BorderImage {
                id: panel
                anchors.fill: parent
                anchors.topMargin: 8
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.bottomMargin: 5
                source: "image://themedimage/widgets/apps/media/content-background"
                border.left:   8
                border.top:    8
                border.bottom: 8
                border.right:  8
            }
            function setNoContentComponent() {
                if (masterVideoModel.count == 0 && !noVideoScreen.visible) {
                    noContentScreen.visible = true
                    if(masterVideoModel.filter == VideoListModel.FilterFavorite) {
                        noContentScreen.sourceComponent = noContentFavorite;
                    } else if(masterVideoModel.filter == VideoListModel.FilterUnwatched) {
                        noContentScreen.sourceComponent = noContentUnwatched;
                    } else if(masterVideoModel.filter == VideoListModel.FilterViewed) {
                        noContentScreen.sourceComponent = noContentViewed;
                    } else if(masterVideoModel.filter == VideoListModel.FilterAdded) {
                        noContentScreen.sourceComponent = noContentAdded;
                    }
                } else {
                    noContentScreen.visible = false
                    noContentScreen.sourceComponent = undefined
                }
            }
            Connections {
                target: masterVideoModel
                onCountChanged: {
                    //console.log("countChanged: count: " + masterVideoModel.count);
                    landingView.setNoContentComponent();
                }
                onFilterChanged: {
                    //console.log("filterChanged: count: " + masterVideoModel.count);
                    landingView.setNoContentComponent();
                }
            }
            NoVideosNotification {
                id: noVideoScreen
                visible: ((masterVideoModel.total == 0)&&(!startupTimer.running))
            }

            Loader {
                id: noContentScreen
                anchors.fill: parent
                visible: false
            }
            Component {
                id: noContentFavorite
                NoContentFavorite {}
            }
            Component {
                id: noContentUnwatched
                NoContentUnwatched {}
            }
            Component {
                id: noContentViewed
                NoContentViewed {}
            }
            Component {
                id: noContentAdded
                NoContentAdded {}
            }

            MediaGridView {
                id: landingScreenGridView
                type: videotype // video app = 0
                selectionMode: multiSelectMode
                visible: !noContentScreen.visible && !noVideoScreen.visible
                showHeader: true
                clip:true
                anchors.fill: parent
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                anchors.leftMargin: (parent.width - Math.floor(parent.width / 370)*370) / 2
                anchors.rightMargin: anchors.leftMargin
                model: masterVideoModel
                defaultThumbnail: "image://themedimage/images/media/video_thumb_med"
                footerHeight: multibar.height
                onClicked:{
                    if(multiSelectMode)
                    {
                        masterVideoModel.setSelected(payload.mitemid, !masterVideoModel.isSelected(payload.mitemid));
                        if (masterVideoModel.isSelected(payload.mitemid))
                            shareObj.addItem(payload.muri);
                        else
                            shareObj.delItem(payload.muri);
                    }
                    else
                    {
                        videoIndex = payload.mindex;
                        currentVideoID = payload.mitemid;
                        currentVideoFavorite = payload.mfavorite;
                        videoSource = payload.muri;
                        fullScreen = false;
                        labelVideoTitle = payload.mtitle;
                        window.addPage(detailViewContent);
                    }
                }
                onLongPressAndHold: {
                    if(!multiSelectMode)
                    {
                        var map = payload.mapToItem(topItem.topItem, mouseX, mouseY);
                        contextMenu.model = [labelPlay, ((payload.mfavorite)?labelUnFavorite:labelFavorite),
                                             labelcShare, labelMultiSelect, labelDelete];
                        contextMenu.payload = payload;
                        contextMenu.mouseX = map.x;
                        contextMenu.mouseY = map.y;
                        topItem.calcTopParent()
                        contextMenu.setPosition( map.x, map.y );
                        contextMenu.show();
                    }
                }
            }
            states: [
                State {
                    name: "view0"
                    when: videoListState == 0
                    PropertyChanges {
                        target: landingView
                        opacity: 1
                    }
                },
                State {
                    name: "view1"
                    when: videoListState == 1
                    PropertyChanges {
                        target: landingView
                        opacity: 1
                    }
                }
            ]

            transitions: [
                Transition {
                    SequentialAnimation {
                        PropertyAnimation {
                            properties: "opacity"
                            duration: 500
                            easing.type: Easing.OutSine
                        }
                    }
                }
            ]
        }

        MediaMultiBar {
            id: multibar
            height: (multiSelectMode)?55:0
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            landscape: window.isLandscape
            showadd: false
            onDeletePressed: {
                if(masterVideoModel.selectionCount() > 0)
                {
                    deleteMultipleItemsDialog.deletecount = masterVideoModel.selectionCount();
                    deleteMultipleItemsDialog.show();
                }
            }
            onCancelPressed: {
                masterVideoModel.clearSelected();
                shareObj.clearItems();
                multiSelectMode = false;
            }
            onSharePressed: {
                if(shareObj.shareCount > 0)
                {
                    var map = mapToItem(topItem.topItem, fingerX, fingerY);
                    shareObj.showContextTypes(map.x, map.y)
                }
            }
            states: [
                State {
                    name: "showActionBar"
                    when: multiSelectMode
                    PropertyChanges {
                        target: multibar
                        opacity:1
                    }
                },
                State {
                    name: "hideActionBar"
                    when: !multiSelectMode
                    PropertyChanges {
                        target: multibar
                        opacity: 0
                    }
                }
            ]

            transitions: [
                Transition {
                    reversible: true
                    PropertyAnimation {
                        target: multibar
                        property: "opacity"
                        duration: 250
                    }
                }
            ]
        }
    }
    TopItem { id: topItem }
}
