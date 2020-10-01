/**

* /QML/DH/DDScrollTicker.qml

*

*/

import QtQuick 1.1

Item
{
    id: idScrollTickerContainer
    clip: true
    x: parent.x; y: parent.y
    width: parent.width
    height: parent.height
    // PROPERTIES
    property bool tickerEnable: true           // Ticker 사용 유무
    property bool tickerFocus: false
    property real tickerDuration: 0
    property int tickerMargin: 120
    property alias text: idTickerText.text
    property alias color: idTickerText.color
    property alias fontFamily: idTickerText.font.family
    property alias fontSize: idTickerText.font.pixelSize
    property alias fontBold: idTickerText.font.bold
    property alias verticalAlignment: idTickerText.verticalAlignment
    property int horizontalAlignment: Text.AlignHCenter
    property int textPaintedWidth: idDummyText.paintedWidth > width ? width : idDummyText.paintedWidth
    property bool isFullLoaded: false
    property bool   overTextPaintedWidth: idDummyText.paintedWidth > idScrollTickerContainer.width ? true : false;
    signal tickerTextEnd();

    Component.onCompleted: {
        isFullLoaded = true;
        doCheckAndStartAnimation();
    }

    onWidthChanged: {
        idTickerText.width = idScrollTickerContainer.width
        idTickerFollowingText.width = idScrollTickerContainer.width
        idDummyText.width = idScrollTickerContainer.width
        if(isFullLoaded)
            doCheckAndStartAnimation();
    }

    onTickerFocusChanged: {
        if(isFullLoaded)
            doCheckAndStartAnimation();
    }

    onTextChanged: {
        idTickerText.x = 0;
        textSlideTimer.stop()
        idTickerAnimation.stop()
        idTickerText.elide = (tickerFocus == true)? Text.ElideNone : Text.ElideRight;
        if(isFullLoaded)
        {
            textSlideTimer.start()
        }
    }

    /* Widgets */
    // 앞에가는 문자열
    Text {
        id: idTickerText
        x: 0
        width: parent.width
        height:  parent.height
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: true
    }

    // 뒤따라오는 문자열
    Text {
        id: idTickerFollowingText
        visible: tickerFocus
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height:  parent.height
        text: idTickerText.text
        font.family: idTickerText.font.family
        font.pixelSize: idTickerText.font.pixelSize
        color: idTickerText.color
        verticalAlignment: idTickerText.verticalAlignment
        horizontalAlignment: idTickerText.horizontalAlignment
        anchors.left: idTickerText.right
        // 앞 문자열 + 120(문자열간 공간) + 뒷 문자열
        anchors.leftMargin: tickerMargin
        onXChanged:{
            if(idTickerFollowingText.x == 0)
            {
                if(idAppMain.gDriverRestriction == false)
                {
                    tickerTextEnd();
                }
            }
        }
    }

    // Dummy Text For Get Text Real Width
    Text {
        id: idDummyText
        text: idTickerText.text
        width: idTickerText.width
        height: idTickerText.height
        font.family: idTickerText.font.family
        font.pixelSize: idTickerText.font.pixelSize
        verticalAlignment: idTickerText.verticalAlignment
        horizontalAlignment: idTickerText.horizontalAlignment
        visible: false
    }

    /* ANIMATIONS */
    SequentialAnimation {
        id: idTickerAnimation
        running: false
        loops : Animation.Infinite
        /* 일단 1초 쉬고, 스크롤, 1.5초 쉬고 다음번 시작때 1초를 더 쉬니까
         * 스크롤과 스크롤 사이에 2.5sec 쉬는 것처럼 동작함
         */
        PauseAnimation { duration: 1000;}
        NumberAnimation {
            target: idTickerText
            property: "x"
            from: 0
            to: -(idDummyText.paintedWidth + tickerMargin)
            duration: tickerDuration
        }
        PauseAnimation { duration: 1500 }
    }

    function doCheckAndStartAnimation(){
        //        console.log("doCheckAndStartAnimation::"+tickerFocus+","+tickerEnable+","+idDummyText.paintedWidth+","+idScrollTickerContainer.width)
        if(tickerFocus && tickerEnable && (idAppMain.gDriverRestriction == false) && idDummyText.paintedWidth > idScrollTickerContainer.width)
        {
            //do animate
            if(idTickerAnimation.running == false)
            {
                idTickerText.elide = Text.ElideNone
                idTickerText.horizontalAlignment = Text.AlignLeft
                idTickerText.width = idDummyText.paintedWidth;

                tickerDuration = Math.floor(Math.abs(idDummyText.paintedWidth + tickerMargin) * 20)
                idTickerAnimation.start();
            }
        }
        else
        {
            idTickerAnimation.complete();
            idTickerAnimation.stop();
            idTickerAnimation.running = false;

            idTickerText.x = 0;
            idTickerText.width = idScrollTickerContainer.width;
            idTickerText.elide = Text.ElideRight
            idTickerText.horizontalAlignment = horizontalAlignment;
        }
    }

    Connections{
        target: UIListener
        onDriverRestrictionFlag: {
            //console.log("driverRestrictionFlag = "+bDriverRestriction);
            doCheckAndStartAnimation();
        }
    }

    Timer {
        id: textSlideTimer
        interval: 500
        repeat: false
        running: false
        triggeredOnStart: true
        onTriggered: {
            doCheckAndStartAnimation()
        }
    } // End Timer
}
