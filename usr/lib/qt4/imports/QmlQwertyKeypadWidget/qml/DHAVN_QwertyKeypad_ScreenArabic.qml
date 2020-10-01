import QtQuick 1.1
import qwertyKeypadUtility 1.0

Item{
    id: scrTop

    property bool bInitScreen: false
    property int  transitDirection: -1
    property bool isFocusedBtnSelected: false
    property bool isFocusedBtnLongPressed: false
    property bool isLongPressed: false //added for ITS 244746 for Long Press remain Focus Issue
    property int keypadType: -1
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

    function getKeypadModel()
    {
        switch(keypadType)
        {
        case 0: return arabic_type0_keypad_model.keypad
        case 1: return arabic_type1_keypad_model.keypad
        default: return null
        }
    }

    DHAVN_QwertyKeypad_ModelArabic_Type0{
        id: arabic_type0_keypad_model
    }

    DHAVN_QwertyKeypad_ModelArabic_Type1{
        id: arabic_type1_keypad_model
    }

    Item{
        id: column

        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left : parent.left
        anchors.leftMargin: ( keypadType==0 ) ? 11 : 8

        Repeater{
            id: buttonRepeater
            model: getKeypadModel()
            delegate:
                DHAVN_QwertyKeypad_Button_Delegate{
                btnid: btn_id;
                width: btn_width
                height:btn_height;
                x: btnXpos; y: btnYpos
                suffix: btn_suffix; keytext: btn_text
                btnEnabled: btn_Enabled
                keycode: btn_keycode
                transitionIndex: trn_index
                fontSize: btn_fontSize
                textVerticalOffSet: textOffSet

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
                           scrTop.keyPressAndHold( btn_keycode,  "" ) ;                           
                       }
                    }
                    else
                    {
                        scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    }
                    //scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                    //added(modified) for ITS 223849 Beep sound twice issue
                    //if (btn_keycode == Qt.Key_Back)
                    //    scrTop.keyPressAndHold( btn_keycode, "");
                    //else
                    //    scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
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


                            scrTop.keyPressAndHold( btn_keycode, "" );
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

                        if(longPressFlag)
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
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    redrawJogCenterRelease(false);

                    if(prevFocusIndex != currentFocusIndex)
                        return

                    if (btn_keycode == Qt.Key_LaunchB)
                    {
                        qwerty_keypad.arabicExtendedToggleProcessing()
                        return
                    }

                    if (btn_keycode == Qt.Key_Back)
                    {      
                        scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, ""), translate.isComposing() )
                    }
                    else
                        scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                }

                function onSelectedButtonPressed()
                {
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
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    currentFocusIndex = btnid
                    prevFocusIndex = currentFocusIndex

                    if (btn_keycode == Qt.Key_LaunchB)
                    {
                        qwerty_keypad.arabicExtendedToggleProcessing()
                        return
                    }

                    if (btn_keycode == Qt.Key_Back)
                        scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, ""), translate.isComposing() )
                    else
                        scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                }

                function onSelectedButtonReleased()
                {
                    if( !btnEnabled )
                        return;

                    if (btn_keycode == Qt.Key_Launch2)
                        return;

                    redrawButtonOnKeyRelease(false);
                }
            }
        }
    }

    function disableButton(nKeycode)
    {
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
    }

    function enableButton(nKeycode)
    {
        for(var i=0; i<getKeypadModel().length; i++)
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
        for(var i=0; i<getKeypadModel().length; i++)
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
                column.children[i].fontColor = "#FAFAFA"
            }

            bCheckDisableItem = false
        }

        if(keypadType == 0)
        {
            column.children[35].btnEnabled = false
            column.children[35].fontColor = "#5B5B5B"
        }
        else
        {
            column.children[33].btnEnabled = false
            column.children[33].fontColor = "#5B5B5B"
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

    function retranslateUi( )
    {
        if(!bInitScreen)
        {
            arabicExtendedMode = 0
            isChinesePinyinListView = false
            keypadType = translate.keypadTypeAr
            translate.changeLang( "Arabic", keypadType, 0 )

            checkDisableButton()

            if(keypadType == 0)
            {
                getKeypadModel()[33].btn_text = screenRepeater.getLaunchText1()
                getKeypadModel()[35].btn_text = screenRepeater.getLaunchText2()
                getKeypadModel()[36].btn_text = screenRepeater.getLaunchText3()
                getKeypadModel()[37].btn_text = screenRepeater.getLaunchText4()

                column.children[35].fontColor = "#5B5B5B"
            }
            else
            {
                getKeypadModel()[31].btn_text = screenRepeater.getLaunchText1()
                getKeypadModel()[33].btn_text = screenRepeater.getLaunchText2()
                getKeypadModel()[34].btn_text = screenRepeater.getLaunchText3()
                getKeypadModel()[35].btn_text = screenRepeater.getLaunchText4()

                column.children[33].fontColor = "#5B5B5B"
            }

            updateButton("")

            bInitScreen = true
        }
    }

    onVisibleChanged:
    {
        if(!visible)
            bInitScreen = false
    }
}
