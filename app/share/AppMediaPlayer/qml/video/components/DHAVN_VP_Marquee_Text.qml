// { modified by Sergey 12.12.2013 for ITS#208592
import QtQuick 1.1


Item
{
    id: root

    height: scrollText.height
    clip: true

    property alias text: scrollText.text
    property alias font: scrollText.font
    property alias color: scrollText.color
    property alias fontSize: scrollText.font.pointSize
    property alias fontFamily: scrollText.font.family
    property alias style: scrollText.style
    property alias styleColor: scrollText.styleColor
    property alias textItem: scrollText
    property alias horizontalAlignment: scrollText.horizontalAlignment
    property int scrollTextGap: 120
    property bool east: EngineListenerMain.middleEast


    states: [
        State
        {
            name: "normal"

            AnchorChanges { target: scrollText; anchors.left: parent.left; anchors.right: undefined }
            PropertyChanges { target: scrollText; anchors.leftMargin: 0 }

            AnchorChanges { target: scrollTwinText; anchors.left: scrollText.left; anchors.right: undefined }
            PropertyChanges { target: scrollTwinText; anchors.leftMargin: scrollText.paintedWidth + root.scrollTextGap }
        },
        State
        {
            name: "east"

            AnchorChanges { target: scrollText; anchors.left: undefined; anchors.right: parent.right }
            PropertyChanges { target: scrollText; anchors.rightMargin: 0 }

            AnchorChanges { target: scrollTwinText; anchors.left: undefined; anchors.right: scrollText.right }
            PropertyChanges { target: scrollTwinText; anchors.rightMargin: scrollText.paintedWidth + root.scrollTextGap }
        }
    ]


    Component.onCompleted:
    {
        state = east ? "east" : "normal";
        scrollAnim.bEast = east;
    }

    onVisibleChanged:
    {
        if(visible && !scrollAnim.running && EngineListener.getScrollingTicker()
                && (EngineListener.getStringWidth(text, font.family, font.pointSize) > root.width))
            scrollAnim.start();
    }

    onEastChanged:
    {
        scrollAnim.stop();
        root.state = east ? "east" : "normal"
        scrollAnim.bEast = east;

        if(EngineListener.getScrollingTicker() && (EngineListener.getStringWidth(text, font.family, font.pointSize) > root.width))
        {
            scrollAnim.start()
        }
    }


    Text
    {
        id: scrollText

        elide: EngineListener.getScrollingTicker() ? Text.ElideNone : Text.ElideRight

        onTextChanged:
        {
            scrollAnim.stop()

            if(EngineListener.getScrollingTicker() && (EngineListener.getStringWidth(text, font.family, font.pointSize) > root.width))
            {
                scrollAnim.start()
            }
        }
    }


    Text
    {
        id: scrollTwinText

        anchors.top: scrollText.top
        anchors.bottom: scrollText.bottom
        visible: scrollAnim.running
        text: visible ? scrollText.text : ""
        font.pointSize: root.fontSize
        color: root.color
        font.family: root.fontFamily
        style: root.style
        styleColor: root.styleColor
    }


    SequentialAnimation
    {
        id: scrollAnim

        property bool bEast: false

        running: false
        loops: Animation.Infinite

        onRunningChanged:
        {
            if(!running)
            {
                if(scrollAnim.bEast)
                    scrollText.anchors.rightMargin = 0;
                else
                    scrollText.anchors.leftMargin = 0;
            }
        }

        PauseAnimation { duration: 1000 }
        PropertyAnimation
        {
            target: scrollText
            property: scrollAnim.bEast ? "anchors.rightMargin" : "anchors.leftMargin"
            to: -(scrollText.paintedWidth + root.scrollTextGap)
            duration: (scrollText.paintedWidth + root.scrollTextGap)/50 * 1000
        }
        PauseAnimation { duration: 100 }
        PropertyAction { target: scrollText; property: scrollAnim.bEast ? "anchors.rightMargin" : "anchors.leftMargin"; value: 0 }
    }
}
// } modified by Sergey 12.12.2013 for ITS#208592
