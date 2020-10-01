/**
 * FileName: MFullListDelegate.qml
 * Author: HYANG
 * Time: 2012-02-20
 *
 * - 2012-02-20 Initial Crated by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MButton {
    id: idMFullListDelegate
    x: 15; y: 0
    width: 1246; height: 90
    buttonWidth: 1246; buttonHeight: 90

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string selectedApp: ""
    property string mChListFirstText: ""
    property string mChListSecondText: ""

    bgImagePress: imgFolderGeneral+"list_p.png"
    bgImageFocusPress: imgFolderGeneral+"list_fp.png"
    bgImageFocus: imgFolderGeneral+"list_f.png"

    firstText: mChListFirstText
    firstTextX: 101-15; firstTextY: 46
    firstTextWidth: textWidthBySelectedApp()//1146
    firstTextSize: 32
    firstTextStyle: "HDBa1"
    firstTextAlies: "Left"
    firstTextColor: colorInfo.brightGrey

    secondText: mChListSecondText
    secondTextX: 101+489+100-15; secondTextY: 46
    secondTextWidth: 489
    secondTextSize: 32
    secondTextStyle: "HDR"
    secondTextAlies: "Right"
    secondTextColor: colorInfo.dimmedGrey
    secondTextVisible: selectedApp == "RdsRadio"

    //****************************** # Line Image #
    Image{
        x: 0-15; y: 254-systemInfo.headlineHeight
        source: imgFolderGeneral+"list_line.png"
    }

    onClickOrKeySelected: {
        idMFullListDelegate.ListView.view.currentIndex = index
        idMFullListDelegate.ListView.view.focus = true
        idMFullListDelegate.ListView.view.forceActiveFocus()
    }
    //****************************** # function #
    function textWidthBySelectedApp(){
        if(selectedApp == "RdsRadio") return 489
        else return 1146
    }
}
