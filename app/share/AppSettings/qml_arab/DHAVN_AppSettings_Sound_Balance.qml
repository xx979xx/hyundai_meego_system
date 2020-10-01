import QtQuick 1.0
import com.settings.variables 1.0
import "Components/InitializeBalanceButton"
import "DHAVN_AppSettings_General.js" as HM
import AppEngineQMLConstants 1.0

DHAVN_AppSettings_FocusedItem{
    id: fade_balance

    default_x: 0
    default_y: 0
    focus_x: 0
    focus_y: 0

    property int fade: 10
    property int balance: 10
    property real value_step: 13.5
    property string image_path: "/app/share/images/AppSettings/"

    property bool bJogCenterPressed: false

    Timer{
        id : saveTimer
        interval: 100
        running: false
        repeat: false

        onTriggered:
        {
            saveDB()
        }
    }

    function setPropertyValue(balance,fader)
    {
        SettingsStorage.balance = balance
        SettingsStorage.fader = fader
    }

    function saveDB()
    {
        var fade_value_converte

        fade_value_converte = Math.abs(20-fade)

        setPropertyValue (balance, fade_value_converte)

        //SettingsStorage.SaveSetting( fade_value_converte,  Settings.DB_KEY_SOUND_FADER ) // delete for ISV 100925
        //SettingsStorage.SaveSetting( balance,  Settings.DB_KEY_SOUND_BALANCE ) // delete for ISV 100925
        SettingsStorage.NotifyFaderChanged( fade_value_converte ) // add for ISV 100925
        SettingsStorage.NotifyBalanceChanged( balance ) // add for ISV 100925

        EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_FADER, fade_value_converte, "", UIListener.getCurrentScreen())
        EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_BALANCE, balance, "", UIListener.getCurrentScreen())

        //console.log("saveTimer stop")
        if(saveTimer.running) saveTimer.stop()
    }

    function init () {
        var fade_value_converte

        fade_value_converte = Math.abs(20-SettingsStorage.fader)

        fade = fade_value_converte
        balance = SettingsStorage.balance

        updateUI()
    }

    function updateUI () {
        axis_line_v.x = balance * value_step + 98
        axis_line_h.y = fade * value_step + 96

        setWave()
        updateResetButtonState()
    }

    function calc_fade (posY) {
        fade_balance.fade = posY / value_step
        //console.log("fade = " + fade_balance.fade)

        setWave()
        updateResetButtonState()
    }

    function calc_balance (posX) {
        fade_balance.balance = posX / value_step
        //console.log("balance = " + fade_balance.balance)

        setWave()
        updateResetButtonState()
    }

    function increaseFade() {
        if (fade<20)
            fade++

        updateUI()
        saveTimer.restart()
    }

    function decreaseFade() {
        if (fade>0)
            fade--

        updateUI()
        saveTimer.restart()
    }

    function increaseBalance() {
        if (balance<20)
            balance++

        updateUI()
        saveTimer.restart()
    }

    function decreaseBalance() {
        if (balance>0)
            balance--

        updateUI()
        saveTimer.restart()
    }

    function updateResetButtonState () {
        if (fade == 10 && balance == 10)
            resetbutton.setState("inactive")
        else
            resetbutton.setState("active")
    }

    function setWave(){
        var defaultValue = 10

        wave_a.source = image_path + "settings/sound/wave_a_" + defaultValue + ".png"
        wave_b.source = image_path + "settings/sound/wave_b_" + defaultValue + ".png"
        wave_c.source = image_path + "settings/sound/wave_c_" + defaultValue + ".png"

        wave_d.source = image_path + "settings/sound/wave_d_" + defaultValue + ".png"
        wave_e.source = image_path + "settings/sound/wave_e_" + defaultValue + ".png"

        wave_f.source = image_path + "settings/sound/wave_f_" + defaultValue + ".png"
        wave_g.source = image_path + "settings/sound/wave_g_" + defaultValue + ".png"

        wave_h.source = image_path + "settings/sound/wave_h_" + defaultValue + ".png"
        wave_i.source = image_path + "settings/sound/wave_i_" + defaultValue + ".png"
        wave_j.source = image_path + "settings/sound/wave_j_" + defaultValue + ".png"

        var wave_a_value = 10
        var wave_b_value = 10
        var wave_c_value = 10
        var wave_d_value = 10
        var wave_e_value = 10
        var wave_f_value = 10
        var wave_g_value = 10
        var wave_h_value = 10
        var wave_i_value = 10
        var wave_j_value = 10

        if (fade > 10)
        {
            var step = 20 - fade

            wave_a.source = image_path + "settings/sound/wave_a_" + parseInt(step) + ".png"
            wave_b.source = image_path + "settings/sound/wave_b_" + parseInt(step) + ".png"
            wave_c.source = image_path + "settings/sound/wave_c_" + parseInt(step) + ".png"

            wave_d.source = image_path + "settings/sound/wave_d_" +  parseInt(step) + ".png"
            wave_f.source = image_path + "settings/sound/wave_f_" +  parseInt(step) + ".png"

            wave_a_value = parseInt(step)
            wave_b_value = parseInt(step)
            wave_c_value = parseInt(step)

            wave_d_value = parseInt(step)
            wave_f_value = parseInt(step)
        }

        else if  (fade < 10)
        {
            var step = fade

            wave_h.source = image_path + "settings/sound/wave_h_" + parseInt(step) + ".png"
            wave_i.source = image_path + "settings/sound/wave_i_" + parseInt(step) + ".png"
            wave_j.source = image_path + "settings/sound/wave_j_" + parseInt(step) + ".png"

            wave_e.source = image_path + "settings/sound/wave_e_" + parseInt(step) + ".png"
            wave_g.source = image_path + "settings/sound/wave_g_" + parseInt(step) + ".png"

            wave_h_value = parseInt(step)
            wave_i_value = parseInt(step)
            wave_j_value = parseInt(step)

            wave_e_value = parseInt(step)
            wave_g_value = parseInt(step)
        }



        if (balance > 10)
        {
            var step = 20 - balance

            if (wave_a_value > parseInt(step))
            {
                wave_a.source = image_path + "settings/sound/wave_a_" + parseInt(step) + ".png"
                wave_a_value = parseInt(step)
            }

            if (wave_h_value > parseInt(step))
            {
                wave_h.source = image_path + "settings/sound/wave_h_" + parseInt(step) + ".png"
                wave_h_value = parseInt(step)
            }

            if (wave_d_value > parseInt(step))
            {
                wave_d.source = image_path + "settings/sound/wave_d_" + parseInt(step) + ".png"
                wave_d_value = parseInt(step)
            }

            if (wave_e_value > parseInt(step))
            {
                wave_e.source = image_path + "settings/sound/wave_e_" + parseInt(step) + ".png"
                wave_e_value = parseInt(step)
            }
        }

        else if  (balance < 10)
        {
            var step = balance

            if (wave_c_value > parseInt(step))
            {
                wave_c.source = image_path + "settings/sound/wave_c_" + parseInt(step) + ".png"
                wave_c_value = parseInt(step)
            }

            if (wave_j_value > parseInt(step))
            {
                wave_j.source = image_path + "settings/sound/wave_j_" + parseInt(step) + ".png"
                wave_j_value = parseInt(step)
            }

            if (wave_f_value > parseInt(step))
            {
                wave_f.source = image_path + "settings/sound/wave_f_" + parseInt(step) + ".png"
                wave_f_value = parseInt(step)
            }

            if (wave_g_value > parseInt(step))
            {
                wave_g.source = image_path + "settings/sound/wave_g_" + parseInt(step) + ".png"
                wave_g_value = parseInt(step)
            }
        }
    }

    Item {
        id: sound_seat

        x: 76; y: 114; width: bg_sound_seat.width; height: bg_sound_seat.height

        property bool is_focusable: true
        property bool is_focusMovable: true
        property bool focus_visible: false

        property string name: "BalanceControl"
        property int focus_x: 0
        property int focus_y: 0

        signal lostFocus( int event, int focusID )

        property bool focused_horizental: true

        function setDefaultFocus()
        {
            axis_point.source = image_path + "settings/axis_point_s.png"
            axis_line_h.source = image_path + "settings/axis_line_h_s.png"
            return true
        }

        function hideFocus()
        {
            sound_seat.focus_visible = false
        }

        function showFocus()
        {
            sound_seat.focus_visible = true
        }

        onFocus_visibleChanged: {
            if (focus_visible)
            {
                if (resetbutton.active)
                    rootSound.setVisualCue(true, true, false, true)
                else
                    rootSound.setVisualCue(true, false, false, true)

                axis_point.source = image_path + "settings/axis_point_s.png"
                axis_line_h.source = image_path + "settings/axis_line_h_s.png"
            }
            else
            {
                bJogCenterPressed = false
                focused_horizental = true
                axis_point.source = image_path + "settings/axis_point_n.png"
                axis_line_h.source = image_path + "settings/axis_line_h_n.png"
                axis_line_v.source = image_path + "settings/axis_line_v_n.png"
            }
        }

        onFocused_horizentalChanged: {
            if (focused_horizental)
            {
                axis_line_h.source = image_path + "settings/axis_line_h_s.png"
                axis_line_v.source = image_path + "settings/axis_line_v_n.png"
            }
            else
            {
                axis_line_h.source = image_path + "settings/axis_line_h_n.png"
                axis_line_v.source = image_path + "settings/axis_line_v_s.png"
            }
        }

        function handleJogEvent( event, status, bRRC )
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                switch ( event )
                {
                case UIListenerEnum.JOG_UP:
                case UIListenerEnum.JOG_DOWN:
                case UIListenerEnum.JOG_LEFT:
                case UIListenerEnum.JOG_RIGHT:
                {
                    sound_seat.lostFocus( event, 0 )
                }
                break

                case UIListenerEnum.JOG_CENTER: //SELECT
                {
                    bJogCenterPressed = true
                }
                break
                }
            }

            if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
                switch ( event )
                {
                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    if (focused_horizental)
                    {
                        increaseFade()
                    }
                    else
                    {
                        decreaseBalance()
                    }

                }
                break

                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    if (focused_horizental)
                    {
                        decreaseFade()
                    }
                    else
                    {
                        increaseBalance()
                    }
                }
                break

                case UIListenerEnum.JOG_CENTER: //SELECT
                {
                    if(bJogCenterPressed)
                        bJogCenterPressed = false
                    else
                        return

                    if (focused_horizental)
                        focused_horizental = false
                    else
                        focused_horizental = true
                }
                break

                }
            }
        }

        Image {
            id: bg_sound_seat
            source: image_path + "settings/bg_sound_seat.png"
        }

        Image {
            id: wave_a

            x: 61; y:27
            source: image_path + "settings/sound/wave_a_5.png"
        }

        Image {
            id: wave_b

            x: wave_a.x + 29; y: 27
            source: image_path + "settings/sound/wave_b_5.png"
        }

        Image {
            id: wave_c

            x: wave_b.x + 198; y: 27
            source: image_path + "settings/sound/wave_c_5.png"
        }

        Image {
            id: wave_d

            x: 57; y:78
            source: image_path + "settings/sound/wave_d_5.png"
        }

        Image {
            id: wave_e

            x: 57; y: wave_d.y + 131
            source: image_path + "settings/sound/wave_e_5.png"
        }

        Image {
            id: wave_f

            x: wave_d.x + 265; y: wave_d.y
            source: image_path + "settings/sound/wave_f_5.png"
        }

        Image {
            id: wave_g

            x: wave_e.x + 265; y: wave_e.y
            source: image_path + "settings/sound/wave_g_5.png"
        }

        Image {
            id: wave_h

            x: wave_a.x; y:wave_i.y + 12
            source: image_path + "settings/sound/wave_h_5.png"
        }

        Image {
            id: wave_i

            x: wave_b.x; y: 286
            source: image_path + "settings/sound/wave_i_5.png"
        }

        Image {
            id: wave_j

            x: wave_c.x; y:wave_i.y + 12
            source: image_path + "settings/sound/wave_j_5.png"
        }

        Image {
            id: axis_line_h

            x: 98; y: 96 + 135
            source: image_path + "settings/axis_line_h_n.png"
        }

        Image {
            id: axis_line_v

            x: 98+ 135; y: 96
            source: image_path + "settings/axis_line_v_n.png"
        }

        Image {
            id: axis_point

            x: axis_line_v.x -20; y: axis_line_h.y -20
            source: image_path + "settings/axis_point_n.png"
        }

        MouseArea {
            x: 98-60; y: 96-60; width: 270+120; height: 270+120

            onPressed: {
                //console.log("onPressed: mouse.x:"+mouse.x+", mouse.y:"+mouse.y)
                // -> added for ITS 217705 Focus does not appear when changing the Fade/Balance
                console.log("[QML] Balance :: Touch Pressed ---")

                fade_balance.hideFocus()
                fade_balance.setFocusHandle(0, 0)
                fade_balance.showFocus()

                if (resetbutton.active)
                    rootSound.setVisualCue(true, true, true, false)
                else
                    rootSound.setVisualCue(true, false, true, false)

                // <- added for ITS 217705 Focus does not appear when changing the Fade/Balance

                if (mouse.x-60 >= -60 && mouse.x-60 <= 330 )
                {
                    if (mouse.x-60 <= 0)
                        axis_line_v.x = 0 + 98
                    else if (mouse.x-60 >= 270)
                        axis_line_v.x = 270 + 98
                    else
                        axis_line_v.x = mouse.x-60 + 98
                }
                if( mouse.y-60 >= -60 && mouse.y-60 <= 330 )
                {
                    if (mouse.y-60 <= 0)
                        axis_line_h.y = 0 + 96
                    else if (mouse.y-60 >= 270)
                        axis_line_h.y = 270 + 96
                    else
                        axis_line_h.y = mouse.y-60 + 96
                }

                if (mouse.x-60 >= -60 && mouse.x-60 <= 330 )
                {
                    if (mouse.x-60 <= 0)
                        calc_balance(0)
                    else if (mouse.x-60 >= 270)
                        calc_balance(270)
                    else
                        calc_balance(mouse.x-60)
                }

                if (mouse.y-60 >= -60 && mouse.y-60 <= 330)
                {
                    if (mouse.y-60 <= 0)
                        calc_fade(0)
                    else if (mouse.y-60 >= 270)
                        calc_fade(270)
                    else
                        calc_fade(mouse.y-60)
                }

                saveTimer.restart()
            }

            onPositionChanged: {
                //console.log("onPositionChanged: mouse.x:"+mouse.x+", mouse.y:"+mouse.y)
                if (mouse.x-60 >= -60 && mouse.x-60 <= 330 )
                {
                    if (mouse.x-60 <= 0)
                    {
                        axis_line_v.x = 0 + 98
                        calc_balance(0)
                    }

                    else if (mouse.x-60 >= 270)
                    {
                        axis_line_v.x = 270 + 98
                        calc_balance(270)
                    }
                    else
                    {
                        axis_line_v.x = mouse.x-60 + 98
                        calc_balance(mouse.x-60)
                    }
                    saveTimer.restart()
                }

                if (mouse.y-60 >= -60 && mouse.y-60 <= 330)
                {
                    if (mouse.y-60 <= 0)
                    {
                        axis_line_h.y = 0 + 96
                        calc_fade(0)

                    }

                    else if (mouse.y-60 >= 270)
                    {
                        axis_line_h.y = 270 + 96
                        calc_fade(270)
                    }

                    else
                    {
                        axis_line_h.y = mouse.y-60 + 96
                        calc_fade(mouse.y-60)
                    }
                    saveTimer.restart()
                }
            }
        }
    }

    function getFadeText()
    {
        if( fade < 10 )
            return qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_FADER_FRONT"))
        else if ( fade > 10)
            return qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_FADER_BACK"))
        else
            return qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_FADER_FRONT")) + "=" +
                    qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_FADER_BACK"))
    }

    function getFadeValue()
    {
        var value = fade - 10

        if(value < 0 )          return (value * -1) + "="
        else if (value > 0 )    return value + "="
        else                    return ""
    }

    function getBalanceText()
    {
        if( balance > 10 )
            return qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_BALANCE_RIGHT"))
        else if ( balance < 10 )
            return qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_BALANCE_LEFT"))
        else
            return qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_BALANCE_LEFT")) + "=" +
                    qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_BALANCE_RIGHT"))
    }

    function getBalanceValue()
    {
        var value = balance - 10

        if( value < 0 )         return (value * -1) + "="
        else if (value > 0 )    return value + "="
        else                    return ""
    }

    Text{
        id: balanceTxt
        width: 165
        horizontalAlignment: Text.AlignRight
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 116
        anchors.left: parent.left
        anchors.leftMargin: 124
        text: getBalanceValue() + getBalanceText() + " " + qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_BALANCE")) + LocTrigger.empty
        font.pointSize: 26
        color: HM.const_COLOR_TEXT_BRIGHT_GREY
        font.family: EngineListener.getFont(false)
    }

    Text{
        id: fadeTxt
        width: 165
        horizontalAlignment: Text.AlignLeft
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 116
        anchors.left: balanceTxt.right
        anchors.leftMargin: 45
        text: getFadeValue() + getFadeText() + " " + qsTranslate(HM.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SOUND_FADER")) + LocTrigger.empty
        font.pointSize: 26
        color: HM.const_COLOR_TEXT_BRIGHT_GREY
        font.family: EngineListener.getFont(false)
    }

    DHAVN_AppSettings_InitializeBalanceButton{
        id: resetbutton
        x: sound_seat.x + 47
        y: sound_seat.y + 426

        is_focusMovable: active

        focus_x: 0
        focus_y: 1

        onResetButtonClicked:
        {
            if(SettingsStorage.NotifyBalanceFaderResetChanged())
            {
                if(focus_visible)
                    moveFocus( 0, -1 )

                fade = 10
                balance = 10
                setPropertyValue(balance, fade)
                updateUI()

                EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_FADER, fade, "", UIListener.getCurrentScreen())
                EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_BALANCE, balance, "", UIListener.getCurrentScreen())
            }
        }

        onJogSelected:
        {
            if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
                if(SettingsStorage.NotifyBalanceFaderResetChanged())
                {
                    if(focus_visible)
                        moveFocus( 0, -1 )

                    fade = 10
                    balance = 10
                    setPropertyValue(balance, fade)
                    updateUI()

                    EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_FADER, fade, "", UIListener.getCurrentScreen())
                    EngineListener.NotifyApplication(Settings.DB_KEY_SOUND_BALANCE, balance, "", UIListener.getCurrentScreen())
                }
            }
        }

        onFocus_visibleChanged:
        {
            if (focus_visible)
            {
                rootSound.setVisualCue(true, false, false, true)
            }
        }

        onActiveChanged:
        {
            if(!active)
            {
                moveFocus( 0, -1 )
            }

            if(sound_seat.focus_visible)
            {
                if(active)
                    rootSound.setVisualCue(true, true, false, true)
                else
                    rootSound.setVisualCue(true, false, false, true)
            }
        }
    }


    Connections{
        target:SettingsStorage

        onBalanceChanged:  {
            balance = SettingsStorage.balance
            updateUI()
        }

        onFaderChanged: {
            //fade = SettingsStorage.fader

            var fade_value_converte

            fade_value_converte = Math.abs(20-SettingsStorage.fader)

            fade = fade_value_converte

            updateUI()
        }
    }
}

