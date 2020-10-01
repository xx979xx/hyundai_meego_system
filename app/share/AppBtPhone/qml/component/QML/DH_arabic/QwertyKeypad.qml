/**
 * /QML/DH_arabic/QwertyKeypad.qml
 *
 */
import QtQuick 1.1

import QmlQwertyKeypadWidget 1.0
import AppEngineQMLConstants 1.0


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
    property bool pinyin: false
    property bool pinyinComplete: false
    property int lastPinYinPosition: 0
/////PINYIN
    property string doneType: "Done"

    // SIGNALS
    signal sigLostFocus();
    signal keyOKClicked();
    signal sigKeypadHide();
    signal sigKeypadShow();


    /* INTERNAL functions */
    function disableSearchButton(){
        idQmlQwertyKeypadWidget.setDisableButton("done")
    }

    function enableSearchButton(){
        idQmlQwertyKeypadWidget.setEnableButton("done")
    }

    function disableDeleteButton(){
        idQmlQwertyKeypadWidget.setDisableButton("delete")
    }

    function enableDeleteButton(){
        idQmlQwertyKeypadWidget.setEnableButton("delete")
    }

    function disableSpaceButton(){
        //idQmlQwertyKeypadWidget.setDisableButton("space")
    }

    function enableSpaceButton(){
        idQmlQwertyKeypadWidget.setEnableButton("space")
    }

    function showQwertyKeypad() {
        idQmlQwertyKeypadWidget.showQwertyKeypad();
    }

    function hideQwertyKeypad() {
        idQmlQwertyKeypadWidget.hideQwertyKeypad();
    }

    function isHide() {
        return idQmlQwertyKeypadWidget.isHide;
    }

    function clearAutomata() {
        idQmlQwertyKeypadWidget.clearBuffer();

        if(true == pinyin) {
            idQwertyKeypad.lastPinYinPosition = 0;
        }
    }


    /* EVENT handlers */
    Component.onCompleted: {
        if("Done" == doneType) {
            // 숨김버튼 비활성화
            idQmlQwertyKeypadWidget.setDisableButton("hide");
        }
    }

    Connections {
        target: UIListener
        onUpdateKeypad: {
            idQmlQwertyKeypadWidget.update();
        }
    }

    /* WIDGETS */
    QmlQwertyKeypadWidget {
        id: idQmlQwertyKeypadWidget
        x: qX
        y: qY
        focus: true
        focus_visible: systemPopupOn == false && idContainer.activeFocus

        doneButtonType: idContainer.doneType

        countryVariant: UIListener.GetCountryVariantFromQML()

        function input(key, label, state) {
            //console.log("######################################");
            //console.log("input(key, label, state) = " + key + ", " + label + ", " + state);
            //console.log("######################################");

            if(1 == gIgnoreReleased) {
                gIgnoreReleased = 2;
            }

            if(0xFF/* SEARCH_BOX_MAX_KEY_CODE */ > key) {
                var position = currentCursor;

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
                // 커서가 문장 중간에 위치할 수 있으므로 커서 앞/뒤 문자열 사이에 문자를 잘라내 새로운 문자열을 만들어냄
                if(0 < currentCursor) {
                    var position = currentCursor - 1;

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

        function pinyinInput(key, label, state) {
            if(Qt.Key_Back == key) {
                if(0 < lastPinYinPosition) {
                    lastPinYinPosition--;
                }

                input(key, label, state);
            } else if(Qt.Key_Home == key) {
                if(true == pinyin) {
                    // 완료를 눌렀을때 병음입력 중이었다면 삭제함
                    if(0 < lastPinYinPosition) {
                        var position =  lastPinYinPosition;

                        currentCursor = outputText.length - lastPinYinPosition
                        lastPinYinPosition = 0;
                        pinyinComplete = true;

                        outputText = outputText.substring(0, outputText.length - position)
                    }
                }

                input(key, label, state);
            } else {
                var regexLetter = /[a-zA-Zʼ]/;

                if(true == regexLetter.test(label) || label == "'") {
                    pinyinComplete = false;
                    lastPinYinPosition++;

                    input(key, label, state);
                } else {
                    if(1 == gIgnoreReleased) {
                        gIgnoreReleased = 2;
                    }
                    var position =  lastPinYinPosition;

                    currentCursor = outputText.length - lastPinYinPosition + label.length;
                    lastPinYinPosition = 0;
                    pinyinComplete = true;

                    // 영어로 입력된 글자를 삭제(lastPinyinPosition까지)하고 한자로 대체함
                    outputText = outputText.substring(0, outputText.length - position) + label;

                    console.log("outputText.length = " + outputText.length);
                    console.log("currentCursor = " + currentCursor);
                }
            }
        }

        onKeyReleased: {
            if(true == pinyin) {
                pinyinInput(key, label, state);
            } else {
                input(key, label, state);
            }
        }

        onKeyPressAndHold: {
            if(Qt.Key_Back == key) {
                var position = currentCursor;
                currentCursor = 0;

                if(true == pinyin) {
                    lastPinYinPosition = 0;
                    clearAutomata();
                }

                outputText = outputText.substring(position);
            }
        }

        onLaunchSettingApp: {
            // 키패드 설정으로 이동
            UIListener.invokePostLaunchSettingsKeypad();
        }

        onLostFocus: {
            sigLostFocus();
        }

        onChinessKeypad: {
            keypadChange()
            //console.log("######################################");
            //console.log("onChinessKeypad: chiness = " + isChiness + ", type = " + keypadType);
            //console.log("######################################");
            pinyin = isChiness;

            if(false == pinyin) {
                var position = lastPinYinPosition;

                lastPinYinPosition = 0;
                clearAutomata();

                currentCursor = outputText.length - position;
                outputText = outputText.substring(0, outputText.length - position);
            }
        }

        onIsHideChanged: {
            if(true == isHide) {
                if(true == pinyin) {
                    var position = lastPinYinPosition;

                    currentCursor = outputText.length - position;
                    outputText = outputText.substring(0, outputText.length - position);
                }

                clearAutomata();
                sigKeypadHide();

                sigLostFocus();
            } else {
                sigKeypadShow();
            }
        }
    }

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

/*DEPRECATED
    onSelectKeyPressed: {
        idQmlQwertyKeypadWidget.onJDEventSelect();
    }
DEPRECATED*/

    onWheelRightKeyPressed: {
        idQmlQwertyKeypadWidget.handleJogEvent(UIListenerEnum.JOG_WHEEL_RIGHT,UIListenerEnum.KEY_STATUS_CLICKED)
        qml_debug("Wheel Right")
    }

    onWheelLeftKeyPressed: {
        idQmlQwertyKeypadWidget.handleJogEvent(UIListenerEnum.JOG_WHEEL_LEFT,UIListenerEnum.KEY_STATUS_CLICKED)
        qml_debug("Wheel Left")
    }
}
/* EOF */
