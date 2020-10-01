/**
 * FileName: MOptionMenuDelegate.qml
 * Author: WSH
 * Time: 2012-03-13
 *
 * - 2012-03-13 Modified by WSH
 * - 2013-01-03 Modified function (onClickOrKeySelected) by WSH
 * - 2013-01-03 Updated Component (MButton.qml) by WSH
 * - 2013-01-03 Changed function (getDimmed() -> getEnabled()) by WSH
 */

import QtQuick 1.1

MButtonForXM {
    id: idOptionMenuDelegate
    x: iMenuListBgX; y: iMenuListBgY
    width: iMenuAreaWidth; height: iMenuListBgHeight
    mEnabled: getEnabled(index)

    property alias dimCheckFlag: idOptionMenuDimcheck.state  //# for rds radio by HYANG (20120521)

    function opTypeEvent(index, opType){
        if(idOptionMenuDelegate.mEnabled){
            if(opType=="dimCheck"){
                //console.log("[MOptionMenuDelegate] idOptionMenuDimcheck.state : ", idOptionMenuDimcheck.state)
                if(dimCheckFlag == "on"){
                    dimCheckFlag = "off"
                    idOptionMenuDimcheck.dimUnchecked()
                }else if(dimCheckFlag == "off"){
                    dimCheckFlag = "on"
                    idOptionMenuDimcheck.dimChecked()
                } // End if
            }
            else if(opType=="radioBtn") {
                selectedRadioIndex = index
                radioEvent(index)
            }
            else{ indexEvent(index) } // End if
        } // End if
    } // End function

    //--------------------- Button Image #
    bgImage: ""
    bgImagePress: sImgBg_OptionMenuListP
    bgImageFocus: sImgBg_OptionMenuListF

    //--------------------- Menu Item #
    firstText: name
    firstTextX: iMenuTextX
    firstTextY: iMenuTextY
    firstTextSize: 32
    firstTextStyle: systemInfo.font_NewHDR
    firstTextWidth: iMenuTextWidth
    firstTextAlies: "Left"
    firstTextColor: idOptionMenuDelegate.activeFocus ? colorInfo.brightGrey : colorInfo.subTextGrey
    firstTextPressColor: colorInfo.brightGrey
    firstTextFocusPressColor: colorInfo.brightGrey
    firstTextEnabled: getEnabled(index)

    //--------------------- Line Image #
    lineImage: sImgLine_OptionMenu
    lineImageX: iMenuLineX
    lineImageY: iMenuLineY

    //--------------------- Clicked/Selected Event #
    onClickOrKeySelected: {
        if(idAppMain.isSettings) return;
        opTypeEvent(index, opType)
    }

    //--------------------- Sub Menu #
    Image{
        id: idOptionMenuSubMenu
        x: iMenuIconX
        y: iMenuIconY
        source: sImgIco_OptionMenuArrow
        visible: (opType=="subMenu")
    }

    //--------------------- Dim Check #
    MDimCheck{
        id: idOptionMenuDimcheck
        //        iconX: iMenuIconX
        //        anchors.verticalCenter: parent.verticalCenter
        visible: (opType=="dimCheck")
        state: ((gArtistSongAlert == true) || (gUnsubscribedChannel == true)) ? "on":"off"
        mEnabled: getEnabled(index)

        Item {
            id: idCheckBoxImage
            x: iMenuIconX
            y: 0
            anchors.verticalCenter: parent.verticalCenter
            width: 45; height: 45
            visible: (opType=="dimCheck")
            Image {
                id: imgDimCheckOff
                source: imageInfo.imgFolderGeneral+"ico_check_n.png"
                visible: (idOptionMenuDimcheck.state == "off")
            }
            Image {
                id: imgDimCheckOn
                source: imageInfo.imgFolderGeneral+"ico_check_s.png"
                visible: (idOptionMenuDimcheck.state == "on")
            }
        }
    } // End MDimCheck

    //--------------------- Radio Button #
    MRadioButton{
        id: idOptionMenuRadioBtn
        iconX: iMenuIconX
        iconY: iMenuIconY
        visible: (opType=="radioBtn")
        active: index == selectedRadioIndex
        mEnabled: getEnabled(index)
        onClickOrKeySelected: {
            selectedRadioIndex = selectedIndex
            radioEvent(selectedRadioIndex)
        }
    }

    //--------------------- 5s Timer stop(), start() for Flickable (disabled) #
    Item{
        width: parent.width; height: parent.height
        visible: (idOptionMenuDelegate.mEnabled == false)
        MouseArea{
            anchors.fill: parent
            onPressed: { idMOptionMenuTimer.stop(); }
            onReleased:{ idMOptionMenuTimer.start(); }
        }
    }

    // ITS 0199067 # by WSH(131029)
    onPressAndHold: {
        if(pressAndHoldFlag == true || isJogEnterLongPressed == true)
        {
            idMOptionMenuTimer.stop();
        }
    }
    
    Keys.onPressed: {
        if(idAppMain.isLeft(event))
            leftKeyMenuClose();

        //# Focus skip when Disable
        //        var i = 0, curIndex, totalCount;
        //        curIndex = idOptionMenuDelegate.ListView.view.currentIndex;
        //        totalCount = idOptionMenuDelegate.ListView.view.count-1;

        //        if(event.key == Qt.Key_Up)
        //        {
        //            while(i != totalCount){
        //                if(curIndex <= 0){ break;}
        //                else{ curIndex--; }
        //                if( getEnabled(curIndex) == false ){ idOptionMenuDelegate.ListView.view.currentIndex = curIndex; }
        //                else{ break; }
        //                i++;
        //            }
        //        }
        //        else if(event.key == Qt.Key_Down)
        //        {
        //            while(i != totalCount){
        //                if(curIndex >= totalCount){ break;}
        //                else{ curIndex++; }
        //                if( getEnabled(curIndex) == false ){ idOptionMenuDelegate.ListView.view.currentIndex = curIndex; }
        //                else{ break; }
        //                i++;
        //            }
        //        }
        //        else
        if(event.key == Qt.Key_Right)
        {
            if(opType=="subMenu") rightKeySubMenuOpen()
        }
    }

    onWheelLeftKeyPressed: {
        if(listOptionMenu.flicking || listOptionMenu.moving)   return;
        if(idAppMain.isSettings) return;

        //# Focus skip when Disable KEH (20130307)
        var i = 0, curIndex, totalCount;
        curIndex = idOptionMenuDelegate.ListView.view.currentIndex;
        totalCount = idOptionMenuDelegate.ListView.view.count-1;
        while(i != totalCount)
        {
            if(curIndex <= 0)
            {
                if(listOptionMenu.count > 8)
                    curIndex = totalCount;
                else
                    break;
            }
            else
            {
                curIndex--;
            }

            if( getEnabled(curIndex) == true )
            {
                idOptionMenuDelegate.ListView.view.currentIndex = curIndex;
                break;
            }
            i++;
        }
    }

    onWheelRightKeyPressed: {
        if(listOptionMenu.flicking || listOptionMenu.moving)   return;
        if(idAppMain.isSettings) return;

        //# Focus skip when Disable KEH (20130307)
        var i = 0, curIndex, totalCount;
        curIndex = idOptionMenuDelegate.ListView.view.currentIndex;
        totalCount = idOptionMenuDelegate.ListView.view.count-1;
        while(i != totalCount)
        {
            if(curIndex >= totalCount)
            {
                if(listOptionMenu.count > 8)
                    curIndex = 0;
                else
                    break;
            }
            else
            {
                curIndex++;
            }

            if( getEnabled(curIndex) == true )
            {
                idOptionMenuDelegate.ListView.view.currentIndex = curIndex;
                break;
            }
            i++;
        }
    }

    //------------------------------ Updated jog_V1.3 (looping X) # by WSH
    Connections{
        target: idOptionMenuDimcheck
        onDimUnchecked:{
            //console.log(" [MOptionMenuDelegate] Call onDimUnchecked")
            dimUncheckEvent(index)
        }
        onDimChecked:{
            //console.log(" [MOptionMenuDelegate] Call onDimChecked")
            dimCheckEvent(index)
        }
    } // End Connections
} // End MButton
