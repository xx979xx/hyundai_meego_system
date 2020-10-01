/**
 * /BT/Call/BtCall3WayCall.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


Item
{
    id: idBtCall3WayMain


    /* WIDGETS */
    MComp.MButtonHaveTickerNoActiveFocus {
        id: idTopBtn
        x: 0
        y: 0
        width: 841
        height: 195
        opacity: 0 == BtCoreCtrl.m_nActivatedCallPos ? 1 : 0.5
        visible: (false == callPrivateMode) && (false == callShowMicVolume) && (false == callShowDTMF)

        bgImage:""
        bgImagePress: (1 == BtCoreCtrl.m_nActivatedCallPos) ? ImagePath.imgFolderBt_phone + "bg_call_p.png" : ""

        Image {
            id: idImgTopIcon
            source: {
                if(0 == BtCoreCtrl.m_nActivatedCallPos) {
                    if(true == firstCallStateIncoming) {
                        ImagePath.imgFolderBt_phone + "call_state_receive_n.png"
                    } else {
                        ImagePath.imgFolderBt_phone + "call_state_send_n.png"
                    }
                } else {
                    ImagePath.imgFolderBt_phone + "call_state_wait_n.png"
                }
            }

            x: 56
            y: 12
            width: 180
            height: 180
        }

        Text {
            id: idTopTimeText
            text: BtCoreCtrl.m_nActivatedCallPos == 0 ? BtCoreCtrl.m_strTimeStamp0 : stringInfo.str_Wait
            x: 275
            y: ("" != BtCoreCtrl.m_strPhoneName0) ? 20 : 32
            width: 588
            height: 32

            font.pointSize: 32
            color: colorInfo.bandBlue
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: stringInfo.fontFamilyRegular    //"HDR"
        }

        Text {
            id: idTopNameText
            text: MOp.getCallerId(BtCoreCtrl.m_strPhoneName0, BtCoreCtrl.m_strPhoneNumber0)
            x: 275
            y: ("" != BtCoreCtrl.m_strPhoneName0) ? 53 : 63
            width: 588
            height: 60

            font.pointSize: 60
            elide: Text.ElideRight
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: stringInfo.fontFamilyRegular    //"HDR"

            //clip: true    전화번호 짤리는 문제 - ISV 78710
        }

        Text {
            id: idTopNumerText
            text: MOp.checkPhoneNumber(BtCoreCtrl.m_strPhoneNumber0)
            x: 275
            y: 123
            width: 588
            height: 42

            clip: true
            font.pointSize: 42
            elide: Text.ElideRight
            color: colorInfo.subTextGrey
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.family: stringInfo.fontFamilyRegular    //"HDR"

            /* 전화번호부에 저장되어있지 않은 번호인 경우 하단 번호출력하지 않도록 수정
             */
            visible: ("" != BtCoreCtrl.m_strPhoneName0) ? true : false
        }

        Image {
            source: ImagePath.imgFolderBt_phone + "bg_call_s.png"
            x: 0
            y: 70
            width: 841
            height: 189
            visible: (0 == BtCoreCtrl.m_nActivatedCallPos) ? true : false
        }

        onClickOrKeySelected: {
            if(1 == BtCoreCtrl.m_nActivatedCallPos) {
                BtCoreCtrl.HandleSwapCalls(0)
            } else {
                qml_debug("Acitive Top Call")
            }
        }
    }

    MComp.MButtonHaveTickerNoActiveFocus {
        id: idBottomBtn
        x: 0
        y: 188
        width: 841
        height: 195
        opacity: (1 == BtCoreCtrl.m_nActivatedCallPos) ? 1 : 0.5
        visible: (true != callPrivateMode) && (false == callShowMicVolume) && (false == callShowDTMF)

        bgImage: ""
        bgImagePress: ImagePath.imgFolderBt_phone + "bg_call_p.png"

        Image {
            id: idImgBottomIcon
            source: {
                if(1 == BtCoreCtrl.m_nActivatedCallPos) {
                    if(true == secondCallStateIncoming) {
                        ImagePath.imgFolderBt_phone + "call_state_receive_n.png"
                    } else {
                        ImagePath.imgFolderBt_phone + "call_state_send_n.png"
                    }
                } else {
                    ImagePath.imgFolderBt_phone + "call_state_wait_n.png"
                }
            }
            x: 56
            y: 12
            width: 180
            height: 180
        }

        Text {
            id: idBottonTimeText
            text: BtCoreCtrl.m_nActivatedCallPos == 1 ? BtCoreCtrl.m_strTimeStamp1 : stringInfo.str_Wait
            x: 275
            y: ("" != BtCoreCtrl.m_strPhoneName1) ? 20 : 42
            width: 588
            height: 32

            font.pointSize: 32
            color: colorInfo.bandBlue
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: stringInfo.fontFamilyRegular    //"HDR"
        }

        Text {
            id: idBottonNameText
            text: MOp.getCallerId(BtCoreCtrl.m_strPhoneName1, BtCoreCtrl.m_strPhoneNumber1)
            x: 275
            y: ("" != BtCoreCtrl.m_strPhoneName1) ? 53 : 73
            width: 588
            height: 60

            font.pointSize: 60
            elide: Text.ElideRight
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: stringInfo.fontFamilyRegular    //"HDR"

            //clip: true    전화번호 짤리는 문제 - ISV 78710
        }

        Text {
            id: idBottonNumberText
            text: MOp.checkPhoneNumber(BtCoreCtrl.m_strPhoneNumber1)
            x: 275
            y: 133
            width: 588
            height: 42

            clip: true
            font.pointSize: 42
            elide: Text.ElideRight
            color: colorInfo.subTextGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: stringInfo.fontFamilyRegular    //"HDR"

            /* 전화번호부에 저장되어있지 않은 번호인 경우 하단 번호출력하지 않도록 수정
             */
            visible: ("" != BtCoreCtrl.m_strPhoneName1) ? true : false
        }

        Image {
            source: ImagePath.imgFolderBt_phone + "bg_call_s.png"
            x: 0
            y: 70
            width: 841
            height: 189
            visible: (1 == BtCoreCtrl.m_nActivatedCallPos) ? true : false
        }

        onClickOrKeySelected: {
            if(BtCoreCtrl.m_nActivatedCallPos == 0) {
                BtCoreCtrl.HandleSwapCalls(1);
            } else {
                qml_debug("Acitive Bottom Call")
            }
        }
    }
}
/* EOF */
