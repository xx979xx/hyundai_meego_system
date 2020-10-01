import Qt 4.7
import Qt.labs.gestures 2.0
import QtQuick 1.1 //added by Michael.Kim 2013.08.02 for Middle East UI
//import QmlModeAreaWidget 1.0 // commented by cychoi 2015.02.11 for new DRS menu UX
import AppEngineQMLConstants 1.0
//import QmlStatusBar 1.0 // commented by cychoi 2015.02.11 for new DRS menu UX //modified by edo.lee 2013.04.04

import "../DHAVN_VP_RESOURCES.js" as RES
import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../components"
import "../models"

// { modified by cychoi 2013.07.07 for New UX
DHAVN_VP_FocusedItem
{
    id:main_rect

    width: CONST.const_SCREEN_WIDTH //added by Michael.Kim 2013.08.08 for Middle East UI
    height: CONST.const_SCREEN_HEIGHT //added by Michael.Kim 2013.08.08 for Middle East UI
//    width:RES.const_SCREEN_WIDTH //deleted by Michael.Kim 2013.08.08 for Middle East UI
//    height:627+93 //deleted by Michael.Kim 2013.08.08 for Middle East UI

    default_x:0
    default_y:0 // 1 // modified by cychoi 2015.02.11 for new DRS menu UX

    property bool east: EngineListenerMain.middleEast //added by Michael.Kim 2013.08.07 for Middle East UI
    LayoutMirroring.enabled: east //added by Michael.Kim 2013.08.07 for Middle East UI
    //property bool bTempMode: false // commented by cychoi 2014.07.15 seperation isTempMode memeber variable // added by cychoi 2013.12.19 for ITS 215825 Default focus
    //property bool bNumDisabled: false // added by cychoi 2014.01.23 for ITS 222055
    property int nLastIndex: 0 // added by oseong.kwon 2014.09.17 for ITS 248579 & ITS 248580
    property bool bLockout: false // added by oseong.kwon 2014.09.17 for ITS 248579 & ITS 248580

    name: "VCD_PbcMenu"
    Image {
        x: east ? 0 : 660 //added by Michael.Kim 2013.08.07 for Middle East UI
        y: CONST.const_MODEAREA_OFFSET_TOP // modified by cychoi 2015.02.11 for new DRS menu UX //added by Michael.Kim 2013.08.07 for Middle East UI
        width: 620 //added by Michael.Kim 2013.08.07 for Middle East UI
        height: 740 //added by Michael.Kim 2013.08.07 for Middle East UI
        source: "/app/share/images/video/bg_pbc.png"
        //anchors.fill: parent //deleted by Michael.Kim 2013.08.07 for Middle East UI
    }

    Image {
        x: east ? 0 : 584 //modified by Michael.Kim 2013.08.07 for Middle East UI
        y: CONST.const_CONTENT_AREA_TOP_OFFSET // modified by cychoi 2015.02.11 for new DRS menu UX
        width: 695-4
        //width: 695-17 //modified by Michael.Kim 2013.08.07 for Middle East UI
        height: 554
        source: "/app/share/images/video/bg_menu_r_s.png"
        mirror : east //added by Michael.Kim 2013.08.07 for Middle East UI
        //anchors.fill: parent
    }

    MouseArea
    {
        anchors.fill: parent
        beepEnabled: false		//added by hyochang.ryu 20130704
        enabled: !bLockout // added by cychoi 2015.07.08 for ITS 265847 disable MouseArea on Driving Regulations
        onPressed:
        {
            controller.onMousePressed()
        }
    }

    // { added by cychoi 2013.12.03 for New UX 
    function updateDelButton()
    {
        if(east || AudioListViewModel.GetCountryVariant() == CONST.const_DISC_CV_MIDDLE_EAST)
        {
            grid_model.set( 11, { "name": QT_TR_NOOP("STR_MEDIA_DELETE_BUTTON"),
                                  "bg_image_n": "",
                                  "bg_image_p": "" } )
        }
        else
        {
            grid_model.set( 11, { "name": "",
                                  "bg_image_n": "/app/share/images/video/icon_dial_del.PNG",
                                  "bg_image_p": "/app/share/images/video/icon_dial_del.PNG" } )
        }
    }
    // } added by cychoi 2013.12.03

    onVisibleChanged:
    {
        // { added by cychoi 2013.12.03 for New UX 
        if(visible)
        {
            EngineListenerMain.qmlLog("VCD_PBC_Menu_onVisibleChanged = " + visible + " TempMode = " + VideoEngine.isVideoTempMode() + " Local TempMode : " +VideoEngine.isLocalTempMode()/*main_rect.bTempMode*/) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
            // { modified by cychoi 2013.12.19 for ITS 215825 Default focus
            if(VideoEngine.isVideoTempMode() == false || VideoEngine.isLocalTempMode() == false/*main_rect.bTempMode == false*/) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
            {
                // { added by oseong.kwon 2014.09.17 for ITS 248579 & ITS 248580
                if((VideoEngine.isLocalTempMode()==true/*main.bTempMode==true*/) &&
                   (EngineListenerMain.IsChangeToDriving() || EngineListenerMain.IsChangeToParking() || EngineListenerMain.getCamInFG()))
                {
                    nLastIndex = grid_view.currentIndex
                    return
                }
                // } added by oseong.kwon 2014.09.17

                controller.setDefaultInputText() // added by cychoi 2013.12.16 ITS 215825
                grid_view.currentIndex = 0
                main_rect.setDefaultFocus(UIListenerEnum.JOG_DOWN)  
                //grid_view.showFocus() // added by lssanh 2013.04.07 ITS162438
                main_rect.updateDelButton();
                // { modified by cychoi 2014.07.15 seperation isTempMode memeber variable
                VideoEngine.setLocalTempMode(true)
                //main_rect.bTempMode = true
                // } modified by cychoi 2014.07.15
            }
            // } modified by cychoi 2013.12.19
        }
        // } added by cychoi 2013.12.03
    }

    // { added by cychoi 2013.12.03 for New UX 
    onEastChanged:
    {
        main_rect.updateDelButton();
    }
    // } added by cychoi 2013.12.03

    // { commented by cychoi 2015.02.11 for new DRS menu UX
    //QmlStatusBar
    //{
    //    id: statusBar
    //    property string name: "statusBar"
    //    x: 0;
    //    y: 0;
    //    width: 1280;
    //    height: 93  
    //    z: idRoadingImg.visible || lockoutRect.visible ? 5 : 0 // modified by cychoi 2015.02.11 for new DRS menu UX //add by shkim 2013.11.13 for ITS 209040 Camera -> VCD PBC Menu Issue
    //    //anchors.top: main.top
    //    //anchors.horizontalCenter: main.horizontalCenter
    //    homeType: "button"
    //    middleEast: east ? true : false //modified by Michael.Kim 2013.08.07 for Middle East UI
    //}

    //mode area
    //QmlModeAreaWidget
    //{
    //    id:mode_bar
    //    anchors.top: parent.top
    //    anchors.topMargin: 93
    //    anchors.left: parent.left
    //    modeAreaModel: mode_area_model
    //    property string name: "ModeArea"
    //    focus_id: 2 // added by ruindmby 2012.08.29 for CR 11640
    //    property int focus_x: 0
    //    property int focus_y: 0
    //    mirrored_layout: EngineListenerMain.middleEast //added by Michael.Kim for Middle East UI
    //    isAVPMode: true // DUAL_KEY
    //    z: idRoadingImg.visible || lockoutRect.visible ? 5 : 0 // modified by cychoi 2015.02.11 for new DRS menu UX //add by shkim 2013.11.13 for ITS 209040 Camera -> VCD PBC Menu Issue
    //    bAutoBeep: false // added by Sergey 19.11.2013 for beep issue
    //    onBeep: EngineListenerMain.ManualBeep(); // added by Sergey 19.11.2013 for beep issue
    //    onQmlLog: EngineListenerMain.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log

    //    onModeArea_BackBtn:
    //    {
    //        //{ added by yongkyun.lee 20130604 for :ITS 175870
    //        if(mode_bar.focus_visible)
    //            mode_bar.lostFocus(UIListenerEnum.JOG_DOWN,UIListenerEnum.KEY_STATUS_RELEASED )           
    //        //} added by yongkyun.lee 20130604 
    //        controller.onPbcOff()
    //    }

    //    //{ added by yongkyun.lee 20130624 for : ITS 175870
    //    onLostFocus:
    //    {
    //        EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onLostFocus :: Modearea ");
    //    }
    //    //} added by yongkyun.lee 20130624 
    //}
    // } commented by cychoi 2015.02.11
    // { add by shkim 2013.11.13 for ITS 209040 Camera -> VCD PBC Menu Issue
    Rectangle
    {

        id: idRoadingImg
        visible: false
        z:3
        anchors.fill:parent
        smooth: true

        Image
        {
            id: loadingPopupBg
            source: RES.const_URL_IMG_BG_LOADING_POPUP
        }

        Text
        {

            anchors.horizontalCenter: parent.horizontalCenter
            y: CONST.const_LOADING_POPUP_TEXT_TOP_OFFSET
            text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_LOADING") + LocTrigger.empty // modified by yungi 2013.04.16 ITS162630
            font.pointSize: 40
            color: CONST.const_FONT_COLOR_BRIGHT_GREY
        }


    }

    // { added by oseong.kwon 2014.09.17 for ITS 248579 & ITS 248580
    Connections
    {
        target: controller

        onShowLockout:
        {
            if(bLockout != onShow)
            {
                // { added by cychoi 2014.10.06 for ITS 249771 exception handling
                if(nLastIndex < 0)
                    nLastIndex = 0
                // } added by cychoi 2014.10.06
                grid_view.currentIndex = nLastIndex
            }
            bLockout = onShow;
        }
    }
    // } added by oseong.kwon 2014.09.17

    Connections
    {
        target: VideoEngine

        onSetLoadingPBCMenu:
        {
            if(isOn == true)
            {
                EngineListenerMain.qmlLog("[QML]PBC_Menu:: loading UI On :" +isOn);
                idRoadingImg.visible = true;
            }
            else if(isOn == false)
            {
                EngineListenerMain.qmlLog("[QML]PBC_Menu:: loading UI Off :" +isOn);
                idRoadingImg.visible = false;
            }
        }
    }

    // { added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
    Connections
    {
        target: video_model

        onInputtextChanged:
        {
            // { added by cychoi 2014.01.23 for ITS 222055
            //if(controller.getCurrentInputTextCount() < 2 ||
            //   controller.isInputAvailable())
            //{
            //    bNumDisabled = false
            //    grid_model.setProperty(0,"dim_color",false)
            //    grid_model.setProperty(1,"dim_color",false)
            //    grid_model.setProperty(2,"dim_color",false)
            //    grid_model.setProperty(3,"dim_color",false)
            //    grid_model.setProperty(4,"dim_color",false)
            //    grid_model.setProperty(5,"dim_color",false)
            //    grid_model.setProperty(6,"dim_color",false)
            //    grid_model.setProperty(7,"dim_color",false)
            //    grid_model.setProperty(8,"dim_color",false)
            //    grid_model.setProperty(10,"dim_color",false)
            //}
            //else
            //{
            //    bNumDisabled = true
            //    grid_model.setProperty(0,"dim_color",true)
            //    grid_model.setProperty(1,"dim_color",true)
            //    grid_model.setProperty(2,"dim_color",true)
            //    grid_model.setProperty(3,"dim_color",true)
            //    grid_model.setProperty(4,"dim_color",true)
            //    grid_model.setProperty(5,"dim_color",true)
            //    grid_model.setProperty(6,"dim_color",true)
            //    grid_model.setProperty(7,"dim_color",true)
            //    grid_model.setProperty(8,"dim_color",true)
            //    grid_model.setProperty(10,"dim_color",true)
            //}
            // } added by cychoi 2014.01.23
            grid_model.setProperty(9,"dim_color",(video_model.inputtext == "  ") ? true : false) // "OK"
            grid_model.setProperty(11,"dim_color",(video_model.inputtext == "  ") ? true : false) // "Delete"

            if(grid_view.model.get(grid_view.currentIndex).btn_id == "num_ok" ||
               grid_view.model.get(grid_view.currentIndex).btn_id == "num_del")
            {
                if(video_model.inputtext == "  ")
                {
                    // { commented by cychoi 2014.01.23 for ITS 222055
                    //grid_view.model.get(grid_view.currentIndex).jog_pressed = false
                    //grid_view.model.get(grid_view.currentIndex).mouse_pressed = false
                    // } commented by cychoi 2014.01.23
                    grid_view.currentIndex = 0
                }
            }
            // { added by cychoi 2014.01.23 for ITS 222055
            //else
            //{
            //    if(bNumDisabled == true)
            //    {
            //        //grid_view.model.get(grid_view.currentIndex).jog_pressed = false
            //        //grid_view.model.get(grid_view.currentIndex).mouse_pressed = false
            //        grid_view.currentIndex = 9 // "OK"
            //    }
            //}
            // } added by cychoi 2014.01.23
        }
    }
    // } added by yungi

    // { commented by cychoi 2014.07.15 seperation isTempMode memeber variable // { added by cychoi 2013.12.19 for ITS 215825 Default focus
    //Connections
    //{
    //    target: controller

    //    onSetPBCMenuUI:
    //    {
    //        main_rect.bTempMode = onTempMode
    //        EngineListenerMain.qmlLog("onSetPBCMenuUI bTempMode = " + main_rect.bTempMode)
    //    }
    //}
    // } commented by cychoi 2014.07.15 // } added by cychoi 2013.12.19

    // } add by shkim 2013.11.13 for ITS 209040 Camera -> VCD PBC Menu Issue
    ListModel
    {
        id: mode_area_model

        /** Title */
        property string text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_PBC_MENU") // modified by cychoi 2013.11.28 ITS 211638
    }
    Image
    {
        id: inputbox
        visible : true
        width: 521
        height: 81
        source: RES.const_URL_IMG_PBC_INPUTBOX
        x: east ? 33 : 718 //modified by Michael.Kim 2013.08.07 for Middle East UI
        y: 196

        Text
        {
            id: inputbox_text
            color: "black"
            font.pointSize:54
            font.family: CONST.const_FONT_FAMILY_NEW_HDB
            x: 51
            y: 40
            anchors.verticalCenter:   inputbox.verticalCenter
            anchors.horizontalCenter: inputbox.horizontalCenter
            text: video_model.inputtext
        }
    }
   
    ListModel
    {
        id:grid_model

        property Component btn_text_style: Component
        {
            Text
            {
                color: "#171717"
                font.pointSize: 1
            }
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/dial_num_1_n.png"
            bg_image_p: "/app/share/images/video/dial_num_1_n.png"
            bg_image_x:64
            bg_image_y:14
            bg_image_w:51
            bg_image_h:53

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0
            bg_text_Ali :""

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num1"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/dial_num_2_n.png"
            bg_image_p: "/app/share/images/video/dial_num_2_n.png"
            bg_image_x:64
            bg_image_y:14
            bg_image_w:51
            bg_image_h:53

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num2"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/dial_num_3_n.png"
            bg_image_p: "/app/share/images/video/dial_num_3_n.png"
            bg_image_x:64
            bg_image_y:14
            bg_image_w:51
            bg_image_h:53

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num3"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/dial_num_4_n.png"
            bg_image_p: "/app/share/images/video/dial_num_4_n.png"
            bg_image_x:64
            bg_image_y:14
            bg_image_w:51
            bg_image_h:53

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num4"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/dial_num_5_n.png"
            bg_image_p: "/app/share/images/video/dial_num_5_n.png"
            bg_image_x:64
            bg_image_y:14
            bg_image_w:51
            bg_image_h:53

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num5"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/dial_num_6_n.png"
            bg_image_p: "/app/share/images/video/dial_num_6_n.png"
            bg_image_x:64
            bg_image_y:14
            bg_image_w:51
            bg_image_h:53

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num6"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/dial_num_7_n.png"
            bg_image_p: "/app/share/images/video/dial_num_7_n.png"
            bg_image_x:64
            bg_image_y:14
            bg_image_w:51
            bg_image_h:53

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num7"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false  // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/dial_num_8_n.png"
            bg_image_p: "/app/share/images/video/dial_num_8_n.png"
            bg_image_x:64
            bg_image_y:14
            bg_image_w:51
            bg_image_h:53

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num8"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/dial_num_9_n.png"
            bg_image_p: "/app/share/images/video/dial_num_9_n.png"
            bg_image_x:64
            bg_image_y:14
            bg_image_w:51
            bg_image_h:53

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num9"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("OK")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: ""
            bg_image_p: ""
            bg_image_x:0
            bg_image_y:0
            bg_image_w:0
            bg_image_h:0

            bg_text_x: 25
            bg_text_y: 0
            bg_text_w: 125
            bg_text_h: 79

            font_color: "#FAFAFA"
            font_size: 32
            btn_id: "num_ok"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/dial_num_0_n.png"
            bg_image_p: "/app/share/images/video/dial_num_0_n.png"
            bg_image_x:64
            bg_image_y:14
            bg_image_w:51
            bg_image_h:53

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num0"
            focused: false
        }

        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/icon_dial_del.PNG"
            bg_image_p: "/app/share/images/video/icon_dial_del.PNG"
            bg_image_x:37
            bg_image_y:13
            bg_image_w:103
            bg_image_h:55

            // { modified by cychoi 2013.12.03 for New UX 
            bg_text_x: 25
            bg_text_y: 0
            bg_text_w: 125
            bg_text_h: 79
            // } modified by cychoi 2013.12.03

            font_color: "#FAFAFA"
            font_size: 32
            btn_id: "num_del"
            focused: false
        }
        ListElement
        {
            name: QT_TR_NOOP("Prev")
            icon_n: "/app/share/images/video/btn_pbc_con_n.png"
            icon_p: "/app/share/images/video/btn_pbc_con_p.png"
            icon_f: "/app/share/images/video/btn_pbc_con_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color: false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/ico_pbc_prev.png"
            bg_image_p: "/app/share/images/video/ico_pbc_prev.png"
            bg_image_x:34
            bg_image_y:22
            bg_image_w:24
            bg_image_h:40

            bg_text_x: 20
            bg_text_y: 0
            bg_text_w: 165
            bg_text_h: 85

            font_color: "#FAFAFA"
            font_size: 32

            btn_id: "num_prev"
            focused: false
        }
        ListElement
        {
            name: QT_TR_NOOP("")
            icon_n: "/app/share/images/video/btn_pbc_num_n.png"
            icon_p: "/app/share/images/video/btn_pbc_num_p.png"
            icon_f: "/app/share/images/video/btn_pbc_num_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color : false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/ico_pbc_return.png"
            bg_image_p: "/app/share/images/video/ico_pbc_return.png"
            bg_image_x:62
            bg_image_y:15
            bg_image_w:51
            bg_image_h:51

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 0
            bg_text_h: 0

            font_color: "#FAFAFA"
            font_size: 50
            btn_id: "num_return"
            focused: false
        }
        ListElement
        {
            name: QT_TR_NOOP("Next")
            icon_n: "/app/share/images/video/btn_pbc_con_n.png"
            icon_p: "/app/share/images/video/btn_pbc_con_p.png"
            icon_f: "/app/share/images/video/btn_pbc_con_f.png"
            mouse_pressed: false
            jog_pressed: false
            dim_color : false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            bg_image_n: "/app/share/images/video/ico_pbc_next.png"
            bg_image_p: "/app/share/images/video/ico_pbc_next.png"
            bg_image_x:127
            bg_image_y:22
            bg_image_w:24
            bg_image_h:40

            bg_text_x: 0
            bg_text_y: 0
            bg_text_w: 165
            bg_text_h: 85

            font_color: "#FAFAFA"
            font_size:32
            btn_id: "num_next"
            focused: false
        }
    }

    DHAVN_VP_FocusedGrid
    {
        id:grid_view      
        visible : true
        width:175*3
        height: 81*5
        cellWidth: 175
        cellHeight:81
        focus: true
        //anchors.left: parent.left
        model:grid_model
        delegate:  screen_delegate
        interactive:false
        y: 292
        x: east ? 33 : 718 //modified by Michael.Kim 2013.08.07 for Middle East UI
        focus_x:0
        focus_y:0 // 1 // modified by cychoi 2015.02.11 for new DRS menu UX

        property bool bFocusOnTopMostRow: (currentIndex == 0 || currentIndex == 1 || currentIndex == 2) ? true : false // added by yungi 2013.11.28 for NO CR VCD-PBC Additional 4-Arrow implementation
        property bool bFocusOnBottomMostRow: (currentIndex == 12 || currentIndex == 13 || currentIndex == 14) ? true : false // added by yungi 2013.11.28 for NO CR VCD-PBC Additional 4-Arrow implementation
        // { added by cychoi 2013.12.10 for UX for Jog HK
        property bool bFocusOnLeftMostCol: (currentIndex == 0 || currentIndex == 3 || currentIndex == 6 || currentIndex == 9 || currentIndex == 12) ? true : false
        property bool bFocusOnRightMostCol: (currentIndex == 2 || currentIndex == 5 || currentIndex == 8 || currentIndex == 11 || currentIndex == 14) ? true : false
        // } modified by cychoi 2013.12.10

// modified by Dmitry 15.05.13
        onJogSelected:
        {
            if(status == UIListenerEnum.KEY_STATUS_PRESSED)
            {
                if (grid_view.currentIndex >= 0)
                {
                    grid_view.model.get(grid_view.currentIndex).jog_pressed = false
                }
                controller.onMousePressed( grid_view.currentIndex )
                grid_view.handleOnPressed(grid_view.currentIndex)
                grid_view.model.get(grid_view.currentIndex).jog_pressed = true
            }
            else if(status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED) // modified by yungi 2013.10.23 for ITS 198052
            {
                grid_view.model.get(grid_view.currentIndex).jog_pressed = false // moved by cychoi 2014.01.23 for ITS 222055
                grid_view.handleOnReleased(grid_view.currentIndex)
            }
        }
// modified by Dmitry 15.05.13

        //{ added by yongkyun.lee 20130624 for : ITS 175870

        // { added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
        onCurrentIndexChanged:
        {
            if(grid_view.model.get(currentIndex).dim_color == true)
            {
                if(currentIndex == 9) // "OK"
                {
                    switch(is_jog_event)
                    {
                        case CONST.const_JOG_EVENT_ARROW_UP:
                            currentIndex-=3
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN:
                            currentIndex+=3
                            break
                        // { modified by cychoi 2013.12.10 for UX for Jog HK
                        case CONST.const_JOG_EVENT_ARROW_LEFT:
                            currentIndex++
                            break
                        case CONST.const_JOG_EVENT_ARROW_RIGHT:
                            // Should not happen
                            break
                        // { added by yungi 2014.02.14 for ITS 225174
                        case CONST.const_JOG_EVENT_ARROW_UP_LEFT:
                            currentIndex = 13
                            break
                        case CONST.const_JOG_EVENT_ARROW_UP_RIGHT:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN_LEFT:
                            currentIndex = 7
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN_RIGHT:
                            // Should not happen
                            break
                        // } added by yungi 2014.02.14
                        case CONST.const_JOG_EVENT_WHEEL_LEFT:
                            currentIndex--
                            break
                        case CONST.const_JOG_EVENT_WHEEL_RIGHT:
                            currentIndex++
                            break
                        // } modified by cychoi 2013.12.10
                        default:
                            //{ added by cychoi 2013.12.01 for Move focus to default if disabled has focus
                            if(video_model.inputtext == "  ")
                            {
                                currentIndex = 0
                            }
                            //} added by cychoi 2013.12.01
                            break
                    }
                }
                else if(currentIndex == 11)  // "Delete"
                {
                    switch(is_jog_event)
                    {
                        case CONST.const_JOG_EVENT_ARROW_UP:
                            currentIndex-=3
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN:
                            currentIndex+=3
                            break
                        // { modified by cychoi 2013.12.10 for UX for Jog HK
                        case CONST.const_JOG_EVENT_ARROW_LEFT:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_RIGHT:
                            currentIndex--
                            break
                        // { added by yungi 2014.02.14 for ITS 225174
                        case CONST.const_JOG_EVENT_ARROW_UP_LEFT:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_UP_RIGHT:
                            currentIndex = 13
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN_LEFT:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN_RIGHT:
                            currentIndex = 7
                            break
                        // } added by yungi 2014.02.14
                        case CONST.const_JOG_EVENT_WHEEL_LEFT:
                            currentIndex--
                            break
                        case CONST.const_JOG_EVENT_WHEEL_RIGHT:
                            currentIndex++
                            break
                        // } modified by cychoi 2013.12.10
                        default:
                            //{ added by cychoi 2013.12.01 for Move focus to default if disabled has focus
                            if(video_model.inputtext == "  ")
                            {
                                currentIndex = 0
                            }
                            //} added by cychoi 2013.12.01
                            break
                    }
                }
                // { added by cychoi 2014.01.23 for ITS 222055
                //else
                //{
                //    if(bNumDisabled == true)
                //    {
                //        switch(is_jog_event)
                //        {
                //            case CONST.const_JOG_EVENT_ARROW_UP:
                //                // Should not happen
                //                break
                //            case CONST.const_JOG_EVENT_ARROW_DOWN:
                //                // Should not happen
                //                break
                //            case CONST.const_JOG_EVENT_ARROW_LEFT:
                //                if(currentIndex == 10)
                //                    currentIndex = 9
                //                break
                //            case CONST.const_JOG_EVENT_ARROW_RIGHT:
                //                if(currentIndex == 10)
                //                    currentIndex = 11
                //                break
                //            case CONST.const_JOG_EVENT_WHEEL_LEFT:
                //                if(currentIndex < 9)
                //                    currentIndex = 14
                //                else if(currentIndex == 10)
                //                    currentIndex = 9
                //                break;
                //            case CONST.const_JOG_EVENT_WHEEL_RIGHT:
                //                if(currentIndex < 9)
                //                    currentIndex = 9
                //                else if(currentIndex == 10)
                //                    currentIndex = 11
                //                break;
                //            default:
                //                currentIndex = 9
                //                break;
                //        }
                //    }
                //}
                // } added by cychoi 2014.01.23
            }

            is_jog_event = -1 // added by cychoi 2014.01.23 for ITS 222055
        }
        // } added by yungi

        onMoveCurrentIndexUp:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onMoveCurrentIndexUp :: grid_view = "+ grid_view.focus_visible);
            if( grid_view.focus_visible )
            {
                //if(bFocusOnTopMostRow ||
                //   (bNumDisabled && grid_view.model.get(grid_view.currentIndex - 3).dim_color == true)) // modified by cychoi 2014.01.23 for ITS 222055
                if(bFocusOnTopMostRow)
                {
                    //grid_view.hideFocus(); // commented by cychoi 2015.02.11 for new DRS menu UX
                    grid_view.lostFocus(UIListenerEnum.JOG_UP);
                    //mode_bar.showFocus(); // commented by cychoi 2015.02.11 for new DRS menu UX
                }
                else grid_view.currentIndex -= 3
            }
        }
        // } modified by yungi
      
        // { modified by yungi 2014.02.14 for ITS 225174 // { added by yungi 2013.11.28 for NO CR VCD-PBC Additional 4-Arrow implementation
        onMoveCurrentIndex:
        {
            switch (direction)
            {
                case UIListenerEnum.JOG_UP:
                {
                    EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onMoveCurrentIndexUp :: grid_view = "+ grid_view.focus_visible);
                    if( grid_view.focus_visible )
                    {
                        if(bFocusOnTopMostRow)
                        {
                            //grid_view.hideFocus(); // commented by cychoi 2015.02.11 for new DRS menu UX
                            grid_view.lostFocus(UIListenerEnum.JOG_UP);
                            //mode_bar.showFocus(); // commented by cychoi 2015.02.11 for new DRS menu UX
                        }
                        else grid_view.currentIndex -= 3
                    }
                    break
                }
                case UIListenerEnum.JOG_DOWN:
                {
                    EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onMoveCurrentIndexDown :: grid_view = "+ grid_view.focus_visible);
                    if(grid_view.focus_visible)
                    {
                        if(bFocusOnBottomMostRow) return
                        else grid_view.currentIndex += 3
                    }
                    break
                }
                case UIListenerEnum.JOG_LEFT:
                {
                    EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onMoveCurrentIndexLeft :: grid_view = "+ grid_view.focus_visible);
                    if(grid_view.focus_visible)
                    {
                        if(bFocusOnLeftMostCol) return // modified by cychoi 2013.12.10 for UX for Jog HK
                        else grid_view.currentIndex--
                    }
                    break
                }
                case UIListenerEnum.JOG_RIGHT:
                {
                    EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onMoveCurrentIndexRight :: grid_view = "+ grid_view.focus_visible);

                    if(grid_view.focus_visible)
                    {
                        if(bFocusOnRightMostCol) return // modified by cychoi 2013.12.10 for UX for Jog HK
                        else grid_view.currentIndex++
                    }
                    break
                }
                case UIListenerEnum.JOG_TOP_RIGHT:
                {
                    EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onMoveCurrentIndexUpRight :: grid_view = "+ grid_view.focus_visible);

                    if(bFocusOnRightMostCol || bFocusOnTopMostRow)
                        return
                    grid_view.currentIndex -= 2
                    break
                }
                case UIListenerEnum.JOG_BOTTOM_RIGHT:
                {
                    EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onMoveCurrentIndexDownRight :: grid_view = "+ grid_view.focus_visible);

                    if(bFocusOnRightMostCol || bFocusOnBottomMostRow)
                        return
                    grid_view.currentIndex += 4
                    break
                }
                case UIListenerEnum.JOG_TOP_LEFT:
                {
                    EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onMoveCurrentIndexUpLeft :: grid_view = "+ grid_view.focus_visible);

                    if(bFocusOnLeftMostCol || bFocusOnTopMostRow)
                        return
                    grid_view.currentIndex -= 4
                    break
                }
                case UIListenerEnum.JOG_BOTTOM_LEFT:
                {
                    EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onMoveCurrentIndexDownLeft :: grid_view = "+ grid_view.focus_visible);

                    if(bFocusOnBottomMostRow || bFocusOnLeftMostCol)
                        return
                    grid_view.currentIndex += 2
                    break
                }
            }
        }
        // } modified by yungi 2014.02.14 // } added by yungi 2013.11.28

        onLostFocus:
        {
            EngineListenerMain.qmlLog("[MP][QML] VP VCD PBC Menu :: onLostFocus :: grid_view ");           
        }
        //} added by yongkyun.lee 20130624 

        // { added by sjhyun 2013.11.19 for ITS 209527
        onVisibleChanged:
        {
            if (visible && (main_rect.__current_index == -1))
            {
                main_rect.setDefaultFocus(UIListenerEnum.JOG_DOWN)
            }
        }
        // } added by sjhyun

        // { modified by cychoi 2014.01.23 for ITS 222055
        //onFocus_visibleChanged:
        //{
        //    if(focus_visible && bNumDisabled == true)
        //    {
        //        if(grid_view.currentIndex < 9 || grid_view.currentIndex == 10)
        //            grid_view.currentIndex = 9 // "OK"
        //    }
        //}
        // } modified by cychoi 2014.01.23

        function handleOnPressed(curIndex)
        {
            grid_view.currentIndex = curIndex
            grid_view.model.get(grid_view.currentIndex).font_color = "white"//"black" //20130308 ys new guide
        }

        function handleOnReleased(curIndex)
        {
            // { added by lssanh 2013.04.07 ITS162438
            if(grid_view.currentIndex == curIndex)
            {
            // } added by lssanh 2013.04.07 ITS162438 	  
                grid_view.currentIndex = curIndex

                controller.onKeyEntered( curIndex )
            } //added by lssanh 2013.04.07 ITS162438 
            grid_view.model.get(grid_view.currentIndex).font_color = "white"
        }
    }

    // { added by cychoi 2013.12.18 ITS 216318
    function handleOnMousePressed(curIndex)
    {
        grid_view.model.get(curIndex).mouse_pressed = true
    }
    
    function handleOnMouseReleased()
    {
        for(var i = 0; i < grid_view.model.count; i++)
        {
            if(grid_view.model.get(i).mouse_pressed == true)
            {
                grid_view.model.get(i).mouse_pressed = false
                break
            }
        }
    }
    // } added by cychoi 2013.12.18

    Component
    {
        id:screen_delegate

        Item
        {
            width: 175 //RES.const_VCD_MENU_ITEM_WIDTH + RES.const_VCD_MENU_GAP;
            height: 81 //RES.const_VCD_MENU_ITEM_HEIGHT + RES.const_VCD_MENU_GAP;

            Image
            {
                id: bg_image
                width: 175 //RES.const_VCD_MENU_ITEM_WIDTH
                height: 81 //RES.const_VCD_MENU_ITEM_HEIGHT
                anchors.right: parent.right
                anchors.top: parent.top
                source: jog_pressed || mouse_pressed ? icon_p : icon_n
                opacity: (dim_color == false) ? 1.0 : 0.5 // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            }

            Image
            {
                id: icon
                //anchors.horizontalCenter: bg_image.horizontalCenter
                //anchors.verticalCenter:   bg_image.verticalCenter
                x: bg_image_x
                y: bg_image_y
                width:bg_image_w
                height:bg_image_h

                source: bg_image_n
                opacity: (dim_color == false) ? 1.0 : 0.5 // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            }

            Text
            {
                id: item_text
                text: qsTranslate(CONST.const_LANGCONTEXT, name) //+ LocTrigger.empty
                font { pointSize: font_size;family: "DH_HDB"}
                x:bg_text_x
                y:bg_text_y
                width:bg_text_w
                height:bg_text_h

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: dim_color ? CONST.const_FONT_COLOR_DIMMED_GREY : font_color // modified by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            }

            Rectangle
            {
                id: focus
                visible: index == grid_view.currentIndex && grid_view.focus_visible

                width: 175//RES.const_VCD_MENU_ITEM_WIDTH
                height: 81

                anchors.right: parent.right
                anchors.top: parent.top

                color: CONST.const_TRANSPARENT_COLOR

                Image
                {
                    id: focused_item_img
                    source: jog_pressed || (grid_mouse_area.pressed && mouse_pressed) ? icon_p : icon_f // modified by cychoi 2013.12.18 ITS 216318


                    width: parent.width//RES.const_VCD_MENU_ITEM_WIDTH
                    height: parent.height

                    anchors.fill: parent
                }

                Image
                {
                    id: focused_icon
                    x: bg_image_x
                    y: bg_image_y
                    width:bg_image_w
                    height:bg_image_h

                    source: bg_image_n
                }

                Text
                {
                    id: focused_item_text
                    text: qsTranslate(CONST.const_LANGCONTEXT, name) //+ LocTrigger.empty
                    font { pointSize: font_size;family: "DH_HDB"}
                    x:bg_text_x
                    y:bg_text_y
                    width:bg_text_w
                    height:bg_text_h
                    //horizontalCenter: focused_item_text.horizontalCenter
                    //verticalCenter: focused_item_text.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    color:font_color
                }
            }

            MouseArea
            {
                id: grid_mouse_area
                anchors.fill: parent
                anchors.left: parent.left
                anchors.top: parent.top
                beepEnabled: false // added by cychoi 2013.12.18
                enabled: !bLockout // added by cychoi 2015.07.08 for ITS 265847 disable MouseArea on Driving Regulations
            
                // { added by cychoi 2013.12.18 ITS 216318
                // { modified by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
                onPressed:
                {
                    if(grid_view.model.get(index).dim_color == false)
                    {
                        //{ added by yongkyun.lee 20130604 for : ITS 168892
                        if(!grid_view.focus_visible) // if(mode_bar.focus_visible) // modified by cychoi 2015.02.11 for new DRS menu UX
                        {
                            // { modified by cychoi 2015.02.11 for new DRS menu UX
                            main_rect.lostFocusHandle(UIListenerEnum.JOG_DOWN)
                            main_rect.setDefaultFocus(UIListenerEnum.JOG_DOWN)
                            //mode_bar.lostFocus(UIListenerEnum.JOG_DOWN,UIListenerEnum.KEY_STATUS_RELEASED )
                            // } modified by cychoi 2015.02.11
                            grid_view.currentIndex = index
                        }
                        //} added by yongkyun.lee 20130604
                        controller.onMousePressed(index)
                        handleOnMousePressed(index)
                    }
                }
                
                onCanceled:
                {
                    handleOnMouseReleased()
                }
                
                onExited:
                {
                    handleOnMouseReleased()
                }
            
                onClicked:
                {
                    if(grid_view.model.get(index).dim_color == false)
                    {
                        handleOnMouseReleased()
                        UIListener.ManualBeep()
                        grid_view.currentIndex = index
                        controller.onKeyEntered(index)
                    }
                }
                // } modified by yungi
                // } added by cychoi 2013.12.18
            }

            // { added by yungi 2013.12.02 NoCR VCD PBC : ModeArea Title Not Changed When Languge changing
            Connections
            {
                target: EngineListenerMain
            
                onRetranslateUi:
                {
                    mode_area_model.text = qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_PBC_MENU")
                    // { added by cychoi 2013.12.03 for New UX 
                    item_text.text = qsTranslate(CONST.const_LANGCONTEXT, name)
                    focused_item_text.text = qsTranslate(CONST.const_LANGCONTEXT, name)
                    main_rect.updateDelButton();
                    // } added by cychoi 2013.12.03
                }
            }
            // } added by yungi 2013.12.02
        }
    }

    // { added by cychoi 2015.02.11 for new DRS menu UX
    Rectangle
    {
       id: lockoutRect

       visible: bLockout
       z:3
       anchors.fill:parent

       color: "black"

       Image
       {
           id: lockoutImg
           anchors.left: parent.left
           anchors.leftMargin: 562
           y: CONST.const_NO_PBCUE_LOCKOUT_ICON_TOP_OFFSET
           source: RES.const_URL_IMG_LOCKOUT_ICON
       }
       
       Text
       {
           width: parent.width           
           horizontalAlignment:Text.AlignHCenter
           anchors.top : lockoutImg.bottom
           text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_DISC_VCD_DRIVING_REGULATION") + LocTrigger.empty
           font.pointSize: 32
           color: "white"
       }
    }
    // } added by cychoi 2015.02.11
}
// } modified by cychoi 2013.07.07

