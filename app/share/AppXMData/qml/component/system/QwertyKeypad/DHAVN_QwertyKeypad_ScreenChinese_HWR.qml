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
    height: 650//375+165 + 110


    signal keyPress( int keycode_s, string keytext_s )
    signal keyPressAndHold( int keycode_s, string keytext_s )
    signal keyReleased( int keycode_s, string keytext_s, bool keystate_s )


    DHAVN_QwertyKeypad_ModelChineseHWR
    {
        id: chinese_handwriting_keypad_model
    }


    Column
    {
        id: column
        anchors.top: parent.top
        anchors.topMargin: 180
     //   anchors.bottom: parent.bottom
     //   anchors.bottomMargin: 94
        spacing: 9

        Repeater
        {
            model: chinese_handwriting_keypad_model.keypad
            delegate: keypad_row
        }

        Component
        {
            id: keypad_row

            Row
            {
                spacing: 7
                anchors.left : parent.left
                anchors.leftMargin: 10

                Repeater
                {
                    model: line
                    delegate:
                    DHAVN_QwertyKeypad_Button
                    {
                        btnid: btn_id; width: btn_width+btn_pad; height: btn_height;                        
                        keytext: btn_text;
                        suffix: btn_suffix;
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
                            console.log("HWR - P ")

                            if((btn_text == "A00") || (btn_text == "B00") || (btn_text == "C00") || (btn_text == "D00"))
                                return;

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
                            console.log("HWR -R ")
                            if((btn_text == "A00") || (btn_text == "B00") || (btn_text == "C00") || (btn_text == "D00"))
                                return;

                            if (btn_keycode == Qt.Key_Launch2)
                                return;

                            if ( btn_keycode != Qt.Key_Shift ){
                                redrawButtonOnKeyRelease()
                            }
                            scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                        }
                    }
                }
            }
        }
    }

    // HWR Area
    Item {
        id: hwrBoardItem

        Image
        {
            id: hwrBoardBG
            source: translate.getResourcePath() + "keypad/bg_chn_inputbox.png"

            anchors.left: parent.left
            anchors.leftMargin: 9
            anchors.top: parent.top
            anchors.topMargin: 180

            MouseArea
            {
                anchors.fill: parent
                // HRBAE - TODO: Invoke emit recognization
            }
        }

        Image
        {
            id: hwrDeleteBtn
            source: translate.getResourcePath() + "music/btn_del_n.png"

            anchors.left: hwrBoardBG.left
            anchors.leftMargin: 29
            anchors.top: hwrBoardBG.top
            anchors.topMargin: 19

            MouseArea
            {
                anchors.fill: parent
            }
        }

    }

    function retranslateUi()
    {
        translate.changeLang( "Chinese", 0,  0)

        column.children[4].children[1].keytext = screenRepeater.getLaunchText1()
        column.children[4].children[2].keytext = screenRepeater.getLaunchText2()
        column.children[4].children[3].keytext = screenRepeater.getLaunchText3()
        column.children[4].children[2].fontColor = "#5C5C5C"

        updateButton("")
    }

    function getLastIndex()
    {
        return chinese_handwriting_keypad_model.btn_count - 1
    }

}
