/**
 * FileName: MRadioButtonFullItem.qml
 * Author: hyang
 * Time: 2011-11-30
 **/

import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent {
    id: idRadiobtnDelegate
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: 90;

    MSystem.SystemInfo{id:systemInfo}
    MSystem.ColorInfo{id:colorInfo}
    MSystem.ImageInfo{id:imageInfo}

    property string imgFolderDmb: imageInfo.imgFolderDmb
    property string imgFolderGeneral: imageInfo.imgFolderGeneral


    property alias active : idRadio.active;

    property string inputMode : idAppMain.inputMode//"touch" //"jog"

    property string itemText : "";

    signal clickOrKeySelected()
    signal pressAndHold();   


    state:idRadio.state;

    Text {
        id: idText
        x: 47+65; y: 18
        width: 1061; //height: 40
        text: itemText
        opacity: 1
        color:colorInfo.brightGrey
        font { family: "HDR"; pixelSize: 40}
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    MComp.RadioButton{
        id: idRadio
        x: 81+944+170; y: 22
        width: 49; height: 50
        anchors.verticalCenter: parent.verticalCenter;
        active: selectedIndex == index
        focus: true;
    }

    Image{
        x: 24 ; y: 92
        width: 1232
        source:imgFolderRadio_Dab+"line_list.png"
    }

    Image {
        id: idFocusImage
        x: 12; y: -9
        height: 104
        source: imgFolderDmb+"list_dmb_f.png"
        visible: idRadio.activeFocus && showFocus;
    }

    Image{
        id: idRadioBtnFocusImage
        x: 81+944+170-7; y: 21-7; z: 1
        width: 63; height: 64
        source: imgFolderGeneral + "radio_f.png"
        visible: idRadio.activeFocus && showFocus;
    }

    onClickOrKeySelected: {
        selectedIndex = index
    }
}
