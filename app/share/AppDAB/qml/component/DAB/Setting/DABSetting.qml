/**
 * FileName: DABSetting.qml
 * Author: HYANG
 * Time: 2013-01-15
 *
 * - 2013-01-15 Initial Created by HYANG
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent{
    id: idDabSetting
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true
    objectName: "DABSetting"

    property string selectedSettingScreen: "DabSetting_SlideShow"
    property int settingViewAreaX: 585

    property int selectedIndex                  : 0
    property bool checkSlideShowActive          : false
    property bool checkServiceFollowingActive   : false
    property bool checkAudioDynamicActive       : false

    property string settingFocusPosition: "SettingMenu"  //# "SettingMenu" or "SettingContents"  (121227)  

    Component.onCompleted : {
        console.log("[QML] DABSetting.qml - onCompleted - state : " + idDabSetting.state )
        MDabOperation.setSettingScreenChanges(selectedSettingScreen);
    }

    //#****************************** Background Image
    Image {
        id: idSettingBg
        y: 0//-systemInfo.statusBarHeight
        source: imageInfo.imgBg_Main
    }

    //#****************************** Left/Right Background Image
    Image {
        x: 0; y: 166 - systemInfo.statusBarHeight
        source: settingFocusPosition == "SettingMenu" ? imageInfo.imgBgMenu_L : ""
    }

    Image {
        y: 166 - systemInfo.statusBarHeight
        source: settingFocusPosition == "SettingContents" ? imageInfo.imgBgMenu_R : ""
    }

    //#****************************** Band
    DABSettingBand {
        id: idDabSettingBand
        KeyNavigation.down: focusMovefromBand()
        x: 0; y: 0;
        width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight;
    }

    function focusMovefromBand(){
        if(settingFocusPosition == "SettingMenu"){
            if(idDabSettingsMenu.selectedIndex == 2)
                return idDabSettingContents
            else
                return idDabSettingsMenu;
        }
        else{
            return idDabSettingContents
        }
    }

    //#****************************** Contents (Right)
    FocusScope {
        id: idDabSettingContents
        KeyNavigation.up: idDabSettingBand
        KeyNavigation.left: idDabSettingsMenu
        x: settingViewAreaX; y: systemInfo.titleAreaHeight;
        width: 695; height: 554;

        Loader { id: idDabSetting_SlideShow; }        
        Loader { id: idDabSetting_ServiceFollowing; }

        onActiveFocusChanged: {
            if(idDabSettingContents.activeFocus) settingFocusPosition = "SettingContents"
        }
    }

    //#****************************** Left/Right Background Image
    Image {
        id: idSettingLeftBgImg
        x: 0; y: 166 - systemInfo.statusBarHeight
        source: settingFocusPosition == "SettingMenu" ? imageInfo.imgBgMenu_L_S : ""
    }

    Image {
        id: idSettingRightBgImg
        x: settingViewAreaX; y: 166 - systemInfo.statusBarHeight
        source: settingFocusPosition == "SettingContents" ? imageInfo.imgBgMenu_R_S : ""
    }

    //#****************************** Menu (Left)
    DABSettingMenu{
        id: idDabSettingsMenu
        x: 0; y: systemInfo.titleAreaHeight;
        width: 695; height: 554
        focus: true
        KeyNavigation.right: (idDabSettingsMenu.selectedIndex == 2) ? idDabSettingContents : idDabSettingsMenu
        KeyNavigation.up: idDabSettingBand
        onActiveFocusChanged: { //# bgImage(Left) for On/Off (121227)
            console.log("[QML] DABSetting.qml : idDabSettingsMenu : onActiveFocusChanged")
            if(idDabSettingsMenu.activeFocus) settingFocusPosition = "SettingMenu"
        }
    }

    MComp.MVisualCue{
        id: idMVisualCue
        x: 560; y: 358-systemInfo.statusBarHeight
        arrowUpFlag : idDabSettingBand.activeFocus ? false : true
        arrowDownFlag : idDabSettingBand.activeFocus ? true : false
        arrowLeftFlag : (idDabSettingContents.activeFocus) ? true : false
        arrowRightFlag : (idDabSettingsMenu.activeFocus) && (idDabSettingsMenu.selectedIndex == 2) ? true : false
    }

    function checkEnterKeyNavigation()    {
        console.log("[QML]  DABSetting.qml : checkEnterKeyNavigation() : idDabSettingsMenu.selectedIndex : " + idDabSettingsMenu.selectedIndex)
        if((idDabSettingsMenu.selectedIndex == 2)) {
            idDabSettingContents.focus = true
        }
    }

    //#****************************** (HardKey) Back Button
    onBackKeyPressed: {
        console.log("[QML] DABSetting.qml : onBackKeyPressed ");
        MDabOperation.settingSaveData();
    }
}
