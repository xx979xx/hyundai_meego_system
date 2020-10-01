// { modified by Sergey 19.07.2013
import Qt 4.7
import "../DHAVN_VP_CONSTANTS.js" as CONST
import AppEngineQMLConstants 1.0


DHAVN_VP_FocusedItem
{
    id: main

    width:  button.width
    height: button.height

//    focus_visible: visible // commented by Sergey 25.10.2013 for new DivX

    property string divxButtonText: ""

    signal divxButtonClicked()


    onFocus_visibleChanged:
    {
        button.source = focus_visible ? "/app/share/images/video/btn_ok_f.png" : "/app/share/images/video/btn_ok_n.png"
    }

    // { modified by Sergey 28.08.2013 for ITS#187023
    onJogSelected:
    {
        switch ( status )
        {
            case UIListenerEnum.KEY_STATUS_PRESSED:
            {
                button.source = "/app/share/images/video/btn_ok_p.png"; // modified by Sergey 25.10.2013 for new DivX

                break;
            }

            case UIListenerEnum.KEY_STATUS_RELEASED:
            {
                button.source = "/app/share/images/video/btn_ok_f.png";
                divxButtonClicked();

                break;
            }

            case UIListenerEnum.KEY_STATUS_CANCELED:
            {
                button.source = "/app/share/images/video/btn_ok_f.png";

                break;
            }

            default:
                break;
        }
    }
    // } modified by Sergey 28.08.2013 for ITS#187023


    Image
    {
        id: button

        source: "/app/share/images/video/btn_ok_n.png"

        MouseArea
        {
            anchors.fill: parent
// modified by Dmitry 22.08.13 for ITS0185765
            onPressed: button.source = "/app/share/images/video/btn_ok_p.png"

            beepEnabled : false;//added for manualBeep 2014.06.19

            //onReleased:
            onClicked: //modified by edo.lee 2013.08.23
            {
                if (button.source == "file:///app/share/images/video/btn_ok_p.png")
                {
                    button.source = "/app/share/images/video/btn_ok_n.png"
                    divxButtonClicked()
                    EngineListenerMain.ManualBeep();//added for manualBeep 2014.06.19
                }
            }

            onExited: button.source = focus_visible ? "/app/share/images/video/btn_ok_f.png" : "/app/share/images/video/btn_ok_n.png"
        }

    }

    Text
    {
        anchors.fill: parent
        text : divxButtonText
        color: CONST.const_COLOR_TEXT_BRIGHT_GREY
        font.pointSize: 36
        font.family: CONST.const_FONT_FAMILY_NEW_HDB
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
// } modified by Sergey 19.07.2013
