/**
 * BtCallMicVolume.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    x: 0
    y: 0
    width: systemInfo.lcdWidth - 386
    height: 420
    focus: true


    /* WIDGETS */
    Text {
        text: stringInfo.str_Mic_Message
        x: 30
        y: 103      //121 - 18
        width: 795
        height: 36
        font.pointSize: 36
        color: colorInfo.brightGrey
        font.family: stringInfo.fontFamilyRegular    //"HDR"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        lineHeight: 0.8
    }

    MComp.MSlider {
        id: icMicSlider
        x: 30
        y: 184      //121 + 63
        focus: true
        opacity: BtCoreCtrl.m_handsfreeMicMute ? 0.5 : 1
    }
}
/* EOF */
