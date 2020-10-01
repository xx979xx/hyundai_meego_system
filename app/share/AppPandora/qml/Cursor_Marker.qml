
import QtQuick 1.1
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES

Item
{
    id: idContainer
    y: 0
    width: 42
    height: 117
    visible: (0 == opacity) ? false : true
    state: "HIDE"


    // PROPERTIES
    property int dragRangeMarginLeft: 0
    property int dragRangeMarginRight: 0
    property int dragRangeLimit: 0

    property int hiddenHeight: 0
    property int hiddenFontSize: 32
    property string hiddenText: ""
    property bool invokeSignal: false

    // SIGNALS
    signal sigMarkerPositionInit();
    signal sigMarkerPositionChange(int position);
    signal sigMarkerPositionRelease(int position);
    signal sigMarkerPositionSync(int position);


    function show(position) {
        state = "SHOW";

        // Update position
        x = position + dragRangeMarginLeft;
        sigMarkerPositionInit();

        startTimer();
    }

    function hide() {
        state = "HIDE";
        stopTimer();
    }

    function startTimer() {
        //DEPRECATED idMarkerTimer.restart();
        idMarkerTimer.restart();// added by cheolhwan 2014-01-10. Scenario Update (Keypad_Ver1.08_131210).
    }

    function stopTimer() {
        if(true == idMarkerTimer.running) {
            idMarkerTimer.stop();
        }
    }

    function syncPosition(position) {
        invokeSignal = false;

        //x = ((1 > position) ? position : position + 6) + dragRangeMarginLeft;
        x = position + dragRangeMarginLeft;
    }


    /* EVENT handlers */
    Component.onCompleted: {
    }

    Component.onDestruction: {
        idMarkerTimer.stop();
    }


    /* WIDGETS */
    Image {
        source: PR_RES.const_MARKER
    }

    MouseArea {
        id: idMouseArea
        beepEnabled: false
        anchors.fill: parent

        drag.target: idContainer
        drag.axis: Drag.XAxis
        drag.minimumX: dragRangeMarginLeft
        drag.maximumX: /*idTextHiddenFull.paintedWidth +*/ dragRangeMarginRight

        onReleased: {
            sigMarkerPositionRelease(idContainer.x - dragRangeMarginLeft);
            startTimer();
        }

        onPositionChanged: {
            if(false ==  invokeSignal) {
                invokeSignal = true;
            } else {
                sigMarkerPositionChange(idContainer.x - dragRangeMarginLeft);
                stopTimer();
            }
        }
    }

//    /* Hidden text for paintedWidth
//     */
//    Text {
//        id: idTextHiddenFull
//        text: hiddenText
//        height: hiddenHeight
//        width: 1000

//        font.pointSize: 30
//        font.family: "HDR"

//        visible: false

//        onTextChanged: {
//            idMouseArea.drag.maximumX =  dragRangeMarginLeft;

//            if(dragRangeLimit + dragRangeMarginLeft < idMouseArea.drag.maximumX) {
//                idMouseArea.drag.maximumX = dragRangeLimit +  dragRangeMarginLeft;
//            }
//        }
//    }

    Timer {
        id: idMarkerTimer
        interval: 5000
        running: false
        repeat: false

        onTriggered: {
            hide();
        }
    }

    /* STATES */
    states: [
         State {
            name: "SHOW";
            PropertyChanges { target: idContainer;   opacity: 1; }
        }
        , State {
            name: "HIDE";
            PropertyChanges { target: idContainer;   opacity: 0; }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { target: idContainer;   properties: "opacity";  duration: 500 }
        }
    ]
}
