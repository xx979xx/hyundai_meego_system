import Qt 4.7

Item {
    id: mainArea
    width: parent.width
    height: label.height + 20

    property alias text: label.text

    signal clicked()

    Component.onCompleted: {
        var textWidth = label.width + 2 * label.anchors.leftMargin;

        if (textWidth > mainArea.parent.width) {
            mainArea.parent.width = textWidth;
        }
    }

    BorderImage {
        id: activeBackground
        anchors.fill: parent
        border.left: 5
        border.right: 5
        border.top: 5
        border.bottom: 5

        source: "image://themedimage/widgets/common/menu/menu-item-active"
        visible: mouseArea.pressed
    }

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 10
        color: mouseArea.pressed ? theme_fontColorSelected :
                                   theme_contextMenuFontColor
        font.pixelSize: theme_contextMenuFontPixelSize
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            mainArea.clicked();
        }
    }
}
