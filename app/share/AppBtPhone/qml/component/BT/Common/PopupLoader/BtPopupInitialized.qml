/**
 * /BT/Common/PopupLoader/BtPopupInitialized.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeDim
{
    id: idPopupinitialized

    black_opacity: (true == btPhoneEnter) ? false : true
    ignoreTimer: true

    firstText: stringInfo.str_Suc_Ini

    function popupBtInitializedHandler() {
        if(true == btPhoneEnter) {
            MOp.postPopupBackKey(555);
        } else {
            if(true == iqs_15My && true == waitContactUpdatePopup) {
                // 초기화 중 전화번호부 업데이트 진행상태였다면 삭제완료 팝업 이 후 전화번호부 업데이트 승인팝업을 출력
                waitContactUpdatePopup = false;
                //[IdeaBank 내수 16년 2차 정업]
                //[START] Remove PB update confirm Popup
                //case 0: KR
                if(UIListener.invokeGetCountryVariant() == 0){
                    BtCoreCtrl.invokeContactUpdate(true);
                }else{
                    MOp.showPopup("popup_Contact_Change");
                }
                //[END]
            } else {
                MOp.hidePopup();
            }
        }
    }

    /* EVENT handlers */
    onShow: {}
    onHide: {}

    onTimerEnd:             { popupBtInitializedHandler(); }
    onPopupClicked:         { popupBtInitializedHandler(); }
    onHardBackKeyClicked:   { popupBtInitializedHandler(); }
}
/* EOF*/
