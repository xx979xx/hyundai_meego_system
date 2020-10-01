/**
 * /BT/Setting/BtRightView/BtSettingsAudioStream/BtSettingsAudioStream.qml
 *
 */
import QtQuick 1.1


Item
{
    id: id_audio_streaming
    x: 0
    y: 0
    width: 547
    height: systemInfo.lcdHeight - systemInfo.statusBarHeight
    clip: true
    //focus: true

    Text {
        text: stringInfo.str_Bell_Save
        x: 9
        y: 247
        width: 540
        height: 32
        font.pointSize: (3 == gLanguage || 4 == gLanguage) ?  30 : 32
        font.family: stringInfo.fontFamilyRegular    //"HDR"
        color: (1 == UIListener.invokeGetVehicleVariant())? colorInfo.commonGrey : colorInfo.brightGrey
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }
}
/* EOF */
