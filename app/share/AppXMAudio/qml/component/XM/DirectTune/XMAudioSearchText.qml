/**
 * FileName: RadioFmFrequencyDial.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7

FocusScope {
    id: idRadioSearchText
    x: 0; y: 0

    property string searchTextColor: colorInfo.buttonGrey
    property string inputTextColor: colorInfo.brightGrey
    property string inputStationColor: colorInfo.dimmedGrey
    property string inputNameColor: colorInfo.dimmedGrey
    
    //**************************************** InputBox Dial Input
    Image{
        id: idRadioInputBox
        x:45; y: 182-166
        source:imageInfo.imgFolderBt_phone + "dial_inputbox_n.png"
    }

    //**************************************** InputBox - Search Number
    Text {
        id : idRadioSearchText1
        x: 45+19; y: 182-166+43-(font.pixelSize/2)
        width: 492; height: 54
        font.pixelSize: 54
        font.family : systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: searchTextColor
        text : xm_search_number
    }

    //**************************************** InputBox - Channel Number
    Text {
        id : idRadioInputText
        x: 68; y: 310-166-(font.pixelSize/2)
        width: 490; height: 40
        font.pixelSize: 40
        font.family : systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: inputTextColor
        text : (xm_search_number != "") ? ((xm_search_find == true) ? "Ch." + xm_search_number : "INVALID CHANNEL") : ""
    }

    //**************************************** InputBox - Station Name
    Text {
        id : idRadioInputStation
        x: 68; y: 310-166+42-(font.pixelSize/2)
        width: 490; height: 28
        font.pixelSize: 28
        font.family : systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: inputStationColor
        text : (xm_search_number != "") ? FINDChInfo.ChnName : ""
    }

    //**************************************** InputBox - Category Name
    Text {
        id : idRadioInputName
        x: 68; y: 310-166+42+34-(font.pixelSize/2)
        width: 490; height: 28
        font.pixelSize: 28
        font.family : systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: inputNameColor
        text : (xm_search_number != "") ? ((xm_search_number == "0") ? "" : FINDChInfo.ChnCategory) : ""
    }
}
