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

MButtonOnlyRadio {
    id: idMChListDelegate
    x: selectedApp=="HdRadio"? 43-29 : idAppMain.generalMirrorMode ? 45 : 43-33 ;
    y: 0 // 2 -> 0 JSH 130808 Modify
    z: index // JSH 140212 , preset save line error
    width: selectedApp=="HdRadio"? 462 : 557
    height: 88//89
    buttonName: index
    active: (buttonName == selectedItem)
    mEnabled:{
        if(idAppMain.presetEditEnabled){
            if(presetOrderHandler && !idMChListDelegate.ListView.view.isDragStarted)
                return true;
            else if(isDragItem)
                return true;
            else
                return false;

        }else
            return true;
    }
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

    property bool isDragItem: false
    property bool isJogItem: false
    property bool isMoveUpScroll: true
    property int  lastMousePositionY: 0
    signal changeRow(int fromIndex, int toIndex);

    property bool isSaveButtonFocus: focusImageVisibleOrPress //dg.jin 20140813 ITS 0245258 focuss issue for KH

    bgImage: ""
    bgImagePress: selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_p.png" : imgFolderRadio+"preset_p.png"
    //bgImageActive: (activeFocus && showFocus) ? "" : selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_s.png" : imgFolderRadio+"preset_s.png"
    bgImageFocusPress: selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_p.png" : imgFolderRadio+"preset_p.png" // JSH 130425 Modify
    bgImageFocus: selectedApp=="HdRadio"? imgFolderRadio_Hd+"bg_menu_tab_l_f.png" : imgFolderRadio+"preset_f.png"

    changedTextDisabledColor: true  // <<--------- Modified by dg.jin (140325 for kh)

    //****************************** # Index (FirstText) #
    firstText: mChListFirstText  //index+1
    firstTextX: idAppMain.generalMirrorMode ? 479 : 43-13-10
    firstTextY: 88-44 +4 // 88-44 , JSH 130619 Modify
    firstTextWidth: 13+49
    firstTextHeight: 40
    firstTextSize: 40
    firstTextStyle: systemInfo.hdb                            // JSH 130930 deleted //DH_PE
    //firstTextStyle: (active)&&(!idMChListDelegate.activeFocus) ? systemInfo.hdb : systemInfo.hdr // JSH 130930 //DH_PE
    firstTextAlies: "Center"
    firstTextColor: focusImageVisible ? colorInfo.brightGrey : colorInfo.dimmedGrey         // colorInfo.dimmedGrey => JSH 130404 [Edit firstText Color Bug Fixed]
    //dg.jin 20140929 ITS 248554 focuspresscolor change
    firstTextPressColor: focusImageVisible ? colorInfo.brightGrey : ((active)&&(!idMChListDelegate.activeFocus) ? "#7CBDFF" : colorInfo.brightGrey);    // colorInfo.dimmedGrey => JSH 130404 [Edit firstText Color Bug Fixed]
    firstTextFocusPressColor: colorInfo.brightGrey
    firstTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF"//idMChListDelegate.active? "#7CBDFF" : colorInfo.brightGrey  //RGB(124, 189, 255)
    firstTextFocusColor: colorInfo.brightGrey
    firstTextScrollEnable: false

    //****************************** # Channel (SecondText) #
    secondText: mChListSecondText //onMChListSecondTextChanged:secondText = mChListSecondText; , JSH 130510 modify
    secondTextX: idAppMain.generalMirrorMode ? 479 - (8+secondTextWidth) : 43-13-10+13+49+8;
    secondTextY: 88-44 +4 // 88-44 , JSH 130619 Modify
    //secondTextWidth: (!onlyPresetName) ? 116 : (presetSave) ? 248 : (presetOrderHandler) ? 269 : 304 //secondTextWidth: onlyPresetName ? 442 : 116 , JSH 130510 deleted
    secondTextWidth: selectedApp=="HdRadio" ? 180 - 43-13-10+13+49+8 : 116 //(presetSave) ? 248 : (presetOrderHandler) ? 269 : 304
    secondTextHeight: 40
    secondTextSize: 40
    //secondTextStyle: selectedApp=="HdRadio" ? systemInfo.hdr : systemInfo.hdb // JSH 130619 added
    secondTextStyle: (active)&&(!idMChListDelegate.activeFocus) ? systemInfo.hdb : systemInfo.hdr                // JSH 130930 added
    secondTextAlies: selectedApp=="HdRadio" ? "Left" : "Right" //secondTextAlies: onlyPresetName ? "Left" : "Right" , JSH 130510 modify
    secondTextElide: idAppMain.generalMirrorMode ? "Left" : "Right"
    secondTextScrollEnable: false//(buttonName == selectedItem)? true: false
    //secondTextScrollInterval: 150
    //secondTextScrollOnewayMode: false
    //secondTextColor: focusImageVisible ? colorInfo.brightGrey : colorInfo.commonGrey //KSW 140227 KH UX issue
    secondTextColor: colorInfo.brightGrey
    //dg.jin 20140929 ITS 248554 focuspresscolor change
    secondTextPressColor:  focusImageVisible ? colorInfo.brightGrey : ((active)&&(!idMChListDelegate.activeFocus) ? "#7CBDFF" : colorInfo.brightGrey);
    secondTextFocusPressColor:  colorInfo.brightGrey;
    secondTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF"//idMChListDelegate.active ? "#7CBDFF" : colorInfo.brightGrey    //RGB(124, 189, 255)
    secondTextFocusColor: colorInfo.brightGrey

    //****************************** # StationName (ThirdText) #
    onMChListThirdTextChanged:thirdText = mChListThirdText;                             // thirdText: mChListThirdText
    //thirdTextX: selectedApp=="HdRadio" ? 43-13-10+13+49+8+116 : idAppMain.generalMirrorMode ? 479 - (8+secondTextWidth+28+thirdTextWidth) :  43-13-10+13+49+8+116+28 // thirdTextX : 43-13-10+13+49+8+116+28 , JSH 130510 modify , JSH 130715
    thirdTextX: selectedApp=="HdRadio" ? 43-13+13+49+8+116-2 : idAppMain.generalMirrorMode ? 479 - (8+secondTextWidth+28+thirdTextWidth) :  43-13-10+13+49+8+116+28 // JSH 130715
    thirdTextY: 88-44 +4 // 88-44 , JSH 130619 Modify
    //thirdTextWidth: (presetSave == true)? 201 : ((presetOrderHandler == true) || (presetOrderHandler == true)) ? 222 : 304 , JSH 130510 deleted
    thirdTextWidth: { //JSH 130510 added
        if(selectedApp=="HdRadio"){
            if(presetSave)
                return 144;
            else if(presetOrderHandler)
                return 164;
            else
                return 184;
        }else{
            if(presetSave)
                return 201;
            else if(presetOrderHandler)
                return 222;
            else
                return 304;
        }
    }
    thirdTextHeight: 40
    thirdTextSize: 40
    //thirdTextStyle: systemInfo.hdb                            // JSH 130930 deleted
    thirdTextStyle: (active)&&(!idMChListDelegate.activeFocus) ? systemInfo.hdb : systemInfo.hdr // JSH 130930
    thirdTextAlies: idAppMain.generalMirrorMode ? "Right" : "Left"
    thirdTextElide: idAppMain.generalMirrorMode ? "Left" : "Right"
    thirdTextScrollEnable:{
        if(idAppMain.generalMirrorMode){
            return false;
        }
        else if(selectedApp !="HdRadio"){
          //dg.jin 20140822 ITS 0246233, 0246234 Scrll no stop for Touch and CCP press focusImageVisible -> focusImageVisibleOrPress
          if((focusImageVisibleOrPress && (!idAppMain.drsShow) && (!QmlController.searchState) && (QmlController.AppState != 0x01))
              ||(focusImageVisibleOrPress && idAppMain.drsShow && (!QmlController.searchState) && (QmlController.AppState != 0x01) && (QmlController.appDisplay == 0x01))) //dg.jin 20150915  0: FRONT 1: REAR 2: CLONE 0xFF:BG
              return true;
          else
             return false;
        }
        else{
            if(focusImageVisibleOrPress && (!idAppMain.drsShow) && (!QmlController.searchState) && (QmlController.AppState != 0x01))// && (thirdTextWidth == 184))
               return true;
            else
               return false;
        }
    }
    //thirdTextScrollInterval: 150
    //thirdTextScrollOnewayMode: false
    //thirdTextVisible: onlyPresetName? false : true
    //thirdTextColor: focusImageVisible ? colorInfo.brightGrey : colorInfo.commonGrey; //thirdTextColor: colorInfo.brightGrey; //dg.jin 140611 ITS 0239952 KH Text color error
    thirdTextColor: colorInfo.brightGrey
    //dg.jin 20140929 ITS 248554 focuspresscolor change
    thirdTextPressColor: focusImageVisible ? colorInfo.brightGrey : ((active)&&(!idMChListDelegate.activeFocus) ? "#7CBDFF" : colorInfo.brightGrey);
    thirdTextFocusPressColor: colorInfo.brightGrey;
    thirdTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF"//idMChListDelegate.active? "#7CBDFF" : colorInfo.brightGrey  //RGB(124, 189, 255)
    thirdTextFocusColor: colorInfo.brightGrey

    presetScan: active && idAppMain.menuPresetScanFlag

    //****************************** # HD Radio yellow icon image #
    Image{
        x: 411-13;
        y: 88-55-2; z: 1
        //width: 44; height: 24  // JSH 130715 deleted
        source: (selectedApp == "HdRadio") && (mChIconHdText.length > 0) ? imgFolderRadio_Hd+ "ico_hd_" + mChIconHdText + ".png" : ""    //"ico_hd.png" : "" , JSH 130715 modify
        //visible: (selectedApp == "HdRadio") && menuHdRadioFlag && iconHdText.text != "" && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))// JSH 130715
        visible: (selectedApp == "HdRadio") && menuHdRadioFlag && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))                           // JSH 130715
    }
    //////////////////////////////////////////////////////////
    // JSH 130715 deleted
    //    Text{
    //        id: iconHdText
    //        text: mChIconHdText
    //        x: 411-13;
    //        y: 88-55-2+12-20/2; z: 1
    //        width: 44; height: 20
    //        font.pixelSize: 20
    //        font.family: systemInfo.hdr//"HDR"
    //        horizontalAlignment: Text.AlignHCenter
    //        verticalAlignment: Text.AlignVCenter
    //        color: colorInfo.black
    //        visible: (selectedApp == "HdRadio") && menuHdRadioFlag && iconHdText.text!="" && (!(idAppMain.presetEditEnabled || idAppMain.presetSaveEnabled))
    //    }
    //////////////////////////////////////////////////////////

    //****************************** # Line Image #
    fgImage: selectedApp  == "HdRadio" ? imgFolderGeneral+"line_ch.png" : imgFolderGeneral+"line_menu_list.png" // JSH 130808 modify
    fgImageX: 43-10
    fgImageY: 92//91 //87 // JSH 130808  87 -> 91 ->92 Modify
    fgImageWidth:selectedApp  == "HdRadio" ? 398 : 493  // JSH 130808 modify
    fgImageHeight: 3

    //****************************** # Preset Save Button (121120)
    MButtonOnlyRadio{
        x: selectedApp  == "HdRadio" ? 43-10+63+248+4 : idAppMain.generalMirrorMode ? 43 : 43-10+201+201+4
        y: 10
        width: 105; height: 68
        bgImage: imgFolderRadio+"btn_save_n.png"
        bgImagePress: imgFolderRadio+"btn_save_p.png"
        visible: presetSave
        firstText: presetSaveText
        firstTextX: 0
        firstTextY: 34//-19
        firstTextWidth: 105
        firstTextHeight: 68
        firstTextSize: 24 //28 , JSH 131211 modify
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextPressColor: colorInfo.brightGrey
        onClickOrKeySelected: presetSaveClickOrKeySelected();
        onVisibleChanged: { // JSH 121121 , Text Update
//            if(selectedApp  == "HdRadio"){ // JSH 130329 Add
//                secondText = "";
//                secondText = mChListSecondText;
//            }else{
                thirdText = "";
                thirdText = mChListThirdText;
//            }
        }
    }

    //****************************** # Edit Preset Order (121120)
    Image {
        id:idDragIcon
        visible: presetOrderHandler && (isDragItem == false)
        x: selectedApp  == "HdRadio" ? 43-10+63+269+10 : idAppMain.generalMirrorMode ? 43 : 43-10+201+222+10 ;y: 31
        source: imageInfo.imgFolderRadio+"ico_handler.png"
    } // End Image

    Item{
        id: idArrowImage
        visible: presetOrderHandler && isDragItem
        Image{
            x: selectedApp  == "HdRadio" ? 43-10+63+269+10+7 : idAppMain.generalMirrorMode ? 43 : 43-10+201+222+10+7
            y: 15
            source: idMChListDelegate.ListView.view.curIndex == 0 ? imgFolderRadio+"ico_arrow_u_d.png" : imgFolderRadio+"ico_arrow_u_n.png"
        }
        Image{
            x: selectedApp  == "HdRadio" ? 43-10+63+269+10+7 : idAppMain.generalMirrorMode ? 43 : 43-10+201+222+10+7
            y: 15+30+4
            source: idMChListDelegate.ListView.view.curIndex == (idMChListDelegate.ListView.view.count-1)? imgFolderRadio+"ico_arrow_d_d.png" : imgFolderRadio+"ico_arrow_d_n.png"
        }
    } // End Item

    //****************************** # Item Click or Key Selected #
    onClickOrKeySelected: {
        //console.log("----------------------------------->> MChListDelegateOnlyRadio.qml onClickOrKeySelected",idMChListDelegate.ListView.view.currentIndex,index)
        selectedItem = index
        idMChListDelegate.ListView.view.currentIndex = index
        idMChListDelegate.ListView.view.focus = true
        idMChListDelegate.ListView.view.forceActiveFocus()
    }
    //onPressAndHold: selectedItem = index // JSH 130518 added

    //****************************** # Wheel in ListView #
    Keys.onReleased:{
        if(Qt.Key_Up == event.key){
            if(!idMChListDelegate.ListView.view.ccpAccelerate){
                jogFocusState  = "Band";
                event.accepted = true;

                //dg.jin 20150427 reorder preset item move change
                if(idAppMain.presetEditEnabled){
                    unlockListViewFocusChange()
                }
            }
        }
        idMChListDelegate.ListView.view.ccpAccelerate = false;

        idAppMain.downKeyLongPressedVisualCueFocus = false; //dg.jin 140530 Down Key Long Pressed VisualCueFocus
    }
    Keys.onPressed: {
        //var local_HdMenuInfo  = 0;  // HD // JSH 130621 Info Window Delete
        var local_HdOnOff     = 0;  // HD

        if(QmlController.getRadioType() == 1){            // HD Radio
            //local_HdMenuInfo    = idAppMain.menuInfoFlag // HD // JSH 130621 Info Window Delete
            local_HdOnOff       = idAppMain.hdRadioOnOff
        }

        if (Qt.Key_Right == event.key && (!idAppMain.generalMirrorMode)){
            console.log("======================> Qt.Key_Right UP Index = ", QmlController.radioBand,idMChListDelegate.ListView.view.currentIndex , index)
            if((!idAppMain.presetSaveEnabled) && (!idAppMain.presetEditEnabled)){
                if (!local_HdOnOff)
                    jogFocusState = "FrequencyDial"
                else if (local_HdOnOff)
                    jogFocusState = "HDDisplay"

                //if (local_HdMenuInfo) // HD // JSH 130621 Info Window Delete
                //    idRadioHdMain.changeInfoState(2,false);//jogFocusState = "PresetList" => JSH 130402 Modify
            }
            event.accepted = true;
            return;
        }
        else if(Qt.Key_Left == event.key && idAppMain.generalMirrorMode){
            console.log("======================> Qt.Key_Left UP Index = ", QmlController.radioBand,idMChListDelegate.ListView.view.currentIndex , index)
            if((!idAppMain.presetSaveEnabled) && (!idAppMain.presetEditEnabled)){
                if (!local_HdOnOff)
                    jogFocusState = "FrequencyDial"
                else if (local_HdOnOff)
                    jogFocusState = "HDDisplay"
            }
            event.accepted = true;
            return;
        }
        else if(idAppMain.isWheelLeft(event) || (Qt.Key_Up == event.key)){
            console.log("======================> isWheelLeft or Qt.Key_Up Index = ", QmlController.radioBand,idMChListDelegate.ListView.view.currentIndex , index)
            idAppMain.isJogMode(event, false); // JSH 130624

            if(Qt.Key_Up == event.key){
                //jogFocusState   = "Band"
                event.accepted  = true;
                return;
            }
            else{
                //if(idMChListDelegate.ListView.view.flicking || idMChListDelegate.ListView.view.moving)   return; // JSH 131107 , 131123 deleted [smoktest error]
                if(idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled){
//                    if( idMChListDelegate.ListView.view.currentIndex){
//                        idMChListDelegate.ListView.view.decrementCurrentIndex();
//                    }
//                    else{
//                        idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.count-1, ListView.Visible);
//                        idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.count-1;
//                    }

                    if(isDragItem) //Drag Mode
                    {
                        if(idChListView.curIndex > 0)
                        {
                            idMChListDelegate.ListView.view.curIndex--;
                            // ITS 0258520 20150225 dg.jin Reorder preset page move change
                            //if(idMChListDelegate.ListView.view.curIndex*height+2 < idMChListDelegate.ListView.view.contentY+height)
                            //    idMChListDelegate.ListView.view.contentY = idMChListDelegate.ListView.view.curIndex*height
                            if(idMChListDelegate.ListView.view.curIndex*height+2 < idMChListDelegate.ListView.view.contentY)
                                idMChListDelegate.ListView.view.contentY = 0

                            idMChListDelegate.ListView.view.itemMoved(0,0);
                        } // End if
                    }
                    else //Jog Mode
                    {
                        if( idMChListDelegate.ListView.view.currentIndex )
                        {
                            idMChListDelegate.ListView.view.decrementCurrentIndex();

                            //if(idAppMain.presetSaveEnabled) // JSH 130725 ITS[0181634] Issue
                                changeListViewPosition(idMChListDelegate.ListView.view.currentIndex);
                        }
                        else
                        {
                            idMChListDelegate.ListView.view.positionViewAtIndex(idMChListDelegate.ListView.view.count-1, idMChListDelegate.ListView.view.Visible);
                            idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.count-1;
                        } // End if
                    } // End if
                    return;
                }
                else{
                    if(idMChListDelegate.ListView.view.flicking)   return; // JSH 131123

                    var selectedIndex = 0;
                    if(globalSelectedBand=="FM1")
                        selectedIndex = QmlController.getPresetIndexFM1()-1
                    if(globalSelectedBand=="FM2")
                        selectedIndex = QmlController.getPresetIndexFM2()-1
                    else if(globalSelectedBand=="AM")
                        selectedIndex = QmlController.getPresetIndexAM()-1

                    if(selectedIndex != (index+1)){
                        QmlController.setPresetIndex(QmlController.radioBand,index+1);
                        QmlController.changeChannel(0x00);
                    }
                    else
                        idMChListDelegate.ListView.view.decrementCurrentIndex();  // focus Image Moved
                }
            }
        }
        else if(idAppMain.isWheelRight(event) || (Qt.Key_Down == event.key)) {
            console.log("======================> isWheelRight or Qt.Key_Down Index = ", QmlController.radioBand,idMChListDelegate.ListView.view.currentIndex , index)
            idAppMain.isJogMode(event, false); // JSH 130624

            idAppMain.downKeyLongPressedVisualCueFocus = false; //dg.jin 140530 Down Key Long Pressed VisualCueFocus

            if(Qt.Key_Down == event.key){
                event.accepted = true;
                return;
            }
            else{
//                if(idMChListDelegate.ListView.view.flicking || idMChListDelegate.ListView.view.moving)   return; // JSH 131107 , 131123 deleted [smoktest error]
                if(idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled){
//                    if((idMChListDelegate.ListView.view.count-1 != idMChListDelegate.ListView.view.currentIndex)){
//                        idMChListDelegate.ListView.view.incrementCurrentIndex();
//                    }
//                    else{
//                        idMChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
//                        idMChListDelegate.ListView.view.currentIndex = 0;
//                    }

                    if(isDragItem) //Drag Mode
                    {
                        if(idMChListDelegate.ListView.view.curIndex < (idMChListDelegate.ListView.view.count-1))
                        {
                            idMChListDelegate.ListView.view.curIndex++;
                            // ITS 0258520 20150225 dg.jin Reorder preset page move change
                            //if(idMChListDelegate.ListView.view.curIndex*height+height > idMChListDelegate.ListView.view.contentY+idMChListDelegate.ListView.view.height)
                            //    idMChListDelegate.ListView.view.contentY = (idMChListDelegate.ListView.view.curIndex*height+height)-idMChListDelegate.ListView.view.height;
                            if(idMChListDelegate.ListView.view.curIndex*height+height > idMChListDelegate.ListView.view.contentY+idMChListDelegate.ListView.view.height)
                                idMChListDelegate.ListView.view.contentY = (idMChListDelegate.ListView.view.count*height)-idMChListDelegate.ListView.view.height;
                            idMChListDelegate.ListView.view.itemMoved(0,0);
                        } // End if
                    }
                    else //Jog Mode
                    {
                        if( idMChListDelegate.ListView.view.count-1 != idMChListDelegate.ListView.view.currentIndex )
                        {
                            idMChListDelegate.ListView.view.incrementCurrentIndex();

                            //if(idAppMain.presetSaveEnabled) // JSH 130725 ITS[0181634] Issue
                                changeListViewPosition(idMChListDelegate.ListView.view.currentIndex);
                        }
                        else
                        {
                            idMChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                            idMChListDelegate.ListView.view.currentIndex = 0;
                        } // End if
                    } // End if
                    return;
                }else{
                    if(idMChListDelegate.ListView.view.flicking)   return; // JSH 131123

                    var selectedIndex = 0;
                    if(globalSelectedBand=="FM1")
                        selectedIndex = QmlController.getPresetIndexFM1()-1
                    if(globalSelectedBand=="FM2")
                        selectedIndex = QmlController.getPresetIndexFM2()-1
                    else if(globalSelectedBand=="AM")
                        selectedIndex = QmlController.getPresetIndexAM()-1

                    if(selectedIndex != (index+1)){
                        QmlController.setPresetIndex(QmlController.radioBand,index+1);
                        QmlController.changeChannel(0x01);                         // JSH 121030
                    }
                    else
                        idMChListDelegate.ListView.view.incrementCurrentIndex();
                }
            }
        }
    }

    function move()
    {
        var contentHeight = idMChListDelegate.ListView.view.count * height;
        if(isMoveUpScroll)
        {
            if(idMChListDelegate.ListView.view.contentY <= (88/2))
            {
                idMChListDelegate.ListView.view.contentY = 0;
                moveTimer.running =false;
            }
            else
                idMChListDelegate.ListView.view.contentY -= (88/2);
            checkOnScrollMoved();
        }else
        {
            if(idMChListDelegate.ListView.view.contentY >= contentHeight - idMChListDelegate.ListView.view.height - (88/2))
            {
                idMChListDelegate.ListView.view.contentY = contentHeight - idMChListDelegate.ListView.view.height;
                moveTimer.running = false;
            }
            else
                idMChListDelegate.ListView.view.contentY += (88/2);
            checkOnScrollMoved();
        }
    } // End function

    function lockListView(){
        idMChListDelegate.ListView.view.currentIndex = index
        idMChListDelegate.ListView.view.interactive = false;   // Cant't move list
        idMChListDelegate.ListView.view.insertedIndex = index; // Save slected index
        idMChListDelegate.ListView.view.curIndex = index;
        idMChListDelegate.ListView.view.isDragStarted = true;
        z = z+1;
    } // End function

    function unlockListView(){
        idMChListDelegate.ListView.view.isDragStarted = false;
        idMChListDelegate.ListView.view.interactive = true;
        idMChListDelegate.ListView.view.itemInitWidth();
        idMChListDelegate.ListView.view.currentIndex = idMChListDelegate.ListView.view.curIndex;
        idMChListDelegate.ListView.view.curIndex = -1;
        idMChListDelegate.ListView.view.insertedIndex = -1;
        idMChListDelegate.ListView.view.forceActiveFocus();
        z = z-1;
    } // End function

    //dg.jin 20150427 reorder preset item move change
    function unlockListViewFocusChange(){
        if(!presetOrderHandler) { // JSH 140108 modify
            if(!idMChListDelegate.ListView.view.interactive)
                idMChListDelegate.ListView.view.interactive = true;
        }
        else if(isDragItem)
        {
            var contentYBackup = idMChListDelegate.ListView.view.contentY;
            moveTimer.running = false;
            isDragItem = false;
            setPresetListIndex();
            changeRow(idMChListDelegate.ListView.view.insertedIndex, idMChListDelegate.ListView.view.curIndex);
            unlockListView();
            idMChListDelegate.ListView.view.contentY = contentYBackup;
            changeListViewPosition(idMChListDelegate.ListView.view.currentIndex); // JSH 130506 added display update
            idAppMain.initMode(); //20141020 dg.jin reorderpreset ccplongpressed -> ccprelease
        }
    }

    function checkOnScrollMoved(){
        ////////////////////////////////////////////////////////////////////////////////
        // JSH 140213  Fixed to no.1 swaying during the preset reorder
        // if((idMChListDelegate.ListView.view.contentY + lastMousePositionY)/height != idMChListDelegate.ListView.view.curIndex)
        // {
        //      if((idMChListDelegate.ListView.view.contentY + lastMousePositionY)/height >= 0 && (idMChListDelegate.ListView.view.contentY + lastMousePositionY)/height < (idMChListDelegate.ListView.view.count-1))
        //      {
        //          idMChListDelegate.ListView.view.curIndex = (idMChListDelegate.ListView.view.contentY + lastMousePositionY)/height;
        //          idMChListDelegate.ListView.view.itemMoved(0,0);
        //      }
        // }
        var bIndex = parseInt((idMChListDelegate.ListView.view.contentY + lastMousePositionY)/height)
        if(bIndex != idMChListDelegate.ListView.view.curIndex)
        {
            if( bIndex >= 0 && bIndex < idMChListDelegate.ListView.view.count)
            {
                idMChListDelegate.ListView.view.curIndex = bIndex;
                idMChListDelegate.ListView.view.itemMoved(0,0);
            }
        }
        ////////////////////////////////////////////////////////////////////////////////
    } // End function
    function setPresetListIndex()
    {
        //console.log("blacktip::===============1 "+idChListView.backupIndex+":"+idMChListDelegate.ListView.view.insertedIndex+":"+idMChListDelegate.ListView.view.curIndex+":"+index)
        if( idChListView.backupIndex < idMChListDelegate.ListView.view.insertedIndex && idChListView.backupIndex < idMChListDelegate.ListView.view.curIndex)
        {
        }else if(idChListView.backupIndex > idMChListDelegate.ListView.view.insertedIndex && idChListView.backupIndex > idMChListDelegate.ListView.view.curIndex)
        {
        }else if(idChListView.backupIndex > idMChListDelegate.ListView.view.insertedIndex && idChListView.backupIndex <= idMChListDelegate.ListView.view.curIndex)
        {
            idChListView.backupIndex = idChListView.backupIndex - 1;
        }else if(idChListView.backupIndex < idMChListDelegate.ListView.view.insertedIndex && idChListView.backupIndex >= idMChListDelegate.ListView.view.curIndex)
        {
            idChListView.backupIndex = idChListView.backupIndex + 1;
        }else if(index == idMChListDelegate.ListView.view.insertedIndex)
        {
            idChListView.backupIndex = idMChListDelegate.ListView.view.curIndex;
        }
        //console.log("blacktip::=============== 2 "+idChListView.backupIndex+":"+idMChListDelegate.ListView.view.insertedIndex+":"+idMChListDelegate.ListView.view.curIndex+":"+index)
    } // End function

    //dg.jin [20140310] [KH]ISV 98064
    //Connections{ //JSH 131016 , language change bug
    //    target: UIListener
    //    onRetranslateUi: {
    //        if(UIListener.GetCountryVariantFromQML() == 0 && (idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled)){
    //            idAppMain.presetSaveEnabled = false;
    //            idAppMain.presetEditEnabled = false;
    //        }
    //    }
    //}

    //dg.jin 20150427 reorder preset item move change
    Connections {
        target: UIListener
        onSignalShowSystemPopup: {
            if(idAppMain.presetEditEnabled){
                unlockListViewFocusChange()
            }
        }
    }

    Connections {
        target: idChListView
        onItemInitWidth: {
            isDragItem = false;
            if(height*index > 0)
                y = height*index;
            else y = 0;
       }
        onItemMoved: {
            if(index < idMChListDelegate.ListView.view.insertedIndex && index < idMChListDelegate.ListView.view.curIndex)
            {
                y = height*index;
            }else if(index > idMChListDelegate.ListView.view.insertedIndex && index > idMChListDelegate.ListView.view.curIndex)
            {
                y = height*index;
            }else if(index > idMChListDelegate.ListView.view.insertedIndex && index <= idMChListDelegate.ListView.view.curIndex)
            {
                y = height*index - height;
            }else if(index < idMChListDelegate.ListView.view.insertedIndex && index >= idMChListDelegate.ListView.view.curIndex)
            {
                y = height*index + height;
            }else if(index == idMChListDelegate.ListView.view.insertedIndex)
            {
                y = height*idMChListDelegate.ListView.view.curIndex
            }
        }
    }
    onChangeRow: {
        console.log("########################### onChangeRow : ListView ###########################",fromIndex, toIndex)
        QmlController.changePresetOrder(fromIndex, toIndex); // MODEL UPDATE
        QmlController.presetModelReplace(fromIndex, toIndex);// MODEL NUM UPDATE AND MICOM SEND
    } // End onChangeRow
}
