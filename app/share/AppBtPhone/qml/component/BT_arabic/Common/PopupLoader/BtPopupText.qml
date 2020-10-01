/**
 * /BT_arabic/Common/PopupLoader/BtPopupText.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeText 
{
    id: idPopupTextContainer

    popupBtnCnt: idPopupLoaderText.buttonCount
    popupFirstText: idPopupLoaderText.bodyText
    popupFirstBtnText: idPopupLoaderText.button1Text
    popupSecondBtnText: idPopupLoaderText.button2Text

    black_opacity: !idPopupLoaderText.backgroundOpacity
    
    
    /* EVENT handlers */
    onPopupFirstBtnClicked: { MOp.hidePopup(); }
    onPopupSecondBtnClicked:{ MOp.hidePopup(); }

    onHardBackKeyClicked:   { MOp.hidePopup(); }
}
/* EOF */
