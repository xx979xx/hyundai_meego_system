import Qt 4.7

import "../System" as MSystem

FocusScope {
    id: container

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id:imageInfo }

    signal clicked(string target, string button)
    signal pressAndHold(string target, string button)
    signal pressed();

    property bool showFocus : idAppMain.focusOn;
    property bool playBeepOn : true;
    property bool pressAndHoldFlag: false
    property bool mEnabled: true;

    property bool mPlayBeep: false

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
    signal leftKeyPressed(); //# added by HYANG (120511)
    signal rightKeyPressed(); //added for Password UpKeyPress Issue
    signal upKeyPressed(); //added for Password UpKeyPress Issue
    signal downKeyPressed();//added for Password UpKeyPress Issue
    signal pressedForFlickable();           //# 5s Timer stop() for Flickable as OptionMenu : KEH (20130416)
    signal mousePosChanged(int x,int y)

    function isMousePressed()
    {
        return mouseArea.pressed && !dimmed && mEnabled; //Added by David Bae.
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        beepEnabled: mPlayBeep
        noClickAfterExited: true
        onClicked: {
            if(!mEnabled) return;
            //if(playBeepOn)
            //    idAppMain.playBeep();
            //console.debug(bgTxt.width);
            container.clicked(container.target, container.buttonName);
            container.clickOrKeySelected();
        }
        onPressAndHold: {
            if(!mEnabled) return;
            if(playBeepOn)
                idAppMain.playBeep();
            container.pressAndHold(container.target, container.buttonName);
            idAppMain.returnToTouchMode();
        }
        onPressed: {
            if(!mEnabled) return;
            idAppMain.returnToTouchMode();
            container.pressed();
            container.pressedForFlickable();
        }
        onReleased:
        {
            if(!mEnabled){
                return;
            }
            container.released(mouseX, mouseY);
        }

        onExited: {
            mouseAreaExit();
        }

        onMousePositionChanged: mousePosChanged(mouseX,mouseY);

    }

    Keys.forwardTo: idAppMain;
    Keys.onPressed:{
        //if(!mEnabled) return;
        //if(!idAppMain.isJogMode(event, true)){return;}
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
        }else if(idAppMain.isLeft(event)){ //# left Key added by HYANG (120511)
            leftKeyPressed();
        }else if(idAppMain.isRight(event)){ //added for Password UpKeyPress Issue
            rightKeyPressed();
        }else if(idAppMain.isUp(event)){
            upKeyPressed();
        }else if(idAppMain.isDown(event)){
            downKeyPressed();
        }//added for Password UpKeyPress Issue
        else {
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
