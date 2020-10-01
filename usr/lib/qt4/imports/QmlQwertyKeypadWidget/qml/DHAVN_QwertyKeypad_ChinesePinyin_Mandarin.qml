import QtQuick 1.1
import ChinesePinyin 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_QwertyKeypad.js" as QKC

Item{
    id: pinyinMain
    signal keySelect( string text )
    signal clearBufferData()
    signal lostFocus( int arrow, int focusID  );

    property string pinyinSpell
    property int focus_index : -1

    property bool focus_visible: false
    property bool is_focusable: true

    x: 9;    width: 1262

    Binding{
        target:pinyinMain
        property: "is_focusable"
        value: (pinyinModel.pinyinCount > 0)
    }

    function setDefaultFocus( arrow, focusID  )
    {
        if(focusID == 0)
        {
            if(leftArrow.active)
                focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LEFT_ARROW_FOCUS_INDEX
            else
            {
                if(selectionList.is_focusMovable)
                {
                    focus_index=1

                    if(selectionList.count)
                        selectionList.currentIndex = 0
                }
            }
        }
        else if(focusID == 9)
        {
            if(rightArrow.active)
                focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_RIGHT_ARROW_FOCUS_INDEX
            else
            {
                if(selectionList.is_focusMovable)
                {
                    focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LIST_VIEW_FOCUS_INDEX

                    if(selectionList.count)
                        selectionList.currentIndex = selectionList.count-1
                }
            }
        }
        else
        {
            if(selectionList.is_focusMovable)
            {
                focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LIST_VIEW_FOCUS_INDEX

                if(selectionList.count)
                    setNextFocusIndexOfList(focusID)
            }
        }

        pinyinMain.showFocus()
    }

    function setNextFocusIndexOfList(nNextFocusIndex)
    {
        var tempX = selectionList.contentX + ( nNextFocusIndex * 128)

        if(selectionList.contentWidth < tempX)
            selectionList.currentIndex = selectionList.count - 1
        else
        {
            var index = selectionList.indexAt(tempX-10, 10)
            selectionList.currentIndex = index
        }
    }

    function showFocus()
    {
        if(is_focusable)
            focus_visible = true
    }

    function hideFocus()
    {
        focus_visible = false
    }

    function handleKey(keyCode, keyText)
    {
        if ( keyCode < 0x01000000 )
        {
            pinyinSpell  += keyText[0]
            pinyinModel.setKeyWord(pinyinSpell)
            return true
        }

        if(keyCode == Qt.Key_Back)
        {
            var nPos = pinyinSpell.length;

            if(nPos <= 0)
                return false

            nPos--

            pinyinSpell = pinyinSpell.substring( 0, nPos )
            pinyinModel.setKeyWord(pinyinSpell)

            // 데이터베이스를 검색하기 위해 버퍼에 저장해둔 문자열의 길이가 0 이하가 되면 버퍼를 초기화하고 버튼을 모두 활성화시킨다.
            if(nPos <= 0)   clearBufferData()

            return true
        }
        return false
    }

    //성음 퀵스펠러 (다음 입력될 수 있는 문자)
    function getConsontChars()
    {
        var nextChars = new Array()
        var btnIDs = new Array()
        var consonantCharLength

        nextChars = pinyinModel.getConsonantsNextCharList();
        consonantCharLength = nextChars.length

        for (var i=0; i < consonantCharLength; i++)
        {
            btnIDs[i] = fromStringToID(nextChars[i])
        }

        return btnIDs
    }

    function fromStringToID(btnText)
    {
        if (btnText ==" ")
            return 100

        var charToAsciiVal = btnText.charCodeAt(0)
        // btnIDList : btn_id list of sequential btn_text {'a', 'b', 'c', ..., 'z'}
        var btnIDList = new Array(10, 24, 22, 12, 2, 13, 14, 15, 7, 16, 17, 18, 26, 25, 8, 9, 0, 3, 11, 4, 6, 23, 1, 21, 5, 20 )
        var btnID = btnIDList[charToAsciiVal - 97]

        return btnID
    }

    function update(keyType)
    {
        selectionList.currentIndex = -1
        pinyinModel.setKeypadType(keyType, false, "")
        pinyinSpell = ""
        pinyinModel.setKeyWord("")
    }

    function clearBuffer()
    {
        selectionList.currentIndex = -1
        pinyinSpell = ""
        pinyinModel.clearBuffer()
    }

    function searchChinesePrediction(inputWord)
    {
        pinyinModel.getDKBDPrediction(inputWord)
    }

    ChinesePinyin  {
        id: pinyinModel
    }

    // 리스트뷰 배경
    Image{
        id: listViewBgImg
        width: parent.width
        y: -78 // (242 + 400) - 720
        source : "/app/share/images/Qwertykeypad/bg_spin_ctrl.png"
        visible: selectionList.count > 0

        DHAVN_QwertyKeypad_PushButton
        {
            id: leftArrow
            suffix: "arrow_l"
            anchors.left: parent.left

            focusID: 0
            focus_visible: focusID == focus_index && pinyinMain.focus_visible

            active: (pinyinModel.pinyinTotalPage > 0)

            // 터치
            onPushButtonClicked:
            {
                if(pinyinMain.is_focusable && active && !focus_visible && qwerty_keypad.focus_visible)
                {
                    focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LEFT_ARROW_FOCUS_INDEX
                    pinyinMain.showFocus()
                }

                if(focus_visible)
                    pinyinModel.decrementCurrentPage()
            }

            // 조그
            onPushButtonReleased:
            {
                pinyinModel.decrementCurrentPage()
            }

            onLostFocus:
            {
                switch ( arrow )
                {
                    // 리스트 뷰에서 조그(상)를 조작하면 키패드App에서 Focus Hide
                case UIListenerEnum.JOG_UP:
                {
                    if(status ==  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = -1
                        qwerty_keypad.lostFocus( arrow, focus_id )
                    }
                }
                break
                case UIListenerEnum.JOG_RIGHT:
                {
                    if(status ==  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LIST_VIEW_FOCUS_INDEX

                        if(selectionList.count)
                            selectionList.currentIndex = 0
                    }
                }
                break
                // 리스트 뷰에서 조그(하)를 조작하면 키패드 버튼화면으로 Focus Move
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    if(status ==  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LIST_VIEW_FOCUS_INDEX

                        if(selectionList.count)
                            selectionList.currentIndex = 0
                    }
                }
                break
                case UIListenerEnum.JOG_DOWN:
                {
                    if(status ==  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = -1
                        pinyinMain.lostFocus(arrow, 0)
                    }
                }
                break
                case UIListenerEnum.JOG_BOTTOM_RIGHT:
                {
                    if(status ==  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = -1
                        pinyinMain.lostFocus(arrow, 1)
                    }
                }
                break
                }
            }
        }

        //후보군 리스트뷰
        DHAVN_QwertyKeypad_ChinesePinyin_ListView {
            id: selectionList
            anchors.fill: parent
            anchors.leftMargin: 118
            anchors.rightMargin: 118
            width: 1022
            clip: true
            focusID: 1
            focus_visible: focusID == focus_index && pinyinMain.focus_visible
            currentIndex : -1
            model: pinyinModel
            highlightMoveDuration : 1
            snapMode: ListView.SnapToItem
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds
            interactive: false
            delegate:
                Item{
                id: itemDelegate
                height:  81
                width: getItemWidth(size)

                property bool bPressed: false
                signal jogSelected( int status )

                function getItemWidth(stringLength)
                {
                    // Pinyin's library provide 12 character(max)
                    switch(stringLength)
                    {
                    case 0: return 0
                    case 1: return 128
                    case 2:
                    case 3: return 256
                    case 4:
                    case 5:
                    case 6: return 384
                    case 7:
                    case 8:
                    case 9: return 512
                    case 10:
                    case 11:
                    case 12: return 640
                    default: return 0
                    }
                }

                function getItemFocusedImage(stringLength)
                {
                    switch(stringLength)
                    {
                    case 0: return ""
                    case 1: return "/app/share/images/Qwertykeypad/bg_spin_ctrl_f.png"
                    case 2:
                    case 3: return "/app/share/images/Qwertykeypad/bg_spin_ctrl_02_f.png"
                    case 4:
                    case 5:
                    case 6: return "/app/share/images/Qwertykeypad/bg_spin_ctrl_03_f.png"
                    case 7:
                    case 8:
                    case 9: return "/app/share/images/Qwertykeypad/bg_spin_ctrl_04_f.png"
                    case 10:
                    case 11:
                    case 12: return "/app/share/images/Qwertykeypad/bg_spin_ctrl_05_f.png"
                    default: return ""
                    }
                }

                function getItemPressedImage(stringLength)
                {
                    switch(stringLength)
                    {
                    case 0: return ""
                    case 1: return "/app/share/images/Qwertykeypad/bg_spin_ctrl_s.png"
                    case 2:
                    case 3: return "/app/share/images/Qwertykeypad/bg_spin_ctrl_02_s.png"
                    case 4:
                    case 5:
                    case 6: return "/app/share/images/Qwertykeypad/bg_spin_ctrl_03_s.png"
                    case 7:
                    case 8:
                    case 9: return "/app/share/images/Qwertykeypad/bg_spin_ctrl_04_s.png"
                    case 10:
                    case 11:
                    case 12: return "/app/share/images/Qwertykeypad/bg_spin_ctrl_05_s.png"
                    default: return ""
                    }
                }

                Image{
                    id: focusedImage
                    anchors.top:parent.top
                    anchors.left:parent.left
                    visible : selectionList.focus_visible && selectionList.currentIndex == index && !bPressed
                    source: itemDelegate.getItemFocusedImage(size)
                }

                Image{
                    id: pressedImage
                    anchors.top:parent.top
                    anchors.left:parent.left
                    visible : bPressed
                    source: itemDelegate.getItemPressedImage(size)
                }

                Text {
                    id: candiateText
                    anchors.centerIn: parent
                    text: name
                    font.pointSize: 50
                    color: ((selectionList.focus_visible && selectionList.currentIndex == index) || bPressed) ? "#FAFAFA" : "#323232"
                    font.family: "DFHeiW5-A"
                }

                Image {
                    visible: (index >= 0) ? true : false
                    anchors.right: parent.right
                    anchors.rightMargin: -2
                    source: "/app/share/images/Qwertykeypad/bg_spin_ctrl_divider.png"
                }

                MouseArea{
                    id: candiateMouseArea
                    anchors.fill: parent
                    beepEnabled: false
                    onCanceled:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        bPressed = false
                    }
                    onExited:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        bPressed = false
                    }
                    onPressed:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        bPressed = true
                    }
                    onReleased:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        if(size && bPressed){
                            bPressed = false
                            pinyinModel.clearBuffer()
                            pinyinSpell = ""
                            selectionList.currentIndex = -1
                            keySelect(name)
                            pinyinMain.lostFocus( UIListenerEnum.JOG_DOWN, focus_id )
                        }
                    }
                }

                onJogSelected:
                {
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
                    {
                        if(size)
                            bPressed = true
                    }
                    else if( status == UIListenerEnum.KEY_STATUS_RELEASED )
                    {
                        bPressed = false

                        if(size){
                            pinyinModel.clearBuffer()
                            pinyinSpell = ""
                            selectionList.currentIndex = -1
                            keySelect(name)
                            pinyinMain.lostFocus( UIListenerEnum.JOG_DOWN, focus_id )
                        }
                    }
                }
            }

            onCountChanged:
            {
                if( count > 0 )
                    is_focusMovable = true
                else
                {
                    is_focusMovable = false
                    if(pinyinMain.focus_visible)
                        pinyinMain.lostFocus( UIListenerEnum.JOG_DOWN, 0 )
                }
            }

            onLostFocus:
            {
                switch ( arrow )
                {
                    // 리스트 뷰에서 조그(상)를 조작하면 키패드에서 포커스가 사라진다.
                case UIListenerEnum.JOG_UP:
                {
                    focus_index = -1
                    qwerty_keypad.lostFocus( arrow, focus_id )
                }
                break
                case UIListenerEnum.JOG_BOTTOM_LEFT:
                {
                    pinyinMain.lostFocus( arrow, currentIndex )
                    focus_index = -1
                }
                break
                // 리스트 뷰에서 조그(하)를 조작하면 키패드 버튼화면으로 포커스가 옮겨진다.
                case UIListenerEnum.JOG_DOWN:
                {
                    pinyinMain.lostFocus( arrow, currentIndex+1 )
                    focus_index = -1
                }
                break
                case UIListenerEnum.JOG_BOTTOM_RIGHT:
                {
                    pinyinMain.lostFocus( arrow, currentIndex+2 )
                    focus_index = -1
                }
                break
                // 리스트 뷰에서 조그(좌)를 조작하면 좌측화살표 버튼이 조작가능한 상태일 경우 포커스가 이동된다.
                case UIListenerEnum.JOG_LEFT:
                {
                    if(leftArrow.active)
                    {
                        focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LEFT_ARROW_FOCUS_INDEX
                    }
                }
                break
                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    if(rightArrow.active)
                    {
                        focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LEFT_ARROW_FOCUS_INDEX
                    }
                }
                break
                // 리스트 뷰에서 조그(우)를 조작하면 우측화살표 버튼이 조작가능한 상태일 경우 포커스가 이동된다.
                case UIListenerEnum.JOG_RIGHT:
                {
                    if(rightArrow.active)
                    {
                        focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_RIGHT_ARROW_FOCUS_INDEX
                    }
                }
                break
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    if(rightArrow.active)
                    {
                        focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_RIGHT_ARROW_FOCUS_INDEX
                    }
                }
                break
                }
            }

            onFocus_visibleChanged:
            {
                if(!focus_visible)
                    currentIndex = -1
            }
        }

        DHAVN_QwertyKeypad_PushButton
        {
            id: rightArrow
            anchors.left: parent.right
            anchors.leftMargin: -120
            suffix: "arrow_r"
            focusID: 2
            focus_visible: focusID == focus_index && pinyinMain.focus_visible

            active: (pinyinModel.pinyinTotalPage > 0)

            onPushButtonClicked:
            {
                if(pinyinMain.is_focusable && active && !focus_visible && qwerty_keypad.focus_visible )
                {
                    focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_RIGHT_ARROW_FOCUS_INDEX
                    pinyinMain.showFocus()
                }

                if(focus_visible)
                    pinyinModel.incrementCurrentPage()
            }

            onPushButtonReleased:
            {
                pinyinModel.incrementCurrentPage()
            }

            onLostFocus:
            {
                switch ( arrow )
                {
                case UIListenerEnum.JOG_UP:     // 우측화살표버튼에서 조그(상)를 조작하면 키패드에서 포커스가 사라진다.
                {
                    if(status == UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = -1
                        qwerty_keypad.lostFocus( arrow, focus_id )
                    }
                }
                break
                case UIListenerEnum.JOG_DOWN:   // 우측화살표버튼에서 조그(하)를 조작하면 키패드 버튼화면으로 포커스가 옮겨진다.
                {
                    if(status ==  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = -1
                        pinyinMain.lostFocus(arrow, 9)
                    }
                }
                break
                case UIListenerEnum.JOG_LEFT:
                {
                    if(status ==  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LIST_VIEW_FOCUS_INDEX
                        selectionList.currentIndex = selectionList.count-1
                    }
                }
                break
                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    if(status ==  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LIST_VIEW_FOCUS_INDEX
                        selectionList.currentIndex = selectionList.count-1
                    }
                }
                break
                case UIListenerEnum.JOG_BOTTOM_LEFT:
                {
                    if(status ==  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = -1
                        pinyinMain.lostFocus(arrow, 8)
                    }
                }
                break
                }
            }
        }
    }
}
