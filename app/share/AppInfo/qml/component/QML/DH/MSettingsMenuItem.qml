/**
 * FileName: MSettingMenuItem.qml
 * Author: hyang
 * Time: 2011-11-28
 **/

import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent{
    id: idSettingsMenuItem
    height: 90
    width: 422//parent.width;

    MSystem.ImageInfo{ id:imageInfo }
    MSystem.ColorInfo{ id:colorInfo }

    property string imgFolderSettings: imageInfo.imgFolderSettings
    property string menuText
    property int selectedIndex: 0;

    //************************ Bottom Line Image ***//
    Image{
        x: 27;
        y: 90;
        source : imgFolderSettings+"line_menu.png"
    }
    //************************ Background Image ***//
    Image{
        id: idBgDelegate
        y: 3;
        height: 90;
        source: ""
    }

    //************************ MenuItem Text ***//
    Text {
        id:idDelegateText
        x: 27 + 15;
        height: 90;
        width: 370
        text: menuText;
        font.pixelSize: 40 //40 is Guideline position
        font.family: "HDR"
        color: idSettingsMenuItem.enabled?colorInfo.brightGrey:colorInfo.dimmedGrey
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }    
    //************************ Focus Image ***//
    Image{
        id:idFocusImage
        x: 0; y: -7;  z: 1
        height: 105

        source: imgFolderSettings+"bg_menu_f.png";
        visible: idSettingsMenuItem.activeFocus && showFocus;
    }
    //************************ State(Item pressed, Item selected) ***//
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
        }
    ]
}

