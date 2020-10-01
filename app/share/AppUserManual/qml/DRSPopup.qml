import QtQuick 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppUserManual_Images.js" as Images
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item
{
    id: container_drs

    width: 1280; height: 720//-93-72
    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property color  brightGray: Dimensions.const_AppUserManual_ListText_Color_BrightGrey // "#fafafa"
    Rectangle {
        id: bg_color
        anchors.fill: parent
        color: "#000000"
        Image {
            id: img_drs
            x: 100+462; y:289 // -165
            source:  Images.const_AppUserManual_DRSPopup
        }
        Text {
            id: text_popup
            x: 0; y:178+289//-165;
            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            text: qsTranslate( "main", "STR_MEDIA_IMAGE_DRIVING_REGULATION" ) + LocTrigger.empty

            wrapMode: Text.WordWrap

            color: brightGray

            font.family: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
            font.pointSize: 32
        }
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            MouseArea
            {
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" && mainFullScreen
                onClicked: {
                    if (appUserManual.state == "pdfScreenView" ) {
                        appUserManual.drsTouch()
                    }
                }
            }
        }
        Rectangle {
            x: 0; y: 0; width: 1280; height: 190
            color: "transparent"
            MouseArea
            {
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" && !mainFullScreen
                beepEnabled: false
                onClicked: {
                    if (appUserManual.state == "pdfScreenView" ) {
                        appUserManual.startTimer()
                    }
                }
            }
        }
        Rectangle {
            x: 0; y: 190; width: 1280; height: 720-190
            color: "transparent"
            MouseArea
            {
                anchors.fill: parent
                enabled: appUserManual.state == "pdfScreenView" && !mainFullScreen
                onClicked: {
                    if (appUserManual.state == "pdfScreenView" ) {
                        appUserManual.drsTouch()
                    }
                }
            }
        }
    }

    Connections {
        target: EngineListener

        onRetranslateUi:
        {
            console.log("DRSPopup.qml :: RetranslateUi Called.");
            text_popup.text = qsTranslate( "main", "STR_MEDIA_IMAGE_DRIVING_REGULATION" )

        }
    }
}

