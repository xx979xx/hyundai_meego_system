import Qt 4.7
import qwertyKeypadUtility 1.0

Item
{
   id: scrTop

   /**Private area*/
   property int  transitDirection: -1
   property bool isFocusedBtnSelected: false

   width:  1280
   height: 375

   signal keyPress( int keycode_s, string keytext_s )
   signal keyPressAndHold( int keycode_s, string keytext_s)
   signal keyReleased( int keycode_s, string keytext_s, bool keystate_s )


   //QwertyKeypadUtility { id: translate }

    DHAVN_QwertyKeypad_ModelEuropean_Numbers
    {
        id: european_numeric_keypad_model
    }

   Column
   {
      id: column

      anchors.fill: parent
      spacing: 9

      Repeater
      {
         model: european_numeric_keypad_model.keypad
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
                  btnid: btn_id
                  width: btn_width; height: btn_height; suffix: btn_suffix; keytext: btn_text
                  transitionIndex: trn_index
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
                     onPressed:
                     {
                        onSelectedButtonPressed(true)
                     }
                     onPressAndHold:
                     {
                        scrTop.keyPressAndHold( btn_keycode, btn_text );
                     }
                     onReleased:
                     {
                        onSelectedButtonReleased()
                     }
                  }


                  function onSelectedButtonPressed(isTouchEvent)
                  {
                      console.log("/home/meego/intelliKeyboard/DHAVN_QwertyKeypadWidget/qml/DHAVN_QwertyKeypad_ScreenEuropean_Numbers.qml")

                      if (btn_keycode == Qt.Key_Launch1)
                          return;

                      if (btn_keycode == Qt.Key_Launch4)
                      {
                          changeButtonIncreased(comma[comma_timer.type])
                          comma_timer.isPressed = true
                      }
                      redrawButtonOnKeyPress(isTouchEvent)
                      scrTop.keyPress( btn_keycode, btn_text );
                  }

                  function onSelectedButtonReleased()
                  {
                      if (btn_keycode == Qt.Key_Launch1)
                          return;

                      redrawButtonOnKeyRelease()
                      scrTop.keyReleased( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ), false )
                  }
               }
            }
         }
      }

      //Component.onCompleted: retranslateUi()
    }


    function retranslateUi()
    {
        translate.changeLang( "EuNumber", isNumber2Mode, 0  )

        column.children[3].children[1].keytext = screenRepeater.getLaunchText1()
        column.children[3].children[2].keytext = screenRepeater.getLaunchText2()
        column.children[3].children[3].keytext = screenRepeater.getLaunchText3()
        column.children[3].children[4].keytext = screenRepeater.getLaunchText4()
        column.children[3].children[1].fontColor = "#5C5C5C"

        updateButton("")
    }

    function getLastIndex()
    {
        return european_numeric_keypad_model.btn_count - 1
    }
}
