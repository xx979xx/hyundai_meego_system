import Qt 4.7
import qwertyKeypadUtility 1.0

Item
{
    id: scrTop

    property int  transitDirection: -1
    property bool isFocusedBtnSelected: false
    property int   keypadType : 0
    /**Private area*/

    width:  1280
    height: 375


    signal keyPress( int keycode_s, string keytext_s )
    signal keyPressAndHold( int keycode_s, string keytext_s )
    signal keyReleased( int keycode_s, string keytext_s, bool keystate_s )

  //  QwertyKeypadUtility{id: translate}

    DHAVN_QwertyKeypad_ModelEuropean_Cyrillic      {      id: cyrillic_keypad_model    }

    function getKeypadModel(type)
    {
        if( type == 4 || type == 5 )           return cyrillic_keypad_model;
        return false;
    }

    Column
    {
        id: column

        anchors.fill: parent
        spacing: 9


        Repeater
        {
            model: cyrillic_keypad_model.keypad
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

                //Rectangle { width: 100; height: 90; color: "transparent"}

                Repeater
                {
                    model: line
                    delegate:
                    DHAVN_QwertyKeypad_Button
                    {
                        btnid: btn_id; width: btn_width+btn_pad; height:btn_height;
                        suffix: btn_suffix; keytext: btn_text;
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
                            // TODO - Check
                            //anchors.rightMargin : btn_pad
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
                            console.log("/home/meego/intelliKeyboard/DHAVN_QwertyKeypadWidget/qml/DHAVN_QwertyKeypad_ScreenEuropean_Cyrillic.qml")

                            if ( btn_keycode == Qt.Key_Launch6 )
                                return;

                            if (btn_keycode == Qt.Key_Launch4)
                            {
                                changeButtonIncreased(comma[comma_timer.type])
                                comma_timer.isPressed = true
                            }

//                            if ( btn_keycode != Qt.Key_Shift )
                            {
                                redrawButtonOnKeyPress(isTouchEvent)
                            }
                            scrTop.keyPress( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                            //onKeyPressed( btn_keycode, btn_text )
                        }

                        function onSelectedButtonReleased()
                        {
                            if ( btn_keycode == Qt.Key_Launch6 )
                                return;

                            if ( btn_keycode != Qt.Key_Shift )
                            {
                                redrawButtonOnKeyRelease()
                            }
                            scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                        }
                    }
                }
            }
        }
    }

    function retranslateUi()
    {
        keypadType = translate.keypadTypeRu;
        translate.changeLang( "EuCyrillic", keypadType, shiftMode !=  e_SHIFT_NONE  )
        updateShiftButton();

        column.children[3].children[1].keytext = screenRepeater.getLaunchText1()
        column.children[3].children[2].keytext = screenRepeater.getLaunchText2()
        column.children[3].children[3].keytext = screenRepeater.getLaunchText3()
        column.children[3].children[4].keytext = screenRepeater.getLaunchText4()
/*
    if (countryVariant == 6)
            column.children[3].children[2].fontColor = "#5C5C5C"
        else
            column.children[3].children[4].fontColor = "#5C5C5C"
*/
        column.children[3].children[4].fontColor = "#5C5C5C"
        updateButton("")
    }

    function getLastIndex()
    {
        return cyrillic_keypad_model.btn_count - 1
    }
}
