import QtQuick 1.1
import qwertyKeypadUtility 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_QwertyKeypad.js" as QKC

Item{
    id: qwerty_keypad

    /**Public area: Props, signals and interfaces for external usage*/

    /** 중국어 키패드인지를 Signal을 통해 전달.
     ** isChiness = true(중국어 키패드), isChiness = false(중국어 키패드 X)
     ** keypadType = -1(중국어 키패드 아님), keypadType = 0(병음), keypadType = 1(성음), keypadType = 2(필기인식) */
    signal chinessKeypad( bool isChiness, int keypadType )
    signal chineseKeypadChanged( int keypadType )

    signal keyPress( int key, string label )
    signal keyPressAndHold( int key, string label )
    signal keyReleased( int key, string label, bool state )
    signal previewCandidate( int key, string label, bool state )
    signal launchSettingApp()
    signal launchChineseKeypadPopup()

    signal pressedOneShift( bool isPress );
    signal pressedTwoShifts( bool isPress );
    signal resetShiftsPress( bool isPress );
    signal updateButton(string button_text);
    signal resetButtonUI();

    signal enableFirstButton(); //added for CCP Delete LongPress Focus Issue
    signal enableShiftButton(); //added for ITS 252365 Shift Button Focus Issue
    signal enablePageButton(); //added for ITS 252365 Shift Button Focus Issue

    signal hideFocusPinYinButton(); //added for ITS 229920 BT Two Focus issue

    signal hideKeypadWidget(); //added for BT Phone

    signal releaseAtPressAndHold(); //added for Delete Long Press Spec Modify

    signal redrawShiftKeyFontColor(int _index); //added for ITS 244662 Shift Font Color Issue
    // 화면에 중국향지 병음 후보군 ListView가 있는지 판단하는 변수
    property bool isChinesePinyinListView: false
    // ListView에 후보군 항목이 존재하는지 판단하는 변수
    property bool isPinyinCandidate: false
    // 중국향지 키패드(후보군 ListView 외)에 포커스가 존재하는지 판단하는 변수(필기인식 제외)
    property bool isKeypadButtonFocused: true

    signal lostFocus( int arrow, int focusID  );
    property bool focus_visible:   true
    property int focus_id: -1
    property bool is_focusable: true
    property ListModel disableList: ListModel{}

    // App(e-Manual, BT)에서 중국향 키보드 타입을 선택하기 위한 Property
    property int setChineseKeypadType: 0

    property bool isCheckLongBackKey: false //added for CCP Delete LongPress Focus Issue
    property bool isUpdateOnTriggered: false //added for CCP Delete LongPress Focus Issue
    signal keyJogCanceled(); //added for CCP Delete LongPress Focus Issue

    // 각 키보드 타입 (영어, 한글, 중동, 중국, 유럽, 러시아)
    property int nKeypadTypeEn: -1
    property int nKeypadTypeKo: -1
    property int nKeypadTypeAr: -1
    property int nKeypadTypeCh: -1
    property int nKeypadTypeEu: -1
    property int nKeypadTypeRu: -1
    property int nKeypadTypeLa: -1

    // 기본 키보드 타입 Default Type
    property int nKeypadDefaultType: -1
    property int currentKeypadScreenType: QKC.const_QWERTY_KEYPAD_TYPE_NONE

    property bool bPressedBack: false
    property bool bPressedLaunch4: false

    property bool enableChineseHWRInput: true
    property string automataString: ""
    property bool isPrevKorStr : false

    //added for comma Input issue
    function initCommaTimer()
    {
        //translate.printLogMessage("[QwertyKeypad] Init Comma Input Timer ....")
        comma_timer.running = false;
        comma_timer.type = 0;

    }


    //added for ITS 229920 BT Two Focus issue
    function sendHidePiyinButtonFocus()
    {
        console.log("[QML]sendHidePiyinButtonFocus() to BT --------------");
        hideFocusPinYinButton()
    }
    //added for Delete Long Press Spec Modify
    function sendReleaseAtPressAndHold()
    {
        releaseAtPressAndHold()
    }

    function hideFocusOnlyBT()
    {
        console.log("[QML]keypad :hideFocusOnlyBT() ")
        focus_visible = false;

        if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHINA)
        {
            // 병음키보드.
            if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_PINYIN)
            {
                // 현재 중국 키패드 화면이면
                if(screenRepeater.index == 1)
                {

                        screenRepeater.children[screenRepeater.index].item.hideFocus()
                }
            }
        }
    }
    function showFocusOnlyBT()
    {
        console.log("[QML]keypad :showFocusOnlyBT() ")
        focus_visible = true;

        if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHINA)
        {
            // 병음키보드.
            if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_PINYIN)
            {
                // 현재 중국 키패드 화면이면
                if(screenRepeater.index == 1)
                {

                        screenRepeater.children[screenRepeater.index].item.showFocus()
                }
            }
        }
    }
    //added for ITS 229920 BT Two Focus issue

    //added for Delete Long Press Spec Modify
    function deleteLongPressInPinYin()
    {
        screenRepeater.children[screenRepeater.index].item.deleteLongPress();
    }


    /**
      * function initKeypad()
      * 전자메뉴얼의 경우, 부팅 시 Keypad QML을 미리 Load. Keypad QML을 재 진입시 호출(초기화 함수)
      */
    function initKeypad()
    {
        //translate.printLogMessage("[QML][QwertyKeypad]initKeypad")
        sendJogCanceled(); //added for ITS 254283 Jog Press State Remain Issue
        //console.log("[LBG] initKeypad start" + translate.currentTime())
        clearBuffer()
        isCheckLongBackKey = false //added for CCP Delete LongPress Focus Issue

        translate.loadSettings();

        if(setChineseKeypadType>=0 && setChineseKeypadType<=2)
            translate.keypadTypeCh = setChineseKeypadType

        var isLanguageKeyboardChanged = false
        var isDefaultKeyboardChanged = false

        // English Keyboard
        if(nKeypadTypeEn != translate.keypadTypeEn)
        {
            nKeypadTypeEn = translate.keypadTypeEn

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // Korean Keyboard
        if(nKeypadTypeKo != translate.keypadTypeKo)
        {
            nKeypadTypeKo = translate.keypadTypeKo

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_KOREAN)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // Cyrillic Keyboard
        if(nKeypadTypeRu != translate.keypadTypeRu)
        {
            nKeypadTypeRu = translate.keypadTypeRu

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_CYRILLIC)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // Arabic Keyboard
        if(nKeypadTypeAr != translate.keypadTypeAr)
        {
            nKeypadTypeAr = translate.keypadTypeAr

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_MIDDLE_EAST)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // China Keyboard
        if(nKeypadTypeCh != translate.keypadTypeCh)
        {
            nKeypadTypeCh = translate.keypadTypeCh

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_CHINA)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // EU Keyboard
        if(nKeypadTypeEu != translate.keypadTypeEu)
        {
            nKeypadTypeEu = translate.keypadTypeEu

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_EU)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // Default Keyboard
        if(nKeypadDefaultType != translate.keypadDefaultType)
        {
            nKeypadDefaultType = translate.keypadDefaultType

            isLanguageKeyboardChanged = true
            isDefaultKeyboardChanged = true
        }

        if(isLanguageKeyboardChanged)
        {
            // unload source
            for(var i = 0; i< countryModel.get(translate.country).line.count; i++){
                screenRepeater.children[screenRepeater.index].source = "";
            }

            keypadRepeater.model = getKeypadType()

            if( isDefaultKeyboardChanged )
            {
                if(translate.country == QKC.const_QWERTY_COUNTRY_RUSSIA
                        && (translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_EUROPE))
                {
                    screenRepeater.index = 3
                }
                else
                {
                    if( screenRepeater.index == 1)
                    {
                        screenRepeater.children[screenRepeater.index].loadSource()
                    }
                    else
                    {
                        screenRepeater.index = 1
                        // Automatically load Source by IndexChanged-Signal
                    }
                }
            }
            else
                screenRepeater.children[screenRepeater.index].loadSource()

            notifyIsChineseKeypad()
        }
        else
        {
            if(translate.country == QKC.const_QWERTY_COUNTRY_RUSSIA
                    && (translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_EUROPE))
            {
                if(screenRepeater.index == 3)
                {
                    currentFocusIndex = 0
                    screenRepeater.children[screenRepeater.index].item.retranslateUi();
                }
                else
                {
                    screenRepeater.children[screenRepeater.index].visible = false
                    screenRepeater.index = 3
                    screenRepeater.children[screenRepeater.index].visible = true
                }
            }
            else
            {
                if( screenRepeater.index == 1)
                {
                    currentFocusIndex = 0
                    screenRepeater.children[screenRepeater.index].item.retranslateUi();
                }
                else
                {
                    screenRepeater.children[screenRepeater.index].visible = false
                    screenRepeater.index = 1
                    screenRepeater.children[screenRepeater.index].visible = true
                }
            }
        }

        resetButtonUI()
        enableJogController()
        //console.log("[LBG] initKeypad end" + translate.currentTime())
    }

    //added for ITS 229467 for BT Keypad HWR Engine Init Issue
    function initBTHWREngine()
    {
        console.log("[QML]initBTHWREngine :: initialize HWR Engine for BT ->")

        // 기본 키패드 (설정 내) : 중국 키패드
        if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHINA)
        {
            console.log("[QML]initBTHWREngine ::  translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHIN")
            // 병음키보드이거나, 성음키보드이지만 블루투스 폰북화면이 아닐 경우.
            if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_PINYIN ||
                    (translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_CONSONANT && !isReceivedUsePhoneBookDB ) )
            {
                // 현재 중국 키패드 화면이면

            }
            else if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_HWR)
            {
                console.log("[QML]initBTHWREngine ::  translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_HWR")
                // 현재 중국 키패드 화면이면
                if(screenRepeater.index == 1)
                {
                    console.log("[QML]initBTHWREngine ::  screenRepeater.index == 1")
                    screenRepeater.children[screenRepeater.index].item.initHWREngineForBT();
                }
            }
        }
    }

    /**
      * function sendJogCanceled()
      * Jog-Pressed상태에서 주행규제 되었을 때, 버튼의 이미지가 Release되지 않는 문제 수정 (DRS On -> Off되었을 때, 한번 호출)
      */
    function sendJogCanceled()
    {
        //translate.printLogMessage("[QML][QwertyKeypad]sendJogCanceled")
        isReceivedJogCanceled = true
        screenRepeater.children[screenRepeater.index].item.isFocusedBtnSelected = false
        screenRepeater.children[screenRepeater.index].item.isFocusedBtnLongPressed = false;
    }

    /**
      * function showQwertyKeypad()
      * 키보드가 hide 상태일 때, 해당 함수 호출하면 show.
      */
    function showQwertyKeypad()
    {
        /** 중국향 성음 키보드(폰북검색)화면에서 입력 중, 키보드가 hide & show 하였을 때 비활성화 버튼이 초기화 되는 이유로
          * update() 호출하지 않음(주석처리) 설정에서 키보드 타입이 변경되면, 어플리케이션에서 해당함수 호출하므로 불필요.
          */
        // update();

        isHide = false;
        showAni.running = true
    }

    /**
      * function hideQwertyKeypad()
      * 키보드가 show 상태일 때, 해당 함수 호출하면 hide. (hide버튼 클릭 시)
      */
    function hideQwertyKeypad()
    {
        isHide = true;
        hideAni.running = true
    }

    //added for ITS 257323 Default Keypad UI Issue
    function defaultKeyboardPage()
    {
        screenRepeater.children[screenRepeater.index].visible = 0;
        screenRepeater.index = 1;
        screenRepeater.children[screenRepeater.index].visible = 1;
        resetButtonUI()
    }

    /**
      * hideFocus() / showFocus()사용하지 않음.
      * focus_visible가 true가 되는 조건을 App에서 설정.
      */
    function hideFocus() {}

    function showFocus() {
        focus_visible = true
    }

    function setDefaultFocus(arrow)
    {
        currentFocusIndex = screenRepeater.children[screenRepeater.index].item.getDefaultFocusIndex()
        return focus_id;
    }

    /**
      * function enableJogController()
      * 중국향 키보드의 경우 병음 후보군 리스트 뷰가 존재하기 때문에, 포커스 이동하는 경우가 리스트뷰 <-> 키보드 자판으로 2가지가 존재함.
      * 키보드 자판에서 포커스가 사라질 경우 현 QML의 JogController을 막도록 설정되어 있음(중국향 키보드 화면에서 Binding)
      * 초기 중국향 키보드가 기본 키보드인 상태에서 부팅하면, 전자메뉴얼의 경우 QML을 미리 Load하고, Binding에 의해 JogController이 잠김.
      * 설정에서 한글키보드로 변경하고 전자메뉴얼 진입 시, JogController이 잠김상태가 풀리지 않아 Jog 무감 현상이 발생.
      * 화면별로 해당 Property 변경하지 않고 아래와 같이 함수 호출하도록 적용.
      */
    function enableJogController()
    {
        if(!isKeypadButtonFocused)
        {
            if(translate.keypadDefaultType != QKC.const_DEFAULT_KEYPAD_CHINA)
                isKeypadButtonFocused = true
        }
    }

    function handleJogEvent(arrow, status) {}

    /**
      * Jog 동작에 의한 Focus 이동시 호출
      */
    function __handleJogEvent(arrow, status)
    {
        //translate.printLogMessage("[QML][QwertyKeypad]__handleJogEvent : " + status)
        if(status == UIListenerEnum.KEY_STATUS_PRESSED)
        {
            prevFocusIndex = currentFocusIndex
            switch(arrow)
            {
            case UIListenerEnum.JOG_UP: //Up
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_UP // currentFocusIndex 변경됨

                if(prevFocusIndex == currentFocusIndex) // top buttons[ex. q,w,e,r,t,y,u,i,o,p] or 상위 버튼들이 모두 disabled 버튼일 경우(성음)
                {
                    // 화면에 병음 ListView가 존재하는지 && ListView에 후보군 Item이 존재하는지 (병음, 성음)
                    if(isChinesePinyinListView && isPinyinCandidate)
                        moveFocusToPinyinListView(arrow, QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_UP)
                    else
                        lostFocus( arrow, focus_id )
                }

                break;
            }
            case UIListenerEnum.JOG_TOP_RIGHT: //Right Up
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_UP_RIGHT

                if(prevFocusIndex == currentFocusIndex)
                {
                    if(isChinesePinyinListView && isPinyinCandidate)
                        moveFocusToPinyinListView(arrow, QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_UP_RIGHT)
                }

                break;
            }
            case UIListenerEnum.JOG_RIGHT: //Right
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_RIGHT
                break
            }
            case UIListenerEnum.JOG_BOTTOM_RIGHT: //Right Down
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_DOWN_RIGHT
                break
            }
            case UIListenerEnum.JOG_DOWN: //Down
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_DOWN
                break
            }
            case UIListenerEnum.JOG_BOTTOM_LEFT: //Left Down
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_DOWN_LEFT
                break
            }
            case UIListenerEnum.JOG_LEFT: //Left
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_LEFT
                break
            }
            case UIListenerEnum.JOG_TOP_LEFT: //Left up
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_UP_LEFT

                if(prevFocusIndex == currentFocusIndex)
                {
                    if(isChinesePinyinListView && isPinyinCandidate)
                        moveFocusToPinyinListView(arrow, QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_UP_LEFT)
                }
                break
            }
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_WHEEL_RIGHT
                break;
            }
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                screenRepeater.children[screenRepeater.index].item.transitDirection = QKC.const_QWERTY_KEYPAD_TRANSIT_DIRECTION_WHEEL_LEFT
                break;
            }
            default:
            {
                return;
            }
            }

            screenRepeater.children[screenRepeater.index].item.transitDirection = -1
        }
        //added for ITS 244662 Shift Font Color Issue
        if(status == UIListenerEnum.KEY_STATUS_CANCELED)
        {
            //translate.printLogMessage("[QML][QwertyKeypad]__handleJogEvent::emit SIGNAL : " + status)
            redrawShiftKeyFontColor(currentFocusIndex); //added for ITS 244662
        }
        //added for ITS 244662 Shift Font Color Issue
    }

    /**
      * function moveFocusToPinyinListView(arrow, nTransitDirection)
      * 중국향 병음 리스트 뷰 화면으로 포커스 이동할 경우 사용.
      */
    function moveFocusToPinyinListView(arrow, nTransitDirection)
    {
        if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_PINYIN)
        {
            screenRepeater.children[screenRepeater.index].item.setFocus(arrow, currentFocusIndex)
        }
        else if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_CONSONANT
                && !isReceivedUsePhoneBookDB)
        {
            var nextItemIndex = screenRepeater.children[screenRepeater.index].item.getNextItemIndex(currentFocusIndex, nTransitDirection)
            var topItemIndex = screenRepeater.children[screenRepeater.index].item.getIndexOfNextDirection(nextItemIndex, nTransitDirection)

            screenRepeater.children[screenRepeater.index].item.setFocus(arrow, topItemIndex)
        }
    }

    /**
      * function update()
      * 1. UIListener로부터 fgReceived Signal을 받았을 경우 호출 (설정 버튼을 통해 설정 진입이후 재 진입시)
      * 2. 각 App에서 설정으로부터 키보드 변경 이벤트를 받았을 경우 호출
      */
    function update()
    {
        updateTimer.restart()

        //console.log("update end" + translate.currentTime())
    }

    function updateOnTriggerd ()
    {
        //console.log("update start" + translate.currentTime())
        //translate.printLogMessage("updateOnTriggerd()");
        isUpdateOnTriggered = true //added for CCP Delete LongPress Focus Issue
        isCheckLongBackKey = false //added for CCP Delete LongPress Focus Issue

        translate.clearAutomata()
        translate.loadSettings();

        if(setChineseKeypadType>=0 && setChineseKeypadType<=2)
            translate.keypadTypeCh = setChineseKeypadType

        var isLanguageKeyboardChanged = false
        var isDefaultKeyboardChanged = false

        // English Keyboard
        if(nKeypadTypeEn != translate.keypadTypeEn)
        {
            nKeypadTypeEn = translate.keypadTypeEn

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_ENGLISH)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // Korean Keyboard
        if(nKeypadTypeKo != translate.keypadTypeKo)
        {
            nKeypadTypeKo = translate.keypadTypeKo

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_KOREAN)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // Cyrillic Keyboard
        if(nKeypadTypeRu != translate.keypadTypeRu)
        {
            nKeypadTypeRu = translate.keypadTypeRu

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_CYRILLIC)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // Arabic Keyboard
        if(nKeypadTypeAr != translate.keypadTypeAr)
        {
            nKeypadTypeAr = translate.keypadTypeAr

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_MIDDLE_EAST)
            {
                if(arabicExtendedMode == 0)
                    isLanguageKeyboardChanged = true
            }
        }

        // China Keyboard
        if(nKeypadTypeCh != translate.keypadTypeCh)
        {
            nKeypadTypeCh = translate.keypadTypeCh

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_CHINA)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // EU Keyboard
        if(nKeypadTypeEu != translate.keypadTypeEu)
        {
            nKeypadTypeEu = translate.keypadTypeEu

            if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_EU)
            {
                isLanguageKeyboardChanged = true
            }
        }

        // Default Keyboard
        if(nKeypadDefaultType != translate.keypadDefaultType)
        {
            nKeypadDefaultType = translate.keypadDefaultType

            isLanguageKeyboardChanged = true
            isDefaultKeyboardChanged = true
        }

        if(isLanguageKeyboardChanged)
        {
            // unload source
            for(var i = 0; i< countryModel.get(translate.country).line.count; i++){
                screenRepeater.children[screenRepeater.index].source = "";
            }

            keypadRepeater.model = getKeypadType()

            if( isDefaultKeyboardChanged )
            {
                if(translate.country == QKC.const_QWERTY_COUNTRY_RUSSIA
                        && (translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_EUROPE))
                {
                    screenRepeater.index = 3
                }
                else
                {
                    if( screenRepeater.index == 1)
                    {
                        screenRepeater.children[screenRepeater.index].loadSource()
                    }
                    else
                    {
                        screenRepeater.index = 1
                        // Automatically load Source by IndexChanged-Signal
                    }
                }
            }
            else
                screenRepeater.children[screenRepeater.index].loadSource()

            notifyIsChineseKeypad()
        }

        enableJogController()
    }

    /**
      * function searchChinesePrediction(inputWord)
      * 각 App으로부터 현재 입력되어 있는 문자열을 받아 다음에 올 수 있는 글자 후보군을 검색함 (중국향 병음/필기인식)
      */
    function searchChinesePrediction(inputWord)
    {
        // 기본 키패드 (설정 내) : 중국 키패드
        if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHINA)
        {
            // 병음키보드이거나, 성음키보드이지만 블루투스 폰북화면이 아닐 경우.
            if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_PINYIN ||
                    (translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_CONSONANT && !isReceivedUsePhoneBookDB ) )
            {
                // 현재 중국 키패드 화면이면
                if(screenRepeater.index == 1)
                {
                    if(inputWord == "")
                    {
                        clearState()
                        return
                    }

                    screenRepeater.children[screenRepeater.index].item.searchChinesePrediction(inputWord);
                }
            }
            else if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_HWR)
            {
                // 현재 중국 키패드 화면이면
                if(screenRepeater.index == 1)
                {
                    screenRepeater.children[screenRepeater.index].item.searchChinesePrediction(inputWord);
                }
            }
        }
    }

    function searchChinesePinyin(inputWord)
    {
        if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHINA)
        {
            // 병음키보드.
            if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_PINYIN)
            {
                // 현재 중국 키패드 화면이면
                if(screenRepeater.index == 1)
                {
                    if(inputWord == "")
                        return
                    else
                        screenRepeater.children[screenRepeater.index].item.searchChinesePinyin(inputWord);
                }
            }
        }
    }

    /**
      * clearState() / clearBuffer()
      * 동일한 내용의 함수이나, 각 App에서 둘다 사용되는 경우가 있음.
      * 오토마타 초기화 및 중국향의 경우 입력되어 있는 글자 초기화
      *
      */
    function clearState()
    {
        //translate.printLogMessage("[QML] keypad::clearState ->")
        isCheckLongBackKey = false //added for CCP Delete LongPress Focus Issue
        //translate.clearAutomata()

        // 중국향지
        if(translate.country == QKC.const_QWERTY_COUNTRY_CHINA)
        {
            // 기본 키패드 (설정 내) : 중국 키패드
            if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHINA)
            {
                // 현재 화면 : 중국 키패드
                if(screenRepeater.index == 1)
                {
                    //added for ITS 227055 Hide focus issue when focus is in ' button
                    if(currentFocusIndex == 19 && screenRepeater.children[screenRepeater.index].item.getIsCurrentItemEnabled())
                    {
                        //console.log("[QML] Clear Current Focus Index ----")
                        currentFocusIndex = 0;
                    }
                    //added for ITS 227055 Hide focus issue when focus is in ' button
                    screenRepeater.children[screenRepeater.index].item.clearBuffer();

                }
                //added for ITS 230155 Hide focus issue in HWR Jog down
                if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_HWR)
                {
                    if(screenRepeater.index == 1)
                    {
                        console.log("[QML]keypad:: HWR:: getIsCurrentItemEnabled() :  " + screenRepeater.children[screenRepeater.index].item.getIsCurrentItemEnabled())
                        if(!screenRepeater.children[screenRepeater.index].item.getIsCurrentItemEnabled())
                        {
                            currentFocusIndex = screenRepeater.children[screenRepeater.index].item.getDefaultFocusIndex()
                        }

                    }
                }
                //added for ITS 230155 Hide focus issue in HWR Jog down
            }
        }
    }

    function clearBuffer()
    {
        //translate.clearAutomata()
        //translate.printLogMessage("[QML] keypad::clearBuffer ->")

        isCheckLongBackKey = false //added for CCP Delete LongPress Focus Issue
        // 중국향지
        if(translate.country == QKC.const_QWERTY_COUNTRY_CHINA)
        {
            // 기본 키패드 (설정 내) : 중국 키패드
            if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHINA)
            {
                // 현재 화면 : 중국 키패드
                if(screenRepeater.index == 1)
                {
                    //added for ITS 227055 Hide focus issue when focus is in ' button
                    if(currentFocusIndex == 19 && screenRepeater.children[screenRepeater.index].item.getIsCurrentItemEnabled())
                    {
                        //console.log("[QML] Clear Current Focus Index ----")
                        currentFocusIndex = 0;
                    }
                    //added for ITS 227055 Hide focus issue when focus is in ' button
                    screenRepeater.children[screenRepeater.index].item.clearBuffer();

                }
                //added for ITS 230155 Hide focus issue in HWR Jog down
                if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_HWR)
                {
                    if(screenRepeater.index == 1)
                    {
                        console.log("[QML]keypad:: HWR:: getIsCurrentItemEnabled() :  " + screenRepeater.children[screenRepeater.index].item.getIsCurrentItemEnabled())
                        if(!screenRepeater.children[screenRepeater.index].item.getIsCurrentItemEnabled())
                        {
                            currentFocusIndex = screenRepeater.children[screenRepeater.index].item.getDefaultFocusIndex()
                        }

                    }
                }
                //added for ITS 230155 Hide focus issue in HWR Jog down
            }
        }
    }

    /**
      * BT의 폰북 검색화면에서 사용되는 데이터베이스 파일 등록을 위해 사용.
      * 성음 키보드일 경우 하단의 값을 참조하여 폰북 화면 표시.
      */
    function setVocalSoundDB(isVocalSoundDB, vocalSoundDBPath)
    {
        phoneBookDBPath = vocalSoundDBPath
        isReceivedUsePhoneBookDB = isVocalSoundDB
    }

    function shiftProcessing()
    {
        //translate.printLogMessage("[QML][QwertyKeypad]shiftProcessing")
        if ( isDoubleShift )
        {
            isDoubleShift= false;
            isShift = false;
            resetShiftsPress(true);
        }
        else if ( isShift )
        {
            isDoubleShift = true;
            pressedTwoShifts(true);
        }
        else
        {
            isShift = true;
            pressedOneShift(true);
        }
    }

    function numberToggleProcessing()
    {
        if (isNumber2Mode)
            isNumber2Mode = false;
        else
            isNumber2Mode = true;
    }

    /**
      * 사용하지 않음. 확인 후 지울 것.
      */
    function latinExtendedToggleProcessing()
    {
        if ( latinExtendedMode == 0)
            latinExtendedMode = 1;
        else if ( latinExtendedMode == 1)
            latinExtendedMode = 2;
        else
            latinExtendedMode = 0;
    }

    /**
      * function arabicExtendedToggleProcessing()
      * 아랍어 키보드화면 <-> 아랍어 특수기호 화면으로 변경하기 위한 용도로 사용
      */
    function arabicExtendedToggleProcessing()
    {
        if ( arabicExtendedMode == 0)
        {
            arabicExtendedMode = 1;

            if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_ARABIC)
            {
                if(getCurrentKeypadScreenType() == QKC.const_QWERTY_KEYPAD_TYPE_MIDDLE_EAST)
                {
                    screenRepeater.children[screenRepeater.index].visible = false
                    screenRepeater.index = 4;
                    screenRepeater.children[screenRepeater.index].visible = true
                }
            }
        }
        else
        {
            arabicExtendedMode = 0;

            if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_ARABIC)
            {
                screenRepeater.children[screenRepeater.index].visible = false
                screenRepeater.index = 1;
                screenRepeater.children[screenRepeater.index].visible = true
            }
        }
    }

    function defaultKey()
    {
        //translate.printLogMessage("[QML][QwertyKeypad]defaultKey")
        comma_timer.running = false;
        comma_timer.type = 0;

        if ( isShift && !isDoubleShift )
        {
            isShift = false;
            resetShiftsPress(true);
            screenRepeater.children[screenRepeater.index].item.retranslateUi();
        }
    }

    /**
      * function checkDuplication(target)
      * 버튼 비활성화를 위한 리스트 항목 내 중복체크 함수
      */
    function checkDuplication(target)
    {
        var isCheck = -1
        if( disableList.count > 0 )
        {
            for(var i=0; i < disableList.count; i++)
            {
                if(disableList.get(i).keytext == target)
                    isCheck = i
            }
        }
        return isCheck
    }

    /**
      * function parseKeycode(strKeyCode)
      * 버튼 비활성화를 위해 받은 문자열을 실제 문자열 코드로 변환
      */
    function parseKeycode(strKeyCode)
    {
        if(strKeyCode == "hide")
            return Qt.Key_Launch0;      // Qt::Key_Launch0; // Show/Hide Button
        else if(strKeyCode == ".-@")
            return Qt.Key_Launch4;      // .-@ Button
        else if(strKeyCode == "space")
            return Qt.Key_Space;        // Space Button
        else if(strKeyCode == "done")
            return Qt.Key_Home;         // Completed Button
        else if(strKeyCode == "delete")
            return Qt.Key_Back
        else
            return -1;
    }

    /**
      * function setUpperCase(isFirstCharacter)
      * 사용하지 않음.
      */
    function setUpperCase(isFirstCharacter)
    {
        if(isFirstCharacter < 0 || isFirstCharacter > 2)
            return;

        isShift = isFirstCharacter

        if(isShift)
            pressedOneShift(true);
        else
            resetShiftsPress(true)

        screenRepeater.children[screenRepeater.index].item.retranslateUi()
    }

    /**
      * function setDisableButton(disableString)
      * Application으로부터 문자열 값을 받아 해당 버튼 비활성화
      */
    function setDisableButton(disableString)
    {
        
        //translate.printLogMessage("setDisableButton.")

        if(disableString.length == 0)
            return;

        var nKeycode = -1;
        var splitArray = [""]

        splitArray = String(disableString).split(' ')

        if(splitArray.length > 0)
        {
            for(var i=0; i < splitArray.length; i++)
            {
                if(splitArray[i].length > 2)    // Special characters (keytype:1) : (ex. Qt.Key_Home, Qt.Key_launch0...)
                {
                    nKeycode = parseKeycode(splitArray[i])

                    if(checkDuplication(nKeycode) == -1)
                    {
                        if(nKeycode != -1)
                        {
                            disableList.append({"keytype":1 , "keytext":nKeycode})

                            if(screenRepeater.children[screenRepeater.index] != null)
                                screenRepeater.children[screenRepeater.index].item.disableButton(nKeycode);

                            if(nKeycode == Qt.Key_Back)
                            {
                                // Only Pressed Back-Key
                                if(bPressedBack)
                                {
                                    //added for Delete Long Press Remain Focus Issue
                                    if(screenRepeater.children[screenRepeater.index] != null)
                                    {
                                        //translate.printLogMessage("[Keypad]setDisableButton : " + screenRepeater.index)
                                        screenRepeater.children[screenRepeater.index].item.isLongPressed = false;
                                    }
                                    //translate.printLogMessage("setDisableButton: key_back")
                                    currentFocusIndex = 0
                                    prevFocusIndex = 0 //added for Delete Long Press Remain Focus Issue
                                    isCheckLongBackKey = true //added for CCP Delete LongPress Focus Issue
                                    bPressedBack = false

                                    enableFirstButton(); //added for CCP Delete LongPress Focus Issue
                                    bPressedLaunch4 = false //added for ITS254646 .-@ input -> Delete All Long Press Not Up String Issue
                                }

                                if(!bPressedLaunch4)
                                {
                                    //modify for ITS 248542 shift Lock Issue
                                    if(!isDoubleShift)
                                    {
                                        isShift = true
                                        pressedOneShift(true);

                                        if(screenRepeater.children[screenRepeater.index] != null)
                                            screenRepeater.children[screenRepeater.index].item.retranslateUi()
                                    }
                                    //modify for ITS 248542 shift Lock Issue
                                }
                            }
                        }
                    }
                }
                else                            // General characters (keytype:0)
                {
                    if(splitArray[i].length != 0)
                    {
                        if(checkDuplication(splitArray[i]) == -1)
                        {
                            disableList.append({"keytype":0 , "keytext":splitArray[i]})
                            screenRepeater.children[screenRepeater.index].item.disableButton(splitArray[i]);
                        }
                    }
                }
            }
        }

        //console.log("[LBG] setDisableButton end" + translate.currentTime())
    }

    /**
      * function setEnableButton(enableString)
      * Application으로부터 문자열 값을 받아 해당 버튼 활성화
      */
    function setEnableButton(enableString)
    {
        //console.log("[LBG] setEnableButton start" + translate.currentTime())

        if(enableString.length == 0)
            return;

        var nKeycode = -1;
        var splitArray = [""]
        var ncheckDuplication = -1

        splitArray = String(enableString).split(' ')

        if(splitArray.length > 0)
        {
            for(var i=0; i < splitArray.length; i++)
            {
                if(splitArray[i].length > 2)    // Special characters (keytype:1) : (ex. Qt.Key_Home, Qt.Key_launch0...)
                {
                    nKeycode = parseKeycode(splitArray[i])
                    ncheckDuplication = checkDuplication(nKeycode)  // return char-index in List
                    if(ncheckDuplication != -1)
                    {
                        disableList.remove(ncheckDuplication)
                        screenRepeater.children[screenRepeater.index].item.enableButton(nKeycode);

                        if(nKeycode == Qt.Key_Back)
                        {
                            if(!isDoubleShift)
                            {
                                isShift = false
                                resetShiftsPress(true);
                                screenRepeater.children[screenRepeater.index].item.retranslateUi()
                            }
                        }
                    }
                }
                else                            // General characters (keytype:0)
                {
                    if(splitArray[i].length !=0)
                    {
                        ncheckDuplication = checkDuplication(splitArray[i])
                        if(ncheckDuplication != -1)
                        {
                            disableList.remove(ncheckDuplication)
                            screenRepeater.children[screenRepeater.index].item.enableButton(splitArray[i]);
                        }
                    }
                }
            }
        }
        //console.log("[LBG] setEnableButton end" + translate.currentTime())
    }

    function processNewSentence(onkey)
    {
        var ccn = (onkey ? 1 : 0);
        if(translate.isFirstCapital && !isDoubleShift)
        {
            if(searchString.length <= ccn ||
                    (searchString.length >(1 + ccn) && searchString.charCodeAt(searchString.length-1-ccn) == Qt.Key_Space &&
                     (searchString.charCodeAt(searchString.length - 2 - ccn) == Qt.Key_Period ||
                      searchString.charCodeAt(searchString.length - 2 - ccn) == Qt.Key_Question ||
                      searchString.charCodeAt(searchString.length - 2 - ccn) == Qt.Key_Exclam)))
            {
                isShift = true;
                pressedOneShift(true);
                screenRepeater.children[screenRepeater.index].item.retranslateUi();
                return true;
            }
            else if(searchString.length > ccn &&
                    (searchString.charCodeAt(searchString.length - 1 - ccn) == Qt.Key_Period ||
                     searchString.charCodeAt(searchString.length - 1 - ccn) == Qt.Key_Question ||
                     searchString.charCodeAt(searchString.length - 1 - ccn) == Qt.Key_Exclam))
            {
                newSentence = true;
                defaultKey();
                return true;
            }
        }
        return false;
    }

    function updateShiftButton()
    {
        //translate.printLogMessage("[QML][QwertyKeypad]updateShiftButton")
        if(isDoubleShift)
            pressedTwoShifts(true);
        else if(isShift)
            pressedOneShift(true);
        else
            resetShiftsPress(true);
    }

    /**Private area*/
    y:  0

    width:  1280
    height:  720

    Image{
        y : 320
        source: "/app/share/images/Qwertykeypad/bg_keypad.png"
    }

    property bool isSwitch:      false
    property bool isHide:        false
    property bool newSentence:   true
    property bool isShift:       false
    property bool isDoubleShift: false
    property bool isNumber2Mode: false
    property int latinExtendedMode: 0
    property int arabicExtendedMode: 0
    property int cyrillicExtendedMode: 0
    property int currentScreenIndex: -1

    property string searchString: ""         //read only!

    // App (e-Manual, BT)에서 하단 Property변경을 통해 완료버튼의 이미지를 변경 (엔터, 돋보기)
    property string doneButtonType: "Done" //Default:Done. (Done, Search)

    property int remYPos
    property variant comma: [".", "-", "@"]

    // Focus Index Property
    property int currentFocusIndex: 0
    property int prevFocusIndex:  0

    property bool isReceivedJogCanceled: false

    property int countryVariant: UIListener.GetCountryVariantFromQML()
    property int chineseKeypadType: 0

    // BT's vocal_sound 데이터베이스 사용여부 변수
    property bool isReceivedUsePhoneBookDB: false
    // BT's vocal_sound 데이터베이스 파일경로 변수
    property string phoneBookDBPath: ""

    DHAVN_QwertyKeypad_CountryModel{ id: countryModel }

    QwertyKeypadUtility{
        id: translate
        country : countryVariant

        onSavedNewChineseKeypadType:
        {
            if (translate.country == QKC.const_QWERTY_COUNTRY_CHINA)
                update()
        }

        onLanguageTypeChanged:
        {
            if(isChanged)
                updateButton("")
        }

        Component.onCompleted: {
            nKeypadTypeEn = translate.keypadTypeEn
            nKeypadTypeKo = translate.keypadTypeKo
            nKeypadTypeRu = translate.keypadTypeRu
            nKeypadTypeAr = translate.keypadTypeAr
            nKeypadTypeCh = translate.keypadTypeCh
            nKeypadTypeEu = translate.keypadTypeEu
            nKeypadDefaultType = translate.keypadDefaultType

            isShift = translate.isFirstCapital;
            processNewSentence(false);
        }
    }

    function getCurrentKeypadScreenType()
    {
        if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_KOREAN)
        {
            currentKeypadScreenType = countryModel.get(QKC.const_DEFAULT_KEYPAD_KOREAN).line.get(screenRepeater.index).type
            return currentKeypadScreenType
        }
        else
        {
            currentKeypadScreenType = countryModel.get(translate.country).line.get(screenRepeater.index).type
            return currentKeypadScreenType
        }
    }

    function getChineseType()
    {
        return translate.keypadTypeCh;
    }

    function getKeypadType()
    {
        if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_KOREAN)
            return countryModel.get(translate.keypadDefaultType).line
        else
        {
            if(translate.country != QKC.const_QWERTY_COUNTRY_CHINA)
                return countryModel.get(translate.country).line
            else
                return countryModel.get(getChineseCountryModel()).line
        }
    }

    function getChineseCountryModel()
    {
        chineseKeypadType = getChineseType();

        if(chineseKeypadType == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_PINYIN)
        {
            return QKC.const_QWERTY_CHINESE_KEYPAD_PINYIN_COUNTRY_MODEL;
        }
        else if(chineseKeypadType == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_CONSONANT)
        {
            if(isReceivedUsePhoneBookDB)
                return QKC.const_QWERTY_CHINESE_KEYPAD_CONSONANT_PHONEBOOK_COUNTRY_MODEL;
            else
            {
                return QKC.const_QWERTY_CHINESE_KEYPAD_CONSONANT_COUNTRY_MODEL;
            }
        }
        else if(chineseKeypadType == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_HWR)
        {
            return QKC.const_QWERTY_CHINESE_KEYPAD_HWR_COUNTRY_MODEL;
        }
        else
        {
            return QKC.const_QWERTY_CHINESE_KEYPAD_PINYIN_COUNTRY_MODEL;
        }
    }

    // Notify (현재 키패드가 중국 키패드인지)
    function notifyIsChineseKeypad()
    {
        if(translate.country == QKC.const_QWERTY_COUNTRY_CHINA) // 향지(중국)
        {
            if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHINA) // 기본키보드(중국키보드)
            {
                if(screenRepeater.index == 1)
                    qwerty_keypad.chinessKeypad(true, translate.keypadTypeCh)
                else
                    qwerty_keypad.chinessKeypad(false, QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_NONE)
            }
            else // 기본키보드(내수)
            {
                qwerty_keypad.chinessKeypad(false, QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_NONE)
            }
        }
        else
        {
            qwerty_keypad.chinessKeypad(false, QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_NONE)
        }
    }

    Item {
        id : screenRepeater
        property int index : -1
        property int prevIndex : 0

        Repeater {
            id: keypadRepeater
            model: getKeypadType()
            Loader{
                id: screenLoader
                signal loadSource();

                Connections{
                    target: screenLoader.item
                    onKeyPress:
                    {
                        //translate.printLogMessage("[QML][QwertyKeypad]onKeyPress")
                        if(keycode_s < 0xFF || keycode_s == Qt.Key_Back || keycode_s == Qt.Key_Return || keycode_s == Qt.Key_Home)
                            qwerty_keypad.keyPress( keycode_s, keytext_s )
                    }
                    onKeyPressAndHold:
                    {
                        //translate.printLogMessage("[QML][QwertyKeypad]onKeyPressAndHold")
                        //console.log("[QML] keyPressAndHold: " + status)
                        var sKeytext = keytext_s
                        if( Qt.Key_Back == keycode_s )
                        {
                            sKeytext = ""
                            bPressedBack = true
                            translate.clearAutomata()
                        }
                        else
                            bPressedBack = false

                        if(keycode_s < 0xFF || keycode_s == Qt.Key_Back || keycode_s == Qt.Key_Return || keycode_s == Qt.Key_Home)
                        {
                          qwerty_keypad.keyPressAndHold(keycode_s, sKeytext)
                          //console.log("[QML] keyPressAndHold::send KeyPressAndHoldSignal ----")
                          //added for Delete Long Press Spec Modify
                          //currentFocusIndex = item.getDefaultFocusIndex() //added(modify) for ITS 223743 for < > Focus issue
                        }
                        if(keycode_s == Qt.Key_Back )
                        {
                            //added for Delete Long Press Spec Modify
                            //currentFocusIndex = item.getDefaultFocusIndex() //added(modify) for ITS 223743 for < > Focus issue
                        }



                    }
                    onKeyReleased:{
                        //translate.printLogMessage("[QML][QwertyKeypad]onKeyReleased")
                        screenRepeater.onKeyRelease(keycode_s, keytext_s, keystate_s);
                    }
                }
                onLoadSource:{
                    if( status != Loader.Ready )
                        source = url
                    processNewSentence(false);
                    item.retranslateUi();
                    currentFocusIndex = item.getDefaultFocusIndex()
                    item.y = qwerty_keypad.height - item.height
                }
            }
        }
        onIndexChanged:
        {
            currentScreenIndex = screenRepeater.index

            children[index].loadSource()
            notifyIsChineseKeypad()
        }

        function onKeyRelease(keycode, keytext, keystate){
            console.debug("[QML] onKeyRelease(keyCode) : "+ keycode)
            console.debug("[QML] onKeyRelease(keytext) : "+ keytext)
            //translate.printLogMessage("onKeyRelease(keyCode) : " + keycode)
            //translate.printLogMessage("onKeyRelease(keytext) : " + keytext)
            var sKeytext = keytext

            if(keycode != Qt.Key_Back)
                bPressedBack = false

            if(keycode != Qt.Key_Launch4)
                bPressedLaunch4 = false

            switch ( keycode )
            {
            case Qt.Key_CapsLock:   // ??
            {
                isSwitch = !isSwitch;
                break;
            }
            case Qt.Key_Control:
            {
                screenRepeater.children[screenRepeater.index].item.retranslateUi();
                break;
            }
            case Qt.Key_Launch0:    // hide keyboard
            {
                hideQwertyKeypad();
                qwerty_keypad.hideKeypadWidget() //added for BT Phone
                break;
            }
            case Qt.Key_Shift:
            {
                shiftProcessing();
                screenRepeater.children[screenRepeater.index].item.retranslateUi();
                break;
            }
            case Qt.Key_Launch1:    // numberic language-keyboard
            {
                screenRepeater.children[index].visible = 0;
                index = 0;
                screenRepeater.children[index].visible = 1;
                break;
            }
            case Qt.Key_Launch2:    // second language-keyboard
            {
                screenRepeater.children[index].visible = 0;
                index = 1;
                screenRepeater.children[index].visible = 1;
                break;
            }
            case Qt.Key_Launch3:    // third language-keyboard
            {
                screenRepeater.children[index].visible = 0;
                index = 2;
                screenRepeater.children[index].visible = 1;
                break;
            }
            case Qt.Key_Launch4:    /** .-@  */
            {
                bPressedLaunch4 = true
                if (comma_timer.type != 1)
                    newSentence = true;
                comma_timer.isPressed = false;
                //if(comma_timer.running)
                //   qwerty_keypad.keyReleased( Qt.Key_Back, translate.makeWord(Qt.Key_Back,""), false );
                //modified for ITS 223211 CCP Jog Beep sound issue
                if(comma_timer.running)
                   qwerty_keypad.keyReleased( Qt.Key_Launch4, translate.makeWord(Qt.Key_Back,""), false );

                comma_timer.running = true;
                comma_timer.time = 0;

                if(comma_timer.type == 0)
                    qwerty_keypad.keyReleased(Qt.Key_Period, translate.makeWord( Qt.Key_Period, "." ), false);
                else if(comma_timer.type == 1)
                    qwerty_keypad.keyReleased(Qt.Key_Period, translate.makeWord( Qt.Key_Minus, "-" ), false);
                else
                    qwerty_keypad.keyReleased(Qt.Key_Period, translate.makeWord( Qt.Key_At, "@"), false);

                if(comma_timer.type > 1){
                    comma_timer.type = 0;
                } else {
                    comma_timer.type++;
                }
                break;
            }
            case Qt.Key_Launch5:    // Setting
            {
                qwerty_keypad.launchSettingApp();
                break;
            }

            case Qt.Key_Launch6:    // forth language keyboard
            {
                screenRepeater.children[index].visible = 0;
                index = 3;
                screenRepeater.children[index].visible = 1;
                break;
            }

            case Qt.Key_Launch7:    // number toggle key
            {
                numberToggleProcessing();
                screenRepeater.children[screenRepeater.index].item.retranslateUi();
                break;
            }

            case Qt.Key_Launch8:    // latin toggle key (Qt.Key_Launch8일 경우 화면 QML 내에서 처리됨. 현 QML에서 사용안됨.)
            {
                latinExtendedToggleProcessing();
                screenRepeater.children[screenRepeater.index].item.retranslateUi();
                break;
            }

            case Qt.Key_Launch9:    // show popup for select chiness keyboard-type (중국향 키보드일경우 중국향 팝업 버튼 클릭 시, 시그널 발생)
            {
                qwerty_keypad.launchChineseKeypadPopup()
                break;
            }

            case Qt.Key_Back:
            {
                bPressedBack = true
                sKeytext = ""
                if(!processNewSentence(true))
                {
                    newSentence = false;
                    defaultKey();
                }
                break;
            }
            case Qt.Key_Space:
            {
                if(translate.isFirstCapital && newSentence && !isDoubleShift)
                {
                    newSentence = false;
                    isShift = true;
                    pressedOneShift(true);
                    screenRepeater.children[screenRepeater.index].item.retranslateUi();
                    comma_timer.running = false;
                    comma_timer.type = 0;
                    break;
                }
            }
            default:
            {
                newSentence = false;
                defaultKey();
                break;
            }
            }

            if(keycode < 0xFF || keycode == Qt.Key_Back || keycode == Qt.Key_Return || keycode == Qt.Key_Home)
            {
                // Korean Automata
                if(keycode == Qt.Key_Back)
                {
                    automataString = translate.automataString
                    console.debug("[QML]automataString : " + automataString);
                    console.debug("[QML]automataString :: isComposing() " + translate.isComposing());
                    if(automataString.length && translate.isComposing())
                    {
                        console.debug("[QML]automataString.length --")
                        qwerty_keypad.keyReleased(Qt.Key_A, translate.automataString, true);
                    }
                    else
                    {   console.debug("[QML]automataString.length :: else , sKeytext : " +sKeytext);
                        qwerty_keypad.keyReleased(keycode, sKeytext, keystate);
                    }
                 }
                else
                    qwerty_keypad.keyReleased(keycode, sKeytext, keystate);
            }
        }

        function getLaunchText1()
        {
            if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_KOREAN)
                return countryModel.get(translate.keypadDefaultType).line.get(0).name
            else
                return countryModel.get(translate.country).line.get(0).name
        }

        function getLaunchText2()
        {
            if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_KOREAN)
                return countryModel.get(translate.keypadDefaultType).line.get(1).name
            else
                return countryModel.get(translate.country).line.get(1).name
        }

        function getLaunchText3()
        {
            if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_KOREAN)
                return countryModel.get(translate.keypadDefaultType).line.get(2).name
            else
                return countryModel.get(translate.country).line.get(2).name
        }

        function getLaunchText4()
        {
            if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_KOREAN)
                return
            else
                return countryModel.get(translate.country).line.get(3).name
        }
    }

    Component.onCompleted:
    {
        remYPos=qwerty_keypad.y

        /**
          * 러시아 향지의 경우, 기본으로 표시되는 키보드는 러시아어 키보드. (유럽키보드의 4번째 화면 0-특수, 1-유럽, 2-라틴, 3-러시아)
          */
        if(translate.country == QKC.const_QWERTY_COUNTRY_RUSSIA
                && (translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_EUROPE))
            screenRepeater.index = 3
        else
            screenRepeater.index = 1

        notifyIsChineseKeypad()
    }

    ParallelAnimation {
        id: hideAni

        running: false
        loops: 1

        NumberAnimation { target: qwerty_keypad; property: "y"; easing.type: Easing.OutQuart; to: qwerty_keypad.y + 600; duration: 300 }
        NumberAnimation { target: qwerty_keypad; property: "opacity"; easing.type: Easing.OutQuart; to: 0.1; duration: 150 }
    }

    ParallelAnimation {
        id: showAni

        running: false
        loops: 1

        NumberAnimation { target: qwerty_keypad; property: "y"; easing.type: Easing.InQuart; to: remYPos; duration: 300 }
        NumberAnimation { target: qwerty_keypad; property: "opacity"; easing.type: Easing.InQuart; to: 1; duration: 400 }
    }


    Timer{
        id: comma_timer

        interval: 100
        property int type: 0
        property int time: 0
        property int limit: 10
        property bool isPressed: false
        repeat: true
        running: false

        onTriggered: {
            if(!isPressed)comma_timer.time++;
            if(comma_timer.time > comma_timer.limit){
                comma_timer.running = false;
                comma_timer.type = 0;
                comma_timer.time = 0;
            }
        }
    }

    Connections{
        target: UIListener;
        //onFgReceived: {
        //    update()
        //}

        onSignalLanguageChanged:
        {
            if(translate.languageType == lang)
                return;

            translate.languageType = lang
        }
    }

    Connections{
        target: focus_visible && isKeypadButtonFocused ? UIListener : null;

        onSignalJogCenterLongPressed:
        {
            //translate.printLogMessage("[QML][QwertyKeypad]onSignalJogCenterLongPressed : ")

            //console.log("[QML]Jog Center Long Pressed : " + status)
            prevFocusIndex = currentFocusIndex
            screenRepeater.children[screenRepeater.index].item.isFocusedBtnSelected = true
            screenRepeater.children[screenRepeater.index].item.isFocusedBtnLongPressed = true;
        }

        onSignalJogNavigation:
        {
            //translate.printLogMessage("[QML][QwertyKeypad]onSignalJogNavigation : status -" + status +" , arrow-" + arrow)
            if( ( status == UIListenerEnum.KEY_STATUS_PRESSED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                //translate.printLogMessage("[QML][QwertyKeypad]KEY_STATUS_PRESSED : ")
                if(isReceivedJogCanceled)
                    isReceivedJogCanceled = false

                prevFocusIndex = currentFocusIndex

                screenRepeater.children[screenRepeater.index].item.isFocusedBtnSelected = true
                screenRepeater.children[screenRepeater.index].item.isFocusedBtnLongPressed = false;
            }

            if( ( status == UIListenerEnum.KEY_STATUS_RELEASED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                //translate.printLogMessage("[QML][QwertyKeypad]KEY_STATUS_RELEASED : ")
                screenRepeater.children[screenRepeater.index].item.isFocusedBtnSelected = false
                screenRepeater.children[screenRepeater.index].item.isFocusedBtnLongPressed = false;
            }

            if( ( status == UIListenerEnum.KEY_STATUS_CANCELED ) && arrow == UIListenerEnum.JOG_CENTER ) {

                //translate.printLogMessage("[QML][QwertyKeypad]KEY_STATUS_CANCELED")

                isReceivedJogCanceled = true
                screenRepeater.children[screenRepeater.index].item.isFocusedBtnSelected = false
                screenRepeater.children[screenRepeater.index].item.isFocusedBtnLongPressed = false;
                keyJogCanceled(); //added for CCP Delete LongPress Focus Issue
            }

            __handleJogEvent(arrow, status);
        }
    }

    function retranslateUIByChangingDB()
    {
        if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHINA)
        {
            if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_CONSONANT)
            {
                // unload source
                for(var i = 0; i< countryModel.get(translate.country).line.count; i++){
                    screenRepeater.children[screenRepeater.index].source = "";
                }

                keypadRepeater.model = getKeypadType()
                screenRepeater.children[screenRepeater.index].loadSource()
            }
        }
    }

    /**
      * 중국향 키보드에서 블루투스 폰북 검색화면 사용 시
      */
    onIsReceivedUsePhoneBookDBChanged:
    {
        retranslateUIByChangingDB()
    }

    /**
      * JogController가 잠김 상태가 되었을 경우, 현재 기본 키보드가 중국 키보드가 아니면 다시 활성화.
      */
    onIsKeypadButtonFocusedChanged:
    {
        enableJogController()
    }

    /**
      * 중국향 키보드 타입이 변경되었을 경우
      */
    onSetChineseKeypadTypeChanged:
    {
        updateOnTriggerd()
    }

    onFocus_visibleChanged:
    {
        if(!focus_visible)
        {
            translate.clearAutomata()
        }
    }

    Timer {
        id: updateTimer

        repeat: false
        interval: 100

        onTriggered: qwerty_keypad.updateOnTriggerd()
    }
}
