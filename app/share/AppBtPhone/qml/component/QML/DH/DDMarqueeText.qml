/**
 * DDMarqueeTExt.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH" as MSystem


Item
{
    id: idMarqueeContainer

    // PROPERTIES
    property bool scrollingTicker: false

    property alias text: idMarqueeText.text
    //property alias font: idMarqueeText.font
    property alias color: idMarqueeText.color
    property alias fontFamily: idMarqueeText.font.family
    property alias fontSize: idMarqueeText.font.pointSize
    property alias verticalAlignment: idMarqueeText.verticalAlignment
    property alias horizontalAlignment: idMarqueeText.horizontalAlignment

    property bool marqueeEnable: false
    property int marqueeMin: 0
    property int marqueeMax: 0
    property int marqueeDuration: 0
    property int marqueeSpace: 120


    clip: false

    state: "STATE_OFF"

    function start() {
        console.log("######################################");
        console.log("START!!!!!!!!!!!!!!!");
        console.log("######################################");
        //state = "STATE_RIGHT";
        idMarqueeAnimation.start();
    }

    function stop() {
        console.log("######################################");
        console.log("STOP!!!!!!!!!!!!!!!");
        console.log("######################################");
        //state = "STATE_OFF";
        idMarqueeAnimation.stop();
    }


    /* Event handlers */
    Component.onCompleted: {
        if(true == marqueeEnable) {
            /* Text + 공백 + Text 형태로 구성
             * 24는 좌측 padding
             */
            console.log("# dMarqueeContainer.width = " + idMarqueeContainer.width);
            marqueeDuration = Math.floor(Math.abs(idMarqueeText.paintedWidth - idMarqueeContainer.width) * 10)

            marqueeMin = 24;
            marqueeMax = -idMarqueeText.paintedWidth + 24 - marqueeSpace;

            //scrollingTicker * Math.floor( Math.abs(scrollText.width - scrolledLabel.width) * 10)
            // scroll되는 텍스트 길이와 텍스트가 보여지는 리스트의 길이의 차(스크롤 되어야 하는 텍스트 부분)이 * 10 만큼의 시간 동안 이동
            // 0.01s 당 1px 이동
            //idMarqueeText.text += idMarqueeText.text;
            idMarqueeText.width = idMarqueeText.paintedWidth;

            console.log("# marqueeDuration = " + marqueeDuration);
            console.log("# text = " + idMarqueeText.text);
            console.log("# paintedWidth = " + idMarqueeText.paintedWidth);
            //idMarqueeContainer.width = idMarqueeText.width;

//            console.log("# idMarqueeText.text = " + idMarqueeText.text);
//            console.log("# idMarqueeFollowingText.text = " + idMarqueeFollowingText.text);

            //state = "STATE_LEFT";
        }
    }


    onStateChanged: {
        console.log("# state = " + state);
    }

    /* Widgets */
//    Text {
//        id: idMarqueeText
//        //width: idMarqueeText.width
//        //text: idMarqueeText.text
//        visible: true
//        clip: false

//        anchors.left: idMarqueeText.righti
//        anchors.leftMargin: 120

//        Rectangle {
//            anchors.fill: idMarqueeFollowingText
//            color: "Yellow"
//        }
//    }

    Text {
        id: idMarqueeText
        x:0
        visible: true
        anchors.verticalCenter: parent.verticalCenter
        clip: false
        width: parent.width

        //anchors.left: idMarqueeContainer.left

//        Rectangle {
//            anchors.fill: parent
//            color: "Yellow"
//        }
    }

    Text {
        id: idMarqueeFollowingText
        visible: true
        anchors.verticalCenter: parent.verticalCenter
        clip: true
        width: parent.width

        text: idMarqueeText.text

        font.family: idMarqueeText.font.family
        font.pointSize: idMarqueeText.font.pointSize
        color: idMarqueeText.color
        verticalAlignment: idMarqueeText.verticalAlignment
        horizontalAlignment: idMarqueeText.horizontalAlignment

        anchors.left: idMarqueeText.right
        anchors.leftMargin: 120

//        Rectangle {
//            anchors.fill: parent
//            color: "Orange"
//        }
    }


    /* STATES & TRANSITIONS */
    /*states: [
        State {
            name: "STATE_LEFT"

            AnchorChanges {
                target: idMarqueeText
                anchors.left: idMarqueeContainer.left
                anchors.right: undefined
            }

            PropertyChanges {
                target: idMarqueeText
                anchors.leftMargin: 0
                anchors.rightMargin: 0
            }
        }
        , State {
            name: "STATE_RIGHT"

            AnchorChanges {
                target: idMarqueeText
                anchors.left: undefined
                anchors.right: idMarqueeContainer.left
            }

            PropertyChanges {
                target: idMarqueeText
                anchors.leftMargin: 0
                anchors.rightMargin: 120    //marqueeMargin
            }
        }
        , State {
            name: "STATE_OFF"

            AnchorChanges {
                target: idMarqueeText
                anchors.left: idMarqueeContainer.left
                anchors.right: undefined
            }

            PropertyChanges {
                target: idMarqueeText
                anchors.leftMargin: 0
                anchors.rightMargin: 0
            }
        }
    ]*/

    SequentialAnimation {
        id: idMarqueeAnimation
        loops: Animation.Infinite
        running: false

        PropertyAnimation {
            target: idMarqueeText
            property: "x"
            from: 0
            to: -(idMarqueeText.paintedWidth + 120)
            duration: 2500
        }

        PauseAnimation  { duration: 2500 }
    }


//    transitions: [
//        Transition {
//            from: "STATE_LEFT"
//            to: "STATE_RIGHT"
//            AnchorAnimation { targets: idMarqueeText;    duration: marqueeDuration }
//            PauseAnimation  { duration: 2500 }
//        }
//        , Transition {
//            from: "STATE_RIGHT"
//            to: "STATE_LEFT"
//            AnchorAnimation { targets: idMarqueeText;   duration: marqueeDuration }
//            PauseAnimation  { duration: 2500 }
//        }
//        , Transition {
//            from: "STATE_LEFT"
//            to: "STATE_OFF"
//        }
//        , Transition {
//            from: "STATE_RIGHT"
//            to: "STATE_OFF"
//        }
//        , Transition {
//            from: "STATE_OFF"
//            to: "STATE_LEFT"
//            AnchorAnimation { targets: idMarqueeText;    duration: marqueeDuration }
//            PauseAnimation  { duration: 2500 }
//        }
//        , Transition {
//            from: "STATE_OFF"
//            to: "STATE_RIGHT"
//            AnchorAnimation { targets: idMarqueeText;    duration: marqueeDuration }
//            PauseAnimation  { duration: 2500 }
//        }
//    ]
}
/* EOF*/
