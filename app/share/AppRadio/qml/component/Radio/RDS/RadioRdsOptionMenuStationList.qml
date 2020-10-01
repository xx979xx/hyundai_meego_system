/**
 * FileName: RadioRdsOptionMenuStationlist.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */
import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MOptionMenu{
    id: idRadioRdsOptionMenuStationList
    focus: true

    signal startRefreshTimer();

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }

    linkedModels: {
        if(globalSelectedBand == 0x01) idRadioRdsFmOptionMenuStationListModel
        else if(globalSelectedBand == 0x03) idRadioRdsMwOptionMenuStationListModel
    }

    //****************************** # Item Clicked #
    onMenu0Click: {        
        if(globalSelectedBand == 0x01){
            console.log(">>>>>>>>>>>>>  Now Broadcasting")
            gotoBackScreen()
            gotoBackScreen()
        }
        else if(globalSelectedBand == 0x03){
            console.log(">>>>>>>>>>>>>  Now Broadcasting")
            gotoBackScreen()
            gotoBackScreen()
        }
    } // End Click
    onMenu1Click: {        
        if(globalSelectedBand == 0x01){
            console.log(">>>>>>>>>>>>>  Sort by")
            setAppMainScreen( "AppRadioRdsOptionMenuSortBy" , true);
        }
        else if(globalSelectedBand == 0x03){
            console.log(">>>>>>>>>>>>>  Refresh")
            setAppMainScreen("PopupRadioRdsLoading" , false);
            QmlController.setRefresh();
//            startRefreshTimer();
        }
    } // End Click

    //****************************** # Menu Open when clicked I, L, Slash key #
    onClickMenuKey: menuAnimation = false;  // JSH 130418 added menuAnimation // gotoBackScreen()
//    onLeftKeyPressed: menuAnimation = false;  // JSH 130418 added menuAnimation // gotoBackScreen()

    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed:  menuAnimation = false;  // JSH 130418 added menuAnimation //gotoBackScreen()

    //****************************** # OptionMenu Timer #
    onOptionMenuFinished: {
        //KSW 131024 [ITS][195847][major] oneDepth menu closed before to do close twodepth menu.
//        console.log("KSW onOptionMenuFinished AppRadioRdsOptionMenuStationList == " ,idAppMain.state);
        if(idAppMain.state != "AppRadioRdsOptionMenuStationList")
            return;
        if(visible) menuAnimation = false;  // JSH 130418 added menuAnimation //gotoBackScreen()
    }
    // 20130428 added by qutiguy.
    //****************************** # init current/selected index = 0 (first item)#
    onVisibleChanged: {
        if(visible)
            idRadioRdsOptionMenuStationList.linkedCurrentIndex = 0;
    }
    //****************************** # Item Model #
    ListModel {
        id: idRadioRdsFmOptionMenuStationListModel
        ListElement { name: "Now Broadcasting"; opType: ""}
        ListElement { name: "Sort by"; opType: "subMenu"}
    }
    ListModel {
        id: idRadioRdsMwOptionMenuStationListModel
        ListElement { name: "Now Broadcasting"; opType: ""}
        ListElement { name: "Refresh"; opType: ""}
    }

    //****************************** # Translation #
    function setModelString(){
        if(globalSelectedBand != 0x03){
            idRadioRdsFmOptionMenuStationListModel.get(0).name = stringInfo.strRDSMenuNowBroadcasting;
            idRadioRdsFmOptionMenuStationListModel.get(1).name = stringInfo.strRDSMenuSortBy;
        }
        else if(globalSelectedBand == 0x03){
            idRadioRdsMwOptionMenuStationListModel.get(0).name = stringInfo.strRDSMenuNowBroadcasting;
            idRadioRdsMwOptionMenuStationListModel.get(1).name = stringInfo.strRDSMenuRefresh;
        }
    }
    Component.onCompleted: setModelString()
    onLinkedModelsChanged: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: {
            setModelString()
        }
    }
} // End MOptionMenu




