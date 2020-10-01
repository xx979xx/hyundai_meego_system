/**
 * FileName: MAppMain.qml
 * Author: David.Bae
 * Time: 2011-10-25 19:35
 *
 * - 2011-10-25 Initial Crated by David
 */

import Qt 4.7
import "../system" as MSystem

FocusScope{
    id:idAppMain
    MSystem.SystemInfo { id: systemInfo }

    width:systemInfo.lcdWidth
    height:systemInfo.lcdHeight

    // Signal Of MAppMain
    signal completed()
    signal beep();

    //property bool isAVMMode : false;

    property bool upKeyPressed : false;
    property bool downKeyPressed : false;
    property bool rightKeyPressed : false;
    property bool leftKeyPressed : false;
    property bool wheelLeftKeyPressed : false;
    property bool wheelRightKeyPressed : false;
    property bool enterKeyPressed: false;

    //property bool isLongKey: false;

    //focus: true;
    // Debugging for focus and key input
//    onFocusChanged: {
//        console.log(" == idAppMain focus: "+ idAppMain.focus + " activeFocus:"+ idAppMain.activeFocus);
//    }

    Component.onCompleted: {
        completed()
    }

    Keys.onPressed: {
        switch(event.key) {
        case Qt.Key_Up:{
            //console.log("-[KEY] MAppMain Up    key Pressed--: "+event.key);
            upKeyPressed = true;
            break;
        }
        case Qt.Key_Down:{
            //console.log("-[KEY] MAppMain Down  key Pressed--: "+event.key);
            downKeyPressed = true;
            break;
        }
        case Qt.Key_Right:{
            //console.log("-[KEY] MAppMain Right key Pressed--: "+event.key);
            rightKeyPressed = true;
            break;
        }
        case Qt.Key_Left:{
            //console.log("-[KEY] MAppMain Left  key Pressed--: "+event.key);
            leftKeyPressed = true;
            break;
        }
        case Qt.Key_Minus:{
            wheelLeftKeyPressed = true;
            break;
        }
        case Qt.Key_Colon:{
            wheelRightKeyPressed = true;
            break;
        }
        case Qt.Key_Enter:{
            //console.log("-[KEY] MAppMain Enter key Pressed--: "+event.key);
            enterKeyPressed = true;
            break;
        }//Kang JungWon(Add)

        default:
            break;
        }
    }
    Keys.onReleased: {

        switch(event.key) {
        case Qt.Key_Up:{
            //console.log("-[KEY] MAppMain UP    key   --Released: "+event.key);
            upKeyPressed = false;
            break;
        }
        case Qt.Key_Down:{
            //console.log("-[KEY] MAppMain Down  key   --Released: "+event.key);
            downKeyPressed = false;
            break;
        }
        case Qt.Key_Right:{
            //console.log("-[KEY] MAppMain Right key   --Released: "+event.key);
            rightKeyPressed = false;
            break;
        }
        case Qt.Key_Left:{
            //console.log("-[KEY] MAppMain Left  key   --Released: "+event.key);
            leftKeyPressed = false;
            break;
        }
        case Qt.Key_Minus:{
            wheelLeftKeyPressed = false;
            break;
        }
        case Qt.Key_Colon:{
            wheelRightKeyPressed = false;
            break;
        }
        case Qt.Key_Enter:{
            //console.log("-[KEY] MAppMain Enter key Pressed--: "+event.key);
            enterKeyPressed = false;
            break;
        }
        default:
            break;
        }
    }

    ///////////////////////////////
    // Jog/Touch Mode
    property string inputMode : "jog" //"touch"//
    property string viewMode:  "small"//jog"
    property bool focusOn : true;//false;
    property bool keyPressed : false;
    //signal jogModeOn();
    function isJogMode(event, isPressed) //Added by David Bae 2012.05.24
    {
        if (isMenuInput(event)) {
            return true;
        }
        ///////idVisualCueTimer.startTimer();
        //if (inputMode == "touch") {
        if (inputMode != "jog") { //Add DMB tune mode by jyjeon
            event.accepted = true
            focusOn = true;
            if (!isPressed) { //Added by David Bae
                inputMode = "jog";
            }
            //jogModeOn();
            return false;
        }else{
            //keyPressed = !keyPressed; //Key Inputed signal.
            return true;
        }
    }
    function isTuneFocusMode() //Add DMB tune mode by jyjeon
    {
        ////////idVisualCueTimer.startTimer();
        if (inputMode != "tuneFocus") {
            inputMode = "tuneFocus";
            focusOn = true;
            return false;
        }else{
            return true;
        }
    }

    function isTouchMode()
    {
        if (inputMode == "touch") {
            return true;
        }
        return false;
    }

    function returnToTouchMode()
    {
        inputMode = "touch";
        focusOn = false;
    }

    function isMenuInput(event)
    {
        switch(event.key)
        {
        case Qt.Key_I:         //Menu Key
        case Qt.Key_L:
        case Qt.Key_Slash:
        case Qt.Key_Backspace: //Back Key
        case Qt.Key_J:
        case Qt.Key_Comma:
        case Qt.Key_K:         //Home Key
        case Qt.Key_Period:
        case Qt.Key_Home:
            return true;
        }
        return false;
    }
    function isHomeKey(event)
    {
        switch(event.key)
        {
        case Qt.Key_K:         //Home Key
        case Qt.Key_Period:
        case Qt.Key_Home:
            return true;
        }
        return false;
    }
    function isBackKey(event)
    {
        switch(event.key)
        {
        case Qt.Key_Backspace: //Back Key
        case Qt.Key_J:
        case Qt.Key_Comma:
            return true;
        }
        return false;
    }
    function isMenuKey(event)
    {
        switch(event.key)
        {
        case Qt.Key_I:         //Menu Key
        case Qt.Key_L:
        case Qt.Key_Slash:
            return true;
        }
        return false;
    }
    function isSelectKey(event)
    {
        switch(event.key) {
        case Qt.Key_Return:
        case Qt.Key_Enter:{
            return true;
            break;
        }
        default:
            return false;
            break;
        }
        return false;
    }
    function isWheelLeft(event)
    {
        if (event.key == Qt.Key_Minus) {
            return true;
        }
        return false;
    }

    function isWheelRight(event)
    {
        if (event.key == Qt.Key_Colon) {
            return true;
        }
        return false
    }
    //# left Key function added by HYANG (120511)
    function isLeft(event)
    {
        if (event.key == Qt.Key_Left) {
            return true;
        }
        return false
    }

    function isRight(event)
    {
        if (event.key == Qt.Key_Right) {
            return true;
        }
        return false
    }

    function isUp(event)
    {
        if (event.key == Qt.Key_Up) {
            return true;
        }
        return false
    }

    function isUp(event)
    {
        if (event.key == Qt.Key_Down) {
            return true;
        }
        return false
    }

    function playBeep()
    {
        beep();
    }
}
