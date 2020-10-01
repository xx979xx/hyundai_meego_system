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

    DHAVN_QwertyKeypad_ModelEnglish_Q              {      id: qwerty_keypad_model    }
    DHAVN_QwertyKeypad_ModelEuropean_Qwertz     {      id: qwertz_keypad_model    }
    DHAVN_QwertyKeypad_ModelEuropean_Azerty      {      id: azerty_keypad_model    }
//    DHAVN_QwertyKeypad_ModelEuropean_Cyrillic      {      id: cyrillic_keypad_model    }

    function getKeypadModel(type)
    {
        if(type == 0)           return qwerty_keypad_model;
        if(type == 1)           return qwerty_keypad_model;
        if(type == 2)           return qwertz_keypad_model;
        if(type == 3)           return azerty_keypad_model;
    //    if(type == 4)           return cyrillic_keypad_model;
    //    if(type == 5)           return cyrillic_keypad_model;
        return qwerty_keypad_model;
    }

    Column
    {
        id: column

        anchors.fill: parent
        spacing: 9


        Repeater
        {
            model: getKeypadModel(keypadType).keypad
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
                            console.log("/home/meego/intelliKeyboard/DHAVN_QwertyKeypadWidget/qml/DHAVN_QwertyKeypad_ScreenEuropean.qml")
                            if ( btn_keycode == Qt.Key_Launch2 )
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
                            if ( btn_keycode == Qt.Key_Launch2 )
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
        keypadType = translate.keypadTypeEu;
        translate.changeLang( "European", keypadType, shiftMode !=  e_SHIFT_NONE  )
        updateShiftButton();

    /*
        getKeypadModel().keypad[3].line[1].btn_text = screenRepeater.getLaunchText1()
        getKeypadModel().keypad[3].line[2].btn_text = screenRepeater.getLaunchText2()
        getKeypadModel().keypad[3].line[3].btn_text = screenRepeater.getLaunchText3()
*/
        qwerty_keypad_model.keypad[3].line[1].btn_text = screenRepeater.getLaunchText1()
        qwerty_keypad_model.keypad[3].line[2].btn_text = screenRepeater.getLaunchText2()
        qwerty_keypad_model.keypad[3].line[3].btn_text = screenRepeater.getLaunchText3()
    //    qwerty_keypad_model.keypad[3].line[4].btn_text = screenRepeater.getLaunchText4()

        qwertz_keypad_model.keypad[3].line[1].btn_text = screenRepeater.getLaunchText1()
        qwertz_keypad_model.keypad[3].line[2].btn_text = screenRepeater.getLaunchText2()
        qwertz_keypad_model.keypad[3].line[3].btn_text = screenRepeater.getLaunchText3()
        qwertz_keypad_model.keypad[3].line[4].btn_text = screenRepeater.getLaunchText4()

        azerty_keypad_model.keypad[3].line[1].btn_text = screenRepeater.getLaunchText1()
        azerty_keypad_model.keypad[3].line[2].btn_text = screenRepeater.getLaunchText2()
        azerty_keypad_model.keypad[3].line[3].btn_text = screenRepeater.getLaunchText3()
        azerty_keypad_model.keypad[3].line[4].btn_text = screenRepeater.getLaunchText4()

        column.children[3].children[2].fontColor = "#5C5C5C"

        updateButton("")
    }

    function getLastIndex()
    {
        return getKeypadModel(translate.keypadTypeEu).btn_count - 1
    }
}
