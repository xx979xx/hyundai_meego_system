import Qt 4.7

Item{
    id: topButton
    width: root.width
    height: root.height

    signal jogDialSelectPressed( bool isPress )
    signal jogDialSelectLongPressed( bool isPress )
    signal jogDialSelectReleased( bool isPress )

    function getLeftMargin()
    {
        if(suffix=='kor_page')
            return 60
        else if (suffix=='eu_la_page')
            return 40
        else if(suffix=='cy_page')
            return 25
        else if(suffix == 'eu_la2_page')
            return 40
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

        source: root.non_pressed_button

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

            onUpdateButton:
            {
                buttonText.text = qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext )
            }

            onResetButtonUI:
            {
                button.source = root.non_pressed_button
            }

            //added for ITS 252365 Shift Button Focus Issue
            onEnablePageButton:
            {
                //translate.printLogMessage("[button_page]Enable Page Button")
                buttonKnob.visible = true
            }
        }

        Text{
            id: buttonText
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 42
            anchors.left: parent.left
            anchors.leftMargin: getLeftMargin()
            z:1
            font.pointSize: fontSize
            style: Text.Sunken
            font.family: "DH_HDB"
            color: fontColor
            smooth: true
        }

        Image{
            id: arrow_r_n
            z:1
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 42
            anchors.left: buttonText.right
            anchors.leftMargin: 35
            source: "/app/share/images/Qwertykeypad/ico_page_r_n.png"
            visible: (button.source != root.pressed_button || button.source != root.focus_pressed_button)
        }

        Image{
            id: arrow_r_p
            z:1
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 42
            anchors.left: buttonText.right
            anchors.leftMargin: 35
            source: "/app/share/images/Qwertykeypad/ico_page_r_p.png"
            visible: (button.source == root.pressed_button || button.source == root.focus_pressed_button)
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
        if(isDoubleShifted)
            fontColor = "#7CBDFF"
        else
            fontColor = "#FAFAFA"

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
