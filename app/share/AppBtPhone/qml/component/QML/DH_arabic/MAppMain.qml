/**
 * /QML/DH_arabic/MAppMain.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH" as MSystem


FocusScope
{
    id: idAppMain
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight

    // PROPERTIES
    property bool upKeyPressed:         false
    property bool downKeyPressed:       false
    property bool rightKeyPressed:      false
    property bool leftKeyPressed:       false
    property bool wheelLeftKeyPressed:  false
    property bool wheelRightKeyPressed: false
    property bool enterKeyPressed:      false

    property bool isLongKey: false

    property bool upKeyLongPressed:     false
    property bool downKeyLongPressed:   false
    property bool rightKeyLongPressed:  false
    property bool leftKeyLongPressed:   false

    // SIGNALS
    signal completed()
    signal beep()

    //focus: true;
    // Debugging for focus and key input
    /*onFocusChanged: {
        console.log(" == idAppMain focus: "+ idAppMain.focus + " activeFocus:"+ idAppMain.activeFocus);
    }*/

    Component.onCompleted: {
        completed()
    }


    Keys.onPressed: {
        switch(event.key) {
            case Qt.Key_Up:
                if(event.modifiers == Qt.ShiftModifier){

                } else {
                    //console.log("-[KEY] MAppMain Up    key Pressed--: "+event.key);
                    upKeyPressed = true;
                    upKeyLongPressed = false;
                }
                break;

            case Qt.Key_Down:
                if(event.modifiers == Qt.ShiftModifier){
                    if(true == idVisualCue.visible) {
                        if(false == menuOn){
                            downKeyLongPressed = true;
                        }
                    }
                } else {
                    //console.log("-[KEY] MAppMain Down  key Pressed--: "+event.key);
                    downKeyPressed = true;
                    downKeyLongPressed = false;
                }
                break;

            case Qt.Key_Right:
                if(event.modifiers == Qt.ShiftModifier){

                } else {
                    //console.log("-[KEY] MAppMain Right key Pressed--: "+event.key);
                    rightKeyPressed = true;
                    rightKeyLongPressed = false;
                }
                break;

            case Qt.Key_Left:
                if(event.modifiers == Qt.ShiftModifier){

                } else {
                    //console.log("-[KEY] MAppMain Left  key Pressed--: "+event.key);
                    leftKeyPressed = true;
                    leftKeyLongPressed = false;
                }
                break;

            case Qt.Key_Semicolon:
                wheelLeftKeyPressed = true;
                break;

            case Qt.Key_Apostrophe:
                wheelRightKeyPressed = true;
                break;

            case Qt.Key_Enter:
                //console.log("-[KEY] MAppMain Enter key Pressed--: "+event.key);
                enterKeyPressed = true;
                break;

            default:
                break;
        }
    }

    Keys.onReleased: {
        upKeyPressed = false;
        upKeyLongPressed = false;
        downKeyPressed = false;
        downKeyLongPressed = false;
        rightKeyPressed = false;
        rightKeyLongPressed = false;
        leftKeyPressed = false;
        leftKeyLongPressed = false;

        switch(event.key) {
            case Qt.Key_Semicolon:
                wheelLeftKeyPressed = false;
                break;

            case Qt.Key_Apostrophe:
                wheelRightKeyPressed = false;
                break;

            case Qt.Key_Enter:
                enterKeyPressed = false;
                break;

            default:
                break;
        }
    }


    property int count: 1;
    property int max_waiting_second:5
/*DEPRECATED
    Timer {
        id:idVisualCueTimer;
        interval: 1000;
        repeat: true;
        //triggeredOnStart: true;

        onTriggered: {
            //console.log("  VisualCue Timer: Triggered... count:" + count);
            if(count == max_waiting_second){
                stopTimer();
                return;
            }
            count++;
        }
        function startTimer()
        {
            count = 1;
            running = true;
        }
        function stopTimer()
        {
            running = false;
            returnToTouchMode();
        }
        function resetTimer(){
            count = 1;
        }
    }
DEPRECATED*/

    function getCount() {
        return count;
    }

