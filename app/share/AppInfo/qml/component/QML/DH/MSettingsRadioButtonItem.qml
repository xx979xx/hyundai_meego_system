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
    width: parent.width//systemInfo.lcdWidth-422;
    height: 90;

    MSystem.SystemInfo{id:systemInfo}
    MSystem.ColorInfo{id:colorInfo}
    MSystem.ImageInfo{id:imageInfo}

    property string imgFolderSettings: imageInfo.imgFolderSettings
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    property alias active : idRadio.active;
    property string itemText : "";
    property int lineWidth: 749
    property int lineHeight: 2
    property int listImgWidth: itemImgX+lineWidth+idRadio.width+7
    property int listImgHeight: 2
    property int itemImgX: 13 // 435-422
    property int itemImgY: 49 // (217-systemInfo.statusBarHeight-systemInfo.bandHeight)
    property int itemTextX: itemImgX+19
    property int radioX: 773 // 1195-422
    property int radioY: 22
    property bool selectedDlg: false
    property int selectedIndexValue
    property string inputMode : idAppMain.inputMode//"touch" //"jog"
    signal clickOrKeySelected()

    state:idRadio.active;

    Image{
        id: imgList
        x: itemImgX; y: itemImgY+43+2
        width: listImgWidth; height: listImgHeight
        source:imgFolderSettings+"line_list.png"
    }

    Text {
        id: idText
        x: itemTextX; y: itemImgY-(height/2)
        width: idRadiobtnDelegate.width-idRadio.width; height: 40
        text: itemText
        opacity: 1
        color: colorInfo.brightGrey
        font { family: "HDR"; pixelSize: 40 }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    MComp.RadioButton{
        id: idRadio
        x: radioX; y: radioY
        width: 49; height: 50
        anchors.verticalCenter: parent.verticalCenter;
        active: selectedIndexValue == index
       
        focus: true;

        onClickOrKeySelected: { idRadiobtnDelegate.clickOrKeySelected() }
    }

    Image {
        id: idFocusImage
        x: itemImgX-12; y: -7; z: 100
        width: listImgWidth+24; height: 111
        source: imgFolderSettings+"line_list_f.png"
        visible: idRadio.activeFocus && showFocus;
    }

    Image{
        id: idRadioBtnFocusImage
        x: radioX-7; y: 21-7;  z: 101
        width: 63; height: 64
        source: imgFolderGeneral + "radio_f.png"
        visible: idRadio.activeFocus && showFocus;
    }

    onClickOrKeySelected: {
    }
}
