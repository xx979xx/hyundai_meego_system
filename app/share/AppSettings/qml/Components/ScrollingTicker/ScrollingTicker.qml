import QtQuick 1.1

Item {
    id: scrollingTicker
    clip: true

    property string text: ""
    property string fontFamily: ""
    property int fontPointSize : 40
    property int fontStyle : Text.Normal
    property string fontColor: "#FAFAFA"
    property int scrollingTextMargin: 0
    property bool isScrolling: false
    property bool updateElide: true
    property bool fontBold: false

    onFontBoldChanged: {
        scrollingTicker.fontFamily = EngineListener.getFont(fontBold)

        updateElide = false
        updateElide = true
    }

    Timer {
        id: animationStartTimer

        interval: 100

        repeat: false

        onTriggered: {
            if (originText.paintedWidth > originText.width)
                scrollStartAni.running = true
            else
            {
                scrollStartAni.running = false
                originText.anchors.rightMargin = 0
            }
        }
    }

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
                    animationStartTimer.restart()
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
                animationStartTimer.restart()
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
        PauseAnimation { duration: 900 }
        PropertyAnimation {
            target: originText
            property: "anchors.leftMargin"
            to: -(originText.paintedWidth + scrollingTextMargin)
            duration: Math.floor( Math.abs(originText.paintedWidth + scrollingTextMargin) * 20)
            // Math.abs(originText.paintedWidth + scrollingTextMargin) * 1000 / 50
            // 0.02초에 1픽셀 이동 -> 2초에 100픽셀 이동 -> 1초에 50픽셀 이동
            // Scroll되어야 할 길이 = 실제 Text의 길이 + 120(Scroll Text간 간격)
        }
        PauseAnimation { duration: 1500 }
        PropertyAction { target: originText; property: "anchors.leftMargin"; value: 0 }
    }
}
