/**
 * FileName: MComponent.qml
 * Author: WSH
 *
 * - 2013-01-03 Deleted property (dimmed) by WSH
 * - 2013-01-03 Modified  property (mEnabled) by WSH
 *   : mEnabled = !dimmed = !disabled
 *     => true(enabled), false(dimmed, disabled)
 */

import Qt 4.7

FocusScope {
    id: container

    signal clicked(string target, string button)
    signal pressAndHold(string target, string button)
    signal pressed();

    property bool showFocus : idAppMain.focusOn;

    property bool mEnabled: true; // true(enabled), false(dimmed, disabled) << Modified by WSH (130103)
    property bool pressAndHoldFlag: false   //-Touch Press/Release Issue (130301)
    property bool isKeyPressed: false
    property bool key_Pressed: false
    property bool longKey_Pressed: false

    signal clickOrKeySelected()
    signal selectKeyPressed()
    signal homeKeyPressed()
    signal backKeyPressed()
    signal wheelRightKeyPressed(int count)
    signal wheelLeftKeyPressed(int count)
    signal clickMenuKey()
    signal etcKeyPressed(int key)
    signal selectKeyReleased()
    signal anyKeyReleased() //# added by HYANG (120425)
    signal leftKeyPressed(); //# added by HYANG (120511)

    signal seekPrevKeyPressed() //Add Seek Prev/Next jyjeon_2012-09-28
    signal seekPrevKeyReleased()
    signal seekNextKeyPressed() //Add Seek Prev/Next jyjeon_2012-09-28
    signal seekNextKeyReleased()
    signal tuneRightKeyPressed()  //Add tune Right/left/Enter jyjeon_2012-10-10
    signal tuneLeftKeyPressed()   //Add tune Right/left/Enter jyjeon_2012-10-10
    signal tuneEnterKeyPressed()  //Add tune Right/left/Enter jyjeon_2012-10-10
    signal tuneEnterLongKeyReleased(); //Add tune Enter longKey jyjeon_2012-10-10
    signal seekPrevLongKeyPressed()
    signal seekPrevLongKeyReleased()
    signal seekNextLongKeyPressed()
    signal seekNextLongKeyReleased()
    signal sWRCSeekPrevKeyPressed()
    signal sWRCSeekNextKeyPressed()
    signal sWRCSeekPrevLongKeyPressed()
    signal sWRCSeekNextLongKeyPressed()
    signal rRCChBkKeyPressed()
    signal rRCChFwKeyPressed()
    
    //add jog keypad 8move
    signal upLeftKeyPressed()
    signal upRightKeyPressed()
    signal downRightKeyPressed()
    signal downLeftKeyPressed()

    signal mousePosChanged(int x,int y)     // JSH 121121
    signal clickOrKeyPosition(int x,int y)  // JSH 121121
    signal clickReleased()                  // JSH 121121
    signal cancel()                         // WSH 130806

    signal pressedForFlickable();   //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)
    signal upKeyReleased();

    signal cancelCCPPressed();

    function isMousePressed()
    {
        return ((mouseArea.pressed && mouseArea.isMovedInside) || isKeyPressed) && mEnabled; //Added by David Bae.
    }

    //-Touch Press/Release Issue (130301)
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        property bool isMovedInside : false // WSH 130806
        onPressAndHold: {
            if(idAppMain.inputModeXM == "jog") return;
            pressAndHoldFlag = true
            if(!mEnabled) return;
            idAppMain.playBeepOn = true;
            container.pressAndHold(container.target, container.buttonName);
            idAppMain.returnToTouchMode();
        }

        onReleased: {

            if(idAppMain.isDragByTouch == true)
            {
                idAppMain.disableInteractive();
                idAppMain.isDragByTouch = false;
            }

            if(isLongKeyExcept)
            {
                pressAndHoldFlag = false;
                isLongKeyExcept = false;
                isMovedInside = false;
                return;
            }
            if(idAppMain.inputModeXM == "jog") return;

            idAppMain.inputModeXM = "touch";

            if( (mouseArea.containsMouse == true)  &&  ( isMovedInside == true) ) {
                pressAndHoldFlag = false;
                if(!mEnabled) return;
                container.clicked(container.target, container.buttonName);
                idAppMain.playBeepOn = true;
                container.clickOrKeySelected();
            }
            clickReleased(); // JSH 121121
            isMovedInside = false;
        }
        onMousePositionChanged: mousePosChanged(mouseX,mouseY); // JSH 121121
        onPressed: {
            container.pressedForFlickable();
            isMovedInside       = true; // WSH 130806
            pressAndHoldFlag    = false; // WSH 130806
            key_Pressed = false;
            longKey_Pressed = false;
            idAppMain.inputModeXM = "touch";
        } //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)
        onExited: { // WSH 130806
            if(!mouseArea.pressed)
                return;

            isMovedInside = false ;
            cancel();
        }
    }

    Keys.forwardTo: idAppMain;
    Keys.onPressed:{
        //if(!mEnabled) return;

        //        console.debug("MComponet.qml : Keys.onPressed : event.key = " + event.key + " key_Equal = " + Qt.Key_Equal);

        idAppMain.inputModeXM = "jog";
        if(event.key == Qt.Key_Equal){return;}
        if(!idAppMain.isJogMode(event, true)){return;}

        if(event.modifiers == Qt.ShiftModifier){
            key_Pressed = false;
            longKey_Pressed = true;
        }else{
            key_Pressed = true;
            longKey_Pressed = false;
        }


        if(mEnabled && idAppMain.isSelectKey(event)){
            //clickOrKeySelected();  // # because clickOrKeySelected() in Keys.onReleased by HYANG(120522)
            if(event.modifiers == Qt.ShiftModifier){ // Added by David.bae for Long Press
                isLongKey = true;
                idAppMain.playBeepOn = true;
                container.pressAndHold(container.target, container.buttonName);
            }else{
                idAppMain.playBeepOn = false;
                isKeyPressed = true;
                event.accepted = true;
                selectKeyPressed();
            }
        }else if(mEnabled && idAppMain.isJogEnterKey(event)){
            if(event.modifiers == Qt.ShiftModifier){
                isJogEnterLongPressed = true;
                idAppMain.playBeepOn = true;
                container.pressAndHold(container.target, container.buttonName);
            }else{
                isJogEnterLongPressed = false;
                selectKeyPressed();
            }
        }else if(idAppMain.isSeekPrev(event)){
            if(event.modifiers == Qt.ShiftModifier){
                isSeekPrevKeyLongPressed = true;
                seekPrevLongKeyPressed();
            }else{
                isSeekPrevKeyLongPressed = false;
                seekPrevKeyPressed();
                return;
            }
        }else if(idAppMain.isSeekNext(event)){
            if(event.modifiers == Qt.ShiftModifier){
                isSeekNextKeyLongPressed = true;
                seekNextLongKeyPressed();
            }else{
                isSeekNextKeyLongPressed = false;
                seekNextKeyPressed();
                return;
            }
        }else if(idAppMain.isHomeKey(event)){
            homeKeyPressed();
        }else if(idAppMain.isBackKey(event) && (event.modifiers == Qt.NoModifier)){
            backKeyPressed();
        }else if(idAppMain.isWheelRight(event)){
            //Added by Jeon_130112 Start
            var count = 0;
            if(!(event.count & 0x00ff))
            {
                count = (event.count >> 8) * -1;
            }else
            {
                count = event.count;
            }
            //Added by Jeon_130112 End
            wheelRightKeyPressed(count);
        }else if(idAppMain.isWheelLeft(event)){
            //Added by Jeon_130112 Start
            var count = 0;
            if(!(event.count & 0x00ff))
            {
                count = (event.count >> 8) * -1;
            }else
            {
                count = event.count;
            }
            //Added by Jeon_130112 End
            wheelLeftKeyPressed(count);
        }else if(idAppMain.isMenuKey(event)){
            if(event.modifiers != Qt.ShiftModifier)
                clickMenuKey();
        }else if(idAppMain.isTuneRight(event)){ //Add tune Right/left/Enter jyjeon_2012-10-10
            tuneRightKeyPressed();
        }else if(idAppMain.isTuneLeft(event)){
            tuneLeftKeyPressed();
        }else if(idAppMain.isTuneEnter(event)){
            if(event.modifiers == Qt.ShiftModifier){
                isLongKey = true;
                //container.pressAndHold(container.target, container.buttonName); //jdh0703 : When Tune knob long in preset list pressed, "Preset Saved" Popup occurred.
            }else{
                tuneEnterKeyPressed();
            }
        }else if(idAppMain.isSWRCSeekPrev(event)){ //Add SWRC Seek Prev/Next dhjung_2012-10-126
            if(event.modifiers == Qt.ShiftModifier)
            {
                sWRCSeekPrevLongKeyPressed();
            }
            else
            {
                sWRCSeekPrevKeyPressed();
            }

        }else if(idAppMain.isSWRCSeekNext(event)){
            if(event.modifiers == Qt.ShiftModifier)
            {
                sWRCSeekNextLongKeyPressed();
            }
            else
            {
                sWRCSeekNextKeyPressed();
            }
        }else if(idAppMain.isRRCChBk(event)){ //Add RRC CH_BK/CH_FW dhjung_2012-10-126
            rRCChBkKeyPressed();
        }else if(idAppMain.isRRCChFw(event)){
            rRCChFwKeyPressed();
        }else if(idAppMain.isLeft(event)){ //# left Key added by HYANG (120511)
            leftKeyPressed();

            //add 8 move
        }else if(idAppMain.isUpLeft(event)){
            upLeftKeyPressed();
        }else if(idAppMain.isUpRight(event)){
            upRightKeyPressed();
        }else if(idAppMain.isDownLeft(event)){
            downLeftKeyPressed();
        }else if(idAppMain.isDownRight(event)){
            downRightKeyPressed();
        }else {
            etcKeyPressed(event.key);
        }
    }
    Keys.onReleased:{

        idAppMain.inputModeXM = "jog";
        if(event.modifiers == Qt.ShiftModifier) // Key_cancel
        {
            //            console.debug("MComponet.qml : Keys.onReleased : Key_cancel  !!");
            event.accepted = true;
            key_Pressed = false;
            longKey_Pressed = false;
            isJogEnterLongPressed = false;
            cancel();
            return;
        }

        if(key_Pressed == false && longKey_Pressed == false)
        {
            // ITS 0198277 # by WSH(131025)
            if(isJogEnterLongPressed == true) { isJogEnterLongPressed = false; }
            //            console.debug("MComponet.qml : Keys.onReleased : return after key cancel");
            return;
        }

        if(isLongKeyExcept)
        {
            isKeyPressed = true;
            if(event.key == Qt.Key_Equal){return;}

            if(idAppMain.upKeyReleased == true && event.key == Qt.Key_Up)
            {
                upKeyReleased();
            }

            anyKeyReleased()   //# added by HYANG (120425)
            selectKeyReleased();   // problem Kang
            isLongKeyExcept = false;
            return;
        }

        //if(!mEnabled) return;
        //        console.debug("MComponet.qml : Keys.onReleased : event.key = " + event.key + " key_Equal = " + Qt.Key_Equal);
        isKeyPressed = false;
        if(event.key == Qt.Key_Equal){return;}

        if(idAppMain.upKeyReleased == true && event.key == Qt.Key_Up)
        {
            upKeyReleased();
        }

        anyKeyReleased()   //# added by HYANG (120425)
        selectKeyReleased();
        if(isLongKey){ // Added by David.bae for Long Press
            event.accepted = true;
            isLongKey = false;
            return;
        }
        if(!idAppMain.isJogMode(event, false)){ return;}
        if(mEnabled && idAppMain.isSelectKey(event)){
            event.accepted = true; //jyjeon_20120606
            idAppMain.playBeepOn = true;
            clickOrKeySelected();
        }else if(mEnabled && idAppMain.isJogEnterKey(event)){
            if(isJogEnterLongPressed == false){
                //console.log("[Component] Jog Enter - Press Released ################################")
                idAppMain.playBeepOn = false;
                clickOrKeySelected();
            }else{
                //console.log("[Component] Jog Enter - Long Press Released ################################")
                idAppMain.playBeepOn = true;
                clickOrKeySelected();//clickReleased();
                isJogEnterLongPressed = false;
            }
        }else if(mEnabled && idAppMain.isSeekPrev(event)){
            if(isSeekPrevKeyLongPressed == false){
                seekPrevKeyReleased();
            }else{
                isSeekPrevKeyLongPressed = false;
                seekPrevLongKeyReleased();
            }
        }else if(mEnabled && idAppMain.isSeekNext(event)){
            if(isSeekNextKeyLongPressed == false){
                seekNextKeyReleased();
            }else{
                isSeekNextKeyLongPressed = false;
                seekNextLongKeyReleased();
            }
        }else if(idAppMain.isTuneEnter(event)){ //Add tune Enter longKey jyjeon_2012-10-10
            event.accepted = true;
            tuneEnterLongKeyReleased();
        }
    }

    Connections{
        target: UIListener
        onReleaseTouchPress:{
            mouseArea.isMovedInside = false;
            cancelCCPPressed();
        }
    }
    Connections{
        target: idAppMain
        onReleaseTouchPressed:{
            mouseArea.isMovedInside = false;
        }
        onPressAndHoldResetFlag:{
            container.key_Pressed = false;
            container.longKey_Pressed = false;
        }
    }
}
