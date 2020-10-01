/**
 * FileName: DABStationListBand.qml
 * Author: DaeHyungE
 * Time: 2012-07-02
 *
 * - 2012-07-02 Initial Crated by HyungE
 */

import Qt 4.7
import "../../QML/DH" as MComp

MComp.MBand {
    id : idDabStationListBand

    titleText : stringInfo.strStation_StationList
    menuBtnFlag : true
    menuBtnText : stringInfo.strStation_Menu

    onMenuBtnPressAndHold: { idStationTimer.stop() }
    onMenuBtnClicked: {
        console.log("[QML] DABStationListBand.qml : onMenuBtnClicked")
        setAppMainScreen("DabStationListMainMenu", true);

        if(idDabStationListView.listCountZeroCheck() == true) idDabStationListBand.focus = true
        else idDabStationListView.focus = true
    }

    onBackBtnPressAndHold: { idStationTimer.stop(); }
    onBackBtnClicked: {
        console.log("[QML] DABStationListBand.qml : onBackBtnClicked")
        gotoBackScreen();
    }
    onActiveFocusChanged: {
        if(!idDabStationListBand.activeFocus) idDabStationListBand.giveForceFocus("menuBtn")
    }
}

