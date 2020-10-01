import Qt 4.7

Item{
    id: topButton
    width: root.width
    height: root.height

    property bool isButtonPressed: false

    signal jogDialSelectPressed( bool isPress )
    signal jogDialSelectLongPressed( bool isPress )
    signal jogDialSelectReleased( bool isPress )

    // [Hide / Space] Button
    function setEnableButton()
    {
        if(btnEnabled)
        {
            if(keycode == Qt.Key_Launch0 || keycode == Qt.Key_Space || keycode == Qt.Key_Home || keycode == Qt.Key_Back)
                button.source = ""
        }
        else
        {
            if(keycode == Qt.Key_Launch0 || keycode == Qt.Key_Space || keycode == Qt.Key_Home || keycode == Qt.Key_Back)
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

        source: ""

        Binding{
            target: buttonKnob; property: "visible"; value: ( currentFocusIndex == btnid && focus_visible && btnEnabled )
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
                isButtonPressed = false
                button.source = ""
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
            color: (buttonKnob.visible || isButtonPressed)? fontColor : "#323232"
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
        isButtonPressed = true
        button.source = root.pressed_button
        buttonKnob.visible = false
    }

    function redrawButtonOnKeyRelease(isDoubleShifted)
    {
        isButtonPressed = false
        if(isDoubleShifted)
            fontColor = "#7CBDFF"
        else
            fontColor = "#FAFAFA"

        button.source = ""

        if(currentFocusIndex == btnid && focus_visible && btnEnabled) buttonKnob.visible = true
    }

    function redrawJogCenterPress()
    {
        isButtonPressed = true
        button.source = root.pressed_button
        buttonKnob.visible = false
    }

    function redrawJogCenterRelease(isDoubleShifted)
    {
        isButtonPressed = false
        if(isDoubleShifted)
            fontColor = "#7CBDFF"
        else
            fontColor = "#FAFAFA"

        button.source = ""

        if(currentFocusIndex == btnid && focus_visible && btnEnabled) buttonKnob.visible = true
    }

    function changeButtonIncreased(symbol){
        text1.text = symbol
    }
}
