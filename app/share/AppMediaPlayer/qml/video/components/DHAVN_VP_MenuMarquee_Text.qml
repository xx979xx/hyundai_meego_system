import QtQuick 1.1
//modified by aettie 20130906
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
    property int paintedWidth: 0 // modified by cychoi 2013.12.30 for marquee text on DVD Setting


    Text {
        id: originText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: fontSize
        color: root.color
        text: parent.text
        width: parent.width
        horizontalAlignment: Text.AlignLeft
        elide: !updateElide ? Text.ElideNone : (!scrollingTicker && (root.paintedWidth > width ) ) ? Text.ElideRight : Text.ElideNone  // modified by cychoi 2013.12.30 for marquee text on DVD Setting //modified by yungi 2013.10.21 for ITS 196374
        style: fontStyle

        // { added by cychoi 2013.12.30 for marquee text on DVD Setting
        onColorChanged:
        {
            root.paintedWidth = EngineListener.getStringWidth(originText.text, originText.font.family, originText.font.pointSize);

            // { added by cychoi 2014.06.13 for ITS 240220
            scrollStartAni.running = false
            originText.anchors.leftMargin = 0

            updateElide = false
            updateElide = true

            if(scrollingTicker && (originText.elide == Text.ElideNone) && (originText.paintedWidth > width ) ) // modified by cychoi 2013.12.30 for marquee text on DVD Setting //modified by yungi 2013.10.21 for ITS 196374
            {
                scrollStartAni.running = true
            }
            else
            {
                scrollStartAni.running = false
                originText.anchors.rightMargin = 0
            }
            // } added by cychoi 2014.06.13
        }
        // } added by cychoi 2013.12.30
            
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
            root.paintedWidth = EngineListener.getStringWidth(originText.text, originText.font.family, originText.font.pointSize); // added by cychoi 2014.04.16 for ITS 234702

            scrollStartAni.running = false
            originText.anchors.leftMargin = 0

            updateElide = false
            updateElide = true

            if(scrollingTicker && (originText.elide == Text.ElideNone) && (originText.paintedWidth > width ) ) // modified by cychoi 2013.12.30 for marquee text on DVD Setting //modified by yungi 2013.10.21 for ITS 196374
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
        PauseAnimation { duration: 1000 } //changed by junam 2013.10.15 from 2500
        PropertyAnimation {
            target: originText
            property: "anchors.leftMargin"
            to: -(originText.paintedWidth + scrollingTextMargin)

            duration: (originText.paintedWidth + 120)/50 * 1000
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
            if(scrollingTicker && (originText.elide == Text.ElideNone) && (originText.paintedWidth > width) ) // modified by cychoi 2013.12.30 for marquee text on DVD Setting //modified by yungi 2013.10.21 for ITS 196374
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

