/**
 * /BT/Common/PopupLoader/BtPopupInitialing.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp


MComp.MPopupTypeLoading
{
    id: idBtPopupInitialing

    popupBtnCnt: 0
    popupLineCnt: 1
    black_opacity: (false == btPhoneEnter) ? true : false

    popupFirstText: stringInfo.str_Inializing

    onShow: {}
    onHide: {}
}

/* EOF */
