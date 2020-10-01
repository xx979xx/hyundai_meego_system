/**
 * FileName: MMsgPopupBtnDelegate.qml
 * Author: WSH
 * Time: 2012-02-13
 *
 * - 2012-02-13 Initial Crated by WSH
 */
import QtQuick 1.0

MButton {
    id:idMMsgPopupBtnDelegate
    x: parent.x; y: parent.y
    width: btnWidth; height: btnHeight
    buttonWidth: width; buttonHeight:height

    bgImage: imgFolderPopup + "popup_d_btn_n.png"
    bgImagePress: imgFolderPopup + "popup_d_btn_p.png"
    bgImageActive: imgFolderPopup + "popup_d_btn_s.png"
    bgImageFocusPress: imgFolderPopup + "popup_d_btn_fp.png"
    bgImageFocus: imgFolderPopup + "popup_d_btn_f.png"

    //--------------------- Clicked/Selected Event #
    onClickOrKeySelected: {
        btnClickEvent(index)
    }

    //--------------------- Text Info
    firstText: btnName
    firstTextSize: btnTextSize
    firstTextX: btnTextX
    firstTextY: btnTextY
    firstTextWidth: buttonWidth
    firstTextStyle: btnTextName
    firstTextAlies: btnTextAlies
    firstTextColor: colorInfo.subTextGrey
    firstTextPressColor : colorInfo.brightGrey
    firstTextFocusPressColor : firstTextPressColor
    firstTextSelectedColor: firstTextPressColor
}
