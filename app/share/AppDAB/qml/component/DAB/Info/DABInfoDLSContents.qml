/**
 * FileName: DABInfoDLSContents.qml
 * Author: HYANG
 * Time: 2013-01-23
 *
 * - 2013-01-23 Initial Created by HYANG
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent{
    id: idDabInfoDLSContents
    width: systemInfo.lcdWidth
    height: systemInfo.contentAreaHeight   

    //******************************# DLS Background Image
    Image{
        x: 33; y: 197 - systemInfo.headlineHeight
        source: imageInfo.imgBg_DLS
    }

    //******************************# DLS Text
    Text{
        id: idTxtDLS
        x: 33 + 49; y: 32 + 76 - 32/2
        width: 1116; height: 212
        text: getDLS()  //"On air now : Jo Whiley with coverage of the Q awards and Paul McCartney being honored with a Lifetime Achievement"
        font.family: idAppMain.fonts_HDR
        font.pixelSize: 32
        wrapMode: Text.Wrap
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
    }

    //******************************# Function
    function getDLS()
    {
        if(idAppMain.m_sDLS == "")
            return stringInfo.strDLS_NoInformation;
        return idAppMain.m_sDLS;
    }
}
