import QtQuick 1.1
import AppEngineQMLConstants 1.0

Item {
    id: drsPopupUI
    width: 1280; height: 720

    property string internal_png_path: "/app/share/images/AppIBox/"

    property color  brighrGray: "#fafafa"
    property int statusbarHeight: 93

    Rectangle {
        id: backgroundColor

        width: parent.width; height: parent.height
        color: "black"
    }

    Image {
        id: icon_drs

        x: 562; y: 289
        width:162; height:161
        source: internal_png_path + "ico_block_image.png"
    }

    Text {
        id: text_drs

        width: parent.width

        anchors.top: icon_drs.bottom

        font.family: (UIListener.GetCountryVariantFromQML() == 2) ? "CHINESS_HDR": "HDR"
        font.pointSize: 32

        color: brighrGray
        horizontalAlignment:Text.AlignHCenter

        text: qsTranslate( "main", "STR_APP_DRS_MESSAGE" )
    }

    Connections {
        target: EngineListener

        onRetranslateUi: {
            text_drs.text = qsTranslate( "main", "STR_APP_DRS_MESSAGE" )
        }
    }

    // SEND_BACKKEYON_TO_MOSTMANAGER
    ImageButton {
        id: drsPopBackBtn
        x:1136; y:statusbarHeight
        width: 141; height: 72

        img_n: internal_png_path + "btn_title_back_f.png"
        img_p: internal_png_path + "btn_title_back_p.png"

        onClicked: EngineListener.EnterDRSSoftBackKey();
    }

    Connections {
        target: UIListener

        onSignalShowSystemPopup: {
            console.log("[QML] onSignalShowSystemPopup")
            drsPopBackBtn.img_n = internal_png_path + "btn_title_back_n.png"
            drsPopBackBtn.bPressed = false;
        }
        onSignalHideSystemPopup: {
            console.log("[QML] onSignalHideSystemPopup")
            drsPopBackBtn.img_n = internal_png_path + "btn_title_back_f.png"
        }

        onSignalJogNavigation: {
            switch( arrow )
            {

            case UIListenerEnum.JOG_CENTER:
            {
                if (status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
                    //UIListener.ManualBeep()
                    drsPopBackBtn.bPressed = true;
                }
                else if (status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                    drsPopBackBtn.bPressed = false;
                    EngineListener.EnterDRSSoftBackKey();
                }
                else if (status == UIListenerEnum.KEY_STATUS_CANCELED)
                {
                    drsPopBackBtn.bPressed = false;
                }
            }
            break

            }
        }
    }


}
