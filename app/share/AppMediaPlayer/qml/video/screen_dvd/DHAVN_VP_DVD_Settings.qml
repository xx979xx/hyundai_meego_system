// { modified by Sergey 19.07.2013. Removed Divx part.
import Qt 4.7
import QtQuick 1.1
import AppEngineQMLConstants 1.0
import Qt.labs.gestures 2.0

import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../DHAVN_VP_RESOURCES.js" as RES
import "../components"

DHAVN_VP_FocusedItem
{
    id: main

    width: CONST.const_SCREEN_WIDTH
    height: CONST.const_SCREEN_HEIGHT
    LayoutMirroring.enabled: east
    LayoutMirroring.childrenInherit: east

    name: "DVD_Settings"
    default_x: east ? 1 : 0
    default_y: 0
    focus_visible: true

    property bool isLeftFocused: true
    property bool east: EngineListenerMain.middleEast
    property alias settingsMenuFrame: menuFrame

    //added by shkim for ITS 185028
    // { commented by yungi 2013.08.05 for 4-arrow display error
    onVisibleChanged:
    {
        EngineListenerMain.qmlLog("DVD_Setting_onVisibleChanged  TempMode : " +VideoEngine.isVideoTempMode()) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
        if (main.visible)
        {
            if(VideoEngine.isVideoTempMode()==false) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
            {
                default_x = east ? 1 : 0 // added by cychoi 2014.03.19 for ITS 230078
                main.setDefaultFocus(UIListenerEnum.JOG_DOWN)
                main.showFocus() // added by cychoi 2013.06.11 for default focus
                //{ added by kssanh 2013.07.03 for ITS 177614
                radioList.hideFocus()
                radioList_NonCaption.hideFocus()
                //removed by Sergey 08.09.2013 for ITS#188248
                //menuFrame.state = "left"
                //} added by kssanh 2013.07.03
            }
        }
    }
    // } commented by yungi 2013.08.05

    //{ modified by yongkyun.lee 2013-07-09 for : ITS 179039
    onIsLeftFocusedChanged:
    {
        if (!isLeftFocused)
        {
            if(radioList.visible)
                radioList.item.focusIndex( )
            else
            {
                radioList_NonCaption.item.checkIndex = false // added by yungi 2013.11.18 for ITS 209719
                radioList_NonCaption.item.focusIndex( )
            }
        }
    }
    //} modified by yongkyun.lee 2013-07-09 

    onEastChanged: cueStateUpdate() // added by yungi 2013.12.07 for ITS 213009



    // ========================================= Functions ================================================

    function resetMenuContent(item)
    {
        EngineListenerMain.qmlLog("AppMediaPlayer resetMenuContent item:", item)
        if(item == 0)
        {
            radioList.visible = true
            radioList_NonCaption.visible = false
            radioList.item.setRadioSelected() // modified by cychoi 2013.06.24 for new DVD Settings UX // added by cychoi 2013.06.16 for selected index from setting value
        }
        else if (item == 3)
        {
            radioList.visible = false
            radioList_NonCaption.visible = false
        }
        else
        {
            radioList.visible = false
            radioList_NonCaption.visible = true
            radioList_NonCaption.item.setRadioSelected() // removed semicolon by cychoi 2013.06.23 // added by cychoi 2013.06.10 for ITS 171121 DVD Setting
        }
    }

    function isRightAreaNotFocused()
    {
        EngineListenerMain.qmlLog("[MP][VP][QML] DVD_Settings::isRightAreaNotFocused");

        if((radioList.status == Loader.Ready && radioList.item.focus_visible)
                || (radioList_NonCaption.status == Loader.Ready && radioList_NonCaption.item.focus_visible)) // modified by ravikanth 21-03-13
        {
            return false
        }

        return true
    }

    function cueStateUpdate()
    {
        if((radioList.focus_visible || radioList_NonCaption.focus_visible) || menu.focus_visible)
        {
            if(radioList.focus_visible || radioList_NonCaption.focus_visible)
            {
                menuFrame.state = "right"
                menuFrame.cueState = east ? "uprightActive" : "upleftActive" // modified by yungi 2013.12.05 for ITS 211269
            }
            else
            {
                menuFrame.state = "left"
                menuFrame.cueState = east ? "upleftActive" : "uprightActive" // modified by yungi 2013.12.05 for ITS 211269
            }
            default_x = east ? 1 : 0 // modified by oseong.kwon 2014.06.26 for ITS 241442 // added by cychoi 2014.03.19 for ITS 230078
        }
        // { commented by oseong.kwon 2014.06.26 for ITS 241442 // { commented by cychoi 2014.03.19 for ITS 230078
        //else
        //{
            //menuFrame.state = "left"
        //    menuFrame.cueState = "downActive" // modified by oseong.kwon 2014.04.10 for ITS 234294 
        //}
        // } commented by oseong.kwon 2014.06.26 // } commented by cychoi 2014.03.19
    }

    // ========================================= Sub elements ================================================

    GestureArea
    {
        anchors.fill: parent
        Tap
        {
            onStarted: controller.onMousePressed();
        }
    }


    Image
    {
        id: mainBg
        source: RES.const_URL_DVD_SETTINGS_BG
    }

    // { commented by yungi 2013.08.05 for 4-arrow display error
    //{ added by yongkyun.lee 20130612 for : ITS 172810
    // } commented by yungi 2013.08.05

    DHAVN_VP_CueBg
    {
        id: menuFrame


        // { modified by yungi 2013.08.05 for 4-arrow display error
        //{ added by yongkyun.lee 20130612 for : ITS 172810
        //z: main.z + 1
        anchors.top: parent.top
        anchors.bottom: main.bottom
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        //anchors.top: parent.top
        //anchors.bottom: main.bottom
        //anchors.topMargin: CONST.const_CENTER_AREA_4ARROW_TOP_OFFSET
        z: main.z + 3
        //anchors.top: main.top
        anchors.left: main.left
        anchors.right: main.right
        //} added by yongkyun.lee 20130612 
        // } modified by yungi 2013.08.05

        bVertical: true
        sVertArrow: main.focus_visible ? "up" : "down"
        east: main.east
        currentFocusIndex : 0 // added by cychoi 2014.12.22 for visual cue animation on quick scroll

        //{ added by yongkyun.lee 20130612 for : ITS 172810
        // Connections { target: menu; onFocus_visibleChanged: if(focus_visible) menuFrame.state = "left" }
        // Connections { target: radioList; onFocus_visibleChanged: if(focus_visible) menuFrame.state = "right" }
        // Connections { target: radioList_NonCaption; onFocus_visibleChanged: if(focus_visible) menuFrame.state = "right" }
        Connections 
        { 
            // { modified by cychoi 2013.07.04 for ITS 178107
            target: menu

            // { added by yungi 2014.02.03 for ITS 223313
            onSignalItemFlicked:
            {
                if(!main.focus_visible)
                {
                    SM.setFocusFromModeAreaToScreen();
                }

                if(menu.selected_item == 0)
                    main.moveFocusHandle((EngineListenerMain.middleEast ? 1 : -1), radioList.focus_y)
                else
                    main.moveFocusHandle((EngineListenerMain.middleEast ? 1 : -1), radioList_NonCaption.focus_y)

                if(!menu.focus_visible) menu.showFocus()
            }
            // } added by yungi 2014.02.03

            onFocus_visibleChanged: 
            {
                if(!visible)
                    return;
                // { added by yungi 2014.01.29 for ITS 223312
                if(menu.focus_visible)
                {
                    radioList.hideFocus()
                    radioList_NonCaption.hideFocus()
                }
                // } added by yungi 2014.01.29

                // { modified by Sergey 08.09.2013 for ITS#188248
                if(menu.focus_visible || (radioList.focus_visible || radioList_NonCaption.focus_visible))
                {
                    if(menu.focus_visible)
                    {
                        menuFrame.state = "left"
                        menuFrame.cueState = east ? "upleftActive" : "uprightActive" // modified by yungi 2013.12.05 for ITS 211269
                    }
                    else
                    {
                        menuFrame.state = "right"
                        menuFrame.cueState = east ? "uprightActive" : "upleftActive" // modified by yungi 2013.12.05 for ITS 211269
                    }
                    default_x = east ? 1 : 0 // modified by oseong.kwon 2014.06.26 for ITS 241442 // added by cychoi 2014.03.19 for ITS 230078
                }
                // { commented by oseong.kwon 2014.06.26 for ITS 241442 // { comment by cychoi 2014.03.19 for ITS 230078
                //else
                //{
                    //menuFrame.state = "left"
                //    menuFrame.cueState = "downActive" // modified by oseong.kwon 2014.04.10 for ITS 234294 
                //}
                // } commented by oseong.kwon 2014.06.26 // } comment by cychoi 2014.03.19
                // } modified by Sergey 08.09.2013 for ITS#188248
            }
            // } modified by cychoi 2013.07.04
        }
        Connections 
        { 
            // { modified by cychoi 2013.07.04 for ITS 178107
            target: radioList
            onFocus_visibleChanged: 
            {
                EngineListenerMain.qmlLog( "DVD Setting radioList :: onFocus_visibleChanged ")

                if(!visible)
                    return;

                // { modified by yungi 2013.12.07 for ITS 213009// { modified by Sergey 08.09.2013 for ITS#188248
               cueStateUpdate()
                // } modified by yungi 2013.12.07 for ITS 213009// } modified by Sergey 08.09.2013 for ITS#188248
            }
            // } modified by cychoi 2013.07.04
        }
        
        Connections 
        { 
            // { modified by cychoi 2013.07.04 for ITS 178107
            target: radioList_NonCaption

            onFocus_visibleChanged:
            {
                EngineListenerMain.qmlLog( "DVD Setting radioList_NonCaption :: onFocus_visibleChanged ")

                if(!visible)
                    return;

                // { modified by yungi 2013.12.07 for ITS 213009 // { modified by Sergey 08.09.2013 for ITS#188248
                cueStateUpdate()
                // } modified by yungi // } modified by Sergey 08.09.2013 for ITS#188248

            }
            // } modified by cychoi 2013.07.04
        }    
        //} added by yongkyun.lee 20130612 
    }

    DHAVN_VP_Menu
    {
        id: menu

        //{ added by yongkyun.lee 20130612 for : ITS 172810
        // anchors.top: menuFrame.top
        // anchors.left: menuFrame.left
        anchors.top:  parent.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET - 5 // modified by cychoi 2014.02.28 for UX & GUI fix //added by shkim for ITS 189040
        anchors.left: parent.left
        //} added by yongkyun.lee 20130612 
        menu_model: list_model
        z:main.z + 10 //added by shkim for ITS 189040
        focus_x: east ? 1 : 0
        focus_y: 0
        currentPageLoop : false //{added by Michael.Kim 2013.08.22 for ITS 185733

        property int currentTab: video_model.activeTab


        // { added by Sergey 19.10.2013 for ITS#196877
        onItemFocused:
        {
            controller.onTabSelected(item);
            resetMenuContent(item)
            // { added by cychoi 2014.04.16 for ITS 234702
            if(!menu.focus_visible)
            {
                menu.showFocus();
            }
            // } added by cychoi 2014.04.16
            menuFrame.currentFocusIndex = item // added by cychoi 2014.12.22 for visual cue animation on quick scroll
        }
        // } added by Sergey 19.10.2013 for ITS#196877

        onSelectItem:
        {
            //added by shkim for ITS 179715
            EngineListenerMain.qmlLog("DVD Settings :: onSelectItem focus_visible = " + focus_visible);
            if(!focus_visible){
                menu.lostFocusHandle(UIListenerEnum.JOG_DOWN)
                // menu.setDefaultFocus(UIListenerEnum.JOG_DOWN) //added(delete) by sh.kim for ITS 185028
                menuFrame.cueState = "upleftActive"
            }
            //added by shkim for ITS 179715
            controller.onTabSelected(item);
            resetMenuContent(item)
        }

        onCurrentTabChanged:
        {
            menu.selectItem(currentTab)
            menu.selected_item = currentTab
        }

        onFocusMoved:
        {
            isLeftFocused = isMenuFocused
        }
    }

    DHAVN_VP_FocusedLoader
    {
        id: radioList
        // deleted by yungi 2013.10.29 for ITS 198333 // { added by yongkyun.lee 20130612 for :  ITS 172810
        anchors.top: parent.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET + 5 // modified by cychoi 2014.02.28 for UX & GUI fix //added by shkim for ITS 189040
        anchors.left: parent.left
        anchors.leftMargin: 708 // modified by cychoi 2014.02.28 for UX & GUI fix
        //} added by yongkyun.lee 20130612 
        z:main.z + 10 //added by shkim for ITS 189040
        name: "STR_SETTING_DVD_CAPTION_LANG"
        focus_x: east ? 0 : 1
        focus_y: 0
        visible: false
        source: "DHAVN_VP_DVD_Settings_RadioList.qml"
        // { added by kssanh 2013.07.03 for ITS 177614
        onVisibleChanged:
        {
            if(!visible)
                radioList.hideFocus()
        }
        // } added by kssanh 2013.07.03
    }

    DHAVN_VP_FocusedLoader
    {
        id: radioList_NonCaption

        //{ added by yongkyun.lee 20130612 for :  ITS 172810
        // anchors.top: menuFrame.top
        // anchors.topMargin: 10
        // anchors.left: menuFrame.left
        anchors.top: parent.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET + 5 // modified by cychoi 2014.02.28 for UX & GUI fix //added by shkim for ITS 189040
        anchors.left: parent.left
        anchors.leftMargin: 708 // modified by cychoi 2014.02.28 for UX & GUI fix
        //} added by yongkyun.lee 20130612 
        z:main.z + 10 //added by shkim for ITS 189040
        name: "STR_SETTING_DVD_VOICE_LANG"
        focus_x: east ? 0 : 1
        focus_y: 0
        visible: false
        source: "DHAVN_VP_DVD_Settings_RadioList_NonCaption.qml"

        // { added by kssanh 2013.07.03 for ITS 177614
        onVisibleChanged:
        {
            if(!visible)
            {
                radioList_NonCaption.hideFocus()
            }
        }
        // } added by kssanh 2013.07.03
    }

    ListModel
    {
        id: list_model

        Component.onCompleted:
        {
            list_model.append({"isCheckNA":false,  "isChekedState":false,"isDimmed":false, "isPopupItem":false, "dbID":0,
                              name:QT_TR_NOOP("STR_SETTING_GENERAL_DVD_CAPTION_LANGUAGE")})

            list_model.append({"isCheckNA":false,  "isChekedState":false,"isDimmed":false, "isPopupItem":false, "dbID":0,
                              name:QT_TR_NOOP("STR_SETTING_GENERAL_DVD_VOICE_LANGUAGE")})

            list_model.append({"isCheckNA":false,  "isChekedState":false,"isDimmed":false, "isPopupItem":false, "dbID":0,
                              name:QT_TR_NOOP("STR_SETTING_GENERAL_DVD_MENU_LANG")})
        }
    }

    Connections{
        target: controller

        onSetDVDSettingUI: {
            //{ deleted by lssanh.lee 20130624 for : ITS167153 dvd setting reset
            //radioList.visible = true
            //radioList_NonCaption.visible = false;
            //} deleted by lssanh.lee 20130624 
            //added by shkim for ITS 185028
            EngineListenerMain.qmlLog("onSetDVDSettingUI_TempMode : " +VideoEngine.isVideoTempMode()) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
            if(VideoEngine.isVideoTempMode()==false) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
            {
                default_x = east ? 1 : 0 // added by cychoi 2014.03.19 for ITS 230078

                menu.visible = true
                menuFrame.visible = true

                list_model.get(0).isDimmed = false
                list_model.get(1).isDimmed = false
                list_model.get(2).isDimmed = false
               // list_model.get(3).isDimmed = true

               //{ added by lssanh.lee 20130624 for :  ITS167153 dvd setting reset
               //menu.currentTab = 0
               // { modified by lssanh 2013.05.14 ITS167153 dvd setting reset
               //menu.currentTab = 0
               //radioList.visible = true
               menu.currentTab = video_model.activeTab
               if (video_model.activeTab == 0)
               {
                    radioList.visible = true
                    radioList_NonCaption.visible = false
                    radioList.item.setRadioSelected() // added by cychoi 2013.06.24 for new DVD Settings UX
               }
               else
               {
                   radioList.visible = false
                   radioList_NonCaption.visible = true
                   radioList_NonCaption.item.setRadioSelected() // added by cychoi 2013.06.24 for new DVD Settings UX
               }
                //} added by lssanh.lee 20130624
               //added by shkim for ITS 185028
               controller.onTabSelected(0);
               resetMenuContent(0)
               menu.selectItem(0)
               menu.selected_item = 0
               //added by shkim for ITS 185028
            }
        }
    }
// { added by yungi 2013.10.29 for ITS 198333
    Connections
    {
       target: radioList.item

       onSignalRadioItemSelected:
       {
           EngineListenerMain.qmlLog( "DVD Setting radioList :: onSignalRadioItemSelected" )

           if(!main.focus_visible)
           {
               SM.setFocusFromModeAreaToScreen();
           }

           if(!radioList.focus_visible)
           {
               // { modified by cychoi 2013.12.11 for ITS 213062
               main.moveFocusHandle((east ? -1 : 1), 0); // modified by Sergey 12.12.2013 for double focus issue
               //main.moveFocusHandle(radioList.focus_x, radioList.focus_y);
               // } modified by cychoi 2013.12.11
               radioList.item.setFocusToSelectedItem();
               radioList.showFocus();
           }
       }
       // { added by yungi 2013.12.11 for ITS 213062
       onSignalRadioItemFlicked:
       {
           EngineListenerMain.qmlLog( "DVD Setting radioList :: onSignalRadioItemFlicked" )

           if(!main.focus_visible)
               SM.setFocusFromModeAreaToScreen();

           if(!radioList.focus_visible)
           {
               // { modified by cychoi 2013.12.11 for ITS 213062
               main.moveFocusHandle((EngineListenerMain.middleEast ? -1 : 1), radioList.focus_y);
               //main.moveFocusHandle(radioList.focus_x, radioList.focus_y);
               // } modified by cychoi 2013.12.11
               radioList.showFocus(); // added by yungi 2014.01.29 for ITS 223312
           }
       }
       // } added by yungi 2013.12.11
       // { added by cychoi 2014.12.22 for visual cue animation on quick scroll
       onSignalRadioFocusIndexChanged:
       {
           menuFrame.currentFocusIndex = radioItem
       }
       // } added by cychoi 2014.12.22
    }

    Connections
    {
       target: radioList_NonCaption.item

       onSignalRadioItemSelected:
       {
           EngineListenerMain.qmlLog( "DVD Setting radioList_NonCaption :: onSignalRadioItemSelected" )

           if(!main.focus_visible)
           {
               SM.setFocusFromModeAreaToScreen();
           }

           if(!radioList_NonCaption.focus_visible)
           {
               // { modified by cychoi 2013.12.11 for ITS 213062
               main.moveFocusHandle((east ? -1 : 1), 0); // modified by Sergey 12.12.2013 for double focus issue
               //main.moveFocusHandle(radioList_NonCaption.focus_x, radioList_NonCaption.focus_y);
               // } modified by cychoi 2013.12.11
               radioList_NonCaption.item.setFocusToSelectedItem();
               radioList_NonCaption.showFocus();
           }
       }
       // { added by yungi 2013.12.11 for ITS 213062
       onSignalRadioItemFlicked:
       {
           EngineListenerMain.qmlLog( "DVD Setting radioList_NonCaption :: onSignalRadioItemFlicked" )

           if(!main.focus_visible)
               SM.setFocusFromModeAreaToScreen();

           if(!radioList_NonCaption.focus_visible)
           {
               // { modified by cychoi 2013.12.11 for ITS 213062
               main.moveFocusHandle((EngineListenerMain.middleEast ? -1 : 1), radioList_NonCaption.focus_y);
               //main.moveFocusHandle(radioList_NonCaption.focus_x, radioList_NonCaption.focus_y);
               // } modified by cychoi 2013.12.11
               radioList_NonCaption.showFocus(); // added by yungi 2014.01.29 for ITS 223312
           }
       }
       // } added by yungi 2013.12.11
       // { added by cychoi 2014.12.22 for visual cue animation on quick scroll
       onSignalRadioFocusIndexChanged:
       {
           menuFrame.currentFocusIndex = radioItem
       }
       // } added by cychoi 2014.12.22
    }
// } added by yungi

    // { added by oseong.kwon 2014.06.26 for ITS 241442
    Connections
    {
       target: SM

       onSigModeAreaFocused:
       {
           if(focused)
           {
               menuFrame.cueState = "downActive"
               default_x = east ? 0 : 1
           }
       }
    }
    // } added by oseong.kwon 2014.06.26
}
// } modified by Sergey 19.07.2013. Removed Divx part.
