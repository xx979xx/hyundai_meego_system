/**
 * FileName: MAppMain.qml
 * Author: David.Bae
 * Time: 2011-10-25 19:35
 *
 * - 2011-10-25 Initial Crated by David
 * - 2012-09-19 added Long key event by HYANG
 * - 2012-09-19 added Long key event(Seek/Next) by WSH
 */

import Qt 4.7
import "../DH" as MComp

FocusScope{
    id:idAppMain
    width:systemInfo.lcdWidth
    height:systemInfo.lcdHeight

    // Signal Of MAppMain
    signal completed()
    signal beep();

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
    property bool isLongKeyForDRS: false;
    property bool upKeyReleased: false;
    property bool downKeyReleased: false;
    property bool upleftKeyLongPressed: false;
    property bool uprightKeyLongPressed: false;
    property bool downleftKeyLongPressed: false;
    property bool downrightKeyLongPressed: false;
    property bool isDRSChange: interfaceManager.isDRSChanged;
    property bool isDRSShow: false;
    property bool isCallStart: interfaceManager.isCallStarted;
    property bool isBTConnectStatus: interfaceManager.isBTConnected;
    property int isVariantId: interfaceManager.HandleGetVariantID();
    property bool statusAntSig: false;
    property bool isNoSignalStatus: false;

    property bool isWsaListModelChanged : false;

    Timer {
        id: idActiveFocusTimer
        interval: 100
        repeat: false
        running: false
        triggeredOnStart: false
        onTriggered:
        {
            console.log(" == idActiveFocusTimer :: activeFocus:"+ idAppMain.activeFocus);
            if(idAppMain.activeFocus == false)
                idAppMain.forceActiveFocus()
        }        
    }

    onActiveFocusChanged: {
        console.log(" == idAppMain focus: "+ idAppMain.focus + " activeFocus:"+ idAppMain.activeFocus);
        if(idAppMain.activeFocus == false)
        {
            idActiveFocusTimer.start()
        }
        else
        {
            idActiveFocusTimer.stop()
        }
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
                upKeyReleased = false;
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
                downKeyReleased = true;
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
//        case Qt.Key_Minus:{
         case Qt.Key_Semicolon:{
            wheelLeftKeyPressed = true;
            break;
        }
//        case Qt.Key_Equal:{
        case Qt.Key_Apostrophe:{
            wheelRightKeyPressed = true;
            break;
        }
        case Qt.Key_Return:
        case Qt.Key_Enter:{
            //console.log("-[KEY] MAppMain Enter key Pressed--: "+event.key);
            enterKeyPressed = true;
            break;
        }//Kang JungWon(Add)

        case Qt.Key_Home:{
            if(event.modifiers == Qt.ShiftModifier){
                event.accepted = true;
                upleftKeyLongPressed = true;
            }
            break;
        }
        case Qt.Key_End:{
            if(event.modifiers == Qt.ShiftModifier){
                event.accepted = true;
                downleftKeyLongPressed = true;
            }
            break;
        }
        case Qt.Key_PageUp:{
            if(event.modifiers == Qt.ShiftModifier){
                event.accepted = true;
                uprightKeyLongPressed = true;
            }
            break;
        }
        case Qt.Key_PageDown:{
            if(event.modifiers == Qt.ShiftModifier){
                event.accepted = true;
                downrightKeyLongPressed = true;
            }
            break;
        }

        default:
            break;
        }
    }
    Keys.onReleased: {
        switch(event.key){
        case Qt.Key_Up:{
            //console.log("-[KEY] MAppMain UP    key   --Released: "+event.key);
            if(upKeyPressed == true && upKeyLongPressed == false)
            {
                upKeyReleased = true;
            }

            upKeyPressed = false;
            upKeyLongPressed = false;
            break;
        }
        case Qt.Key_Down:{
            //console.log("-[KEY] MAppMain Down  key   --Released: "+event.key);
            if(downKeyPressed == true && downKeyLongPressed == false)
            {
                downKeyReleased = true;
            }

            downKeyPressed = false;
            downKeyLongPressed = false;
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
        //case Qt.Key_Minus:{
        case Qt.Key_Semicolon:{
            wheelLeftKeyPressed = false;
            break;
        }
//        case Qt.Key_Equal:{
        case Qt.Key_Apostrophe:{
            wheelRightKeyPressed = false;
            break;
        }
        case Qt.Key_Return:
        case Qt.Key_Enter:{
            //console.log("-[KEY] MAppMain Enter key Pressed--: "+event.key);
            enterKeyPressed = false;
            break;
        }
        case Qt.Key_Home:{
            upleftKeyLongPressed = false;
            break;
        }
        case Qt.Key_End:{
            downleftKeyLongPressed = false;
            break;
        }
        case Qt.Key_PageUp:{
            uprightKeyLongPressed = false;
            break;
        }
        case Qt.Key_PageDown:{
            downrightKeyLongPressed = false;
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
    // Jog/Touch Mode "jog" or "touch"
    property string inputMode : "jog"   //-Focus Rule Issue(130301)
    property bool focusOn : true;       //-Focus Rule Issue(130301)
    property bool keyPressed : false;
    //signal jogModeOn();
    function isJogMode(event, isPressed) //Added by David Bae 2012.05.24
    {
        if(isMenuInput(event)){
            return true;
        }
        //idVisualCueTimer.startTimer();//remove Jog Timer : jyjeon_20120920
        //if(inputMode == "touch"){
        if(inputMode != "jog"){ //Add DMB tune mode by jyjeon
            event.accepted = true
            focusOn = true;
            if(!isPressed){ //Added by David Bae
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
        if(inputMode == "jog"){  //-Focus Rule Issue(130301)
            return true;
        }
        return false;
    }

    function returnToTouchMode()
    {
        inputMode = "jog";       //-Focus Rule Issue(130301)
        focusOn = true;          //-Focus Rule Issue(130301)
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
        case Qt.Key_F6:        //SWRC Seek Next key
        case Qt.Key_F7:        //SWRC Seek Prev key
        case Qt.Key_Delete:    //RRC CH_FW key
        case Qt.Key_Control:   //RRC CH_BK key
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
//        if(event.key == Qt.Key_Minus){
        if(event.key == Qt.Key_Semicolon){
            return true;
        }
        return false;
    }
    function isWheelRight(event)
    {
//        if(event.key == Qt.Key_Equal){
        if(event.key == Qt.Key_Apostrophe){
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

    //Add SWRC Seek Prev/Next dhjung_2012-10-26
    function isSWRCSeekPrev(event)
    {
        if(event.key == Qt.Key_F7){
            return true;
        }
        return false;
    }
    function isSWRCSeekNext(event)
    {
        if(event.key == Qt.Key_F6){
            return true;
        }
        return false;
    }
    //Add RRC CH_BK/CH_FW dhjung_2012-10-26
    function isRRCChBk(event)
    {
        if(event.key == Qt.Key_Control){
            return true;
        }
        return false;
    }
    function isRRCChFw(event)
    {
        if(event.key == Qt.Key_Delete){
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

    function playBeep()
    {
        beep();
    }

    property bool isFirstSignal: false

    function checkFirstSignal()
    {
        if(isFirstSignal == true)
        {
            isFirstSignal = false
            return false;
        }
        isFirstSignal = true;
        return true;
    }
}
