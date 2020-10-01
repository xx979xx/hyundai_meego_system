/**
 * FileName: InfoTypeABand.qml
 * Author: WSH
 * Time: 2012-02-27
 *
 * - 2012-02-13 Initial Crated by WSH
 */

import QtQuick 1.0
import "../../component/system/DH" as MSystem
import "../../component/QML/DH" as MComp
import "../../component/Info" as MInfo

MComp.MComponent {
    id: idInfoTypeABand
    x: 0; y: 0
    focus: true
    width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MInfo.InfoImageInfo{ id: imageInfo }

    //--------------- Preperty #
    property string titleText: "" //[user control] Title`s Label Text
    property bool tabBtnFlag: false  //[user control] BandTab button On/Off

    //--------------- Signal (when button clicked) #
    //signal backKeyClicked();

    //--------------- Background Image of Band #
    Image{
        y: 0
        height: 83
        source: imgFolderGeneral+"bg_title_area.png"
    } // End Image


    //--------------- Title Text #
    Text{
        id: txtTitle
        text: titleText
        x: 41; y: 90-systemInfo.statusBarHeight
        width: 863; height: 68
        font.pixelSize: 34
        font.family: "HDR"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    } // End Text

    InfoTypeABack{ id: idBackKey; focus: true }

    onBackKeyPressed: {
        console.log(" # [NonAVMain][InfoTypeABand] Back")
        gotoBackScreen()
    }
} // End MComponent
