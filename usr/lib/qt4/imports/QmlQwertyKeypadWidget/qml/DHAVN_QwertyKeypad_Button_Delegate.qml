import QtQuick 1.1

Item{
    id: root
    property int btnid: 0
    property int keycode: -1
    property int textVerticalOffSet: 0
    property bool btnEnabled: true
    property string keytext: ""
    property string suffix: ""
    property int fontSize: 50
    property string fontColor: "#FAFAFA"
    property variant transitionIndex: [0]
    property bool longPressFlag: false
    property string non_pressed_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_n.png"
    property string pressed_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_p.png"
    property string knob_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_f.png"
    property string selected_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_s.png"
    property string focus_pressed_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_fp.png"
    property string disable_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_d.png"

    property string non_pressed_sel_button: getNormalShiftImage("_sel")
    property string pressed_sel_button: getPressedShiftImage("_sel")
    property string knob_sel_button: getFocusedShiftImage("_sel")
    property string focus_pressed_sel_button: getFocusedPressShiftImage("_sel")

    property string non_pressed_lock_button: getNormalShiftImage("_lock")
    property string pressed_lock_button: getPressedShiftImage("_lock")
    property string knob_lock_button: getFocusedShiftImage("_lock")
    property string focus_pressed_lock_button: getFocusedPressShiftImage("_lock")
    property string disable_lock_button: getDisabledShiftImage("_lock")

    signal jogDialSelectPressed( bool isPress )
    signal jogDialSelectLongPressed( bool isPress )
    signal jogDialSelectReleased( bool isPress )


    // (Select / Lock) Normal Image
    function getNormalShiftImage(type)
    {
        if ( suffix == 'kor_shift'      ||
                suffix == 'cy_shift'    ||
                suffix == 'abc_shift'   ||
                suffix == 'eu_la_shift' ||
                suffix == 'eu_la2_shift')
            return "/app/share/images/Qwertykeypad/btn_" + suffix + type + "_n.png"
        else
            return ""
    }

    // [Shift] Focus Button
    function getFocusedShiftImage(type)
    {
        if ( suffix == 'kor_shift'      ||
                suffix == 'cy_shift'    ||
                suffix == 'abc_shift'   ||
                suffix == 'eu_la_shift' ||
                suffix == 'eu_la2_shift')
            return "/app/share/images/Qwertykeypad/btn_" + suffix + type + "_f.png"
        else
            return ""
    }

    // [Shift] Press Button
    function getPressedShiftImage(type)
    {
        if ( suffix == 'kor_shift'      ||
                suffix == 'cy_shift'    ||
                suffix == 'abc_shift'   ||
                suffix == 'eu_la_shift' ||
                suffix == 'eu_la2_shift')
            return "/app/share/images/Qwertykeypad/btn_" + suffix + type + "_p.png"
        else
            return ""
    }

    // [Shift] Focus Press Button
    function getFocusedPressShiftImage(type)
    {
        if ( suffix == 'kor_shift'      ||
                suffix == 'cy_shift'    ||
                suffix == 'abc_shift'   ||
                suffix == 'eu_la_shift' ||
                suffix == 'eu_la2_shift')
            return "/app/share/images/Qwertykeypad/btn_" + suffix + type + "_fp.png"
        else
            return ""
    }

    // [Shift] Disable Button
    function getDisabledShiftImage(type)
    {
        if ( suffix == 'kor_shift')
            return "/app/share/images/Qwertykeypad/btn_" + suffix + type + "_d.png"
        else
            return ""
    }

    function jogDialSelectPressedHandle(isPress)
    {
        //translate.printLogMessage("[QML][Button_Delegate]jogDialSelectPressedHandle")
        root.jogDialSelectPressed(isPress)
    }

    function jogDialSelectLongPressedHandle(isPress)
    {
        //translate.printLogMessage("[QML][Button_Delegate]jogDialSelectLongPressedHandle")
        root.jogDialSelectLongPressed(isPress)
    }

    function jogDialSelectReleasedHandle(isPress)
    {
        //translate.printLogMessage("[QML][Button_Delegate]jogDialSelectReleasedHandle")
        root.jogDialSelectReleased(isPress)
    }

    function redrawButtonOnKeyPress()
    {
         //translate.printLogMessage("[QML][Button_Delegate]redrawButtonOnKeyPress")
        if ( buttonLoader.status == Loader.Ready )
        {
            buttonLoader.item.redrawButtonOnKeyPress()
        }
    }

    function redrawButtonOnKeyRelease(isDoubleShifted)
    {
        //translate.printLogMessage("[QML][Button_Delegate]redrawButtonOnKeyRelease")
        //translate.printLogMessage("[QML][Button_Delegate] : redrawButtonOnKeyRelease : btnid :" + btnid)
        //translate.printLogMessage("[QML][Button_Delegate] : redrawButtonOnKeyRelease : currentFocusIndex :" + currentFocusIndex)
        //translate.printLogMessage("[QML][Button_Delegate] : redrawButtonOnKeyRelease : prevFocusIndex :" + prevFocusIndex)
        if ( buttonLoader.status == Loader.Ready )
        {
            buttonLoader.item.redrawButtonOnKeyRelease(isDoubleShifted)
        }
    }

    function redrawJogCenterPress()
    {
        //translate.printLogMessage("[QML][Button_Delegate]redrawJogCenterPress")
        if ( buttonLoader.status == Loader.Ready )
        {
            buttonLoader.item.redrawJogCenterPress()
        }
    }

    function redrawJogCenterRelease(isDoubleShifted)
    {
        //translate.printLogMessage("[QML][Button_Delegate]redrawJogCenterRelease")
        if ( buttonLoader.status == Loader.Ready )
        {
            buttonLoader.item.redrawJogCenterRelease(isDoubleShifted)
        }
    }

    function changeButtonIncreased(symbol)
    {
        //translate.printLogMessage("[QML][Button_Delegate]changeButtonIncreased")
        if ( buttonLoader.status == Loader.Ready )
        {
            buttonLoader.item.changeButtonIncreased(symbol)
        }
    }

    function getSource()
    {
        if( suffix == 'kor_character'  ||
                suffix == 'kor3_character' ||
                suffix == 'me_character'   ||
                suffix == 'eu_la_character'||
                suffix == 'me_01_character'||
                suffix == 'me_02_character'||
                suffix == 'eu_la2_character')
            return "DHAVN_QwertyKeypad_Button_Character.qml"

        else if( suffix == 'kor_shift'   ||
                suffix == 'cy_shift'    ||
                suffix == 'abc_shift'   ||
                suffix == 'eu_la_shift' ||
                suffix == 'eu_la2_shift')
            return "DHAVN_QwertyKeypad_Button_Shift.qml"

        else if ( suffix == 'kor_done'   ||
                 suffix == 'kor3_done'  ||
                 suffix == 'eu_la_done' ||
                 suffix == 'me_done'    ||
                 suffix == 'chn_done'   ||
                 suffix == 'chn_done_02' )
            return "DHAVN_QwertyKeypad_Button_Done.qml"

        else if ( suffix =='kor_page'    ||
                 suffix == 'eu_la_page'  ||
                 suffix == 'cy_page' ||
                 suffix == 'eu_la2_page')
            return "DHAVN_QwertyKeypad_Button_Page.qml"

        else if( suffix == "chn_charater_01" ||
                suffix == "chn_charater_02" ||
                suffix == "chn_charater_03" ||
                suffix == "chn_charater_04" ||
                suffix == "chn_charater_05" ||
                suffix == "chn_charater_06" ||
                suffix == "chn_charater_07" ||
                suffix == "chn_charater_08" ||
                suffix == "chn_charater_09")
            return "DHAVN_QwertyKeypad_Button_Character_HWR.qml"

        else
            return "DHAVN_QwertyKeypad_Button_Others.qml"
    }

    Loader{
        id: buttonLoader
        source: getSource()

        function initConnection()
        {
            if(item != null)
            {
                buttonLoader.item.jogDialSelectPressed.connect( root.jogDialSelectPressedHandle )
                buttonLoader.item.jogDialSelectLongPressed.connect( root.jogDialSelectLongPressedHandle )
                buttonLoader.item.jogDialSelectReleased.connect( root.jogDialSelectReleasedHandle )
            }
        }

        onStatusChanged:
        {
            //translate.printLogMessage("[QML][Button_Delegate]onStatusChanged")
            if(status == Loader.Ready)
            {
                initConnection()
            }
        }
    }

    onBtnEnabledChanged:
    {
        //translate.printLogMessage("[QML][Button_Delegate]onBtnEnabledChanged")
        //translate.printLogMessage("[QML][Button_Delegate] : redrawButtonOnKeyRelease : btnid :" + btnid)
        //translate.printLogMessage("[QML][Button_Delegate] : redrawButtonOnKeyRelease : currentFocusIndex :" + currentFocusIndex)
        //translate.printLogMessage("[QML][Button_Delegate] : redrawButtonOnKeyRelease : prevFocusIndex :" + prevFocusIndex)
        if(buttonLoader.item != null)
            buttonLoader.item.setEnableButton()
    }
}

