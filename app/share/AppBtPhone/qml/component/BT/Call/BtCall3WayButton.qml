/**
 * /BT/Call/BtCall3WayButton.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


Row 
{
    id: idCall3WaybuttonContainer
    focus: true

    /* EVENT handlers */
    onVisibleChanged: {
        if(true == idCall3WaybuttonContainer.visible) {
            if(true == idCall3WaybuttonContainer.activeFocus) {
                id3WayBtn3.forceActiveFocus();
            }
        }
    }

    /* WIDGETS */
    MComp.DDCallButton {
        id: id3WayBtn1
        width: 297
        height: 94
        focus: true

        bgImage:        ImagePath.imgFolderBt_phone + "btn_call_bottom_s_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_call_bottom_s_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_call_bottom_s_f.png"

        fgImage:        if (1 == UIListener.invokeGetVehicleVariant()){
                            if(true == id3WayBtn1.activeFocus){
                                ImagePath.imgFolderBt_phone + "ico_call_trans_f.png"
                            } else if (false == id3WayBtn1.mEnabled){
                                ImagePath.imgFolderBt_phone + "ico_call_trans_d.png"
                            } else {
                                ImagePath.imgFolderBt_phone + "ico_call_trans_n.png"
                            }
                        } else {
                            if (false == id3WayBtn1.mEnabled){
                                ImagePath.imgFolderBt_phone + "ico_call_trans_d.png"
                            } else {
                                ImagePath.imgFolderBt_phone + "ico_call_trans_n.png"
                            }
                        }
        fgImageWidth: 68
        fgImageHeight: 60

        firstText: stringInfo.str_Change
        firstTextX: 76
        firstTextY: 14
        firstTextSize: 30
        firstTextColor: mEnabled? colorInfo.brightGrey : colorInfo.disableGrey
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"

        onClickOrKeySelected: {
            // 대기통화 전환
            id3WayBtn1.forceActiveFocus();
            BtCoreCtrl.HandleSwapCalls();
        }


        onWheelRightKeyPressed: {
            if(true == id3WayBtn2.mEnabled) {
                id3WayBtn2.focus = true;
            } else {
                id3WayBtn3.focus = true;
            }
        }
    }

    // Switch handsfree/private mode
    MComp.DDCallButton {
        id: id3WayBtn2
        width: 297
        height: 94

        bgImage:        ImagePath.imgFolderBt_phone + "btn_call_bottom_s_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_call_bottom_s_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_call_bottom_s_f.png"

        fgImage:        if (false == callPrivateMode) {
                            if (1 == UIListener.invokeGetVehicleVariant()){
                                if(true == id3WayBtn2.activeFocus) {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_f.png"
                                } else if(false == id3WayBtn2.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_n.png"
                                }
                            } else {
                                if(false == id3WayBtn2.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_mobile_n.png"
                                }
                            }
                        } else {
                            if (1 == UIListener.invokeGetVehicleVariant()){
                                if(true == id3WayBtn2.activeFocus) {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_f.png"
                                } else if(false == id3WayBtn2.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_n.png"
                                }
                            } else {
                                if(false == id3WayBtn2.mEnabled) {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_d.png"
                                } else {
                                    ImagePath.imgFolderBt_phone + "ico_call_handsfree_n.png"
                                }
                            }
                        }
        fgImageWidth: 68
        fgImageHeight: 60

        firstText: (false == callPrivateMode) ? stringInfo.str_Change_Phone : stringInfo.str_Change_Handfree
        firstTextX: 76
        firstTextY: 14
        firstTextSize: 30
        firstTextAlies: "Center"
        firstTextColor: mEnabled? colorInfo.brightGrey : colorInfo.disableGrey
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"

        onClickOrKeySelected: {
            // 휴대폰 통화 전환(private)
            id3WayBtn2.forceActiveFocus();
            BtCoreCtrl.HandlePrivateCallToggle();
        }


        onWheelLeftKeyPressed: id3WayBtn1.focus = true
        onWheelRightKeyPressed: id3WayBtn3.focus = true
    }

    // Call end
    MComp.DDCallButton {
        id: id3WayBtn3
        width: 297
        height: 94

        bgImage:        ImagePath.imgFolderBt_phone + "btn_call_bottom_s_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_call_bottom_s_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_call_bottom_s_f.png"

        fgImage:        if (1 == UIListener.invokeGetVehicleVariant()){
                            if(true == id3WayBtn3.activeFocus){
                                ImagePath.imgFolderBt_phone + "ico_call_end_f.png"
                            } else if (false == id3WayBtn3.mEnabled){
                                ImagePath.imgFolderBt_phone + "ico_call_end_d.png"
                            } else {
                                ImagePath.imgFolderBt_phone + "ico_call_end_n.png"
                            }
                        } else {
                            if (false == id3WayBtn3.mEnabled){
                                ImagePath.imgFolderBt_phone + "ico_call_end_d.png"
                            } else {
                                ImagePath.imgFolderBt_phone + "ico_call_end_n.png"
                            }
                        }
        fgImageWidth: 76
        fgImageHeight: 60

        firstText: stringInfo.str_End
        firstTextX: 93
        firstTextY: 14
        firstTextSize: 30
        firstTextColor: mEnabled? colorInfo.brightGrey : colorInfo.disableGrey
        firstTextStyle: stringInfo.fontFamilyBold    //"HDB"

        onClickOrKeySelected: {
            // 통화종료
            //BtCoreCtrl.HandleHangupCall();
            id3WayBtn3.forceActiveFocus();
            BtCoreCtrl.HandleReleaseCurrentCall();
        }

        onWheelLeftKeyPressed: {
            if(true == id3WayBtn2.mEnabled) {
                id3WayBtn2.focus = true;
            } else {
                id3WayBtn1.focus = true;
            }
        }
    }
}
/* EOF */
