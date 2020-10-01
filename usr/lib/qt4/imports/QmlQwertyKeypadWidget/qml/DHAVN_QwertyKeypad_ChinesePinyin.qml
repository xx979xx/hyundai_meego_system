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

    property string phoneticSpell //added for Modified Pinyin Engine

    property ListModel pinyinSpellList: ListModel{}
    property int focus_index : -1

    property bool focus_visible: false
    property bool is_focusable: true

    property int nFirstCharacterSize: 1
    property int cnt; //added for Modified Pinyin Engine

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
                    focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LIST_VIEW_FOCUS_INDEX

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
                        selectionList.currentIndex = selectionList.count - 1
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

    function searchChinesePinyin(inputWord)
    {
        //console.log("[QML]serchChinesePinyin : inputWord :" + inputWord)
        pinyinSpell = inputWord
        pinyinModel.setKeyWord(pinyinSpell)
        pinyinModel.setUpdateInputText(pinyinSpell)//added for modify Pinyin result word

    }

    //modified for Modified Pinyin Engine
    function handleKey(keyCode, keyText)
    {
        //console.log("[QML]handleKey : keyCode, keyText :" + keyCode + keyText)
        var prevItemSize;
        var currentItemSize;
        var sPinyinSpell;

        var sTmpPhoneticSpell;//added for Modified Pinyin Engine
        var pCountResult;//added for Modified Pinyin Engine
        var n_PhoneticSpell;//added for Modified Pinyin Engine
        if ( keyCode < 0x01000000 && keyCode != Qt.Key_Space)
        {
            // "문자"를 입력하기 전에, 첫 번째 후보군의 글자 수
            if(selectionList.count)
                prevItemSize = pinyinModel.getItemSize(0);

            sPinyinSpell = pinyinSpell
            sPinyinSpell += keyText[0]
            if(keyText[0] != "") //added for Modified Pinyin Engine
                pinyinModel.addPrevPhoneticInputText(keyText[0]);
            //added for Modified Pinyin Engine
            // pinyin 입력 글자가 40자가 넘거나, 마지막으로 입력된 글자가 "'"이었으나, 다시 "'"가 입력되면 입력 무시.
            if( sPinyinSpell.length > 40 ||
                    (pinyinSpell.length > 0 && pinyinSpell.charAt(pinyinSpell.length-1) == "'" ) && keyText == "'" )
                return
            else
            {
                pinyinSpell = sPinyinSpell
                pinyinModel.setKeyWord(pinyinSpell)
            }

            //added for Modified Pinyin Engine
            pCountResult = pinyinModel.getPhoneticCountResult()
            n_PhoneticSpell = pinyinModel.getPhoneticSpell()

            //for(cnt = 0; cnt < n_PhoneticSpell.length; cnt++)
            //{
            //    console.log("[QML]PhoneticSpell : " + n_PhoneticSpell[cnt]);
            //}

            // ex : ti'an -> tian
            if(pCountResult == 0)
            {
                scrTop.keyReleased( Qt.Key_Back, "", translate.isComposing() )
                scrTop.keyReleased( Qt.Key_Back, "", translate.isComposing() )
                for(cnt = n_PhoneticSpell.length - 2; cnt < n_PhoneticSpell.length; cnt++ )
                {
                    //console.log("[QML]append - PhoneticSpell : " + n_PhoneticSpell[cnt]);
                    scrTop.keyReleased( keyCode, n_PhoneticSpell[cnt], translate.isComposing() )
                }

            }// ex: tia -> ti'a
            else if(pCountResult == 1)
            {
                scrTop.keyReleased( keyCode, "'", translate.isComposing() )
                scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )

            }// ex : ti -> ti
            else if(pCountResult == 2)
            {
                scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )

            }// ex : ti -> ti
            else
            {
                scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )

            }
            //added for Modified Pinyin Engine


            return
        }
        else if(keyCode == Qt.Key_Back)
        {
            //console.log("[QML] Qt.Key_Back : pinyinSpell : " + pinyinSpell)
            // Qt.Key_Back 입력하기 전에, 첫 번째 후보군의 글자 수
            if(selectionList.count)
                prevItemSize = pinyinModel.getItemSize(0);

            var nPos = pinyinSpell.length;          

            if(nPos > 0)
            {
                nPos--

                pinyinSpell = pinyinSpell.substring( 0, nPos )
                //console.log("[QML] Qt.Key_Back : testCode : " + pinyinSpell)
                pinyinModel.setPrevPhoneticInputTextByBack()
                pinyinModel.setKeyWord(pinyinSpell)

            }
            //console.log("[QML] nPos-- : pinyinSpell : " + pinyinSpell)

            pCountResult = pinyinModel.getPhoneticCountResult() //added for modify Pinyin result word
            n_PhoneticSpell = pinyinModel.getPhoneticSpell()

            //for(cnt = 0; cnt < n_PhoneticSpell.length; cnt++)
            //{
            //    console.log("[QML]PhoneticSpell : " + n_PhoneticSpell[cnt]);
            //}

            //modify for ITS 227416 Pinyin -> ENG -> Pinyin Delete Issue
            if(nPos == 0)
            {
               scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
            }
            else
            {
                // ex : ti'an -> tian , when back key case : ti'a ->delete a  prev: ti'a, phonetic: ti
                if(pCountResult == 0)
                {
                    //console.log("[QML]Qt.Key_Back , pCountResult == 0");
                    scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
                    scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
                }// ex: tia -> ti'a, when back key case : tian -> delete n prev: tia , phonetic : ti'a
                else if(pCountResult == 1)
                {
                    scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
                    scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
                    scrTop.keyReleased( 0x52, "'", translate.isComposing() )
                    scrTop.keyReleased( 0x52, n_PhoneticSpell[n_PhoneticSpell.length -1], translate.isComposing() )


                }// ex : ti -> ti, when back key case : ti -> delete i prev: t , phonetic: t
                else if(pCountResult == 2)
                {
                    scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )

                }// ex : ti -> ti
                else
                {
                    scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )

                }

            }
            //modify for ITS 227416 Pinyin -> ENG -> Pinyin Delete Issue


            if(nPos <= 0)
            {
                pinyinModel.clearPhoneticBuffer()
                clearBufferData()
            }

            return
        }
        else if(keyCode == Qt.Key_Space)
        {
            console.log("hanuk : keyCode == Qt.Key_Space")
            if(selectionList.count){
                console.log("hanuk : pinyinModel.getNameByItemIndexOfPage(0):"+pinyinModel.getNameByItemIndexOfPage(0))
                keySelect(pinyinModel.getNameByItemIndexOfPage(0))
                pinyinSpell = ""
                selectionList.currentIndex = -1
                pinyinMain.lostFocus( UIListenerEnum.JOG_DOWN, 0 )
                pinyinModel.clearPhoneticBuffer() //added for Modified Pinyin Engine
                qwerty_keypad.sendHidePiyinButtonFocus() //added for ITS 229920 BT Two Focus issue
            }
            else
            {
                console.log("hanuk : Space Release")
                scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
            }
        }
        else
        {
            //특수기호 키보드나 영어키보드로 전환할 경우, 내부에 입력된 문구를 삭제한다
            if(keyCode == Qt.Key_Launch1 || keyCode == Qt.Key_Launch3)
            {
                pinyinModel.clearBuffer()
                pinyinSpell = ""
                pinyinModel.clearPhoneticBuffer() //added for Modified Pinyin Engine
            }

            //일반 다른 키 입력을 출력한다.("문자", "삭제"버튼을 제외한 일반 키 입력)
            scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
            return
        }
    }
    //modified for Modified Pinyin Engine


    //    function handleKey(keyCode, keyText)
    //    {
    //        console.log("[QML]handleKey : keyCode, keyText :" + keyCode + keyText)
    //        var prevItemSize;
    //        var currentItemSize;
    //        var sPinyinSpell;
    //        if ( keyCode < 0x01000000 && keyCode != Qt.Key_Space)
    //        {
    //            // "문자"를 입력하기 전에, 첫 번째 후보군의 글자 수
    //            if(selectionList.count)
    //                prevItemSize = pinyinModel.getItemSize(0);

    //            sPinyinSpell = pinyinSpell
    //            sPinyinSpell += keyText[0]

    //            // pinyin 입력 글자가 40자가 넘거나, 마지막으로 입력된 글자가 "'"이었으나, 다시 "'"가 입력되면 입력 무시.
    //            if( sPinyinSpell.length > 40 ||
    //                    (pinyinSpell.length > 0 && pinyinSpell.charAt(pinyinSpell.length-1) == "'" ) && keyText == "'" )
    //                return
    //            else
    //            {
    //                pinyinSpell = sPinyinSpell
    //                pinyinModel.setKeyWord(pinyinSpell)
    //            }

    //            // "문자"를 입력한 후에, 첫 번째 후보군의 글자 수
    //            if(selectionList.count)
    //                currentItemSize = pinyinModel.getItemSize(0);

    //            // 입력 전과 입력 후의 글자 수 비교
    //            if(prevItemSize < currentItemSize)
    //            {
    //                // "문자" 입력 후에 첫 번째 후보군의 글자 수가 1일 경우, 그냥 출력
    //                if(currentItemSize == 1)
    //                {
    //                    scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
    //                    return
    //                }

    //                // 수동으로 "'"를 입력하였을 경우가 아니라 검색된 후보군의 글자 수가 증가됨에 따라 자동적으로 "'"를 입력하여야 할 경우
    //                // pinyinSpell에는 "'"가 추가되지 않고, App으로 Signal만 전달하여 "'"와 "입력한 글자" 두번 전달한다
    //                if(pinyinSpell.length>0)
    //                {
    //                    var checkString = pinyinSpell.substring(0, pinyinSpell.length-1)
    //                    if(checkString.length)
    //                    {
    //                        if(checkString.charAt(checkString.length-1) !="'")
    //                            scrTop.keyReleased( keyCode, "'", translate.isComposing() )
    //                    }
    //                    else
    //                        scrTop.keyReleased( keyCode, "'", translate.isComposing() )
    //                }

    //                scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
    //            }
    //            else
    //            {
    //                //입력 전과 입력 후 첫 번쨰 후보군 글자 수가 동일할 경우 그냥 출력
    //                scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
    //            }

    //            return
    //        }
    //        else if(keyCode == Qt.Key_Back)
    //        {
    //            // Qt.Key_Back 입력하기 전에, 첫 번째 후보군의 글자 수
    //            if(selectionList.count)
    //                prevItemSize = pinyinModel.getItemSize(0);

    //            var nPos = pinyinSpell.length;

    //            if(nPos > 0)
    //            {
    //                nPos--

    //                pinyinSpell = pinyinSpell.substring( 0, nPos )
    //                pinyinModel.setKeyWord(pinyinSpell)
    //            }

    //            // Qt.Key_Back 입력한 후에, 첫 번째 후보군의 글자 수
    //            if(selectionList.count)
    //                currentItemSize = pinyinModel.getItemSize(0);

    //            // 입력 전과 입력 후의 글자 수 비교
    //            if(prevItemSize > currentItemSize)
    //            {
    //                // 입력 전에 첫 번째 후보군이 1글자 일경우는, 한번만 삭제한다.
    //                if(prevItemSize == 1)
    //                {
    //                    scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
    //                    return
    //                }

    //                // 그 외의 경우, "ʼ"와 "입력한 글자" 삭제를 위해서 두번을 삭제한다.
    //                scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )

    //                // 그 외의 경우, "ʼ"와 "입력한 글자" 두번을 입력한다.
    //                if(pinyinSpell.length>0)
    //                {
    //                    if(pinyinSpell.charAt(pinyinSpell.length-1) !="'")
    //                    {
    //                        scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
    //                    }
    //                }
    //            }
    //            else
    //            {
    //                //입력 전과 입력 후 첫 번째 후보군 글자 수가 같을 경우 그냥 한번 삭제한다.
    //                scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
    //            }

    //            // 데이터베이스를 검색하기 위해 버퍼에 저장해둔 문자열의 길이가 0 이하가 되면 버퍼를 초기화하고 버튼을 모두 활성화시킨다.
    //            if(nPos <= 0)   clearBufferData()

    //            return
    //        }
    //        else if(keyCode == Qt.Key_Space)
    //        {
    //            console.log("hanuk : keyCode == Qt.Key_Space")
    //            if(selectionList.count){
    //                console.log("hanuk : pinyinModel.getNameByItemIndexOfPage(0):"+pinyinModel.getNameByItemIndexOfPage(0))
    //                keySelect(pinyinModel.getNameByItemIndexOfPage(0))
    //                pinyinSpell = ""
    //                selectionList.currentIndex = -1
    //                pinyinMain.lostFocus( UIListenerEnum.JOG_DOWN, 0 )
    //            }
    //            else
    //            {
    //                console.log("hanuk : Space Release")
    //                scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
    //            }
    //        }
    //        else
    //        {
    //            //특수기호 키보드나 영어키보드로 전환할 경우, 내부에 입력된 문구를 삭제한다
    //            if(keyCode == Qt.Key_Launch1 || keyCode == Qt.Key_Launch3)
    //            {
    //                pinyinModel.clearBuffer()
    //                pinyinSpell = ""
    //            }

    //            //일반 다른 키 입력을 출력한다.("문자", "삭제"버튼을 제외한 일반 키 입력)
    //            scrTop.keyReleased( keyCode, translate.makeWord( keyCode, qsTranslate( "DHAVN_QwertyKeypad_Screen", keyText )), translate.isComposing() )
    //            return
    //        }
    //    }

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
    }

    function searchChinesePrediction(inputWord)
    {
        pinyinModel.getDKBDPrediction(inputWord)
    }

    function clearBuffer()
    {
        selectionList.currentIndex = -1
        pinyinSpell = ""
        pinyinModel.clearBuffer()
        pinyinModel.clearPhoneticBuffer() //added for Modified Pinyin Engine
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
            focusID: QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LEFT_ARROW_FOCUS_INDEX
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
                break;
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
            focusID: QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LIST_VIEW_FOCUS_INDEX
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
                    beepEnabled: true //modify for ITS 225378
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

                            clearBufferData()
                            //pinyinModel.clearPhoneticBuffer() //added for Modified Pinyin Engine

                            pinyinMain.lostFocus( UIListenerEnum.JOG_DOWN, 0 )
                            qwerty_keypad.sendHidePiyinButtonFocus() //added for ITS 229920 BT Two Focus issue

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

                            clearBufferData()
                            //pinyinModel.clearPhoneticBuffer() //added for Modified Pinyin Engine

                            pinyinMain.lostFocus( UIListenerEnum.JOG_DOWN, 0 )

                            qwerty_keypad.sendHidePiyinButtonFocus() //added for ITS 229920 BT Two Focus issue

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
                // 리스트 뷰에서 조그(하)를 조작하면 키패드 버튼화면으로 포커스가 옮겨진다.
                case UIListenerEnum.JOG_DOWN:
                {
                    pinyinMain.lostFocus( arrow, (currentItem.x / 128) + 1 )
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
                        if( currentIndex == 0 )
                            focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LEFT_ARROW_FOCUS_INDEX
                    }
                }
                break
                // 리스트 뷰에서 조그(우)를 조작하면 우측화살표 버튼이 조작가능한 상태일 경우 포커스가 이동된다.
                case UIListenerEnum.JOG_RIGHT:
                {
                    if(rightArrow.active)
                        focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_RIGHT_ARROW_FOCUS_INDEX
                }
                break
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    if(rightArrow.active)
                    {
                        if( currentIndex == (count-1) )
                            focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_RIGHT_ARROW_FOCUS_INDEX
                    }
                }
                break
                case UIListenerEnum.JOG_BOTTOM_LEFT:
                {
                    pinyinMain.lostFocus( arrow, (currentItem.x / 128) + 1 - 1)
                    focus_index = -1
                }
                break
                case UIListenerEnum.JOG_BOTTOM_RIGHT:
                {
                    pinyinMain.lostFocus( arrow, ( (currentItem.x+currentItem.width) / 128) + 1)
                    focus_index = -1
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
            focusID: QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_RIGHT_ARROW_FOCUS_INDEX
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

                        if(selectionList.count)
                            selectionList.currentIndex = selectionList.count-1
                    }
                }
                break
                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    if(status ==  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        focus_index = QKC.const_QWERTY_KEYPAD_CHINESE_CANDIDATE_LIST_VIEW_FOCUS_INDEX

                        if(selectionList.count)
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

    onPinyinSpellChanged:
    {
        if(pinyinSpell.length > 0)
            scrTop.setEnableButtonByIndex(19, true)
        else
            scrTop.setEnableButtonByIndex(19, false)
    }
}
