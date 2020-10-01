/**
 * FileName: InfoTypeABand.qml
 * Author: WSH
 * Time: 2012-02-27
 *
 * - 2012-02-13 Initial Crated by WSH
 */

import Qt 4.7

import "../../component/system/DH" as MSystem
import "../../component/QML/DH" as MComp
import "../../component/Info" as MInfo

MComp.MButton {
    id: idInfoTypeABack
    x: 1060; y: 0
    width:194; height:68; z:100
    focus: true
    MInfo.InfoImageInfo{ id: imageInfo }

    bgImage: imageInfo.imgFolderGeneral+"btn_back_n.png"
    bgImagePress: imageInfo.imgFolderGeneral+"btn_back_p.png"
    bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_back_p.png"
    //bgImageFocus: imgFolderGeneral+"bg_top_btn_f.png"

    //Focus Image
    Image {
        //anchors.fill: bgImage
        id: idFocusImage
        x: -8; y: -8 ; z: 5
        source: imageInfo.imgFolderGeneral+"bg_top_btn_f.png"
        visible: showFocus && idInfoTypeABack.activeFocus
    }

    onActiveFocusChanged:{ console.debug(" # [InfoTypeABack][onActiveFocusChanged] activeFocus :" + idInfoTypeABack.activeFocus) }
    onClickOrKeySelected: {
        console.log(" # [InfoTypeABack] Back")
        gotoBackScreen()
    }
}
