import QtQuick 1.1
import qwertyKeypadUtility 1.0

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

    //QwertyKeypadUtility{id: translate}

    DHAVN_QwertyKeypad_ModelLatinExtended{
        id: latin_extended_keypad_model//keypad
    }
    Item{
        id: column

        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 8

        Repeater{
            model: latin_extended_keypad_model.keypad   //keypad
            delegate:
                DHAVN_QwertyKeypad_Button_Delegate{
                btnid: btn_id;
                width: btn_width;
                height:btn_height;
                suffix: btn_suffix;
                keytext: btn_text;
                keycode: btn_keycode
                btnEnabled: btn_Enabled
                transitionIndex: trn_index;
                fontSize: btn_fontSize
                textVerticalOffSet: textOffSet
                x: btnXpos
                y: btnYpos

                onJogDialSelectPressed:
                {
                    //translate.printLogMessage("onJogDialSelectPressed.")
                    //added for CCP Delete LongPress Focus Issue
                    //if(isUpdateOnTriggered == true)
                    //{
                        //translate.printLogMessage("[QML][ScreenLatinExtended]reset Back Key Flag: ")
                        isCheckLongBackKey = false
                        isUpdateOnTriggered = false
                    //}
                    //added for CCP Delete LongPress Focus Issue
                    onJogCenterPressed()
                }

                onJogDialSelectLongPressed:
                {
                    //translate.printLogMessage("onJogDialSelectLongPressed.")
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
                    //translate.printLogMessage("onJogDialSelectReleased.")
                    //added for CCP Delete LongPress Focus Issue
                    if(isCheckLongBackKey == false)
                    {
                        onJogCenterReleased()
                    }
                    else
                    {
                        if(btn_keycode == 80)
                        {
                            onJogCenterReleasedAtLongPress()
                            isCheckLongBackKey = false
                            //translate.printLogMessage("[symbols]init at Key 0 : " )
                        }
                    }
                    //added for Long Press Input Is
                }

                MouseArea{
                    beepEnabled: btnEnabled
                    noClickAfterExited: true
                    anchors.fill: parent
                    onPressed:
                    {
                        translate.printLogMessage("[MouseArea]onPressed.")
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        onSelectedButtonPressed()
                    }
                    onClicked:
                    {
                        //translate.printLogMessage("[MouseArea]onClicked.")
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        onSelectedButtonClicked()
                    }
                    onPressAndHold:
                    {
                        //translate.printLogMessage("[MouseArea]onPressAndHold.")
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
                        //translate.printLogMessage("[MouseArea]onPressAndHold.")
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        isLongPressed = false //added for ITS 244746 for Long Press remain Focus Issue
                        if(isFocusedBtnSelected)
                            return

                        isCheckLongBackKey = false  //added for ITS 253846 Delete Long Touch Press -> CCP Jog Press State Issue
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

                        isCheckLongBackKey = false  //added for ITS 253846 Delete Long Touch Press -> CCP Jog Press State Issue
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

                    if (btn_keycode == Qt.Key_Launch3)
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

                    if (btn_keycode == Qt.Key_Launch3)
                        return;

                    if ( btn_keycode == Qt.Key_Shift )
                    {
                        shiftProcessing()
                    }

                    redrawJogCenterRelease(false)

                    if(prevFocusIndex != currentFocusIndex)
                        return

                    if ( btn_keycode != Qt.Key_Shift )
                    {                        
                        scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                    }
                }


                //added for CCP Delete LongPress Focus Issue
                function onJogCenterReleasedAtLongPress()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch3)
                        return;

                    if ( btn_keycode == Qt.Key_Shift )
                    {
                        shiftProcessing()
                    }

                    redrawJogCenterRelease(false)

                    if(prevFocusIndex != currentFocusIndex)
                        return


                }

                function onSelectedButtonPressed()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch3)
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

                    if (btn_keycode == Qt.Key_Launch3)
                        return;

                    currentFocusIndex = btnid
                    prevFocusIndex = currentFocusIndex

                    if ( btn_keycode == Qt.Key_Shift )
                    {
                        shiftProcessing()
                    }

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
                    //added for ITS 252365 Shift Button Focus Issue

                }

                function onSelectedButtonReleased()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch3)
                        return;

                    redrawButtonOnKeyRelease(false)
                }
            }


        }
    }

    function disableButton(nKeycode)
    {
        for(var i=0; i<latin_extended_keypad_model.keypad.length; i++)
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
        for(var i=0; i<latin_extended_keypad_model.keypad.length; i++)
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

        for(var i=0; i<latin_extended_keypad_model.keypad.length; i++)
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

        column.children[33].btnEnabled = false
        column.children[33].fontColor = "#5B5B5B"
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

    function retranslateUi( )
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


        translate.changeLang( "LatinExt", 0, isShift )

        checkDisableButton()

        column.children[31].keytext = screenRepeater.getLaunchText1()
        column.children[32].keytext = screenRepeater.getLaunchText2()
        column.children[33].keytext = screenRepeater.getLaunchText3()
        column.children[33].fontColor = "#5B5B5B"

        updateButton("")
    }

    function getDefaultFocusIndex()
    {
        for(var i=0; i<latin_extended_keypad_model.keypad.length; i++)
        {
            if(column.children[i].btnEnabled)
                return column.children[i].btnid
        }
    }

    function getIsCurrentItemEnabled()
    {
        return column.children[currentFocusIndex].btnEnabled
    }

    function retranslateUiByShift( )
    {
        translate.changeLang( "LatinExt", 0, isShift  )

        checkDisableButton()

        updateButton("")
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

        retranslateUiByShift();
    }
}
