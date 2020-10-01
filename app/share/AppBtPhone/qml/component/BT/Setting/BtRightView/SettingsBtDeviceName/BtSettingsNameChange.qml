/**
 * BtSettingsNamaChange.qml
 *
 */
import QtQuick 1.1
import "../../../../QML/DH_arabic" as MCompArabic
import "../../../../QML/DH" as MComp
import "../../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePathArab
import "../../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idSettingsBtNameChange
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    /* propertys */
    property int hiddenCursor: 0
    property bool backButtonPressed: false
    property bool popupOn: (popupState != "") ? true : false
    property string hiddenText: ""
    /* 시스템 팝업이 떠있는 경우, 이 전 포커스 위치를 판단하는 변수
     * 0: 대기, 1: 키패드 포커스, 2: 입력창 포커스
     */
    property int focusPoint: 0


    /* functions */
    function cursorChanged() {
        // 커서 위치 변경 부분
        hiddenText = idTextInputDeviceName.text
        hiddenCursor = idTextInputDeviceName.cursorPosition

        idTextInputDeviceName.text = hiddenText + "a"

        idTextInputDeviceName.text = hiddenText
        idTextInputDeviceName.cursorPosition = hiddenCursor
    }

    function cursorFocus() {
        // 입력 창 포커스 이동 동작
        idTextInputDeviceName.forceActiveFocus();
        idTextInputDeviceName.cursorDelegate = idDelegateFocusCursor
        cursorChanged()

        if(idTextInputDeviceName.text.length != 0) {
            idTextHiden.show();
        }
        focusPoint = 2;
    }

    function cursorNormal() {
        if(idTextInputDeviceName.cursorDelegate == idDelegateFocusCursor) {
            // 입력 창 포커스 벗어나는 동작
            idTextInputDeviceName.cursorDelegate = idDelegateCursor
            cursorChanged();
            idTextHiden.hide();
        }
    }

    Connections {
        target : idAppMain
        onPopupDisplayToDeviceName : {
            idQwertyKeypad.sigSendJogCanceled();
            console.log("\n\n[BT]QML onPopupDisplayToDeviceName")
        }

        onSigPopupStateChanged: {
            /* ITS 0238170/0236422/0237335 기기명 변경 화면 > 로컬 팝업 > 시스템 팝업 > BT 다른 화면 진입 > CCP jog up > 포커스 사라짐
             * 기기명 변경화면으로 포커스 이동되지 않도록 조건문 추가
             */
            if(0 < callType){
                if("FOREGROUND" == callViewState){
                    //do nothing
                }
            } else {
                if("SettingsBtNameChange" == idAppMain.state) {
                    if(false == systemPopupOn) {
                        /* system 팝업이 뜨는 경우 */
                        console.log("\n\n onSigPopupStateChanged systemPopupOn : \n\n" + focusPoint)
                        if(true == idQwertyKeypad.activeFocus) {
                            focusPoint = 1;
                            idQwertyKeypad.hideKeypadFocus();
                        } else if(true == idTextInputDeviceName.activeFocus) {
                            focusPoint = 2;
                            cursorNormal();
                        }
                    } else {
                        if(false == popupOn) {
                            /* system 팝업과 local 팝업이 모두 닫힌 경우 */
                            console.log("\n\n onSigPopupStateChanged systemPopupOff : \n\n" + focusPoint)
                            if(1 == focusPoint) {
                                idQwertyKeypad.showKeypadFocus();
                            } else if(2 == focusPoint) {
                                cursorFocus();
                                idTextHiden.hide();
                            }
                            focusPoint = 0;
                        }
                    }
                } else {
                    //do nothing
                }
            }
        }
    }

    onPopupOnChanged: {
        if(true == popupOn) {
            /* local 팝업이 뜨는 경우 */
            idTextInputDeviceName.cursorDelegate = idDelegateCursor
            idTextHiden.hide();
        } else {
            if(true == idSettingsBtNameChange.visible) {
                if(true == systemPopupOn) {
                    /* local 팝업은 닫히고 system 팝업은 떠 있는 경우 */
                    idQwertyKeypad.hideKeypadFocus();
                } else {
                    if(1 == focusPoint) {
                        idQwertyKeypad.showKeypadFocus();
                    } else if(2 == focusPoint) {
                        cursorFocus();
                        idTextInputSearchHide.hide();
                    }
                }
            }
        }
    }

    Image {
        id: bgImgBtSettingsDeviceNameChange
        y: -93
        source: ImagePath.imgFolderGeneral + "bg_main.png"
    }

    MouseArea {
        anchors.fill:parent
        onClicked: {
            // do nothing
        }
    }

    onVisibleChanged: {
        if(true == idSettingsBtNameChange.visible) {
            if(3 < checkedCallViewStateChange) {
                checkedCallViewStateChange = 0;
                return;
            }
            idQwertyKeypad.forceActiveFocus();

            idTextInputDeviceName.text = BtCoreCtrl.m_strBtLocalDeviceName
            idQwertyKeypad.outputText = BtCoreCtrl.m_strBtLocalDeviceName
            idTextHiden.text = idTextInputDeviceName.text

            idTextInputDeviceName.cursorPosition = idTextInputDeviceName.text.length
            idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition
            idQwertyKeypad.currentCursor = idTextInputDeviceName.cursorPosition
            idQwertyKeypad.clearAutomata();
            cursorNormal();
        }
    }

    MComp.DDSimpleBandForDeviceName {
        id: idDeviceChangeNameBand
        titleText: stringInfo.str_Device_Name_Band

        //Jog 동작 추가 (커서 Show)
        Keys.onReleased: {
            if(Qt.ShiftModifier == event.modifiers) {
                event.accepted = true;
                return;
            }

            switch(event.key) {
                case Qt.Key_Down: {
                    cursorFocus();
                    break;
                }
            }
        }

        onBackBtnClicked: { popScreen(310); }
        onBackBtnKeyPressed: { popScreen(310); }
    }

    Image {
        source: 20 != gLanguage ? ImagePath.imgFolderPhoto + "bg_edit_new_inputbox.png" : ImagePathArab.imgFolderPhoto + "bg_edit_new_inputbox.png"
        x: 7
        y: systemInfo.titleAreaHeight + 10
        width: 1268
        height: 150
        
        Text {
            id: idTextNullInput
            text: stringInfo.str_Empty_Device_Name;
            x: 34
            y: 24
            width: 1197
            height: 46
            color: colorInfo.dimmedGrey
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: 20 != gLanguage ? Text.AlignLeft : Text.AlignRight
            visible: 0 ==  idTextInputDeviceName.text.length
        }

        TextInput {
            id: idTextInputDeviceName
            text: BtCoreCtrl.m_strBtLocalDeviceName
            x: 34
            width: 1197
            anchors.verticalCenter: idTextNullInput.verticalCenter
            horizontalAlignment: 20 == gLanguage && idTextInputDeviceName.text.length == 0 ? Text.AlignRight : undefined

            color: colorInfo.buttonGrey
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            maximumLength: 20
            cursorVisible: true
            cursorPosition: 0
            cursorDelegate: idDelegateCursor

            /* property */
            property bool upKeyPress: false

            /* event */
            onTextChanged: {
                if(true == backButtonPressed) {
                    /* Back Key가 눌린경우 1글자가 지워지므로 복원함(복원하지 않을 경우 1글자가 지워지며 Home으로 빠짐)
                     */
                    idTextInputDeviceName.text = idQwertyKeypad.outputText;
                    backButtonPressed = false;
                }

                if(idQwertyKeypad.pinyin != "") {
                    if(0 == idTextInputDeviceName.text.length) {
                        idQwertyKeypad.disableDeleteButton();
                    } else {
                        idQwertyKeypad.enableDeleteButton();
                    }
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    // UPDATE cursor position - 입력 창 터치될때 동작
                    idQwertyKeypad.initCommaTimer();
                    idTextInputDeviceName.cursorPosition = idTextInputDeviceName.positionAt(mouseX, TextInput.CursorOnCharacter);
                    idQwertyKeypad.currentCursor = idTextInputDeviceName.cursorPosition
                    idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition
                    idQwertyKeypad.clearAutomata();
                    cursorFocus();
                }
            }

            Keys.onPressed: {
                switch(event.key) {
                    case Qt.Key_Left: {
                        event.accepted = true;
                        break;
                    }

                    case Qt.Key_Right: {
                        event.accepted = true;
                        break;
                    }

                    /* HK Back 선택시 글씨 지워지고 화면 전환되는 문제점으로 Back Press 동작 하지 않도록 수정 */
                    case Qt.Key_Backspace:
                    case Qt.Key_J:
                    case Qt.Key_Comma: {
                        //back key
                        // [ITS 232873]
                        console.log("## Keys.onPressed(BACK)");
                        backButtonPressed = true;
                        popScreen(6578);
                        event.accepted = true;
                        break;
                    }
                }
            }

            Keys.onReleased: {

                // MComponent를 이용하지 않고 직접 키 처리
                if(Qt.ShiftModifier == event.modifiers) {
                    event.accepted = true;
                    return;
                }

                switch(event.key) {
                case Qt.Key_Return:
                case Qt.Key_Enter: {
                    cursorNormal()
                    idQwertyKeypad.forceActiveFocus();
                    idTextHiden.hide();
                    break;
                }
                case Qt.Key_Semicolon: {
                    //왼쪽 휠
                    if("" == idTextInputDeviceName.text) {
                        idTextHiden.hide();

                    } else {
                        idMarkerTimer.restart();
                        idTextHiden.show();
                        if(0 < cursorPosition) {
                            cursorPosition--;
                        } else {
                            //cursorPosition = idTextInputDeviceName.text.length;
                        }
                    }

                    idQwertyKeypad.currentCursor = idTextInputDeviceName.cursorPosition;
                    idQwertyKeypad.outputCursor = idTextInputDeviceName.cursorPosition
                    idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition
                    idQwertyKeypad.clearAutomata();
                    break;
                }

                case Qt.Key_Apostrophe: {
                    //오른쪽 휠
                    if("" == idTextInputDeviceName.text) {
                        idTextHiden.hide();

                    } else {
                        idMarkerTimer.restart();
                        idTextHiden.show();
                        if(idTextInputDeviceName.text.length > cursorPosition) {
                            cursorPosition++;
                        } else {
                            //cursorPosition = 0;
                        }
                    }

                    idQwertyKeypad.currentCursor = idTextInputDeviceName.cursorPosition;
                    idQwertyKeypad.outputCursor = idTextInputDeviceName.cursorPosition
                    idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition
                    idQwertyKeypad.clearAutomata();
                    break;
                }

                case Qt.Key_Backspace:
                case Qt.Key_J:
                case Qt.Key_Comma: {
                    break;
                }

                case Qt.Key_Up : {
                    if(upKeyPress == true) {
                        upKeyPress = false

                        if(idTextInputDeviceName.text.length != 0) {
                            idTextHiden.show();
                        } else {
                            cursorFocus()
                        }
                    } else {
                        cursorNormal()
                        idDeviceChangeNameBand.forceActiveFocus()
                    }
                    break;
                }

                case Qt.Key_Down : {
                    cursorNormal()
                    idQwertyKeypad.forceActiveFocus();
                    break;
                }

                case Qt.Key_Left: {
                    event.accepted = true;
                    break;
                }

                case Qt.Key_Right: {
                    event.accepted = true;
                    break;
                }

                default:
                    break;
                }
            }
        }

        TextInput {
            id: idTextHiden
            text: BtCoreCtrl.m_strBtLocalDeviceName

            x: 34
            y: 74
            width: 1197
            height: 60

            color: colorInfo.transparent
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            maximumLength: (true == idQwertyKeypad.pinyin) ? 32767 : 20
            cursorVisible: true
            cursorPosition: idTextInputDeviceName.cursorPosition
            cursorDelegate: idMarker

            visible: true

            state: "HIDE"

            MouseArea {
                anchors.fill: parent

                onPositionChanged: {
                    if(true == idSettingsBtNameChange.visible) {
                        if(true == popupOn){
                            idTextHiden.hide()
                        } else {
                            // UPDATE cursor position
                            idTextInputDeviceName.forceActiveFocus();
                            idTextHiden.cursorPosition = idTextHiden.positionAt(mouseX, TextInput.CursorOnCharacter);
                            idTextInputDeviceName.cursorPosition = idTextHiden.cursorPosition
                            idQwertyKeypad.currentCursor = idTextHiden.cursorPosition
                            idQwertyKeypad.clearAutomata();
                            idMarkerTimer.restart();
                        }
                    }
                }
            }

            function show() {
                idTextHiden.state = "SHOW";
                idMarkerTimer.restart();
            }

            function hide() {
                idTextHiden.state = "HIDE";
                idMarkerTimer.stop();
            }

            Timer {
                id: idMarkerTimer
                interval: 5000
                running: false
                repeat: false

                onTriggered: {
                    idTextHiden.hide();
                }
            }

            states: [
                State {
                    name: "SHOW";
                    PropertyChanges { target: idTextHiden;   opacity: 1; }
                }
                , State {
                    name: "HIDE";
                    PropertyChanges { target: idTextHiden;   opacity: 0; }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation { target: idTextHiden;   properties: "opacity";  duration: 500 }
                }
            ]
        }
    }

    // Cursor normal delegate
    Component {
        id: idDelegateCursor

        Item {
            y: 3
            width: 4
            height: 47

            Image {
                id: idDelegateCursorImage
                source: UIListener.m_sImageRoot + "keypad/cursor_n.png";

                SequentialAnimation {
                    running: idDelegateCursorImage.visible
                    loops: Animation.Infinite;

                    NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 1; duration: 100 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 0; duration: 100 }
                }
            }
        }
    }

    // Cursor focus delegate
    Component {
        id: idDelegateFocusCursor

        Item {
            y: 3
            width: 4
            height: 47

            Image {
                id: idDelegateCursorFocusImage
                source: UIListener.m_sImageRoot + "keypad/cursor_f.png";

                SequentialAnimation {
                    running: idDelegateCursorFocusImage.visible
                    loops: Animation.Infinite;

                    NumberAnimation { target: idDelegateCursorFocusImage; property: "opacity"; to: 1; duration: 100 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { target: idDelegateCursorFocusImage; property: "opacity"; to: 0; duration: 100 }
                }
            }
        }
    }

    Component {
        id: idMarker

        Rectangle {
            Image {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: -19
                source: ImagePath.imgFolderKeypad + "ico_marker.png"
            }
        }
    }

    MComp.QwertyKeypad {
        id: idQwertyKeypad
        //y: 243      //268 + 66 - 90  // (x: y: => qX: qY:)
        y: -93
        focus: true
        outputText: BtCoreCtrl.m_strBtLocalDeviceName

        doneType: "Done"
        currentCursor: idTextInputDeviceName.cursorPosition
        keypadInput: idTextInputDeviceName.text

        function cutOff(deviceName) {
            return deviceName.substring(0, 20);
        }

        function checkLength(deviceName) {
            return deviceName.length;
        }

        function update(empty) {
            if(true == empty) {
                idTextInputDeviceName.color = colorInfo.disableGrey;
                idTextInputDeviceName.maximumLength = 30;

                // Set default text.
                idTextInputDeviceName.text = ""
                idTextHiden.text = ""

                // Set cursor position.
                idTextInputDeviceName.cursorPosition = 0;
            } else {
                idTextInputDeviceName.color = colorInfo.buttonGrey;
                idTextInputDeviceName.cursorVisible = true;
                idTextInputDeviceName.maximumLength = 21

                // Set input text.
                idTextInputDeviceName.text = idQwertyKeypad.outputText;
                idTextHiden.text = idQwertyKeypad.outputText;

                // Set cursor position.
                if(idQwertyKeypad.currentCursor > idTextInputDeviceName.text.length) {
                    idQwertyKeypad.currentCursor = idTextInputDeviceName.text.length;
                }

                idTextInputDeviceName.cursorPosition = idQwertyKeypad.currentCursor
                idTextHiden.cursorPosition = idQwertyKeypad.currentCursor;;
            }
        }

        function truncate() {
            // 제일 뒤 문자 1개 삭제
            if(1 > idQwertyKeypad.outputText.length - 1) {
                // 삭제 뒤 Length가 0가 된 경우
                idQwertyKeypad.outputText = "";
                update(true);
            } else {
                if(idQwertyKeypad.currentCursor < idQwertyKeypad.outputText.length) {
                    // 중간에 삽입된 경우
                    idQwertyKeypad.outputText = idQwertyKeypad.outputText.substring(0, idQwertyKeypad.currentCursor - 1)
                            + idQwertyKeypad.outputText.substring(idQwertyKeypad.currentCursor);
                    idQwertyKeypad.currentCursor = idQwertyKeypad.currentCursor - 1;
                } else {
                    // 제일 뒤에 추가된 경우
                    idQwertyKeypad.outputText = idQwertyKeypad.outputText.substr(0, idQwertyKeypad.outputText.length - 1);
                }

                update(false);
            }
        }

        function saveDeviceName() {
            if("" != idQwertyKeypad.outputText) {
                if(20 >= checkLength(idQwertyKeypad.outputText)) {
                    changedDeviceName = idQwertyKeypad.outputText;
                    BtCoreCtrl.invokeSetDeviceName(changedDeviceName)
                    popScreen(311);
                    return;
                } else {
                    idQwertyKeypad.initCommaTimer();
                    MOp.showPopup("popup_device_name_limit_length");
                }
            } else {
                MOp.showPopup("popup_device_name_empty");
            }

            // idQwertyKeypad.showQwertyKeypad();
        }

        Component.onCompleted: {
            idTextInputDeviceName.cursorPosition = idQwertyKeypad.outputText.length;
            idTextHiden.cursorPosition = idQwertyKeypad.outputText.length;
        }

        onActiveFocusChanged: {
            if(true == idQwertyKeypad.activeFocus){
                focusPoint = 1;
            }
        }

        onOutputTextChanged: {
            idTextHiden.hide();
            idTextInputDeviceName.cursorDelegate = idDelegateCursor

            // 키패드 입력 되는 시점에 키패드로 먼저 포커스 이동 시킴
            idQwertyKeypad.forceActiveFocus();

            if(true == idQwertyKeypad.pinyin && false == idQwertyKeypad.pinyinComplete) {
                if(20 == idTextInputDeviceName.text.length && 1 == idQwertyKeypad.lastPinYinPosition) {
                    // 20글자에서 추가되는 경우 입력 막음
                    idQwertyKeypad.initCommaTimer();
                    MOp.showPopup("popup_device_name_limit_length");
                    idQwertyKeypad.outputText = cutOff(idQwertyKeypad.outputText);
                    idQwertyKeypad.clearAutomata();
                } else {
                    if(1 > idQwertyKeypad.outputText.length) {
                        update(true);
                    } else {
                        update(false);

                        // PinYin 입력 중 미완성 글자에 대한 반전효과
                        idTextInputDeviceName.select(idTextInputDeviceName.text.length - idQwertyKeypad.lastPinYinPosition, idTextInputDeviceName.text.length);
                    }
                }
            } else {
                if(1 > idQwertyKeypad.outputText.length) {
                    update(true);
                } else if(20 < idQwertyKeypad.outputText.length) {
                    /* Limited characters */
                    //update(false);
                    truncate();
                    idQwertyKeypad.initCommaTimer();
                    MOp.showPopup("popup_device_name_limit_length");
                } else {
                    update(false);
                }
            }
        }

        onSigLostFocus: {
            idTextInputDeviceName.upKeyPress = true
            cursorFocus()
        }

        onKeyOKClicked: {
            if("" != idQwertyKeypad.outputText) {
                saveDeviceName();
            } else {
                MOp.showPopup("popup_device_name_empty");

                // TODO: ddingddong 확인 필요
                idQwertyKeypad.showQwertyKeypad();
            }
        }

        //isHide: idBtSettinsSearchListView.forceActiveFocus()
        onBackKeyPressed: {
            btPhoneEnter = false;
            popScreen(313);
        }
    }
}/* EOF */
