import Qt 4.7
import qwertyKeypadUtility 1.0

Item
{
    id: scrTop

    property bool is_Shift:       false
    property bool is_DoubleShift: false
    property int  transitDirection: -1
    property bool isFocusedBtnSelected: false
    property int   keypadType : 0
    /**Private area*/

    width:  1280
    height: 375


    signal keyPress( int keycode_s, string keytext_s )
    signal keyPressAndHold( int keycode_s, string keytext_s )
    signal keyReleased( int keycode_s, string keytext_s, bool keystate_s )

    //QwertyKeypadUtility { id: translate }

    DHAVN_QwertyKeypad_ModelArabic
    {
        id: arabic_keypad_model
    }
    DHAVN_QwertyKeypad_ModelArabic_Type2
    {
        id: arabic_type2_keypad_model
    }

    Column
    {
        id: column

        anchors.fill: parent;
        spacing: 9

        Repeater
        {
            model: (keypadType == 0)? arabic_keypad_model.keypad : arabic_type2_keypad_model.keypad
            delegate: keypad_row
        }

        Component
        {
            id: keypad_row

            Row
            {
                spacing: 7
                anchors.left : parent.left
                anchors.leftMargin: 8

                Repeater
                {
                    model: line
                    delegate:
                    DHAVN_QwertyKeypad_Button_Arabic
                    {
                        btnid: btn_id; width: btn_width+btn_pad
                        height:btn_height;
                        suffix: btn_suffix; keytext: btn_text; keytext2: btn_text2;
                        transitionIndex: trn_index
                        padWidth: btn_pad
                        fontSize: btn_fontSize

                        onJogDialSelectPressed:
                        {
                            onSelectedButtonPressed(false)
                        }

                        onJogDialSelectReleased:
                        {
                            onSelectedButtonReleased()
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            anchors.rightMargin : btn_pad
                            onPressed:
                            {
                                onSelectedButtonPressed(true)
                            }
                            onPressAndHold:
                            {
                                scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                            }
                            onReleased:
                            {
                                onSelectedButtonReleased()
                            }
                        }
                        function onSelectedButtonPressed(isTouchEvent)
                        {
                        //    console.log( "Arab - onSelectedButtonPressed....")
                            console.log("/home/meego/intelliKeyboard/DHAVN_QwertyKeypadWidget/qml/DHAVN_QwertyKeypad_ScreenArabic.qml")

                            if (btn_keycode == Qt.Key_Launch2)
                                return;

                            if (btn_keycode == Qt.Key_Launch4)
                            {
                                changeButtonIncreased(comma[comma_timer.type])
                                comma_timer.isPressed = true
                            }

//                            if ( btn_keycode != Qt.Key_Shift )
                            {
                                redrawButtonOnKeyPress(isTouchEvent);
                                scrTop.keyPress( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                            }
                          //  scrTop.keyPress( btn_keycode, qsTr( btn_text ) );
                        }

                        function onSelectedButtonReleased()
                        {
                            if (btn_keycode == Qt.Key_Launch2)
                                return;

                            if ( btn_keycode != Qt.Key_Shift )
                            {
                           //     console.log( "Arab - translate.keypadTypeAr:  )" + translate.keypadTypeAr + ", is_Shift" + is_Shift )

                                if ( translate.keypadTypeAr == 0 )
                                {
                                    if ( btn_text == "A05" ||
                                        btn_text == "A09" ||
                                        btn_text == "B05" ||
                                        btn_text == "B06" ||
                                        btn_text == "B07" ||
                                        btn_text == "C04" ||
                                        btn_text == "C05" ||
                                        btn_text == "C06" ||
                                        btn_text == "C09" )
                                    {
                                        if ((is_Shift == true) && (is_DoubleShift == true))
                                        {
                                            redrawButtonOnKeyRelease2();
                                         }
                                        else
                                        {
                                            redrawButtonOnKeyRelease();
                                            changeShiftCharacterColor("#FAFAFA");
                                        }
                                    }
                                    else
                                    {
                                        redrawButtonOnKeyRelease();
                                        if ( (is_Shift == true) && (is_DoubleShift == false) )
                                        {
                                            changeShiftCharacterColor("#FAFAFA");
                                        }
                                    }
                                }
                                else    // Type2
                                {
                                    redrawButtonOnKeyRelease();
                                }
                                scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                            }
                            else   // Qt.Key_Shift
                            {
                                if (translate.keypadTypeAr != 0)
                                    return;

                                shiftProcessing();
                                retranslateUi();
                            }
                        }
                    }
                }
            }
        }

      Component.onCompleted:
      {
          is_Shift = false;
          is_DoubleShift = false;
      }

    }

    function retranslateUi( )
    {
        keypadType = translate.keypadTypeAr
        translate.changeLang( "Arabic", keypadType, (keypadType == 0)? is_Shift : 0 )

         if(is_DoubleShift)
             pressedTwoShifts(true);
         else if(is_Shift)
             pressedOneShift(true);
         else
             resetShiftsPress(true);

         if (keypadType == 0)
         {
             arabic_keypad_model.keypad[3].line[1].btn_text = screenRepeater.getLaunchText1()
             arabic_keypad_model.keypad[3].line[2].btn_text = screenRepeater.getLaunchText2()
             arabic_keypad_model.keypad[3].line[3].btn_text = screenRepeater.getLaunchText3()
             column.children[3].children[2].fontColor = "#5C5C5C"
         }
         else
         {
             arabic_type2_keypad_model.keypad[4].line[1].btn_text = screenRepeater.getLaunchText1()
             arabic_type2_keypad_model.keypad[4].line[2].btn_text = screenRepeater.getLaunchText2()
             arabic_type2_keypad_model.keypad[4].line[3].btn_text = screenRepeater.getLaunchText3()
             column.children[4].children[2].fontColor = "#5C5C5C"
         }
        updateButton("")
    }

    function changeShiftCharacterColor( colorString )
    {
        column.children[0].children[5].fontColor = colorString;
        column.children[0].children[9].fontColor = colorString;

        column.children[1].children[5].fontColor = colorString;
        column.children[1].children[6].fontColor = colorString;
        column.children[1].children[7].fontColor = colorString;

        column.children[2].children[5].fontColor = colorString;
        column.children[2].children[6].fontColor = colorString;
        column.children[2].children[7].fontColor = colorString;
        column.children[2].children[10].fontColor = colorString;
    }

    function shiftProcessing ()
    {
        if ( is_DoubleShift )
        {
            is_DoubleShift= false;
            is_Shift = false;
            resetShiftsPress( true );
            changeShiftCharacterColor("#FAFAFA");
        }
        else if ( is_Shift )
        {
            is_DoubleShift = true;
            pressedTwoShifts( true );
        }
        else
        {
            is_Shift = true;
            pressedOneShift ( true );
            changeShiftCharacterColor("#7CBDFF");
        }
    }
    function getLastIndex()
    {
        return arabic_keypad_model.btn_count - 1
    }
}
