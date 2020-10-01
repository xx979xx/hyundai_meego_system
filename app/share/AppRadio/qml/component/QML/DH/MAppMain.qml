/**
 * FileName: MAppMain.qml
 * Author: David.Bae
 * Time: 2011-10-25 19:35
 *
 * - 2011-10-25 Initial Crated by David
 * - 2012-09-19 added Long key event by HYANG
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

    signal optionMenuHide(); //20141017 dg.jin systempopup hide option menu

    property bool blockCueMovement: false   //# Block cue memovement by qutiguy 20130607 ITS-172533
    property bool upKeyPressed : false;
    property bool downKeyPressed : false;
    property bool rightKeyPressed : false;
    property bool leftKeyPressed : false;
    property bool wheelLeftKeyPressed : false;
    property bool wheelRightKeyPressed : false;
    property bool enterKeyPressed: false;
    property bool upKeyLongPressed: false;      //# Up Key Long Pressed by HYANG (120919)
    property bool downKeyLongPressed: false;    //# Down Key Long Pressed by HYANG (120919)
    property bool leftKeyLongPressed: false;    //# Left Key Long Pressed by HYANG (120919)
    property bool rightKeyLongPressed: false;   //# Right Key Long Pressed by HYANG (120919)
    property bool isLongKey: false;
    property bool presetSaveEnabled : false // JSH 130717 , preset list save button on /off
    property bool presetEditEnabled : false // JSH 130717 , preset list Edit button on /off
    property bool downKeyLongPressedVisualCueFocus: false;    //dg.jin 140530 Down Key Long Pressed VisualCueFocus
    property bool playBeepOnHold : true; //dg.jin 20150213 ITS 0258199 presetlist CCP longpress beep problem

    // 20130410 added by qutiguy - property for enter event type.(mouse : 0, key : 1, ccp enter: 2, rrc enter3)
    property int enterType : 0 ;

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
            if(event.modifiers == Qt.ShiftModifier){ //# Up key Long pressed by HYANG (120919)
                //console.log("#>>>>>>>>>> [MAppMain] - [Up Key Long Pressed]")
                event.accepted = true
                upKeyLongPressed = true;
            }
            else{
                //console.log("-[KEY] MAppMain Up    key Pressed--: "+event.key);
                upKeyPressed = true;
            }
            break;
        }
        case Qt.Key_Down:{
            if(event.modifiers == Qt.ShiftModifier){ //# Down key Long pressed by HYANG (120918)
                //console.log("#>>>>>>>>>> [MAppMain] - [Down Key Long Pressed]")
                event.accepted = true
                downKeyLongPressed = true;
            }
            else{
                //console.log("-[KEY] MAppMain Down  key Pressed--: "+event.key);
                downKeyPressed = true;
            }
            break;
        }
        case Qt.Key_Right:{
            if(event.modifiers == Qt.ShiftModifier){ //# Right key Long pressed by HYANG (120918)
                //console.log("#>>>>>>>>>> [MAppMain] - [Right Key Long Pressed]")
                event.accepted = true
                rightKeyLongPressed = true;
            }
            else{
                //console.log("-[KEY] MAppMain Right key Pressed--: "+event.key);
                rightKeyPressed = true;
            }
            break;
        }
        case Qt.Key_Left:{
            if(event.modifiers == Qt.ShiftModifier){ //# Left key Long pressed by HYANG (120918)
                //console.log("#>>>>>>>>>> [MAppMain] - [Left Key Long Pressed]")
                event.accepted = true
                leftKeyLongPressed = true;
            }
            else{
                //console.log("-[KEY] MAppMain Left  key Pressed--: "+event.key);
                leftKeyPressed = true;
            }
            break;
        }
        case Qt.Key_Semicolon:{  //HWS 130114
            wheelLeftKeyPressed = true;
            break;
        }
        case Qt.Key_Apostrophe:{ //HWS 130114
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
            upKeyLongPressed = false;
            break;
        }
        case Qt.Key_Down:{
            //console.log("-[KEY] MAppMain Down  key   --Released: "+event.key);
            downKeyPressed = false;
            downKeyLongPressed = false;
            downKeyLongPressedVisualCueFocus = false;    //dg.jin 140530 Down Key Long Pressed VisualCueFocus
            break;
        }
        case Qt.Key_Right:{
            //console.log("-[KEY] MAppMain Right key   --Released: "+event.key);
            rightKeyPressed = false;
            rightKeyLongPressed = false;
            break;
        }
        case Qt.Key_Left:{
            //console.log("-[KEY] MAppMain Left  key   --Released: "+event.key);
            leftKeyPressed = false;
            leftKeyLongPressed = false;
            break;
        }
        case Qt.Key_Semicolon:{ //HWS 130114
            wheelLeftKeyPressed = false;
            break;
        }
        case Qt.Key_Apostrophe:{ //HWS 130114
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
//remove Jog Timer : jyjeon_20120920
//    property int count: 1;
//    property int max_waiting_second:5
//    Timer {
//        id:idVisualCueTimer;
//        interval: 1000;
//        repeat: true;
//        //triggeredOnStart: true;

//        onTriggered: {
//            //console.log("  VisualCue Timer: Triggered... count:" + count);
//            if(count == max_waiting_second){
//                stopTimer();
//                return;
//            }
//            count++;
//        }
//        function startTimer()
//        {
//            count = 1;
//            running = true;
//        }
//        function stopTimer()
//        {
//            running = false;
//            returnToTouchMode();
//        }
//        function resetTimer(){
//            count = 1;
//        }
//    }
//    function getCount(){
//        return count;
//    }

    //    onKeyPressedChanged: {
    //        idVisualCueTimer.count = 0;
    //    }

    ///////////////////////////////
    // Jog/Touch Mode
    property string inputMode : "jog" //"touch"//
    property string viewMode:  "small"//jog"
    property bool focusOn : true; //false; //130226 Modify
    property bool keyPressed : false;
    property bool systemPopupShow : false; //dg.jin 20140901 ITS 247202 focus issue
    //signal jogModeOn();
    function initMode(){ // JSH 130625
        inputMode = "jog";
    }
    function isJogMode(event, isPressed) //Added by David Bae 2012.05.24
    {
        if(isMenuInput(event)){
            return true;
        }
        //idVisualCueTimer.startTimer();//remove Jog Timer : jyjeon_20120920
        //if(inputMode == "touch"){
        if(inputMode != "jog"){ //Add DMB tune mode by jyjeon
            //event.accepted = true // JSH 130228 delete
            focusOn = true;
            if(!isPressed){ //Added by David Bae
                inputMode = "jog";
            }
            //jogModeOn();
            return true;//false; // JSH 130228 delete
        }else{
            //keyPressed = !keyPressed; //Key Inputed signal.
            return true;
        }
    }
    function isTuneFocusMode() //Add DMB tune mode by jyjeon
    {
        //idVisualCueTimer.startTimer(); //remove Jog Timer : jyjeon_20120920
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
        //focusOn = false; //130226 delete
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
        case Qt.Key_Q:         //Seek Key
        case Qt.Key_W:
        case Qt.Key_O:         //tune key
            //case Qt.Key_Home:
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
            //case Qt.Key_Home:
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
            //break;
        }
        default:
            return false;
            //break;
        }
        //return false;
    }
    function isWheelLeft(event)
    {
        if(event.key == Qt.Key_Semicolon){ //HWS 130114
            return true;
        }
        return false;
    }

    function isWheelRight(event)
    {
        if(event.key == Qt.Key_Apostrophe){ //HWS 130114
            return true;
        }
        return false
    }

    //Add Seek Prev/Next jyjeon_2012-09-28
    function isSeekPrev(event)
    {
        if(event.key == Qt.Key_Q){
            return true;
        }
        return false;
    }

    function isSeekNext(event)
    {
        if(event.key == Qt.Key_W){
            return true;
        }
        return false
    }

    //Add tune Right/left/Enter jyjeon_2012-10-10
    function isTuneRight(event)
    {
        if(event.key == Qt.Key_O && event.modifiers == Qt.AltModifier){
            return true;
        }
        return false;
    }

    function isTuneLeft(event)
    {
        if(event.key == Qt.Key_O && event.modifiers == Qt.ControlModifier){
            return true;
        }
        return false;
    }

    function isTuneEnter(event)
    {
        if(event.key == Qt.Key_O){
            return true;
        }
        return false;
    }


    //Add to upleft, upright, downleft, downright jog move - problem Kang ( 2012 - 7 -25 )
    function isUpLeft(event)
    {
        if(event.key == Qt.Key_Home){
            return true;
        }
        return false
    }

    function isUpRight(event)
    {
        if(event.key == Qt.Key_PageUp){
            return true;
        }
        return false
    }

    function isDownLeft(event)
    {
        if(event.key == Qt.Key_End){
            return true;
        }
        return false
    }

    function isDownRight(event)
    {
        if(event.key == Qt.Key_PageDown){
            return true;
        }
        return false
    }


    //# left Key function added by HYANG (120511)
    function isLeft(event)
    {
        if(event.key == Qt.Key_Left){
            return true;
        }
        return false
    }
    function isRight(event)
    {
        if(event.key == Qt.Key_Right){
            return true;
        }
        return false
    }
    function playBeep()
    {
        //console.log("=========================> AppMain  playBeep()");
        //UIListener.writeToLogFile("=========================> AppMain  playBeep()");
        beep();
    }
}
