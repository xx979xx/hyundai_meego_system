import Qt 4.7

Item{
    id: topButton
    width: root.width
    height: root.height

    signal jogDialSelectPressed( bool isPress )
    signal jogDialSelectLongPressed( bool isPress )
    signal jogDialSelectReleased( bool isPress )

    function setEnableButton(){ }

    function getIncreasedTextWidth()
    {
        var width;
        if      ( suffix == 'kor_character'   ) width = 130
        else if ( suffix == 'kor3_character'  ) width = 100
        else if ( suffix == 'me_character'    ) width = 105
        else if ( suffix == 'eu_la_character' ) width = 118
        else if ( suffix == 'me_01_character' ) width = 118
        else if ( suffix == 'me_02_character' ) width = 130
        else if ( suffix == "eu_la2_character") width = 109

        return width
    }

    function getOffSet()
    {
        var offset
        if( suffix == 'me_character') offset = 67
        else if (suffix == 'me_01_character' || suffix == 'me_02_character') offset = 65
        else offset = 70

        return offset
    }

    function getX_PressImageOfTouch()
    {
        if(suffix =='me_character')
            return -31
        else
            return -29
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
                //translate.printLogMessage("[QML][Button_Character]onBtnDisableFocusChanged : false : " + btnid)
            }

        }

        onBtnSelectedChanged:
        {
            //translate.printLogMessage("[QML][Button_Character]onBtnSelectedChanged : " + btnid )
            if ( btnSelected )
            {
                buttonKnob.visible = false
                //if(isLongPressState == false) { //added for Jog Long Press and Release Text Input Issue
                //translate.printLogMessage("[QML][Button_Character]emit jogDialSelectPressed " )
                topButton.jogDialSelectPressed(true)
                //}
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
            //translate.printLogMessage("[QML][Button_Character]onBtnLongPressedChanged : " + btnid)
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
             //translate.printLogMessage("[QML][Button_Character]onJogDialDirectionChanged")
            if ( jogDialDirection >= 0 )
            {
                currentFocusIndex = getNextItemEnabled(transitionIndex[jogDialDirection], jogDialDirection)
            }
        }

        Connections{
            target: qwerty_keypad

            onUpdateButton:
            {
                //translate.printLogMessage("[QML][Button_Character]onUpdateButton")
                buttonText.text = qsTranslate( "DHAVN_QwertyKeypad_Screen", root.keytext )
            }

            onResetButtonUI:
            {
                //translate.printLogMessage("[QML][Button_Character]onResetButtonUI")
                if ( suffix == 'kor_character'      ||
                        suffix == 'kor3_character'  ||
                        suffix == 'me_character'    ||
                        suffix == 'me_01_character' ||
                        suffix == 'me_02_character' ||
                        suffix == 'eu_la_character' ||
                        suffix == 'eu_la2_character')
                {
                    buttonIncreased.visible = false
                    buttonIncreased.source = ""
                }

                button.source = root.non_pressed_button
            }
            //added for CCP Delete LongPress Focus Issue
            onEnableFirstButton:
            {
                translate.printLogMessage("[character]onEnableFirstButton. ");
                if(btnid == 0)
                {
                    translate.printLogMessage("[character]Enable FIrst Button: btnid : 0")
                    buttonKnob.visible = true
                }

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
            font.family: (suffix == 'me_01_character' || suffix == 'me_02_character') ? "Amiri" : "DH_HDB"
            color: fontColor
            smooth: true
            visible: (suffix!='kor_page') && (suffix != 'eu_la_page') && (suffix != 'cy_page') && (suffix != 'eu_la2_page')
        }

        Image{
            id: buttonIncreased

            source: "" //pressed_button
            x:  getX_PressImageOfTouch()
            y:  -133 //-133
            visible: false

            Text{
                id: text1

                width: getIncreasedTextWidth()
                text: buttonText.text
                z:1
                anchors.verticalCenter: parent.top
                anchors.verticalCenterOffset: getOffSet()
                anchors.left: parent.left
                anchors.leftMargin: 24
                horizontalAlignment: Text.AlignHCenter

                font.pointSize: getFontSize()

                style: Text.Sunken
                font.family: (suffix == 'me_01_character' || suffix == 'me_02_character') ? "Amiri" : "DH_HDB"
                color: fontColor
                styleColor:  "#000000"
                smooth: true
            }
        }

        Image{
            id: buttonKnob

            anchors.centerIn: parent;

            source: knob_button
            visible: false
        }
    }

    function getFontSize()
    {
        if( keycode == Qt.Key_Launch4 )
        {
            if( (suffix == 'kor3_character') || (suffix =='me_character') )
                return 60
            else
                return 70
        }
        else
        {
            if( (suffix == 'me_01_character') || (suffix =='me_02_character') )
                return 58
            else
                return 70
        }
    }

    function redrawButtonOnKeyPress()
    {
        //translate.printLogMessage("[QML][Button_Character]redrawButtonOnKeyPress")
        buttonIncreased.source = pressed_button
        buttonIncreased.visible = true

        buttonKnob.visible = false
    }

    function redrawButtonOnKeyRelease(isDoubleShifted)
    {
        //translate.printLogMessage("[QML][Button_Character]redrawButtonOnKeyRelease")
        //translate.printLogMessage("[QML][Button_Character] : redrawButtonOnKeyRelease : btnid :" + btnid)
        //translate.printLogMessage("[QML][Button_Character] : redrawButtonOnKeyRelease : currentFocusIndex :" + currentFocusIndex)
        //translate.printLogMessage("[QML][Button_Character] : redrawButtonOnKeyRelease : prevFocusIndex :" + prevFocusIndex)
        if ( suffix == 'kor_character'      ||
                suffix == 'kor3_character'  ||
                suffix == 'me_character'    ||
                suffix == 'me_01_character' ||
                suffix == 'me_02_character' ||
                suffix == 'eu_la_character' ||
                suffix == 'eu_la2_character')
        {
            buttonIncreased.visible = false
            buttonIncreased.source = ""
        }

        if(isDoubleShifted)
            fontColor = "#7CBDFF"
        else
            fontColor = "#FAFAFA"

        button.source = root.non_pressed_button

        if(currentFocusIndex == btnid && focus_visible && btnEnabled) buttonKnob.visible = true
    }

    function redrawJogCenterPress()
    {
        //translate.printLogMessage("[QML][Button_Character]redrawJogCenterPress")
        button.source = root.focus_pressed_button
        buttonKnob.visible = false
    }

    function redrawJogCenterRelease(isDoubleShifted)
    {
        //translate.printLogMessage("[QML][Button_Character]redrawJogCenterRelease")
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
