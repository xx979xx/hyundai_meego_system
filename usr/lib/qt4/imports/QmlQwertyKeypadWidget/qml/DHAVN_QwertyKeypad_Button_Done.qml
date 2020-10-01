import Qt 4.7

Item{
    id: topButton
    width: root.width
    height: root.height

    signal jogDialSelectPressed( bool isPress )
    signal jogDialSelectLongPressed( bool isPress )
    signal jogDialSelectReleased( bool isPress )

    // [Hide / Space] Button
    function setEnableButton()
    {
        if(btnEnabled)
        {
            button.source = root.non_pressed_button
        }
        else
        {
            button.source = root.disable_button
        }
    }

    function getHomeBtnLeftMargin()
    {
        var retVal = 26

        if ( suffix == 'kor_done'        ) retVal = 26
        else if ( suffix == 'kor3_done'       ) retVal = 62
        else if ( suffix == 'eu_la_done'      ) retVal = 22
        else if ( suffix == 'me_done'         ) retVal = 62
        else if ( suffix == 'chn_done'        ) retVal = 91
        else if ( suffix == 'chn_done_02'     ) retVal = 26

        return retVal
    }

    Image{
        id: button
        width: parent.width
        height:parent.height

        /**Private area*/
        property bool btnFocus: ( currentFocusIndex == btnid && focus_visible && btnEnabled )
        property bool btnSelected: ( prevFocusIndex == btnid && isFocusedBtnSelected )
        property bool btnLongPressed: ( (prevFocusIndex == btnid) && isFocusedBtnSelected && isFocusedBtnLongPressed )
        property int  jogDialDirection: ( prevFocusIndex == btnid) ? transitDirection : -1
        property bool btnDisableFocus: ( currentFocusIndex == btnid && isLongPressed ) //added for ITS 244746 for Long Press remain Focus Issue
        property alias btnKnobVisible: buttonKnob.visible//added for ITS 245697 Long Press Focus Issue

        source: non_pressed_button

        Binding{
            target: buttonKnob; property: "visible"; value: ( currentFocusIndex == btnid && focus_visible && btnEnabled )
        }
        //added for ITS 245697 Long Press Focus Issue
        onBtnKnobVisibleChanged:
        {
            //translate.printLogMessage("[QML][Button_Character]onBtnKnobVisibleChanged :  " + btnKnobVisible)
            if(btnKnobVisible)
            {
                if(btnDisableFocus)
                {
                    if(btn_keycode != Qt.Key_Back)
                    {
                        //translate.printLogMessage("[QML][Button_Character]onBtnKnobVisibleChanged : true : " + btnid)
                        button.source = root.non_pressed_button
                        buttonKnob.visible = false
                    }

                }
                else
                {
                    //translate.printLogMessage("[QML][Button_Character]onBtnKnobVisibleChanged : false : " + btnid)
                }
            }

        }

        //added for ITS 244746 for Long Press remain Focus Issue
        onBtnDisableFocusChanged:
        {
            if(btnDisableFocus)
            {
                if(btn_keycode != Qt.Key_Back)
                {
                    //translate.printLogMessage("[QML][Button_Character]onBtnDisableFocusChanged : true : " + btnid)
                    button.source = root.non_pressed_button
                    buttonKnob.visible = false
                }
            }
            else
            {
                translate.printLogMessage("[QML][Button_Character]onBtnDisableFocusChanged : false : " + btnid)
            }

        }

        onBtnSelectedChanged:
        {
            if ( btnSelected )
            {
                buttonKnob.visible = false
                topButton.jogDialSelectPressed(true)
            }
            else
            {
                if(isReceivedJogCanceled)
                {
                    redrawButtonOnKeyRelease(false);
                    isReceivedJogCanceled = false
                }
                else
                {
                    topButton.jogDialSelectReleased(true)
                }
            }
        }
        onBtnLongPressedChanged: {
            //added(modified) for ITS 223849 Beep sound twice issue
            //topButton.jogDialSelectLongPressed(true)
            if(btnLongPressed)
            {
                topButton.jogDialSelectLongPressed(true)
            }
            else
            {
                topButton.jogDialSelectLongPressed(false)
            }
            //added(modified) for ITS 223849 Beep sound twice issue
        }

        onJogDialDirectionChanged:
        {
            if ( jogDialDirection >= 0 )
            {
                currentFocusIndex = getNextItemEnabled(transitionIndex[jogDialDirection], jogDialDirection)
            }
        }

        Connections{
            target: qwerty_keypad

            onResetButtonUI:
            {
                if(btnEnabled)
                    button.source = root.non_pressed_button
                else
                    button.source = root.disable_button
            }
        }

        Image {
            id: homeBtn
            z: 5
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.left: parent.left
            anchors.leftMargin: getHomeBtnLeftMargin()
            source: (doneButtonType == "Search") ?
                        ((btnEnabled)? "/app/share/images/Qwertykeypad/" + "icon_keypad_search_n.png" : "/app/share/images/Qwertykeypad/" + "icon_keypad_search_d.png") :
                        ((btnEnabled)? "/app/share/images/Qwertykeypad/" + "icon_keypad_enter_n.png" : "/app/share/images/Qwertykeypad/" + "icon_keypad_enter_d.png" )
            visible: (keycode == Qt.Key_Home)
        }

        Image{
            id: buttonKnob

            anchors.centerIn: parent;

            source: knob_button
            visible: false
        }
    }

    function redrawButtonOnKeyPress()
    {
        button.source = root.pressed_button

        buttonKnob.visible = false
    }

    function redrawButtonOnKeyRelease(isDoubleShifted)
    {
        button.source = root.non_pressed_button
        if(currentFocusIndex == btnid && focus_visible && btnEnabled) buttonKnob.visible = true
    }

    function redrawJogCenterPress()
    {
        button.source = root.focus_pressed_button
        buttonKnob.visible = false
    }

    function redrawJogCenterRelease(isDoubleShifted)
    {
        button.source = root.non_pressed_button
        if(currentFocusIndex == btnid && focus_visible && btnEnabled) buttonKnob.visible = true
    }

    function changeButtonIncreased(symbol){
        text1.text = symbol
    }
}
