/**
 * /BT/Call/BtCallconference.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


Item
{
    id: idBtConferenceMain
    x: 0
    y: 0
    width: 787
    height: 195
    visible: (false == callPrivateMode) && (false == callShowMicVolume) && (false == callShowDTMF)


    /* WIDGETS */
    Image {
        id: idBtConferenceImage
        source: ImagePath.imgFolderBt_phone + "call_state_calling_n.png"
        x: 0
        y: 0
        width: 180
        height: 180
    }

    Text {
        id: idTimeText
        text: BtCoreCtrl.m_strTimeStamp0
        x: 219
        y: -7
        width: 588
        height: 32

        font.pointSize: 32
        color: colorInfo.bandBlue
        verticalAlignment: Text.AlignVCenter
        font.family: stringInfo.fontFamilyRegular    //"HDR"
    }

    Text {
        id: idNameText
        text: stringInfo.str_Conferencecall
        x: 219
        y: 41
        width: 588
        height: 60

        font.pointSize: 50
        elide: Text.ElideRight
        color: colorInfo.brightGrey
        verticalAlignment: Text.AlignVCenter
        font.family: stringInfo.fontFamilyRegular    //"HDR"

        //clip: true    전화번호 짤리는 문제 - ISV 78710

    }

    Image {
        source: ImagePath.imgFolderBt_phone + "ico_conference_n.png"
        x: 219
        y: 124
        width: 41
        height: 42
    }

    Text {
        id: idNumberText
        text: BtCoreCtrl.m_nMultiPartyCallCount0
        x: 276
        y: 126
        width: 511
        height: 40

        clip: true
        font.pointSize: 40
        elide: Text.ElideRight
        color: colorInfo.subTextGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.family: stringInfo.fontFamilyRegular    //"HDR"
    }
}
/* EOF */
