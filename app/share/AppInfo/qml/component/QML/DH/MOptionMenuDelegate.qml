/**
 * FileName: MOptionMenuDelegate.qml
 * Author: WSH
 * Time: 2012-03-13
 *
 * - 2012-03-13 Modified by WSH
 */
import QtQuick 1.0

MButton {
    id: idOptionMenuDelegate
    x: 0; y: 0
    width: delegateWidth; height: itemHeight
    dimmed: getDimmed()

    function getDimmed(){
        switch(index){
        case 0: return menu0Dimmed;
        case 1: return menu1Dimmed;
        case 2: return menu2Dimmed;
        case 3: return menu3Dimmed;
        case 4: return menu4Dimmed;
        case 5: return menu5Dimmed;
        case 6: return menu6Dimmed;
        case 7: return menu7Dimmed;
        case 8: return menu8Dimmed;
        case 9: return menu9Dimmed;
        case 10: return menu10Dimmed;
        case 11: return menu11Dimmed;
        case 12: return menu12Dimmed;
        case 13: return menu13Dimmed;
        case 14: return menu14Dimmed;
        case 15: return menu15Dimmed;

        default: return false;
        }
    } // End function

    onDimmedChanged: { console.log(" [OptionMenuDelegate]["+index+"]: "+!getDimmed()) }

    function opTypeEvent(index, opType){
        if(!idOptionMenuDelegate.dimmed){
            if(opType=="dimCheck"){
                if(idOptionMenuDimcheck.flagToggle){
                    idOptionMenuDimcheck.dimUnchecked()
                }else if(!idOptionMenuDimcheck.flagToggle){
                    idOptionMenuDimcheck.dimChecked()
                } // End if
                idOptionMenuDimcheck.flagToggle = !idOptionMenuDimcheck.flagToggle
            }
            else if(opType=="radioBtn") {
                selectedRadioIndex = index
                radioEvent(index)
            }
            else{ indexEvent(index) } // End if
        } // End if
    } // End function

    //--------------------- Button Info #
    buttonWidth : width
    buttonHeight: height
    bgImage: ""
    bgImagePress: menuDepth=="OneDepth"? imgFolderGeneral + "bg_optionmenu_list_p.png" : imgFolderGeneral + "bg_optionmenu_list_02_p.png"
    bgImageFocusPress: menuDepth=="OneDepth"? imgFolderGeneral + "bg_optionmenu_list_fp.png" : imgFolderGeneral + "bg_optionmenu_list_02_fp.png"
    bgImageFocus: menuDepth=="OneDepth"? imgFolderGeneral + "bg_optionmenu_list_f.png" : imgFolderGeneral + "bg_optionmenu_list_02_f.png"

    //--------------------- Clicked/Selected Event #
    onClickOrKeySelected: { opTypeEvent(index, opType) }

    //--------------------- Menu Item #
    firstText: name
    firstTextX: listLeftMargine
    firstTextY : (130-systemInfo.statusBarHeight)
    firstTextSize: itemItemFontSize
    firstTextStyle: itemItemFontName
    firstTextWidth: (opType=="dimCheck"||opType=="radioBtn") ? itemWidth-45-1 : itemWidth-1 // itemWidth-45-1
    firstTextAlies: "Left"
    firstTextElide : "Right"
    firstTextColor: colorInfo.subTextGrey
    firstTextPressColor: colorInfo.brightGrey
    firstTextFocusPressColor: colorInfo.brightGrey
    firstTextEnabled: !getDimmed()

    //--------------------- Sub Menu #
    Image{
        id: idOptionMenuSubMenu
        x: menuDepth=="OneDepth"? itemWidth-(itemWidth-275) : itemWidth-(itemWidth-256); //z: 1
        source: imgFolderGeneral + "ico_optionmenu_arrow.png"
        anchors.verticalCenter: parent.verticalCenter
        visible: (opType=="subMenu")
    } // End MDimCheck

    //--------------------- Dim Check #
    MDimCheck{
        id: idOptionMenuDimcheck
        iconX: menuDepth=="OneDepth"? itemWidth-(itemWidth-275) : itemWidth-(itemWidth-256); //z: 1
        anchors.verticalCenter: parent.verticalCenter
        visible: (opType=="dimCheck")
        state: (flagToggle==true)?"on":"off"
        dimmed: getDimmed()
    } // End MDimCheck

    //--------------------- Radio Button #
    MRadioButton{
        id: idOptionMenuRadioBtn
        iconX: menuDepth=="OneDepth"? itemWidth-(itemWidth-275) : itemWidth-(itemWidth-256); z: 1
        anchors.verticalCenter: parent.verticalCenter
        visible: (opType=="radioBtn")
        active: index == selectedRadioIndex
        dimmed: getDimmed()

        onClickOrKeySelected: {
            selectedRadioIndex = selectedIndex
            radioEvent(selectedRadioIndex)
        }
    } // End MRadioButton

    //--------------------- Line Image #
    Image {
        id: imgLine
        y: lineY
        height: lineHeight
        source: imgFolderGeneral + "line_optionmenu.png"
    } // End Imgae

    Connections{
        target: idOptionMenuDimcheck
        onDimUnchecked:{ dimUncheckEvent(index) }
        onDimChecked:{ dimCheckEvent(index) }
    } // End Connections
} // End MButton
