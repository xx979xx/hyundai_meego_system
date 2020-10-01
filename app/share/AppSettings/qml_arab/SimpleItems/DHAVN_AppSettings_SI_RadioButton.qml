import QtQuick 1.1
import "DHAVN_AppSettings_SI_RadioList.js" as HM
import "../DHAVN_AppSettings_Resources.js" as RES
import AppEngineQMLConstants 1.0
import "../Components/ScrollingTicker"

Item{
    id: radioButton

    property bool checked: false
    property bool pressed: false
    property bool highlight: false
    property bool focus_selected: false
    property string __lang_context: HM.const_LANGCONTEXT

    width: 550
    height: 89

    onHighlightChanged: {
        if(!highlight)
            pressed = false
    }

    Image{
        id: line_image
        anchors.top: parent.top
        anchors.topMargin: 89
        anchors.left: parent.left
        anchors.leftMargin: 45
        source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
    }

    Image{
        id:radio_f_id
        anchors.top: line_image.top
        anchors.topMargin: -90
        anchors.left: line_image.left
        anchors.leftMargin: -45
        source: RES.const_URL_IMG_SETTINGS_B_BG_MENU_TAB_R_FOCUSED
        visible: radioButton.highlight && !radioButton.pressed && !radio_p_id.visible
    }

    Image{
        id:radio_p_id
        anchors.top: line_image.top
        anchors.topMargin: -90
        anchors.left: line_image.left
        anchors.leftMargin: -45
        source: RES.const_URL_IMG_SETTINGS_B_BG_MENU_TAB_R_PRESSED
        visible: radioButton.pressed
    }

    ScrollingTicker {
        id: scrollingTicker
        clip: true
        width: 443
        height: 89
        scrollingTextMargin: 120
        anchors.verticalCenter: line_image.top
        anchors.verticalCenterOffset: -45
        anchors.left: line_image.left
        anchors.leftMargin: 36
        isScrolling: radioButton.highlight && isParkingMode
        fontPointSize: 40
        fontFamily: EngineListener.getFont(false)
        text: qsTranslate( __lang_context, title_of_radiobutton) + LocTrigger.empty
        fontStyle: Text.Sunken
        fontColor: radioList.font_color
    }

    Image{
        id: radioImage
        anchors.top: line_image.top
        anchors.topMargin: -68
        anchors.left: line_image.left
        anchors.leftMargin: -31
        source: radioButton.checked ? HM.const_URL_IMG_GENERAL_RADIO_S : HM.const_URL_IMG_GENERAL_RADIO_N
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        enabled: enable
        beepEnabled: false

        onPressed: radioButton.pressed = true
        onReleased:
        {
            if (radio_p_id.visible)
            {
                SettingsStorage.callAudioBeepCommand()
                indexSelected( index, false )
            }

            radioButton.pressed = false
        }
        onExited: radioButton.pressed = false
        onCanceled: radioButton.pressed = false
    }

    Connections{
        target: radioButton.highlight ? UIListener: null

        onSignalJogNavigation:
        {
            // -> add code [ISV 96346] 부팅 완료 후 일반 연속으로 선택시 언어화면에 커서 표시 오류
            if((rootPopUpLoader.visible || rootToastPopUpLoader.visible))
            {
                if(radioButton.pressed)
                    radioButton.pressed = false
                return;
            }
            // <-

            if ( arrow == UIListenerEnum.JOG_CENTER )
            {
                switch(status)
                {
                case UIListenerEnum.KEY_STATUS_PRESSED:
                {
                    radioButton.pressed = true
                }
                break
                case UIListenerEnum.KEY_STATUS_RELEASED:
                {
                    if(radioButton.pressed)
                    {
                        radioButton.pressed = false
                        indexSelected( index, true )
                    }
                }
                break
                case UIListenerEnum.KEY_STATUS_CANCELED:
                {
                    radioButton.pressed = false
                }
                break
                }
            }
        }
    }

    // -> Add code for defending.[ISV 96346] 부팅 완료 후 일반 연속으로 선택시 언어화면에 커서 표시 오류
    Connections{
        target: radioButton.focus_selected ? rootPopUpLoader : null

        onVisibleChanged:
        {
            if(rootPopUpLoader.visible)
            {
                if(radioButton.pressed)
                    radioButton.pressed = false
            }
        }
    }

    Connections{
        target: radioButton.focus_selected ? rootToastPopUpLoader : null

        onVisibleChanged:
        {
            if(rootToastPopUpLoader.visible)
            {
                if(radioButton.pressed)
                    radioButton.pressed = false
            }
        }
    }
    // <-
}
