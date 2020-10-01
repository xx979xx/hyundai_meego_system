import QtQuick 1.1
import AppEngineQMLConstants 1.0
import qwertyKeypadUtility 1.0
import ChinesePinyin 1.0

Item{
    id: scrTop

    property int  transitDirection: -1
    property bool isFocusedBtnSelected: false
    property bool isFocusedBtnLongPressed: false

    property bool isLongPressAtBackKey: false //added for Delete Long Press Spec Modify

    // 병음 리스트뷰 하단의 키패드화면 포커스 유무 판단 플래그
    property bool focus_visible: false
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

    Binding{
        target: scrTop
        property: "focus_visible"
        value: qwerty_keypad.focus_visible
    }

    Binding{
        target: pinyin
        property: "focus_visible"
        value: qwerty_keypad.focus_visible ? false : false
    }

    Binding{
        target: qwerty_keypad
        property: "isPinyinCandidate"
        value: pinyin.is_focusable
    }

    Binding{
        target: qwerty_keypad
        property: "isKeypadButtonFocused"
        value: focus_visible
    }

    onFocus_visibleChanged:
    {
        if(focus_visible)
            pinyin.focus_visible=false
    }

    function showFocus()
    {
        focus_visible = true
    }

    function hideFocus()
    {
        focus_visible = false
    }

    function setFocus(arrow, nCurrentFocusIndex )
    {
        var nNextFocusIndex = -1

        if(arrow == UIListenerEnum.JOG_UP)
        {
            nNextFocusIndex = nCurrentFocusIndex

            if(pinyin.is_focusable)
            {
                pinyin.setDefaultFocus( arrow, nNextFocusIndex )
                focus_visible = false
            }
            else
                qwerty_keypad.lostFocus( arrow, focus_id )
        }
        else if(arrow == UIListenerEnum.JOG_TOP_LEFT)
        {
            nNextFocusIndex = nCurrentFocusIndex - 1 // Left -> -1

            if(nNextFocusIndex < 0)
                return

            if(pinyin.is_focusable)
            {
                pinyin.setDefaultFocus( arrow, nNextFocusIndex )
                focus_visible = false
            }
        }
        else if(arrow == UIListenerEnum.JOG_TOP_RIGHT)
        {
            nNextFocusIndex = nCurrentFocusIndex + 1 // Right -> +1

            if(nNextFocusIndex > 9)
                return

            if(pinyin.is_focusable)
            {
                pinyin.setDefaultFocus( arrow, nNextFocusIndex )
                focus_visible = false
            }
        }
    }

    function searchChinesePrediction(inputWord)
    {
        pinyin.searchChinesePrediction(inputWord)
    }

    DHAVN_QwertyKeypad_ChinesePinyin{
        id: pinyin
        onKeySelect: scrTop.keyReleased( Qt.Key_A, translate.makeWord( Qt.Key_A, text), translate.isComposing() )

        onLostFocus:
        {
            switch ( arrow )
            {
            case UIListenerEnum.JOG_DOWN:
            case UIListenerEnum.JOG_BOTTOM_LEFT:
            case UIListenerEnum.JOG_BOTTOM_RIGHT:
            {
                pinyin.hideFocus()
                currentFocusIndex = focusID
                scrTop.showFocus()
            }
            break
            }
        }

        onFocus_visibleChanged:
        {
            if(focus_visible)
                scrTop.focus_visible=false
        }
    }

    DHAVN_QwertyKeypad_ModelChinesePinyin{
        id: chinese_pinyin_keypad_model
    }

    Item{
        id: column

        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left : parent.left
        anchors.leftMargin: 8

        Repeater{
            model: chinese_pinyin_keypad_model.keypad
            delegate:
                DHAVN_QwertyKeypad_Button_Delegate{
                btnid: btn_id; width: btn_width; height:btn_height;
                suffix: btn_suffix; keytext: btn_text;
                keycode: btn_keycode
                btnEnabled: btn_Enabled
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
                    console.log("[QML]onJogDialSelectLongPressed : Pinyin : " + isPress)

                    if(btn_keycode == Qt.Key_Back)
                    {
                        if(isPress)
                        {
                           scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                           isLongPressAtBackKey = true //added for Delete Long Press Spec Modify
                        }

                    }
                    else
                    {
                        scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    }
                    //scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    //added(modified) for ITS 223849 Beep sound twice issue

                    /* //added for Delete Long Press Spec Modify
                    if(btn_keycode == Qt.Key_Back)
                    {
                        pinyin.clearBuffer()
                    }
                    */

                }
                onJogDialSelectReleased:
                {
                    //console.log("[QML]onJogDialSelectReleased ------>");
                    onJogCenterReleased()
                    qwerty_keypad.sendReleaseAtPressAndHold() //added for Delete Long Press Spec Modify
                    isLongPressAtBackKey = false //added for Delete Long Press Spec Modify
                }

                MouseArea{
                    anchors.fill: parent
                    beepEnabled: btnEnabled
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
                            //pinyin.clearBuffer() //added for Delete Long Press Spec Modify
                            isLongPressAtBackKey = true //added for Delete Long Press Spec Modify
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

                            //added for Delete Long Press Spec Modify
                            if(isLongPressAtBackKey)
                            {
                                isLongPressAtBackKey = false
                                qwerty_keypad.sendReleaseAtPressAndHold()
                            }
                        }

                        onSelectedButtonReleased()
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
                    if( isLongPressAtBackKey == false ) //added for Delete Long Press Spec Modify
                        pinyin.handleKey(btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ))
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
                    focus_visible = true

                    redrawButtonOnKeyRelease(false)

                    pinyin.handleKey(btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ))
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

    function retranslateUi()
    {
        isChinesePinyinListView = true

        translate.changeLang( "Chinese", 0,  0)
        pinyin.update(translate.keypadTypeCh)

        checkDisableButton()

        column.children[29].keytext = screenRepeater.getLaunchText1()
        column.children[30].keytext = screenRepeater.getLaunchText2()
        column.children[31].keytext = screenRepeater.getLaunchText3()
        column.children[30].fontColor = "#5B5B5B"

        updateButton("")
    }

    function getDefaultFocusIndex()
    {
        for(var i=0; i<chinese_pinyin_keypad_model.keypad.length; i++)
        {
            if(column.children[i].btnEnabled)
                return column.children[i].btnid
        }
    }

    function getIsCurrentItemEnabled()
    {
        return column.children[currentFocusIndex].btnEnabled
    }

    function searchChinesePinyin(inputWord)
    {
        pinyin.searchChinesePinyin(inputWord)
    }
    //added for Delete Long Press Spec Modify
    function deleteLongPress()
    {
        pinyin.handleKey(Qt.Key_Back, "");
    }

    function disableButton(nKeycode)
    {
        for(var i=0; i<chinese_pinyin_keypad_model.keypad.length; i++)
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
        for(var i=0; i<chinese_pinyin_keypad_model.keypad.length; i++)
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

    function checkDisableButton()
    {
        var bCheckDisableItem = false

        for(var i=0; i<chinese_pinyin_keypad_model.keypad.length; i++)
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
            }

            bCheckDisableItem = false
        }

        if(pinyin.pinyinSpell == "")
        {
            column.children[19].btnEnabled = false
            column.children[19].fontColor = "#5B5B5B"
        }

        column.children[30].btnEnabled = false
        column.children[30].fontColor = "#5B5B5B"
    }

    function setEnableButtonByIndex(index, bEnabled)
    {
        if(index>=0 && index < chinese_pinyin_keypad_model.keypad.length)
        {
            column.children[index].btnEnabled = bEnabled
            column.children[index].fontColor = bEnabled ? "#FAFAFA":"#5B5B5B"
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

    function clearBuffer()
    {
        pinyin.clearBuffer()
    }
}
