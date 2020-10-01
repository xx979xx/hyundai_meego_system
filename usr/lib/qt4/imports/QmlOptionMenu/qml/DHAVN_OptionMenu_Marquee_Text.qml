import QtQuick 1.1
import "DHAVN_OptionMenu.js" as CONST //added by aettie 20130906 for text scroll

Item
{
    id: root
    clip: true
    height: originText.height

    //property string text: ""
    property alias text: originText.text
    property string fontFamily: ""
    property int fontSize : 40
    property int fontStyle : Text.Normal
    property color color: "#FAFAFA"
    property int scrollingTextMargin: 120
    property bool scrollingTicker: false
    property bool updateElide: true


    Text {
        id: originText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: fontSize
        color: root.color
        text: parent.text
        width: parent.width
        horizontalAlignment: Text.AlignLeft
        elide: !updateElide ? Text.ElideNone : (!scrollingTicker && (paintedWidth > width) ) ? Text.ElideRight : Text.ElideNone
        style: fontStyle

        onElideChanged:
        {
            if(scrollingTicker)
            {
                if(originText.elide == Text.ElideNone)
                {
                    scrollStartAni.running = true
                }
            }
            else
            {
                scrollStartAni.running = false
                originText.anchors.leftMargin = 0
            }
        }

        onTextChanged:
        {
            scrollStartAni.running = false
            originText.anchors.leftMargin = 0

            updateElide = false
            updateElide = true

            if(scrollingTicker && (originText.elide == Text.ElideNone) && (paintedWidth > width) )
            {
                scrollStartAni.running = true
            }
            else
            {
                scrollStartAni.running = false
                originText.anchors.rightMargin = 0
            }
        }

        font.family: fontFamily
    }

    Text {
        id: scrollText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: originText.left
        anchors.leftMargin: originText.paintedWidth + scrollingTextMargin
        font.pointSize: fontSize
        color: root.color
        text: visible ? originText.text : ""
        visible: scrollStartAni.running
        font.family: fontFamily
    }

    SequentialAnimation
    {
    //modified by aettie 20130905 for text scroll time
        id: scrollStartAni
        running: false
        loops: Animation.Infinite
        PauseAnimation { duration: 1000 }//2500 }
        PropertyAnimation {
            target: originText
            property: "anchors.leftMargin"
            to: -(originText.paintedWidth + scrollingTextMargin)
	    //modified by aettie 20130906 for text scroll
            duration: (originText.paintedWidth + CONST.const_OPTION_MENU_TEXT_MID_MARGIN)/CONST.const_OPTION_MENU_TEXT_PIXEL_PER_SEC * CONST.const_OPTION_MENU_TEXT_SEC
        }
        PauseAnimation { duration: 100 }
        PropertyAction { target: originText; property: "anchors.leftMargin"; value: 0 }
    }


    Timer
    {
        running: scrollingTicker
        interval: 1000
        triggeredOnStart: false
        onTriggered:
        {
            if(scrollingTicker && (originText.elide == Text.ElideNone) && (originText.paintedWidth > width) )
            {
                scrollStartAni.running = true
            }
            else
            {
                scrollStartAni.running = false
                originText.anchors.rightMargin = 0
            }
        }
    }
}
