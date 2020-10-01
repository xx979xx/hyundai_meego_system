/**
 * FileName: MAppMain.qml
 * Author: David.Bae
 * Time: 2011-10-25 19:35
 *
 * - 2011-10-25 Initial Crated by David
 */

import Qt 4.7
import "../../system/DH" as MSystem
import "../DH" as MComp

FocusScope{
    id:idAppMain
    MSystem.SystemInfo { id: systemInfo }

    width:systemInfo.lcdWidth
    height:systemInfo.lcdHeight

    // Signal Of MAppMain
    signal completed()
    signal beep();
    signal visualCueTimerStarted(); //Add DMB tune mode by jyjeon

    property bool upKeyPressed : false;
    property bool downKeyPressed : false;
    property bool rightKeyPressed : false;
    property bool leftKeyPressed : false;
    property bool wheelLeftKeyPressed : false;
    property bool wheelRightKeyPressed : false;

    //focus: true;
    // Debugging for focus and key input
    onFocusChanged: {
        console.log(" == idAppMain focus: "+ idAppMain.focus + " activeFocus:"+ idAppMain.activeFocus);
    }

    Component.onCompleted: {
        completed()
    }

    Keys.onPressed: {
        switch(event.key){
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
        case Qt.Key_Equal:{
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

        switch(event.key){
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
        case Qt.Key_Equal:{
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

    /////////////////////////////////
    // Jog Timer
    property int count: 1;
    property int max_waiting_second:5
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
            visualCueTimerStarted(); //Add DMB tune mode by jyjeon
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
    function getCount(){
        return count;
    }

//    onKeyPressedChanged: {
//        idVisualCueTimer.count = 0;
//    }

    ///////////////////////////////
    // Jog/Touch Mode
    property string inputMode : "touch"// "jog"//
    property string viewMode:  "small"//jog"
    property bool focusOn : false;
    property bool keyPressed : false;
    //signal jogModeOn();
    function isJogMode(event)
    {
        if(isMenuInput(event)){
            return true;
        }
        idVisualCueTimer.startTimer();
        //if(inputMode == "touch"){
        if(inputMode != "jog"){ //Add DMB tune mode by jyjeon
            inputMode = "jog";
            focusOn = true;
            //jogModeOn();
            event.accepted = true
            return false;
        }else{
            //keyPressed = !keyPressed; //Key Inputed signal.
            return true;
        }
    }
    function isTuneFocusMode() //Add DMB tune mode by jyjeon
    {
        idVisualCueTimer.startTimer();
        if(inputMode != "tuneFocus"){
            inputMode = "tuneFocus";
            focusOn = true;
            return false;
        }else{
            return true;
        }
    }

    function isTouchMode()
    {
        if(inputMode == "touch"){
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
        switch(event.key){
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
        if(event.key == Qt.Key_Minus){
            return true;
        }
        return false;
    }

    function isWheelRight(event)
    {
        if(event.key == Qt.Key_Equal){
            return true;
        }
        return false
    }

    function playBeep()
    {
        beep();
    }
}
