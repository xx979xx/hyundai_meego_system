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
import QtQuick 1.0

MButton {
    id: idOptionMenuDelegate
    x: 0; y: 0
    width: delegateWidth; height: opItemHeight
    mEnabled: getEnabled(index)

    function getEnabled(index){
        switch(index){
        case 0: return menu0Enabled;
        case 1: return menu1Enabled;
        case 2: return menu2Enabled;
        case 3: return menu3Enabled;
        case 4: return menu4Enabled;
        case 5: return menu5Enabled;
        default: return true;
        }
    } // End function

    //onMEnabledChanged: { console.log(" [MOptionMenuDelegate]["+index+"]: "+getEnabled()) }

    property alias dimCheckFlag: idOptionMenuDimcheck.state  //# for rds radio by HYANG (20120521)

    property bool isFlagOn: opType !="dimCheck" ? false : flagToggle

    Component.onCompleted: {
        if(opType == "dimCheck")
            dimCheckFlag = flagToggle ? "on" : "off"
    }

    onIsFlagOnChanged: {
        dimCheckFlag = flagToggle ? "on" : "off"
    }

    function opTypeEvent(index, opType){
        if(idOptionMenuDelegate.mEnabled){
            if(opType=="dimCheck"){
                if(dimCheckFlag == "on")
                    dimUncheckEvent(index);
                else
                    dimCheckEvent(index);
            }else if(opType=="radioBtn") {
                selectedRadioIndex = index
                radioEvent(index)
            }else if(opType=="subMenu") {
                subMenuIndexEvent(index);
            }
            else{ indexEvent(index) } // End if
        } // End if
    } // End function

    //--------------------- Button Info #
//    buttonWidth : width
//    buttonHeight: height
    bgImage: ""
    bgImagePress: opBgImagePress
    bgImageFocusPress: opBgImageFocusPress
    bgImageFocus: opBgImageFocus
    bgFitToSize: true
//    bgImageX: 0
//    bgImageY: -3
//    bgImageHeight: 86

    //--------------------- Clicked/Selected Event #
    onClickOrKeySelected: {
        if(isOnAnimation == false)
        {
            idMOptionMenu.linkedCurrentIndex = index
            idOptionMenuDelegate.ListView.view.focus = true
            idOptionMenuDelegate.ListView.view.forceActiveFocus()
            opTypeEvent(index, opType)
        }
    }

    //--------------------- Menu Item #
    firstText: name
    firstTextX: listLeftMargine
//    firstTextY : (130-systemInfo.statusBarHeight)
    firstTextSize: opItemFontSize
    firstTextStyle: opItemFontName
    firstTextWidth: (opType=="") ? opItemWidth-listLeftMargine : opItemWidth-60-1
    firstTextAlies: Text.AlignLeft
//    firstTextElide : "Right"
    firstTextColor: colorInfo.subTextGrey
    firstTextPressColor: colorInfo.brightGrey
    firstTextFocusPressColor: colorInfo.brightGrey
    firstTextDisableColor: enabled ? colorInfo.subTextGrey : colorInfo.disableGrey
    enabled: getEnabled(index)

    onEnabledChanged: {
        if(enabled == false)
        {
            if(ListView.view.currentIndex == index)
            {
                if(ListView.view.currentIndex > 0)
                    ListView.view.decrementCurrentIndex();
                else
                    ListView.view.incrementCurrentIndex();
            }
        }
    }

    //--------------------- Sub Menu #
    Image{
        id: idOptionMenuSubMenu
        x: opIconX
        source: enabled ? imgFolderGeneral + "ico_optionmenu_arrow.png" : ""
        anchors.verticalCenter: parent.verticalCenter
        visible: (opType=="subMenu")
    } // End SubMenu

    //--------------------- Dim Check #
    MDimCheck{
        id: idOptionMenuDimcheck
        visible: (opType=="dimCheck")
        mEnabled: getEnabled(index)
        onDimChecked: {
            idMOptionMenu.linkedCurrentIndex = index
            idOptionMenuDelegate.ListView.view.focus = true
            idOptionMenuDelegate.ListView.view.forceActiveFocus()
            opTypeEvent(index, opType)
        }
        onDimUnchecked: {
            idMOptionMenu.linkedCurrentIndex = index
            idOptionMenuDelegate.ListView.view.focus = true
            idOptionMenuDelegate.ListView.view.forceActiveFocus()
            opTypeEvent(index, opType)
        }
        Item {
            id: idCheckBoxImage
            x: opIconX
            y: 0
            anchors.verticalCenter: parent.verticalCenter
            width: 45; height: 45
            visible: (opType=="dimCheck")
            Image {
                id: imgDimCheckOff
                source: imageInfo.imgFolderGeneral+"ico_check_n.png"
                visible: (dimCheckFlag == "off")
            }
            Image {
                id: imgDimCheckOn
                source: imageInfo.imgFolderGeneral+"ico_check_s.png"
                visible: (dimCheckFlag == "on")
            }
        }
    } // End MDimCheck

    //--------------------- Radio Button #
    MRadioButton{
        id: idOptionMenuRadioBtn
        anchors.verticalCenter: parent.verticalCenter
        visible: (opType=="radioBtn")
        active: index == selectedRadioIndex
        mEnabled: getEnabled(index)

        onClickOrKeySelected: {
            selectedRadioIndex = selectedIndex
            radioEvent(selectedRadioIndex)
        }
        Image {
            id: imgRadioBtn
            x: opIconX
            y: 0
            width: 45; height: 45
            source: (index == selectedRadioIndex) ? imageInfo.imgFolderGeneral + "ico_radio_s.png" : imageInfo.imgFolderGeneral + "ico_radio_n.png"
            fillMode: Image.TileHorizontally
            anchors.verticalCenter: parent.verticalCenter
            smooth: true
            visible: (opType=="radioBtn")
        }
    } // End MRadioButton

    //--------------------- Line Image #
    Image {
        id: imgLine
        y: opLineY
        height: opLineHeight
        source: opLineImg
    } // End Imgae

    // # Restart Timer # by WSH(121030)
    onPressed: { idMOptionMenuTimer.resetTimer() }

    // Updated jog_V1.3 (Close OptionMenu) # by WSH
    Keys.onPressed: {
        if(event.key == Qt.Key_Left)
        {
            if(menuDepth == "TwoDepth")
            {
                optionFinishForSubMenu();
            }else
            {
                hideMenu();
            }
        }else if(event.key == Qt.Key_Right)
        {
            if(opType == "subMenu")
            {
                idMOptionMenu.linkedCurrentIndex = index
                idOptionMenuDelegate.ListView.view.focus = true
                idOptionMenuDelegate.ListView.view.forceActiveFocus()
                opTypeEvent(index, opType)
            }
        }
    }
    
    // Updated jog_V1.3 (looping O) ------------------------------
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;

        //# Focus skip when Disable KEH (20130307)
        var i = 0, curIndex, totalCount;
        curIndex = idMOptionMenu.linkedCurrentIndex;
        totalCount = idOptionMenuDelegate.ListView.view.count-1;

        while(i != totalCount){
            if(curIndex <= 0){
                if(listOptionMenu.count > 8) curIndex = totalCount;
                else break;
            }
            else{ curIndex--; }
            if( getEnabled(curIndex) == true ){
                idMOptionMenu.linkedCurrentIndex = curIndex;
                break;
            }
            i++;
        }

    }
    onWheelRightKeyPressed: {
        //# Focus skip when Disable KEH (20130307)
        if(ListView.view.flicking || ListView.view.moving)   return;

        var i = 0, curIndex, totalCount;
        curIndex = idMOptionMenu.linkedCurrentIndex;
        totalCount = idOptionMenuDelegate.ListView.view.count-1;

        while(i != totalCount){
            if(curIndex >= totalCount){
                if(listOptionMenu.count > 8)
                    curIndex = 0;
                else break;
            }
            else{ curIndex++; }
            if( getEnabled(curIndex) == true )
            {
                idMOptionMenu.linkedCurrentIndex = curIndex;
                break;
            }
            i++;
        }

    }
} // End MButton
