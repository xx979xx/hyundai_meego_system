/**
 * /BT_arabic/Common/PopupLoader/BtPopupMaxContacts.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idBtPopupMaxContacts

    popupBtnCnt: 1
    popupLineCnt: 1

    popupFirstText: stringInfo.str_Phonebook_Full
    popupFirstBtnText: stringInfo.str_Ok


    //onPopupFirstBtnClicked: { MOp.showPopup("popup_bt_phonebook_download_completed"); }
    //onHardBackKeyClicked:   { MOp.showPopup("popup_bt_phonebook_download_completed"); }
    onPopupFirstBtnClicked: { MOp.hidePopup(); }
    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
