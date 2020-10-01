/**
 * /BT_arabic/Common/PopupLoader/BtPopupLaunchHelpInDriving.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText
{
    id: idPopupLaunchHelpContainer

    popupBtnCnt: 1
    popupLineCnt: 1
    black_opacity: false

    popupFirstText: stringInfo.launch_help_in_driving
    popupFirstBtnText: stringInfo.str_Ok


    /* EVENT handlers */
    onPopupFirstBtnClicked: { MOp.postPopupBackKey(4456); }
    onHardBackKeyClicked:   { MOp.postPopupBackKey(4457); }

    //DEPRECATED onPopupClicked: {}
    //DEPRECATED onPopupBgClicked: {}
}
/* EOF */
