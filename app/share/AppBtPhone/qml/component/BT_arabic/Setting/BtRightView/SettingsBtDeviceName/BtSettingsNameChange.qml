/**
 * BtSettingsNamaChange.qml
 *
 */
import QtQuick 1.1
import "../../../../QML/DH_arabic" as MComp
import "../../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idSettingsBtNameChange
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true

    property bool backButtonPressed: false
    property bool popupOn: (popupState != "") ? true : false

    // SIGNALS
    //DEPRECATED signal backKey();
    //DEPRECATED signal keyPadBack();

    //DEPRECATED onVisibleChanged: { if(visible) idBtSettingsDeviceNameChangeMain.focus = true; }

    /* 마우스 X좌표를 전달 받아 선택된 문자의 커서 값을 전달
       (단, 커서의 위치는 변경되지 않음) */
    function calculateMarkerPosition(mouseX) {
        var rect = idTextInputDeviceName.positionToRectangle(idTextInputDeviceName.cursorPosition);
        return rect.x;
    }
    /* functions */
    function cursorChanged() {
        // 커서 위치 변경 부분
        hiddenText = idTextInputDeviceName.text
        hiddenCursor = idTextInputDeviceName.cursorPosition

        idTextInputDeviceName.text = "  "

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
    }

    function cursorNormal() {
        // 입력 창 포커스 벗어나는 동작
        idTextInputDeviceName.cursorDelegate = idDelegateCursor
        cursorChanged();
        idTextHiden.hide();
    }

    onPopupOnChanged: {
        if(true == popupOn) {
            idTextHiden.hide();
        } else {
            if(true == idSettingsBtNameChange.visible) {
                idQwertyKeypad.forceActiveFocus();
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

    Component.onCompleted: {
        idQwertyKeypad.forceActiveFocus();
        idTextHiden.text = idTextInputDeviceName.text
        idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition
    }

    onVisibleChanged: {
        if(true == idSettingsBtNameChange.visible) {
            cursorNormal();
            idTextInputDeviceName.text = BtCoreCtrl.m_strBtLocalDeviceName
        }
    }

    MComp.DDSimpleBand {
        id: idDeviceChangeNameBand
        titleText: stringInfo.str_Device_Name_Band

        onBackBtnClicked: {
            //setMainAppScreen("SettingsBtDeviceName", false)
            popScreen(310);
            //settingCurrentIndex = 5;
        }

        //Jog 동작 추가 (커서 Show)
        Keys.onPressed: {
            if(Qt.ShiftModifier == event.modifiers) {
                event.accepted = true;
                return;
            }

            switch(event.key) {
            case Qt.Key_Down: {
                if(0 != idTextInputDeviceName.text.length) {
                    idTextInputDeviceName.forceActiveFocus();
                    idTextHiden.show();
                    idTextInputDeviceName.cursorDelegate = idDelegateFocusCursor
                    idTextInputDeviceName.cursorPosition = 0
                    idTextInputDeviceName.cursorPosition = idTextHiden.cursorPosition
                } else {
                    idQwertyKeypad.forceActiveFocus();
                }

                break;
            }
            }
        }
    }

    Image {
        source: ImagePath.imgFolderPhoto + "bg_edit_new_inputbox.png"
        x: 7
        y: systemInfo.titleAreaHeight + 10
        width: 1268
        height: 150
        
        Text {
            id: idEmptyDeviceName
            text: stringInfo.str_Empty_Device_Name;
            x: 34
            y: 24
            width: 1197
            height: 46
            color: colorInfo.buttonGrey
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignRight
            visible: 0 ==  idTextInputDeviceName.text.length
        }

        TextInput {
            id: idTextInputDeviceName
            text: BtCoreCtrl.m_strBtLocalDeviceName
            x: 34
            anchors.verticalCenter: idEmptyDeviceName.verticalCenter
            width: 1197

            color: colorInfo.buttonGrey
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            maximumLength: (true == idQwertyKeypad.pinyin) ? 32767 : 20
            cursorVisible: true
            cursorPosition: 0
            cursorDelegate: idDelegateCursor
            horizontalAlignment: Text.AlignRight
            visible: idTextInputDeviceName.text.length != 0

            property string keyCompensation: "";
            property bool  upKeyPress: false;

            onTextChanged: {
                if(true == backButtonPressed) {
                    /* Back Key가 눌린경우 1글자가 지워지므로 복원함(복원하지 않을 경우 1글자가 지워지며 Home으로 빠짐)
                     */
                    idTextInputDeviceName.text = idQwertyKeypad.outputText;
                    backButtonPressed = false;
                }
            }

            onCursorPositionChanged: {
                if("LEFT" == keyCompensation) {
                    cursorPosition++;
                    keyCompensation = "";
                } else if("RIGHT" == keyCompensation) {
                    cursorPosition--;
                    keyCompensation = "";
                } else {
                    // do nothing
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    // UPDATE cursor position
                    if(0 != idTextInputDeviceName.text.length) {
                        idTextInputDeviceName.cursorDelegate = idDelegateFocusCursor
                        idTextInputDeviceName.forceActiveFocus();
                        idTextInputDeviceName.cursorPosition = idTextInputDeviceName.positionAt(mouseX, TextInput.CursorOnCharacter);
                        idQwertyKeypad.currentCursor = idTextInputDeviceName.cursorPosition
                        idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition
                        idQwertyKeypad.clearAutomata();
                        idTextHiden.show();
                    } else {

                    }
                }
            }

            Keys.onPressed: {

                // MComponent를 이용하지 않고 직접 키 처리
                if(Qt.ShiftModifier == event.modifiers) {
                    event.accepted = true;
                    return;
                }

                switch(event.key) {
                case Qt.Key_Return:
                case Qt.Key_Enter: {
                    cursorNormal();
                    idQwertyKeypad.forceActiveFocus();
                    idTextHiden.hide();
                    break;
                }
                case Qt.Key_Semicolon: {
                    if(0 < cursorPosition) {
                        cursorPosition--;
                    } else {
                        //cursorPosition = idTextInputDeviceName.text.length;
                    }

                    idQwertyKeypad.currentCursor = idTextInputDeviceName.cursorPosition;
                    idQwertyKeypad.outputCursor = idTextInputDeviceName.cursorPosition
                    idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition
                    idQwertyKeypad.clearAutomata();
                    break;
                }

                case Qt.Key_Apostrophe: {
                    if(idTextInputDeviceName.text.length > cursorPosition) {
                        cursorPosition++;
                    } else {
                        //cursorPosition = 0;
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
                    console.log("## Keys.onPressed(BACK)");
                    /* Back Key가 눌린경우 1글자가 지워지므로 복원함(복원하지 않을 경우 1글자가 지워지며 Home으로 빠짐)
                         */
                    backButtonPressed = true;
                    popScreen(6578);
                    break;
                }

                case Qt.Key_Left: {
                    console.log("##  Keys.onPressed(LEFT)");
                    /* TextInput에서 Left key에 의해 cursor가 좌측으로 이동되므로 강제로 +1 해서 제자리에 위치한것처럼 처리함
                         */
                    console.log("cursorPosition = " + cursorPosition);
                    console.log("idTextInputDeviceName.text.length = " + idTextInputDeviceName.text.length);
                    if(idTextInputDeviceName.text.length > cursorPosition) {
                        cursorPosition++;
                    } else {
                        /* 왼쪽키를 입력했을 때 Keys.onPressed() 후에 TextInput Widget에서 좌측으로 Cursor를 옮기는(position - 1)
                             * 코드가 동작함, 따라서 Cursor가 제일 뒤에 있을때 position + 1이 동작하지 않으므로 TextInput Widget에 의해
                             * 좌측으로 -1 만큼 이동하는 현상이 발생
                             */
                        keyCompensation = "LEFT";
                    }
                    break;
                }

                case Qt.Key_Right: {
                    console.log("##  Keys.onPressed(RIGHT)");
                    /* TextInput에서 Right key에 의해 Cursor가 우측으로 이동되므로 강제로 +1 해서 제자리에 위치한것처럼 처리함
                         */
                    if(1 > cursorPosition) {
                        /* 우측으로 +1 만큼 이동하는 현상이 발생
                             */
                        //cursorPosition = 0;
                        keyCompensation = "RIGHT";
                    } else {
                        cursorPosition--;
                    }
                    break;
                }

                case Qt.Key_Up : {
                    if(upKeyPress == true) {
                        upKeyPress = false
                        idTextHiden.show();
                    } else {
                        //idCursorMarker.hide();
                        cursorNormal();
                        idTextInputDeviceName.cursorPosition = 0
                        idTextInputDeviceName.cursorPosition = idTextHiden.cursorPosition
                        idDeviceChangeNameBand.forceActiveFocus();
                    }
                    break;
                }

                case Qt.Key_Down : {
                    //idCursorMarker.hide();
                    cursorNormal();
                    idTextInputDeviceName.cursorPosition = 0
                    idTextInputDeviceName.cursorPosition = idTextHiden.cursorPosition
                    idQwertyKeypad.forceActiveFocus();
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
            y: 70
            width: 1197
            height: 60

            color: colorInfo.transparent
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            maximumLength: (true == idQwertyKeypad.pinyin) ? 32767 : 20
            cursorVisible: true
            cursorPosition: idTextInputDeviceName.cursorPosition
            cursorDelegate: idMarker
            horizontalAlignment: Text.AlignRight
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

        TextInput {
            id: idHideenTextInput
            text: ""
            x: 34
            y: 24
            width: 1197
            height: 46

            color: colorInfo.buttonGrey
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            cursorVisible: true
            cursorPosition: 0
            cursorDelegate: idDelegateCursor
            horizontalAlignment: Text.AlignRight
            visible: 0 == idTextInputDeviceName.text.length
        }
    }

    Component {
        id: idDelegateCursor

        Item {
            y: 3
            width: 4
            height: 47

            Image {
                id: idDelegateCursorImage
                source: UIListener.m_sImageRoot + "keypad/cursor_n.png";
                visible: true

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

    Component {
        id: idDelegateFocusCursor

        Item {
            y: 3
            width: 4
            height: 47

            Image {
                id: idDelegateFocusCursorImage
                source: UIListener.m_sImageRoot + "keypad/cursor_f.png";
                visible: true

                SequentialAnimation {
                    running: idDelegateFocusCursorImage.visible
                    loops: Animation.Infinite;

                    NumberAnimation { target: idDelegateFocusCursorImage; property: "opacity"; to: 1; duration: 100 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { target: idDelegateFocusCursorImage; property: "opacity"; to: 0; duration: 100 }
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
                anchors.leftMargin: -18
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


        function cutOff(deviceName) {
            return deviceName.substring(0, 20);
        }

        function checkLength(deviceName) {
            return deviceName.length;
        }

        function update(empty) {
            idTextInputDeviceName.cursorDelegate = idDelegateCursor
            if(true == empty) {
                idTextInputDeviceName.color = colorInfo.disableGrey;
                idTextInputDeviceName.cursorVisible = false;
                idTextInputDeviceName.maximumLength = 30;

                // Set default text.
                idTextInputDeviceName.text = ""

                // Set cursor position.
                idTextInputDeviceName.cursorPosition = 0;
            } else {
                idTextInputDeviceName.color = colorInfo.buttonGrey;
                idTextInputDeviceName.cursorVisible = true;
                idTextInputDeviceName.maximumLength = (true == idQwertyKeypad.pinyin) ? 32767 : 20

                // Set input text.
                idTextInputDeviceName.text = idQwertyKeypad.outputText;
                idTextHiden.text = idQwertyKeypad.outputText;

                // Set cursor position.
                if(idQwertyKeypad.currentCursor > idTextInputDeviceName.text.length) {
                    idQwertyKeypad.currentCursor = idTextInputDeviceName.text.length;
                }
                idTextInputDeviceName.cursorPosition = idQwertyKeypad.currentCursor
                idTextHiden.cursorPosition = idQwertyKeypad.currentCursor;
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

        onOutputTextChanged: {
            idTextHiden.hide();
            // 키패드 입력 되는 시점에 키패드로 먼저 포커스 이동 시킴
            idQwertyKeypad.forceActiveFocus();

            if(true == idQwertyKeypad.pinyin && false == idQwertyKeypad.pinyinComplete) {
                if(20 == idTextInputDeviceName.text.length && 1 == idQwertyKeypad.lastPinYinPosition) {
                    // 20글자에서 추가되는 경우 입력 막음
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
                    MOp.showPopup("popup_device_name_limit_length");
                } else {
                    update(false);
                }
            }
        }

        onSigLostFocus: {
            if(0 != idTextInputDeviceName.text.length) {
                idTextInputDeviceName.upKeyPress = true
                idTextHiden.show();
                idTextInputDeviceName.forceActiveFocus();
                idTextInputDeviceName.cursorDelegate = idDelegateFocusCursor
                idTextInputDeviceName.cursorPosition = 0
                idTextInputDeviceName.cursorPosition = idTextHiden.cursorPosition
            } else {
                idDeviceChangeNameBand.forceActiveFocus();
            }
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
}
/* EOF */
