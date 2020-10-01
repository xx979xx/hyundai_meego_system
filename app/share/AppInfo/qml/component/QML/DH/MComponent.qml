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
    signal released();

    function isMousePressed()
    {
        return mouseArea.pressed & !dimmed;
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if(playBeepOn)
                idAppMain.playBeep();
            //console.debug(bgTxt.width);
            container.clicked(container.target, container.buttonName);
            container.clickOrKeySelected();
        }
        onPressAndHold: {
            if(playBeepOn)
                idAppMain.playBeep();
            container.pressAndHold(container.target, container.buttonName);
            idAppMain.returnToTouchMode();
        }
        onPressed: {
            idAppMain.returnToTouchMode();
            container.pressed();
        }
        onReleased: {
            container.released();
        }
    }

    Keys.forwardTo: idAppMain;
    Keys.onPressed:{
        //if(!idAppMain.isJogMode(event)){ return;}
        if(idAppMain.isSelectKey(event)){
            clickOrKeySelected();
            selectKeyPressed();
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
        }else {
            etcKeyPressed(event.key);
        }
    }
    Keys.onReleased:{
            selectKeyReleased();
    }
}
