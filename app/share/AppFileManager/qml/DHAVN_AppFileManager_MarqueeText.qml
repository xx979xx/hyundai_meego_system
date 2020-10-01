import QtQuick 1.1

Item
{
    id: scrolledLabel
    height: scrollText.height
    clip: true

    property bool scrollingTicker: false

    property alias text: scrollText.text
    property alias font: scrollText.font
    property alias color: scrollText.color
    // { modified by edo.lee 2012.11.29 New UX
    //property alias fontSize: scrollText.font.pixelSize
    property alias fontSize: scrollText.font.pointSize
    // { modified by edo.lee
    property alias fontFamily: scrollText.font.family

    state: "left"
    states: [
        State {
            name: "left"
            AnchorChanges {
                target: scrollText
                anchors.left: scrolledLabel.left
                anchors.right: undefined
            }
        },
        State {
            name: "right"
            AnchorChanges {
                target: scrollText
                anchors.right: (scrollText.width > scrolledLabel.width) ? scrolledLabel.right : undefined
                anchors.left: (scrollText.width > scrolledLabel.width) ? undefined : anchors.left
            }
        }
    ]

    transitions: Transition {
        ParallelAnimation {
            AnchorAnimation
            {
                targets:scrollText
                duration: scrollingTicker * Math.floor( Math.abs(scrollText.width - scrolledLabel.width) * 10)
            }
        }
    }

    Timer {
        id: scroll_timer
        repeat: true
        running: scrollingTicker && (scrollText.width > scrolledLabel.width)
        interval: Math.floor( 2500 + Math.abs(scrollText.width - scrolledLabel.width) * 10)
        onRunningChanged:
        {
            if(!running) {
                scrolledLabel.state = "left"
            }
        }

        triggeredOnStart: true
        onTriggered: {
            if(scrolledLabel.state === "left")
            {
                scrolledLabel.state = "right"
            }
            else
            {
                scrolledLabel.state = "left"
            }
        }
    }

    Text
    {
        id: scrollText
        visible: true
        width: scrollingTicker ? implicitWidth : parent.width
        elide: scrollingTicker ? Text.ElideNone : Text.ElideRight
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignLeft // added by Dmitry 03.05.13
    }
}

//{Commented by Alexey Edelev 2012.10.08
//import QtQuick 1.0
//
//Item
//{
//    id: marqueeText
//    height: scrollText.height
//    clip: true
//
//    property alias text: scrollText.text
//    property alias font: scrollText.font
//    property alias color: scrollText.color
//    property alias fontSize: scrollText.font.pixelSize
//    property alias fontFamily: scrollText.font.family
//
//    Text
//    {
//        id:scrollText
//
//        property bool isFocusedText: (StateManager.getScrollingTicker() && root.isFocusedList) ? true : false;
//
//        onIsFocusedTextChanged:
//        {
//            scrollText.x = 0;
//
//            if(isFocusedText && (StateManager.getStringWidth(StateManager.getFocusedItemName(root.focusedListIndex), font.family, font.pixelSize) > marqueeText.width))
//                marqueeTimer.restart()
//            else
//                marqueeTimer.stop()
//        }
//    }
//
//    Timer {
//        id: marqueeTimer
//        interval: 100
//        onTriggered:
//        {
//            if(scrollText.x + scrollText.width < 0)
//            {
//                scrollText.x = scrollText.parent.width;
//            }
//            scrollText.x -= 10;
//        }
//        repeat: true
//    }
//}
//}Commented by Alexey Edelev 2012.10.08
