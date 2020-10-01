/**
 * FileName: MStationListDelegate.qml
 * Author: hyang
 * Time: 2011-12-27
 * using in RDS Radio
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
    property string imgFolderRadio_Dab: imageInfo.imgFolderRadio_Dab

    //property alias active : idRadio.active;

    property string inputMode : idAppMain.inputMode//"touch" //"jog"

    property string firstText : "";
    property string secondText: "";
    property string selectedMenu: "FM";

    signal clickOrKeySelected()
    signal pressAndHold();


    //state:idRadio.state;

    Text {        
        x: 24+57; y: 18
        width: 1061; //height: 40
        text: firstText
        opacity: 1
        color: colorInfo.brightGrey
        font { family: "HDR"; pixelSize: 40}
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    Image {        
        x: 24+57+959+23-3; y:20
        width: 194; height: 51
        source: imgFolderRadio_Dab + "list_category.png"
        visible: selectedMenu != "MW"
    }
    Text{
        id: idPtyText
        x:24+57+959+23; y:20
        width: 194-3; height: 51
        text: secondText
        font.family: "HDR"
        font.pixelSize: 28
        color: colorInfo.subTextGrey
        wrapMode: Text.Wrap
        visible: selectedMenu != "MW"
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        onTextChanged: {
            font.pixelSize = 28
            if(paintedHeight > height || paintedWidth+4 > width ){
                font.pixelSize = (font.pixelSize*0.8);
            }
        }
    }

    Image{
        x: 24 ; y: 92
        width: 1232
        source:imgFolderRadio_Dab+"line_list.png"
    }

    Image {
        id: idFocusImage
        x: 12; y: -3
        height: 104
        source: imgFolderDmb+"list_dmb_f.png"
        visible: idRadiobtnDelegate.activeFocus && idRadiobtnDelegate.showFocus;
    }

    onClickOrKeySelected: {
        selectedIndex = index
    }
}
