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
            if(keycode == Qt.Key_Launch0 || keycode == Qt.Key_Space || keycode == Qt.Key_Home || keycode == Qt.Key_Back || suffix=='chn_left' || suffix=='chn_right')
                button.source = root.non_pressed_button
        }
        else
        {
            if(keycode == Qt.Key_Launch0 || keycode == Qt.Key_Space || keycode == Qt.Key_Home || keycode == Qt.Key_Back || suffix=='chn_left' || suffix=='chn_right')
            {
                button.source = root.disable_button
            }
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
                //                if(btnid != 27)
                //                {
                //                    translate.printLogMessage("[QML][Button_Character]onBtnDisableFocusChanged : true : " + btnid)
                //                    button.source = root.non_pressed_button
                //                    buttonKnob.visible = false
                //                }
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

            onUpdateButton:
            {
                buttonText.text = qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext )
            }

            onResetButtonUI:
            {
                if(btnEnabled)
                    button.source = root.non_pressed_button
                else
                    button.source = root.disable_button
            }
        }

        Text{
            id: buttonText
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: textVerticalOffSet
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            z:1
            font.pointSize: fontSize
            style: Text.Sunken
            font.family: "DH_HDB"
            color: fontColor
            smooth: true
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
        //translate.printLogMessage("[QML][Button_Others]redrawButtonOnKeyPress")
        button.source = root.pressed_button
        buttonKnob.visible = false
    }

    function redrawButtonOnKeyRelease(isDoubleShifted)
    {
        //translate.printLogMessage("[QML][Button_Others]redrawButtonOnKeyRelease")
        //translate.printLogMessage("[QML][Button_Others] : redrawButtonOnKeyRelease : btnid :" + btnid)
        //translate.printLogMessage("[QML][Button_Others] : redrawButtonOnKeyRelease : currentFocusIndex :" + currentFocusIndex)
        //translate.printLogMessage("[QML][Button_Others] : redrawButtonOnKeyRelease : prevFocusIndex :" + prevFocusIndex)
        if(isDoubleShifted)
            fontColor = "#7CBDFF"
        else
            fontColor = "#FAFAFA"

        button.source = root.non_pressed_button

        if(currentFocusIndex == btnid && focus_visible && btnEnabled) buttonKnob.visible = true
    }

    function redrawJogCenterPress()
    {

        //translate.printLogMessage("[QML][Button_Others]redrawJogCenterPress")
        button.source = root.focus_pressed_button
        buttonKnob.visible = false
    }

    function redrawJogCenterRelease(isDoubleShifted)
    {
        //translate.printLogMessage("[QML][Button_Others]redrawJogCenterRelease")
        if(isDoubleShifted)
            fontColor = "#7CBDFF"
        else
            fontColor = "#FAFAFA"

        button.source = root.non_pressed_button

        if(currentFocusIndex == btnid && focus_visible && btnEnabled) buttonKnob.visible = true
    }

    function changeButtonIncreased(symbol){
        text1.text = symbol
    }
}
