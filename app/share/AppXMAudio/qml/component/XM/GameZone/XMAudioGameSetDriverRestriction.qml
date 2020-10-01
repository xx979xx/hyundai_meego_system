/**
 * FileName: RadioPresetList.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7

FocusScope {
    id: idRadioGameSetDriverRestrictionQml
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.contentAreaHeight

    property string gameSetDriverRestrictionTextColor: colorInfo.brightGrey

    //Driving Restriction
    Image{
        x: 100+462; y: 289-166
        source: imageInfo.imgFolderGeneral+"ico_block.png"
        visible: true
    }

    //Driver Restriction Text
    Text {
        id: idRadioGameSetDriverRestrictionText
        x: 100; y: 467-166
        width: 462+618; height: 35
        font.pixelSize: 32
        font.family : systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: gameSetDriverRestrictionTextColor
        text : stringInfo.sSTR_XMRADIO_DRS_WARNING
        visible: true
    }
}
