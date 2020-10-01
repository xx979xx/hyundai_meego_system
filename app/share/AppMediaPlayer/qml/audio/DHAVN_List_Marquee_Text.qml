import QtQuick 1.1

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
    //property bool updateElide: false
    property bool leftElide: EngineListenerMain.middleEast
    property int textPaintedWidth: 0

    function setElide()
    {
        originText.elide = leftElide ? Text.ElideLeft : Text.ElideRight
        //originText.elide = Text.ElideNone
        if ( scrollingTicker && (root.textPaintedWidth > width) )
            originText.elide = Text.ElideNone
        else
            originText.elide = (leftElide ? Text.ElideLeft : Text.ElideRight)
    }
    
    function controlMarquee()
    {
        root.textPaintedWidth = EngineListener.getStringWidth(originText.text, originText.font.family, originText.font.pointSize)
        
        //updateElide = scrollingTicker;
        setElide()
        
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

    Text {
        id: originText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: fontSize
        color: root.color
        text: parent.text
        width: parent.width
        horizontalAlignment: Text.AlignLeft
        // modified by ravikanth for ITS 0189163
        //elide: !updateElide ? ( leftElide ? Text.ElideLeft : Text.ElideRight ) : Text.ElideNone
        elide: Text.ElideNone

        style: fontStyle

        // modified by ravikanth for ITS 0187237
        onWidthChanged:
        {
            controlMarquee()
        }

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
            controlMarquee()
        }

        font.family: fontFamily
        // { modified by cychoi 2014.04.06 for ITS 224876 list marquee on AutoTrackChanged //{added for ITS 224876
        onFontChanged:
        {
            controlMarquee()
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
        PauseAnimation { duration: 1000 }  //changed by junam 2013.10.15 from 2500
        PropertyAnimation {
            target: originText
            property: "anchors.leftMargin"
            to: -(originText.paintedWidth + scrollingTextMargin)
            //{changed by junam 2013.08.16 for moving 50px / sec
            //duration: (originText.paintedWidth + 120)/100 * 1000
            duration: (originText.paintedWidth + 120)/50 * 1000
            //}changed by junam
        }
        PauseAnimation { duration: 1500 } //changed by junam 2013.10.15 from 100
        PropertyAction { target: originText; property: "anchors.leftMargin"; value: 0 }
    }


    Timer
    {
        running: scrollingTicker
        interval: 1000
        triggeredOnStart: true
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
    onScrollingTickerChanged:
    {
        controlMarquee()
    }

    Component.onCompleted:
    {
        controlMarquee()
    }
}
//}changed by junam
