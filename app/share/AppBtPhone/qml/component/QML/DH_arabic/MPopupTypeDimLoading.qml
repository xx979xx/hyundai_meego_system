/**
 * /QML/DH_arabic/MPopupTypeDimLoading.qml
 *
 */

import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MComponent
{
    id: bt_Popup_Dim_Loading_1Line
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    // PROPERTIES
    property string popupName
    property string firstText: ""
    property bool black_opacity: true


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == bt_Popup_Dim_Loading_1Line.visible) {
            popupBackGroundBlack = black_opacity
        }
    }

    onVisibleChanged: {
        if(true == bt_Popup_Dim_Loading_1Line.visible) {
            popupBackGroundBlack = black_opacity
        }
    }

    /* WIDGETS */
    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: (true == black_opacity) ? 0.6 : 1
    }

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_c.png"
        x: 250
        y: 454 - systemInfo.statusBarHeight
        width: 780
        height: 208

        DDLoadingPopupAnimation{
            id: idImageContainer
            x: 352
            y: 36
        }

        Text {
            id: firstLine
            text: firstText
            x: 34
            y: 130
            width: 712
            height: 36
            font.pointSize: 36
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            wrapMode: Text.WordWrap
        }
    }
}
/* EOF */
