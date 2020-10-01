/*
 * /BT_arabic/Recent/Main/BtRecentDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idRecentCallListDelegate
    width: 1045
    height: 90


    /* PROPERTIES */
    property bool hasInfoButton: btnRecentCall.visible
    property bool focusInfoButton: false

    Connections {
        target: idAppMain

        onDeleteBackKeyPress: {
            focusInfoButton = false
        }
    }

    onVisibleChanged: {
        if(true == idRecentCallListDelegate.visible) {
            focusInfoButton = false
        }
    }

    /* WIDGETS */
    MComp.MRecentCallDelegate {
        id: idBtRecentDelegate
        x: 177
        y: 0
        width: 876
        height: 90
        focus: !btnRecentCall.focus
        // buttonFocus: false == systemPopupOn && (true == idBtRecentDelegate.activeFocus) && popupState == "" ? true : false

        /* Ticker Enable! */
        tickerEnable: true


        bgImage: ""
        bgImagePress:   ImagePath.imgFolderBt_phone + "recent_list_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "recent_list_f.png"
        bgImageX: 0
        bgImageY: -1
        bgImageWidth: 876
        bgImageHeight: 93

        lineImage: ImagePath.imgFolderBt_phone + "recent_list_line.png"
        lineImageX: -177
        lineImageY: 90

        firstText: MOp.getCallerId(contactName, number)
        firstTextColor: colorInfo.brightGrey
        firstTextX: 298
        firstTextY: 26
        firstTextWidth: 430
        firstTextHeight: 42
        firstTextSize: 40
        firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
        firstTextAlies: "Right"
        firstTextElide: "Left"

        secondText: ("" != contactName) ? MOp.checkPhoneNumber(number) : ""
        secondTextX: 14
        secondTextY: 30
        secondTextWidth: 274
        secondTextHeight: 32
        secondTextSize: 32
        secondTextStyle: stringInfo.fontFamilyRegular    //"HDR"
        secondTextColor: colorInfo.dimmedGrey
        secondTextFocusColor: colorInfo.brightGrey
        secondTextFocusVisible: idBtRecentDelegate.activeFocus == true
        secondTextAlies: "Left"
        secondTextElide:"Left"

        Image {
            id: imgCallType
            source: (type == 1) ? ImagePath.imgFolderBt_phone + "ico_recent_sent.png" : (type == 2) ? ImagePath.imgFolderBt_phone + "ico_recent_recived.png" : ImagePath.imgFolderBt_phone + "ico_recent_missed.png";
            x: 728
            y: 11
            width: 71
            height: 71
        }

        onClickOrKeySelected: {
            /* 발신번호표시제한 + 통화중 -> 발신번호표시제한 팝업이 우선권을 가짐
             */
            if("" == number) {
                MOp.showPopup("popup_Bt_Call_No_Outgoing");
            } else {
                //__IQS_15MY_ Call End Modify
                if(9 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                    // 통화 중 추가 통화 금지
                    MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
                } else if(true == MOp.containsOnlyNumber(number)) {
                    BtCoreCtrl.HandleCallStart(number)
                } else {
                    MOp.showPopup("popup_Bt_Call_No_Outgoing");
                }
            }
        }
    }

    MComp.DDImageButton {
        id: btnRecentCall
        x: 22
        y: 11
        width: 132
        height: 71
        visible: (number != "") && ("" != contactName) ? true : false
        focus: focusInfoButton && false == systemPopupOn

        bgImage:        ImagePath.imgFolderBt_phone + "btn_more_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_more_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_more_f.png"

        onClickOrKeySelected: {
            gRecentsInfo = { number: number, index: index, name: contactName }

            recentCallList.currentIndex = index;
            focusInfoButton = true;
            // 폰북 이동 또는 즐겨찾기 추가 팝업
            MOp.showPopup("popup_recent_info");
        }
    }

    onClickOrKeySelected: {
        /* 발신번호표시제한 + 통화중 -> 발신번호표시제한 팝업이 우선권을 가짐
         */
        idRecentCallListDelegate.forceActiveFocus();

        if("" == number) {
            MOp.showPopup("popup_Bt_Call_No_Outgoing");
        } else {
            //__IQS_15MY_ Call End Modify
            if(9 < BtCoreCtrl.m_ncallState || (true == iqs_15My && true == BtCoreCtrl.m_bIsCallEndViewState && 1 == BtCoreCtrl.m_ncallState)) {
                // 통화 중 추가 통화 금지
                MOp.showPopup("popup_Bt_State_Calling_No_OutCall");
            } else if(true == MOp.containsOnlyNumber(number)) {
                BtCoreCtrl.HandleCallStart(number)
            } else {
                MOp.showPopup("popup_Bt_Call_No_Outgoing");
            }
        }
    }

    onReleased: {
        if(false == btnRecentCall.visible){
        console.log("## ~ Play Beep Sound ~ ##")
        UIListener.ManualBeep();
        }
    }
}
/* EOF */
