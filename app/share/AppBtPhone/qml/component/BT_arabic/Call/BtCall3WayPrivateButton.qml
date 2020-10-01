/**
 * /BT/Call/BtCallSingleButton.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


Row
{
    id: idCallSingleButton
    spacing: 7
    focus: true


    /* EVENT handlers */
    /*onActiveFocusChanged: {
        if(true == idCallSingleButton.activeFocus) {
            if(20 == BtCoreCtrl.m_ncallState || 21 == BtCoreCtrl.m_ncallState) {
                idCall3WayButtonEnd.forceActiveFocus();
            } else {
                idCall3WayButtonPrivate.forceActiveFocus();
            }
        }
    }*/

    onVisibleChanged: {
        if(true == idCallSingleButton.visible) {
            idCall3WayButtonPrivate.focus = true
        }
    }


    /* WIDGETS */
    MComp.DDCallButton {
        id: idCall3WayButtonEnd
        width: 420
        height: 94
        mEnabled: 1 != BtCoreCtrl.m_ncallState
        focus: true

        bgImage:        ImagePath.imgFolderBt_phone + "btn_call_bottom_l_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_call_bottom_l_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_call_bottom_l_f.png"

        fgImage:        if (1 == UIListener.invokeGetVehicleVariant()){
                            if(true == idCall3WayButtonEnd.activeFocus){
                                ImagePath.imgFolderBt_phone + "ico_call_end_f.png"
                            } else if (false == idCall3WayButtonEnd.mEnabled){
                                ImagePath.imgFolderBt_phone + "ico_call_end_d.png"
                            } else {
                                ImagePath.imgFolderBt_phone + "ico_call_end_n.png"
                            }
                        } else {
                            if (false == idCall3WayButtonEnd.mEnabled){
                                ImagePath.imgFolderBt_phone + "ico_call_end_d.png"
                            } else {
                                ImagePath.imgFolderBt_phone + "ico_call_end_n.png"
                            }
                        }
        fgImageWidth:   68
        fgImageHeight:  60

        firstText: stringInfo.str_End
        firstTextX: 80
        firstTextY: 8
        firstTextSize: 42
        firstTextColor: mEnabled? colorInfo.brightGrey : colorInfo.disableGrey
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"

        secend_visible: false

        onClickOrKeySelected: {
            // 통화종료
            idCall3WayButtonEnd.forceActiveFocus();
        //3Way 상태에서 hangup을 보내면 phone에 따라 상태 이상해지는 현상 발생함.
            //BtCoreCtrl.HandleHangupCall();
            BtCoreCtrl.HandleReleaseCurrentCall();
        }

        onWheelRightKeyPressed: {
            if(true == idCall3WayButtonPrivate.mEnabled) {
                idCall3WayButtonPrivate.focus = true;
            } else {
                idCall3WayButtonEnd.focus = true;
            }
        }
    }

    MComp.DDCallButton {
        id: idCall3WayButtonPrivate
        width: 420
        height: 94
        mEnabled: 1 != BtCoreCtrl.m_ncallState && 21 != BtCoreCtrl.m_ncallState && 20 != BtCoreCtrl.m_ncallState

        bgImage:        ImagePath.imgFolderBt_phone + "btn_call_bottom_l_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_call_bottom_l_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_call_bottom_l_f.png"

        fgImage:        if (false == callPrivateMode || (true == iqs_15My && 1 == BtCoreCtrl.m_ncallState)) {
                            if (1 == UIListener.invokeGetVehicleVariant()){
                                if(true == idCall3WayButtonPrivate.activeFocus) {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_f.png"
                                } else if(false == idCall3WayButtonPrivate.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_n.png"
                                }
                            } else {
                                if(false == idCall3WayButtonPrivate.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_n.png"
                                }
                            }
                        } else {
                            if (1 == UIListener.invokeGetVehicleVariant()){
                                if(true == idCall3WayButtonPrivate.activeFocus) {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_f.png"
                                } else if(false == idCall3WayButtonPrivate.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_n.png"
                                }
                            } else {
                                if(false == idCall3WayButtonPrivate.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_n.png"
                                }
                            }
                        }
        fgImageWidth:   68
        fgImageHeight:  60

        firstText: (false == callPrivateMode) ? stringInfo.str_Change_Phone : stringInfo.str_Change_Handfree
        firstTextX: 80
        firstTextY: 8
        firstTextSize: 42
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"

        secend_visible: false

        firstTextColor: mEnabled? colorInfo.brightGrey : colorInfo.disableGrey

        onClickOrKeySelected: {
            // 휴대폰 통화 전환(private)
            idCall3WayButtonPrivate.forceActiveFocus();
            BtCoreCtrl.HandlePrivateCallToggle();
        }

        onWheelLeftKeyPressed: {
            idCall3WayButtonEnd.focus = true;
        }
    }
}
/* EOF */
