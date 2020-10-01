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

import "../../system/DH" as MSystem

FocusScope {
    id: container

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id:imageInfo }

    signal clicked(string target, string button)
    signal pressAndHold(string target, string button)
    signal pressed();

    property bool showFocus : idAppMain.focusOn;
    property bool playBeepOn : true;
    //property bool playBeepOnHold : true; //dg.jin 20141103 ITS 251755 presetlist longpress beep  //dg.jin 20150213 ITS 0258199 presetlist CCP longpress beep problem

    property bool mEnabled: true; // true(enabled), false(dimmed, disabled) << Modified by WSH (130103)
    property bool pressAndHoldFlag: false   //-Touch Press/Release Issue (130301)
    property bool dimmed : false;
    property bool pressCancel : false; // JSH 130906

    property bool showPopup : idAppMain.systemPopupShow;  //dg.jin 20140901 ITS 247202 focus issue
    // 20130410 - modified by qutiguy - argument : mouse=0 key=1, ccp_enter=2, rrc_enter=3;
    //    signal clickOrKeySelected()
    signal clickOrKeySelected(int mode)
    signal selectKeyPressed()
    signal homeKeyPressed()
    signal backKeyPressed()
    signal wheelRightKeyPressed()
    signal wheelLeftKeyPressed()
    signal seekPrevKeyPressed() //Add Seek Prev/Next jyjeon_2012-09-28
    signal seekNextKeyPressed() //Add Seek Prev/Next jyjeon_2012-09-28
    signal tuneRightKeyPressed()  //Add tune Right/left/Enter jyjeon_2012-10-10
    signal tuneLeftKeyPressed()   //Add tune Right/left/Enter jyjeon_2012-10-10
    signal tuneEnterKeyPressed()  //Add tune Right/left/Enter jyjeon_2012-10-10
    signal tuneEnterLongKeyReleased(); //Add tune Enter longKey jyjeon_2012-10-10
    signal clickMenuKey()
    signal etcKeyPressed(int key)
    signal selectKeyReleased()
    signal anyKeyReleased() //# added by HYANG (120425)
    signal leftKeyPressed(); //# added by HYANG (120511)
    
    //add jog keypad 8move
    signal upLeftKeyPressed()
    signal upRightKeyPressed()
    signal downRightKeyPressed()
    signal downLeftKeyPressed()

    signal upKeyReleased()
    signal pressedForFlickable(int x,int y);           //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)
    signal mousePosChanged(int x,int y)     // JSH 121121
    signal clickReleased()                  // JSH 121121
    signal cancel()                         // JSH 130609

    //// 2013.10.07 added by qutiguy - override event filter : To sound Beep while system popup is showing.
    signal preventDrag()
     ////
    function isMousePressed()
    {
        return mouseArea.pressed && mEnabled; //Added by David Bae.
    }

    //-Touch Press/Release Issue (130301)
    Connections{
        target: idAppMain
        onPressCancelSignal:{ // JSH 130906 Modify
            //console.log("############################  touch - onPressCancelSignal");
            if(mouseArea.pressed){
                pressCancel = true;
                cancel();
            }
        }
    }
    //// 2013.11.14 added by qutiguy - ITS 0208894: to cancel touch event  when touch + HKey.
    Connections{
        target: UIListener
        onSignalTouchCancel:{
            console.log("[CHECK_11_13_TOUCH_CANCEL]############################  touch - onSignalTouchCancel");
            if(mouseArea.pressed){
                pressCancel = true;
                cancel();
            }
            preventDrag();
        }
    }
    ////
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        property bool isExited : false // JSH 130717
        onPressAndHold: {
            pressAndHoldFlag = true
            if(!mEnabled || pressCancel) return; //if(!mEnabled) return; // JSH 130906 Modify
            playBeepOnHold = true; //dg.jin 20141103 ITS 251755 presetlist longpress beep
            container.pressAndHold(container.target, container.buttonName);
            idAppMain.returnToTouchMode();
        }
        onReleased: {
            if((mouseArea.containsMouse == true) && (!isExited)){ // JSH 130717 Modify
                pressAndHoldFlag    = false;
                if(!mEnabled || pressCancel) return; //if(!mEnabled) return;  // JSH 130906 Modify
                container.clicked(container.target, container.buttonName);
                playBeepOn = true;     // JSH 130404
                // 20130410 modified by qutiguy - emit signal with 0 in touching
                //                clickOrKeySelected();
                console.log("############################  touch - before signal");
                idAppMain.enterType = 0;
                clickOrKeySelected(0);
                console.log("############################  touch - after signal");
            }
            clickReleased();    // JSH 121121
            if(isLongKey) // JSH 140129 ITS [0223318]
                isLongKey = false;
//            isExited  = false;  // JSH 130717
        }
        onMousePositionChanged: {
            //// 2013.11.14 added by qutiguy - ITS 0208894: to cancel touch event  when touch + HKey.
            if(!mEnabled || pressCancel){
                console.log("[CHECK_11_14_DRAG] : Mouse pressCanceled " + pressCancel );
                return;
            }
            ////
            mousePosChanged(mouseX,mouseY); // JSH 121121
        }
        onPressed: { //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)
            idAppMain.returnToTouchMode(); // JSH 130624
            container.pressedForFlickable(mouseX,mouseY);
            isExited            = false; // JSH 130717
            pressAndHoldFlag    = false;
            pressCancel         = false; // JSH 130906
        }
        onExited:  { // JSH 130717
            if(!mouseArea.pressed)
                return;

            isExited = true ;
            cancel();
        }
    }

    Keys.forwardTo: idAppMain;
    Keys.onPressed:{
        //if(!mEnabled) return;
        if(event.key == Qt.Key_Equal){return;} //HWS
        if(!idAppMain.isJogMode(event, true)){return;}
        if(mEnabled && idAppMain.isSelectKey(event)){
            //clickOrKeySelected();  // # because clickOrKeySelected() in Keys.onReleased by HYANG(120522)
            if(event.modifiers == Qt.ShiftModifier){ // Added by David.bae for Long Press
                //isLongKey = true; ,JSH 130711 deleted
                playBeepOnHold = false; //dg.jin 20141103 ITS 251755 presetlist longpress beep
                container.pressAndHold(container.target, container.buttonName);
            }else{
                selectKeyPressed();
            }
            //idAppMain.playBeep();
        }else if(idAppMain.isHomeKey(event)){
            homeKeyPressed();
        }else if(idAppMain.isBackKey(event)){
            // 20130423 added by qutiguy - set flag 0 if backkey.
            //idAppMain.enterType = 0;
            if(event.text == "ccp"){
                idAppMain.enterType = 2;
            } else if(event.text == "rrc"){
                idAppMain.enterType = 3;
            }
            backKeyPressed();
        }else if(idAppMain.isWheelRight(event)){
            wheelRightKeyPressed();
        }else if(idAppMain.isWheelLeft(event)){
            wheelLeftKeyPressed();
        }else if(idAppMain.isMenuKey(event)){
            clickMenuKey();
        }else if(idAppMain.isSeekPrev(event)){ //Add Seek Prev/Next jyjeon_2012-09-28
            seekPrevKeyPressed();
        }else if(idAppMain.isSeekNext(event)){
            seekNextKeyPressed();
        }else if(idAppMain.isTuneRight(event)){ //Add tune Right/left/Enter jyjeon_2012-10-10
            tuneRightKeyPressed();
        }else if(idAppMain.isTuneLeft(event)){
            tuneLeftKeyPressed();
        }else if(idAppMain.isTuneEnter(event)){
            if(event.modifiers == Qt.ShiftModifier){
                isLongKey = true;
                playBeepOnHold = false; //dg.jin 20141103 ITS 251755 presetlist longpress beep
                container.pressAndHold(container.target, container.buttonName);
            }else{
                tuneEnterKeyPressed();
            }
        }else if(idAppMain.isLeft(event)){ //# left Key added by HYANG (120511)
            leftKeyPressed();

      //add 8 move
        }else if(idAppMain.isUpLeft(event)){
            upLeftKeyPressed();
        }else if(idAppMain.isUpRight(event)){
            upRightKeyPressed();
        }else if(idAppMain.isDownLeft(event)){
            downLeftKeyPressed();
        }else if(idAppMain.isDownRight){
            downRightKeyPressed();
        }else {
            etcKeyPressed(event.key);
        }
    }
    Keys.onReleased:{
        //if(!mEnabled) return;
        if(event.key == Qt.Key_Equal){return;} //HWS
        if(idAppMain.upKeyReleased == true && event.key == Qt.Key_Up){ upKeyReleased(); }
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
            playBeepOn = false;     // JSH 130404 CCP no beep
            // 20130410 modified by qutiguy - emit signal with 1 in case key enter.(ccp enter: 2, rrc enter3)
            //            clickOrKeySelected(0);
            console.log("############################  CCP/RRC Enter - before signal");
            if(event.modifiers == Qt.ShiftModifier){ // Cancel key , JSH 130609
                cancel();
            }
            else{
                if(event.text == "ccp"){
                    idAppMain.enterType = 2;
                    clickOrKeySelected(2);
                } else if(event.text == "rrc"){
                    idAppMain.enterType = 3;
                    clickOrKeySelected(3);
                } else {
                    idAppMain.enterType = 1;
                    clickOrKeySelected(1);
                }
            }
            console.log("############################  CCP/RRC Enter - end");
        }else if(idAppMain.isTuneEnter(event)){ //Add tune Enter longKey jyjeon_2012-10-10
            event.accepted = true;
            tuneEnterLongKeyReleased();
        }
    }
}
