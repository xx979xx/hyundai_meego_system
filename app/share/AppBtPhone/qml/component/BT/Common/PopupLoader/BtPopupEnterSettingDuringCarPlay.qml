/**
 * /BT/Common/PopupLoader/BtPopupEnterSettingDuringCarPlay.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupEnterSettingDuringCarPlay

    popupBtnCnt: 1
    popupFirstText: stringInfo.str_enter_setting_during_CarPlay;
    popupFirstBtnText: stringInfo.str_Ok

    black_opacity: true

    /* EVENT handlers */
    onPopupFirstBtnClicked: { MOp.hidePopup(); }

    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
