/**
 * MButton.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH" as MSystem
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


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
        /* 자동 사라지는 사양 삭제 - 커서는 입력 창의 포커스로 표시됨 (사라지면 안됨)
         */
        idMarkerTimer.restart();
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
        x: 2
        source: ImagePath.imgFolderKeypad + "ico_marker.png"
    }

    MouseArea {
        id: idMouseArea
        anchors.fill: parent

        drag.target: idContainer
        drag.axis: Drag.XAxis
        drag.minimumX: dragRangeMarginLeft
        drag.maximumX: idTextHiddenFull.paintedWidth + dragRangeMarginRight

        onReleased: {
            sigMarkerPositionRelease(idContainer.x - dragRangeMarginLeft);
            startTimer();
        }

        onPositionChanged: {
            if(false ==  invokeSignal) {
                // 좌표보정에 의해 position이 변경될 경우 다시 호출되므로 무시함
                invokeSignal = true;
            } else {
                sigMarkerPositionChange(idContainer.x - dragRangeMarginLeft);
                stopTimer();
            }
        }
    }

    /* Hidden text for paintedWidth
     */
    Text {
        id: idTextHiddenFull
        text: hiddenText
        height: hiddenHeight
        width: 1000

        font.pointSize: hiddenFontSize
        font.family: stringInfo.fontFamilyRegular    //"HDR"

        visible: false

        onTextChanged: {
            idMouseArea.drag.maximumX = idTextHiddenFull.paintedWidth + dragRangeMarginLeft;

            if(dragRangeLimit + dragRangeMarginLeft < idMouseArea.drag.maximumX) {
                idMouseArea.drag.maximumX = dragRangeLimit +  dragRangeMarginLeft;
            }
        }
    }

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
/* EOF */
