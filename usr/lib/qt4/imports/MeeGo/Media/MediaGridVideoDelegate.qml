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
    property int mcount
    property int mlength
    property string martist
    property string maddedtime

    property bool misvirtual: (type != 1)?isvirtual:false

    mtitle:{
        try {
            return title
        }
        catch(err){
            return ""
        }
    }

    mlength:{
        try {
            return length
        }
        catch(err){
            return 0
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

    mcount: {
        try {
            return tracknum;
        }
        catch(err) {
            return 0
        }
    }

    martist: {
        var a;
        try {
            a = artist
        }
        catch(err) {
            a = ""
        }
        a[0]== undefined ? "" : a[0]
    }

    maddedtime: {
        try {
            return addedtime;
        }
        catch(err) {
            return ""
        }
    }

    Item {
        id:horizontalLine
        height: 6
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        visible: dinstance.y > 0 //gridView.contentY
        Item {
            height: 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            Rectangle {
                id: spaceLineDark
                // TODO: Use defined values from theme
                color: "#cbc9c9"//separatorDarkColor
                opacity: 1.0 //separatorDarkAlpha
                height: 1
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
            }
            Rectangle {
                id: spaceLineLight
                // TODO: Use defined values from theme
                color: "#FFFFFF"//separatorLightColor
                opacity: 1.0 //separatorLightAlpha
                height: 1
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }
    }

    Image {
        id: content
        width: 214
        height: 138

        anchors.top: horizontalLine.bottom
        anchors.topMargin: 10
        anchors.left: parent.left

        asynchronous: true

        Item {
                id: wrapper
                anchors.fill: parent
                anchors.topMargin: 5
                anchors.bottomMargin: 9
                anchors.leftMargin: 4
                anchors.rightMargin: 4
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
        Image {
            z: 10
            anchors.fill: parent
            source: "image://themedimage/widgets/apps/media/tile-border-videos"
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
    Column {
        id: textBackground
        width: parent.width - content.width - 5
        height: 138
        opacity: theme_mediaGridTitleBackgroundAlpha
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        z: 1
        Text {
            id: titleText
            text: mtitle
            width: parent.width
            wrapMode: Text.Wrap
            font.pixelSize: theme_fontPixelSizeNormal
            font.bold: true
            color: theme_fontColorHighlight
        }
        Text {
            id: durationText
            text: (formatMinutes(length)==1)?qsTr("%1 Minute").arg(formatMinutes(length)):qsTr("%1 Minutes").arg(formatMinutes(length))
            font.pixelSize: theme_fontPixelSizeNormal
            width: titleText.width
            elide: Text.ElideRight
            color: theme_fontColorMedium
        }
    }
}



