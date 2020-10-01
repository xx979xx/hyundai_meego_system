/**
 * /QML/DH/MComponent.qml
 *
 */
import QtQuick 1.1


FocusScope
{
    id: container


    // PROPERTIES
    property bool mEnabled: true
    property bool dimmed: false
    property bool playLongPressBeep: false

    // SIGNALS
    signal clicked(string target, string button)
    signal pressAndHold(string target, string button)
    signal pressed(int x, int y);
    signal released(int x, int y);

    signal clickOrKeySelected()
    signal selectKeyPressed()
    //DEPRECCATED signal homeKeyPressed()
    signal backKeyPressed()
    signal wheelRightKeyPressed()
    signal wheelLeftKeyPressed()
    signal clickMenuKey()
    signal etcKeyPressed(int key)
    signal selectKeyReleased()
    signal anyKeyReleased()
    signal leftKeyPressed()
    signal rightKeyPressed()

    signal upLeftKeyPressed()
    signal upRightKeyPressed()
    signal downRightKeyPressed()
    signal downLeftKeyPressed()

    signal leftKeyReleased()
    signal rightKeyReleased()
    signal cancel();


    function isMousePressed() {
        return mouseArea.pressed && !dimmed && mEnabled;
    }

    /* WIDGETS */
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        beepEnabled: false
        noClickAfterExited: true

        onClicked: {
            if(false == mEnabled) {
                return;
            }

            if(true == dimmed) {
                return;
            }

            //DEPRECATED if(playBeepOn) idAppMain.playBeep();
            container.clicked(container.target, container.buttonName);
            
            // 터치 동작 중간에 HK 입력이 있으면 Release 동작 안하도록 수정
            if(inputMode == "touch") {
                container.clickOrKeySelected();
            }
            
            // 버튼 동작 이후 Menu 가 표시 된 경우 Menu로 포커스 전달 하도록 수정
            if(true == menuOn) {
                idMenu.forceActiveFocus();
            }
        }

        onPressed: {
            if(!mEnabled) {
                return;
            }

            idAppMain.returnToTouchMode();
            container.pressed(mouseX, mouseY);
        }

        onReleased: {
            if(!mEnabled) {
                return;
            }

            console.log("mouseX : " + mouseX + "  mouseY : " + mouseY)
            container.released(mouseX, mouseY);
        }

        onExited: {
            mouseAreaExit();
        }
    }

    Keys.forwardTo: idAppMain;

    Keys.onPressed: {

        //[ITS 0270332] AADefend H/U Key제어
        if(idAppMain.mainGetAADefendVisible()){
            idAppMain.mainAADefendKeyHandler(event);
            return;
        }

        idAppMain.returnToJogMode();
        /*if(!idAppMain.isJogMode(event, true)) {
            return;
        }*/

        /* UISH 또는 KeypadWidget 버그로 판단되며, 임시 방어코드 추가함
         */
        gIgnoreReleased = 1;

        if(true == mEnabled && idAppMain.isSelectKey(event)) {
            //DEPRECATED clickOrKeySelected();
            if(event.modifiers == Qt.ShiftModifier) {
                // Long Press 시 비프음 추가
                if(true == playLongPressBeep) {
                    UIListener.ManualBeep();
                }

                //isLongKey = true;
                //DEPRECATED pressAndHold(container.target, container.buttonName);
            } else {
                selectKeyPressed();
            }

            // accepted = true 로 설정하지 않으면 이벤트가 여러번 발생함
            event.accepted = true;
            //idAppMain.playBeep();
        } else if(idAppMain.isHomeKey(event)) {
            /* Signal로 전달할 필요없이 바로 HOME key 처리하도록 수정
             */
            //homeKeyPressed();
            UIListener.invokePostHomeKey();
        } else if(idAppMain.isBackKey(event)) {
            backKeyPressed();
        } else if(idAppMain.isWheelRight(event)) {
            wheelRightKeyPressed();
        } else if(idAppMain.isWheelLeft(event)) {
            wheelLeftKeyPressed();
        } else if(idAppMain.isMenuKey(event)){
            clickMenuKey();
        } else if(idAppMain.isLeft(event)) {
            leftKeyPressed();
        } else if(idAppMain.isRight(event)) {
            rightKeyPressed();
        } else if(idAppMain.isUpLeft(event)) {
            upLeftKeyPressed();
        } else if(idAppMain.isUpRight(event)) {
            upRightKeyPressed();
        } else if(idAppMain.isDownLeft(event)) {
            downLeftKeyPressed();
        } else if(idAppMain.isDownRight(event)) {
            downRightKeyPressed();
        } else {
            etcKeyPressed(event.key);
        }
    }

    Keys.onReleased: {
        idAppMain.returnToJogMode();

        //if(!mEnabled) return;

        /* UISH 또는 KeypadWidget 버그로 판단되며, 임시 방어코드 추가함
         *
         * KeypadWidget에서 CCP OK를 누른경우(Done), 아래의 순서로 이벤트가 전달되어
         * Release Event를 무시해야 하는 케이스가 발생함
         * 1) Pressed
         * 2) KeypadWidget의 Released
         * 3) Released(Keypad가 사라지고 난 이전 화면으로 전달)
         *
         * KeypadWidget에서 CCP OK를 누른 경우 2로 설정됨
         * 2로 설정될 경우 Release Event를 무시함
         * (Touch의 경우 Pressed, Released Event가 발생하지 않음)
         */
        if(true == isLongKey) {
            isLongKey = false;

            if(true == mEnabled && idAppMain.isSelectKey(event)) {
                event.accepted = true;
            }

            return;
        }

        if(1 == gIgnoreReleased) {
            gIgnoreReleased = 0;
        } else {
            event.accepted = true;
            return;
        }

        selectKeyReleased();
        anyKeyReleased();

        /*if(!idAppMain.isJogMode(event, false)) {
            return;
        }*/

        if(true == mEnabled && idAppMain.isSelectKey(event)) {
            if(event.modifiers == Qt.ShiftModifier){
                cancel();
            } else {
                event.accepted = true;
                clickOrKeySelected();
            }
        } else if(idAppMain.isLeft(event)){ // WSH(130320)
            event.accepted = true;
            leftKeyReleased();
            //EngineListener.jogKeyPressed(0 /*Left*/);
        } else if(idAppMain.isRight(event)){ // WSH(130320)
            event.accepted = true;
            rightKeyReleased();
            //EngineListener.jogKeyPressed(1 /*Right*/);
        }
    }
}
/* EOF */
