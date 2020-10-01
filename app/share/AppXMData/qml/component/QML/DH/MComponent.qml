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

FocusScope {
    id: container

    signal clicked(string target, string button)
    signal pressAndHold(string target, string button)
    signal pressed();

    property bool playBeepOn : true;
    property bool showFocus : idAppMain.focusOn;

    property bool mEnabled: true; // true(enabled), false(dimmed, disabled) << Modified by WSH (130103)
    property bool pressAndHoldFlag: false   //-Touch Press/Release Issue (130301)
    property bool isChangeRow: false
    property bool isKeyPressed: false

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

    signal mousePressChanged(bool isPressed)
    signal mousePosChanged(int x,int y)     // JSH 121121
    signal clickOrKeyPosition(int x,int y)  // JSH 121121
    signal clickReleased()            // JSH 121121

    signal upKeyReleased()

    function isMousePressed()
    {
        return ((mouseArea.pressed && mouseArea.isMovedInside)|| isKeyPressed) && mEnabled; //Added by David Bae.
    }

    function isMousePressedOnly()
    {
        return ((mouseArea.pressed && mouseArea.isMovedInside)) && mEnabled; //Added by David Bae.
    }

    //-Touch Press/Release Issue (130301)
    MouseArea {
        id: mouseArea
        anchors.fill: parent
//        onClicked: {
//            if(!mEnabled) return;
//            container.clickOrKeyPosition(mouseX,mouseY); // JSH 121121
//        }
        property bool isMovedInside: false
        onPressed: {
            playBeepOn = true;
            isMovedInside = true;
            mousePressChanged(true);
        }

        onExited: {
            isMovedInside = false;
        }

        onPressAndHold: {
            pressAndHoldFlag = true;
            if(!mEnabled) return;
            container.pressAndHold(container.target, container.buttonName);
//            idAppMain.returnToTouchMode();
        }

        onReleased: {
            if(mouseArea.containsMouse == true && isMovedInside == true){
                pressAndHoldFlag = false;
                if(!mEnabled) return;
                container.clicked(container.target, container.buttonName);
                container.clickOrKeySelected();
                container.clickOrKeyPosition(mouseX,mouseY); // JSH 121121
                clickReleased(); // JSH 121121
            }else
            {
                if(isChangeRow)
                {
                    pressAndHoldFlag = false;
                    if(!mEnabled) return;
                    container.clicked(container.target, container.buttonName);
                    container.clickOrKeySelected();
                    container.clickOrKeyPosition(mouseX,mouseY);
                    clickReleased();
                }
            }
            isMovedInside = false;
            mousePressChanged(false);
        }

        onMousePositionChanged: mousePosChanged(mouseX,mouseY); // JSH 121121
    }

    Keys.forwardTo: idAppMain;
    Keys.onPressed:{
        //if(!mEnabled) return;

//        console.debug("=============MComponet.qml : Keys.onPressed : event.key = " + event.key + " key_Equal = " + Qt.Key_Equal);

         // For SystemPopup Test
        if(event.modifiers != Qt.ShiftModifier) // long key is not initialized.
            idAppMain.isLongKeyForDRS = false;
        if(debugOnOff == true)
        {
            if(idAppMain.isBackKey(event))
            {
                weatherDataManager.testSystemPopup();
                event.accepted = true;
                return;
            }
        }
        if(event.key == Qt.Key_Equal){return;}
        if(!idAppMain.isJogMode(event, true)){return;}
        if(mEnabled && idAppMain.isSelectKey(event)){
            //clickOrKeySelected();  // # because clickOrKeySelected() in Keys.onReleased by HYANG(120522)
            if(event.modifiers == Qt.ShiftModifier){ // Added by David.bae for Long Press
                isLongKey = true;
//                playBeepOn = true;
                container.pressAndHold(container.target, container.buttonName);
                playBeepOn = false;
            }else{
                playBeepOn = false;
                isKeyPressed = true;
                event.accepted = true;
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
        }else if(idAppMain.isSeekPrev(event)){ // Modified dhjung_2012-10-26
            if(event.modifiers == Qt.ShiftModifier){
                console.log(" [QML] #############  Seek Prev Long Key Pressed #############")
                isLongKey = true;
                seekPrevLongKeyPressed();
            }else{
                isLongKey = false;
                seekPrevKeyPressed();
                return;
            }
        }else if(idAppMain.isSeekNext(event)){ // Modified dhjung_2012-10-26
            if(event.modifiers == Qt.ShiftModifier){
                console.log(" [QML] #############  Seek Next Long Key Pressed #############")
                isLongKey = true;
                seekNextLongKeyPressed();
            }else{
                isLongKey = false;
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
        }else {
            etcKeyPressed(event.key);
        }
    }
    Keys.onReleased:{
        //if(!mEnabled) return;
//        console.debug("=============MComponet.qml : Keys.onReleased : event.key = " + event.key + " key_Equal = " + Qt.Key_Equal);
        isKeyPressed = false;
        if(event.key == Qt.Key_Equal){return;}
        if(event.modifiers == Qt.ShiftModifier) // Key_cancel
        {
            event.accepted = true;
            isLongKey = false;
            return;
        }

        if(idAppMain.upKeyReleased == true && event.key == Qt.Key_Up)
        {
            upKeyReleased();
        }

        anyKeyReleased()   //# added by HYANG (120425)
        selectKeyReleased();   // problem Kang
        if(idAppMain.isLongKeyForDRS && idAppMain.isSelectKey(event))
        {
            event.accepted = true;
            isLongKey = false;
            idAppMain.isLongKeyForDRS = false;
            return;
        }
        if(isLongKey){ // Added by David.bae for Long Press
            event.accepted = true;
            isLongKey = false;
            clickOrKeySelected();
            return;
        }
        if(!idAppMain.isJogMode(event, false)){ return;}
        if(mEnabled && idAppMain.isSelectKey(event)){
            event.accepted = true; //jyjeon_20120606
            playBeepOn = false;
            clickOrKeySelected();
        }else if(idAppMain.isTuneEnter(event)){ //Add tune Enter longKey jyjeon_2012-10-10
            event.accepted = true;
            tuneEnterLongKeyReleased();
        }
    }
    Connections{
        target: UIListener
        onReleaseTouchPress:{
            mouseArea.isMovedInside = false;
            idAppMain.isLongKeyForDRS = true;
            isKeyPressed = false;
        }
    }
}
