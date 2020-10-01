/**
 * /QML/DH/QwertyKeypad.qml
 *
 */
import QtQuick 1.1

import QmlQwertyKeypadWidget 1.0
import AppEngineQMLConstants 1.0
import "../../BT/Common/Javascript/operation.js" as MOp

MComponent
{
    id: idContainer

    // PROPERTIES
    property alias qY: idQmlQwertyKeypadWidget.y
    property alias qX: idQmlQwertyKeypadWidget.x
    property string outputText: ""
    property int outputCursor: 0
    property int currentCursor: 0
/////PINYIN
    property string pinyin: "NONE"              // "NONE", "PINYIN", "SOUND", "HANDWRITING"
    property bool pinyinComplete: true
    property int lastPinYinPosition: 0
/////PINYIN
    property string doneType: "Done"
    property bool useVocalSound: false
    property string keypadInput: ""
    property bool qwertyKeypadPress: false

    //삭제 버튼 LongPress 시, 모션 변경으로 인해 변수 추가
    property bool isPressAndHold: false
    property bool isPinYinPressAndHold: false
    //Timer가 돌고 있는지 확인하는 변수
    property bool timerActive: false

    // SIGNALS
    signal sigLostFocus();
    signal keyOKClicked();
    signal sigKeypadHide();
    signal sigKeypadShow();
    signal sigKeypadChanged();
    signal changePINYIN();
    signal keypadWidghtHide();

    /* INTERNAL functions */

    /* 키패드 Search 버튼 비활성화 */
    function disableSearchButton(){
        idQmlQwertyKeypadWidget.setDisableButton("done")
    }

    /* 키패드 Search 버튼 활성화 */
    function enableSearchButton(){
        idQmlQwertyKeypadWidget.setEnableButton("done")
    }

    /* 키패드 Delete 버튼 비활성화 */
    function disableDeleteButton(){
        idQmlQwertyKeypadWidget.setDisableButton("delete")
    }

    /* 키패드 Delete 버튼 활성화 */
    function enableDeleteButton(){
        idQmlQwertyKeypadWidget.setEnableButton("delete")
    }

    /* 키패드 Speace 버튼 비활성화 */
    function disableSpaceButton(){
        //idQmlQwertyKeypadWidget.setDisableButton("space")
    }

    /* 키패드 Speace 버튼 활성화 */
    function enableSpaceButton(){
        idQmlQwertyKeypadWidget.setEnableButton("space")
    }

    /* 키패드 보임 */
    function showQwertyKeypad() {
        idQmlQwertyKeypadWidget.showQwertyKeypad();
    }

    /* 키패드 숨김 */
    function hideQwertyKeypad() {
        idQmlQwertyKeypadWidget.hideQwertyKeypad();
    }

    /* 키패드 숨김 상태 확인 */
    function isHide() {
        return idQmlQwertyKeypadWidget.isHide;
    }

    /* 키패드 내부 입력된 값 초기화 */
    function clearAutomata() {
        idQmlQwertyKeypadWidget.clearBuffer();

        if("PINYIN" == pinyin) {
            idQwertyKeypad.lastPinYinPosition = 0;
        } else if("SOUND" == pinyin) {
            idQmlQwertyKeypadWidget.clearState();
            idQwertyKeypad.lastPinYinPosition = 0;
        }
    }

    function initHWRKeypad() {
        console.log("\n\n [Qml][Keypad] initHWRKeypad\n\n")
        idQmlQwertyKeypadWidget.initBTHWREngine()
    }

    /* 키패드 변경 함수 (중국어 키패드만)
     * 기기명 변경에서는 성음이 없어서 하기와 같이 따로 분리하여 관리
     * chineseKeypadTypeDeviceName (기기명 변경에서의 키패드 상태)
     * chineseKeypadType (전화번호부 검색에서의 키패드 상태)
     * 사양 변경으로 Keypad Last Mode 각각 유지 (병음/성음/필기인식)
     */
    function keypadChanged() {
        if("SettingsBtNameChange" == idAppMain.state) {
            idQmlQwertyKeypadWidget.setChineseKeypadType = chineseKeypadTypeDeviceName
        } else {
            idQmlQwertyKeypadWidget.setChineseKeypadType = chineseKeypadType
        }
    }

    /* 현재 입력 전 문자(파란색으로 변경되는 부분)의 갯수 확인 */
    function lastPinYinCheck(text) {
        var inputText = text
        var pinyinLength
        var selectEnd
        var selectStart

        if("SettingsBtNameChange" == idAppMain.state) {
            selectEnd = keypadInput.selectionEnd
            selectStart = idTextInputDeviceName.selectionStart
        } else if("BtContactSearchMain" == idAppMain.state) {
            selectEnd = idTextInputSearch.selectionEnd
            selectStart = idTextInputSearch.selectionStart
        }
        inputText = inputText.substring(selectStart, selectEnd)
        inputText = inputText.replace(/'/gi,"")

        pinyinLength = inputText.length

        return pinyinLength;
    }

    function showKeypadFocus() {
        idQmlQwertyKeypadWidget.showFocusOnlyBT();
    }

    function hideKeypadFocus() {
        idQmlQwertyKeypadWidget.hideFocusOnlyBT();
    }
    
    function sigSendJogCanceled(){
        idQmlQwertyKeypadWidget.sendJogCanceled();
    }

    function deleteLongPressInPinYin(){
        idQmlQwertyKeypadWidget.deleteLongPressInPinYin();
    }

    function initCommaTimer() {
        idQmlQwertyKeypadWidget.initCommaTimer();
    }

    Component.onCompleted: {
        console.log("\n\n\n\n\n\n\n\n[BT][Keypad] onCompleted > " + idContainer.visible )
        /* 초기 화면 진입 시 키패드 초기화 */
        idQmlQwertyKeypadWidget.initKeypad();
    }

    Connections {
        target: UIListener

        /* 키패드 상태 Update */
        onUpdateKeypad: {
            idQmlQwertyKeypadWidget.update();
        }
    }

    Connections {
        target: idAppMain

        onSetKeypad: {
            idContainer.keypadChanged();
            if(pinyin == "HANDWRITING") {
                initHWRKeypad();
            }
        }

        onSigPopupStateChanged: {
            /* 필기 인식 중 일때 팝업이 표시되면서 필기 좌표가 (0.0)으로 이동되는 문제 수정
             */
            if(0 < callType){
                if("FOREGROUND" == callViewState){
                    //do nothing
                }
            } else {
                if(("BtContactSearchMain" == idAppMain.state || "SettingsBtNameChange" == idAppMain.state) && "HANDWRITING" == idContainer.pinyin) {
                    if("" != popupState) {
                        idQmlQwertyKeypadWidget.enableChineseHWRInput = false
                        UIListener.invokeSendTouchCleanUpForApps();
                    } else {
                        idQmlQwertyKeypadWidget.enableChineseHWRInput = true
                    }
                }
            }
        }
    }

    onVisibleChanged: {
        console.log("\n\n[BT][Keypad] visible Changed > " + idContainer.visible )
        /* 초기 화면 진입 시 키패드 초기화 */
        idQmlQwertyKeypadWidget.initKeypad();

        if(true == idContainer.visible) {
            if(pinyin == "HANDWRITING") {
                initHWRKeypad();
            }
        }

        if(0 == outputText.length) {
            idQwertyKeypad.disableDeleteButton();
        } else {
            idQwertyKeypad.enableDeleteButton();
        }
    }

    onActiveFocusChanged: {
        if(true == idContainer.activeFocus) {
            idContainer.showKeypadFocus();
        } else {
            idContainer.hideKeypadFocus();
        }
    }

    /* WIDGETS */
    QmlQwertyKeypadWidget {
        id: idQmlQwertyKeypadWidget
        x: qX
        y: qY
        focus: popupState == "" ? true : false
        focus_visible: systemPopupOn == false && idContainer.activeFocus

        // 완료 버튼 (엔터로 할 것인지 돋보기로 할것인지)
        doneButtonType: idContainer.doneType

        // 향지 정보
        countryVariant: UIListener.GetCountryVariantFromQML()

        // 중국어 키패드 상태 (병음/성음/필기인식)
        setChineseKeypadType: "SettingsBtNameChange" == idAppMain.state ? chineseKeypadTypeDeviceName : chineseKeypadType

        property bool jogMode: false // 키패드에서 사용자의 동작을 확인하는 변수 (Touch / Jog)

        /* functions */
        /* 키패드 입력 부분 */
        function input(key, label, state) {
            console.log("\n\n [BT][KEYPAD] function input \n key > " + key + "\n label > " + label + "\n state > " + state + "\n lastPinYinPosition > " + lastPinYinPosition + "\n pinyinComplete > " + pinyinComplete)

            if(1 == gIgnoreReleased) {
                gIgnoreReleased = 2;
            }

            if( Qt.Key_Launch4 == key && label == "")
            {
                /* 키패드 하단 스페이스바 옆에 있는 단축 버튼 동작 시 발생되는 동작 */
                var position = currentCursor - 1;
                currentCursor--;
                outputText = outputText.substring(0, position) +  outputText.substring(position + 1);
            } else {
                /* 제일 앞인 경우 삭제하지 않음 */
            }

            if(0xFF/* SEARCH_BOX_MAX_KEY_CODE */ > key) {
                /* 일반 키패드 입력 글자 */
                var position = currentCursor;
                if("BtContactSearchMain" == idAppMain.state && outputText.length >= 160) {
                    idQwertyKeypad.initCommaTimer();
                    return;
                }
                /* 커서가 문장 중간에 위치할 수 있으므로 커서 앞/뒤 문자열 사이에 문자를 잘라내 새로운 문자열을 만들어냄
                 * Automata에 의해 1개 입력에 대해 최대 2개 문자가 입력될 수 있으며
                 * state에 따라 true일 경우 1개 문자를 지우고 2개 문자를 삽입해야 함
                 * e.g. ㅎㅎ --> 두번째 ㅎ 에서 "ㅎㅎ"가 label로 전달, stateu = true
                 *      ㅎㅗ --> 두번째 ㅗ 에서 "호" 가 label로 전달, state = true
                 */
                var offset = 0;
                if(true == state) {
                    offset = 1;
                }

                console.log("## currentCursor = " + currentCursor);
                console.log("## label = " + label);
                console.log("## length = " + label.length);
                console.log("## offset = " + offset);
                console.log("## outputText = " + outputText);
                console.log("## outputText.substring(0, length - currentCursor) = " + outputText.substring(0, position - offset));
                console.log("## outputText.substring(currentCursor) = " + outputText.substring(position));

                /* [주의] currentCursor 위치를 먼저 바꾸고 outputText를 바꿔야 Keypad를 사용하는 곳에서 onOutputTextChanged에서 처리가 가능해짐
                 */
                currentCursor = position + label.length - offset;
                // 커서가 문장 중간에 위치할 수 있으므로 커서 앞/뒤 문자열 사이에 끼워넣어  새로운 문자열을 만들어냄
                outputText = outputText.substring(0, position - offset) + label + outputText.substring(position);
                console.log("## outputText(result) = " + outputText);
            } else if(Qt.Key_Back == key) {
                /* 삭제 동작 커서가 문장 중간에 위치할 수 있으므로 커서 앞/뒤 문자열 사이에 문자를 잘라내 새로운 문자열을 만들어냄 */
                if(0 < currentCursor) {
                    var position = currentCursor - 1;

                    if(0 == position) {
                        if(false == jogMode) {
                            UIListener.ManualBeep();
                        }
                    }

                    if("" != label) {
                        outputText = outputText.substring(0, position) +  label + outputText.substring(position + 1);
                    } else {
                        currentCursor--;
                        outputText = outputText.substring(0, position) +  outputText.substring(position + 1);
                    }
                } else {
                    // 제일 앞인 경우 삭제하지 않음
                }
            } else if(Qt.Key_Home == key) {
                /* UISH 또는 KeypadWidget 버그로 판단되며, 임시 방어코드 추가함
                 *
                 * KeypadWidget에서 CCP OK를 누른경우(Done), 아래의 순서로 이벤트가 전달되어
                 * Release Event를 무시해야 하는 케이스가 발생함
                 * 1) Pressed
                 * 2) KeypadWidget의 Released
                 * 3) Released(Keypad가 사라지고 난 이전 화면으로 전달)
                 *
                 * 1이면 Pressed가 된 상태로, Pressed 된 상태에서 OK가 되면 다음번 Release를 무시함
                 */
                keyOKClicked();
                if(pinyin != "SOUND") {
                    clearAutomata();
                }
            } else if(Qt.Key_Shift == key || Qt.Key_Launch7 == key) {
                idContainer.forceActiveFocus();
                cursorNormal();
            }
        }

        function fixedFromCharCode(codePt) {
            var test = 0xFFFF;
            if(codePt > 0xFFFF/* SEARCH_BOX_MAX_SYMBOL_CODE */ ) {
                codePt -= 0x10000/* SEARCH_BOX_SUB_VAL */;
                return String.fromCharCode(0xD800/* SEARCH_BOX_MASK_1 */ + (codePt >> 10), 0xDC00/* SEARCH_BOX_MASK_2 */ + (codePt & 0x3FF /* SEARCH_BOX_MASK_3 */));
            } else {
                return String.fromCharCode(codePt);
            }
        }

        /* 중국어 병음 입력 부분 */
        function pinyinInput(key, label, state) {
            console.log("\n\n [BT][KEYPAD] function pinyinInput \n key > " + key + "\n label > " + label + "\n state > " + state + "\n lastPinYinPosition > " + lastPinYinPosition + "\n pinyinComplete > " + pinyinComplete)
            if(Qt.Key_Back == key) {
                if(0 < lastPinYinPosition) {
                    lastPinYinPosition--;
                }

                input(key, label, state);

                if(lastPinYinPosition == 0) {
                    idQmlQwertyKeypadWidget.searchChinesePrediction(keypadInput)
                }
            } else if(Qt.Key_Home == key) {
                if("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) {
                    // 완료를 눌렀을때 병음입력 중이었다면 삭제함
                    if(0 < lastPinYinPosition) {
                        var position =  lastPinYinPosition;
                        var tempCurrentCursor = currentCursor

                        currentCursor = outputText.length - lastPinYinPosition
                        lastPinYinPosition = 0;
                        pinyinComplete = true;

                        outputText = outputText.substring(0, tempCurrentCursor - position)
                                     + outputText.substring(tempCurrentCursor)
                    }
                }

                input(key, label, state);
            } else {
                if(lastPinYinCheck(outputText) > 41 && pinyinComplete == false) {
                    return;
                }

                var regexLetter = /[a-zA-Zʼ]/;

                /* 입력 값 확인 부분 regexLetter.test(label) */
                if(true == regexLetter.test(label) || label == "'") {
                    pinyinComplete = false;
                    lastPinYinPosition++;

                    input(key, label, state);
                } else {
                    if(1 == gIgnoreReleased) {
                        gIgnoreReleased = 2;
                    }

                    var selectEnd = [""]
                    var selectStart = [""]
                    var splitArray = [""]

                    /* 병음에서 후보군이 없는 알파벳 + "'" + space 입력 시, 알파벳만 남게 하기 위한 변수 */
                    var selectReplace;

                    if("SettingsBtNameChange" == idAppMain.state) {
                        selectEnd = idTextInputDeviceName.selectionEnd
                        selectStart = idTextInputDeviceName.selectionStart
                        splitArray = idTextInputDeviceName.selectedText.split("'")
                        /* "'"을  ""로 변환 */
                        selectReplace = idTextInputDeviceName.selectedText.replace(/'/g, "");

                    } else if("BtContactSearchMain" == idAppMain.state) {
                        selectEnd = idTextInputSearch.selectionEnd
                        selectStart = idTextInputSearch.selectionStart
                        splitArray = idTextInputSearch.selectedText.split("'")
                        /* "'"을  ""로 변환 */
                        selectReplace = idTextInputSearch.selectedText.replace(/'/g, "");
                    }
                    
                    if ( label.length < splitArray.length ) {  // 선택된 병음이 입력한 병음 구분자 수보다 작을 경우

                        /* 병음에서 후보군이 없는 알파벳 + "'" + space 입력 시 */
                        if(0 < splitArray.length && label == " ") {

                            lastPinYinPosition = 0; //select 초기화
                            currentCursor = selectStart + selectReplace.length;
                            outputText = outputText.substring(0, selectStart) + selectReplace + outputText.substring(selectEnd)

                            pinyinComplete = true;
                        } else {
                            var selectedStr = ""
                            var notSelectedStr = ""
                            var tempCurrentCursor = [""]
                            var saveText = ""
                            var saveOverText = ""

                            for(var i = 0; i < splitArray.length; i++) {
                                if(i < label.length) {
                                    selectedStr += splitArray[i]         // 치환된 병음 별도 저장
                                } else {
                                    notSelectedStr += splitArray[i]         // 남아있는 입력 병음 별도 저장
                                    if(i != splitArray.length - 1) {
                                        notSelectedStr += "'"
                                    }
                                }
                            }

                            pinyinComplete = false;

                            lastPinYinPosition = notSelectedStr.length
                            currentCursor = selectStart + label.length + notSelectedStr.length;
                            tempCurrentCursor = currentCursor

                            saveText = outputText.substring( 0, selectStart ) + label + outputText.substring(selectEnd)

                            saveOverText = outputText.substring( 0, selectStart )      // selectedText 이전 string
                                    + label                                                    // 치환된 병음 한자
                                    + outputText.substring( selectStart + selectedStr.length + label.length )      // selectedText 시작 위치 + 치환된 selectedText length + 구분자 수

                            if(20 < saveText.length) {
                                // 20자 이상 입력 시 후보군 표시 하지 않도록 수정
                                outputText = saveText
                                lastPinYinPosition = 0
                                currentCursor = selectStart + label.length
                            } else {
                                outputText = saveOverText
                            }
                        }

                        if("SettingsBtNameChange" == idAppMain.state) {
                            // 20자 이상입력 불가
                            if(true == pinyinComplete) {
                                if(20 < outputText.length) {
                                    MOp.showPopup("popup_device_name_limit_length");
                                }

                                outputText = outputText.substring(0,20)
                            } else if(outputText.length - lastPinYinPosition >= 20) {
                                if(20 <= tempCurrentCursor) {
                                    if(20 > tempCurrentCursor - lastPinYinPosition) {
                                        outputText = outputText.substring(0,20 + lastPinYinPosition)
                                        pinyinComplete = true
                                        lastPinYinPosition = 0
                                        MOp.showPopup("popup_device_name_limit_length");
                                    } else if(20 == tempCurrentCursor - lastPinYinPosition) {
                                        pinyinComplete = true
                                        lastPinYinPosition = 0
                                        outputText = outputText.substring(0,20)
                                    } else {
                                        pinyinComplete = true
                                        lastPinYinPosition = 0
                                        outputText = outputText.substring(0,20)
                                        MOp.showPopup("popup_device_name_limit_length");
                                    }
                                } else {
                                    if(20 == tempCurrentCursor - lastPinYinPosition) {
                                        outputText = outputText.substring(0,20 + lastPinYinPosition)
                                    } else {
                                        outputText = outputText.substring(0,20 + lastPinYinPosition)
                                        MOp.showPopup("popup_device_name_limit_length");
                                    }
                                }
                            }

                            MOp.returnFocus();
                        } else if("BtContactSearchMain" == idAppMain.state) {
                            // 160자 이상 입력 불가
                            if(true == pinyinComplete) {
                                outputText = outputText.substring(0,160)
                            } else if(outputText.length - lastPinYinPosition >= 160) {
                                if(160 <= tempCurrentCursor) {
                                    if(160 > tempCurrentCursor - lastPinYinPosition) {
                                        outputText = outputText.substring(0,160 + lastPinYinPosition)
                                    } else {
                                        pinyinComplete = true
                                        lastPinYinPosition = 0
                                        outputText = outputText.substring(0,160)
                                    }
                                } else {
                                    outputText = outputText.substring(0,160 + lastPinYinPosition)
                                }
                            }
                            MOp.returnFocus();
                        }

                        if(false == pinyinComplete) {
                            idQmlQwertyKeypadWidget.searchChinesePinyin(notSelectedStr)
                        }
                    } else {
                        if(label == " " && lastPinYinPosition != 0) {
                            changePINYIN();

                            /* 키패드 내부 포커스를 강제로 보이지 않도록 하는 부분*/
                            if(popupState == "") {
                                idContainer.showKeypadFocus();
                            } else {
                                idContainer.hideKeypadFocus();
                            }
                            MOp.returnFocus();

                            return;
                        }

                        var position =  currentCursor;
                        var lastPiyin = lastPinYinPosition

                        currentCursor = position - lastPiyin + label.length;
                        lastPinYinPosition = 0;
                        pinyinComplete = true;

                        // 영어로 입력된 글자를 삭제(lastPinyinPosition까지)하고 한자로 대체함
                        outputText = outputText.substring(0, position - lastPiyin) + label + outputText.substring(position);

                        clearAutomata()

                        if(outputText.length < 21) {

                        } else {
                            if("SettingsBtNameChange" == idAppMain.state) {
                                // 20자 이상입력 불가
                                outputText = outputText.substring(0,20)
                                MOp.showPopup("popup_device_name_limit_length");
                            } else if("BtContactSearchMain" == idAppMain.state) {
                                outputText = outputText.substring(0,160)
                                MOp.returnFocus();
                            }
                        }
    
                        if("SOUND" == pinyin) {
                            idQmlQwertyKeypadWidget.clearState();
                        }

                        idQmlQwertyKeypadWidget.searchChinesePrediction(keypadInput)
                    }
                }
            }
        }

        /* 필기 인식 키패드에서 사용자의 동작으로 그려질때 불려지는 함수 */
        function previewHWRCandidate(key, label, state) {
            console.log("\n\n [BT][KEYPAD] function previewHWRCandidate \n key > " + key + "\n label > " + label + "\n state > " + state + "\n lastPinYinPosition > " + lastPinYinPosition + "\n pinyinComplete > " + pinyinComplete)
            if(label == "" && lastPinYinPosition == 0) {
                return;
            }

            console.log("outputText.length > " + outputText.length)

            if("SettingsBtNameChange" == idAppMain.state && "HANDWRITING" == pinyin && 19 < outputText.length && pinyinComplete == true) {
                /* 필기 인식 일 때, 20자이상 입력 되지 않도록 수정*/
                lastPinYinPosition = 0
                return;
            }

            if( lastPinYinPosition == 0) {
                pinyinComplete = false;
                lastPinYinPosition++;
                input(key, label, state);
                textChange();
            } else {
                if(lastPinYinPosition == 1)
                /* 후보군이 1글자 입력 되어 있을 때 */
                {
                    input(Qt.Key_Back, 0, 0)
                    lastPinYinPosition = 0
                    textChange();
                    pinyinComplete = false;
                }

                if(label == "") {
                /* 입력 값이 없을 때 */
                    pinyinComplete = true;

                    //현재 입력되어 있는 글자 다음에 올수 있는 후보군 표시한다.
                    idQmlQwertyKeypadWidget.searchChinesePrediction(keypadInput)
                } else {
                /* 입력 값이 있을 때 */
                    lastPinYinPosition++;
                    input( key, label, state)

                    if("HANDWRITING" == pinyin) {
                        textChange();
                    }
                }
            }

            /* 입력된 값을 확인 하고 Delete 버튼 활성화 동작 추가*/
            if(0 == outputText.length) {
                idQwertyKeypad.disableDeleteButton();
            } else {
                idQwertyKeypad.enableDeleteButton();
            }
        }

        /* */
        function hwrInput(key, label, state) {
            console.log("\n\n [BT][KEYPAD] function hwrInput \n key > " + key + "\n label > " + label + "\n state > " + state + "\n lastPinYinPosition > " + lastPinYinPosition + "\n pinyinComplete > " + pinyinComplete)
            if(Qt.Key_Back == key) {
                if(0 < lastPinYinPosition) {
                    lastPinYinPosition--;
                }
                input(Qt.Key_Back, label, state);

                // Delete in Keypad
                idQmlQwertyKeypadWidget.clearState();

                //삭제 버튼을 눌렀을 때, lastPinyinPosition이 없으면 글자 다음에 올수 있는 후보군 검색
                if(lastPinYinPosition == 0) {
                    idQmlQwertyKeypadWidget.searchChinesePrediction(keypadInput)
                }

                if(0 == outputText.length) {
                    if(false == jogMode) {
                        UIListener.ManualBeep();
                    }
                    idQwertyKeypad.disableDeleteButton();
                } else {
                    idQwertyKeypad.enableDeleteButton();
                }
            } else if(Qt.Key_Home == key) {
                if( 20 < outputText.length) {
                    return
                }

                if(0 < lastPinYinPosition) {
                    var position =  lastPinYinPosition;

                    currentCursor = outputText.length - lastPinYinPosition
                    lastPinYinPosition = 0;
                    pinyinComplete = true;

                    outputText = outputText.substring(0, outputText.length - position)
                }

                input(key, label, state);
            } else {
                if(key == Qt.Key_A && label != "")
                {
                    // 영어로 입력된 글자를 삭제(lastPinyinPosition까지)하고 한자로 대체함
                    if ( lastPinYinPosition == 1 ) {            // 알파벳 한 글자 -> 한자 변환 시 커서 위치 조절
                        //appUserManualSearchBar.displayText( Qt.Key_Back, 0,0 )

                        outputText = outputText.substring( 0, currentCursor - lastPinYinPosition)
                                                                    + label
                                                                    + outputText.substring( currentCursor + lastPinYinPosition - 1)

                        lastPinYinPosition = 0;
                        textChange();

                        //input( key, label, state)
                    }
                    else {
                        console.log("hwrInput(): lastPinYinPosition:"+lastPinYinPosition)
                        input( key, label, state)
                    }

                    lastPinYinPosition = 0;
                    pinyinComplete = true;
                    //appUserManualSearchBar.setSearchIcon(true)
                    idQmlQwertyKeypadWidget.setEnableButton("done")
                    idQmlQwertyKeypadWidget.clearState();

                    //글자 다음에 올수 있는 후보군 검색
                    if(lastPinYinPosition == 0)
                        idQmlQwertyKeypadWidget.searchChinesePrediction(keypadInput)
                } else {
                    if(lastPinYinPosition == 0) {
                        input( key, label, state)
                    }
                }

                if(0 == outputText.length) {
                    idQwertyKeypad.disableDeleteButton();
                } else {
                    idQwertyKeypad.enableDeleteButton();
                }
            }
        }

        /* EVENT handlers */
        onKeyReleased: {
            if(true == popupOn) {
                isPressAndHold = false
                timerActive = false
            } else {
                if (isPressAndHold){
                    if(isPinYinPressAndHold){
                        console.log("# [QwertyKeypad] isPinYinPressAndHold: true ")
                    }
                    else{
                        isPressAndHold = false
                        timerActive = false
                        idDeleteLongPressTimer.stop();
                    }
                }

                if("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) {
                    pinyinInput(key, label, state);
                } else if("HANDWRITING" == pinyin) {
                    hwrInput(key, label, state);
                } else {
                    input(key, label, state);
                }
            }
        }

        function pressAndHoldTrigger(){
            if ( !isPressAndHold ) {return}
            if("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) {
                deleteLongPressInPinYin();
            } else if("HANDWRITING" == pinyin) {
                hwrInput(Qt.Key_Back, 0, false);
            } else {
                input(Qt.Key_Back, 0, false);
            }

            if(0 == currentCursor) {
                isPressAndHold = false
                timerActive = false
                idDeleteLongPressTimer.stop();
            }
        }

        Keys.onPressed: {
            jogMode = true
        }

        Keys.onReleased: {
            jogMode = false
        }

        onHideKeypadWidget: {
            keypadWidghtHide();
        }

        /* 필기 인식 화면에서 그림을 그릴 때 발생되는 부분*/
        onPreviewCandidate:
        {
            console.log("\n\n [BT][KEYPAD] function onPreviewCandidate \n key > " + key + "\n label > " + label + "\n state > " + state + "\n lastPinYinPosition > " + lastPinYinPosition + "\n pinyinComplete > " + pinyinComplete)
            previewHWRCandidate(key, label, state)
        }

        onKeyPressAndHold: {
            if(Qt.Key_Back == key) {
                isPressAndHold = true
                timerActive = true
                idDeleteLongPressTimer.start();

                if("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) {
                    isPinYinPressAndHold = true
                } else if("HANDWRITING" == pinyin) {
                    hwrInput(key, label, state);
                } else {
                    input(key, label, state);
                }
            }
        }

        onReleaseAtPressAndHold: {
            console.log("SearchView.qml :: onReleaseAtPressAndHold"  );
            if(isPressAndHold) {
                isPinYinPressAndHold = false
            }
        }

        /* 키패드 설정 이동 */
        onLaunchSettingApp: {
            idContainer.forceActiveFocus();
            cursorNormal();
            UIListener.invokePostLaunchSettingsKeypad();
        }

        /* 키패드에서 포커스 빠질때 발생 */
        onLostFocus: {
            sigLostFocus();
        }

        onChinessKeypad: {
            pinyinComplete = true;

            //console.log("######################################");
            //console.log("onChinessKeypad: chiness = " + isChiness + ", type = " + keypadType);
            //console.log("######################################");

            if("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) {
                /* 중국어 키패드 변경 할때 이전 키패드가 필기 인식인 경우
                 * 이전에 병음입력이었다면 반전된(완성되기 전) 입력분을 삭제함
                 */
                if(0 != lastPinYinPosition) {
                    changePINYIN();
                }

                clearAutomata();

            } else if("HANDWRITING" == pinyin) {
                /* 중국어 키패드 변경 할때 이전 키패드가 필기 인식인 경우 */
                if(0 != lastPinYinPosition) {
                    changePINYIN();
                }

                lastPinYinPosition = 0
            }

            else if("SOUND" == pinyin) {
                /* 중국어 키패드 변경 할때 이전 키패드가 성음인 경우 */
            }

            var newPinyin = "";
            if(true == isChiness) {
                switch(keypadType) {
                case 0: /* 병음 */
                    newPinyin = "PINYIN";
                    keypadChangeChinese();
                    idQmlQwertyKeypadWidget.searchChinesePrediction(keypadInput)
                    break;
                case 2: /* 필기 */
                    newPinyin = "HANDWRITING";
                    keypadChangeChinese();
                    idQmlQwertyKeypadWidget.searchChinesePrediction(keypadInput)
                    break;
                case 1: /* 성음 */
                    newPinyin = "SOUND";
                    keypadChangeChinese();
                    idQmlQwertyKeypadWidget.searchChinesePrediction(keypadInput)
                    break;

                default:
                    newPinyin = "NONE";
                    break;
                }
            } else {
                newPinyin = "NONE";
            }

            pinyin = newPinyin;
            sigKeypadChanged();

            /* 키패드 변경시, 필기 인식인 경우 필기 인식 초기화 함수 호출 */
            if("HANDWRITING" == newPinyin) {
                initHWRKeypad();
            }
        }

        onChineseKeypadChanged: {
            UIListener.sendChineseKeypad(keypadType);
        }

        /* 키패드가 숨겨질때 발생 */
        onIsHideChanged: {
            if(true == isHide) {
                if("PINYIN" == pinyin || (false == useVocalSound && "SOUND" == pinyin)) {
                    var position = lastPinYinPosition;
                    changePINYIN();
                    lastPinYinPosition = 0;
                    textChange();
                }

                if("SOUND" != pinyin) {
                    clearAutomata();
                }

                sigKeypadHide();

                sigLostFocus();

                if(inputMode == "jog") {
                    qwertyKeypadPress = true
                }
            } else {
                sigKeypadShow();
            }
        }

        /* 중국어 키패드 변경 팝업 표시 부분 */
        onLaunchChineseKeypadPopup: {
            idContainer.forceActiveFocus();
            cursorNormal()

            keypadInputType = pinyin
            if("SettingsBtNameChange" == idAppMain.state) {
                /* 기기이름에서는 "성음"이 없는 팝업 출력 */
                MOp.showPopup("popup_Keypad_Change_Device_Name")
            } else {
                /* 기기이름에서는 "성음"이 추가된 팝업 출력 */
                MOp.showPopup("popup_Keypad_Change")
            }
        }

        onHideFocusPinYinButton: {
            /* 중국어 키패드 병음에서 후보군 선택 시 발생
             * 포커스 중복 문제점 수정
             */
            console.log("\n\n[BT][KEYPAD] onHideFocusPinYinButton")

            if(popupState == "") {
                idContainer.showKeypadFocus();
            } else {
                idContainer.hideKeypadFocus();
            }
            MOp.returnFocus();
        }

        Component.onCompleted: {
            idContainer.keypadChanged();
            if("Done" == doneType) {
                // 숨김버튼 비활성화
                idQmlQwertyKeypadWidget.setDisableButton("hide");
            }

            if(true == useVocalSound) {
                var database = BtCoreCtrl.invokeGetVocalSoundDB();
                if("" == database) {
                    console.log("########################## bd address ERROR!!!!!!!!!!!!!");
                    idQmlQwertyKeypadWidget.setVocalSoundDB(false, "");
                } else {
                    console.log("########################## DB = " + database);
                    /* [주의] BtDatabaseWrapper.cpp에서 사용하는 DB 파일명과 동일해야 함
                     */
                    idQmlQwertyKeypadWidget.setVocalSoundDB(true, "/app/tracker/" + database + "CN.db");
                }
            }

            if(0 == outputText.length) {
                idQwertyKeypad.disableDeleteButton();
            } else {
                idQwertyKeypad.enableDeleteButton();
            }
        }
    }

    /* Key Event */
    onEtcKeyPressed: {
        switch(key) {
            case Qt.Key_Up:
                idQmlQwertyKeypadWidget.__handleJogEvent(UIListenerEnum.JOG_UP,UIListenerEnum.KEY_STATUS_CLICKED);
                break;

            case Qt.Key_Down:
                idQmlQwertyKeypadWidget.__handleJogEvent(UIListenerEnum.JOG_DOWN,UIListenerEnum.KEY_STATUS_CLICKED);
                break;

            case Qt.Key_Left:
                break;

            case Qt.Key_Right:
                //idQmlQwertyKeypadWidget.__handleJogEvent(UIListenerEnum.JOG_RIGHT,UIListenerEnum.KEY_STATUS_CLICKED)
                break;

            default:
                break;
        }
    }

    onLeftKeyPressed: {
        idQmlQwertyKeypadWidget.__handleJogEvent(UIListenerEnum.JOG_LEFT,UIListenerEnum.KEY_STATUS_CLICKED)
    }

    onRightKeyPressed: {
        idQmlQwertyKeypadWidget.__handleJogEvent(UIListenerEnum.JOG_RIGHT,UIListenerEnum.KEY_STATUS_CLICKED)
    }

    onUpLeftKeyPressed: {
        idQmlQwertyKeypadWidget.__handleJogEvent(UIListenerEnum.JOG_TOP_LEFT,UIListenerEnum.KEY_STATUS_CLICKED)
    }

    onUpRightKeyPressed: {
        idQmlQwertyKeypadWidget.__handleJogEvent(UIListenerEnum.JOG_TOP_RIGHT,UIListenerEnum.KEY_STATUS_CLICKED)
    }

    onDownLeftKeyPressed: {
        idQmlQwertyKeypadWidget.__handleJogEvent(UIListenerEnum.JOG_BOTTOM_LEFT,UIListenerEnum.KEY_STATUS_CLICKED)
    }

    onDownRightKeyPressed: {
        idQmlQwertyKeypadWidget.__handleJogEvent(UIListenerEnum.JOG_BOTTOM_RIGHT,UIListenerEnum.KEY_STATUS_CLICKED)
    }

    onWheelRightKeyPressed: {
        idQmlQwertyKeypadWidget.handleJogEvent(UIListenerEnum.JOG_WHEEL_RIGHT,UIListenerEnum.KEY_STATUS_CLICKED)
        qml_debug("Wheel Right")
    }

    onWheelLeftKeyPressed: {
        idQmlQwertyKeypadWidget.handleJogEvent(UIListenerEnum.JOG_WHEEL_LEFT,UIListenerEnum.KEY_STATUS_CLICKED)
        qml_debug("Wheel Left")
    }

    /* Timer */
    Timer {
        id: idDeleteLongPressTimer
        interval: 150
        repeat: true

        onTriggered: {
            if(true == popupOn) {
                idDeleteLongPressTimer.stop();
            } else {
                idQmlQwertyKeypadWidget.pressAndHoldTrigger()
            }
        }
    }
}
/* EOF */
