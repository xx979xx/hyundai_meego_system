/**
 * /BT/Contacts/Search/BtContactSearchMain.qml
 * 키패드 내부에서 Cursor Delegate를 직접적으로 변경 시 커서 위치가 저장되지 않아, 몇몇개의 함수로
 * 변경이후 커서 위치 동기화 하도록 되어있
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePathArab


MComp.MComponent
{
    id: idBtContactSearch
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    /* property */
    property int listCount: 0
    property bool searchResult: false
    property bool backButtonPressed: false
    property bool keypadUpPressed: false
    property bool searchEnable: true
    property string beforeKeypad: ""
    property bool popupOn: (popupState != "") ? true : false

    /* 시스템 팝업이 떠있는 경우, 이 전 포커스 위치를 판단하는 변수
     * 0: 초기값 1: 키패드 포커스, 2: 입력창 포커스
     */
    property int focusPoint: 0

    /* list로 포커스를 이동해야 하는 상황 check */
    property bool listFocusOn: false

    property int countZeroresult: 0

    /* function */

    /* 입력창 내부 커서 변경
     * text가 변경될때 이전 Cursor위치를 유지하는 문제로 Text를 다시 변경 해주어 Cursor 위치 재설정
     */
    function cursorChanged() {
        /* 입력창 내부 커서 위치 재설정 부분으로 영어 입력 후 다른 Text로 변경 될때 필요한 함수
         * 함수 내부적인 동작은 기존 커서 위치를 0으로 초기화 이후 입력된 Text에 따라 다시 커서 위치 재 설정 부분
         */

        // Text 저장
        var hiddenText = ""

        // 커서 위치 저장
        var hiddenCursor = 0

        /* 검색 동작을 하지 않도록 하는 변수(searchEnable) 변수로 막아주지 않으면 입력된 값이
         * 초기화 될때 검색하고 다시 입력 되는 값에 또 검색을 수행 하게됨
         */
        searchEnable = false

        // 기존의 Text와 커서 위치 저장
        hiddenText = idTextInputSearch.text
        hiddenCursor = idTextInputSearch.cursorPosition

        /*
         * 성음 입력 검색창 터치 시, 키패드 활성화 되지 않도록 수정
         * 성음을 제외한 키패드 타입에서 초기화 하도록 코드 수정 (필기 인식에서 커서와 글씨 겹치는 이슈)
         */
        if("SOUND" == idQwertyKeypad.pinyin) {
            idTextInputSearch.text = idQwertyKeypad.outputText
            idTextInputSearchHide.text = idTextInputSearch.text
        } else {
            idTextInputSearch.text = hiddenText + "a"
            idTextInputSearchHide.text = hiddenText + "a"
        }

        // 저장된 Text 다시 입력
        idTextInputSearch.text = hiddenText
        idTextInputSearch.cursorPosition = hiddenCursor
        idTextInputSearchHide.text = hiddenText
        idTextInputSearchHide.cursorPosition = hiddenCursor

        // 검색 허용 변수 초기화
        searchEnable = true
    }

    /* 병음 입력 시 알파벳이 입력된 상태에서 입력창으로 포커스 이동 시 알파벳 구분자 삭제
     */
    function removeSelect() {
        /* 성음에서는 입력창 선택 시 변경이 알파벳으로 필요없음 */
        if("SOUND" == idQwertyKeypad.pinyin) {
            return;
        }

        var cutText = idQwertyKeypad.outputText

        // 처음부터 입력 된 Text까지의 문구 저장
        var haedText = cutText.substring(0,idTextInputSearch.selectionStart)

        // 입력 중인 Text 저장
        var badyText = cutText.substring(idTextInputSearch.selectionStart, idTextInputSearch.selectionStart + idQwertyKeypad.lastPinYinPosition)

        // 입력된 Text 이후 문구 저장
        var tailText = cutText.substring(idTextInputSearch.selectionStart + idQwertyKeypad.lastPinYinPosition)

        // 입력 중인 Text에서 구분자(') 삭제하고 다시 변수에 저장
        badyText = badyText.replace(/'/gi,"")

        // Text 재 조립
        idQwertyKeypad.outputText = haedText + badyText + tailText

        // 초기화
        idQwertyKeypad.lastPinYinPosition = 0
        idQwertyKeypad.clearAutomata()
        idQwertyKeypad.currentCursor = haedText.length + badyText.length
        idTextInputSearch.cursorPosition = idQwertyKeypad.currentCursor
        idTextInputSearchHide.cursorPosition = idQwertyKeypad.currentCursor
    }


    /* 입력창에 포커스가 전달 될때 Cursor Delegate 변경 부분
     */
    function cursorFocus() {

        //입력창에 포커스 이동될때 구분자(')가 있는 경우 구분자 삭제하고 입력
        removeSelect()

        // 포커스 커서 변경
        idTextInputSearch.cursorDelegate = idDelegateFocusCursor


        if(0 != idTextInputSearch.text.length && idQwertyKeypad.pinyin != "SOUND") {
            if(idQwertyKeypad.pinyin == "PINYIN") {
                // ITS 228021 문제점 병음 키패드에서 구분자 삭제 동작이후 검색 동작 추가
                BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
            }

            // 입력된 값이 있고, 성음 키패드가 아닌 경우 Marker을 표시
            idTextInputSearchHide.show();
        }

        // 커서 동기화
        cursorChanged()
        idTextInputSearch.forceActiveFocus();
        if(false == listFocusOn) {
            focusPoint = 2;
        }
    }

    /* 입력창에 포커스가 사라질때 Cursor Delegate 변경 부
     */
    function cursorNormal() {
        if(idTextInputSearch.cursorDelegate == idDelegateFocusCursor) {
            // 포커스 없는 커서로 변경
            idTextInputSearch.cursorDelegate = idDelegateCursor

            // 포커스 위치 동기화
            cursorChanged()

            // 하단의 Marker 숨김
            idTextInputSearchHide.hide();
        }
    }

    /* 중국어 키패드 입력 시 검색되는 값의 Model 변경 부 (검색 동작이 달라 다른 model을 사용)
     */
    function changeListModel() {
        if(2 == UIListener.invokeGetCountryVariant()) {
            /* 중국어 */
            if("SOUND" == idQwertyKeypad.pinyin) {
                /* 성음 */ idBtContactSearchListView.model = InitialSearchResultContactList
            } else {
                /* 병음, 필기인식 */ idBtContactSearchListView.model = contactExactSearchProxy
            }
        } else {
            /* 중국어를 제외한 언어 */ idBtContactSearchListView.model = contactExactSearchProxy
        }
    }

    /* signal */
    Connections {
        target: UIListener

        /* 언어 변경 Signal */
        onRetranslateUi: {
            if(20 == gLanguage) {
                idTextInputSearch.anchors.left = undefined
                idTextInputSearch.anchors.right = idImageSearchBar.right
                idTextInputSearch.anchors.rightMargin = 50
            } else {
                idTextInputSearch.anchors.right = undefined
                idTextInputSearch.anchors.left = idImageSearchBar.left
                idTextInputSearch.anchors.leftMargin = 33
            }

            // 후석을 통하여 언어 변경 동작이 일어 날 때, 검색된 리스트의 Model 변경
            idBtContactSearch.changeListModel();
        }
    }

    Connections {
        target: idAppMain

        /* 키패드 변경 시 발생되는 Signal */
        onKeypadChange: {
            if(0 == idTextInputSearch.text.length) {
                idQwertyKeypad.disableDeleteButton();
            } else {
                idQwertyKeypad.enableDeleteButton();
            }

            if(false == idButtonSearch.mEnabled) {
                idQwertyKeypad.disableSearchButton("done")
            } else {
                idQwertyKeypad.enableSearchButton("done")
            }
        }

        /* 중국 키패드 변경 시 발생되는 Signal */
        onKeypadChangeChinese: {
            if("" != idQwertyKeypad.pinyin) {
                if("SOUND" == idQwertyKeypad.pinyin) {
                    BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, true)
                } else {
                    BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
                }
            } else {
                BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
            }
        }

        /* 팝업이 표시될 때 발생하는 Signal */
        onSigPopupStateChanged: {
            /* ITS 0238170/0236422/0237335 검색 화면 > 로컬 팝업 > 시스템 팝업 > BT 다른 화면 진입 > CCP jog up > 포커스 사라짐
             * 검색화면으로 포커스 이동되지 않도록 조건문 추가
             */
            //[ITS 0271233]
            if(idBtContactSearchListView.visible == true)
            {
                idBtContactSearchListView.stopScroll();
            }

            if(0 < callType){
                if("FOREGROUND" == callViewState){
                    //do nothing
                }
            } else {
                if("BtContactSearchMain" == idAppMain.state) {
                    if(false == systemPopupOn) {
                        console.log("\n\n onSigPopupStateChanged systemPopupOn :\n\n" + focusPoint)
                        if(true == idQwertyKeypad.activeFocus) {
                            focusPoint = 1;
                            idQwertyKeypad.hideKeypadFocus();
                        } else if(true == idTextInputSearch.activeFocus) {
                            focusPoint = 2;
                            cursorNormal();
                        } else if (true == listFocusOn) {
                            focusPoint = 3;
                        }
                    } else {
                        /* BT 팝업과 시스템 팝업이 겹쳐 뜰 때, 포커스 이슈 */
                        if(false == popupOn) {
                            console.log("\n\n onSigPopupStateChanged systemPopupOff : \n\n" + focusPoint)
                            if(1 == focusPoint) {
                                idQwertyKeypad.showKeypadFocus();
                            } else if(2 == focusPoint) {
                                cursorFocus();
                                idTextInputSearchHide.hide();
                            } else if(3 == focusPoint) {
                                idBtContactSearchListView.forceActiveFocus();
                                keypadUpPressed = false;
                            }

                            focusPoint = 0;
                            console.log("\n\n onSigPopupStateChanged systemPopupOff \n\n")
                            listFocusOn = false;
                        }
                    }
                } else {
                    //do nothing
                }
            }
        }

        /* 키패드 초기화 Signal */
        onIniKeypadInput: {
            idTextInputSearch.text = ""
            idTextInputSearchHide.text = ""
            idQwertyKeypad.outputText = idTextInputSearch.text
            idQwertyKeypad.clearAutomata();
        }

        onPopupDisplayToDeviceName : {
            idQwertyKeypad.sigSendJogCanceled();
            console.log("\n\n[BT]QML onPopupDisplayToDeviceName")
        }
    }

    onPopupOnChanged: {
        if(true == popupOn) {
            /* local 팝업이 뜨는 경우 */
            idTextInputSearch.cursorDelegate = idDelegateCursor
            idTextInputSearchHide.hide();
        } else {
            if(true == idBtContactSearch.visible) {
                if(true == systemPopupOn) {
                    /* local 팝업은 닫히고 system 팝업은 떠 있는 경우 */
                    idQwertyKeypad.hideKeypadFocus();
                } else {
                    if(1 == focusPoint) {
                        idQwertyKeypad.showKeypadFocus();
                    } else if(2 == focusPoint) {
                        cursorFocus();
                        idTextInputSearchHide.hide();
                    } else if(3 == focusPoint) {
                        idBtContactSearchListView.forceActiveFocus();
                        keypadUpPressed = false;
                    }
                    focusPoint = 0;
                    listFocusOn = false;
                }
            }
        }
    }

    /* EVENT handlers */
    Component.onCompleted: {
        if(contactSearchInput == "") {
            idTextInputSearch.text = ""
            idTextInputSearchHide.text = ""
        } else {
            idTextInputSearch.text = contactSearchInput
            idTextInputSearchHide.text = contactSearchInput
        }

        idQwertyKeypad.outputText = idTextInputSearch.text

        idQwertyKeypad.showQwertyKeypad();
        idTextInputSearch.cursorDelegate = idDelegateCursor
        idQwertyKeypad.forceActiveFocus();

        idTextInputSearch.cursorPosition = idTextInputSearch.text.length
        idTextInputSearchHide.cursorPosition = idTextInputSearch.text.length
        idQwertyKeypad.currentCursor = idTextInputSearch.text.length

        // 키패드 입력 변경 시 입력된 값에 의해 검색 동작 추가
        if("" != idQwertyKeypad.pinyin) {
            if("SOUND" == idQwertyKeypad.pinyin) {
                BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, true)
            } else {
                BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
            }
        } else {
            BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
        }

        // 입력값이 없는 경우 Delete 버튼 비활성화
        if(0 == idTextInputSearch.text.length) {
            idQwertyKeypad.disableDeleteButton();
        } else {
            idQwertyKeypad.enableDeleteButton();
        }

        // 중국향 키패드에서는 SpeaceBar 초기 항상 비활성화
        if("NONE" != idQwertyKeypad.pinyin ) {
            idQwertyKeypad.disableSpaceButton();
        } else {
            if(0 == idTextInputSearch.text.length) {
                idQwertyKeypad.disableSpaceButton();
            } else {
                idQwertyKeypad.enableSpaceButton();
            }
        }

        // 현재 언어가 중동향인지 확인 이후 입력창의 위치를 변경
        if(20 == gLanguage) {
            idTextInputSearch.anchors.left = undefined
            idTextInputSearch.anchors.right = idImageSearchBar.right
            idTextInputSearch.anchors.rightMargin = 50
        } else {
            idTextInputSearch.anchors.right = undefined
            idTextInputSearch.anchors.left = idImageSearchBar.left
            idTextInputSearch.anchors.leftMargin = 33
        }
    }

    Component.onDestruction: {
        idDownScrollTimer.stop();
        idUpScrollTimer.stop();
    }

    onVisibleChanged: {
        changeListModel();
        if(contactSearchInput == "") {
            if(4 == UIListener.invokeGetCountryVariant()){
                idTextInputSearch.text = "a"
            }
            idTextInputSearch.text = ""
            idTextInputSearchHide.text = ""
        } else {
            idTextInputSearch.text = contactSearchInput
            idTextInputSearchHide.text = contactSearchInput
        }

        idQwertyKeypad.outputText = idTextInputSearch.text

        idTextInputSearch.cursorPosition = idTextInputSearch.text.length
        idTextInputSearchHide.cursorPosition = idTextInputSearch.text.length
        idQwertyKeypad.currentCursor = idTextInputSearch.text.length

        if(true == idBtContactSearch.visible) {
            setKeypad();
            idQwertyKeypad.showQwertyKeypad();
            idTextInputSearch.cursorDelegate = idDelegateCursor
            idQwertyKeypad.forceActiveFocus();

            idQwertyKeypad.clearAutomata();

            if(true == idQwertyKeypad.isHide()) {
                idQwertyKeypad.showQwertyKeypad();
                idTextInputSearch.cursorDelegate = idDelegateCursor
                idQwertyKeypad.forceActiveFocus();
            }

            if(0 == idTextInputSearch.text.length) {
                idQwertyKeypad.disableDeleteButton();
                idQwertyKeypad.disableSpaceButton();
            } else {
                idQwertyKeypad.enableDeleteButton();
                if("NONE" == idQwertyKeypad.pinyin) {
                    idQwertyKeypad.enableSpaceButton();
                }
            }

            if(20 == gLanguage) {
                idTextInputSearch.anchors.left = undefined
                idTextInputSearch.anchors.right = idImageSearchBar.right
                idTextInputSearch.anchors.rightMargin = 50
            } else {
                idTextInputSearch.anchors.right = undefined
                idTextInputSearch.anchors.left = idImageSearchBar.left
                idTextInputSearch.anchors.leftMargin = 33
            }
        } else {
            if("" != idQwertyKeypad.pinyin) {
                if("SOUND" == idQwertyKeypad.pinyin) {
                    BtCoreCtrl.invokeTrackerSearchPhonebook("", true)
                } else {
                    BtCoreCtrl.invokeTrackerSearchPhonebook("", false)
                }
            } else {
                BtCoreCtrl.invokeTrackerSearchPhonebook("", false)
            }

            idQwertyKeypad.showQwertyKeypad();
            idDownScrollTimer.stop();
            idUpScrollTimer.stop();
        }
    }

    onBackKeyPressed: {
        popScreen(203);

        if("FROM_SEARCH" == favoriteAdd){
            favoriteAdd = "FROM_CONTACT";
        }
    }

    MouseArea {
        anchors.fill: parent
        beepEnabled: false
    }

    Rectangle {
        color: "Black"
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight
        x: 0
        y: 0
        visible: (false == idBtContactSearchListView.visible) ? true : false

        // 검색결과가 있으면 Listview, 없으면 아래 문구("검색결과가 없습니다.") 표시
        Text {
            text: stringInfo.str_Bt_No_List
            x: 150
            y: 294
            width: 980
            height: 40
            font.pointSize: 40
            font.family: stringInfo.fontFamilyRegular    //"HDB"
            color: colorInfo.brightGrey
            horizontalAlignment: "AlignHCenter"
            wrapMode: Text.WordWrap
        }
    }

    /* Widgets */
    Image {
        source: ImagePath.imgFolderGeneral + "bg_title.png"
        x: 0;
        y: 0;
    }

    Image {
        id: idImageSearchBar
        source: 20 == gLanguage ? ImagePathArab.imgFolderKeypad + "bg_search_m.png" : ImagePath.imgFolderKeypad + "bg_search_m.png"
        x: 20 == gLanguage ? 282 : 7
        z: 100
        width: 992
        height: 69

        MouseArea {
            anchors.fill: parent

            onClicked: {
                // 입력창 선택 시 키패드 보여짐
                idQwertyKeypad.initCommaTimer();
                idQwertyKeypad.showQwertyKeypad();

                cursorFocus();
                idQwertyKeypad.lastPinYinPosition = 0
                idQwertyKeypad.pinyinComplete = true
                idTextInputSearch.cursorPosition = idTextInputSearch.positionAt(mouseX, TextInput.CursorOnCharacter);
                idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition
                idTextInputSearchHide.cursorPosition = idTextInputSearch.cursorPosition
            }
        }

        // Search text input
        TextInput {
            id: idTextInputSearch
            text: contactSearchInput
            y: 10
            width: 847 - 44 - idTextResult.paintedWidth

            color: colorInfo.buttonGrey;
            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            cursorVisible: true
            cursorPosition: idTextInputSearch.text.length
            cursorDelegate: idDelegateCursor
            horizontalAlignment: 20 == gLanguage && idTextInputSearch.text.length == 0 ? Text.AlignRight : undefined

            property string keyCompensation: "";

            Item {
                id: idHiddenTextItem
                anchors.fill: parent

                Text {
                    id: idSearchText
                    x: 5
                    text: stringInfo.str_Search_Phonebook_Text
                    color: colorInfo.dimmedGrey
                    font.pointSize: 32
                    font.family: stringInfo.fontFamilyBold    //"HDR"
                    anchors.verticalCenter: parent.verticalCenter
                    visible: idTextInputSearch.text.length == 0
                    anchors.right: 20 == gLanguage ? parent.right : undefined
                    anchors.left: 20 != gLanguage ? parent.left : undefined
                }

                Text {
                    text: idQwertyKeypad.pinyin == "SOUND" ? " [" + stringInfo.str_Keypad_Sound + "]" : idQwertyKeypad.pinyin == "PINYIN" ? " [" + stringInfo.str_Keypad_Pinyin + "]" : ""
                    color: colorInfo.dimmedGrey
                    font.pointSize: 32
                    font.family: stringInfo.fontFamilyBold    //"HDR"
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: idSearchText.right
                    visible: idTextInputSearch.text.length == 0
                }
            }

            onTextChanged: {
                if(true == backButtonPressed) {
                    /* Back Key가 눌린경우 1글자가 지워지므로 복원함(복원하지 않을 경우 1글자가 지워지며 Home으로 빠짐)
                     */
                    idTextInputSearch.text = idQwertyKeypad.outputText;
                    backButtonPressed = false;
                }

                if(idQwertyKeypad.pinyin != "") {
                    if(0 == idTextInputSearch.text.length) {
                        idQwertyKeypad.disableDeleteButton();
                    } else {
                        idQwertyKeypad.enableDeleteButton();
                    }
                }

                if("NONE" != idQwertyKeypad.pinyin) {
                    console.log("#########################")
                    console.log("idQwertyKeypad.pinyin > " + idQwertyKeypad.pinyin)
                    console.log("#########################")
                    if("PINYIN" == idQwertyKeypad.pinyin) {

                    } else if("SOUND" == idQwertyKeypad.pinyin) {
                        if(true == searchEnable) {
                            BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, true)
                        }
                    } else {
                        if(true == searchEnable) {
                            BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
                        }
                    }
                } else {
                    //삭제 키 Longpress 중일 때, 검색 되지 않도록 수정
                    if(true == searchEnable && false == idQwertyKeypad.timerActive) {
                        BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
                    }
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    idQwertyKeypad.initCommaTimer();
                    // 입력창 선택 시 키패드 보여짐
                    idQwertyKeypad.showQwertyKeypad();

                    cursorFocus()
                    idQwertyKeypad.lastPinYinPosition = 0
                    idQwertyKeypad.pinyinComplete = true

                    idTextInputSearch.cursorPosition = idTextInputSearch.positionAt(mouseX, TextInput.CursorOnCharacter);
                    idTextInputSearchHide.cursorPosition = idTextInputSearch.cursorPosition
                    idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition
                }

                //DEPRECATED KeyNavigation.left: {}
                KeyNavigation.down: idQwertyKeypad
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
                        event.accepted = true;
                        break;
                    }
                }
            }

            Keys.onReleased: {
                if(2 == gIgnoreReleased) {
                    gIgnoreReleased = 0;
                    console.log("## gIgnoreReleased Change(2 -> 0)")
                    /* 검색 결과 없을 때, 서치바에서 밴드 버튼으로 한번에 포커스 이동하지 않는 이슈
                     * gIgnoreReleased = 0 셋팅 후, return 타지 않게 수정
                     */
                    if((1 > idBtContactSearchListView.count)) {
                        if (20 != gLanguage) {
                            if(Qt.Key_Right == event.key || Qt.Key_Backspace == event.key || Qt.Key_J == event.key || Qt.Key_Comma == event.key) {
                                //do nothing
                            } else {
                                return;
                            }
                        } else {
                            if(Qt.Key_Left == event.key || Qt.Key_Backspace == event.key || Qt.Key_J == event.key || Qt.Key_Comma == event.key) {
                                //do nothing
                            } else {
                                return;
                            }
                        }
                    }
                }
                // MComponent를 이용하지 않고 직접 키 처리
                switch(event.key) {
                case Qt.Key_Return:
                case Qt.Key_Enter: {
                    cursorNormal()
                    idQwertyKeypad.forceActiveFocus();
                    idTextInputSearchHide.hide();
                    break;
                }

                case Qt.Key_Semicolon: {
                    if("" == idTextInputSearch.text) {
                        idTextInputSearchHide.hide();

                    } else {
                        idMarkerTimer.restart();
                        idTextInputSearchHide.show();
                        if("SOUND" == idQwertyKeypad.pinyin) {
                            return;
                        }

                        if(0 < cursorPosition) {
                            cursorPosition--;
                        } else {
                            //cursorPosition = idTextInputSearch.text.length;
                        }
                    }

                    idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition;
                    idQwertyKeypad.outputCursor = idTextInputSearch.cursorPosition
                    idTextInputSearchHide.cursorPosition = idTextInputSearch.cursorPosition
                    idQwertyKeypad.clearAutomata();
                    break;
                }

                case Qt.Key_Apostrophe: {
                    if("" == idTextInputSearch.text) {
                        idTextInputSearchHide.hide();

                    } else {
                        idMarkerTimer.restart();
                        idTextInputSearchHide.show();
                        if("SOUND" == idQwertyKeypad.pinyin) {
                            return;
                        }

                        if(idTextInputSearch.text.length > cursorPosition) {
                            cursorPosition++;
                        } else {
                            //cursorPosition = 0;
                        }
                    }

                    idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition;
                    idQwertyKeypad.outputCursor = idTextInputSearch.cursorPosition
                    idTextInputSearchHide.cursorPosition = idTextInputSearch.cursorPosition
                    idQwertyKeypad.clearAutomata();
                    break;
                }

                case Qt.Key_Backspace:
                case Qt.Key_J:
                case Qt.Key_Comma: {
                    idTextInputSearchHide.hide();
                    console.log("## Keys.onPressed(BACK)");
                    /* Back Key가 눌린경우 1글자가 지워지므로 복원함(복원하지 않을 경우 1글자가 지워지며 Home으로 빠짐)
                         */
                    backButtonPressed = true;
                    popScreen(6578);

                    break;
                }

                case Qt.Key_Down: {
                    if(idBtContactSearchListView.visible
                            && idBtContactSearchListView.count > 0) {
                        idQwertyKeypad.hideQwertyKeypad();
                        idBtContactSearchListView.forceActiveFocus();
                        idBtContactSearchListView.longPressed = false
                        idTextInputSearchHide.hide();

                    } else {
                        idQwertyKeypad.forceActiveFocus();
                        idTextInputSearchHide.hide();
                    }

                    cursorNormal()

                    keypadUpPressed = false;
                    event.accepted = true;

                    break;
                }

                case Qt.Key_Left: {
                    event.accepted = true;

                    if(20 == gLanguage) {
                        if(true == idButtonSearch.mEnabled) {
                            idButtonSearch.forceActiveFocus();
                        } else {
                            idButtonBack.forceActiveFocus();
                        }

                        idTextInputSearchHide.hide();
                        cursorNormal()
                    }
                    break;
                }

                case Qt.Key_Right: {
                    event.accepted = true;

                    if(20 != gLanguage) {

                        if(true == idButtonSearch.mEnabled) {
                            idButtonSearch.forceActiveFocus();
                        } else {
                            idButtonBack.forceActiveFocus();
                        }

                        idTextInputSearchHide.hide();
                        cursorNormal()
                    }

                    break;
                }

                default:
                    break;
                }
            }
        }

        TextInput {
            id: idTextInputSearchHide
            text: idTextInputSearch.text
            anchors.left: idTextInputSearch.left
            anchors.right: idTextInputSearch.right
            anchors.top: idTextInputSearch.bottom
            anchors.topMargin: 4
            z: 100
            horizontalAlignment: 20 == gLanguage && idTextInputSearch.text.length == 0 ? Text.AlignRight : undefined


            font.pointSize: 32
            font.family: stringInfo.fontFamilyBold    //"HDB"
            color: colorInfo.transparent
            cursorVisible: true
            cursorPosition: idTextInputSearch.text.length
            cursorDelegate: idMarker

            property string keyCompensation: "";
            visible: true

            state: "HIDE"

            MouseArea {
                anchors.fill: parent

                onPositionChanged: {
                    idMarkerTimer.stop()
                    // 터치된 위치로 커서를 옮기고 Marker를 표시함
                    idTextInputSearch.forceActiveFocus();
                    idTextInputSearchHide.cursorPosition = idTextInputSearch.positionAt(mouseX, TextInput.CursorOnCharacter);
                    idTextInputSearch.cursorPosition = idTextInputSearchHide.cursorPosition
                    idQwertyKeypad.currentCursor = idTextInputSearch.cursorPosition
                }
                onReleased: {
                    idMarkerTimer.start()
                }
            }

            function show() {
                idTextInputSearchHide.state = "SHOW";
                idMarkerTimer.restart();
            }

            function hide() {
                idTextInputSearchHide.state = "HIDE";
                idMarkerTimer.stop();
            }

            Timer {
                id: idMarkerTimer
                interval: 5000
                running: false
                repeat: false

                onTriggered: {
                    idTextInputSearchHide.hide();
                }
            }

            states: [
                State {
                    name: "SHOW";
                    PropertyChanges { target: idTextInputSearchHide;   opacity: 1; }
                }
                , State {
                    name: "HIDE";
                    PropertyChanges { target: idTextInputSearchHide;   opacity: 0; }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation { target: idTextInputSearchHide;   properties: "opacity";  duration: 500 }
                }
            ]
        }
        // Cursor delegate
        Component {
            id: idDelegateCursor

            Item {
                y: 3
                width: 0
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

        Component {
            id: idDelegateFocusCursor

            Item {
                y: 3
                width: 0
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

        // "Search Result: 0"
        Text {
            id: idTextResult
            text: idBtContactSearchListView.count
            y: 0
            height: 30
            font.family: stringInfo.fontFamilyBold    //"HDB"
            font.pointSize: 30
            color: colorInfo.disableGrey

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            visible: (0 < idTextInputSearch.text.length && gLanguage != 20) ? true : false

            anchors.right: parent.right
            anchors.rightMargin: 26
            anchors.verticalCenter: parent.verticalCenter

            onVisibleChanged: {
                if(true == idTextResult.visible) {
                    idTextInputSearch.width = 847 - 44 - idTextResult.paintedWidth;
                }
            }

            onTextChanged: {
                idTextInputSearch.width = 847 - idTextResult.paintedWidth;
            }
        }

        // 검색결과가 있을때 표시되는 사람 아이콘
        Image {
            source: ImagePath.imgFolderKeypad + "ico_search_result.png"
            y: 14
            anchors.right: idTextResult.left
            anchors.verticalCenter: idTextResult.verticalCenter
            visible: idTextResult.visible
        }

        Text {
            id: idTextResultArab
            text: idBtContactSearchListView.count
            y: 0
            height: 30
            font.family: stringInfo.fontFamilyBold    //"HDB"
            font.pointSize: 30
            color: colorInfo.disableGrey

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            visible: (0 < idTextInputSearch.text.length && gLanguage == 20) ? true : false

            anchors.left: parent.left
            anchors.leftMargin: 27
            anchors.verticalCenter: parent.verticalCenter

            onVisibleChanged: {
                if(true == idTextResult.visible) {
                    idTextInputSearch.width = 847 - idTextResult.paintedWidth;
                }
            }

            onTextChanged: {
                idTextInputSearch.width = 847 - idTextResult.paintedWidth;
            }
        }

        // 검색결과가 있을때 표시되는 사람 아이콘
        Image {
            source: ImagePath.imgFolderKeypad + "ico_search_result.png"
            y: 14
            anchors.left: idTextResultArab.right
            anchors.verticalCenter: idTextResultArab.verticalCenter
            visible: idTextResultArab.visible
        }
    }

    // Search key button
    MComp.MButton {
        id: idButtonSearch
        x: 20 == gLanguage ? 141 : 998
        y: 0
        width: 141
        height: 72

        bgImage: 20 == gLanguage ? ImagePathArab.imgFolderGeneral + "btn_title_sub_n.png" : ImagePath.imgFolderGeneral + "btn_title_sub_n.png"
        bgImagePress: 20 == gLanguage ? ImagePathArab.imgFolderGeneral + "btn_title_sub_p.png" : ImagePath.imgFolderGeneral + "btn_title_sub_p.png"
        bgImageFocus: 20 == gLanguage ? ImagePathArab.imgFolderGeneral + "btn_title_sub_f.png" : ImagePath.imgFolderGeneral + "btn_title_sub_f.png"

        fgImage: true == idButtonSearch.mEnabled ? ImagePath.imgFolderKeypad + "icon_title_search_n.png" : ImagePath.imgFolderKeypad + "icon_title_search_d.png"

        fgImageX: 41
        fgImageY: 6
        fgImageWidth: 60
        fgImageHeight: 60
        mEnabled: {
            if("" !=idQwertyKeypad.pinyin) {
                if(0 == idTextInputSearch.text.length) {
                    false
                } else if (0 != idQwertyKeypad.lastPinYinPosition) {
                    false
                } else {
                    true
                }
            } else {
                (0 != idTextInputSearch.text.length)
            }
        }

        property bool longPressed: false

        // 검색 버튼 비활성화 시 키패드 내부 검색 버튼 비활성화 하는 코드 추가
        onMEnabledChanged: {
            if(false == idButtonSearch.mEnabled) {
                idQwertyKeypad.disableSearchButton("done")
            } else {
                idQwertyKeypad.enableSearchButton("done")
            }
        }

        onClickOrKeySelected: {
            if(1 > idBtContactSearchListView.count) {
                removeSelect()
                cursorFocus()
                idTextInputSearch.cursorPosition = idQwertyKeypad.currentCursor
                idQwertyKeypad.hideQwertyKeypad();
                keypadUpPressed = false;
            } else {
                idQwertyKeypad.hideQwertyKeypad();
                keypadUpPressed = false;
                idTextInputSearchHide.hide();
                idTextInputSearch.cursorDelegate = idDelegateCursor
                idBtContactSearchListView.currentIndex = 0;
                idBtContactSearchListView.forceActiveFocus();
            }
        }

        Keys.onReleased: {
            /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
             * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
             */
            if(Qt.Key_Down == event.key) {
                if(Qt.ShiftModifier == event.modifiers) {
                    // Long-pressed
                    idButtonSearch.longPressed = false;
                    event.accepted = true;
                } else {
                    // Short pressed
                    event.accepted = true;
                }

                // 키패드 내부 조그 동작 수정 - ISV 조그 동작 동기화 문제점
                if(idBtContactSearchListView.visible
                        && idQwertyKeypad.isHide()
                        && idBtContactSearchListView.count > 0) {
                    idBtContactSearchListView.forceActiveFocus();
                    idBtContactSearchListView.longPressed = true
                } else {
                    idQwertyKeypad.showQwertyKeypad();
                    idQwertyKeypad.forceActiveFocus();
                }
                event.accepted = true;

            } else if(Qt.Key_Left == event.key) {
                if(20 != gLanguage) {
                    cursorFocus()
                }
            } else if(Qt.Key_Right == event.key) {
                if(20 == gLanguage) {
                    if("NONE" != idQwertyKeypad.pinyin) {
                        idButtonSearch.forceActiveFocus();
                    } else {
                        cursorFocus()
                    }
                }
            }
        }

        //KeyNavigation.left: ("NONE" != idQwertyKeypad.pinyin) ?  idButtonSearch : idTextInputSearch;
        onWheelLeftKeyPressed: {
            if(20 == gLanguage) {
                idButtonBack.forceActiveFocus();
            }
        }

        onWheelRightKeyPressed: {
            if(20 != gLanguage) {
                idButtonBack.forceActiveFocus();
            }
        }
    }

    // Back key button
    MComp.MButton {
        id: idButtonBack
        x: 20 == gLanguage ? 3 : 1136
        y: 0
        width: 141
        height: 72

        bgImage: 20 == gLanguage ? ImagePathArab.imgFolderGeneral + "btn_title_back_n.png" : ImagePath.imgFolderGeneral + "btn_title_back_n.png"
        bgImagePress: 20 == gLanguage ? ImagePathArab.imgFolderGeneral + "btn_title_back_p.png" : ImagePath.imgFolderGeneral + "btn_title_back_p.png"
        bgImageFocus: 20 == gLanguage ? ImagePathArab.imgFolderGeneral + "btn_title_back_f.png" : ImagePath.imgFolderGeneral + "btn_title_back_f.png"

        /* [주의] Backkey pressed와 Back button pressed를 동시에 처리해야 함
         */
        onClickOrKeySelected: {
            idTextInputSearchHide.hide();
            idTextInputSearch.cursorDelegate = idDelegateCursor
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
                    event.accepted = true;
                } else {
                    // Short pressed
                    event.accepted = true;
                }
            } else if(Qt.Key_Left == event.key) {
                if(20 != gLanguage) {
                    cursorFocus()
                }
            } else if(Qt.Key_Right == event.key) {
                if(20 == gLanguage) {
                    if("NONE" != idQwertyKeypad.pinyin) {
                        idButtonBack.forceActiveFocus();
                    } else {
                        cursorFocus()
                    }
                }
            }
            
            // 키패드 내부 조그 동작 수정 - ISV 조그 동작 동기화 문제점
            if(Qt.Key_Down == event.key) {
                if(idBtContactSearchListView.visible
                        && idQwertyKeypad.isHide()
                        && idBtContactSearchListView.count > 0) {
                    idBtContactSearchListView.forceActiveFocus();
                    idBtContactSearchListView.longPressed = false
                } else {
                    idQwertyKeypad.showQwertyKeypad();
                    idQwertyKeypad.forceActiveFocus();
                }
                event.accepted = true;
            }
        }

        onWheelLeftKeyPressed: {
            if(20 != gLanguage) {
                if(false == idButtonSearch.mEnabled) {
                    idButtonBack.forceActiveFocus();
                } else {
                    idButtonSearch.forceActiveFocus();
                }
            }
        }

        onWheelRightKeyPressed: {
            if(20 == gLanguage) {
                if(false == idButtonSearch.mEnabled) {
                    idButtonBack.forceActiveFocus();
                } else {
                    idButtonSearch.forceActiveFocus();
                }
            }
        }
    }

    // Search result listview
    MComp.DDListView {
        id: idBtContactSearchListView
        y: 73
        width: systemInfo.lcdWidth
        height: 540
        visible: idBtContactSearchListView.count != 0 && idTextInputSearch.text != ""
        snapMode: idBtContactSearchListView.moving ? ListView.SnapToItem : ListView.NoSnap // modified by Dmitry 27.07.13
        highlightMoveDuration: 1
        highlightFollowsCurrentItem: true
        updateOnLanguageChanged: false;
        model: {
            if(2 == UIListener.invokeGetCountryVariant()) {
                if("SOUND" == idQwertyKeypad.pinyin) {
                    InitialSearchResultContactList
                } else {
                    contactExactSearchProxy
                }
            } else {
                // 기타 다른 모든 언어
                contactExactSearchProxy
            }
        }

        // 검색화면은 리스트의 수가 동적으로 변경되므로 cacheBuffer를 적용하면 오히려 속도가 저하되어 제거함
        //DEPRECATED cacheBuffer: 1000
        clip: true
        focus: true

        property bool longPressed: false

        // 바운스 효과 추가
        // boundsBehavior: Flickable.StopAtBounds

        onActiveFocusChanged: {
            if(true == idBtContactSearchListView.activeFocus && true == listFocusOn) {
                focusPoint = 3;
            }
        }

        onFlickEnded: {
            cursorNormal();
        }

        onMovementStarted: {
            if(idQwertyKeypad.isHide() == false) {
                hideByFlicking = true;
                idQwertyKeypad.hideQwertyKeypad();
            }
        }

        onMovementEnded: {
            if(false == idBtContactSearchListView.visible) {
                return;
            }

            // Flicking 후 화면 상단에 포커스를 설정함
            var endIndex = getEndIndex(contentY);
            var flickingIndex = getStartIndex(contentY);

            if(endIndex >= currentIndex && flickingIndex < currentIndex){
                // onMovementEnded 시점에 포커스 이동하도록 수정 팝업이 있는 경우 포커스 전달 안하도록
                if(popupState == "" && menuOn == false) {
                    idBtContactSearchListView.forceActiveFocus();
                }
            } else if(prevContentY != contentY) {
                if(endIndex < count - 1) {
                    if(-1 < flickingIndex) {
                        //positionViewAtIndex(flickingIndex, ListView.SnapPosition);  //ListView.Beginning);
                        currentIndex = flickingIndex;
                    }
                } else {
                    /* 리스트 최하단일 경우 Section에 의해 상단으로 끌어올려지는 경우가 발생하기 때문에
                     * 포커스 설정후(currentIndex 설정 후) 화면을 제일 아래로 끌어내림
                     */
                    currentIndex = flickingIndex;
                    positionViewAtEnd();
                }
            } else {
                //Do Nothing
            }

            // onMovementEnded 시점에 포커스 이동하도록 수정 팝업이 있는 경우 포커스 전달 안하도록
            if(popupState == "" && menuOn == false) {
                idBtContactSearchListView.forceActiveFocus();
            }
            cursorNormal();
        }

        onCountChanged: {
            idBtContactSearchListView.currentIndex = 0;
            listCount = idBtContactSearchListView.count;
            idBtContactSearchListView.positionViewAtIndex( 0, ListView.Beginning);
            if(0 == idBtContactSearchListView.count) {
                countZeroresult ++;
            }
        }

        delegate: BtContactSearchDelegate {
            onWheelLeftKeyPressed:  {
                if(false == idBtContactSearchListView.flicking && false == idBtContactSearchListView.moving) {
                    var startIndex = idBtContactSearchListView.getStartIndex(idBtContactSearchListView.contentY);

                    if(index > 0) {
                        if(startIndex == idBtContactSearchListView.currentIndex) {
                            idBtContactSearchListView.positionViewAtIndex(idBtContactSearchListView.currentIndex - 1, ListView.End);
                        }

                        idBtContactSearchListView.decrementCurrentIndex();
                    } else {
                        // 리스트가 하나의 화면에 표시 되면 루핑 되지 않도록 수정(HMC)
                        if(6 < idBtContactSearchListView.count) {
                            idBtContactSearchListView.currentIndex = idBtContactSearchListView.count - 1;
                        } else {
                            //DEPRECATED console.log("### Stop looping idBtContactSearchListView.count = " + idBtContactSearchListView.count)
                        }
                    }
                }
            }
            
            onWheelRightKeyPressed: {
                if(false == idBtContactSearchListView.flicking && false == idBtContactSearchListView.moving) {
                    var endIndex = idBtContactSearchListView.getEndIndex(idBtContactSearchListView.contentY);

                    if(index < idBtContactSearchListView.count - 1) {
                        if(endIndex == idBtContactSearchListView.currentIndex) {
                            idBtContactSearchListView.positionViewAtIndex(idBtContactSearchListView.currentIndex + 1, ListView.Beginning);
                        }

                        idBtContactSearchListView.incrementCurrentIndex();
                    } else {
                        // 리스트가 하나의 화면에 표시 되면 루핑 되지 않도록 수정(HMC)
                        if(6 < idBtContactSearchListView.count) {
                            idBtContactSearchListView.currentIndex = 0;
                        } else {
                            //DEPRECATED console.log("### Stop looping idBtContactSearchListView.count = " + idBtContactSearchListView.count)
                        }
                    }
                }
            }

            Keys.onPressed: {
                /* ListView로 전달되어야 하는 Key Event를 제외한 나머지 Key Event는 accepted = true 해줘야 함
                 * (accepted = true로 설정된 Key Event는 ListView로 전달되지 않음)
                 */
                /*if(Qt.Key_Down == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        idBtContactSearchListView.longPressed = true;

                        if(idBtContactSearchListView.currentIndex < idBtContactSearchListView.count - 1) {
                            // Propagate to ListView
                            idBtContactSearchListView.longPressed = true;
                        } else {
                            // 더이상 밑으로 내려갈 수 없을때
                            event.accepted = true;
                        }
                    } else {
                        // Short pressed
                        event.accepted = true;
                    }
                } else */
                if(Qt.Key_Up == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        // Long-pressed
                        idBtContactSearchListView.longPressed = true;

                        if(0 < idBtContactSearchListView.currentIndex) {
                            // Propagate to ListView
                            idBtContactSearchListView.startUpScroll();
                        } else {
                            // 더이상 위로 올라갈 수 없을때
                            event.accepted = true;
                        }
                    } else {
                        // Short pressed
                        event.accepted = true;
                    }
                } else if(Qt.Key_Down == event.key) {
                    if(Qt.ShiftModifier == event.modifiers) {
                        idBtContactSearchListView.longPressed = true;
                        idBtContactSearchListView.startDownScroll();
                    }

                    keypadUpPressed = false;
                    event.accepted = true;
                }
            }

            Keys.onReleased: {
                idBtContactSearchListView.stopScroll();
                // 키패드 내부 조그 동작 수정 - ISV 조그 동작 동기화 문제점 (Long Key 동작 무시)
                if(true == idBtContactSearchListView.longPressed){
                    idBtContactSearchListView.longPressed = false
                    return;
                }

                if(Qt.Key_Up == event.key) {
                    if(true == keypadUpPressed) {
                        keypadUpPressed = false;
                        event.accepted = true;
                        return;
                    }

                    if(true == idBtContactSearchListView.longPressed) {
                        if(0 < idBtContactSearchListView.currentIndex) {
                            // Propagate to ListView
                        } else {
                            // 더이상 위로 올라갈 수 없을때 Release도 전달되지 않도록 막아야 함
                            idBtContactSearchListView.longPressed = false;
                            event.accepted = true;
                        }
                    } else {
                        idQwertyKeypad.showQwertyKeypad();
                        cursorFocus()
                        event.accepted = true;
                    }
                } else if (Qt.Key_Down == event.key) {
                    keypadUpPressed = false
                    event.accepted = true;
                }
            }
        }

        function startDownScroll() {
            idDownScrollTimer.start();
        }

        function startUpScroll() {
            idUpScrollTimer.start();
        }

        function stopScroll() {
            if(true == idDownScrollTimer.running) {
                idDownScrollTimer.stop();
            } else if(true == idUpScrollTimer.running) {
                idUpScrollTimer.stop();
            }
        }

        function runningScroll() {
            if(true == idDownScrollTimer.running || true == idUpScrollTimer.running) {
                return true;
            } else {
                return false;
            }
        }
    }

    // Scroll
    MComp.MScroll {
        id: idContactSearchListScroll
        x: 1257
        y: 199 - systemInfo.headlineHeight + systemInfo.titleAreaHeight
        height: 476
        width: 14

        // 6개 이상인 경우 스크롤바 표시
        visible: (idBtContactSearchListView.count > 6 && idTextInputSearch.text.length > 0)
        scrollArea: idBtContactSearchListView
    }

    // Keypad
    MComp.QwertyKeypad {
        id: idQwertyKeypad
        //y: 243
        y: -93
        focus: true

        doneType: "Search"
        currentCursor: idTextInputSearch.cursorPosition
        useVocalSound: true
        keypadInput: idTextInputSearch.text

        function cutOff(deviceName) {
            return deviceName.substring(0, 160);
        }

        function checkLength(deviceName) {
            return deviceName.length;
        }

        function update(empty) {
            if(true == empty) {
                idTextInputSearch.color = colorInfo.disableGrey;
                idTextInputSearch.maximumLength = 30;

                // Set default text.
                idTextInputSearch.text = ""
                idTextInputSearchHide.text = ""

                // Set cursor position.
                idTextInputSearch.cursorPosition = 0;
            } else {
                idTextInputSearch.color = colorInfo.buttonGrey;
                idTextInputSearch.maximumLength = 161

                // Set input text.
                idTextInputSearch.text = idQwertyKeypad.outputText;
                idTextInputSearchHide.text = idQwertyKeypad.outputText;

                // Set cursor position.
                if(idQwertyKeypad.currentCursor > idTextInputSearch.text.length) {
                    idQwertyKeypad.currentCursor = idTextInputSearch.text.length;
                }

                idTextInputSearch.cursorPosition = idQwertyKeypad.currentCursor;
                idTextInputSearch.cursorDelegate = idDelegateCursor
                idTextInputSearchHide.cursorPosition = idQwertyKeypad.currentCursor;
                idTextInputSearchHide.hide();
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

        Connections {
            target: idAppMain
            onTextChange : {
                idTextInputSearch.select(idTextInputSearch.cursorPosition - idQwertyKeypad.lastPinYinPosition , idTextInputSearch.cursorPosition);
            }

            onPhonebookModelChanged: {
                /* 전화번호부 항목 변경 */

                if(idAppMain.state === "BtContactSearchMain") {
                    if(1 === countZeroresult && 0 == idBtContactSearchListView.count) {
                        if(false == idTextInputSearch.activeFocus && false == idButtonSearch.activeFocus && false == idButtonBack.activeFocus && true == idQwertyKeypad.isHide()) {
                            if(false == systemPopupOn) {
                                if(false == popupOn) {
                                focusPoint = 0;
                                cursorFocus();
                                idTextInputSearchHide.hide();
                                }
                            } else {
                                focusPoint = 2;
                            }
                        }
                    }
                }
                countZeroresult = 0;
            }
        }

        onChangePINYIN: {
            removeSelect();
            idTextInputSearch.select(idTextInputSearch.cursorPosition - lastPinYinPosition , idTextInputSearch.cursorPosition);
        }

        onOutputTextChanged: {
            if(false == idQwertyKeypad.focus) {
                idQwertyKeypad.forceActiveFocus();
            }

            idTextInputSearchHide.hide();
            idTextInputSearch.cursorDelegate = idDelegateCursor

            // 키패드 입력 되는 시점에 키패드로 먼저 포커스 이동 시킴
            idQwertyKeypad.forceActiveFocus();

            if("PINYIN" == idQwertyKeypad.pinyin && false == idQwertyKeypad.pinyinComplete) {
                if(160 == idTextInputSearch.text.length && 1 == idQwertyKeypad.lastPinYinPosition) {
                    // 160글자에서 추가되는 경우 입력 막음
                    //MOp.showPopup("popup_device_name_limit_length");
                    idQwertyKeypad.outputText = cutOff(idQwertyKeypad.outputText);
                    idQwertyKeypad.clearAutomata();
                } else {
                    if(1 > idQwertyKeypad.outputText.length) {
                        update(true);
                    } else {
                        update(false);

                        // PinYin 입력 중 미완성 글자에 대한 반전효과
                        idTextInputSearch.select(idTextInputSearch.cursorPosition - lastPinYinPosition , idTextInputSearch.cursorPosition);
                    }
                }
            } else {
                if(1 > idQwertyKeypad.outputText.length) {
                    update(true);
                } else if(160 < idQwertyKeypad.outputText.length) {
                    /* Limited characters */
                    //update(false);
                    truncate();
                } else {
                    update(false);
                }
            }

            if("NONE" != idQwertyKeypad.pinyin) {
                // PinYin 입력 중 미완성 글자에 대한 반전효과
                idTextInputSearch.select(idTextInputSearch.cursorPosition - lastPinYinPosition , idTextInputSearch.cursorPosition);
            }

            if("PINYIN" == idQwertyKeypad.pinyin && false == idQwertyKeypad.pinyinComplete) {
                /* 중국어 입력모드일때 중국어 입력이 완성된 시점에 검색함
                 * 영어입력상태(검색X) --> 한자로 변환(검색O)
                 */

            } else if("PINYIN" == idQwertyKeypad.pinyin && true == idQwertyKeypad.pinyinComplete) {
                BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
                idTextInputSearch.cursorPosition = 0
                idTextInputSearch.cursorPosition = idQwertyKeypad.currentCursor
            }

            if(1 > idTextInputSearch.text.length) {
                searchResult = false;
            }

            if("NONE" != idQwertyKeypad.pinyin ) {
                idQwertyKeypad.disableSpaceButton();
            } else {
                if(0 == idTextInputSearch.text.length) {
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
            changeListModel()

            console.log("idQwertyKeypad.pinyin > " + idQwertyKeypad.pinyin)

            if("NONE" != idQwertyKeypad.pinyin ) {
                if("SOUND" == idQwertyKeypad.pinyin) {
                    /* 성음으로 변경 시 항상 초기화 */
                    idTextInputSearch.text = ""
                    idTextInputSearchHide.text = ""
                    idQwertyKeypad.outputText = ""
                }

                idQwertyKeypad.outputText = idTextInputSearch.text
                idTextInputSearchHide.text = idTextInputSearch.text

                if("SOUND" != idQwertyKeypad.pinyin) {
                    /* 성음으로 변경 시 항상 초기화 */
                    idTextInputSearch.cursorPosition = idTextInputSearch.text.length
                    idTextInputSearchHide.cursorPosition = idTextInputSearch.text.length
                    idQwertyKeypad.currentCursor = idTextInputSearch.text.length
                    lastPinYinPosition = 0
                }

                idQwertyKeypad.disableSpaceButton();

                if("" != idQwertyKeypad.pinyin) {
                    if("SOUND" == idQwertyKeypad.pinyin) {
                        BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, true)
                    } else {
                        BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
                    }
                } else {
                    BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
                }
            } else {
                if("SOUND" == beforeKeypad) {
                    idTextInputSearch.text = ""
                    idTextInputSearchHide.text = ""
                    idQwertyKeypad.outputText = ""
                }

                if(0 == idTextInputSearch.text.length) {
                    idQwertyKeypad.disableSpaceButton();
                } else {
                    idQwertyKeypad.enableSpaceButton();
                    BtCoreCtrl.invokeTrackerSearchPhonebook(idTextInputSearch.text, false)
                }
            }

            beforeKeypad = pinyin
        }

        onActiveFocusChanged: {
            if(true == idQwertyKeypad.activeFocus && true == idQwertyKeypad.isHide()) {
                console.log("[QML] QML've been recved signal activeFocusChanged")
                idQwertyKeypad.showQwertyKeypad();
            }
            if(true == idQwertyKeypad.activeFocus){
                focusPoint = 1;
            }
        }

        onSigLostFocus: {
            /* 키패드 내부 키패드 숨김 버튼 선택 시 Release 2번 발생되는 문제점 수정
             */

            console.log("\n\n\n키패드 숨김\n\n\n")

            /* ITS 233259
             * 리스트 결과가 있을 때 리스트 Flicking 동작 시, 키패드가 내려 가지 않는 이슈
             */
            if(true == idBtContactSearchListView.hideByFlicking && 0 < idBtContactSearchListView.count) {
                // hideByFlicking변수 초기화
                idBtContactSearchListView.hideByFlicking = false;
                return;
            }

            gIgnoreReleased = 2;

            if(1 > idBtContactSearchListView.count) {
                if("SOUND" == idQwertyKeypad.pinyin) {
                    cursorFocus()

                    idTextInputSearch.cursorPosition = idQwertyKeypad.currentCursor
                } else {
                    removeSelect()

                    idTextInputSearch.cursorPosition = idQwertyKeypad.currentCursor
                    cursorFocus()
                    keypadUpPressed = true
                }
            } else {
                //keypadUpPressed = true
                //idQwertyKeypad.hideQwertyKeypad();
                /* 키패드에서 검색창으로 포커스 이동 시, 키패드 내려가지 않게 수정
                */

                idTextInputSearchHide.hide();
                idTextInputSearch.cursorDelegate = idDelegateCursor
                //idBtContactSearchListView.currentIndex = 0;
                //idBtContactSearchListView.forceActiveFocus();
                /* 키패드에서 jog up 할 때, 검색창으로 포커스 이동하도록 수정
                  */
                cursorFocus()
                keypadUpPressed = true
            }
        }

        onKeyOKClicked: {
            idQwertyKeypad.hideQwertyKeypad();
            keypadUpPressed = false

            if(1 > idBtContactSearchListView.count) {
                removeSelect()
                cursorFocus()
                idTextInputSearch.cursorPosition = idQwertyKeypad.currentCursor
            } else {
                idTextInputSearchHide.hide();
                idTextInputSearch.cursorDelegate = idDelegateCursor
                idBtContactSearchListView.currentIndex = 0;
                idBtContactSearchListView.forceActiveFocus();
            }
        }

        onKeypadWidghtHide: {
            if(1 > idBtContactSearchListView.count) {
                removeSelect()
                cursorFocus()
                idTextInputSearch.cursorPosition = idQwertyKeypad.currentCursor
                idQwertyKeypad.hideQwertyKeypad();
                keypadUpPressed = false;
            } else {
                idQwertyKeypad.hideQwertyKeypad();
                keypadUpPressed = false;
                idTextInputSearchHide.hide();
                idTextInputSearch.cursorDelegate = idDelegateCursor
                idBtContactSearchListView.currentIndex = 0;
                idBtContactSearchListView.forceActiveFocus();
            }
        }
    }

    /* TIMERS */
    Timer {
        id: idDownScrollTimer
        interval: 80
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var endIndex = idBtContactSearchListView.getEndIndex(idBtContactSearchListView.contentY);

            if(idBtContactSearchListView.currentIndex + 1 < idBtContactSearchListView.count) {
                if(endIndex == idBtContactSearchListView.currentIndex) {
                    idBtContactSearchListView.positionViewAtIndex(idBtContactSearchListView.currentIndex + 1, ListView.Beginning);
                }

                idBtContactSearchListView.currentIndex += 1;
            } else {
                idBtContactSearchListView.currentIndex = idBtContactSearchListView.count - 1;
                stop();
            }
        }
    }

    Timer {
        id: idUpScrollTimer
        interval: 80
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var startIndex = idBtContactSearchListView.getStartIndex(idBtContactSearchListView.contentY);

            if(0 < idBtContactSearchListView.currentIndex - 1) {
                if(startIndex == idBtContactSearchListView.currentIndex) {
                    idBtContactSearchListView.positionViewAtIndex(idBtContactSearchListView.currentIndex - 1, ListView.End);
                }
                idBtContactSearchListView.currentIndex -= 1;
            } else {
                idBtContactSearchListView.currentIndex = 0;
                stop();
            }
        }
    }
}
/* EOF */
