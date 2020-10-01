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

    property bool mEnabled: true; // true(enabled), false(dimmed, disabled) << Modified by WSH (130103)
    property bool pressAndHoldFlag: false   //-Touch Press/Release Issue (130301)
    property bool pressCancel: false

    signal clickOrKeySelected()
    signal selectKeyPressed()
    signal homeKeyPressed()
    signal backKeyPressed()
    signal wheelRightKeyPressed(int count)
    signal wheelLeftKeyPressed(int count)
    signal seekPrevKeyReleased() //Add Seek Prev/Next jyjeon_2012-09-28
    signal seekNextKeyReleased() //Add Seek Prev/Next jyjeon_2012-09-28
    signal tuneRightKeyPressed()  //Add tune Right/left/Enter jyjeon_2012-10-10
    signal tuneLeftKeyPressed()   //Add tune Right/left/Enter jyjeon_2012-10-10
    signal tuneEnterKeyPressed()  //Add tune Right/left/Enter jyjeon_2012-10-10
    signal tuneEnterLongKeyReleased(); //Add tune Enter longKey jyjeon_2012-10-10
    signal clickMenuKey()
    signal etcKeyPressed(int key)
    signal selectKeyReleased()
    signal anyKeyPressed(int event) //#KEH 130904

    //add jog keypad 8move
    signal upLeftKeyPressed()
    signal upRightKeyPressed()
    signal downRightKeyPressed()
    signal downLeftKeyPressed()

    signal upKeyReleased(int event)
    signal pressedForFlickable();   //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)
    signal cancel();

    function isMousePressed()
    {
        return mouseArea.pressed && mEnabled; //Added by David Bae.
    }

    //-Touch Press/Release Issue (130301)
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        property bool isExited: false
        onPressAndHold: {
            pressAndHoldFlag = true
            if(!mEnabled || pressCancel) return;
            container.pressAndHold(container.target, container.buttonName);
            idAppMain.returnToTouchMode();
        }

        onReleased: {
            if((mouseArea.containsMouse == true) && (!isExited)){
                if(!mEnabled || pressCancel) return;

                container.clicked(container.target, container.buttonName);
                container.clickOrKeySelected();

            }
            pressAndHoldFlag = false;
        }

        onPressed: {
            idAppMain.isSeekLongCheckForceRelease()
            container.pressedForFlickable();
            isExited = false;
            pressAndHoldFlag = false;
            pressCancel = false;
        } //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)

        onExited: {
            if(!mouseArea.pressed) return;
            isExited = true;
            cancel();
        }
    }

    Keys.forwardTo: idAppMain;
    Keys.onPressed:{
        //if(!mEnabled) return;
        if(event.modifiers != Qt.ShiftModifier){
            anyKeyPressed(event.key)
        }
        //console.debug("=============MComponet.qml : Keys.onPressed : event.key = " + event.key + " key_Equal = " + Qt.Key_Equal);
        if(event.key == Qt.Key_Equal){return;}
        if(!idAppMain.isJogMode(event, true)){return;}

        if(event.modifiers == Qt.NoModifier){
            idAppMain.isSeekLongCheckForceRelease()
        }

        if(mEnabled && idAppMain.isSelectKey(event)){
            if(event.modifiers == Qt.ShiftModifier){ // Added by David.bae for Long Press
                pressAndHoldFlag = true
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
            clickMenuKey();
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
        //if(!mEnabled) return;
        //        console.debug("=============MComponet.qml : Keys.onReleased : event.key = " + event.key + " key_Equal = " + Qt.Key_Equal);
        if(event.key == Qt.Key_Equal){return;}
        if(idAppMain.upKeyReleased == true && event.key == Qt.Key_Up){ upKeyReleased(event.key); }

        selectKeyReleased();
        if(isLongKey){ // Added by David.bae for Long Press
	    event.accepted = true;
            isLongKey = false;
            return;
        }
        if(!idAppMain.isJogMode(event, false)){ return;}
        if(mEnabled && idAppMain.isSelectKey(event)){
            event.accepted = true; //jyjeon_20120606
            if(event.modifiers == Qt.ShiftModifier){
                cancel();
            }
            else{
                playBeepOn = false;
                clickOrKeySelected();
                playBeepOn = true;
            }
              pressAndHoldFlag = false;
        }else if(idAppMain.isTuneEnter(event)){ //Add tune Enter longKey jyjeon_2012-10-10
            event.accepted = true;
            tuneEnterLongKeyReleased();
        }
        else if(idAppMain.bSeekPrevKeyReleased == true && event.key == Qt.Key_Q){ seekPrevKeyReleased(); }
        else if(idAppMain.bSeekNextKeyReleased == true && event.key == Qt.Key_W){ seekNextKeyReleased(); }
    }
    Connections {
           target: idAppMain
           onPressCancelSignal:{
               if(mouseArea.pressed){
                   pressCancel = true;
                   cancel();
               }
           }

           onPressCancelJogSignal: {
               if(pressAndHoldFlag == true) {
                   cancel();
               }
           }
       }
}
