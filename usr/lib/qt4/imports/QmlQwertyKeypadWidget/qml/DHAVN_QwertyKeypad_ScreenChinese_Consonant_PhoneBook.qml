import QtQuick 1.1
import qwertyKeypadUtility 1.0
import AppEngineQMLConstants 1.0
import ChinesePinyin 1.0
import "DHAVN_QwertyKeypad.js" as QKC

Item{
    id: scrTop

    property int  transitDirection: -1
    property bool isFocusedBtnSelected: false
    property bool isFocusedBtnLongPressed: false
    property bool isLongPressed: false //added for ITS 244746 for Long Press remain Focus Issue
    /**Private area*/

    width:  1280
    height: 400

    MouseArea{
        anchors.fill: parent
        beepEnabled: false
    }

    signal keyPress( int keycode_s, string keytext_s )
    signal keyPressAndHold( int keycode_s, string keytext_s )
    signal keyReleased( int keycode_s, string keytext_s, bool keystate_s )

    property bool focus_visible: false

    // 상위 qwerty_keypad에 focus_visible이 변경되면 현재 keypad화면의 focus_visible도 동일하게 변경됨
    Binding{
        target: scrTop
        property: "focus_visible"
        value: qwerty_keypad.focus_visible
    }

    // 상위 qwerty_keypad의 UIListener Connection을 Visible/Invisible
    Binding{
        target: qwerty_keypad
        property: "isKeypadButtonFocused"
        value: focus_visible
    }

    function showFocus()
    {
        focus_visible = true
    }

    function hideFocus()
    {
        focus_visible = false
    }

    DHAVN_QwertyKeypad_ChinesePinyin_PhoneBook{
        id: pinyinPhoneBook

        // BT(vocal_sound) DB Path가 잘못되었거나, DB Open 실패할 경우, default 성음 키패드로 변경
        onPhoneBookDBReadFailed:
        {
            if(isReceivedUsePhoneBookDB)
            {
                isReceivedUsePhoneBookDB = false
            }
        }
    }

    DHAVN_QwertyKeypad_ModelChineseConsonant{
        id: chinese_consonant_keypad_model
    }

    Item{
        id: column

        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 8

        Repeater{
            model: chinese_consonant_keypad_model.keypad
            delegate:
                DHAVN_QwertyKeypad_Button_Delegate{
                btnid: btn_id; width: btn_width; height:btn_height;
                suffix: btn_suffix; keytext: btn_text;
                btnEnabled: btn_Enabled
                keycode: btn_keycode
                transitionIndex: trn_index
                fontSize: btn_fontSize
                x: btnXpos
                y: btnYpos

                textVerticalOffSet: textOffSet
                signal updateButton( string button_text )

                onJogDialSelectPressed: onJogCenterPressed()
                onJogDialSelectLongPressed:
                {
                    //added(modified) for ITS 223849 Beep sound twice issue
                    if(btn_keycode == Qt.Key_Back)
                    {
                        if(isPress)
                        {
                            scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                        }

                       clearDisableButton()
                       clearBuffer()
                    }
                    else
                    {
                        scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    }
                    //scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    //added(modified) for ITS 223849 Beep sound twice issue
                    //if(btn_keycode == Qt.Key_Back)
                    //{
                    //    scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    //    clearDisableButton()
                    //    clearBuffer()
                    //}
                }
                onJogDialSelectReleased:
                {
                    onJogCenterReleased()
                }


                MouseArea{
                    anchors.fill: parent
                    beepEnabled: false //added for ITS 225692 beep issue
                    noClickAfterExited: true
                    onPressed:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        onSelectedButtonPressed()
                    }
                    onClicked:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        onSelectedButtonClicked()
                    }
                    onPressAndHold:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        if( !btnEnabled )
                            return;

                        if(btn_keycode == Qt.Key_Back)
                        {
                            //currentFocusIndex = btnid //added for Delete Long Press Spec Modify
                            //prevFocusIndex = currentFocusIndex //added for Delete Long Press Spec Modify

                            isLongPressed = true //added for ITS 244746 for Long Press remain Focus Issue
                            scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                            clearDisableButton()
                            clearBuffer()
                            longPressFlag = true //added for Delete Long Press Spec Modify
                        }
                        else
                            longPressFlag = true
                    }

                    onReleased:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        isLongPressed = false //added for ITS 244746 for Long Press remain Focus Issue
                        if(isFocusedBtnSelected)
                            return

                        if (longPressFlag)
                        {
                            onSelectedButtonClicked()
                            longPressFlag = false

                        }

                        onSelectedButtonReleased()
                        //added for ITS 225692 beep issue
                        if(btnEnabled)
                            UIListener.ManualBeep();
                        //added for ITS 225692 beep issue
                    }

                    onExited:
                    {
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        isLongPressed = false //added for ITS 244746 for Long Press remain Focus Issue
                        if(isFocusedBtnSelected)
                            return
                        //added for ITS 245874 delete long key press Issue
                        if(btn_keycode == Qt.Key_Back)
                        {
                            if (longPressFlag)
                            {
                                //console.log("[QML]screenKorean : longPressFlag : ")
                                onSelectedButtonClicked()
                                longPressFlag = false
                            }
                        }
                        //added for ITS 245874 delete long key press Issue
                        longPressFlag = false
                        onSelectedButtonReleased()
                    }
                }

                function onJogCenterPressed()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    redrawJogCenterPress()
                    scrTop.keyPress( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                }

                function onJogCenterReleased()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    redrawJogCenterRelease(false)

                    if(prevFocusIndex != currentFocusIndex)
                        return

                    if ( btn_keycode != Qt.Key_Shift )
                    {                        
                        scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                    }

                    if( pinyinPhoneBook.handleKey(btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )) )
                        retranslateUiConsonants(keycode)

                }

                function onSelectedButtonPressed()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    redrawButtonOnKeyPress()
                    scrTop.keyPress( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                }

                function onSelectedButtonClicked()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    currentFocusIndex = btnid
                    prevFocusIndex = currentFocusIndex

                    redrawButtonOnKeyRelease(false)

                    if ( btn_keycode != Qt.Key_Shift )
                    {
                        scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                    }//added for ITS 252365 Shift Button Focus Issue
                    else
                    {
                         qwerty_keypad.keyReleased(btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing());
                         //qwerty_keypad.enableShiftButton(); //added for ITS 252365 Shift Button Focus Issue
                    }
                    //added for ITS 252365 Shift Button Focus Iss

                    if( pinyinPhoneBook.handleKey(btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )) )
                        retranslateUiConsonants(keycode)
                }

                function onSelectedButtonReleased()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    redrawButtonOnKeyRelease(false)
                }
            }
        }
    }

    function disableButton(nKeycode)
    {
        for(var i=0; i<chinese_consonant_keypad_model.keypad.length; i++)
        {
            if(nKeycode == column.children[i].keycode
                    || nKeycode == qsTranslate( "DHAVN_QwertyKeypad_Screen", column.children[i].keytext ))
            {
                column.children[i].btnEnabled = false
                column.children[i].fontColor = "#5B5B5B"
            }
        }

        updateButton("")
    }

    function enableButton(nKeycode)
    {
        for(var i=0; i<chinese_consonant_keypad_model.keypad.length; i++)
        {
            if(nKeycode == column.children[i].keycode
                    || nKeycode == qsTranslate( "DHAVN_QwertyKeypad_Screen", column.children[i].keytext ))
            {
                column.children[i].btnEnabled = true
                column.children[i].fontColor = "#FAFAFA"
            }
        }

        updateButton("")
    }

    function getDefaultFocusIndex()
    {
        for(var i=0; i<chinese_consonant_keypad_model.keypad.length; i++)
        {
            if(column.children[i].btnEnabled)
                return column.children[i].btnid
        }
    }

    function getIsCurrentItemEnabled()
    {
        return column.children[currentFocusIndex].btnEnabled
    }

    function clearDisableButton()
    {
        for(var i=0; i<chinese_consonant_keypad_model.keypad.length; i++)
        {
            if( index == column.children[i].btnid )
            {
                column.children[i].btnEnabled = true
                column.children[i].fontColor = "#FAFAFA"
            }

            // Consonant키보드 Shift 대문자 고정 및 비활성화
            if(Qt.Key_Shift == column.children[i].keycode)
            {
                column.children[i].btnEnabled = false
            }
        }

        updateButton("")
    }

    function checkDisableButton()
    {
        var bCheckDisableItem = false

        for(var i=0; i<chinese_consonant_keypad_model.keypad.length; i++)
        {
            for(var m=0; m< disableList.count; m++)
            {
                if(disableList.get(m).keytext ==
                        (disableList.get(m).keytype == 0 ? qsTranslate( "DHAVN_QwertyKeypad_Screen", column.children[i].keytext ) : column.children[i].keycode))
                {
                    bCheckDisableItem = true
                    break
                }
            }

            if(bCheckDisableItem)
            {
                column.children[i].btnEnabled = false
                column.children[i].fontColor = "#5B5B5B"
            }
            else
            {
                column.children[i].btnEnabled = true
                column.children[i].fontColor = "#FAFAFA"

                // Consonant키보드 Shift 대문자 고정 및 비활성화
                if(Qt.Key_Shift == column.children[i].keycode)
                {
                    column.children[i].btnEnabled = false
                }
            }

            bCheckDisableItem = false

        }

        column.children[30].btnEnabled = false
        column.children[30].fontColor = "#5B5B5B"

        if(translate.country == QKC.const_QWERTY_COUNTRY_CHINA) // 향지(중국)
        {
            if(translate.keypadDefaultType == QKC.const_DEFAULT_KEYPAD_CHINA) // 기본키보드(중국키보드)
            {
                if(translate.keypadTypeCh == QKC.const_QWERTY_CHINESE_KEYPAD_TYPE_CONSONANT)
                {
                    column.children[19].btnEnabled = false // Shift Button Disable
                    column.children[31].btnEnabled = false
                    column.children[31].fontColor = "#5B5B5B"
                }
            }
        }
    }

    function getNextItemEnabled(nNextIndex, nDirectionIndex)
    {
        if(column.children[nNextIndex].btnEnabled) // enabled button
            return nNextIndex
        else                                          // disabled button
        {
            if(nNextIndex == column.children[nNextIndex].transitionIndex[nDirectionIndex])
                return currentFocusIndex

            return getNextItemEnabled(column.children[nNextIndex].transitionIndex[nDirectionIndex], nDirectionIndex)
        }
    }

    function retranslateUi()
    {
        isChinesePinyinListView = false

        // 중국어 Consonant키보드 진입시 초기화 수행
        clearDisableButton()
        clearBuffer()

        // Consonant키보드 Shift 대문자 고정 및 비활성화
        isShift = true;
        isDoubleShift = true;
        pressedTwoShifts(true);
        column.children[19].btnEnabled = false

        translate.changeLang( "Chinese", 0,  isShift)
        pinyinPhoneBook.update(translate.keypadTypeCh)

        checkDisableButton()

        column.children[29].keytext = screenRepeater.getLaunchText1()
        column.children[30].keytext = screenRepeater.getLaunchText2()
        column.children[31].keytext = screenRepeater.getLaunchText3()
        column.children[30].fontColor = "#5B5B5B"

        updateButton("")
    }

    function retranslateUiConsonants(keycode)
    {
        var enableColorString ="#FAFAFA"
        var disableColorString = "#5B5B5B"

        var nLength
        var btnIDs = new Array()
        btnIDs = pinyinPhoneBook.getConsontChars()
        nLength = btnIDs.length

        // 검색 문자열(버퍼)의 길이가 0일 경우 모든 버튼이 활성화 되어 있어야 하므로 리턴시킴.
        if(pinyinPhoneBook.pinyinSpell == 0) return

        // 전체버튼을 disable시킴
        changeButtonEnabled(disableColorString, false)


        var nNextFocusIndex = -1
        for (var i=0; i < nLength; i++)
        {
            if( (btnIDs[i] < 10) || ( btnIDs[i]  > 9 && btnIDs[i]  < 19) || ( btnIDs[i]  > 19 && btnIDs[i]  < 27))
            {
                column.children[btnIDs[i]].btnEnabled = true
                column.children[btnIDs[i]].fontColor = enableColorString

                if(keycode != Qt.Key_Back)
                {
                    if(nNextFocusIndex == -1)
                        nNextFocusIndex = btnIDs[i]
                    else
                    {
                        if(nNextFocusIndex > btnIDs[i])
                            nNextFocusIndex = btnIDs[i]
                    }
                }
            }
        }

        if(keycode != Qt.Key_Back)
        {
            if(nNextFocusIndex == -1)
                currentFocusIndex = getDefaultFocusIndex()
            else
                currentFocusIndex = nNextFocusIndex
        }
    }

    function changeButtonEnabled(colorString, isEnabled)
    {
        var i;

        for (i=0; i < 10; i++)
        {
            column.children[i].btnEnabled= isEnabled
            column.children[i].fontColor = colorString
        }

        for (i=10; i > 9 && i < 19; i++)
        {
            column.children[i].btnEnabled= isEnabled
            column.children[i].fontColor = colorString
        }

        for (i=20; i > 19 && i < 27; i++)
        {
            column.children[i].btnEnabled= isEnabled
            column.children[i].fontColor = colorString
        }
    }

    function clearBuffer()
    {
        clearDisableButton()
        pinyinPhoneBook.clearBuffer()
        checkDisableButton()
    }

    Connections{
        target: pinyinPhoneBook

        onClearBufferData:
        {
            clearBuffer()
        }
    }
}
