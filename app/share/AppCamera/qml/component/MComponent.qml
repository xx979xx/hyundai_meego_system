import Qt 4.7

import "../system/operation.js" as MOp

FocusScope {
    id: container

    signal clicked(string target, string button);
    //signal pressAndHold(string target, string button)
    signal pressed();
    signal released();
    signal exited();

    property bool showFocus : idAppMain.focusOn;
    property bool playBeepOn : true;
    property bool enableClick: true;

    property bool mEnabled: true;

    property bool dimmed : false;

    signal clickOrKeySelected()
    signal keySelected()

    signal selectKeyPressed()
    signal homeKeyPressed()
    signal backKeyPressed()
    signal wheelRightKeyPressed()
    signal wheelLeftKeyPressed()
    signal clickMenuKey()
    signal etcKeyPressed(int key)
    signal selectKeyReleased()
    signal leftKeyPressed(); //# added by HYANG (120511)
    signal rightKeyPressed(); //# added by HYANG (120511)
    signal upKeyPressed(); //# added by HYANG (120511)
    signal downKeyPressed(); //# added by HYANG (120511)

    function isMousePressed()
    {
        return mouseArea.pressed && !dimmed && mEnabled; //Added by David Bae.
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: enableClick
        onClicked: {
            if (!mEnabled) return;
//            if (playBeepOn)
//                idAppMain.playBeep();
            //console.debug(bgTxt.width);
            container.forceActiveFocus();
            container.clicked(container.target, container.buttonName);
            container.clickOrKeySelected();
        }
//        onPressAndHold: {
//            if (!mEnabled) return;
//            if (playBeepOn)
//                idAppMain.playBeep();
//            container.pressAndHold(container.target, container.buttonName);
//            //idAppMain.returnToTouchMode();
//        }
        onPressed: {
            if (!mEnabled) return;
            if (playBeepOn)
                idAppMain.playBeep();
            //idAppMain.returnToTouchMode();
            container.pressed();
        }

        onReleased: container.released();
        onExited: container.exited(); //depress image
    }

    Keys.forwardTo: idAppMain;
    Keys.onPressed:{
//        if (playBeepOn)
//            idAppMain.playBeep();  // Hard keys no need beep. (2013/03/28)
        //if (!mEnabled) return;
        if (!idAppMain.isJogMode(event, true)) {return;}
        if (mEnabled && idAppMain.isSelectKey(event)) {
            //clickOrKeySelected();  // # because clickOrKeySelected() in Keys.onReleased by HYANG(120522)
//            if (event.modifiers == Qt.ShiftModifier) { // Added by David.bae for Long Press
//                isLongKey = true;
//                //container.pressAndHold(container.target, container.buttonName);
//            }else{
            selectKeyPressed();
//            if (idShortWideMenu.visible) {
//                idShortWideMenu.visible = false;
//                restoreViewFocus();
//                MOp.toggleWideMenus(1);
//            }
            //}
            //idAppMain.playBeep();
            if (cppToqml.IsDHPE) {
                checkAndshowMenuBar();
            }
        }else if (idAppMain.isHomeKey(event)) {
            homeKeyPressed();
        }else if (idAppMain.isBackKey(event)) {
            backKeyPressed();
        }else if (idAppMain.isWheelRight(event)) {
            wheelRightKeyPressed();
            if (!cppToqml.IsDHPE) {
                if (idShortWideMenu.visible) {
                    idShortWideMenu.visible = false;
                    restoreViewFocus();
                    MOp.toggleWideMenus(1);
                }
            }
            else {
                checkAndshowMenuBar();
            }
        }else if (idAppMain.isWheelLeft(event)) {
            wheelLeftKeyPressed();
            if (!cppToqml.IsDHPE) {
                if (idShortWideMenu.visible) {
                    idShortWideMenu.visible = false;
                    restoreViewFocus();
                    MOp.toggleWideMenus(1);
                }
            }
            else {
                checkAndshowMenuBar();
            }
        }else if (idAppMain.isMenuKey(event)) {
            clickMenuKey();
            if (!cppToqml.IsDHPE) {
                if (idShortWideMenu.visible) {
                    idShortWideMenu.visible = false;
                    restoreViewFocus();
                    MOp.toggleWideMenus(1);
                }
            }
            else {
                checkAndshowMenuBar();
            }
        }else if (idAppMain.isLeft(event)) { //# left Key added by HYANG (120511)
            leftKeyPressed();
            if (cppToqml.IsDHPE) {
                checkAndshowMenuBar();
            }
        }else if (idAppMain.isRight(event)) { //# left Key added by HYANG (120511)
            rightKeyPressed();
            if (cppToqml.IsDHPE) {
                checkAndshowMenuBar();
            }
        }else if (idAppMain.isUp(event)) { //# left Key added by HYANG (120511)
            upKeyPressed();
            if (cppToqml.IsDHPE) {
                checkAndshowMenuBar();
            }
        }else if (idAppMain.isDown(event)) { //# left Key added by HYANG (120511)
            downKeyPressed();
            if (cppToqml.IsDHPE) {
                checkAndshowMenuBar();
            }
        }else {
            etcKeyPressed(event.key);
        }
    }
    Keys.onReleased:{
        //if (!mEnabled) return;

        selectKeyReleased();   // problem Kang
//        if (isLongKey) { // Added by David.bae for Long Press
//            event.accepted = true;
//            isLongKey = false;
//            return;
//        }
        if (!idAppMain.isJogMode(event, false)) { return;}
        if (mEnabled && idAppMain.isSelectKey(event)) {
            event.accepted = true; //jyjeon_20120606
            clickOrKeySelected();
            keySelected();
        }
    }

    Connections {
        target: UIListener
        onKeyCanceled: selectKeyReleased();
    }

    function checkAndshowMenuBar() {
        if (avmMenuBtnType==1 || avmMenuBtnType==2) {
            idMenuTimer.stop();
            if (!avmMenus.visible) {
                avmMenus.visible = true;
            }
            idMenuTimer.start();
        }
    }

}
