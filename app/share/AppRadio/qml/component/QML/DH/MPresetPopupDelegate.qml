/**
 * FileName: MPresetPopup.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 * - 2012-07-31 GUI change (GUI popup_planB_v1.1.0)
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

MButton{
    id: idButton
    x: 110+37; y: 174+120
    width: 155; height: 104
    buttonWidth: 155; buttonHeight: 104
    focus: true
    active: idButton.secondText != "Empty" || idButton.secondText == ""

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    //****************************** # Button background Image #
    bgImage: imgFolderPopup+"btn_preset_n.png"
    bgImageActive: imgFolderPopup+"btn_preset_s.png"
    bgImageFocus: imgFolderPopup+"btn_preset_f.png"
    bgImageFocusPress: imgFolderPopup+"btn_preset_p.png"
    bgImagePress: imgFolderPopup+"btn_preset_p.png"

    //****************************** # SXM - Image Icon #
    fgImageX: 16
    fgImageY: 22
    fgImageWidth: 59
    fgImageHeight: 59
    fgImage: presetPopupFgImage
    fgImageVisible: (selectedApp == "SXM")? ((presetPopupText == "Empty")? false : true) : false

    //****************************** # firstText #
    firstText: index+1
    firstTextX: (selectedApp == "SXM")? ((presetPopupText == "Empty")? 11 : 16+63) : 11
    firstTextY: 27
    firstTextWidth: (selectedApp == "SXM")? ((presetPopupText == "Empty")? 134 : 66) : 134
    firstTextHeight: 30
    firstTextSize: 30
    firstTextStyle: systemInfo.hdb
    firstTextAlies: "Center"
    firstTextColor: (presetPopupText == "Empty")? colorInfo.disableGrey : "#B6C9FF"  //RGB(182, 201, 255)
    firstTextSelectedColor: "#B6C9FF"

    //****************************** # secondText #
    secondText: presetPopupText
    secondTextX: (selectedApp == "SXM")? ((presetPopupText == "Empty")? 11 : 16+63) : 11
    secondTextY: (selectedApp == "SXM") || (presetPopupText == "Empty")? 27+42 : 27+41
    secondTextWidth: (selectedApp == "SXM")? ((presetPopupText == "Empty")? 134 : 66) : 134
    secondTextHeight: (selectedApp == "SXM") || (presetPopupText == "Empty")? 28 : 36
    secondTextSize: (selectedApp == "SXM") ? ((presetPopupText == "Empty")? 36 : 28) : 36
    secondTextStyle: systemInfo.hdb
    secondTextAlies: "Center"
    secondTextElide: "Right"
    secondTextColor: (presetPopupText == "Empty")? colorInfo.disableGrey : colorInfo.brightGrey
    secondTextSelectedColor: colorInfo.brightGrey

    //****************************** # SXM(Empty / !Empty) text size, position, fgimageFlag change (120727) #
    function textPositionChange(){
        if(selectedApp == "SXM"){
            if(presetPopupText == "Empty"){
                firstTextX = 11
                firstTextWidth = 134
                secondTextX = 11
                secondTextWidth = 134
                secondTextSize = 36
                fgImageVisible = false
            }
            firstTextX = 16+63
            firstTextWidth = 66
            secondTextX = 16+63
            secondTextWidth = 66
            secondTextSize = 28
            fgImageVisible = true
        }
        else{
            firstTextX = 11
            firstTextWidth = 134
            secondTextX = 11
            secondTextWidth = 134
            secondTextSize = 36
            fgImageVisible = false
        }
    }

    //****************************** # Click, Key Selected Event #
    onClickOrKeySelected: {        
        idPresetGridView.currentIndex = index
        idPresetGridView.focus = true
        idPresetGridView.forceActiveFocus()
        textPositionChange()

        presetItemClicked()      
    }
}

