/**
 * FileName: MSettingRadioItem.qml
 * Author: wsh
 * Time: 2011-12-17
 **/

import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent{
    id: idSettingsMenuItem
    height: 90
    width: 858//parent.width;

    MSystem.ImageInfo{ id:imageInfo }
    MSystem.ColorInfo{ id:colorInfo }

    property bool active: false
    property string imgFolderSettings: imageInfo.imgFolderSettings
    property string menuText
    //property int selectedIndex: 0;

    //---------------------  Bottom Line Image #
    Image {
        x:13//-20
        anchors.bottom: parent.bottom
        source: imgFolderSettings + "line_list.png"
    } // End Image

    //---------------------  Background Image #
    Image{
        id: idBgDelegate
        y: 3;
        height: 90;
        source: ""
    } // End Image

    //---------------------  ListItem Text #
    Text {
        id: idDelegateText
        x: 33
        focus: true
        text: menuText
        font.pixelSize: 40
        font.family: "HDR"
        color: colorInfo.brightGrey
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideRight
    } // End Text

    //---------------------  Focus Image #
    Image {
        id:idFocusImage1
        x: 3; y: -7; z: 1
        width: parent.width-12; height:parent.height+12
        source: (idDelegateText.activeFocus)? imgFolderSettings + "line_list_f.png":""
    } // End Image



//    //---------------------  Bottom Line Image #
//    Image{
//        x: 27;
//        y: 90;
//        source : imgFolderSettings+"line_menu.png"
//    } // End Image

//    //---------------------  Background Image #
//    Image{
//        id: idBgDelegate
//        y: 3;
//        height: 90;
//        source: ""
//    } // End Image

//    //---------------------  MenuItem Text #
//    Text {
//        id:idDelegateText
//        x: 27 + 15;
//        height: 90;
//        width: 370
//        text: menuText;
//        font.pixelSize: 40 //40 is Guideline position
//        font.family: "HDR"
//        color: colorInfo.dimmedGrey
//        verticalAlignment: Text.AlignVCenter
//        elide: Text.ElideRight
//    }
//    //---------------------  Focus Image #
//    Image{
//        id:idFocusImage
//        x: 0; y: -7;  z: 1
//        height: 105

//        source: imgFolderSettings+"bg_menu_f.png";
//        visible: idSettingsMenuItem.activeFocus && showFocus;
//    }

    //---------------------  State(Item pressed, Item selected) #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges { target:idBgDelegate; height: 90; source: imgFolderSettings+"bg_menu_p.png"}
            PropertyChanges { target:idDelegateText; color:colorInfo.brightGrey;}
        },
        State {
            name: 'selected'; when: index == selectedIndex
            PropertyChanges { target: idDelegateText; color:colorInfo.black}
            PropertyChanges { target: idBgDelegate; y: -2; height: 100; source:imgFolderSettings+"bg_menu_s.png";}
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges { target: background; source: bgImagePressed; }
            PropertyChanges { target: bgTxt; color:fontColorActived; }
            PropertyChanges { target: bgTxtShadow; color:fontColorActivedShadow;  }
        }
    ]
}
