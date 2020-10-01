/**
 * /BT_arabic/Call/BtCallSingleButton.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH_arabic" as MComp
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


Row
{
    id: idCallSingleButton
    spacing: 7
    focus: true


    /* EVENT handlers */
    onActiveFocusChanged: {
        if(true == idCallSingleButton.activeFocus) {
            if(20 == BtCoreCtrl.m_ncallState || 21 == BtCoreCtrl.m_ncallState) {
                idCallSingleButtonEnd.forceActiveFocus();
            } else {
                idCallSingleButtonPrivate.forceActiveFocus();
            }
        }
    }

    onVisibleChanged: {
        if(true == idCallSingleButton.visible) {
            if(true == idCallSingleButton.activeFocus) {
                idCallSingleButtonEnd.forceActiveFocus();
            }
        }
    }


    /* WIDGETS */
    MComp.DDCallButton {
        id: idCallSingleButtonEnd
        width: 420
        height: 94
        mEnabled: 1 != BtCoreCtrl.m_ncallState
        focus: true

        bgImage:        ImagePath.imgFolderBt_phone + "btn_call_bottom_l_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_call_bottom_l_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_call_bottom_l_f.png"

        fgImage:        if (1 == UIListener.invokeGetVehicleVariant()){
                            if(true == idCallSingleButtonEnd.activeFocus){
                                ImagePath.imgFolderBt_phone + "ico_call_end_f.png"
                            } else if (false == idCallSingleButtonEnd.mEnabled){
                                ImagePath.imgFolderBt_phone + "ico_call_end_d.png"
                            } else {
                                ImagePath.imgFolderBt_phone + "ico_call_end_n.png"
                            }
                        } else {
                            if (false == idCallSingleButtonEnd.mEnabled){
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
            idCallSingleButtonEnd.forceActiveFocus();
            BtCoreCtrl.HandleHangupCall();
        }

        onWheelRightKeyPressed: {
            if(true == idCallSingleButtonPrivate.mEnabled) {
                idCallSingleButtonPrivate.focus = true;
            } else {
                idCallSingleButtonEnd.focus = true;
            }
        }
    }

    MComp.DDCallButton {
        id: idCallSingleButtonPrivate
        width: 420
        height: 94
        mEnabled: 1 != BtCoreCtrl.m_ncallState && 21 != BtCoreCtrl.m_ncallState && 20 != BtCoreCtrl.m_ncallState

        bgImage:        ImagePath.imgFolderBt_phone + "btn_call_bottom_l_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_call_bottom_l_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_call_bottom_l_f.png"

        //__IQS_15MY__ Call End Modify
        fgImage:        if (false == callPrivateMode || (true == iqs_15My && 1 == BtCoreCtrl.m_ncallState)) {
                            if (1 == UIListener.invokeGetVehicleVariant()){
                                if(true == idCallSingleButtonPrivate.activeFocus) {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_f.png"
                                } else if(false == idCallSingleButtonPrivate.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_n.png"
                                }
                            } else {
                                if(false == idCallSingleButtonPrivate.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_n.png"
                                }
                            }
                        } else {
                            if (1 == UIListener.invokeGetVehicleVariant()){
                                if(true == idCallSingleButtonPrivate.activeFocus) {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_f.png"
                                } else if(false == idCallSingleButtonPrivate.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_n.png"
                                }
                            } else {
                                if(false == idCallSingleButtonPrivate.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_n.png"
                                }
                            }
                        }
        fgImageWidth:   68
        fgImageHeight:  60

        //__IQS_15MY__ Call End Modify
        firstText: (false == callPrivateMode || (true == iqs_15My && 1 == BtCoreCtrl.m_ncallState)) ? stringInfo.str_Change_Phone : stringInfo.str_Change_Handfree
        firstTextX: 80
        firstTextY: 8
        firstTextSize: 42
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"

        secend_visible: false

        firstTextColor: mEnabled? colorInfo.brightGrey : colorInfo.disableGrey

        onClickOrKeySelected: {
            // 휴대폰 통화 전환(private)
            idCallSingleButtonPrivate.forceActiveFocus();
            BtCoreCtrl.HandlePrivateCallToggle();
        }

        onWheelLeftKeyPressed: {
            idCallSingleButtonEnd.focus = true;
        }
    }

}
/* EOF */
