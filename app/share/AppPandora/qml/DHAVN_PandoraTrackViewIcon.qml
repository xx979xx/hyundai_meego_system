import Qt 4.7
import "DHAVN_AppPandoraConst.js" as PR

Item {
    id: controlIcon

    property string iconText;

    x: 1054
    y: 185-93
    width: 210
    height: 45
    visible: false

    Image {
        source: "/app/share/images/pandora/bg_no_net.png"
        anchors.fill: parent
    }

    Text {
        text : iconText
        font.pointSize: 24
        font.family: PR.const_PANDORA_FONT_FAMILY_HDB
        color: "#9599A0" //KH GUI(149, 153, 160) //PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
