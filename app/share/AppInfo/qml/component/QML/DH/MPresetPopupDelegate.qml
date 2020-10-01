/**
 * FileName: MPresetPopup.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Crated by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

MButton{
    id: idButton
    x: 110+37; y: 174+120
    width: 155; height: 104
    buttonWidth: 155; buttonHeight: 104
    focus: true  
    active: idButton.firstText != "" || idButton.secondText !=""

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string presetFirstText: modelFirstPreset
    property string presetSecondText: selectedApp == "Radio" || selectedApp == "HdRadio" || selectedApp == "XmRadio" ? ""  : modelSecondPreset
    property string presetStationImage: imgFolderPopup+"bg_station.png"    //# item`s fg image

    //****************************** # Button background Image #
    bgImage: imgFolderPopup+"btn_preset_n.png"
    bgImageActive: imgFolderPopup+"btn_preset_s.png"
    bgImageFocus: imgFolderPopup+"btn_preset_f.png"
    bgImageFocusPress: imgFolderPopup+"btn_preset_fp.png"
    bgImagePress: imgFolderPopup+"btn_preset_p.png"

    //****************************** # XmRadio - Image Icon #
    fgImageX: 15
    fgImageY: 23
    fgImageWidth: 57
    fgImageHeight: 57
    fgImage: presetStationImage
    fgImageVisible: selectedApp == "XmRadio"

    //****************************** # firstText #
    firstText: presetFirstText
    firstTextX: textXBySelectedApp();
    firstTextY: textYBySelectedApp();
    firstTextWidth: textWidthBySelectedApp();
    firstTextHeight: textHeightBySelectedApp();
    firstTextSize: textSizeBySelectedApp();
    firstTextStyle: "HDBa1"
    firstTextAlies: "Center"
    firstTextColor: colorInfo.brightGrey
    firstTextSelectedColor: colorInfo.brightGrey

    //****************************** # DabRadio, RdsRadio, DMB - secondText #
    secondText: presetSecondText
    secondTextX: 11
    secondTextY: textYBySelectedAppSecond()
    secondTextWidth: 134
    secondTextHeight: 32
    secondTextSize: 32
    secondTextStyle: "HDBa1"
    secondTextAlies: "Center"
    secondTextColor: colorInfo.brightGrey
    secondTextSelectedColor: colorInfo.brightGrey
    secondTextVisible: selectedApp == "DabRadio" || selectedApp == "RdsRadio" || selectedApp == "DMB"

    onClickOrKeySelected: {        
        idPresetGridView.currentIndex = index
        idPresetGridView.focus = true
        idPresetGridView.forceActiveFocus()

        presetItemClicked()
        if(idButton.firstText == "" || idButton.secondText =="" ){
            underTextColor = "#434A5D" //RGB(67,74,93)
        }
        else
            underTextColor = colorInfo.disableGrey
    }
    property string underTextChangeColor: colorInfo.disableGrey
    //****************************** # underText #
    underText: index+1
    underTextX: 11
    underTextY: 53
    underTextWidth: 134
    underTextHeight: 60
    underTextSize: 60
    underTextStyle: "HDBa1"
    underTextAlies: "Center"
    underTextColor: colorInfo.disableGrey

    //****************************** # Function #
    function textXBySelectedApp(){
        if(selectedApp == "Radio" || selectedApp == "HdRadio") return 11
        else if(selectedApp == "XmRadio") return 15+64
        else if(selectedApp == "DabRadio" || selectedApp == "RdsRadio" || selectedApp == "DMB") return 11
    }
    function textYBySelectedApp(){
        if(selectedApp == "Radio" || selectedApp == "HdRadio") return 50
        else if(selectedApp == "XmRadio") return 23+33
        else if(selectedApp == "DabRadio" || selectedApp == "RdsRadio" || selectedApp == "DMB"){
            if(secondText=="") return 50
            else return 34
        }
    }
    function textYBySelectedAppSecond(){
        if(selectedApp == "Radio" || selectedApp == "HdRadio") return 34+38
        else if(selectedApp == "XmRadio") return 34+38
        if(selectedApp == "DabRadio" || selectedApp =="RdsRadio" || selectedApp == "DMB"){
            if(firstText=="") return 50
            else return 34+38
        }
    }
    function textWidthBySelectedApp(){
        if(selectedApp == "Radio" || selectedApp == "HdRadio") return 134
        else if(selectedApp == "XmRadio") return 66
        else if(selectedApp == "DabRadio" || selectedApp == "RdsRadio" || selectedApp == "DMB") return 134
    }
    function textHeightBySelectedApp(){
        if(selectedApp == "Radio" || selectedApp == "HdRadio") return 36
        else if(selectedApp == "XmRadio") return 28
        else if(selectedApp == "DabRadio" || selectedApp == "RdsRadio" || selectedApp == "DMB") return 32
    }
    function textSizeBySelectedApp(){
        if(selectedApp == "Radio" || selectedApp == "HdRadio") return 36
        else if(selectedApp == "XmRadio") return 28
        else if(selectedApp == "DabRadio" || selectedApp == "RdsRadio" || selectedApp == "DMB") return 32
    }
}

