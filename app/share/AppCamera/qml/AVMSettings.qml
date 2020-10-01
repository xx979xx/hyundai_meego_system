import QtQuick 1.1

import QmlStatusBar 1.0

import "system" as MSystem
import "component" as MComp
import "system/operation.js" as MOp

MComp.MComponent{
    id: idAVMSettingMain
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true
    enableClick: false;

    MSystem.ColorInfo { id: colorInfo }
    MSystem.SystemInfo { id: systemInfo }
    MSystem.StringInfo {id:stringInfo}
    property alias backFocus: idModeArea.backKeyButton
    property int selectedItem: 0

    function setRightMenuScreen(index, save) {
        MOp.setRightMain(index, save)
    }

    function changeRightMenuFocus(index) {
        idAVMSettingLeftList.enableQuickScroll = false;
        MOp.setRightMainFocus(index);
    }

    Component.onCompleted:{
        setRightMenuScreen(0, true);
        idAVMSettingLeftList.forceActiveFocus();
        idAVMSettingLeftList.enableQuickScroll = true;
        //For AutoTest
        UIListener.SendAutoTestSignal();
    }

    Image {
        id: bgImg
        x: 0; y:0
        width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
        source: systemInfo.imageInternal+"bg_main.png"
    }

    //New StatusBar Test
    QmlStatusBar {
        id: statusBar
        x:0; y:0
        width: systemInfo.lcdWidth; height: systemInfo.statusBarHeight
        homeType: "none"
        middleEast: (cppToqml.IsArab)? true : false
    }

    MComp.MBand {
        id: idModeArea
        x: 0; y: systemInfo.statusBarHeight
        titleText: stringInfo.setModeAreaTxt
        focus: false

        onBackKeyClicked: {
            mainViewState="AVMMain"
            idMainView.forceActiveFocus()
            setMainAppScreen("", false)
            MOp.setAVMMainFocus(false)
        }

        Keys.onDownPressed: {
            idAVMSettingRightMenu.forceActiveFocus();
            selectedMenuForceFocus(idAVMSettingLeftList.selectedIndex);
            idVisualCue.arrowMode = (cppToqml.IsArab)? 1 : 2;
        }


        onActiveFocusChanged:
        {
            if (activeFocus) {
                idVisualCue.arrowMode = 0;
            }
            else {
                idVisualCue.arrowMode = (cppToqml.IsArab)? 2 : 1;
            }
        }

    }

    Image {
        width:1280; height: 554
        x:0; y:166
        source: {
            if (cppToqml.IsArab) {
                if (idAVMSettingRightMenu.activeFocus) systemInfo.imageInternal+"bg_menu_r_rev.png"
                else systemInfo.imageInternal+"bg_menu_l_rev.png"
            }
            else {
                if (idAVMSettingRightMenu.activeFocus) systemInfo.imageInternal+"bg_menu_r.png"
                else systemInfo.imageInternal+"bg_menu_l.png"
            }
        }
    }

    Image{
        id: leftOutLayer
        width: 667; height: 554
        x:(cppToqml.IsArab)? (idAVMSettingMain.width-width-2) : 0
        y:(cppToqml.IsArab)? 70+systemInfo.statusBarHeight : 73+systemInfo.statusBarHeight
        visible: (rightOutLayer.visible)? false : true
        source: (cppToqml.IsArab)? systemInfo.imageInternal+"bg_menu_l_s_rev.png" :  systemInfo.imageInternal+"bg_menu_l_s.png"
    }

    Image{
        id: rightOutLayer
        width: 691; height: 554
        x:(cppToqml.IsArab)? 0 : 585+3
        y:(cppToqml.IsArab)? 70+systemInfo.statusBarHeight : 73+systemInfo.statusBarHeight
        visible: (idAVMSettingRightMenu.activeFocus)? true : false
        source: (cppToqml.IsArab)? systemInfo.imageInternal+"bg_menu_r_s_rev.png" :  systemInfo.imageInternal+"bg_menu_r_s.png"
    }

    MComp.MVisualCue{
        id: idVisualCue
        y:264+systemInfo.statusBarHeight
        x:565
        arrowMode: (cppToqml.IsArab)? 2 : 1;
    }

    MComp.AVMSetting_LeftMenuList{
        id:idAVMSettingLeftList
        y:(cppToqml.IsArab)? 79+systemInfo.statusBarHeight : 79+systemInfo.statusBarHeight
        x:(cppToqml.IsArab)? (idAVMSettingMain.width-34-width) : 34
        z:2
        focus:true
        width: 537; height:529

//        Keys.onRightPressed:{
//            if (!cppToqml.IsArab) {
//                selectedMenuForceFocus(selectedIndex)
//                idVisualCue.arrowMode = 2;
//            }
//        }

//        Keys.onLeftPressed:{
//            if (cppToqml.IsArab) {
//                selectedMenuForceFocus(selectedIndex)
//                idVisualCue.arrowMode = 1;
//            }
//        }

        KeyNavigation.up: {
            backFocus.forceActiveFocus();
            idAVMSettingLeftList.enableQuickScroll = false;
            idModeArea
        }

        onActiveFocusChanged: {
            if (activeFocus) {
                if (cppToqml.IsArab) {
                    idVisualCue.arrowMode = 2;
                }
                else {
                    idVisualCue.arrowMode = 1;
                }
            }
        }
    }

    MComp.MComponent{
        id:idAVMSettingRightMenu
        x:(cppToqml.IsArab)? 40 : 708
        y:(cppToqml.IsArab)? 81+systemInfo.statusBarHeight : 81+systemInfo.statusBarHeight
        z:2
        width: 538 // 542//572
        enableClick: false;
        height:systemInfo.lcdHeight-systemInfo.bandHeight

        Loader  { id: idGeneralLoader}
        Loader  { id: idInitFrontViewLoader}
        Loader  { id: idInitRearViewLoader}

        Keys.onLeftPressed:{
            if (!cppToqml.IsArab) {
                idAVMSettingLeftList.focus = true
                idAVMSettingLeftList.forceActiveFocus()
                idVisualCue.arrowMode = 1;
                idAVMSettingLeftList.enableQuickScroll = true;
            }
        }

        Keys.onRightPressed:{
            if (cppToqml.IsArab) {
                idAVMSettingLeftList.focus = true
                idAVMSettingLeftList.forceActiveFocus()
                idVisualCue.arrowMode = 2;
                idAVMSettingLeftList.enableQuickScroll = true;
            }
        }

        onActiveFocusChanged: {
            if (activeFocus) {
                idAVMSettingLeftList.enableQuickScroll = false;
                if (cppToqml.IsArab) {
                    idVisualCue.arrowMode = 1;
                }
                else {
                    idVisualCue.arrowMode = 2;
                }
            }
        }

    }

    function selectedMenuForceFocus(sIndex) {
        idAVMSettingLeftList.enableQuickScroll = false;
        switch (sIndex) {
        case 0:
            idGeneralLoader.forceActiveFocus();
            break;
        case 1:
            idInitFrontViewLoader.forceActiveFocus();
            break;
        case 2:
            idInitRearViewLoader.forceActiveFocus();
            break;
        }

    }

    //scroll
//    Image
//    {
//       y:92
//       x: 588
//       source: systemInfo.imgFolderGeneral + "scroll_menu_bg.png"
//       visible: true
//       Item
//       {
//           height: idAVMSettingLeftList.menuList.visibleArea.heightRatio * 350
//           y:350 * idAVMSettingLeftList.menuList.visibleArea.yPosition
//           visible:true
//          Image
//          {
//             y: -parent.y
//             source: systemInfo.imgFolderGeneral + "scroll_menu.png"
//          }
//          width: parent.width
//          clip: true
//       }
//    }


}
