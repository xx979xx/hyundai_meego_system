import QtQuick 1.0
import AppEngineQMLConstants 1.0

Item
{
    id: container_drs

    width: 1280; height: 720

    property string image_path: "/app/share/images/AppIBox/"
    //property string image_path: "../../png/AppIBox/"
    property color  brighrGray: "#fafafa"
    property color  subTextGray: "#d4d4d4"

    signal popupClicked()


    Rectangle {
        id: bg_color

        anchors.fill: parent

        color: "#000000"
    }

    Image {
        id: image_popup_bg

        x: 93; y: 208

        source: image_path + "bg_type_a.png"

        Image {
            id: image_popup_btn

            x: 780; y: 25

            source: image_path + "btn_type_a_01_f.png"

            MouseArea {
                anchors.fill: parent

                onPressed: {
                    image_popup_btn.source = image_path + "btn_type_a_01_p.png"
                }

                onClicked: {
                    container_drs.popupClicked()
                    ViewWidgetController.backFromDRSPopup(UIListener.getCurrentScreen());
                    image_popup_btn.source = image_path + "btn_type_a_01_f.png"
                }

                onReleased: {
                    image_popup_btn.source = image_path + "btn_type_a_01_f.png"
                }
            }
        }

        Image {
            id: image_popup_light

            x: 773; y: 117

            source: image_path + "light.png"
        }

        Text {
            id: text_popup

            x: 78; y:0; width: 654; height: parent.height

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            text: qsTranslate( "main", "STR_DRS_POPUP" ) + LocTrigger.empty

            wrapMode: Text.WordWrap

            color: subTextGray

            font.family: (UIListener.GetCountryVariantFromQML() == 2) ? "CHINESS_HDR": "HDR"
            font.pointSize: 32
        }

        Text {
            id: text_popup_btn_name

            x: 832; width: 210

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 152

            text: qsTranslate( "main", "STR_POPUP_OK" ) + LocTrigger.empty

            color: brighrGray

            font.family: "DH_HDB"
            font.pointSize: 36
        }
    }

    Connections {
        target: EngineListener

        onRetranslateUi: {
            text_popup.text = qsTranslate( "main", "STR_DRS_POPUP" )
            text_popup_btn_name.text = qsTranslate( "main", "STR_POPUP_OK" )
        }
    }

    Connections {
        target: UIListener

        onSignalJogNavigation: {

            switch( arrow )
            {

            case UIListenerEnum.JOG_CENTER:
            {
                if (status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
                    //UIListener.ManualBeep()
                    image_popup_btn.source = image_path + "btn_type_a_01_p.png"
                }

                if (status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                    image_popup_btn.source = image_path + "btn_type_a_01_f.png"
                    container_drs.popupClicked()
                    ViewWidgetController.backFromDRSPopup(UIListener.getCurrentScreen());
                }
            }
            break

            }
        }
    }
}

