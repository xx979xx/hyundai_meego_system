/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import MeeGo.Panels 0.1

import MeeGo.Sharing 0.1
import MeeGo.Sharing.UI 0.1


Window {
    id: window
    anchors.centerIn: parent

    fullContent: true
    fullScreen: true

    bookMenuModel: ["MainPage"]
    bookMenuPayload: [mainPage]

    Component.onCompleted: {
        switchBook(mainPage)
    }

    Translator {
        catalog: "meego-ux-panels"
    }

    Theme {
        id: theme
    }

    PanelProxyModel {
        id: panelsModel
        filterType: PanelProxyModel.FilterTypeHidden
        sortType: PanelProxyModel.SortTypeIndex
    }

    Labs.ApplicationsModel {
        id: appsModel
        directories: [ "/usr/share/meego-ux-appgrid/applications", "/usr/share/applications", "~/.local/share/applications" ]
        favorites.limit: 8
        favorites.filterOut: ["/usr/share/meego-ux-appgrid/applications/meego-ux-settings.desktop"]
    }

    Labs.WindowModel {
        id: windowModel
    }

    Labs.BackgroundModel {
        id: backgroundModel
    }

    onOrientationChanged: {
        if (bgRect.bgImage1) {
            if (window.orientation & 1) {
                bgRect.bgImage2 = bgImageLandscape.createObject(bgRect);
	    } else {
                bgRect.bgImage2 = bgImagePortrait.createObject(bgRect);
	    }
            animBG2In.start();
        } else {
            if (window.orientation & 1) {
                bgRect.bgImage1 = bgImageLandscape.createObject(bgRect);
	    } else {
                bgRect.bgImage1 = bgImagePortrait.createObject(bgRect);
	    }
            animBG1In.start();
        }
    }

    Rectangle {
        id: bgRect
        anchors.fill: parent
        z: -1
        color: "black"
        property QtObject bgImage1: null
        property QtObject bgImage2: null

        //Get around the animations complaining about null objects
        Component.onCompleted: {
            bgImage2 = dummyImage.createObject(bgRect);
        }

        Component {
            id: dummyImage
            Image {
            }
        }


        Connections {
            target: bgRect.bgImage1
            onStatusChanged: {
                console.log("Image1 status changed:", bgRect.bgImage1.status);
                if (bgRect.bgImage1.status == Image.Ready) {
                    console.log("Starting animBG1In");
                    animBG1In.start();
                }
            }
        }

        Connections {
            target: bgRect.bgImage2
            onStatusChanged: {
                console.log("Image2 status changed:", bgRect.bgImage2.status);
                if (bgRect.bgImage2.status == Image.Ready) {
                    console.log("Starting animBG2In");
                    animBG2In.start();
                }
            }
        }


        SequentialAnimation {
            id: animBG1In
            ScriptAction {
                script: { console.log("Inside animBG1In, 1/2:", bgRect.bgImage1, bgRect.bgImage2); }
            }
            ParallelAnimation {
                NumberAnimation {
                    target: bgRect.bgImage1
                    property: "opacity"
                    to: 1.0
                    duration: 500
                }
                NumberAnimation {
                    target: bgRect.bgImage2
                    property: "opacity"
                    to: 0
                    duration: 500
                }
            }
            ScriptAction {
                script: { bgRect.bgImage2.destroy(); bgRect.bgImage2 = null; }
            }
        }

        SequentialAnimation {
            id: animBG2In
            ScriptAction {
                script: { console.log("Inside animBG2In, 1/2:", bgRect.bgImage1, bgRect.bgImage2); }
            }
            ParallelAnimation {
                NumberAnimation {
                    target: bgRect.bgImage2
                    property: "opacity"
                    to: 1.0
                    duration: 500
                }
                NumberAnimation {
                    target: bgRect.bgImage1
                    property: "opacity"
                    to: 0
                    duration: 500
                }
            }
            ScriptAction {
                script: { bgRect.bgImage1.destroy(); bgRect.bgImage1 = null; }
            }
        }


        Component {
            id: bgImageLandscape
            Image {
                id: bgImageLPrivate
                anchors.fill: parent
                asynchronous: true
                source: backgroundModel.activeWallpaper
                fillMode: Image.PreserveAspectCrop
                opacity: 0.0

                Component.onCompleted: {
                    sourceSize.height = bgRect.height;
                    rotation = (window.orientation == 1) ? 0 : 180;
                }
            }
        }

        Component {
            id: bgImagePortrait
            Image {
                id: bgImagePPrivate
                asynchronous: true
                source: backgroundModel.activeWallpaper
                opacity: 0.0
                anchors.fill: parent
                height: bgRect.width
                width: bgRect.height
                fillMode: Image.PreserveAspectCrop

                Component.onCompleted: {
                    sourceSize.height = bgRect.width;
                    rotation = (window.orientation == 2) ? 270 : 90;
                }
            }
        }
    }

    Image {
        opacity: 0
        source: "image://themedimage/widgets/apps/panels/panel-background"
        width: sourceSize.width
        height: sourceSize.height
        asynchronous: false
        onStatusChanged: {
            if ((status == Image.Ready) && visible) {
                panelSize.baseSize = width;
                source = "";
                visible = false;
            }
        }
    }

    Item {
        id: panelSize
        property int baseSize: 0
        property int oneHalf: Math.round(baseSize/2)
        property int oneThird: Math.round(baseSize/3)
        property int oneFourth: Math.round(baseSize/4)
        property int oneSixth: Math.round(baseSize/6)
        property int oneEigth: Math.round(baseSize/8)
        property int oneTenth: Math.round(baseSize/10)
        property int oneTwentieth: Math.round(baseSize/20)
        property int oneTwentyFifth: Math.round(baseSize/25)
        property int oneThirtieth: Math.round(baseSize/30)
        property int oneSixtieth: Math.round(baseSize/60)
        property int oneEightieth: Math.round(baseSize/80)
        property int oneHundredth: Math.round(baseSize/100)

        property int panelOuterSpacing: oneTwentieth

        property int contentSideMargin: 12
        property int contentTopMargin: 8
        property int contentTitleHeight: 53
        property int contentAreaTopMargin: 8
        property int contentAreaBottomMargin: 8
        property int contentAreaSideMargin: 10
        property int primaryTileContentHeight: 124
        property int primaryTileGridVSpacing: 2
        property int primaryTileContentWidth: 204
        property int primaryTileGridHSpacing: 6
        property int primaryTileTextHeight: 36
        property int secondaryIconImageSize: 98
        property int secondaryTileGridVSpacing: 2
        property int secondaryTileGridHSpacing: 6
        property int secondaryTileTopMargin: 10
        property int tileTextLeftMargin: 15
        property int tileTextTopMargin: 15
        property int tileTextLineSpacing: 2
        property int tileListItemHeight: 63
        property int tileListItemContentHeight: 49
        property int tileListIconImageSize: 43
        property int tileListSpacing: 6
        property int serviceIconSize: 40
        property int tileFontSize: theme.fontPixelSizeNormal
        property string fontFamily: theme.fontFamily
        property int timestampFontSize: theme.fontPixelSizeSmall

        property int friendpanelsCacheBuffer: 8000
    }

    Item {
        id: panelColors
        property string panelHeaderColor: theme.buttonFontColor
        property string contentHeaderColor: theme.fontColorNormal
        property string tileMainTextColor: "#2a7e98"
        property string tileDescTextColor: "#666666"
    }

    overlayItem: Item {
        id: deviceScreen        
        anchors.fill: parent

        clip: true

        ShareObj {
            id: shareObj
        }

        TopItem {
            id: topItem
        }

        ModalSpinner {
            id: spinnerContainer

            function startSpinner() {
                spinnerContainer.show();
                spinnerTimer.restart();
            }
            Timer {
                id: spinnerTimer
                interval: 6000
                repeat: false
                onTriggered: spinnerContainer.hide()
            }
            Connections {
                target: qApp
                onWindowListUpdated: spinnerContainer.hide()
            }
        }

    }
    Component {
        id: mainPage
        AppPage {
            fullContent: true
            fullScreen: true
            Item {
                id: background
                anchors.fill: parent
//                color: "black"
//                property variant backgroundImage: null
/*                Image {
                    id: backgroundImage
                    anchors.fill: parent
                    asynchronous: true
                    source: backgroundModel.activeWallpaper
                    fillMode: Image.PreserveAspectCrop
                    Component.onCompleted: {
                        sourceSize.height = background.height;
                    }
                }*/
                Component {
                    id: backgroundImageComponent
                    Image {
                        //anchors.centerIn: parent
                        anchors.fill: parent
                        asynchronous: true
                        source: backgroundModel.activeWallpaper
                        sourceSize.height: background.height
                        fillMode: Image.PreserveAspectCrop
                    }
                }
            }

            StatusBar {
                anchors.top: parent.top
                width: parent.width
                height: theme.statusBarHeight
                active: window.isActiveWindow
                backgroundOpacity: theme.panelStatusBarOpacity
            }
            Item {
                id: panelsContainer
                anchors.fill: parent
                anchors.topMargin: theme.statusBarHeight

                ListView {
                    id: allPanels
                    anchors.topMargin: panelSize.panelOuterSpacing
                    anchors.fill: parent
                    interactive: true
                    cacheBuffer: count * panelSize.baseSize
                    flickableDirection: Flickable.HorizontalFlick
                    orientation: ListView.Horizontal
                    snapMode: ListView.NoSnap
                    spacing: panelSize.panelOuterSpacing
                    property bool animationEnabled: true
                    onMovementEnded: {
                        snapMode = ListView.NoSnap
                    }
                    onMovementStarted: {
                        snapMode = ListView.SnapToItem
                    }
                    Behavior on contentX {
                        NumberAnimation { duration: 250 }
                    }
                    model:panelsModel
                    delegate: Loader {
                        id: contentLoader
                        source: path

                        height: parent.height
                        //width: 640
                        property QtObject aPanelObj: panelObj
                        property string aDisplayName: displayName
                        property int aIndex: index

                        function amIVisible() {
                            //console.log("amIVisiblePanel")
                            var minX = allPanels.visibleArea.xPosition * allPanels.contentWidth;
                            var maxX = minX + allPanels.width;
                            var myMinX = index * (item.width + panelSize.panelOuterSpacing);
                            var myMaxX = ((index+1) * (item.width + panelSize.panelOuterSpacing))-panelSize.panelOuterSpacing;
                            //console.log("amIVisiblePanel? minX: ", minX, "maxX: ", maxX);
                            //console.log("amIVisiblePanel? idx: ", index, "displayName: ", displayName, "myMinX: ", myMinX, "myMaxX: ", myMaxX);
                            if ((myMinX < minX) || (myMaxX > maxX)) {
                                //console.log("amIVisiblePanel? false");
                                return false;
                            }
                            //console.log("amIVisiblePanel? true");
                            return true;
                        }

                        Component.onCompleted: {
                            console.log("displayName: " + displayName + ", index: " + index)
                        }

                        Behavior on opacity {
                            NumberAnimation { duration:250 }
                        }

                        Behavior on x {
                            id:moveSlowly
                            enabled: allPanels.animationEnabled 
                            NumberAnimation { duration: 250}
                        }

                        Behavior on width {
                            NumberAnimation { duration:250 }
                        }

                        onOpacityChanged: {
                            if (opacity == 0) {
                            panelsModel.remove(index)
//                                    allPanels.contentWidth
//                                    = allPanels.contentWidth -(item.width + panelView.spacing)
                            }

                        }

                        Connections {
                            target: contentLoader.item
                            onVisibleOptionClicked:{
                                if (allowHide) {
                                    panelObj.IsVisible = false;
                                }
                            }
                        onFlipped: {
                            // Calculate contentX change by hand because Behavior doesn't work when
                            // using positionViewAtIndex. Assumes that all panels are same width. Is that safe?
                            //allPanels.positionViewAtIndex(index, ListView.Contain);
                            //console.log("Panel index: " + index);
                            var start = allPanels.contentX;
                            var end = start + allPanels.width
                            var panelStartsAt = index*(width + allPanels.spacing);
                            var panelEndsAt = index*(width + allPanels.spacing) + width;
                            //console.log("area: "+start+" - "+ end);
                            //console.log("panelStarts at: "+panelStartsAt+", panelEnds at: "+ panelEndsAt);
                            if (start > panelStartsAt) {
                                allPanels.contentX = panelStartsAt;
                            } else if (end < panelEndsAt){
                                allPanels.contentX = start + (panelEndsAt - end);
                            }
                        }

                            onDraggingFinished:{
                                console.log("------------oldIdx: " + oldIndex + ", newIdx: " + newIndex)
                                panelsModel.move(oldIndex, newIndex)
                            } //onDraggingFinished
                        }
                    } //Delegate - panel nloader
                }
            }
        }
    }
}

