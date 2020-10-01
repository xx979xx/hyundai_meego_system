/*
 * BtRecentDelegate.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    id: idRecentCallListDelegate
    width: 1045
    height: 90


    /* PROPERTIES */
    property bool hasInfoButton: btnRecentCall.visible
    // Delegate 내부에 오른쪽 상세정보 확인 버튼의 유무 확인 변수

    /* 최근 통화 목록 리스트 내부 포커스 위치를 설정 하는 변수
     * focusInfoButton: false > 리스트 왼쪽 포커스
     * focusInfoButton: true > 리스트 오른쪽 버튼에 포커스
     */
    property bool focusInfoButton: false

    Connections {
        target: idAppMain

        // Delete 화면에서 Back 버튼 선택시 발생되는 Signal
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
    MComp.MButtonHaveTicker {
        id: idBtRecentDelegate
        x: 0
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
        bgImageX: 5
        bgImageY: -1
        bgImageWidth: 876
        bgImageHeight: 93

        lineImage: ImagePath.imgFolderBt_phone + "recent_list_line.png"
        lineImageX: 0
        lineImageY: 90

        firstText: MOp.getCallerId(contactName, number)
        firstTextColor: colorInfo.brightGrey
        firstTextX: 130
        firstTextY: 26
        firstTextWidth: 430
        firstTextHeight: 42
        firstTextSize: 40
        firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
        firstTextAlies: "Left"
        firstTextElide: "Right"
        // 이름 갱신 안되는 문제
        firstTextVisible: false

        secondText: ("" != contactName) ? MOp.checkPhoneNumber(number) : ""
        secondTextX: 580
        secondTextY: 30
        secondTextWidth: 274
        secondTextHeight: 32
        secondTextSize: 32
        secondTextStyle: stringInfo.fontFamilyRegular    //"HDR"
        secondTextColor: colorInfo.dimmedGrey
        secondTextFocusColor: colorInfo.brightGrey
        secondTextFocusVisible: idBtRecentDelegate.activeFocus == true
        secondTextAlies: "Right"
        secondTextElide: "Right"

        // 이름 갱신 안되는 문제
        property bool nameRefreshed: refreshed

        onNameRefreshedChanged: {
            if(true == refreshed) {
                firstText = MOp.getCallerId(contactName, number);
                firstTextVisible = true;
            }
        }


        Image {
            id: imgCallType
            source: (type == 1) ? ImagePath.imgFolderBt_phone + "ico_recent_sent.png" : (type == 2) ? ImagePath.imgFolderBt_phone + "ico_recent_recived.png" : ImagePath.imgFolderBt_phone + "ico_recent_missed.png";
            x: 47
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
        x: 891
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

            /* ITS 0236251
             * 버튼 없는 리스트에 포커스 이동 후, 버튼있는 리스트의 버튼 터치 >> 팝업 닫은 후 CCP 동작 시, 포커스가 튀는 현상
             */
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
