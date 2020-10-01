import Qt 4.7
import qwertyKeypadUtility 1.0
import ChinesePinyin 1.0

Item
{
    id: scrTop

    property int  transitDirection: -1
    property bool isFocusedBtnSelected: false
    property int   keypadType : 0
    /**Private area*/

    width:  1280
    height: 375+165


    signal keyPress( int keycode_s, string keytext_s )
    signal keyPressAndHold( int keycode_s, string keytext_s )
    signal keyReleased( int keycode_s, string keytext_s, bool keystate_s )

    DHAVN_QwertyKeypad_ChinesePinyin
    {
        id: pinyin
        onKeySelect: scrTop.keyReleased( Qt.Key_A, translate.makeWord( Qt.Key_A, text), translate.isComposing() )
    }

    DHAVN_QwertyKeypad_ModelChinesePinyin
    {
        id: chinese_pinyin_keypad_model
    }

     Column
    {
        id: column

        anchors.bottom: parent.bottom
        spacing: 9

        Repeater
        {
            model: chinese_pinyin_keypad_model.keypad
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
                    DHAVN_QwertyKeypad_Button
                    {
                        btnid: btn_id; width: btn_width+btn_pad; height:btn_height;
                        suffix: btn_suffix; keytext: btn_text;
                        transitionIndex: trn_index
                        fontSize: btn_fontSize
                        padWidth: btn_pad
                        signal updateButton( string button_text )

                        onJogDialSelectPressed: onSelectedButtonPressed(false)
                        onJogDialSelectReleased: onSelectedButtonReleased()

                        MouseArea
                        {
                            anchors.fill: parent
                            onPressed: onSelectedButtonPressed(true)
                            onPressAndHold: scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                            onReleased: onSelectedButtonReleased()
                        }

                        function onSelectedButtonPressed(isTouchEvent)
                        {
                            console.log("/home/meego/intelliKeyboard/DHAVN_QwertyKeypadWidget/qml/DHAVN_QwertyKeypad_ScreenChinese_Pinyin.qml")

                            if (btn_keycode == Qt.Key_Launch2)
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
                            if (btn_keycode == Qt.Key_Launch2)
                                return;

                            if ( btn_keycode != Qt.Key_Shift ){
                                redrawButtonOnKeyRelease()
                            }
                            if( btn_keycode == Qt.Key_Space ){
                                scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                            }
                            if(false == pinyin.handleKey(btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ))){
                                scrTop.keyReleased( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ), translate.isComposing() )
                            }
                        }
                    }
                }

            }
        }
    }

    function retranslateUi()
    {
        translate.changeLang( "Chinese", 0,  0)
     //   keypadType = translate.keypadTypeCh
     //   translate.changeLang( "Chinese", keypadType, 0 )


        pinyin.update(translate.keypadTypeCh)

        column.children[3].children[1].keytext = screenRepeater.getLaunchText1()
        column.children[3].children[2].keytext = screenRepeater.getLaunchText2()
        column.children[3].children[3].keytext = screenRepeater.getLaunchText3()
        column.children[3].children[2].fontColor = "#5C5C5C"

        updateButton("")
    }

    function getLastIndex()
    {
        return chinese_pinyin_keypad_model.btn_count - 1
    }

}
