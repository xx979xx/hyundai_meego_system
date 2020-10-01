import QtQuick 1.1

Item {
    id: scrollingTicker
    clip: true

    property string text: ""
    property string fontFamily: ""
    property int fontPointSize : 40
    property int fontStyle : Text.Normal
    property color fontColor: "#FAFAFA"
    property int scrollingTextMargin: 0
    property bool isScrolling: false
    property bool updateElide: true

    Text {
        id: originText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: fontPointSize
        color: fontColor
        text: parent.text
        width: parent.width
        horizontalAlignment: Text.AlignLeft
        elide: !updateElide ? Text.ElideNone :
                (!isScrolling && (paintedWidth > width) ) ? Text.ElideRight : Text.ElideNone
        style: fontStyle
        //styleColor: "black"
        onElideChanged:
        {
            if(isScrolling)
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

        onTextChanged: {
            scrollStartAni.running = false
            originText.anchors.leftMargin = 0

            updateElide = false
            updateElide = true

            if(isScrolling && (originText.elide == Text.ElideNone) && (paintedWidth > width) )
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
        font.pointSize: fontPointSize
        color: fontColor
        text: visible ? parent.text : ""
        visible: scrollStartAni.running
        font.family: fontFamily
    }

    SequentialAnimation
    {
        id: scrollStartAni
        running: false
        loops: Animation.Infinite
        PauseAnimation { duration: 100 }
        PropertyAnimation {
            target: originText
            property: "anchors.leftMargin"
            to: -(originText.paintedWidth + scrollingTextMargin)
            duration: Math.floor( Math.abs(originText.paintedWidth + scrollingTextMargin) * 10)
            // 0.01초에 1픽셀 이동 -> 1초에 100픽셀 이동
            // Scroll되어야 할 길이 = 실제 Text의 길이 + 120(Scroll Text간 간격)
        }
        PauseAnimation { duration: 2500 }
        PropertyAction { target: originText; property: "anchors.leftMargin"; value: 0 }
    }
}

