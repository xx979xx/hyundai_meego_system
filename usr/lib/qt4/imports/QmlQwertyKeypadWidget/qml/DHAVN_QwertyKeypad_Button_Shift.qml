import Qt 4.7

Item{
    id: topButton
    width: root.width
    height: root.height

    signal jogDialSelectPressed( bool isPress )
    signal jogDialSelectLongPressed( bool isPress )
    signal jogDialSelectReleased( bool isPress )

    // Shift 비활성화의 경우, 중국향 성음 키보드화면에서만 존재
    function setEnableButton()
    {
        if(!btnEnabled)
        {
            if(keycode == Qt.Key_Shift)
            {
                button.source = root.disable_lock_button
            }
        }
    }

    function getFocusedImageSource()
    {
        if(isShift)
        {
            if(isDoubleShift)
                return knob_lock_button;
            else
                return knob_sel_button
        }
        else
        {
            return knob_button;
        }
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
                        translate.printLogMessage("[QML][Button_shift]onBtnKnobVisibleChanged : true : " + btnid)
                        //added for Shift lock Image change Issue
                        if( isShift )
                        {
                            if(isDoubleShift){
                                button.source = root.non_pressed_lock_button
                                translate.printLogMessage("[QML][Button_shift]onBtnKnobVisibleChanged : isDoubleShift : " )
                            }
                        }
                        else
                        {
                            translate.printLogMessage("[QML][Button_shift]onBtnKnobVisibleChanged : isDoubleShift : else " )
                            button.source = root.non_pressed_button
                        }
                        //added for Shift lock Image change Issue

                        //button.source = root.non_pressed_button
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
                    translate.printLogMessage("[QML][Button_shift]onBtnDisableFocusChanged : true : " + btnid)
                    //added for Shift lock Image change Issue
                    if( isShift )
                    {
                        if(isDoubleShift){
                            button.source = root.non_pressed_lock_button
                            translate.printLogMessage("[QML][Button_shift]onBtnDisableFocusChanged : isDoubleShift : " )
                        }
                    }
                    else
                    {
                        translate.printLogMessage("[QML][Button_shift]onBtnDisableFocusChanged : isDoubleShift : else " )
                        button.source = root.non_pressed_button
                    }
                    //added for Shift lock Image change Issue
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

            onPressedOneShift:
            {
                button.source = root.non_pressed_sel_button
            }

            onPressedTwoShifts:
            {
                button.source = root.non_pressed_lock_button
            }

            onResetShiftsPress:
            {
                button.source = root.non_pressed_button
            }
            //added for ITS 252365
            onEnableShiftButton:
            {
                //translate.printLogMessage("[button_shift]Enable Shift Button")
                buttonKnob.visible = true
            }


        }

        Image{
            id: buttonKnob

            anchors.centerIn: parent;

            source: getFocusedImageSource()
            visible: false
        }
    }


    function redrawButtonOnKeyPress()
    {
        if( isShift )
        {
            if(isDoubleShift)
                button.source = root.pressed_lock_button
            else
                button.source = root.pressed_sel_button
        }
        else
        {
            button.source = root.pressed_button
        }

        buttonKnob.visible = false
    }

    function redrawButtonOnKeyRelease(isDoubleShifted)
    {
        if( isShift )
        {
            if(isDoubleShift)
                button.source = root.non_pressed_lock_button
            else
                button.source = root.non_pressed_sel_button
        }
        else
        {
            button.source = non_pressed_button
        }

        if(currentFocusIndex == btnid && focus_visible && btnEnabled)
            buttonKnob.visible = true
    }

    function redrawJogCenterPress()
    {
        if( isShift )
        {
            if(isDoubleShift)
                button.source = root.focus_pressed_lock_button
            else
                button.source = root.focus_pressed_sel_button
        }
        else
        {
            button.source = root.focus_pressed_button
        }

        buttonKnob.visible = false
    }

    function redrawJogCenterRelease(isDoubleShifted)
    {
        if( isShift )
        {
            if(isDoubleShift)
                button.source = root.non_pressed_lock_button
            else
                button.source = root.non_pressed_sel_button
        }
        else
        {
            button.source = root.non_pressed_button
        }

        if(currentFocusIndex == btnid && focus_visible && btnEnabled)
            buttonKnob.visible = true
    }
}
