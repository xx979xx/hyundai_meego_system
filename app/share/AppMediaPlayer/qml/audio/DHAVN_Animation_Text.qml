import QtQuick 1.1

Item
{
    id: root
    clip: true
    height: masterText.height

    // { added by cychoi 2015.10.06 for ISV 119679
    LayoutMirroring.enabled: EngineListenerMain.middleEast
    LayoutMirroring.childrenInherit: EngineListenerMain.middleEast
    // } added by cychoi 2015.10.06

    signal runningFinished();

    property alias text : masterText.text
    property alias font : masterText.font
    property alias style : masterText.style
    property alias color : masterText.color
    property alias loops : scrollStartAni.loops

    property bool scrolling : false
    property bool scrollable : false
    property int horizontalAlignment : Text.AlignLeft
    property int scrollingTextMargin: 120
    property int fullPaintedWidth : 0
    property bool isUpdating: false

    function updateState()
    {
        root.isUpdating = true;
        if(scrollStartAni.running)
        {
            scrollStartAni.complete();
            scrollStartAni.running = false;
        }
        root.fullPaintedWidth = EngineListener.getStringWidth(text, font.family, font.pointSize);
        root.scrollable = (root.fullPaintedWidth > root.width)
        if(scrollable && scrolling)
        {
            scrollStartAni.restart();
        }
        root.isUpdating = false;
    }

    onScrollingChanged: updateState();

    Text
    {
        id: masterText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        horizontalAlignment: root.scrollable ? Text.AlignLeft : root.horizontalAlignment
        elide: (root.scrollable && root.scrolling == false)?
               ( EngineListenerMain.middleEast ?  Text.ElideLeft : Text.ElideRight)
               : Text.ElideNone

        onPaintedWidthChanged: updateState();
    }

    Text
    {
        id: slaveText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: masterText.left
        anchors.leftMargin: masterText.paintedWidth + scrollingTextMargin
        font.pointSize: masterText.font.pointSize
        color: masterText.color
        text: visible ? masterText.text : ""
        visible: scrollable && scrolling
        font.family: masterText.font.family
    }

    SequentialAnimation
    {
        id: scrollStartAni
        running: false
        loops: Animation.Infinite
        PauseAnimation { duration: 1000 }
        PropertyAnimation
        {
            target: masterText
            property: "anchors.leftMargin"
            to: -(fullPaintedWidth + scrollingTextMargin)
            duration: (fullPaintedWidth + 120)/50 * 1000
        }
        PauseAnimation { duration: 1500 }
        PropertyAction { target: masterText; property: "anchors.leftMargin"; value: 0 }

        onRunningChanged:
        {
            if(!running && !root.isUpdating)
                runningFinished();
        }
    }
}
