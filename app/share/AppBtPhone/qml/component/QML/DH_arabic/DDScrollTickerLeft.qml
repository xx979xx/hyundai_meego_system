/**
 * /QML/DH_arabic/DDScrollTicker.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH" as MSystem


Item
{
    id: idScrollTickerContainer
    clip: true
    state: "TICKER_STATE_OFF"

    // PROPERTIES
    property bool tickerEnable: false           // Ticker 사용 유무
    property bool tickerAvailable: false        // Scrolling의 가능유무
    property bool tickerFocus: false
    property real tickerDuration: 0
    property int tickerMargin: 120

    // 버튼에서 두번째 Text확인 코드
    property bool tickerSecondText: false

    property string tickerText: ""
    property alias color: idTickerText.color
    property alias fontFamily: idTickerText.font.family
    property alias fontSize: idTickerText.font.pointSize
    property alias verticalAlignment: idTickerText.verticalAlignment
    property alias horizontalAlignment: idTickerText.horizontalAlignment


    /* INTERNAL functions */
    function setFocus(focus) {
        if(tickerFocus != focus) {
            tickerFocus = focus;
        }
    }

    function refresh() {
        // 유사 코드가 onCompleted()에 존재함, Animation ON/OFF만 다름
        if(false == tickerEnable) {
            // do nothing
            return;
        }

        if(true == idTickerAnimation.running) {
            // idTickerAnimation.complete()을 쓰면 비정상동작, 문구가 긴 언어에서 짧은 언어로 전환할때 Animation 멈추는 위치 오류 등
            idTickerAnimation.stop();
            idTickerText.x = tickerItem.width - idTickerText.paintedWidth;
        }


        if(idTickerText.paintedWidth > idScrollTickerContainer.width) {
            // 버튼에서 두번째 Text확인 코드
            if(false == tickerSecondText) {
                tickerDuration = Math.floor(Math.abs(idTickerText.paintedWidth + tickerMargin) * 10)
            } else if(0 == tickerDuration) {
                tickerDuration = Math.floor(Math.abs(idTickerText.paintedWidth + tickerMargin) * 10)
            }
            // 0.01s 당 1px 이동

            //idTickerText.text += idTickerText.text;
            idTickerText.width = idTickerText.paintedWidth;

            tickerAvailable = true;
        } else {
            tickerAvailable = false;
        }

        if(true == tickerAvailable && state == "TICKER_STATE_START") {
            idTickerAnimation.start();
        }
    }


    /* Event handlers */
    Component.onCompleted: {
        idTickerAnimation.complete();
        if(false == tickerEnable) {
            // do nothing
            return;
        }

        if(hideenText.paintedWidth > idScrollTickerContainer.width) {
            // 0.01s 당 1px 이동
            if(false == tickerSecondText) {
                tickerDuration = Math.floor(Math.abs(idTickerText.paintedWidth + tickerMargin) * 10)
            } else if(0 == tickerDuration) {
                tickerDuration = Math.floor(Math.abs(idTickerText.paintedWidth + tickerMargin) * 10)
            }

            //idTickerText.text += idTickerText.text;
            idTickerText.width = idTickerText.paintedWidth;
            tickerAvailable = true;
        } else {
            tickerAvailable = false;
        }
    }


    Text {
        id: hideenText
        text: tickerText

        visible: false
        //width: parent.width

        horizontalAlignment: Text.AlignLeft
        //anchors.left: idMarqueeContainer.left
        font.family: idTickerText.font.family
        font.pointSize: idTickerText.font.pointSize
        color: idTickerText.color
        verticalAlignment: idTickerText.verticalAlignment

        onTextChanged: {
            refresh();
        }
    }

    onStateChanged: {
        if(false == tickerEnable || false == tickerAvailable) {
            // Scroll Ticker가 Disable되어 있거나 Enable되어 있더라도 Scrolling할 길이가 아닐때는 모든 State 변화를 무시함
            return;
        }

        switch(state) {
            case "TICKER_STATE_STOP":
                idTickerAnimation.complete();
                break;

            case "TICKER_STATE_START":
                idTickerAnimation.start();
                break;

            default:
                break;
        }
    }

    Item {
        id: tickerItem
        //anchors.right: parent.right
        width: idTickerText.width
        height: parent.height
        clip: true

        /* Widgets */
        // 앞에가는 문자열
        Text {
            id: idTickerText
            text: tickerText
            x: 0//tickerItem.width - idTickerText.paintedWidth
            visible: true
            anchors.verticalCenter: parent.verticalCenter
            //width: parent.width

            //horizontalAlignment: Text.AlignLeft
            //anchors.left: idMarqueeContainer.left

            onTextChanged: {
                refresh();

                // width가 변경되었으므로 anchor도 재설정해줘야 함
                idTickerFollowingText.anchors.right = idTickerText.left
                idTickerFollowingText.anchors.rightMargin = tickerMargin
            }
        }

        // 뒤따라오는 문자열
        Text {
            id: idTickerFollowingText
            visible: true
            anchors.verticalCenter: parent.verticalCenter
            clip: true


            text: tickerText

            font.family: idTickerText.font.family
            font.pointSize: idTickerText.font.pointSize
            color: idTickerText.color
            verticalAlignment: idTickerText.verticalAlignment
            //horizontalAlignment: Text.AlignRihgt//idTickerText.horizontalAlignment

            anchors.right: idTickerText.left
            // 앞 문자열 + 120(문자열간 공간) + 뒷 문자열
            anchors.rightMargin: tickerMargin
        }


        /* ANIMATIONS */
        SequentialAnimation {
            id: idTickerAnimation
            loops: Animation.Infinite
            running: false

            /* 일단 1초 쉬고, 스크롤, 1.5초 쉬고 다음번 시작때 1초를 더 쉬니까
             * 스크롤과 스크롤 사이에 2.5sec 쉬는 것처럼 동작함
             */
            PauseAnimation { duration: 1000 }

            PropertyAnimation {
                target: idTickerText
                property: "x"
                from: 0//tickerItem.width - idTickerText.paintedWidth
                to: 120 + tickerItem.width
                duration: tickerDuration
            }

            PauseAnimation { duration: 1500 }
        }
    }



    /* STATES */
    states: [
        State {
            name: "TICKER_STATE_OFF"
            when: (false == tickerEnable)
        }
        , State {
            name: "TICKER_STATE_START"
            when: (true == tickerFocus && true == parking)
            //PropertyChanges { target: idTickerAnimation;    running: true }
        }
        , State {
            name: "TICKER_STATE_STOP"
            when: (false == tickerFocus || false == parking)
        }
    ]
}
/* EOF*/
