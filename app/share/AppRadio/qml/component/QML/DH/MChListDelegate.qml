/**
 * FileName: MChListDelegate.qml
 * Author: HYANG
 * Time: 2012-05
 *
 * - 2012-05 Initial Created by HYANG
 * - 2012-07-25 added presetList bigSize
 * - 2012-08-22 added TextScroll
 * - 2012-09-19 change text color
 * - 2012-11-20 GUI modify(selected image delete) Save, edit icon add
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MButton {
    id: idMChListDelegate
    x: selectedApp=="DMB"? 43-10 : selectedApp=="HdRadio"? 43-29 : 43-33;
    y: 2
    width: selectedApp=="DMB"? 422 : selectedApp=="HdRadio"? 462 : 557
    height: 89
    buttonName: index
    active: (buttonName == selectedItem)

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    //****************************** # Preperty #
    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderRadio_Hd : imageInfo.imgFolderRadio_Hd
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderDmb : imageInfo.imgFolderDmb

    property string selectedApp: "DMB"    // Application selected ("DMB" | "HdRadio" .. )

    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property string mChListThirdText: ""
    property string mChIconHdText: ""
    property bool menuHdRadioFlag: false
    property bool onlyPresetName: false
    property bool presetSave: false
    property bool presetOrderHandler: false
    property bool presetOrderArrow: false
    property string presetSaveText: ""
    signal presetSaveClickOrKeySelected();
    signal presetOrderHandlerClickOrKeySelected();

    bgImage: ""
    bgImagePress: selectedApp=="DMB"? imgFolderDmb+"ch_list_p.png" : selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_p.png" : imgFolderRadio+"preset_p.png"
    // bgImageActive: selectedApp=="DMB"? imgFolderDmb+"ch_list_s.png" : selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_s.png" : imgFolderRadio+"preset_s.png"
    bgImageFocusPress: selectedApp=="DMB"? imgFolderDmb+"ch_list_fp.png" : selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_p.png" : imgFolderRadio+"preset_p.png"
    bgImageFocus: selectedApp=="DMB"? imgFolderDmb+"ch_list_f.png" : selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_f.png" : imgFolderRadio+"preset_f.png"

    //****************************** # Index (FirstText) #
    firstText: mChListFirstText  //index+1
    firstTextX: selectedApp=="DMB"? 0 : 43-13-10
    firstTextY: 89-44
    firstTextWidth: selectedApp=="DMB"? 58 : 13+49
    firstTextHeight: 40
    firstTextSize: 40
    firstTextStyle: systemInfo.hdb
    firstTextAlies: "Center"
    firstTextColor: idMChListDelegate.activeFocus? colorInfo.brightGrey : colorInfo.dimmedGrey
    firstTextPressColor: idMChListDelegate.activeFocus? colorInfo.brightGrey : colorInfo.dimmedGrey
    firstTextFocusPressColor: colorInfo.brightGrey
    firstTextSelectedColor: idMChListDelegate.active ? "#7CBDFF" : colorInfo.brightGrey  //RGB(124, 189, 255)

    //****************************** # Channel (SecondText) #
    secondText: mChListSecondText
    secondTextX: (selectedApp == "DMB")? 58+15 : 43-13-10+13+49+8;
    secondTextY: 89-44
    secondTextWidth: (selectedApp == "DMB")? 337 : onlyPresetName ? 442 : 116
    secondTextHeight: 40
    secondTextSize: 40
    secondTextStyle: systemInfo.hdb
    secondTextAlies: (selectedApp == "DMB") || onlyPresetName ? "Left" : "Right"
    secondTextElide: "Right"
    secondTextScrollEnable: false//(buttonName == selectedItem)? true: false
    secondTextScrollInterval: 150
    secondTextScrollOnewayMode: false
    secondTextColor: colorInfo.brightGrey;
    secondTextPressColor:  colorInfo.brightGrey;
    secondTextFocusPressColor:  colorInfo.brightGrey;
    secondTextSelectedColor: idMChListDelegate.active ? "#7CBDFF" : colorInfo.brightGrey //RGB(124, 189, 255)

    //****************************** # StationName (ThirdText) #
    thirdText: mChListThirdText
    thirdTextX: 43-13-10+13+49+8+116+28
    thirdTextY: 89-44
    thirdTextWidth: (presetSave == true)? 201 : ((presetOrderHandler == true) || (presetOrderHandler == true)) ? 222 : 304
    thirdTextHeight: 40
    thirdTextSize: 40
    thirdTextStyle: systemInfo.hdr//"HDR"
    thirdTextAlies: "Left"
    thirdTextElide: "Right"
    thirdTextScrollEnable: false//(buttonName == selectedItem)? true: false
    thirdTextScrollInterval: 150
    thirdTextScrollOnewayMode: false
    thirdTextVisible: selectedApp == "DMB"? false : onlyPresetName? false : true
    thirdTextColor: colorInfo.brightGrey
    thirdTextPressColor: colorInfo.brightGrey;
    thirdTextFocusPressColor: colorInfo.brightGrey;
    thirdTextSelectedColor: idMChListDelegate.active ? "#7CBDFF" : colorInfo.brightGrey  //RGB(124, 189, 255)

    //****************************** # HD Radio yellow icon image #
    Image{
        x: 411-13;
        y: 89-55-2; z: 1
        width: 44; height: 24
        source: imgFolderRadio_Hd+"ico_hd.png"
        visible: (selectedApp == "HdRadio") && menuHdRadioFlag && iconHdText.text!=""
    }
    Text{
        id: iconHdText
        text: mChIconHdText
        x: 411-13;
        y: 89-55-2+12-20/2; z: 1
        width: 44; height: 20
        font.pixelSize: 20
        font.family: systemInfo.hdr//"HDR"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.black
        visible: (selectedApp == "HdRadio") && menuHdRadioFlag && iconHdText.text!=""
    }

    //****************************** # Line Image #
    fgImage: selectedApp == "DMB"? imgFolderGeneral+"line_ch.png" : imgFolderGeneral+"line_menu_list.png"
    fgImageX: 43-10
    fgImageY: 87
    fgImageWidth: selectedApp == "DMB"? 398 : 493
    fgImageHeight: 3

    //****************************** # Preset Save Button (121120)
    MButton{
        x: 43-10+201+201+4
        y: 10
        width: 105; height: 68
        bgImage: imgFolderRadio+"btn_save_n.png"
        bgImagePress: imgFolderRadio+"btn_save_p.png"
        visible: presetSave
        firstText: presetSaveText
        firstTextX: 0
        firstTextY: 34-19
        firstTextWidth: 105
        firstTextHeight: 68
        firstTextSize: 28
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextPressColor: colorInfo.brightGrey
        onClickOrKeySelected: presetSaveClickOrKeySelected();
    }

    //****************************** # Edit Preset Order (121120)
    Image{ //
        x: 43-10+201+222+10
        y: 31
        source: imgFolderRadio+"ico_handler.png"
        visible: presetOrderHandler
        MouseArea{
            anchors.fill: parent
            onClicked: presetOrderHandlerClickOrKeySelected();
        }
    }
    Item{
        visible: presetOrderArrow
        Image{
            x: 43-10+201+222+10+7
            y: 15
            source: index == 0? imgFolderRadio+"ico_arrow_u_d.png" : imgFolderRadio+"ico_arrow_u_n.png"
        }
        Image{
            x: 43-10+201+222+10+7
            y: 15+30+4
            source: index == (idMChListDelegate.ListView.view.count-1)? imgFolderRadio+"ico_arrow_d_d.png" : imgFolderRadio+"ico_arrow_d_n.png"
        }
    }

    //****************************** # Item Click or Key Selected #
    onClickOrKeySelected: {
        selectedItem = index
        idMChListDelegate.ListView.view.currentIndex = index
        idMChListDelegate.ListView.view.focus = true
        idMChListDelegate.ListView.view.forceActiveFocus()
    }

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event) || (Qt.Key_Up == event.key)){
            console.log("======================> isWheelLeft Index = ", idMChListDelegate.ListView.view.currentIndex , index)
            if(idMChListDelegate.ListView.view.currentIndex > 0xF0)      // JSH 120709 Radio
                idMChListDelegate.ListView.view.currentIndex = index;

            if(Qt.Key_Up == event.key)
                return;

            if( idMChListDelegate.ListView.view.currentIndex ){
                idMChListDelegate.ListView.view.decrementCurrentIndex();
            }
            else{
                idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.count-1, idMChListDelegate.ListView.view.Visible);
                idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.count-1;
            }
        }
        else if(idAppMain.isWheelRight(event) || (Qt.Key_Down == event.key)) {
            console.log("======================> isWheelRight Index = ", idMChListDelegate.ListView.view.currentIndex , index)
            if(idMChListDelegate.ListView.view.currentIndex > 0xF0)      // JSH 120709 Radio
                idMChListDelegate.ListView.view.currentIndex = index;

            if(Qt.Key_Down == event.key)
                return;

            if( idMChListDelegate.ListView.view.count-1 != idMChListDelegate.ListView.view.currentIndex ){
                idMChListDelegate.ListView.view.incrementCurrentIndex();
            }
            else{
                idMChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                idMChListDelegate.ListView.view.currentIndex = 0;
            }
        }
    }
}
