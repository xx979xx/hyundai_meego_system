/**
 * FileName: MPresetPopup.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Crated by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

MComponent{
    id: idMPresetPopup
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string imgFolderPopup: imageInfo.imgFolderPopup    
    property QtObject presetPopupModel                              //# GridView`s Model
    property string selectedApp: "Radio"                              //# "Radio","HdRadio" | "XmRadio" | "DabRadio","RdsRadio","DMB"
    property string titleFirstText: ""                                       //# title Text
    property string titleSecondText: ""                                       //# title Text
    property string btnText: ""                                         //# button Text

    property int currentIndex: idPresetGridView.currentIndex
    property QtObject currentItem: idPresetGridView.currentItem

    signal presetItemClicked()
    signal buttonClicked()
    signal hardBackKeyClicked()

    MouseArea{ anchors.fill: parent }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height:parent.height
        color: colorInfo.black
        opacity: 0.7
    }
    //****************************** # Preset Background #
    Image{
        x: 110; y: 153-systemInfo.statusBarHeight
        width: 1087; height: 514
        source: imgFolderPopup+"popup_etc_07_bg.png"
    }

    //****************************** # Preset Title Text #
    Text{
        text: titleFirstText
        x: 110+45; y: 153+45-36/2-systemInfo.statusBarHeight
        width: 997; height: 36
        font.pixelSize: 36
        font.family: "HDBa1"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: "#B6C9FF" //RGB(182,201,255)
    }
    Text{
        text: titleSecondText
        x: 110+45; y: 153+45+65-36/2-systemInfo.statusBarHeight
        width: 997; height: 36
        font.pixelSize: 36
        font.family: "HDBa1"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: "#B6C9FF" //RGB(182,201,255)
    }

    //****************************** # GridView Preset Items #
    FocusScope {
        id: idPresetView
        x: 110+37; y: 153+163-systemInfo.statusBarHeight
        width: 1057; height: 401-163-5
        focus: true
        property int selectedItem: 0
        GridView {
            id: idPresetGridView
            anchors.fill: parent
            cellWidth: 171; cellHeight: 116
            focus: true
            model: presetPopupModel
            boundsBehavior: idPresetGridView.count > 12? Flickable.DragOverBounds : Flickable.StopAtBounds
            delegate: MPresetPopupDelegate{id: idPresetDelegate}
            opacity : 1
            clip: true

            //****************************** # Wheel move in GridView #
            Keys.onPressed: {
                if(idAppMain.isWheelLeft(event)){
                    idPresetGridView.moveCurrentIndexLeft()
                }
                else if(idAppMain.isWheelRight(event)) {
                    idPresetGridView.moveCurrentIndexRight()
                }
            }
        }
        KeyNavigation.down: idButton

        //****************************** # Scroll #
        MScroll {
            x: 1057-37; y: 122-120; z:1
            scrollArea: idPresetGridView;
            height: 471-122-105; width: 13
            visible: idPresetGridView.count > 12
            selectedScrollImage: imgFolderPopup+"scroll_preset_bg.png"
        } // End MOptionScroll
    }

    //****************************** # Cancel Button #
    MButton{
        id: idButton
        x: 110+333; y: 153+401-systemInfo.statusBarHeight
        width: 420; height: 73
        bgImage: imgFolderPopup+"btn_popup_l_n.png"
        bgImageActive: imgFolderPopup+"btn_popup_l_s.png"
        bgImageFocus: imgFolderPopup+"btn_popup_l_f.png"
        bgImageFocusPress: imgFolderPopup+"btn_popup_l_fp.png"
        bgImagePress: imgFolderPopup+"btn_popup_l_p.png"

        firstText: btnText
        firstTextX: 38; firstTextY: 33
        firstTextWidth: 344; firstTextHeight: 30
        firstTextSize: 30
        firstTextStyle: "HDBa1"
        firstTextAlies: "Center"
        firstTextColor: colorInfo.subTextGrey

        onClickOrKeySelected:{

            buttonClicked()
        }
        KeyNavigation.up: idPresetView
    }
    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}


