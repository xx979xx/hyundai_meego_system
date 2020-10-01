import QtQuick 1.0
import QmlStatusBar 1.0
import "DHAVN_AppClock_Main_DHPE.js" as HM

Item
{
    id: container_eTest

    width: 1280; height: 720//-93-72

    function eCallTypeChanged(type)
    {
        text_sos.text = ""

        if(type == 0) {
            text_sos.text = qsTranslate( "main", "STR_STANDBY_SOS" ) + EngineListener.empty
            text_sos.color = Qt.rgba(255/255, 0/255, 0/255, 1)
            img_ico_caution.source = ""
            img_ico_caution.source = "/app/share/images/AppStandBy/eCall/ico_caution_r.png"
        }
        else {
            text_sos.text = qsTranslate( "main", "STR_STANDBY_SOS_TEST" ) + EngineListener.empty
            text_sos.color = HM.const_COLOR_TEXT_BRIGHT_GREY
            img_ico_caution.source = ""
            img_ico_caution.source = "/app/share/images/AppStandBy/eCall/ico_caution_w.png"
        }
    }

    QmlStatusBar {
        id: statusBar
        x: 0; y: 0; z:10000; width: 1280; height: 93
        homeType: "none"
        middleEast: (langID == 20 ) ? true : false
    }

    Image {
        id: img_bg_main
        anchors.fill: parent
        source: "/app/share/images/AppStandBy/bg_main.png";

        Image {
            id: img_bg_frame
            source: "/app/share/images/AppStandBy/eCall/bg_frame.png"
            x: 70;  y: 129
        }
        Image {
            id: img_ico_caution
//            source: "/app/share/images/AppStandBy/eCall/ico_caution_r.png"
            x: 140+410;  y: 264
        }

        Text {
            id: text_sos
            x: 140;             y: 264+212-64
            width: 410+590
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.family:  "DH_HDR"
            font.pointSize: 96
        }
    }

    Connections {
        target: EngineListener

        onRetranslateUi:
        {
        }

        onChangeECallType:
        {
           eCallTypeChanged(type);
        }
    }
}

