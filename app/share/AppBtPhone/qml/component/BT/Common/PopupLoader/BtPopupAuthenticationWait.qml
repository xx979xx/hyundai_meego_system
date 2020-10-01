/**
 * /BT/Common/PopupLoader/BtPopupAuthenticationWait.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MComp.MPopup
{
    id: idMPopupTypeBluetoothSSP
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.lcdHeight
    focus: true


    /* WIDGETS */
    Rectangle {
        width: parent.width
        height: parent.height
        color: colorInfo.black
        opacity: (false == btPhoneEnter || false == btSettingsEnter) ? 0.6 : 1
    }

    // PROPERTIES
    property string popupName

    Image {
        source: ImagePath.imgFolderPopup + "bg_type_b.png"
        x: 93
        y: 171 - systemInfo.statusBarHeight
        width: 1093
        height: 379

        Text {
            id: idText1
            text: stringInfo.str_Passkey_Popup + " : "
            x: 69
            y: 71
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
        }

        Text {
            id: idTextSub1
            text: sspOk
            anchors.left: idText1.right
            y: 71
            width: 955 - idText1.paintedWidth
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideRight
        }

        Text {
            id: idText2
            text: stringInfo.str_Device_Name_Popup + " : "
            x: 69
            y: 123
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
        }

        Text {
            id: idTextSub2
            text: sspDeviceName
            anchors.left: idText2.right
            y: 123
            width: 955 - idText2.paintedWidth
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            elide: Text.ElideRight
        }

        Image {
            source: ImagePath.imgFolderPopup + "divide_02.png"
            x: 47
            y: 188
        }

        Text {
            id: idText3
            text: stringInfo.str_Device_Ssp_Wait_2Line
            x: 69
            y: 260
            width: 955
            height: 32
            font.pointSize: 32
            font.family: stringInfo.fontFamilyRegular    //"HDR"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: colorInfo.subTextGrey
            wrapMode: Text.WordWrap
            lineHeight: gLanguage == 21 ? 0.8 : 1
        }
    }
}
/* EOF */
