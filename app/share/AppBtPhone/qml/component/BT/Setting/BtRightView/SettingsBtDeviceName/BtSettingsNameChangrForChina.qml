/**
 * BtSettingsNamaChange.qml
 *
 */
import QtQuick 1.1
import "../../../../QML/DH" as MComp
import "../../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
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
    property bool keypadUpPressed: false
    property string hiddenText: ""
    property int hiddenCursor: 0
    property bool popupOn: (popupState != "") ? true : false
    /* 시스템 팝업이 떠있는 경우, 이 전 포커스 위치를 판단하는 변수
     * 0: 대기, 1: 키패드 포커스, 2: 입력창 포커스
     */
    property int focusPoint: 0

    /* INTERNAL functions */
    function cursorChanged() {
        console.log("\n\n[BT][Function] cursorChanged")

        hiddenText = idTextInputDeviceName.text
        hiddenCursor = idTextInputDeviceName.cursorPosition

        idTextInputDeviceName.text = hiddenText + "a"
        idTextHiden.text = hiddenText + "a"

        idTextInputDeviceName.text = hiddenText
        idTextHiden.text = hiddenText

        idTextInputDeviceName.cursorPosition = hiddenCursor
        idTextHiden.cursorPosition = hiddenCursor
    }

    function cursorFocus() {
        idTextInputDeviceName.cursorDelegate = idDelegateFocusCursor
        removeSelect()
        cursorChanged()

        /* 입력 값이 없는 경우 Marker 표시 하지 않도록 수정 */
        if(0 != idTextInputDeviceName.text.length) {
            idTextHiden.show();
        }

        if(false == idTextInputDeviceName.activeFocus) {
            idTextInputDeviceName.forceActiveFocus();
        }
        focusPoint = 2;
    }

    function cursorNormal() {
        if(idTextInputDeviceName.cursorDelegate == idDelegateFocusCursor) {
            idTextInputDeviceName.cursorDelegate = idDelegateCursor
            cursorChanged()
            idTextHiden.hide();
        }
    }

    function removeSelect() {
        var cutText = idQwertyKeypad.outputText
        var haedText = cutText.substring(0,idTextInputDeviceName.selectionStart)
        var badyText = cutText.substring(idTextInputDeviceName.selectionStart, idTextInputDeviceName.selectionStart + idQwertyKeypad.lastPinYinPosition)
        var tailText = cutText.substring(idTextInputDeviceName.selectionStart + idQwertyKeypad.lastPinYinPosition)

        badyText = badyText.replace(/'/gi,"")

        cutText = haedText + badyText + tailText

        if(20 < cutText.length) {
            idQwertyKeypad.clearAutomata();
            idQwertyKeypad.initCommaTimer();
            MOp.showPopup("popup_device_name_limit_length");
        }

        idQwertyKeypad.outputText = cutText.substring(0,20)

        idQwertyKeypad.pinyinComplete = true

        if(20 <  haedText.length + badyText.length) {
            idQwertyKeypad.currentCursor = idQwertyKeypad.outputText.length
        } else {
            idQwertyKeypad.currentCursor = haedText.length + badyText.length
        }
        idTextInputDeviceName.cursorPosition = idQwertyKeypad.currentCursor
        idTextHiden.cursorPosition = idQwertyKeypad.currentCursor

        idQwertyKeypad.lastPinYinPosition = 0
        idQwertyKeypad.clearAutomata()
        MOp.returnFocus();
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
                        idTextHiden.hide();
                    }
                }
            }
        }
    }

    onActiveFocusChanged: {
        if(true == idSettingsBtNameChange.activeFocus) {
            if(false == idQwertyKeypad.focus) {
                cursorFocus();
            }
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        idQwertyKeypad.forceActiveFocus();
        if("NONE" != idQwertyKeypad.pinyin) {
            idQwertyKeypad.disableSpaceButton();
        } else {
            if(0 == idTextInputDeviceName.text.length) {
                idQwertyKeypad.disableSpaceButton();
            } else {
                idQwertyKeypad.enableSpaceButton();
            }
        }
    }

    onVisibleChanged: {
        if(true == idSettingsBtNameChange.visible) {
            if(3 < checkedCallViewStateChange) {
                checkedCallViewStateChange = 0;
                return;
            }
            setKeypad();

            idQwertyKeypad.forceActiveFocus();
            idTextInputDeviceName.select(0, 0);

            idTextInputDeviceName.text = BtCoreCtrl.m_strBtLocalDeviceName
            idQwertyKeypad.outputText = BtCoreCtrl.m_strBtLocalDeviceName

            idTextInputDeviceName.cursorPosition = idTextInputDeviceName.text.length
            idQwertyKeypad.currentCursor = idTextInputDeviceName.text.length

            idQwertyKeypad.clearAutomata();
            cursorNormal()
        }
    }


    /* WIDGETS */
    Image {
        id: bgImgBtSettingsDeviceNameChange
        y: -93
        source: ImagePath.imgFolderGeneral + "bg_main.png"
    }

    Image {
        source: ImagePath.imgFolderGeneral + "bg_title.png"
        x: 0;
        y: 0;
    }

    MouseArea {
        anchors.fill: parent
        beepEnabled: false
        onClicked: {
            // do nothing
        }
    }

    MComp.MButton {
        id: idButtonBack
        x: 1136
        y: 0
        width: 141
        height: 72

        bgImage: ImagePath.imgFolderGeneral + "btn_title_back_n.png"
        bgImagePress: ImagePath.imgFolderGeneral + "btn_title_back_p.png"
        bgImageFocus: ImagePath.imgFolderGeneral + "btn_title_back_f.png"

        /* [주의] Backkey pressed와 Back button pressed를 동시에 처리해야 함
         */
        onClickOrKeySelected: {
            qml_debug("idBackKey Back Press");
            //setMainAppScreen("BtContactMain",false);
            popScreen(204);

            if("FROM_SEARCH" == favoriteAdd) {
                favoriteAdd = "FROM_CONTACT"
            }
        }

        Keys.onReleased: {
            /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
             * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
             */
            if(Qt.Key_Down == event.key) {
                if(Qt.ShiftModifier == event.modifiers) {
                    // Long-pressed
                    idButtonSearch.longPressed = true;
                    event.accepted = true;
                } else {
                    // Short pressed
                    event.accepted = true;
                }
            } else if(Qt.Key_Left == event.key) {
                cursorFocus()

                idTextInputDeviceName.cursorPosition = idQwertyKeypad.currentCursor
                idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition
                event.accepted = true;
            }

            // 키패드 내부 조그 동작 수정 - ISV 조그 동작 동기화 문제점
            if(Qt.Key_Down == event.key) {
                idQwertyKeypad.showQwertyKeypad();
                idQwertyKeypad.forceActiveFocus();
                event.accepted = true;
            }
        }

        onBackKeyPressed: {
            qml_debug("idBackKey Back Press");
            //setMainAppScreen("BtContactMain",false);
            popScreen(204);

            if("FROM_SEARCH" == favoriteAdd) {
                favoriteAdd = "FROM_CONTACT"
            }
        }
    }

    Image {
        id: idImageSearchBar
        source: ImagePath.imgFolderKeypad + "bg_search_l.png"
        x: 7
        y: 0
        z: 100
        width: 1130
        height: 69

        TextInput {
            id: idTextInputDeviceName
            text: contactSearchInput
            x: 34
            y: 10
            width: 950 - idKeypadTypeText.paintedWidth/2 - 10
            color: colorInfo.buttonGrey
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            maximumLength: ("NONE" != idQwertyKeypad.pinyin) ? 20 : 32767
            cursorVisible: true
            cursorPosition: text.length
            cursorDelegate: idDelegateCursor

            property string keyCompensation: "";
            property bool upKeyPress: false

            onTextChanged: {
                if(true == backButtonPressed) {
                    /* Back Key가 눌린경우 1글자가 지워지므로 복원함(복원하지 않을 경우 1글자가 지워지며 Home으로 빠짐)
                     */
                    idTextInputDeviceName.text = idQwertyKeypad.outputText;
                    backButtonPressed = false;
                }

                if(idQwertyKeypad.pinyin != "") {
                    if(20 != gLanguage) {
                        if(0 == idTextInputDeviceName.text.length) {
                            idQwertyKeypad.disableDeleteButton();
                        } else {
                            idQwertyKeypad.enableDeleteButton();
                        }
                    }
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
                    //DEPRECATED idQwertyKeypad.showQwertyKeypad();
                    idQwertyKeypad.initCommaTimer();
                    removeSelect()
                    cursorFocus()

                    idTextInputDeviceName.cursorPosition = idTextInputDeviceName.positionAt(mouseX, TextInput.CursorOnCharacter);
                    idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition
                    idQwertyKeypad.currentCursor = idTextInputDeviceName.cursorPosition

                    // [ITS 232873]
                    if(popupState !=  "") {
                        MOp.returnFocus();
                        cursorNormal();
                        idTextHiden.hide();
                    }
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
//                    backButtonPressed = true;
//                    popScreen(6578);
                    break;
                }

                case Qt.Key_Left: {
                    console.log("##  Keys.onPressed(LEFT)");
                    event.accepted = true;
                    break;
                }

                case Qt.Key_Right: {
                    console.log("##  Keys.onPressed(RIGHT)");
                    cursorNormal()
                    idButtonBack.forceActiveFocus()
                    event.accepted = true
                    break;
                }

                //Jog 동작 추가 (커서 Show)
                case Qt.Key_Up : {
                    if(upKeyPress == true) {
                        upKeyPress = false

                        if(idTextInputDeviceName.text.length != 0) {
                            idTextHiden.show();
                        }
                    }
                    break;
                }

                case Qt.Key_Down : {
                    cursorNormal()
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
            text: idTextInputDeviceName.text

            x: 34
            y: 74
            z: 100

            width: 950 - idKeypadTypeText.paintedWidth / 2 - 10
            height: 60

            color: colorInfo.transparent
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            cursorVisible: true
            cursorPosition: idTextInputDeviceName.cursorPosition
            cursorDelegate: idMarker

            visible: true

            state: "HIDE"

            MouseArea {
                anchors.fill: parent

                onPositionChanged: {
                    // UPDATE cursor position
                    idTextInputDeviceName.forceActiveFocus();
                    idTextHiden.cursorPosition = idTextHiden.positionAt(mouseX, TextInput.CursorOnCharacter);
                    idTextInputDeviceName.cursorPosition = idTextHiden.cursorPosition
                    idQwertyKeypad.currentCursor = idTextHiden.cursorPosition
                    idQwertyKeypad.clearAutomata();
                    idMarkerTimer.restart();
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

        // Cursor delegate
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

        Text {
            id: idSearchText
            x: 34
            y: 13
            text: stringInfo.str_Empty_Device_Name
            color: colorInfo.dimmedGrey
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: idTextInputDeviceName.verticalCenter
            visible: idTextInputDeviceName.text.length == 0
        }

        Text {
            id: idKeypadTypeText
            text: idQwertyKeypad.pinyin == "SOUND" ? " [" + stringInfo.str_Keypad_Sound + "]" : idQwertyKeypad.pinyin == "PINYIN" ? " [" + stringInfo.str_Keypad_Pinyin + "]" : ""
            color: colorInfo.dimmedGrey
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDR"
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: idImageSearchBar.right
            anchors.rightMargin: 30
            visible: "NONE" != idQwertyKeypad.pinyin//idTextInputDeviceName.text.length == 0 && (3 == gLanguage || 4 == gLanguage)
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
                idTextHiden.text = idTextInputDeviceName.text

                // Set cursor position.
                idTextInputDeviceName.cursorPosition = 0;
            } else {
                idTextInputDeviceName.color = colorInfo.buttonGrey;
                //idTextInputDeviceName.maximumLength = 160
                idTextInputDeviceName.maximumLength = ("NONE" == idQwertyKeypad.pinyin) ? 20 : 32767

                // Set input text.
                console.log("idQwertyKeypad.outputText > " + idQwertyKeypad.outputText)
                idTextInputDeviceName.text = idQwertyKeypad.outputText;
                idTextHiden.text = idTextInputDeviceName.text

                // Set cursor position.
                if(idQwertyKeypad.currentCursor > idTextInputDeviceName.text.length) {
                    idQwertyKeypad.currentCursor = idTextInputDeviceName.text.length;
                }

                idTextInputDeviceName.cursorPosition = idQwertyKeypad.currentCursor;
                idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition
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

            idQwertyKeypad.showQwertyKeypad();
        }

        Component.onCompleted: {
            idTextInputDeviceName.cursorPosition = idQwertyKeypad.outputText.length;
        }

        Connections {
            target: idAppMain
            onTextChange: {
                idTextInputDeviceName.select(idTextInputDeviceName.cursorPosition - idQwertyKeypad.lastPinYinPosition , idTextInputDeviceName.cursorPosition);
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
                            console.log("\n\n onSigPopupStateChanged systemPopupOn \n\n")
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
                                console.log("\n\n onSigPopupStateChanged systemPopupOff \n\n")
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

        onChangePINYIN: {
            idSettingsBtNameChange.removeSelect();
            idTextInputDeviceName.select(idTextInputDeviceName.cursorPosition - idQwertyKeypad.lastPinYinPosition , idTextInputDeviceName.cursorPosition);
        }

        onActiveFocusChanged: {
            if(true == idQwertyKeypad.activeFocus){
                focusPoint = 1;
            }
        }

        onOutputTextChanged: {
            idTextHiden.hide();
            idTextInputDeviceName.cursorDelegate = idDelegateCursor

            idQwertyKeypad.forceActiveFocus();
            if("PINYIN" == idQwertyKeypad.pinyin && false == idQwertyKeypad.pinyinComplete) {
                if(1 > idQwertyKeypad.outputText.length) {
                    update(true);
                } else {
                    update(false);

                    // PinYin 입력 중 미완성 글자에 대한 반전효과
                    idTextInputDeviceName.select(idTextInputDeviceName.cursorPosition - lastPinYinPosition , idTextInputDeviceName.cursorPosition);
                }
            } else if("PINYIN" == idQwertyKeypad.pinyin && true == idQwertyKeypad.pinyinComplete) {
                if(20 == idTextInputDeviceName.text.length && 1 == idQwertyKeypad.lastPinYinPosition) {
                    // 20글자에서 추가되는 경우 입력 막음
                    idQwertyKeypad.clearAutomata();
                    idQwertyKeypad.initCommaTimer();
                    MOp.showPopup("popup_device_name_limit_length");
                    MOp.returnFocus()
                } else {
                    console.log("idQwertyKeypad.lastPinYinPosition > " + idQwertyKeypad.lastPinYinPosition)
                    console.log("idQwertyKeypad.currentCursor > " + idQwertyKeypad.currentCursor)
                    if(1 > idQwertyKeypad.outputText.length) {
                        update(true);
                    } else {
                        update(false);

                        // PinYin 입력 중 미완성 글자에 대한 반전효과
                        idTextInputDeviceName.select(idTextInputDeviceName.cursorPosition - lastPinYinPosition , idTextInputDeviceName.cursorPosition);
                    }
                }
            } else {
                if(1 > idQwertyKeypad.outputText.length) {
                    update(true);
                } else if(20 < idQwertyKeypad.outputText.length) {
                    /* Limited characters */
                    //update(false);
                    truncate();
                    idQwertyKeypad.clearAutomata();
                    idQwertyKeypad.initCommaTimer();
                    MOp.showPopup("popup_device_name_limit_length");
                    MOp.returnFocus()
                } else {
                    // VALID device name
                    update(false);
                }
            }

            if("NONE" != idQwertyKeypad.pinyin) {
                // PinYin 입력 중 미완성 글자에 대한 반전효과
                idTextInputDeviceName.select(idTextInputDeviceName.cursorPosition - lastPinYinPosition , idTextInputDeviceName.cursorPosition);
            }

            if("PINYIN" == idQwertyKeypad.pinyin && false == idQwertyKeypad.pinyinComplete) {
                /* 중국어 입력모드일때 중국어 입력이 완성된 시점에 검색함
                 * 영어입력상태(검색X) --> 한자로 변환(검색O)
                 */

            } else if("PINYIN" == idQwertyKeypad.pinyin && true == idQwertyKeypad.pinyinComplete) {
                idTextInputDeviceName.cursorPosition = 0
                idTextInputDeviceName.cursorPosition = idQwertyKeypad.currentCursor
            }

            if("NONE" != idQwertyKeypad.pinyin ) {
                idQwertyKeypad.disableSpaceButton();
            } else {
                if(0 == idTextInputDeviceName.text.length) {
                    idQwertyKeypad.disableSpaceButton();
                } else {
                    idQwertyKeypad.enableSpaceButton();
                }
            }

            if("HANDWRITING" == idQwertyKeypad.pinyin) {
                cursorChanged();
            }
        }

        onSigKeypadChanged: {
            if("NONE" != idQwertyKeypad.pinyin ) {
                idQwertyKeypad.disableSpaceButton();
            } else {
                if(0 == idTextInputDeviceName.text.length) {
                    idQwertyKeypad.disableSpaceButton();
                } else {
                    idQwertyKeypad.enableSpaceButton();
                }
            }
        }

        onSigLostFocus: {
            idTextInputDeviceName.upKeyPress = true

            removeSelect()
            cursorFocus()

            idTextInputDeviceName.cursorPosition = idQwertyKeypad.currentCursor
            idTextHiden.cursorPosition = idTextInputDeviceName.cursorPosition

            if(popupState !=  "") {
                MOp.returnFocus()
                idTextHiden.hide();
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
}/* EOF */

