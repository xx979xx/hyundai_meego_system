import Qt 4.7

//import "../../system/DH" as MSystem
FocusScope {
    id: container

    signal clicked(string target, string button)
    signal pressAndHold(string target, string button)
    signal pressed();

    property bool showFocus : idAppMain.focusOn;
    property bool playBeepOn : true;

    property bool mEnabled: true;

    property bool dimmed : false;

    signal clickOrKeySelected()
    signal selectKeyPressed()
    signal homeKeyPressed()
    signal backKeyPressed()
    signal wheelRightKeyPressed()
    signal wheelLeftKeyPressed()
    signal clickMenuKey()
    signal etcKeyPressed(int key)
    signal selectKeyReleased()
    signal anyKeyReleased() //# added by HYANG (120425)
//    signal leftKeyPressed(); //# added by HYANG (120511)

    //add jog keypad 8move
    signal upLeftKeyPressed()
    signal upRightKeyPressed()
    signal downRightKeyPressed()
    signal downLeftKeyPressed()

    function isMousePressed()
    {
        return mouseArea.pressed && !dimmed && mEnabled; //Added by David Bae.
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if(!mEnabled) return;
            //if(playBeepOn) idAppMain.playBeep(); //jyjeon_20120723 : move to MButton
            //console.debug(bgTxt.width);
            container.clicked(container.target, container.buttonName);
            container.clickOrKeySelected();
        }
        onPressAndHold: {
            if(!mEnabled) return;
            //if(playBeepOn) idAppMain.playBeep(); //jyjeon_20120723 : move to MButton
            container.pressAndHold(container.target, container.buttonName);
            idAppMain.returnToTouchMode();
        }
        onPressed: {
            if(!mEnabled) return;
            idAppMain.returnToTouchMode();
            container.pressed();
        }
    }

    Keys.forwardTo: idAppMain;
    Keys.onPressed:{
        //if(!mEnabled) return;
        if(!idAppMain.isJogMode(event, true)){return;}
        if(mEnabled && idAppMain.isSelectKey(event)){
            //clickOrKeySelected();  // # because clickOrKeySelected() in Keys.onReleased by HYANG(120522)
            if(event.modifiers == Qt.ShiftModifier){ // Added by David.bae for Long Press
                isLongKey = true;
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
            wheelRightKeyPressed();
        }else if(idAppMain.isWheelLeft(event)){
            wheelLeftKeyPressed();
        }else if(idAppMain.isMenuKey(event)){
            clickMenuKey();
        }/*else if(idAppMain.isLeft(event)){
            leftKeyPressed();
        }*/else if(idAppMain.isUpLeft(event)){
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
        anyKeyReleased()   //# added by HYANG (120425)
        selectKeyReleased();   // problem Kang
        if(isLongKey){ // Added by David.bae for Long Press
            event.accepted = true;
            isLongKey = false;
            return;
        }
        if(!idAppMain.isJogMode(event, false)){ return;}
        if(mEnabled && idAppMain.isSelectKey(event)){
            event.accepted = true; //jyjeon_20120606
            clickOrKeySelected();
        }

    }
}
