import QtQuick 1.1
import AppEngineQMLConstants 1.0

Item{
    id: pushButton

    property int focusID: -1
    property bool focus_visible: false
    property bool active: false
    property string suffix: ""
    property string non_pressed_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_n.png"
    property string pressed_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_p.png"
    property string focus_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_f.png"
    property string selected_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_s.png"
    property string focus_pressed_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_fp.png"
    property string disable_button: "/app/share/images/Qwertykeypad/btn_" + suffix + "_d.png"

    signal pushButtonClicked()
    signal pushButtonReleased()
    signal jogSelected(int status)
    signal lostFocus( int arrow, int status )

    function setState(s)
    {
        switch (s)
        {
        case "active":
        {
            pushButton.active = true
            break;
        }
        case "inactive":
        {
            pushButton.active = false
            break;
        }

        }
    }

    Image{
        id:btn_image
        source: non_pressed_button

        MouseArea{
            id: btn_image_area
            anchors.fill: parent
            beepEnabled: pushButton.active //modify for ITS 225378
            noClickAfterExited: true

            onPressed:
            {
                // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                if(isFocusedBtnSelected)
                    return

                if( pushButton.active )
                {
                    btn_fp.visible = true
                }
            }
            //onCanceled: pressImageR.visible = false

            onClicked:
            {
                // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                if(isFocusedBtnSelected)
                    return

                if( pushButton.active )
                {
                    btn_fp.visible = false
                    pushButtonClicked()
                }
            }

            onReleased:
            {
                // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                if(isFocusedBtnSelected)
                    return

                btn_fp.visible = false
            }

            onExited:
            {
                // (Clone Mode) - Block front-touch when button is jog-pressed by RRC
                if(isFocusedBtnSelected)
                    return

                btn_fp.visible = false
            }
        }
    }

    Image{
        id: btn_f
        source: focus_button
        visible: ( pushButton.focus_visible && (!btn_fp.visible) )
    }

    Image{
        id: btn_fp
        source: focus_pressed_button
        visible: false
    }

    Image{
        id: btn_d
        source: disable_button
        visible: !active
    }

    function handleJogEvent( arrow, status )
    {
        switch ( arrow )
        {
        case UIListenerEnum.JOG_UP: //UP
        case UIListenerEnum.JOG_DOWN: //DOWN
        case UIListenerEnum.JOG_LEFT: //LEFT
        case UIListenerEnum.JOG_RIGHT: //RIGHT
        case UIListenerEnum.JOG_WHEEL_LEFT:
        case UIListenerEnum.JOG_WHEEL_RIGHT:
        case UIListenerEnum.JOG_BOTTOM_LEFT:
        case UIListenerEnum.JOG_BOTTOM_RIGHT:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                pushButton.lostFocus( arrow, status )
            }
        }
        break
        case UIListenerEnum.JOG_CENTER: //SELECT
        {
            switch ( status )
            {
            case UIListenerEnum.KEY_STATUS_PRESSED:
            {
                if( pushButton.active && focus_visible)
                {
                    btn_fp.visible = true
                }
            }
            break

            case UIListenerEnum.KEY_STATUS_RELEASED:
            {
                if( pushButton.active && focus_visible)
                {
                    btn_fp.visible = false
                    pushButtonReleased()
                }
            }
            break
            }
        }
        break
        }
    }

    Connections{
        target: ( (pushButton.visible) && (pushButton.focus_visible) ) ? UIListener : null

        onSignalJogNavigation:
        {
            switch ( arrow )
            {
            case UIListenerEnum.JOG_UP:
            case UIListenerEnum.JOG_RIGHT:
            case UIListenerEnum.JOG_DOWN:
            case UIListenerEnum.JOG_LEFT:
            case UIListenerEnum.JOG_WHEEL_LEFT:
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            case UIListenerEnum.JOG_CENTER:
            case UIListenerEnum.JOG_BOTTOM_LEFT:
            case UIListenerEnum.JOG_BOTTOM_RIGHT:
            {
                handleJogEvent( arrow, status )
            }
            break
            }
        }
    }
}
