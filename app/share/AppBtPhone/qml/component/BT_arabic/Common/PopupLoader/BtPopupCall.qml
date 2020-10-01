/**
 * /BT_arabic/Common/PopupLoader/BtPopupCall.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeBluetoothCall
{
    id: idBtPopupCall
    focus: true

    popupBtnCnt: 2

    popupFirstText: MOp.getCallerId(BtCoreCtrl.m_strPhoneName0, BtCoreCtrl.m_strPhoneNumber0)
    popupSecondText: MOp.getCallerNumber(BtCoreCtrl.m_strPhoneNumber0)

    popupFirstBtnText: stringInfo.str_Accept
    popupSecondBtnText: stringInfo.str_Reject
    secondTextVisible: ("" != BtCoreCtrl.m_strPhoneName0) ? true : false

    onPopupFirstBtnClicked: {
        // Accept
        BtCoreCtrl.HandleAcceptCall();
        /* Display On/Off 동작 시 바탕에 Call화면 보이는 현상 때문에 코드 추가
         */
        //MOp.showCallView();
    }

    onPopupSecondBtnClicked: {
        // Reject
        BtCoreCtrl.HandleHangupCall();
        //MOp.initCallView(4003);

        /* 다이얼(or 설정) -> 콜 팝업인 상황인지
         * HOME -> 콜 팝업인 상황인지 구분해야 함

        if(1 > screenSize()) {
            // Main팀 요청으로 삭제
            MOp.postBackKey(5);
        }*/

        // 수신 통화 중 거절 선택 하면 전화번호부 날라가는 문제
/*DEPRECATED
        phoneName = "";
        phoneNum = "";
DEPRECATED*/
    }
}
/* EOF */
