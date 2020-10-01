import QtQuick 1.1

Item
{
    id: root
    clip: true
    height: originText.height

    property alias text: originText.text
    property string fontFamily: ""
    property int fontSize : 40
    property int fontStyle : Text.Normal
    property color color: "#FAFAFA"
    property int scrollingTextMargin: 120
    property bool scrollingTicker: false
    property bool leftAlide: EngineListener.middleEast

    function setElide(){
        originText.elide = Text.ElideNone
        if ( scrollingTicker && (originText.paintedWidth > width) )
            originText.elide = Text.ElideNone
        else
            originText.elide = (leftAlide ? Text.ElideLeft : Text.ElideRight)
    }

    function controlMarquee() {
        setElide()

        if(scrollingTicker)
        {
            if(originText.elide == Text.ElideNone)
            {
                scrollStartAni.running = true
            }
            else
            {
                scrollStartAni.running = false
                originText.anchors.leftMargin = 0
            }
        }
        else
        {
            scrollStartAni.running = false
            originText.anchors.leftMargin = 0
        }
    }

    Text {
        id: originText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: fontSize
        color: root.color
        text: parent.text
        width: parent.width
        horizontalAlignment: Text.AlignLeft
        elide: (leftAlide ? Text.ElideLeft : Text.ElideRight )

        style: fontStyle

        onWidthChanged:
        {
            if ( scrollingTicker ){
                originText.elide = Text.ElideNone
                if ( originText.paintedWidth > width ){
                    originText.elide = (leftAlide ? Text.ElideLeft : Text.ElideRight )
                    originText.elide = Text.ElideNone
                    if ( !scrollStartAni.running) 
                        scrollStartAni.running = true
                }
                else {
                    originText.elide = (leftAlide ? Text.ElideLeft : Text.ElideRight)
                    scrollStartAni.running = false
                    originText.anchors.leftMargin = 0
                }
            }
        }

        Component.onCompleted: {
            controlMarquee()
        }

        font.family: fontFamily
        // { modified by cychoi 2014.04.06 for ITS 224876 list marquee on AudoTrackChanged //{added for ITS 224876
        onFontChanged:
        {
            scrollStartAni.running = false
            originText.anchors.leftMargin = 0

            if(scrollingTicker && (originText.elide == Text.ElideNone) && (originText.paintedWidth > width))
            {
                scrollStartAni.running = true
            }
            else
            {
                scrollStartAni.running = false
                originText.anchors.leftMargin = 0
            }
        }
        // } modified by cychoi 2014.04.06 //}added for ITS 224876
    }

    Text {
        id: scrollText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: originText.left
        anchors.leftMargin: originText.paintedWidth + scrollingTextMargin
        font.pointSize: fontSize
        color: root.color
        text: visible ? originText.text : ""
        visible: scrollingTicker && scrollStartAni.running
        font.family: fontFamily
    }

    SequentialAnimation
    {
        id: scrollStartAni
        running: false
        loops: Animation.Infinite
        PauseAnimation { duration: 1000 }
        PropertyAnimation {
            target: originText
            property: "anchors.leftMargin"
            to: -(originText.paintedWidth + scrollingTextMargin)
            duration: (originText.paintedWidth + 120)/50 * 1000
        }
        PauseAnimation { duration: 1500 }
        PropertyAction { target: originText; property: "anchors.leftMargin"; value: 0 }
    }

    onScrollingTickerChanged:
    {
        controlMarquee()
    }
}
