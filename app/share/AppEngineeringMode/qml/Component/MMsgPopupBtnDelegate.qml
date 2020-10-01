/**
 * FileName: MMsgPopupBtnDelegate.qml
 * Author: WSH
 * Time: 2012-02-13
 *
 * - 2012-02-13 Initial Created by WSH
 */
import QtQuick 1.0
import "../System" as MSystem
MButtonTouch {
    id:idMMsgPopupBtnDelegate
    x: parent.x; y: parent.y
    width: btnWidth; height: btnHeight
    //buttonWidth: width; buttonHeight:height
    MSystem.ImageInfo { id: imageInfo }
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral

    bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
    bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    fgImage: ""
    fgImageActive: ""

    //--------------------- Clicked/Selected Event #
    onClickOrKeySelected: {
        btnClickEvent(index)
    }

    //--------------------- Text Info
    firstText: btnName
    firstTextSize: btnTextSize
    firstTextX: btnTextX
    firstTextY: btnTextY
    firstTextWidth: 262/*buttonWidth*/
    firstTextStyle: btnTextName
    //firstTextAlies: btnTextAlies
    firstTextColor: colorInfo.brightGrey
    //firstTextPressColor : colorInfo.brightGrey
    //firstTextFocusPressColor : firstTextPressColor
    firstTextSelectedColor: firstTextPressColor
}