/*DEPRECATED
    onKeyPressedChanged: {
        idVisualCueTimer.count = 0;
    }
DEPRECATED*/

    property string inputMode : "jog"// "jog"//
    property bool focusOn : true;
    property bool keyPressed : false;
    //signal jogModeOn();


    function isJogMode(event, isPressed) {
        if(isMenuInput(event)) {
            return true;
        }

        //idVisualCueTimer.startTimer();
        //if(inputMode == "touch"){
        if(inputMode != "jog") { //Add DMB tune mode by jyjeon
            event.accepted = true
            focusOn = true;
            if(!isPressed) { //Added by David Bae
                inputMode = "jog";
            }

            //jogModeOn();
            return false;
        } else {

            //keyPressed = !keyPressed; //Key Inputed signal.
            return true;
        }
    }

    function isTuneFocusMode() {
        //idVisualCueTimer.startTimer();
        if(inputMode != "tuneFocus") {
            inputMode = "tuneFocus";
            focusOn = true;
            return false;
        } else {
            return true;
        }
    }

    function isTouchMode() {
        if(inputMode == "touch") {
            return true;
        }

        return false;
    }

    function returnToTouchMode() {
        inputMode = "touch";
        focusOn = true;
    }

    function returnToJogMode() {
        inputMode = "jog";
        focusOn = false;
    }

    function isMenuInput(event) {
        switch(event.key) {
            case Qt.Key_I:         // Menu Key
            case Qt.Key_L:
            case Qt.Key_Slash:
            case Qt.Key_Backspace: // Back Key
            case Qt.Key_J:
            case Qt.Key_Comma:
            case Qt.Key_K:         // Home Key
            case Qt.Key_Period:
            //case Qt.Key_Home:
                return true;
        }

        return false;
    }

    function isHomeKey(event) {
        switch(event.key) {
            case Qt.Key_K:         //Home Key
            case Qt.Key_Period:
            //case Qt.Key_Home:
                return true;
        }
        return false;
    }

    function isBackKey(event) {
        switch(event.key) {
            case Qt.Key_Backspace: //Back Key
            case Qt.Key_J:
            case Qt.Key_Comma:
                return true;
        }

        return false;
    }

    function isMenuKey(event) {
        switch(event.key) {
            case Qt.Key_I:         //Menu Key
            case Qt.Key_L:
            case Qt.Key_Slash:
                return true;
        }

        return false;
    }

    function isSelectKey(event) {
        switch(event.key) {
            case Qt.Key_Return:
            case Qt.Key_Enter: {
                return true;
            }

            default:
                return false;
        }

        return false;
    }

    function isWheelLeft(event) {
        if(event.key == Qt.Key_Semicolon) {
            return true;
        }

        return false;
    }

    function isWheelRight(event) {
        if(event.key == Qt.Key_Apostrophe) {
            return true;
        }

        return false
    }
    
    //Add to upleft, upright, downleft, downright jog move - problem Kang ( 2012 - 7 -25 )
    function isUpLeft(event) {
        if(event.key == Qt.Key_Home) {
            return true;
        }
        return false
    }

    function isUpRight(event) {
        if(event.key == Qt.Key_PageUp) {
            return true;
        }
        return false
    }

    function isDownLeft(event) {
        if(event.key == Qt.Key_End) {
            return true;
        }

        return false
    }

    function isDownRight(event) {
        if(event.key == Qt.Key_PageDown) {
            return true;
        }

        return false
    }

    function isLeft(event) {
        if(event.key == Qt.Key_Left){
            return true;
        }
        return false
    }

    function isRight(event) {
        if(event.key == Qt.Key_Right){
            return true;
        }
        return false
    }

    function playBeep() {
        beep();
    }
}
/* EOF */
