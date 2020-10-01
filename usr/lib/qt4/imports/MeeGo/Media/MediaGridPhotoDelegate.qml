import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Media 0.1

Item {
    id: dinstance
    width: gridView.cellWidth
    height: gridView.cellHeight

    property int mindex: index
    property string mtitle
    property string malbum
    property string muri: uri
    property string murn: urn
    property string mthumburi
    property string mitemid
    property int mitemtype
    property bool mfavorite
    property string maddedtime

    mtitle:{
        try {
            return title
        }
        catch(err){
            return ""
        }
    }

    mthumburi:{
        try {
            if (thumburi == "" | thumburi == undefined)
                return defaultThumbnail
            else
                return thumburi
        }
        catch(err){
            return defaultThumbnail
        }
    }

    malbum:{
        try {
            return album;
        }
        catch(err) {
            return ""
        }
    }

    mitemid:{
        try {
            return itemid;
        }
        catch(err) {
            return ""
        }
    }

    mitemtype:{
        try {
            return itemtype
        }
        catch(err) {
            return -1
        }
    }

    mfavorite: {
        try {
            return favorite;
        }
        catch(err) {
            return false
        }
    }

    maddedtime: {
        try {
            return addedtime;
        }
        catch(err) {
            return ""
        }
    }

    Image {
        width: 104
        height: width
        anchors.centerIn: parent

        asynchronous: true

        BorderImage {
            id: thumbnailClipper
            anchors.fill:parent
            z: -10
            asynchronous: true

            source: borderImageSource
            border.top: borderImageTop
            border.bottom: borderImageBottom
            border.left: borderImageLeft
            border.right: borderImageRight

            Item {
                id: wrapper
                anchors.fill: parent
                anchors.topMargin: thumbnailClipper.border.top - borderImageInnerMargin
                anchors.bottomMargin: thumbnailClipper.border.bottom - borderImageInnerMargin
                anchors.leftMargin: thumbnailClipper.border.left - borderImageInnerMargin
                anchors.rightMargin: thumbnailClipper.border.right - borderImageInnerMargin
                transformOrigin: Item.Center
                rotation: extension.orientation * 90

                Image {
                    id: thumbnail
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: mthumburi
                    smooth: !gridView.moving
                    clip: true
                    asynchronous: true
                    z: 0

                    Rectangle {
                        id: fog
                        anchors.fill: parent
                        color: "white"
                        opacity: 0.25
                        visible: false
                    }
                }

                ImageExtension {
                    id: extension
                    source: muri
                }
            }
            Item {
                id: frame
                anchors.fill: wrapper
                z: 2
                visible: false
                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: 0.7
                }
                Image {
                    id: tick
                    asynchronous: true
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    source: "image://themedimage/widgets/apps/media/photo-selected-tick"
                }
            }
        }

        MouseArea {
            id: mouseArea

            anchors.fill:parent

            onClicked:{
                container.clicked(mouseX,mouseY, dinstance);
            }
            onPressAndHold: {
                container.longPressAndHold(mouseX,mouseY,dinstance);
            }
            onDoubleClicked: {
                container.doubleClicked(mouseX,mouseY,dinstance);
            }
            onReleased: {
                container.released(mouseX,mouseY,dinstance);
            }
            onPositionChanged: {
                container.positionChanged(mouseX,mouseY,dinstance);
            }
        }

        states: [
            State {
                name: "normal"
                when: !selectionMode && !mouseArea.pressed
                PropertyChanges {
                    target: frame
                    visible: false
                }
            },
            State {
                name: "feedback"
                when: !selectionMode && mouseArea.pressed
                PropertyChanges {
                    target: fog
                    visible: true
                }
            },
            State {
                name: "selectionNotSelected"
                when: selectionMode && !gridView.model.isSelected(itemid)
                PropertyChanges {
                    target: frame
                    visible: false
                }
            },
            State {
                name: "selectionSelected"
                when: selectionMode && gridView.model.isSelected(itemid)
                PropertyChanges {
                    target: frame
                    visible: true
                }
            }
        ]
    }
}

