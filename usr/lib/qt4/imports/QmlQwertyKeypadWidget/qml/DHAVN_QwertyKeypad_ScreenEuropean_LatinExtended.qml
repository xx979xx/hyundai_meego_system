import QtQuick 1.1
import qwertyKeypadUtility 1.0

Item{
    id: scrTop

    property int keypadType: -1
    property bool bInitScreen:false
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

    //  QwertyKeypadUtility{id: translate}

    DHAVN_QwertyKeypad_ModelEuropean_LatinExtended{
        id: keypad_model
    }
    DHAVN_QwertyKeypad_ModelEuropean_LatinExtended3p{
        id: keypad_model_latin_3p
    }

    function getKeypadModel()
    {
        switch(latinExtendedMode)
        {
        case 0:
        case 1:
            return keypad_model.keypad
        case 2: return keypad_model_latin_3p.keypad
        default: return keypad_model.keypad
        }
    }

    Item{
        id: column

        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left : parent.left
        anchors.leftMargin: 11

        Repeater{
            model: getKeypadModel()//keypad_model.keypad
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

                onJogDialSelectPressed:
                {
                    onJogCenterPressed()
                }

                onJogDialSelectLongPressed:
                {
                    //added(modified) for ITS 223849 Beep sound twice issue
                    if(btn_keycode == Qt.Key_Back)
                    {
                        if(isPress)
                        {
                            scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                        }

                    }
                    else
                    {
                        scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    }
                    //scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    //added(modified) for ITS 223849 Beep sound twice issue
                }

                onJogDialSelectReleased:
                {
                    onJogCenterReleased()
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

                            //added for ITS 247594 Long Touch Beep Issue
                            if(btnEnabled)
                                translate.callAudioBeepCommand();
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

                    if (btn_keycode == Qt.Key_Launch4)
                    {
                        //changeButtonIncreased(comma[comma_timer.type])
                        comma_timer.isPressed = true
                    }

                    redrawJogCenterPress()
                    scrTop.keyPress( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                }

                function onJogCenterReleased()
                {
                    if( !btnEnabled )
                        return;

                    if ( btn_keycode == Qt.Key_Shift )
                    {
                        shiftProcessing()
                    }

                    if ( btn_keycode == Qt.Key_Launch8 )
                    {
                        latinExtendedToggleProcessing()
                    }

                    redrawJogCenterRelease(false)

                    if(prevFocusIndex != currentFocusIndex)
                        return

                    if ( btn_keycode != Qt.Key_Shift && btn_keycode != Qt.Key_Launch8 )
                    {                        
                        scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                    }
                }

                function onSelectedButtonPressed()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch4)
                    {
                        //changeButtonIncreased(comma[comma_timer.type])
                        comma_timer.isPressed = true
                    }

                    redrawButtonOnKeyPress()
                    scrTop.keyPress( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                }

                function onSelectedButtonClicked()
                {
                    if( !btnEnabled )
                        return;

                    currentFocusIndex = btnid
                    prevFocusIndex = currentFocusIndex

                    if ( btn_keycode == Qt.Key_Shift )
                    {
                        shiftProcessing()
                    }

                    if ( btn_keycode == Qt.Key_Launch8 )
                    {
                        latinExtendedToggleProcessing()
                    }

                    redrawButtonOnKeyRelease(false)

                    if ( btn_keycode != Qt.Key_Shift && btn_keycode != Qt.Key_Launch8)
                    {
                        scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                    }

                    if(btn_keycode == Qt.Key_Shift)
                    {
                        //added for ITS 252365 Shift Button Focus Issue

                        qwerty_keypad.keyReleased(btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing());
                        //qwerty_keypad.enableShiftButton(); //added for ITS 252365 Shift Button Focus Issue
                        //added for ITS 252365 Shift Button Focus Issue
                    }

                }

                function onSelectedButtonReleased()
                {
                    if( !btnEnabled )
                        return;

                    redrawButtonOnKeyRelease(false)
                }
            }
        }
    }

    function disableButton(nKeycode)
    {
        var length;
        if(latinExtendedMode == 2)
            length = keypad_model_latin_3p.keypad.length
        else
            length = keypad_model.keypad.length

        for(var i=0; i< length/*keypad_model.keypad.length*/; i++)
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
        var length;
        if(latinExtendedMode == 2)
            length = keypad_model_latin_3p.keypad.length
        else
            length = keypad_model.keypad.length

        for(var i=0; i< length/*keypad_model.keypad.length*/; i++)
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
        var length;
        if(latinExtendedMode == 2)
            length = keypad_model_latin_3p.keypad.length
        else
            length = keypad_model.keypad.length

        for(var i=0; i< length/*keypad_model.keypad.length*/; i++)
        {
            if(column.children[i].btnEnabled)
                return column.children[i].btnid
        }
    }

    function getIsCurrentItemEnabled()
    {
        return column.children[currentFocusIndex].btnEnabled
    }

    function checkDisableButton()
    {
        var length;
        if(latinExtendedMode == 2)
            length = keypad_model_latin_3p.keypad.length
        else
            length = keypad_model.keypad.length

        var bCheckDisableItem = false

        for(var i=0; i< length/*keypad_model.keypad.length*/; i++)
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

         if(latinExtendedMode == 2){
             column.children[38].btnEnabled = false
             column.children[38].fontColor = "#5B5B5B"
         }
         else{
             column.children[35].btnEnabled = false
             column.children[35].fontColor = "#5B5B5B"
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

        if(!bInitScreen)
        {
            latinExtendedMode = 0;
            bInitScreen = true
        }

        //        if(checkDuplication(Qt.Key_Back) != -1)
        //        {
        //            isShift = true;
        //            isDoubleShift= false;
        //            pressedOneShift(true);
        //        }
        //        else
        //        {
        //            isShift = false;
        //            isDoubleShift= false;
        //            resetShiftsPress(true);
        //        }
        isShift = false;
        isDoubleShift= false;
        resetShiftsPress(true);


        translate.changeLang( "EuLatinExt", latinExtendedMode, isShift )

        checkDisableButton()

        translate.printLogMessage("retranslateUi: latinExtendedMode" + latinExtendedMode )

        if(latinExtendedMode == 2){
            column.children[36].keytext = screenRepeater.getLaunchText1()
            column.children[37].keytext = screenRepeater.getLaunchText2()
            column.children[38].keytext = screenRepeater.getLaunchText3()
            column.children[39].keytext = screenRepeater.getLaunchText4()
            column.children[38].fontColor = "#5B5B5B"
        }
        else{
            column.children[33].keytext = screenRepeater.getLaunchText1()
            column.children[34].keytext = screenRepeater.getLaunchText2()
            column.children[35].keytext = screenRepeater.getLaunchText3()
            column.children[36].keytext = screenRepeater.getLaunchText4()
            column.children[35].fontColor = "#5B5B5B"
        }



        updateButton("")
    }

    function retranslateUiByLatinExtendedToggle()
    {
        translate.changeLang( "EuLatinExt", latinExtendedMode, isShift  )

        checkDisableButton()

        translate.printLogMessage("retranslateUiByLatinExtendedToggle: latinExtendedMode" + latinExtendedMode )
        if(latinExtendedMode == 2){
            column.children[36].keytext = screenRepeater.getLaunchText1()
            column.children[37].keytext = screenRepeater.getLaunchText2()
            column.children[38].keytext = screenRepeater.getLaunchText3()
            column.children[39].keytext = screenRepeater.getLaunchText4()
            column.children[38].fontColor = "#5B5B5B"
            currentFocusIndex = 25
        }
        else{
            column.children[33].keytext = screenRepeater.getLaunchText1()
            column.children[34].keytext = screenRepeater.getLaunchText2()
            column.children[35].keytext = screenRepeater.getLaunchText3()
            column.children[36].keytext = screenRepeater.getLaunchText4()
            column.children[35].fontColor = "#5B5B5B"
            currentFocusIndex = 23
        }

        updateButton("")
    }

    function latinExtendedToggleProcessing()
    {
        if ( latinExtendedMode == 0)
            latinExtendedMode = 1;
        else if ( latinExtendedMode == 1)
            latinExtendedMode = 2;
        else
            latinExtendedMode = 0;

        retranslateUiByLatinExtendedToggle()
    }

    function shiftProcessing()
    {
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

        retranslateUiByLatinExtendedToggle();
    }

    onVisibleChanged:
    {
        if(!visible)
            bInitScreen = false
    }
}
