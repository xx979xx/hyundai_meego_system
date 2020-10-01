/**
 * /BT/Common/PopupLoader/BtPopupDeleteSelectedOnly.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupDeleteSelectedOnly

    popupBtnCnt: 2
    popupLineCnt: 1

    popupFirstText: deviceSelectInt < 2 ? stringInfo.str_Device_Delete : stringInfo.str_Device_Delete_All_Select_2

    popupFirstBtnText: stringInfo.str_Yes
    popupSecondBtnText: stringInfo.str_Bt_No

    black_opacity: true

    /* EVENT handlers */
    onPopupFirstBtnClicked: {
        // 삭제 완료 시점에 화면이 빠지기 때문에 popScreen을 완료 팝업으로 옮김
        btDeleteMode = true;

        // 삭제 중인 상태에서는 연결을 할 수 없도록 처리
        BtCoreCtrl.invokeControlConnectableMode(false);

        // 삭제중 팝업 표시
        MOp.showPopup("popup_Bt_Deleting");

        if(5 > deviceSelectInt) {
            BtCoreCtrl.invokeRemovePairedDevice();
        } else {
            BtCoreCtrl.invokeRemoveAllPairedDevice();
        }
    }

    onPopupSecondBtnClicked: { MOp.hidePopup(); }
    onHardBackKeyClicked: { MOp.hidePopup(); }
}
/* EOF */
