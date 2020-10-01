import Qt 4.7

Item
{
    id: topButton
    property int btnid: 0
    property string keytext: ""
    property string suffix: ""
    property int padWidth: 0
    property int fontSize: 50
    property string fontColor: "#FAFAFA"
    property variant transitionIndex: [0]
    property bool disableForIntelliKeyboard: false
    property bool isBackspaceButton: false

    //__INTELLIKEYPAD_FOR_XMDATA__
//    property url non_pressed_button: translate.getResourcePath() + "keypad/btn_" + suffix + "_n.png"
//    property url pressed_button: translate.getResourcePath() + "keypad/btn_" + suffix + "_p.png"
//    property url knob_button: translate.getResourcePath() + "keypad/btn_" + suffix + "_f.png"
//    property url selected_button: translate.getResourcePath() + "keypad/btn_" + suffix + "_s.png"
//    property url focus_pressed_button: translate.getResourcePath() + "keypad/btn_" + suffix + "_fp.png"

    property string shiftmodeSuffix: ""

    property url non_pressed_button: isBackspaceButton && disableForIntelliKeyboard ? imageInfo.imgFolderKeypad + "btn_" + suffix + shiftmodeSuffix + "_d.png" : imageInfo.imgFolderKeypad + "btn_" + suffix + shiftmodeSuffix + "_n.png"
    property url pressed_button: imageInfo.imgFolderKeypad + "btn_" + suffix + shiftmodeSuffix + "_p.png"
    property url knob_button: imageInfo.imgFolderKeypad + "btn_" + suffix + shiftmodeSuffix + "_f.png"
    property url selected_button: imageInfo.imgFolderKeypad + "btn_" + suffix + shiftmodeSuffix + "_f.png"
    property url focus_pressed_button: imageInfo.imgFolderKeypad + "btn_" + suffix + shiftmodeSuffix + "_fp.png"

    signal jogDialSelectPressed( bool isPress )
    signal jogDialSelectReleased( bool isPress )

    onDisableForIntelliKeyboardChanged: {
        if(disableForIntelliKeyboard)
            fontColor = "#5C5C5C"
        else
            fontColor = "#FAFAFA"
    }

    Image
    {
        id: button
        width: parent.width - padWidth;
        height:parent.height

        /**Private area*/
        property bool btnSelected: false
        property bool btnDownPressed: false
        property int  jogDialDirection: -1

        source: non_pressed_button

        Binding
        {
            target: button; property: "source"; value:knob_button;  when: currentFocusIndex == btnid && focus_visible
        }
        Binding
        {
            target: button; property: "source"; value:non_pressed_button;  when: currentFocusIndex != btnid || !focus_visible
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
            if(idAppMain.isKeyCanceled)
            {
                idAppMain.isKeyCanceled = false;
                return;
            }

            if ( btnSelected )
            {
                topButton.jogDialSelectPressed(true)
                console.log( "DHAVN onBtnSelectedChanged : currentFocusIndex = " + currentFocusIndex);
//                if(currentFocusIndex != 27){ // Qt.Key_Back
//                    jdSelTimer.restart()
//                }
            }
            else
            {
                if(idAppMain.isDRSChange != true)
                topButton.jogDialSelectReleased(true)
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
            }

            onPressedOneShift:
            {
                if ( suffix == 'kor_shift'      ||
                        suffix == 'kor3_shift'  ||
                        suffix == 'cy_shift'        ||
                        suffix == 'arab2_shift' ||
                        suffix == 'eu_la_shift' ||
                        suffix == 'abc_shift')
                {
                    shiftmodeSuffix = "_sel";
                }
            }

            onPressedTwoShifts:
            {
                if ( suffix == 'kor_shift'      ||
                        suffix == 'kor3_shift'  ||
                        suffix == 'cy_shift'        ||
                        suffix == 'arab2_shift' ||
                        suffix == 'eu_la_shift' ||
                        suffix == 'abc_shift' )
                {
                    shiftmodeSuffix = "_lock";
                }
            }

            onResetShiftsPress:
            {
                if ( suffix == 'kor_shift'      ||
                        suffix == 'kor3_shift'  ||
                        suffix == 'cy_shift'        ||
                        suffix == 'arab2_shift' ||
                        suffix == 'eu_la_shift' ||
                        suffix == 'abc_shift' )
                {
                    shiftmodeSuffix = "";
                }
            }
        }


        Image
        {
            id: buttonIncreased

            source: pressed_button

            x:  -29
            y:  -133

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
                color:  "#FAFAFA"/*"#000000"*///[ITS 190808]
                styleColor:  "#FAFAFA"

                smooth: true
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
            visible: suffix.substr(suffix.indexOf("_")+1, suffix.length) != "done"
        }

        Image
        {
            id: buttonDone
            anchors.centerIn: parent;
            source: fontColor == "#5C5C5C" ? imageInfo.imgFolderKeypad + "icon_keypad_search_d.png" : imageInfo.imgFolderKeypad + "icon_keypad_search_n.png"
            visible: suffix.substr(suffix.indexOf("_")+1, suffix.length) == "done"
        }
    }

    function redrawButtonOnKeyPress(isTouchEvent)
    {

        if ( suffix == 'kor_character'      ||
                suffix == 'kor3_character'  ||
                suffix == 'cy_character'        ||
                suffix == 'arab2_character' ||
                suffix == 'eu_la_character' )
        {
//            currentFocusIndex = btnid;
            buttonIncreased.visible = false
            if(isTouchEvent)
            {
                buttonIncreased.visible = true
            }else
            {
                buttonIncreased.visible = false
                button.source = focus_pressed_button;
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
        if ( suffix == 'kor_character'      ||
                suffix == 'kor3_character'  ||
                suffix == 'cy_character'        ||
                suffix == 'arab2_character' ||
                suffix == 'eu_la_character' )
         {
            buttonIncreased.visible = false
         }

        if(disableForIntelliKeyboard == false)
            fontColor = "#FAFAFA"
        if(currentFocusIndex == btnid && focus_visible == true)
            button.source = knob_button
        else
            button.source = non_pressed_button
        focusExitDeleteLongRelease();
    }


    function redrawButtonOnKeyRelease2()
    {
         if ( suffix == 'kor_character' )
         {
             if (focus_visible == false)
             {
                 buttonIncreased.visible = false
             }
         }
        fontColor = "#7CBDFF"
         if(currentFocusIndex == btnid)
             button.source = knob_button
         else
            button.source = non_pressed_button
         focusExitDeleteLongRelease();
    }


    function changeButtonIncreased(symbol){
        text1.text = symbol
    }

}
