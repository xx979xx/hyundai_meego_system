import QtQuick 1.1
import qwertyKeypadUtility 1.0

Item{
    id: scrTop

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

    DHAVN_QwertyKeypad_ModelEuropean_Cyrillic
    {
        id: cyrillic_keypad_model
    }

    Item{
        id: column

        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left : parent.left
        anchors.leftMargin: 11

        Repeater{
            model: cyrillic_keypad_model.keypad
            delegate:
                DHAVN_QwertyKeypad_Button_Delegate{
                btnid: btn_id; width: btn_width; height:btn_height;
                suffix: btn_suffix; keytext: btn_text;
                keycode: btn_keycode
                btnEnabled: btn_Enabled
                transitionIndex: trn_index

                fontSize: btn_fontSize
                textVerticalOffSet: textOffSet
                x: btnXpos
                y: btnYpos

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

                    if ( btn_keycode == Qt.Key_Launch6 )
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

                    if ( btn_keycode == Qt.Key_Launch6 )
                        return;

                    if ( btn_keycode == Qt.Key_Shift )
                    {
                        shiftProcessing()
                    }

                    if ( btn_keycode == Qt.Key_LaunchA )
                    {
                        cyrillicExtendedToggleProcessing()
                    }

                    redrawJogCenterRelease(false)

                    if(prevFocusIndex != currentFocusIndex)
                        return

                    if ( btn_keycode != Qt.Key_Shift && btn_keycode != Qt.Key_LaunchA)
                    {                        
                        scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                    }
                }

                function onSelectedButtonPressed()
                {
                    if( !btnEnabled )
                        return;

                    if ( btn_keycode == Qt.Key_Launch6 )
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

                    if ( btn_keycode == Qt.Key_Launch6 )
                        return;

                    currentFocusIndex = btnid
                    prevFocusIndex = currentFocusIndex

                    if ( btn_keycode == Qt.Key_Shift )
                    {
                        shiftProcessing()
                    }

                    if ( btn_keycode == Qt.Key_LaunchA )
                    {
                        cyrillicExtendedToggleProcessing()
                    }

                    redrawButtonOnKeyRelease(false)

                    if ( btn_keycode != Qt.Key_Shift && btn_keycode != Qt.Key_LaunchA)
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

                    if ( btn_keycode == Qt.Key_Launch6 )
                        return;

                    redrawButtonOnKeyRelease(false)
                }
            }


        }
    }

    function disableButton(nKeycode)
    {
        for(var i=0; i<cyrillic_keypad_model.keypad.length; i++)
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
        for(var i=0; i<cyrillic_keypad_model.keypad.length; i++)
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
        for(var i=0; i<cyrillic_keypad_model.keypad.length; i++)
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
        var bCheckDisableItem = false

        for(var i=0; i<cyrillic_keypad_model.keypad.length; i++)
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

        column.children[40].btnEnabled = false
        column.children[40].fontColor = "#5B5B5B"

        if(cyrillicExtendedMode == 1)
        {
            for( i=14; i<25; i++ )
            {
                column.children[i].btnEnabled = false
            }

            for( i=27; i<35; i++ )
            {
                column.children[i].btnEnabled = false
            }
        }
        else
        {
            for( i=14; i<25; i++ )
            {
                column.children[i].btnEnabled = true
            }

            for( i=27; i<35; i++ )
            {
                column.children[i].btnEnabled = true
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


        if(!bInitScreen)
        {
            translate.changeLang( "EuCyrillic", translate.keypadTypeRu, isShift  )
            cyrillicExtendedMode = 0
            bInitScreen = true
        }
        else
        {
            if(cyrillicExtendedMode == 0)
            {
                translate.changeLang( "EuCyrillic", translate.keypadTypeRu, isShift  )
            }
            else
            {
                translate.changeLang( "EuCyrillicExt", translate.keypadTypeRu, isShift  )
            }
        }

        checkDisableButton()

        column.children[37].keytext = screenRepeater.getLaunchText1()
        column.children[38].keytext = screenRepeater.getLaunchText2()
        column.children[39].keytext = screenRepeater.getLaunchText3()
        column.children[40].keytext = screenRepeater.getLaunchText4()
        column.children[40].fontColor = "#5B5B5B"
        updateButton("")
    }

    function changeLanguage()
    {
        if(cyrillicExtendedMode == 0)
        {
            translate.changeLang( "EuCyrillic", translate.keypadTypeRu, isShift  )
        }
        else
        {
            translate.changeLang( "EuCyrillicExt", translate.keypadTypeRu, isShift  )
        }
    }

    function retranslateUiByCyrillicExtendedToggle()
    {
        changeLanguage()

        checkDisableButton()

        updateButton("")
    }

    function cyrillicExtendedToggleProcessing()
    {
        if ( cyrillicExtendedMode == 0)
            cyrillicExtendedMode = 1;
        else if ( cyrillicExtendedMode == 1)
            cyrillicExtendedMode = 0;

        retranslateUiByCyrillicExtendedToggle()
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

        retranslateUiByCyrillicExtendedToggle();
    }

    onVisibleChanged:
    {
        if(!visible)
            bInitScreen = false
    }
}
