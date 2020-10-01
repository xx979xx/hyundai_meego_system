/**
 * /BT_arabic/Common/PopupLoader/BtPopupPairedDeviceDelete.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupPairedDeviceDelete

    popupBtnCnt: 2
    popupLineCnt: 1

    popupFirstText: stringInfo.str_Device_Delete

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No

    // 뒷배경 투명도 설정
    black_opacity: true
    popupLineHeight: 0.85


    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        // TODO: 정원 재확인!!!!
        MOp.showPopup("popup_Bt_Deleting");

        // 삭제 완료 시점에 화면이 빠지기 때문에 popScreen을 완료 팝업으로 옮김
        btDeleteMode = true

        // 삭제 중인 상태에서는 연결을 할 수 없도록 처리
        BtCoreCtrl.invokeControlConnectableMode(false);

        if(5 > deviceSelectInt) {
            BtCoreCtrl.invokeRemovePairedDevice();
        } else {
            BtCoreCtrl.invokeRemoveAllPairedDevice();
        }
    }

    onPopupSecondBtnClicked:{ MOp.hidePopup(); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
