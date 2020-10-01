/**
 * BtCallProbateMode.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


Item
{
    id: idBtCallPrivateModeMain
    x: 0
    y: 0
    width: systemInfo.lcdWidth - 386
    height: 420
    focus: true


    /* WIDGETS */
    Image {
        id: imgBtCallImage
        source: ImagePath.imgFolderBt_phone + "ico_cellphone.png"
        x: 39
        y: 3
        width: 95
        height: 182
    }

    Text {
        id: idTimeText
        text: {
              if(30 == BtCoreCtrl.m_ncallState) {
                  stringInfo.str_Wait
              } else if(31 == BtCoreCtrl.m_ncallState){
                  BtCoreCtrl.m_strTimeStamp0
              } else if(0 != BtCoreCtrl.m_nActivatedCallPos) {
                  BtCoreCtrl.m_strTimeStamp1
              } else {
                  BtCoreCtrl.m_strTimeStamp0
              }
        }
        x: 219
        y: -7
        width: 588
        height: 32

        font.pointSize: 32
        color: colorInfo.bandBlue
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.family: stringInfo.fontFamilyRegular    //"HDR"
    }

    Text {
        id: idMessageText
        text: stringInfo.str_pravite_message_1
        x: 219
        width: 588
        height: 50

        anchors.verticalCenter: idTimeText.verticalCenter
        anchors.verticalCenterOffset: 52

        lineHeight: 0.75
        font.pointSize: 50
        wrapMode: Text.WordWrap
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        font.family: stringInfo.fontFamilyRegular    //"HDR"
    }
}
/* EOF */
