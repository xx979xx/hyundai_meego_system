import QtQuick 1.1
import qwertyKeypadUtility 1.0
import "DHAVN_QwertyKeypad.js" as QKC

Item{
    id: scrTop

    property int keypadType: -1
    property int  transitDirection: -1
    property bool isFocusedBtnSelected: false
    property bool isFocusedBtnLongPressed: false
    property string btnTextOrigin: ""
    property bool isExited: false

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

    //QwertyKeypadUtility { id: translate }

    DHAVN_QwertyKeypad_ModelEnglish_Q{
        id: korean_qwerty_keypad_model
    }
    DHAVN_QwertyKeypad_ModelKorean_A{
        id: korean_abcd_keypad_model
    }

    DHAVN_QwertyKeypad_ModelEnglish_Q_For_Arabic{
        id: arabic_korean_qwerty_keypad_model
    }

    DHAVN_QwertyKeypad_ModelKorean_A_For_Arabic{
        id: arabic_korean_abcd_keypad_model
    }

    function getKeypadModel()
    {
        switch(translate.country)
        {
        case QKC.const_QWERTY_COUNTRY_ME:
        {
            switch(keypadType)
            {
            case 0: return arabic_korean_qwerty_keypad_model.keypad
            case 1: return arabic_korean_abcd_keypad_model.keypad
            default: return null
            }
        }
        default:
        {
            switch(keypadType)
            {
            case 0: return korean_qwerty_keypad_model.keypad
            case 1: return korean_abcd_keypad_model.keypad
            default: return null
            }
        }
        }
    }

    Item{
        id: column

        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left : parent.left
        anchors.leftMargin: 8

        Repeater{
            model: getKeypadModel()
            delegate:
                DHAVN_QwertyKeypad_Button_Delegate{
                btnid: btn_id;
                width: btn_width
                height:btn_height;
                suffix: btn_suffix;
                keytext: btn_text;
                keycode: btn_keycode
                btnEnabled: btn_Enabled
                transitionIndex: trn_index
                x: btnXpos
                y: btnYpos

                fontSize: btn_fontSize
                textVerticalOffSet: textOffSet

                onJogDialSelectPressed:
                {
                    //translate.printLogMessage("[QML][ScreenKorean]onJogDialSelectPressed: " + btn_keycode)
                    //added for CCP Delete LongPress Focus Issue
                    //if(isUpdateOnTriggered == true)
                    //{
                        //translate.printLogMessage("[QML][ScreenKorean]reset Back Key Flag: ")
                        isCheckLongBackKey = false
                        isUpdateOnTriggered = false
                    //}
                    //added for CCP Delete LongPress Focus Issue
                    onJogCenterPressed()
                }

                onJogDialSelectLongPressed:
                {

                    //translate.printLogMessage("[QML][ScreenKorean]onJogDialSelectLongPressed")
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
                    //translate.printLogMessage("[QML][ScreenKorean]onJogDialSelectReleased: " + btn_keycode + longPressFlag )
                    //added for CCP Delete LongPress Focus Issue
                    if(isCheckLongBackKey == false)
                    {

                        onJogCenterReleased()
                        //translate.printLogMessage("[ScreenKorean]isCheckLongBackKey == false " )
                    }
                    else
                    {

                        if(btn_keycode == 81 || btn_keycode == 80 )
                        {
                            onJogCenterReleasedAtLongPress()
                            isCheckLongBackKey = false
                            //translate.printLogMessage("[ScreenKorean]init at Key 0 : " )
                        }


                    }
                    //added for CCP Delete LongPress Focus Issue
                }

                MouseArea{
                    anchors.fill: parent
                    beepEnabled: btnEnabled
                    noClickAfterExited: true
                    onPressed:
                    {
                        //translate.printLogMessage("[QML][ScreenKorean]onPressed")

                        //translate.printLogMessage("[QML]screenKorean : onPressed : btnid :" + btnid)
                        //translate.printLogMessage("[QML]screenKorean : onPressed : currentFocusIndex :" + currentFocusIndex)
                        //translate.printLogMessage("[QML]screenKorean : onPressed : prevFocusIndex:" + prevFocusIndex)
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        onSelectedButtonPressed()
                    }
                    onClicked:
                    {
                        //translate.printLogMessage("[QML][ScreenKorean]onClicked")
                        //console.log("[QML]screenKorean : onClicked")
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        if(isFocusedBtnSelected)
                            return

                        onSelectedButtonClicked()
                    }
                    onPressAndHold:
                    {
                        //translate.printLogMessage("[QML][ScreenKorean]onPressAndHold")
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        //console.log("[QML]screenKorean : onPressAndHold")
                        if(isFocusedBtnSelected)
                            return

                        if( !btnEnabled )
                            return;

                        if(btn_keycode == Qt.Key_Back)
                        {
                            //translate.printLogMessage("[QML]screenKorean : onPressAndHold : btn_keycode == Qt.Key_Back")
                            //translate.printLogMessage("[QML]screenKorean : onPressAndHold : btnid :" + btnid)
                            //translate.printLogMessage("[QML]screenKorean : onPressAndHold : currentFocusIndex :" + currentFocusIndex)
                            //translate.printLogMessage("[QML]screenKorean : onPressAndHold : prevFocusIndex :" + prevFocusIndex)
                            
							isLongPressed = true //added for ITS 244746 for Long Press remain Focus Issue
                            
							//currentFocusIndex = btnid //added for ITS 244746 Back Long Press Focus Issue
                            //prevFocusIndex = currentFocusIndex //added for ITS 244746 Back Long Press Focus Issue
                            longPressFlag = true //added for Delete Long Press Spec Modify
                            scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );

                        }
                        else
                            longPressFlag = true
                    }

                    onReleased:
                    {
                        //translate.printLogMessage("[QML][ScreenKorean]onReleased")
                        //translate.printLogMessage("[QML]screenKorean : onReleased : btnid :" + btnid)
                        //translate.printLogMessage("[QML]screenKorean : onReleased : currentFocusIndex :" + currentFocusIndex)
                        //translate.printLogMessage("[QML]screenKorean : onReleased : prevFocusIndex :" + prevFocusIndex)
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                        //console.log("[QML]screenKorean : onReleased : ")

                        isLongPressed = false //added for ITS 244746 for Long Press remain Focus Issue

                        if(isFocusedBtnSelected)
                            return

                        isCheckLongBackKey = false  //added for ITS 253846 Delete Long Touch Press -> CCP Jog Press State Issue
                        if (longPressFlag)
                        {
                            //console.log("[QML]screenKorean : longPressFlag : ")
                            onSelectedButtonClicked()
                            longPressFlag = false

                            //added for ITS 247594 Long Touch Beep Issue
                            if(btnEnabled)
                                translate.callAudioBeepCommand();
                        }

                        onSelectedButtonReleased()
                        if(isExited) isExited= false
                    }

                    onExited:
                    {
                        isLongPressed = false //added for ITS 244746 for Long Press remain Focus Issue
                        // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
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
                        isExited = true
                        longPressFlag = false
                        onSelectedButtonReleased()
                    }
                }
                function onJogCenterPressed()
                {
                    //translate.printLogMessage("[QML][ScreenKorean]onJogCenterPressed")
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    if (btn_keycode == Qt.Key_Launch4)
                    {
                        //changeButtonIncreased(comma[comma_timer.type])
                        comma_timer.isPressed = true
                    }

                    redrawJogCenterPress();
                    scrTop.keyPress( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                }

                function onJogCenterReleased()
                {
                    //translate.printLogMessage("[QML][ScreenKorean]onJogCenterReleased")
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    if (btn_keycode == Qt.Key_Shift)
                    {
                        if (translate.keypadTypeKo != 0)
                            return;

                        shiftProcessing();
                    }

                    if ( translate.keypadTypeKo == 0 )
                    {
                        if ( btn_text == "STR_KEYPAD_TYPE_Q" ||
                                btn_text == "STR_KEYPAD_TYPE_W" ||
                                btn_text == "STR_KEYPAD_TYPE_E" ||
                                btn_text == "STR_KEYPAD_TYPE_R" ||
                                btn_text == "STR_KEYPAD_TYPE_T" ||
                                btn_text == "STR_KEYPAD_TYPE_O" ||
                                btn_text == "STR_KEYPAD_TYPE_P" )
                        {
                            if ((isShift == true) && (isDoubleShift == true))
                            {
                                redrawJogCenterRelease(true);
                            }
                            else
                            {
                                redrawJogCenterRelease(false);
                            }
                        }
                        else
                        {
                            redrawJogCenterRelease(false);
                        }
                    }
                    else    // Type2
                    {
                        redrawJogCenterRelease(false);
                    }

                    if(prevFocusIndex == currentFocusIndex)
                    {
                        // Shift
                        if ( btn_keycode != Qt.Key_Shift )
                        {
                            //modified for ITS 224092 Kor Automata not delete
                            if (btn_keycode == Qt.Key_Back)
                            {                                
                                scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, ""), translate.isComposing() )
                            }
                            else
                                scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )

                            //scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                            //modified for ITS 224092 Kor Automata not delete
                        }
                    }

                    if ( btn_text == "STR_KEYPAD_TYPE_Q_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_W_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_E_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_R_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_T_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_O_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_P_PRESS_AND_HOLD" )
                    {
                        btn_text = btnTextOrigin
                    }
                }


                //added for CCP Delete LongPress Focus Issue
                function onJogCenterReleasedAtLongPress()
                {
                    //translate.printLogMessage("[QML][ScreenKorean]onJogCenterReleased")
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    if (btn_keycode == Qt.Key_Shift)
                    {
                        if (translate.keypadTypeKo != 0)
                            return;

                        shiftProcessing();
                    }

                    if ( translate.keypadTypeKo == 0 )
                    {
                        if ( btn_text == "STR_KEYPAD_TYPE_Q" ||
                                btn_text == "STR_KEYPAD_TYPE_W" ||
                                btn_text == "STR_KEYPAD_TYPE_E" ||
                                btn_text == "STR_KEYPAD_TYPE_R" ||
                                btn_text == "STR_KEYPAD_TYPE_T" ||
                                btn_text == "STR_KEYPAD_TYPE_O" ||
                                btn_text == "STR_KEYPAD_TYPE_P" )
                        {
                            if ((isShift == true) && (isDoubleShift == true))
                            {
                                redrawJogCenterRelease(true);
                            }
                            else
                            {
                                redrawJogCenterRelease(false);
                            }
                        }
                        else
                        {
                            redrawJogCenterRelease(false);
                        }
                    }
                    else    // Type2
                    {
                        redrawJogCenterRelease(false);
                    }


                    if ( btn_text == "STR_KEYPAD_TYPE_Q_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_W_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_E_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_R_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_T_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_O_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_P_PRESS_AND_HOLD" )
                    {
                        btn_text = btnTextOrigin
                    }
                }

                function onSelectedButtonPressed()
                {
                    //translate.printLogMessage("[QML][ScreenKorean]onSelectedButtonPressed")
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    if (btn_keycode == Qt.Key_Launch4)
                    {
                        //changeButtonIncreased(comma[comma_timer.type])
                        comma_timer.isPressed = true
                    }

                    redrawButtonOnKeyPress();
                    scrTop.keyPress( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                }

                function onSelectedButtonClicked()
                {
                    //translate.printLogMessage("[QML][ScreenKorean]onSelectedButtonClicked")
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    if (btn_keycode == Qt.Key_Shift)
                    {
                        if (translate.keypadTypeKo != 0)
                            return;

                        shiftProcessing();
                    }

                    currentFocusIndex = btnid
                    prevFocusIndex = currentFocusIndex

                    // TYPE 1
                    if ( translate.keypadTypeKo == 0 )
                    {
                        if ( btn_text == "STR_KEYPAD_TYPE_Q" ||
                                btn_text == "STR_KEYPAD_TYPE_W" ||
                                btn_text == "STR_KEYPAD_TYPE_E" ||
                                btn_text == "STR_KEYPAD_TYPE_R" ||
                                btn_text == "STR_KEYPAD_TYPE_T" ||
                                btn_text == "STR_KEYPAD_TYPE_O" ||
                                btn_text == "STR_KEYPAD_TYPE_P" )
                        {
                            if ((isShift == true) && (isDoubleShift == true))
                            {
                                redrawButtonOnKeyRelease(true);
                            }
                            else
                            {
                                redrawButtonOnKeyRelease(false);
                            }
                        }
                        else
                        {
                            redrawButtonOnKeyRelease(false);
                        }
                    }
                    else    // Type 2
                    {
                        redrawButtonOnKeyRelease(false);
                    }

                    if ( btn_keycode != Qt.Key_Shift )
                    {
                        //modified for ITS 224092 Kor Automata not delete
                        if (btn_keycode == Qt.Key_Back)
                            scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, ""), translate.isComposing() )
                        else
                            scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )

                        //scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                        //modified for ITS 224092 Kor Automata not delete
                    }//added for ITS 252365 Shift Button Focus Issue
                    else
                    {
                         qwerty_keypad.keyReleased(btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing());
                         //qwerty_keypad.enableShiftButton(); //added for ITS 252365 Shift Button Focus Issue
                    }
                    //added for ITS 252365 Shift Button Focus Issue
                    if ( btn_text == "STR_KEYPAD_TYPE_Q_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_W_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_E_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_R_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_T_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_O_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_P_PRESS_AND_HOLD" )
                    {
                        btn_text = btnTextOrigin
                    }
                }

                function onSelectedButtonReleased()
                {
                    //console.log("[QML]screenKorean : onSelectedButtonReleased : ")



                    if( !btnEnabled )
                    {
                        //console.log("[QML]screenKorean: !btnEnabled ----")
                        return;
                    }

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    if ( translate.keypadTypeKo == 0 )
                    {
                        if ( btn_text == "STR_KEYPAD_TYPE_Q" ||
                                btn_text == "STR_KEYPAD_TYPE_W" ||
                                btn_text == "STR_KEYPAD_TYPE_E" ||
                                btn_text == "STR_KEYPAD_TYPE_R" ||
                                btn_text == "STR_KEYPAD_TYPE_T" ||
                                btn_text == "STR_KEYPAD_TYPE_O" ||
                                btn_text == "STR_KEYPAD_TYPE_P" )
                        {
                            if ((isShift == true) && (isDoubleShift == true))
                            {
                                redrawButtonOnKeyRelease(true);
                            }
                            else
                            {
                                if( isExited && isShift )
                                    redrawButtonOnKeyRelease(true);
                                else
                                    redrawButtonOnKeyRelease(false);
                            }
                        }
                        else
                        {
                            redrawButtonOnKeyRelease(false);
                        }
                    }
                    else    // Type2
                    {
                        redrawButtonOnKeyRelease(false);
                    }

                    if ( btn_text == "STR_KEYPAD_TYPE_Q_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_W_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_E_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_R_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_T_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_O_PRESS_AND_HOLD" ||
                            btn_text == "STR_KEYPAD_TYPE_P_PRESS_AND_HOLD" )
                    {
                        btn_text = btnTextOrigin
                    }
                }

            }
        }
    }

    function getIsCurrentItemEnabled()
    {
        //translate.printLogMessage("[QML][ScreenKorean]getIsCurrentItemEnabled")
        //console.log("[LBG] getIsCurrentItemEnabled start" + translate.currentTime())
        return column.children[currentFocusIndex].btnEnabled
        //console.log("[LBG] getIsCurrentItemEnabled end" + translate.currentTime())
    }

    function getDefaultFocusIndex()
    {
        //translate.printLogMessage("[QML][ScreenKorean]getDefaultFocusIndex")
        //console.log("[LBG] getIsCurrentItemEnabled start" + translate.currentTime())
        for(var i=0; i<getKeypadModel().length; i++)
        {
            if(column.children[i].btnEnabled)
                return column.children[i].btnid
        }
        //console.log("[LBG] getIsCurrentItemEnabled end" + translate.currentTime())
    }

    function changeShiftCharacterColor( colorString )
    {
        //translate.printLogMessage("[QML][ScreenKorean]changeShiftCharacterColor")
        //console.log("[LBG] changeShiftCharacterColor start" + translate.currentTime())
        var i;
        for( i = 0; i < 5; i++){
            column.children[i].fontColor = colorString;
        }
        for( i = 8; i < 10; i++){
            column.children[i].fontColor = colorString;
        }
        //console.log("[LBG] changeShiftCharacterColor end" + translate.currentTime())
    }

    function disableButton(nKeycode)
    {
        //console.log("[LBG] disableButton start" + translate.currentTime())
        for(var i=0; i<getKeypadModel().length; i++)
        {
            if(nKeycode == column.children[i].keycode
                    || nKeycode == qsTranslate( "DHAVN_QwertyKeypad_Screen", column.children[i].keytext ))
            {
                column.children[i].btnEnabled = false
                column.children[i].fontColor = "#5B5B5B"
            }
        }

        updateButton("")
        //console.log("[LBG] disableButton end" + translate.currentTime())
    }

    function enableButton(nKeycode)
    {
        //translate.printLogMessage("[QML][ScreenKorean]enableButton")
        //console.log("[LBG] enableButton start" + translate.currentTime())
        for(var i=0; i<getKeypadModel().length; i++)
        {
            if( (nKeycode == column.children[i].keycode)
                    || (nKeycode == qsTranslate( "DHAVN_QwertyKeypad_Screen", column.children[i].keytext )) )
            {
                column.children[i].btnEnabled = true
                column.children[i].fontColor = "#FAFAFA"
            }
        }

        updateButton("")
        //console.log("[LBG] enableButton end" + translate.currentTime())
    }

    function checkDisableButton()
    {
        //translate.printLogMessage("[QML][ScreenKorean]checkDisableButton")
        //console.log("[LBG] checkDisableButton start" + translate.currentTime())
        var bCheckDisableItem = false

        for(var i=0; i<getKeypadModel().length; i++)
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

                if(isShift)
                    column.children[i].fontColor = "##7CBDFF"
                else
                    column.children[i].fontColor = "#FAFAFA"
            }

            bCheckDisableItem = false
        }

        if( keypadType == 0 )
        {
            column.children[30].btnEnabled = false
            column.children[30].fontColor = "#5B5B5B"
        }
        else
        {
            column.children[36].btnEnabled = false
            column.children[36].fontColor = "#5B5B5B"
        }

        //console.log("[LBG] checkDisableButton end" + translate.currentTime())
    }

    function retranslateUi( )
    {
        //translate.printLogMessage("[QML][ScreenKorean]retranslateUi")
        //console.log("[LBG] retranslateUi start" + translate.currentTime())
        isChinesePinyinListView = false

        keypadType = translate.keypadTypeKo
        translate.changeLang( "Korean", keypadType,  0 )

        isShift = false;
        isDoubleShift = false;
        resetShiftsPress( true );
        changeShiftCharacterColor("#FAFAFA");

        checkDisableButton()

        if( keypadType == 0 )
        {
            column.children[29].keytext = screenRepeater.getLaunchText1()
            column.children[30].keytext = screenRepeater.getLaunchText2()
            column.children[31].keytext = screenRepeater.getLaunchText3()

            column.children[30].fontColor = "#5B5B5B"
        }
        else
        {
            column.children[35].keytext = screenRepeater.getLaunchText1()
            column.children[36].keytext = screenRepeater.getLaunchText2()
            column.children[37].keytext = screenRepeater.getLaunchText3()

            column.children[36].fontColor = "#5B5B5B"
        }

        updateButton("")
        //console.log("[LBG] retranslateUi end" + translate.currentTime())
    }

    function retranslateUiByShift( )
    {
        //translate.printLogMessage("[QML][ScreenKorean]retranslateUiByShift")
        keypadType = translate.keypadTypeKo
        translate.changeLang( "Korean", keypadType, ( keypadType== 0)? isShift : 0 )

        checkDisableButton()

        updateButton("")
    }

    function getNextItemEnabled(nNextIndex, nDirectionIndex)
    {
        //console.log("[LBG] getNextItemEnabled start" + translate.currentTime())

        if(column.children[nNextIndex].btnEnabled) // enabled button
            return nNextIndex
        else                                          // disabled button
        {
            if(nNextIndex == column.children[nNextIndex].transitionIndex[nDirectionIndex])
                return currentFocusIndex

            return getNextItemEnabled(column.children[nNextIndex].transitionIndex[nDirectionIndex], nDirectionIndex)
        }
        //console.log("[LBG] getNextItemEnabled end" + translate.currentTime())
    }

    function shiftProcessing()
    {
        //translate.printLogMessage("[QML][ScreenKorean]shiftProcessing")
        if ( isDoubleShift )
        {
            //translate.printLogMessage("[QML][ScreenKorean]shiftProcessing:: isDoubleShift")
            isDoubleShift= false;
            isShift = false;
            resetShiftsPress(true);
            changeShiftCharacterColor("#FAFAFA");
        }
        else if ( isShift )
        {
            //translate.printLogMessage("[QML][ScreenKorean]shiftProcessing:: isShift")
            isDoubleShift = true;
            pressedTwoShifts(true);
        }
        else
        {
            isShift = true
            pressedOneShift(true);
            changeShiftCharacterColor("#7CBDFF");
        }

        retranslateUiByShift();
    }
    //added for ITS 244662 Shift Font Color Issue
    Connections{
        target:qwerty_keypad
        onRedrawShiftKeyFontColor:{
            //translate.printLogMessage("[QML][ScreenKorean]onRedrawShiftKeyFontColor : " + _index)
            if(isDoubleShift || isShift)
                changeShiftCharacterColor("#7CBDFF");

        }


        //added for CCP Delete LongPress Focus Issue
        onKeyJogCanceled:{
            translate.printLogMessage("[ScreenKorean]onKeyCanceled.")
            /** Add Center Long Press Stop Logic **/

        }
    }
    //added for ITS 244662 Shift Font Color Issue
}
