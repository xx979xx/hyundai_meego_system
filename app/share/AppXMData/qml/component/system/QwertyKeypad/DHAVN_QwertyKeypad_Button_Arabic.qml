import Qt 4.7

Item
{
    id: topButton
    property int btnid: 0
    property string keytext: ""
    property string keytext2: ""
    property string suffix: ""
    property int padWidth: 0
    property int fontSize: 50
    property string fontColor: "#FAFAFA"
    property variant transitionIndex: [0]

    property url non_pressed_button: translate.getResourcePath() + "keypad/btn_" + suffix + "_n.png"
    property url pressed_button: translate.getResourcePath() + "keypad/btn_" + suffix + "_p.png"
    property url knob_button: translate.getResourcePath() + "keypad/btn_" + suffix + "_f.png"
    property url selected_button: translate.getResourcePath() + "keypad/btn_" + suffix + "_s.png"
    property url focus_pressed_button: translate.getResourcePath() + "keypad/btn_" + suffix + "_fp.png"

    signal jogDialSelectPressed( bool isPress )
    signal jogDialSelectReleased( bool isPress )

    Image
    {
        id: button
        width: parent.width - padWidth;
        height:parent.height

        /**Private area*/
        property bool btnFocus: false
        property bool btnSelected: false
        property bool btnDownPressed: false
        property int  jogDialDirection: -1

        source: non_pressed_button

        Binding
        {
            target: buttonKnob; property: "visible"; value: ( currentFocusIndex == btnid && focus_visible )
        }
        Binding
        {
            target: button; property: "btnSelected"; value: ( prevFocusIndex == btnid && isFocusedBtnSelected )
        }
        Binding
        {
            target: button; property: "jogDialDirection"; value: ( prevFocusIndex == btnid) ? transitDirection : -1
        }

        onBtnSelectedChanged:
        {
            if ( btnSelected )
            {
                buttonKnob.visible = false
                topButton.jogDialSelectPressed(true)
//                jdSelTimer.restart()
            }
            else
            {
                topButton.jogDialSelectReleased(true)
                buttonKnob.visible = true
            }
        }

        onJogDialDirectionChanged:
        {
            if ( jogDialDirection >= 0 )
            {
                currentFocusIndex = transitionIndex[jogDialDirection]
            }
        }

        Timer
        {
            id: jdSelTimer

            interval: 500;
            running: false
            onTriggered: qwerty_keypad.onJDEventSelectRelease()
        }
        Connections
        {
            target: qwerty_keypad

            onUpdateButton:
            {
                buttonText.text = qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext )
                buttonText2.text = qsTranslate( "DHAVN_QwertyKeypad_Screen", keytext2 )
            }

            onPressedOneShift:
            {
                if ( suffix == 'kor_shift' ||
                        suffix == 'kor3_shift'  ||
                        suffix == 'cy_shift'     ||
                        suffix == 'arab2_shift' ||
                        suffix == 'eu_la_shift' )
                {
                    button.source = selected_button
                }
            }

            onPressedTwoShifts:
            {
                if ( suffix == 'kor_shift' ||
                        suffix == 'kor3_shift'  ||
                        suffix == 'cy_shift'     ||
                        suffix == 'arab2_shift' ||
                        suffix == 'eu_la_shift' )
                {
                    button.source = pressed_button
                }
            }

            onResetShiftsPress:
            {
                if ( suffix == 'kor_shift' ||
                        suffix == 'kor3_shift'  ||
                        suffix == 'cy_shift'     ||
                        suffix == 'arab2_shift' ||
                        suffix == 'eu_la_shift' )
                {
                    button.source = non_pressed_button
                }
            }
        }


        Text
        {
            id: buttonText
            anchors.centerIn: parent;
            font.pixelSize: fontSize
            style: Text.Sunken
            font.family: systemInfo.font_NewHDB
            color: fontColor
            styleColor: "#000000"
            smooth: true
            visible: true
        }

        Text
        {
            id: buttonText2
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 32
            font.pixelSize:  40
            style: Text.Sunken
            font.family: systemInfo.font_NewHDB
            color:  "#7CBDFF"
            styleColor:  "#000000"
            smooth: true
            visible: true
        }

        Image
        {
            id: buttonIncreased

            source: pressed_button

            x:  -29
            y:  -130

            visible: false

            Text
            {
                id: text1
                text: buttonText.text
                anchors.centerIn: parent;
                anchors.verticalCenterOffset:  -44
                font.pixelSize:  70
                style: Text.Sunken
                font.family: systemInfo.font_NewHDB
                color:  "#000000"
                styleColor:  "#FAFAFA"
                smooth: true
            }

            Text
            {
                id: text2
                text: buttonText2.text
                anchors.right: parent.right
                anchors.rightMargin: 36
                anchors.top: parent.top
                anchors.topMargin: 30
                font.pixelSize:  50
                style: Text.Sunken
                font.family: systemInfo.font_NewHDB
                color:  "#7CBDFF"
                styleColor:  "#000000"
                smooth: true
            }
        }

        Image
        {
            id: buttonKnob

            anchors.centerIn: parent;

            source: knob_button
            visible: false
        }

    }
    function redrawButtonOnKeyPress()
    {
        fontColor = "#000000"

        if ( suffix == 'kor_character' ||
            suffix == 'kor3_character' ||
            suffix == 'cy_character' ||
            suffix == 'arab2_character' ||
            suffix == 'eu_la_character' )
        {
            if (focus_visible)
            {
                buttonIncreased.visible = false
                button.source = focus_pressed_button
                buttonKnob.visible = true
            }
            else
            {
                buttonIncreased.visible = true
                buttonKnob.visible = false
            }
        }
        else
        {
            buttonIncreased.visible = false
            if(isTouchEvent)
            {
                button.source = pressed_button
            }
            else
            {
                button.source = focus_pressed_button;
            }
        }
    }

    function redrawButtonOnKeyRelease()
    {
         if ( suffix == 'kor_character' ||
              suffix == 'kor3_character' ||
              suffix == 'cy_character' ||
              suffix == 'arab2_character' ||
              suffix == 'eu_la_character' )
         {
             if (focus_visible)
             {
                  buttonKnob.visible = false
             }
             else
             {
                buttonIncreased.visible = false
                buttonKnob.visible = false
             }
         }

        fontColor = "#FAFAFA"
        button.source = non_pressed_button
    }

    function redrawButtonOnKeyRelease2()
    {
         if ( suffix == 'cy_character' )
         {
             if (focus_visible)
             {
                  buttonKnob.visible = false
             }
             else
             {
                buttonIncreased.visible = false
                buttonKnob.visible = false
             }
         }

        fontColor = "#7CBDFF"
        button.source = non_pressed_button
    }


    function changeButtonIncreased(symbol){
        text1.text = symbol
    }

}
