/**
 * FileName: MPreset.qml
 * Author: HYANG
 * Time: 2012-07
 *
 * - 2012-07 Initial Created by HYANG
 * - 2012-07 add signal pressAndHold
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

MComponent{
    id: idMPreset
    x: 0; y: systemInfo.statusBarHeight
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property QtObject presetModel: idPresetModel  //# GridView`s Model

    property int selectedIndex: 0
    property int firstTextPreset
    property string secondTextPreset: ""

    property int currentIndex: idPresetGridView.currentIndex
    property QtObject currentItem: idPresetGridView.currentItem

    signal presetItemClicked()
    signal presetItemPressAndHold(bool beepplay) //dg.jin 20141103 ITS 251755 presetlist longpress beep

    //****************************** # Preset Background #
    //KSW 140120 for KH
//    Image{
//         x: 0; y: -systemInfo.statusBarHeight
////         width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
////        Image{ source: imgFolderGeneral+"bg_type_b.png"}
//         source: imgFolderGeneral+"bg_main.png"
//    }

    //****************************** # GridView Default ListModel #
    ListModel{
        id: idPresetModel
        ListElement{presetName: ""}
        ListElement{presetName: ""}
        ListElement{presetName: ""}
        ListElement{presetName: ""}
        ListElement{presetName: ""}
        ListElement{presetName: ""}
        ListElement{presetName: ""}
        ListElement{presetName: ""}
        ListElement{presetName: ""}
        ListElement{presetName: ""}
        ListElement{presetName: ""}
        ListElement{presetName: ""}
    }

    //****************************** # GridView #
    FocusScope {
        id: idPresetView
        x: 58;// y: 184-systemInfo.headlineHeight
        width: systemInfo.lcdWidth; height: systemInfo.lcdHeight-systemInfo.statusBarHeight
        focus: true
        GridView {
            id: idPresetGridView
            anchors.fill: parent
            cellWidth: 590; cellHeight: 86
            focus: true
            model: presetModel
            flow: GridView.TopToBottom
            boundsBehavior: Flickable.StopAtBounds
            delegate: MPresetDelegate{ id: idMPresetDelegate }
            opacity : 1
            clip: true
        }
    }
//20130111 added by qutiguy - fixed a defect wrong current index after saving preset
    function updateCurrentIndex(indexArgument){
        idPresetGridView.currentIndex = indexArgument;
    }
    function increaseCurrentIndex(){
        idPresetGridView.moveCurrentIndexDown();
    }
    function decreaseCurrentIndex(){
        idPresetGridView.moveCurrentIndexUp();
    }
}


