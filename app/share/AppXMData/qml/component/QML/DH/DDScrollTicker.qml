/**

* /QML/DH/DDScrollTicker.qml

*

*/

import QtQuick 1.1

import "../../XMData" as XM

Item
{
    id: idScrollTickerContainer
    clip: tickerFocus
    x: parent.x; y: parent.y
    width: parent.width
    height: parent.height
    // PROPERTIES
    property bool tickerEnable: false           // Ticker 사용 유무
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
    property bool checkDRSStatus: idAppMain.isDRSChange
    property int overTextPaintedWidth: idDummyText.paintedWidth - idScrollTickerContainer.width//idTickerFollowingText.paintedWidth > idTickerText.width
    signal tickerTextEnd();
    signal doCheckTickerForTextChanged();

    Component.onCompleted: {
        isFullLoaded = true;
        doCheckAndStartAnimation();
    }

    onCheckDRSStatusChanged: {
        if(isFullLoaded)
            doCheckAndStartAnimation();
    }

    onTickerFocusChanged: {
        if(isFullLoaded)
            doCheckAndStartAnimation();
    }

    onVisibleChanged: {
        if(isFullLoaded)
            doCheckAndStartAnimation();
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
        visible: idTickerAnimation.running
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
    }

    // Dummy Text For Get Text Real Width
    Text {
        id: idDummyText
        text: idTickerText.text
        font.family: idTickerText.font.family
        font.pixelSize: idTickerText.font.pixelSize
//        font.bold: idTickerText.font.bold
        verticalAlignment: idTickerText.verticalAlignment
        horizontalAlignment: idTickerText.horizontalAlignment
        visible: false
        onTextChanged: {
            if(isFullLoaded)
            {
                doCheckAndStartAnimation();
                doCheckTickerForTextChanged();
            }
        }
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
        ScriptAction{script: tickerTextEnd();}
        PauseAnimation { duration: 1500 }
    }

    function doCheckAndStartAnimation(){
        if(tickerFocus && tickerEnable && idDummyText.paintedWidth > idScrollTickerContainer.width && idAppMain.isDRSChange != true && visible == true)
        {
//do animate
            if(idTickerAnimation.running == true)
            {
                idTickerAnimation.stop();
                idTickerAnimation.start();
                idTickerAnimation.running = false;

                idTickerText.x = 0;
                idTickerText.width = idScrollTickerContainer.width;
                idTickerText.elide = Text.ElideRight
                idTickerText.horizontalAlignment = horizontalAlignment;
            }

            idTickerText.elide = Text.ElideNone
            idTickerText.horizontalAlignment = Text.AlignLeft
            idTickerText.width = idDummyText.paintedWidth;

            tickerDuration = Math.floor(Math.abs(idDummyText.paintedWidth + tickerMargin) * 20)//[common rule change - 2013.11.12]
            idTickerAnimation.start();
        }
        else
        {
            idTickerAnimation.stop();
            idTickerAnimation.start();
            idTickerAnimation.running = false;

            idTickerText.x = 0;
            idTickerText.width = idScrollTickerContainer.width;
            idTickerText.elide = Text.ElideRight
            idTickerText.horizontalAlignment = horizontalAlignment;
        }
    }
}

/* EOF*/
