import Qt 4.7
import qwertyKeypadUtility 1.0

Item
{
    id: scrTop

    property int  transitDirection: -1
    property bool isFocusedBtnSelected: false
    /**Private area*/

    width:  1280
    height: 375


    signal keyPress( int keycode_s, string keytext_s )
    signal keyPressAndHold( int keycode_s, string keytext_s )
    signal keyReleased( int keycode_s, string keytext_s, bool keystate_s )

    //QwertyKeypadUtility{id: translate}

    DHAVN_QwertyKeypad_ModelLatinExtended
    {
        id: latin_extended_keypad_model//keypad
    }
    Column
    {
        id: column

        anchors.fill: parent;
        spacing: 9



        Repeater
        {
            model: latin_extended_keypad_model.keypad   //keypad
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
                    delegate: DHAVN_QwertyKeypad_Button
                    {
                        btnid: btn_id; width: btn_width; height:btn_height;
                        suffix: btn_suffix; keytext: btn_text;
                        transitionIndex: trn_index;
                        fontSize: btn_fontSize

                        property string originalText: btn_text

                        onJogDialSelectPressed:
                        {
                            onSelectedButtonPressed(false)
                        }

                        onJogDialSelectReleased:
                        {
                            onSelectedButtonReleased(false)
                        }

                        MouseArea
                        {
                            property bool isMovedInside: false

                            anchors.fill: parent
                            onExited: {
                                isMovedInside = false;
                                redrawButtonOnKeyRelease()
                            }
                            onPressed:
                            {
                                isMovedInside = true;
                                onSelectedButtonPressed(true);
                            }
                            onPressAndHold:
                            {
                                scrTop.keyPressAndHold( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text ) );
                            }
                            onReleased:
                            {
                                if(containsMouse == true && isMovedInside == true){
                                    onSelectedButtonReleased(true)
                                }
                                isMovedInside = false;
                            }
                        }

                        function onSelectedButtonPressed(isTouchEvent)
                        {
                            console.log("/home/meego/intelliKeyboard/DHAVN_QwertyKeypadWidget/qml/DHAVN_QwertyKeypad_ScreenLatinExtended.qml")
                            if( disableForIntelliKeyboard == true)
                                return;

                            if (btn_keycode == Qt.Key_Launch3)
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

                        function onSelectedButtonReleased(isTouchEvent)
                        {
                            if( disableForIntelliKeyboard == true)
                                return;
                            if (btn_keycode == Qt.Key_Launch3)
                                return;

                            if ( btn_keycode != Qt.Key_Shift )
                            {
                                currentFocusIndex = btnid;
                                redrawButtonOnKeyRelease()
                            }
                            if(isTouchEvent)
                                UIListener.playAudioBeep();
                            scrTop.keyReleased( btn_keycode, translate.makeWord( btn_keycode, qsTranslate( "DHAVN_QwertyKeypad_Screen", btn_text )), translate.isComposing() )
                        }
                    }
                }
            }
        }
    }

    function retranslateUi( )
    {
        translate.changeLang( "LatinExt", 0, shiftMode !=  e_SHIFT_NONE  )
        updateShiftButton();

        column.children[3].children[1].keytext = screenRepeater.getLaunchText1()
        column.children[3].children[2].keytext = screenRepeater.getLaunchText2()
        column.children[3].children[3].keytext = screenRepeater.getLaunchText3()
        column.children[3].children[3].fontColor = "#5C5C5C"
        column.children[3].children[3].disableForIntelliKeyboard = true;

        updateButton("")
    }

    function getLastIndex()
    {
        return latin_extended_keypad_model.btn_count - 1
    }
    function checkIntelliKeyboard(flag)
    {
        var keyRow = column;
        for(var i = 0 ; i < keyRow.children.length; i++)
        {
            var keycol = keyRow.children[i];
            for(var j = 0 ; j < keycol.children.length; j++)
            {
                var curKey = keycol.children[j];
                if(curKey.suffix)
                {
                    if(curKey.suffix.substr(curKey.suffix.indexOf("_")+1, curKey.suffix.length) == "character")
                    {
                        if(flag == 0xffffffff)
                            curKey.disableForIntelliKeyboard = false;
                        else
                        {
                            var DEF_A_MAX = 10;        // number of keys - Line A
                            var DEF_B_MAX = 9;          // number of keys - Line B
                            var DEF_C_MAX = 8;          // number of keys - Line C

                            if(curKey.originalText.length != 0)
                            {
                                var strText = curKey.originalText;
                                var index = -1;
                                if(strText.charAt(0) == 'A')
                                {
                                    index = parseInt(strText.substr(1,strText.length),10);
                                }else if(strText.charAt(0) == 'B')
                                {
                                    index = DEF_A_MAX + parseInt(strText.substr(1,strText.length),10);
                                }else if(strText.charAt(0) == 'C')
                                {
                                    index = DEF_A_MAX + DEF_B_MAX + parseInt(strText.substr(1,strText.length),10);
                                }

                                if(index != -1)
                                {
                                    var bytedata = 0x00000001 << index;
                                    if(flag & bytedata)
                                    {
                                        curKey.disableForIntelliKeyboard = false;
                                    }else
                                    {
                                        curKey.disableForIntelliKeyboard = true;
                                    }
                                }else
                                {
                                    curKey.disableForIntelliKeyboard = true;
                                }
                            }
                        }
                    }else if(curKey.suffix.substr(curKey.suffix.indexOf("_")+1, curKey.suffix.length) == "done")
                    {
                        if(/*outputText.length*/foundItemCount == 0)
                        {
                            curKey.disableForIntelliKeyboard = true;
                        }else
                        {
                            curKey.disableForIntelliKeyboard = false;
                        }
                    }else if(curKey.suffix.substr(curKey.suffix.indexOf("_")+1, curKey.suffix.length) == "del")
                    {
                        curKey.isBackspaceButton = true;
                        if(outputText.length/*foundItemCount*/ == 0)
                        {
                            curKey.disableForIntelliKeyboard = true;
                        }else
                        {
                            curKey.disableForIntelliKeyboard = false;
                        }
                    }
                }
            }
        }
//        if(flag != 0)
            updateTransitionIndex();
    }
    function updateTransitionIndex()
    {
        var keyRow = column;
        var firstEnableKey = null;
        var lastEnableKey = null;
        for(var i = 0 ; i < keyRow.children.length; i++)
        {
            var sourceSpaceCount = 0;
            var keycol = keyRow.children[i];
            for(var j = 0 ; j < keycol.children.length+sourceSpaceCount; j++)
            {
                var curKey = keycol.children[j-sourceSpaceCount];
                var lastrightup = curKey;
                var lastleftdown = curKey;

                // 0 leftup, 1 up, 2 rightup, 3 leftdown, 4 down, 5 rightdown, 6 left, 7 right, 8 wheelleft, 9 wheelright
                if(curKey)
                {
                    if(curKey.disableForIntelliKeyboard == false)
                    {
                        if(firstEnableKey == null)
                        {
                            firstEnableKey = curKey;
                        }
                        lastEnableKey = curKey;
                    }

                    if(curKey.keycode == 0x20 && sourceSpaceCount < 2)
                    {
                        sourceSpaceCount++;
                    }

                    if((curKey.transitionIndex && (curKey.disableForIntelliKeyboard == false)) || (curKey.btnid == currentFocusIndex))
                    {
                        var result = [curKey, curKey, curKey, curKey, curKey, curKey, curKey, curKey, curKey, curKey];
                        // 0 leftup, 1 up, 2 rightup, 8 wheelleft
                        for(var k = (i-1); k >= 0 ; k--)
                        {
                            for(var l = keyRow.children[k].children.length; l >= 0; l--)
                            {
                                var targetKey = keyRow.children[k].children[l];
                                if(targetKey && targetKey.transitionIndex && (targetKey.disableForIntelliKeyboard == false))
                                {
                                    if(result[8] == curKey)
                                    {
                                        result[8] = targetKey;
                                        result[2] = targetKey;
                                        result[1] = targetKey;
                                        result[0] = targetKey;
                                        lastrightup = targetKey;
                                    }else if(l > j)
                                    {
                                        result[2] = targetKey;
                                        result[1] = targetKey;
                                        result[0] = targetKey;
                                        lastrightup = targetKey;
                                    }else if(l == j)
                                    {
                                        result[1] = targetKey;
                                        result[0] = targetKey;
                                        lastrightup = targetKey;
                                    }else if(l < j)
                                    {
                                        if(result[0] == result[1])
                                            result[0] = targetKey;
                                        lastrightup = targetKey;
                                    }
                                }
                            }
                            if(result[8] != curKey)
                                break;
                        }

                        // 3 leftdown, 4 down, 5 rightdown, 9 wheelright
                        for(var k = (i+1); k < keyRow.children.length; k++)
                        {
                            var spaceCount = 0;
                            for(var l = 0; l < keyRow.children[k].children.length+spaceCount ; l++)
                            {
                                var targetKey = keyRow.children[k].children[l-spaceCount];
                                if(targetKey)
                                {
                                    if(targetKey.keycode == 0x20 && spaceCount < 2)
                                    {
                                        spaceCount++;
                                    }
                                    if(targetKey.transitionIndex && (targetKey.disableForIntelliKeyboard == false))
                                    {
                                        if(result[9] == curKey)
                                        {
                                            result[9] = targetKey;
                                            result[3] = targetKey;
                                            result[4] = targetKey;
                                            result[5] = targetKey;
                                            lastleftdown = targetKey;
                                        }else if(l < j)
                                        {
                                            result[3] = targetKey;
                                            result[4] = targetKey;
                                            result[5] = targetKey;
                                            lastleftdown = targetKey;
                                        }else if(l == j)
                                        {
                                            result[4] = targetKey;
                                            result[5] = targetKey;
                                            lastleftdown = targetKey;
                                        }else if(l > j)
                                        {
                                            if(result[5] == result[4])
                                                result[5] = targetKey;
                                            lastleftdown = targetKey;
                                        }
                                    }
                                }
                            }
                            if(result[9] != curKey)
                                break;
                        }

                        //8 wheelleft, 9 wheelright
                        for(var k = 0 ; k < keycol.children.length+sourceSpaceCount; k++)
                        {
                            var targetKey = keycol.children[k-sourceSpaceCount];
                            if(targetKey && targetKey.transitionIndex && (targetKey.disableForIntelliKeyboard == false))
                            {
                                if(k < j)
                                {
                                    result[6] = targetKey;
                                    result[8] = targetKey;
                                }else if(k > j)
                                {
                                    if(result[7] == curKey)
                                    {
                                        result[7] = targetKey;
                                        result[9] = targetKey;

                                        break;
                                    }
                                }
                            }
                        }

                        curKey.transitionIndex = [result[0].btnid,result[1].btnid,result[2].btnid,result[3].btnid,result[4].btnid,result[5].btnid,result[6].btnid,result[7].btnid,result[8].btnid,result[9].btnid];

                        if(curKey.btnid == currentFocusIndex && curKey.disableForIntelliKeyboard == true)
                        {
                            prevFocusIndex = currentFocusIndex;
                            if(result[8] != curKey)
                                currentFocusIndex = result[8].btnid;
                            else currentFocusIndex = result[9].btnid;
                        }
                    }
                }
            }
        }
        firstEnableKey.transitionIndex = [firstEnableKey.transitionIndex[0],firstEnableKey.transitionIndex[1],firstEnableKey.transitionIndex[2],firstEnableKey.transitionIndex[3],firstEnableKey.transitionIndex[4],firstEnableKey.transitionIndex[5],firstEnableKey.transitionIndex[6],firstEnableKey.transitionIndex[7],lastEnableKey.btnid,firstEnableKey.transitionIndex[9]];
        lastEnableKey.transitionIndex = [lastEnableKey.transitionIndex[0],lastEnableKey.transitionIndex[1],lastEnableKey.transitionIndex[2],lastEnableKey.transitionIndex[3],lastEnableKey.transitionIndex[4],lastEnableKey.transitionIndex[5],lastEnableKey.transitionIndex[6],lastEnableKey.transitionIndex[7],lastEnableKey.transitionIndex[8],firstEnableKey.btnid];
    }
}
