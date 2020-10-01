/**
 * FileName: MComponent.qml
 * Author: WSH
 *
 * - 2013-01-03 Deleted property (dimmed) by WSH
 * - 2013-01-03 Modified  property (mEnabled) by WSH
 *   : mEnabled = !dimmed = !disabled
 *     => true(enabled), false(dimmed, disabled)
 * - 2013-01-28 Added Seek/Next Released() by WSH
 * - 2013-01-28 Added HK Pressed()/Released() by WSH
 */

import Qt 4.7

import "../../system/DH" as MSystem
import Qt.labs.gestures 2.0

FocusScope {
    id: container

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id:imageInfo }

    signal clicked(string target, string button)
    signal pressAndHold(string target, string button)
    signal pressed();
    signal mouseExit();

    property bool showFocus : idAppMain.focusOn;
    property bool playBeepOn : true;

    property bool mEnabled: true; // true(enabled), false(dimmed, disabled) << Modified by WSH (130103)
    property bool pressAndHoldFlag: false
    property bool pressAndHoldFlagDMB: false

    property bool isExited: false

    signal clickOrKeySelected()
    signal selectKeyPressed()
    signal homeKeyPressed()
    signal backKeyPressed()
    signal wheelRightKeyPressed(int count)
    signal wheelLeftKeyPressed(int count)
    signal clickMenuKey()
    signal etcKeyPressed(int key)
    signal selectKeyReleased()
    signal leftKeyPressed()
    signal rightKeyPressed()
    signal anyKeyReleased() //# added by HYANG (120425)
    signal leftKeyReleased()
    signal rightKeyReleased()

    // ============================== START HK Pressed()/Released() # by WSH(130127)
    signal tuneRightKeyPressed()     // [TUNE] Add tune Right jyjeon_2012-10-10
    signal tuneLeftKeyPressed()      // [TUNE] Add tune Left jyjeon_2012-10-10
    signal tuneEnterKeyPressed()     // [TUNE] Add tune Enter jyjeon_2012-10-10
    signal tuneEnterLongKeyReleased()// [TUNE Long] Add tune Enter longKey jyjeon_2012-10-10
    signal seekPrevKeyPressed()      // [SEEK] Add Seek Prev Pressed()  # jyjeon_2012-09-28
    signal seekPrevKeyReleased()     // [SEEK] Add Seek Prev Released() # dhjung_2012-10-26
    signal seekPrevLongKeyPressed()  // [SEEK Long]  Add Seek Prev longKey Presedd # dhjung_2012-10-26
    signal seekPrevLongKeyReleased() // [SEEK Long]  Add Seek Prev longKey Released # dhjung_2012-10-26
    signal seekNextKeyPressed()      // [TRACK] Add Seek Prev Pressed() # jyjeon_2012-09-28
    signal seekNextKeyReleased()     // [TRACK] Add Seek Next Released() # dhjung_2012-10-26
    signal seekNextLongKeyPressed()  // [TRACK Long] Add Seek Next longKey Presedd # dhjung_2012-10-26
    signal seekNextLongKeyReleased() // [TRACK Long] Add Seek Next longKey Released # dhjung_2012-10-26
    signal sWRCSeekPrevKeyPressed()  // [SWRC] Add Seek Next longKey Released # dhjung_2012-10-26
    signal sWRCSeekNextKeyPressed()  // [SWRC] Add Seek Next longKey Released # dhjung_2012-10-26
    signal rRCChBkKeyPressed()       // [RRC] Add RRC CH Back Key Released # dhjung_2012-10-26
    signal rRCChFwKeyPressed()       // [RRC] Add Seek Next longKey Released # dhjung_2012-10-26
    // ============================== End HK Pressed()/Released() # by WSH(130127)
    
    //add jog keypad 8move
    signal upLeftKeyPressed()
    signal upRightKeyPressed()
    signal downRightKeyPressed()
    signal downLeftKeyPressed()

    // ========================================= Preset Order - WSH(130205)
    signal mousePosChanged(int x,int y)    
    signal clickOrKeyPosition(int x,int y)
    signal clickReleased()            

    signal upKeyReleased()
    signal pressedForFlickable();   //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)

    function isMousePressed()
    {
        return mouseArea.pressed && mEnabled; //Added by David Bae.
    }

    GestureArea{
        id: gestureArea
        anchors.fill: parent
        property bool gestureAreaTouch: false
        Tap{
            onStarted:
            {
                gestureArea.gestureAreaTouch = true;
                idAppMain.isDrag = false;
            }

            onFinished:
            {
                gestureArea.gestureAreaTouch = false;
            }
        }

         Pan{
             onFinished:
             {
                 if(gestureArea.gestureAreaTouch == true)
                 {
                     idAppMain.isDrag = true;
                 }
                 gestureArea.gestureAreaTouch = false;
             }
         }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onPressAndHold: {
            pressAndHoldFlag = true;
            pressAndHoldFlagDMB = true;
            if(!mEnabled) return;
            container.pressAndHold(container.target, container.buttonName);
//            idAppMain.returnToTouchMode();
        }
        onPressed: {
            isExited = false;
            idAppMain.iskeyRelease = false;
            idAppMain.isSelectButton = false;
            idAppMain.inputModeDMB = "touch";

            if(idAppMain.state == "AppDmbPlayerOptionMenu" || idAppMain.state == "AppDmbDisasterOptionMenu" || idAppMain.state == "AppDmbDisasterEditOptionMenu")
            {
                container.pressedForFlickable(mouseX,mouseY); //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)
            }
        }

        onExited: {
            if(mouseArea.pressed == true)
            {
                isExited = true;
                mouseExit();
            }
        }

        onMousePositionChanged:{ mousePosChanged(mouseX,mouseY); }// WSH(130205)

        onReleased: {

            if(idAppMain.inputModeDMB == "jog") return;

            idAppMain.inputModeDMB = "touch";

            if(mouseArea.containsMouse == true)
            {
                if(idAppMain.presetEditEnabled == true )
                {
                    if(isExited == true && idAppMain.isSelectButton == true) return;
                }
                else
                {
                    if(isExited == true) return;
                }

                pressAndHoldFlag = false;
                if(!mEnabled) return;
                container.clicked(container.target, container.buttonName);
                container.clickOrKeySelected();
                container.clickOrKeyPosition(mouseX,mouseY); // WSH(130205)
                clickReleased(); // WSH(130205)
                pressAndHoldFlagDMB = false;
            }
            else if(mouseArea.containsMouse == false)
            {
                if(idAppMain.presetEditEnabled == true)
                {

                    if( isExited == true && idAppMain.isSelectButton == true) return;

                    pressAndHoldFlag = false;
                    if(!mEnabled) return;
                    container.clicked(container.target, container.buttonName);
                    container.clickOrKeySelected();
                    container.clickOrKeyPosition(mouseX,mouseY); // WSH(130205)
                    clickReleased(); // WSH(130205)
                    pressAndHoldFlagDMB = false;
                }
            }
        }
    }
    Keys.forwardTo: idAppMain;
    Keys.onPressed:{
        idAppMain.iskeyRelease = false;
        idAppMain.inputModeDMB = "jog"
        //if(!mEnabled) return;

//        console.debug("=============MComponet.qml : Keys.onPressed : event.key = " + event.key + " key_Equal = " + Qt.Key_Equal);

        if(event.key == Qt.Key_Equal){return;}
        if(!idAppMain.isJogMode(event, true)){return;}

        if( (mEnabled == true) && (idAppMain.isSelectKey(event) == true) ){
            if(pressAndHoldFlag == true) pressAndHoldFlag = false;

            //clickOrKeySelected();  // # because clickOrKeySelected() in Keys.onReleased by HYANG(120522)
            if(event.modifiers == Qt.ShiftModifier){ // Added by David.bae for Long Press
//                isLongKey = true;
                idAppMain.isEnterLongKey = true;
                container.pressAndHold(container.target, container.buttonName);
            }else{
                selectKeyPressed();
            }
            //idAppMain.playBeep();
        }else if(idAppMain.isHomeKey(event)){
            homeKeyPressed();
        }else if(idAppMain.isBackKey(event)){
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
            EngineListener.wheelKeyPressed(1 /* Right */);
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
            EngineListener.wheelKeyPressed(0 /* Left */);
        }else if(idAppMain.isMenuKey(event)){
            clickMenuKey();
        }else if(idAppMain.isSeekPrev(event)){ // Modified dhjung_2012-10-26
            if(event.modifiers == Qt.ShiftModifier){
//                console.log(" [QML] #############  Seek Prev Long Key Pressed #############")
                isLongKey = true;
                idAppMain.isSeekPreLongKey = true;
                seekPrevLongKeyPressed();
            }else{
                isLongKey = false;
                isEnterLongKey = false;
                idAppMain.isSeekPreLongKey = false;
                seekPrevKeyPressed();
                return;
            }
        }else if(idAppMain.isSeekNext(event)){ // Modified dhjung_2012-10-26
            if(event.modifiers == Qt.ShiftModifier){
//                console.log(" [QML] #############  Seek Next Long Key Pressed #############")
                isLongKey = true;
                idAppMain.isSeekNextLongKey = true;
                seekNextLongKeyPressed();
            }else{
                isLongKey = false;
                isEnterLongKey = false;
                idAppMain.isSeekNextLongKey = false;
                seekNextKeyPressed();
                return;
            }
        }else if(idAppMain.isTuneRight(event)){ //Add tune Right/left/Enter jyjeon_2012-10-10
            tuneRightKeyPressed();
        }else if(idAppMain.isTuneLeft(event)){
            tuneLeftKeyPressed();
        }else if(idAppMain.isTuneEnter(event)){
            if(event.modifiers == Qt.ShiftModifier){
                isLongKey = true;
                container.pressAndHold(container.target, container.buttonName);
            }else{
                tuneEnterKeyPressed();
            }
        }else if(idAppMain.isSWRCSeekPrev(event)){ //Add SWRC Seek Prev/Next dhjung_2012-10-126
            sWRCSeekPrevKeyPressed();
        }else if(idAppMain.isSWRCSeekNext(event)){
            sWRCSeekNextKeyPressed();
        }else if(idAppMain.isRRCChBk(event)){ //Add RRC CH_BK/CH_FW dhjung_2012-10-126
            rRCChBkKeyPressed();
        }else if(idAppMain.isRRCChFw(event)){
            rRCChFwKeyPressed();
	    
      //add 8 move
        }else if(idAppMain.isUpLeft(event)){
            upLeftKeyPressed();
        }else if(idAppMain.isUpRight(event)){
            upRightKeyPressed();
        }else if(idAppMain.isDownLeft(event)){
            downLeftKeyPressed();
        }else if(idAppMain.isDownRight(event)){
            downRightKeyPressed();
        }else if(idAppMain.isLeft(event)){
            leftKeyPressed();
            EngineListener.jogKeyPressed(0 /*Left*/);
        }else if(idAppMain.isRight(event)){
            rightKeyPressed();
            EngineListener.jogKeyPressed(1 /*Right*/);
        }else {
            etcKeyPressed(event.key);
        }
    }
    Keys.onReleased:{
        //if(!mEnabled) return;
//        console.debug("=============MComponet.qml : Keys.onReleased : event.key = " + event.key + " key_Equal = " + Qt.Key_Equal);
        idAppMain.inputModeDMB = "jog"

        if(event.modifiers == Qt.ShiftModifier) // Key_cancel
        {
            event.accepted = true;

            mouseExit();

            if(idAppMain.isSeekPreLongKey == true)
            {
                idAppMain.isSeekPreLongKey = false;
            }
            else if(idAppMain.isSeekNextLongKey == true)
            {
                idAppMain.isSeekNextLongKey = false;
            }

            return;
        }

        if(event.key == Qt.Key_Equal){return;}

        if(idAppMain.upKeyReleased == true && event.key == Qt.Key_Up)
        {
            upKeyReleased();
            return;
        }

        anyKeyReleased()   //# added by HYANG (120425)
        selectKeyReleased();   // problem Kang
        if(isLongKey){ // Added by David.bae for Long Press
            event.accepted = true;
//            isLongKey = false;
//            return;
        }
        if(idAppMain.isEnterLongKey == true && (mEnabled && idAppMain.isSelectKey(event))){ // for Enter Long Press
            event.accepted = true;
            idAppMain.isEnterLongKey = false;
//            return;
        }

        if(!idAppMain.isJogMode(event, false)){ return;}

        if(mEnabled && idAppMain.isSelectKey(event)){
            event.accepted = true; //jyjeon_20120606
            clickOrKeySelected();
        }else if(idAppMain.isTuneEnter(event)){ //Add tune Enter longKey jyjeon_2012-10-10
            event.accepted = true;
            tuneEnterLongKeyReleased();
        }
        else if(idAppMain.isSeekPrev(event)){
            if(isLongKey == true) {
                isLongKey = false
                idAppMain.isSeekPreLongKey = false;
                seekPrevLongKeyReleased();
            } else if(isEnterLongKey == true) {
                isEnterLongKey = false;
            } else {
                seekPrevKeyReleased();
            }

        }else if(idAppMain.isSeekNext(event)){
            if(isLongKey == true) {
                isLongKey = false
                idAppMain.isSeekNextLongKey = false;
                seekNextLongKeyReleased();
            } else if(isEnterLongKey == true) {
                isEnterLongKey = false;
            }else {
                seekNextKeyReleased();
            }

        }
        else if(idAppMain.isLeft(event)){ // WSH(130320)
            event.accepted = true;
            leftKeyReleased();
            //EngineListener.jogKeyPressed(0 /*Left*/);
        }else if(idAppMain.isRight(event)){ // WSH(130320)
            event.accepted = true;
            rightKeyReleased();
            //EngineListener.jogKeyPressed(1 /*Right*/);
        }

    }
}
