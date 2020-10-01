// { modified by Sergey 20.07.2013
import Qt 4.7
import QtQuick 1.1 //added by Michael.Kim 2013.08.02 for Middle East UI
import AppEngineQMLConstants 1.0
import Qt.labs.gestures 2.0

import "../components/listView"
import "../components"
import "../models"
import "../DHAVN_VP_CONSTANTS.js" as CONST


DHAVN_VP_FocusedCppItem
{
    id: main_rect

    width: CONST.const_SCREEN_WIDTH
    height: CONST.const_SCREEN_HEIGHT

    property bool east: EngineListenerMain.middleEast //added by Michael.Kim 2013.08.02 for Middle East UI
    property bool bFocusOnTopMostRow: (grid.currentIndex == 0 || grid.currentIndex == 1 || grid.currentIndex == 2) ? true : false // added by yungi 2013.10.25 for UX Scenario DVD-Setting Update
    property bool bFocusOnLeftMostCol: (grid.currentIndex == 0 || grid.currentIndex == 3 || grid.currentIndex == 6 || grid.currentIndex == 9) ? true : false // modified by cychoi 2013.11.26 for ITS 211070 // added by yungi 2013.10.25 for UX Scenario DVD-Setting Update
    property bool bFocusOnRightMostCol: (grid.currentIndex == 2 || grid.currentIndex == 5 || grid.currentIndex == 8 || grid.currentIndex == 11) ? true : false // modified by cychoi 2013.11.26 for ITS 211070 // added by yungi 2013.10.25 for UX Scenario DVD-Setting Update
    property bool bFocusOnBottomMostRow: (grid.currentIndex == 9 || grid.currentIndex == 10 || grid.currentIndex == 11) ? true : false // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
    property bool bPopupShown: false // added by cychoi 2013.12.28 for ITS 217548
    //property bool bNumDisabled: false // added by cychoi 2014.01.23 for ITS 222055

    LayoutMirroring.enabled: east //added by Michael.Kim 2013.08.02 for Middle East UI

    name: "SearchLang"
    focus:true
    //default_x:1
    default_x: east ? 0 : 1 //modified by Michael.Kim 2013.08.02 for Middle East UI
    default_y:0

    property int focus_index: -1
    property int focusIndex: 0
    property real titleHeightRatio: CONST.const_TITLE_LIST_ITEM_HEIGHT * input_lang_list.count/input_lang_list.height
    //added by Michael.Kim 2013.07.23 for New UX

    // { added by cychoi 2014.02.14 for ITS 225376
    MouseArea
    {
        anchors.fill: parent
        beepEnabled: false
        onPressed:
        {
            controller.onMousePressed()
        }
    }
    // } added by cychoi 2014.02.14

    //{ added by cychoi 2013.11.27 for ITS 211173
    Connections
    {
        target: video_model
        onInputTextChanged:
        {
            // { added by cychoi 2014.01.23 for ITS 222055
            //if(controller.getCurrentInputTextCount() < 4)
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
            grid_model.setProperty(9,"dim_color",(video_model.inputText == "") ? true : false) // "Done"
            grid_model.setProperty(11,"dim_color",(video_model.inputText == "") ? true : false) // "Delete"
            visualCueState() //added by oseong.kwon 2013.12.17 for ITS 216001
            
            if(grid.model.get(grid.currentIndex).item_value == "Done" ||
               grid.model.get(grid.currentIndex).item_value == "Delete")
            {
                if(video_model.inputText == "")
                {
                    grid.currentIndex = 0
                    //visualCueState() //removed by yungi  2013.12.05 for ITS 211269
                }
            }
            // { added by cychoi 2014.01.23 for ITS 222055
            //else
            //{
            //    if(bNumDisabled == true)
            //        grid.currentIndex = 9 // "Done"
            //}
            // } added by cychoi 2014.01.23
        }
    }
    //} added by cychoi 2013.11.27

    // { added by cychoi 2013.12.28 for ITS 217548
    Connections
    {
        target: VideoEngine

        onSystemPopupShow:
        {
            // { added by cychoi 2014.02.14 ITS 225398
            if( disp == SM.disp)
                bPopupShown = bShown
            else
                bPopupShown = false
            // } added by cychoi 2014.02.14
        }

        onLocalPopupShow:
        {
            // { added by cychoi 2014.02.14 ITS 225398
            if( disp == SM.disp)
                bPopupShown = bShown
            else
                bPopupShown = false
            // } added by cychoi 2014.02.14
            if(bShown == false)
            {
                controller.setDefaultInputText()
            }
        }
    }
    // } added by cychoi 2013.12.28

    // { added by oseong.kwon 2014.06.26 for ITS 241442
    Connections
    {
       target: SM

       onSigModeAreaFocused:
       {
           if(focused)
           {
               visual_cue.cueState = "downActive"
           }
       }
    }
    // } added by oseong.kwon 2014.06.26

    // { added by cychoi 2013.12.03 for New UX 
    function updateDelButton()
    {
        if(east || AudioListViewModel.GetCountryVariant() == CONST.const_DISC_CV_MIDDLE_EAST)
        {
            grid_model.set( 11, { "name": QT_TR_NOOP("STR_MEDIA_DELETE_BUTTON"),
                                  "icon": "" } )
        }
        else
        {
            grid_model.set( 11, { "name": "",
                                  "icon": "/app/share/images/bt_phone/icon_dial_del.PNG" } )
        }
    }
    // } added by cychoi 2013.12.03

    onVisibleChanged:
    {
        if (visible)
        {
            EngineListenerMain.qmlLog("onVisibleChanged = " +  visible + " TempMode = " + VideoEngine.isVideoTempMode()) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
            if(VideoEngine.isVideoTempMode() == false) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
            {
                video_model.inputText = controller.getCurrentCode()
                controller.refreshCaptionList()
                grid.currentIndex = 0 // added by cychoi 2014.02.14 for DVD SearchCaption local Temporal Mode
                main_rect.setDefaultFocus(UIListenerEnum.JOG_DOWN)
                main_rect.updateDelButton(); // added by cychoi 2013.12.03 for New UX 
                // { added by cychoi 2014.01.23 for ITS 222055
                //if(bNumDisabled == true)
                //{
                //    if(grid.currentIndex < 9 || grid.currentIndex == 10)
                //        grid.currentIndex = 9 // "Done"
                //}
                // } added by cychoi 2014.01.23
            }
            // { added by cychoi 2014.03.19 for ITS 230078
            else
            {
                grid_model.setProperty(9,"dim_color",(video_model.inputText == "") ? true : false) // "Done"
                grid_model.setProperty(11,"dim_color",(video_model.inputText == "") ? true : false) // "Delete"
                if(video_model.inputText == "") grid.currentIndex = 0
            }
            // } added by cychoi 2014.03.19
        }
    }

    // { added by cychoi 2013.12.03 for New UX 
    onEastChanged:
    {
    	// { added by yungi 2013.12.07 for ITS 213009
        if(input_lang_list.focus_visible)
        {
            visual_cue.state = "left"
            visual_cue.cueState = east ? "upleftActive" : "uprightActive"
        }
        else if(grid.focus_visible)
        {
            visualCueState()
        }
        // } added by yungi 2013.12.07
        main_rect.updateDelButton();
    }
    // } added by cychoi 2013.12.03

    function handleBackKey()
    {
        main_rect.visible = false
    }

    function retranslateUi()
    {
    }

    function visualCueState()
    {
        if(grid.currentIndex < 0 ||
           grid.model.get(grid.currentIndex).dim_color)
        {
            // If current button is not set or is disabled, juset return
            return
        }
        
        if(input_lang_list.count > 0)
        {
            switch(grid.currentIndex)
            {
                case 0:
                case 3:
                {
                    if(east)
                        visual_cue.cueState = "uprightdownActive"
                    else
                        visual_cue.cueState = "allActive"
                    break;
                }
                case 2:
                case 5:
                {
                    if(east)
                        visual_cue.cueState = "allActive"
                    else
                        visual_cue.cueState = "upleftdownActive"
                    break;
                }
                case 6:
                {
                    if(east)
                    {
                        if(grid.model.get(9).dim_color)
                            visual_cue.cueState = "uprightActive"
                        else
                            visual_cue.cueState = "uprightdownActive"
                    }
                    else
                    {
                        if(grid.model.get(9).dim_color)
                            visual_cue.cueState = "upleftrightActive"
                        else
                            visual_cue.cueState = "allActive"
                    }
                    break;
                }
                case 8:
                {
                    if(east)
                    {
                        if(grid.model.get(11).dim_color)
                            visual_cue.cueState = "upleftrightActive"
                        else
                            visual_cue.cueState = "allActive"
                    }
                    else
                    {
                        if(grid.model.get(11).dim_color)
                            visual_cue.cueState = "upleftActive"
                        else
                            visual_cue.cueState = "upleftdownActive"
                    }
                    break;
                }
                case 9:
                {
                    if(east)
                        visual_cue.cueState = "uprightActive"
                    else
                        visual_cue.cueState = "upleftrightActive"
                    break;
                }
                case 10:
                {
                    visual_cue.cueState = "upleftrightActive"
                    break;
                }
                case 11:
                {
                    if(east)
                        visual_cue.cueState = "upleftrightActive"
                    else
                        visual_cue.cueState = "upleftActive"
                    break;
                }
                case 1:
                case 4:
                case 7:
                {
                    visual_cue.cueState = "allActive"
                    break;
                }
                default:
                    break;
            }
        }
        else
        {
            // { modified by oseong.kwon 2013.12.17 for ITS 216001     
            switch(grid.currentIndex)
            {
                case 0:
                case 3:
                {
                    visual_cue.cueState = "uprightdownActive"
                    break;
                }
                case 2:
                case 5:
                {
                    visual_cue.cueState = "upleftdownActive"
                    break;
                }
                case 9:
                {
                    visual_cue.cueState = "uprightActive"
                    break;
                }
                case 11:
                {
                    visual_cue.cueState = "upleftActive"
                    break;
                }
                case 6:
                {
                    if(grid.model.get(9).dim_color)
                        visual_cue.cueState = "uprightActive"
                    else
                        visual_cue.cueState = "uprightdownActive"
                    break;
                }
                case 8:
                {
                    if(grid.model.get(11).dim_color)
                        visual_cue.cueState = "upleftActive"
                    else
                        visual_cue.cueState = "upleftdownActive"
                    break;
                }
                case 10:
                {
                    if(grid.model.get(9).dim_color)
                        visual_cue.cueState = "upActive"
                    else
                        visual_cue.cueState = "upleftrightActive"
                    break;
                }
                case 1:
                case 4:
                case 7:
                {
                    visual_cue.cueState = "allActive"
                    break;
                }
                default:
                    break;
            }
            // } modified by oseong.kwon 2013.12.17
        }
    }



    // ======================================= SUB ELEMENTS =============================================


    Image
    {
        id: backgroundImage
        source: "/app/share/images/general/bg_main.png" //20131025 GUI fix
    }

    // { modified by cychoi 2014.05.12 for ITS 230078 (Add fix)
    Image
    {
        id: listFrame

        z: main_rect.z+2
        anchors.top: main_rect.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: main_rect.bottom
        anchors.left: main_rect.left

        source: east ? "" : "/app/share/images/video/bg_menu_l_s.png"
        mirror: east
        visible: visual_cue.state != "right"
    }

    Image
    {
        id: listFrameME

        z: main_rect.z+2
        anchors.top: main_rect.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: main_rect.bottom
        anchors.right: main_rect.right

        source: east ? "/app/share/images/video/bg_menu_l_s.png" : ""
        mirror: east
        visible: visual_cue.state != "right"
    }

    Image
    {
        id: listFrameBG

        anchors.top: main_rect.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: main_rect.bottom
        anchors.left: east ? undefined : main_rect.left
        anchors.right: east ? main_rect.right : undefined

        source: "/app/share/images/video/bg_menu_l.png"
        mirror: east
        visible: visual_cue.state != "right"
    }

    Image
    {
        id: keypadFrame

        z: main_rect.z+2
        anchors.top: main_rect.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: main_rect.bottom
        anchors.right: main_rect.right

        source: east ? "" : "/app/share/images/video/bg_menu_r_s.png"
        mirror: east
        visible: visual_cue.state == "right"
    }

    Image
    {
        id: keypadFrameME

        z: main_rect.z+2
        anchors.top: main_rect.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: main_rect.bottom
        anchors.left: main_rect.left

        source: east ? "/app/share/images/video/bg_menu_r_s.png" : ""
        mirror: east
        visible: visual_cue.state == "right"
    }

    Image
    {
        id: keypadFrameBG

        anchors.top: main_rect.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: main_rect.bottom
        anchors.left: east ? main_rect.left : undefined
        anchors.right: east ? undefined : main_rect.right

        source: "/app/share/images/video/bg_menu_r.png"
        mirror: east
        visible: visual_cue.state == "right"
    }
    // } modified by cychoi 2014.05.12

    //added by Michael.kim 2013.07.20 for New UX
    DHAVN_VP_CueBg
    {
        id: visual_cue

        z: main_rect.z+3

        anchors.left: main_rect.left
        anchors.leftMargin: 0
        anchors.right: main_rect.right
        anchors.top : main_rect.top
        //anchors.topMargin: CONST.const_CENTER_AREA_4ARROW_TOP_OFFSET // commented by yungi2 2013.08.05 for 4-arrow display error
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET // added by yungi2 2013.08.05 for 4-arrow display error
        bVertical: true
        sVertArrow: main_rect.focus_visible ? "up" : "down"
        east: main_rect.east
        currentFocusIndex : 0 // added by cychoi 2014.12.22 for visual cue animation on quick scroll
        // removed by Sergey 08.09.2013 for ITS#188248
        // removed by yungi 2013.12.04 for ITS 211269 // { added by yungi 2013.11.19 for ITS 209826
        Connections
        {
            // { modified by cychoi 2013.07.04 for ITS 178107
            target: input_lang_list
            onFocus_visibleChanged:
            {
                if(!main_rect.focus_visible)
                    return;

                // { modified by Sergey 08.09.2013 for ITS#188248
                if(input_lang_list.focus_visible || grid.focus_visible)
                {
                    if(input_lang_list.focus_visible)
                    {
                        visual_cue.state = "left"
                        visual_cue.cueState = east ? "upleftActive" : "uprightActive" // modified by yungi 2013.12.05 for ITS 211269
                    }
                    else
                    {
                        visual_cue.state = "right"
                        // { modified by cychoi 2014.01.23 for ITS 222055
                        visualCueState()
                        //visual_cue.cueState = east ? "uprightActive" : "upleftActive" // modified by yungi 2013.12.05 for ITS 211269
                        // } modified by cychoi 2014.01.23
                    }
                }
                // { commented by oseong.kwon 2014.06.26 for ITS 241442 // { commented by cychoi 2014.03.19 for ITS 230078
                //else
                //{
                //    visual_cue.state = "right"
                //    visual_cue.cueState = "downActive" // modified by oseong.kwon 2014.04.10 for ITS 234294 
                //}
                // } commented by oseong.kwon 2014.06.26 // } commented by cychoi 2014.03.19
                // } modified by Sergey 08.09.2013 for ITS#188248
            }
            // } modified by cychoi 2013.07.04
        }
        Connections
        {
            // { modified by cychoi 2013.07.04 for ITS 178107
            target: grid
            onFocus_visibleChanged:
            {
                if(!main_rect.focus_visible)
                    return;

                // { modified by Sergey 08.09.2013 for ITS#188248
                if(grid.focus_visible || input_lang_list.focus_visible)
                {
                    if(grid.focus_visible)
                    {
                        visual_cue.state = "right"
                        // { modified by cychoi 2014.01.23 for ITS 222055
                        visualCueState()
                        // { modified by yungi 2013.12.05 for ITS 211269
                        //if(input_lang_list.count > 0)
                        //    visual_cue.cueState = east ? "uprightdownActive" : "allActive"
                        //else
                        //    visual_cue.cueState = "uprightdownActive"
                        // } modified by yungi
                        // } modified by cychoi 2014.01.23 for ITS 222055
                    }
                    else
                    {
                        visual_cue.state = "left"
                        visual_cue.cueState = east ? "upleftActive" : "uprightActive"
                    }
                }
                // { commented by oseong.kwon 2014.06.26 for ITS 241442 // { commented by cychoi 2014.03.19 for ITS 230078
                //else
                //{
                //    visual_cue.state = "right"
                //    visual_cue.cueState = "downActive" // modified by oseong.kwon 2014.04.10 for ITS 234294 
                //}
                // } commented by oseong.kwon 2014.06.26 // } commented by cychoi 2014.03.19
                // } modified by Sergey 08.09.2013 for ITS#188248
            }
            // } modified by cychoi 2013.07.04
        }

        state: "right"
    }
    //added by Michael.kim 2013.07.20 for New UX

    DHAVN_VP_SearchCaptionList
    {
        id: input_lang_list

        anchors.left: main_rect.left
        //anchors.leftMargin: 45 // commented by cychoi 2014.03.28 for ITS 232218 GUI fix
        anchors.top: listFrame.top
        anchors.topMargin: 98

        width:  580 // modified by cychoi 2014.03.28 for ITS 232218 GUI fix
        height: 445 //340 //modified by Michael.Kim 2013.07.20 for New UX

        //focus_x: 0
        focus_x: east ? 1 : 0 //modified by Michael.Kim 2013.08.02 for Middle East UI
        focus_y: 0
        focus_visible: false

        onCountChanged:
        {
            input_lang_list.currentIndex = 0 // added by cychoi 2015.07.27 for ITS 266991
            input_lang_list.positionViewAtIndex(0,input_lang_list.Beginning) // added by cychoi 2015.07.27 for ITS 266991
            visualCueState() //added by yungi  2013.12.05 for ITS 211269
        }

        // { added by yungi 2013.12.12 for NoCR DVD-SearchCaption TopFocus Not visible
        onNoFocusFlickingEnded:
        {
            if(input_lang_list.visible == true && input_lang_list.focus_visible == false) // modified by cychoi 2015.07.27 for ITS 266991
            {
                SM.setFocusFromModeAreaToScreen(); // added by wspark 2014.01.23 for ITS 222054
                lostFocus( east ? UIListenerEnum.JOG_RIGHT : UIListenerEnum.JOG_LEFT )
                input_lang_list.currentIndex = moveIndex
                input_lang_list.positionViewAtIndex(moveIndex,input_lang_list.Beginning)
                input_lang_list.focus_visible = true
            }
        }
        // } added by yungi 2013.12.12

        // { added by cychoi 2014.12.22 for visual cue animation on quick scroll
        onCurrentIndexChanged:
        {
            visual_cue.currentFocusIndex = input_lang_list.currentIndex
        }
        // } added by cychoi 2014.12.22
    }

    Image
    {
        id: inputbox

        // { deleted by Michael.Kim 2013.08.07 for Middle East UI
        //        anchors.top: listFrame.top
        //        anchors.topMargin: 15 //modified by Michael.Kim 2013.07.20 for New UX
        //        anchors.left: main_rect.left
        //        anchors.leftMargin: 45
        // { deleted by Michael.Kim 2013.08.07 for Middle East UI

        // { modified by Michael.Kim 2013.08.07 for Middle East UI
        x: east? 717 : 45
        y: 182
        width: 524
        height: 84
        // { modified by Michael.Kim 2013.08.07 for Middle East UI

        //source: "/app/share/images/bt_phone/dial_inputbox_n.png"
        source: "/app/share/images/video/dial_inputbox_n.png" //modified by Michael.Kim 2013.07.20 for New UX
        mirror: east

        Text
        {
            id: inputbox_text
            // { modified by yungi 2013.12.03 for ITS 212329
            anchors.left: east ? undefined : parent.left
            anchors.leftMargin: east ? undefined : 19
            anchors.right: east ? parent.right : undefined
            anchors.rightMargin: east ? 19 : undefined
            // } modified by yungi

            color: CONST.const_FONT_COLOR_BUTTON_GREY //modified by Michael.Kim 2013.07.20 for New UX
            font { pointSize: 54; family: "DH_HDR"} //modified by Michael.Kim 2013.07.20 for New UX
            x: 20
            anchors.verticalCenter:   inputbox.verticalCenter
            text: video_model.inputText
        }

    }

    //added by Michael.kim 2013.07.20 for New UX
    DHAVN_VP_Curved_Scroll
    {
        id: titleScroll

        // { deleted by Michael.Kim 2013.08.07 for Middle East UI
        //        z: main_rect.z+1
        //        anchors.verticalCenter: listFrame.verticalCenter
        //        anchors.right: listFrame.right
        //        anchors.rightMargin: 30 //modified by Michael.Kim 2013.07.20 for New UX
        // { deleted  by Michael.Kim 2013.08.07 for Middle East UI

        // { modified by Michael.Kim 2013.08.07 for Middle East UI
        x: east? 642 : 583
        y: 196
        // { modified by Michael.Kim 2013.08.07 for Middle East UI

        anchors.verticalCenter: listFrame.verticalCenter

        // { modified by yungi 2013.12.18 for ITS 216177
        verticalOffset: ((input_lang_list.visibleArea.heightRatio != 1) ?
                        ((titleScroll.height * coverage >= 80) ? input_lang_list.visibleArea.yPosition : input_lang_list.visibleArea.yPosition / 1.12) :
                        (input_lang_list.visibleArea.yPosition > 0) ? 0 : -input_lang_list.visibleArea.yPosition)
        // } modified by yungi 2013.12.18

        coverage:  ((input_lang_list.visibleArea.heightRatio != 1)? input_lang_list.visibleArea.heightRatio :
                    titleHeightRatio - input_lang_list.visibleArea.yPosition)
        pageSize : ((input_lang_list.visibleArea.heightRatio != 1)? input_lang_list.visibleArea.heightRatio : ( 1 / titleHeightRatio ))
        visible :  (input_lang_list.count == 0) ? false :(pageSize < 1)
        east: main_rect.east


        onVisibleChanged: {
            EngineListenerMain.qmlLog("input_lang_list.count = " + input_lang_list.count)
        }

        onPageSizeChanged: {
            EngineListenerMain.qmlLog("pageSizeChanged = " + pageSize)
                input_lang_list.currentPage = pageSize
        }
    }
    //added by Michael.kim 2013.07.20 for New UX

    DHAVN_VP_FocusedGrid
    {
        id: grid

        width:174*3
        height: 130*4
        cellWidth: 174
        cellHeight:130

        name: "FocusedGrid"
        focus: true
        //focus_x:1
        focus_x: east ? 0 : 1 //modified by Michael.Kim 2013.08.02 for Middle East UI
        focus_y:0

        model: grid_model
        delegate: screen_delegate
        interactive: false

        // { deleted by Michael.Kim 2013.08.07 for Middle East UI
        //        anchors.top: keypadFrame.top
        //        anchors.topMargin: 15
        //        anchors.left: main_rect.left
        //        anchors.leftMargin: 717
        // { deleted by Michael.Kim 2013.08.07 for Middle East UI

        // { modified by Michael.Kim 2013.08.07 for Middle East UI
        x : east ? 30 : 717
        y: 182
        // { modified by Michael.Kim 2013.08.07 for Middle East UI

        // { modified by yungi 2014.02.14 for ITS 225174 //{ modified by yongkyun.lee 2013-07-20 for : ITS 180917
        onMoveCurrentIndex:
        {
            switch (direction)
            {
                case UIListenerEnum.JOG_UP:
                {
                    EngineListenerMain.qmlLog("onMoveCurrentIndexUp")

                    if(bFocusOnTopMostRow)
                        lostFocus( UIListenerEnum.JOG_UP )
                    else grid.currentIndex -= 3
                }
                case UIListenerEnum.JOG_DOWN:
                {
                    EngineListenerMain.qmlLog("onMoveCurrentIndexDown")

                    if(bFocusOnBottomMostRow) return
                    else grid.currentIndex += 3
                }
                case UIListenerEnum.JOG_LEFT:
                {
                    EngineListenerMain.qmlLog("onMoveCurrentIndexLeft")

                    if(!east && bFocusOnLeftMostCol)
                        lostFocus( UIListenerEnum.JOG_LEFT )
                    else if(bFocusOnLeftMostCol) return
                    else grid.currentIndex--
                }
                case UIListenerEnum.JOG_RIGHT:
                {
                    EngineListenerMain.qmlLog("onMoveCurrentIndexRight")

                    if(east && bFocusOnRightMostCol)
                        lostFocus( UIListenerEnum.JOG_RIGHT )
                    else if(bFocusOnRightMostCol) return
                    else grid.currentIndex++
                }
                case UIListenerEnum.JOG_TOP_RIGHT:
                {
                    EngineListenerMain.qmlLog("onMoveCurrentIndexUpRight")

                    if(bFocusOnTopMostRow || bFocusOnRightMostCol)
                        return
                    else grid.currentIndex -= 2
                    break
                }
                case UIListenerEnum.JOG_BOTTOM_RIGHT:
                {
                    EngineListenerMain.qmlLog("onMoveCurrentIndexDownRight")

                    if(bFocusOnBottomMostRow || bFocusOnRightMostCol)
                        return
                    else grid.currentIndex += 4
                    break
                }
                case UIListenerEnum.JOG_TOP_LEFT:
                {
                    EngineListenerMain.qmlLog("onMoveCurrentIndexTopRight")

                    if(bFocusOnTopMostRow || bFocusOnLeftMostCol) return
                    grid.currentIndex -= 4
                    break
                }
                case UIListenerEnum.JOG_BOTTOM_LEFT:
                {
                    EngineListenerMain.qmlLog("onMoveCurrentIndexDownLeft")

                    if(bFocusOnBottomMostRow || bFocusOnLeftMostCol)
                        return
                    grid.currentIndex += 2
                    break
                }
            }
        }
        // } modified by yungi 2014.02.14 //} modified by yongkyun.lee 2013-07-20

        onJogSelected:
        {
            if(status == UIListenerEnum.KEY_STATUS_PRESSED)
            {
                EngineListenerMain.qmlLog("onJogSelected PRESS in gridView" + grid.currentIndex)
                if (grid.currentIndex >= 0)
                    grid.model.get(grid.currentIndex).jog_pressed = true
            }
            else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
            {
                EngineListenerMain.qmlLog("onJogSelected RELEASE in gridView" + grid.currentIndex)
                if (grid.currentIndex >= 0 && grid.model.get(grid.currentIndex).jog_pressed == true) // modified by sjhyun 2013.10.29 for ITS 198332
                {
                    grid.model.get(grid.currentIndex).jog_pressed = false
                    controller.onKeyEntered(grid.model.get(grid.currentIndex).item_value)
                }
            }
            // { added by wspark 2014.01.24 for ITS 222575
            else if(status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
            {
                EngineListenerMain.qmlLog("onJogSelected LONG_PRESSED in gridView" + grid.currentIndex)
                if(grid.model.get(grid.currentIndex).item_value == "Delete")
                {
                    grid.model.get(grid.currentIndex).jog_pressed = false
                    controller.deleteAllInputText()
                }
            }
            // } added by wspark
        }

        // { modified by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update //{ added by cychoi 2013.11.27 for ITS 211173
        onCurrentIndexChanged:
        {
            // { modified by cychoi 2013.12.10 for UX for Jog HK { modified by yungi  2013.12.05 for ITS 211269
            if(grid.model.get(grid.currentIndex).dim_color)
            {
                if(currentIndex == 9) // "Done"
                {
                    switch(is_jog_event)
                    {
                        case CONST.const_JOG_EVENT_ARROW_UP:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN:
                            currentIndex-=3
                            break
                        case CONST.const_JOG_EVENT_ARROW_LEFT:
                            currentIndex++
                            break
                        case CONST.const_JOG_EVENT_ARROW_RIGHT:
                            // Should not happen
                            break
                        // { added by yungi 2014.02.14 for ITS 225174
                        case CONST.const_JOG_EVENT_ARROW_UP_LEFT:
                            // Should not happen
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
                        //{ added by cychoi 2013.12.01 for Move focus to default if disabled has focus
                        default:
                            if(video_model.inputText == "")
                                currentIndex = 0
                            break;
                        //} added by cychoi 2013.12.01
                    }
                }
                else if(currentIndex == 11) // "Delete"
                {
                    switch(is_jog_event)
                    {
                        case CONST.const_JOG_EVENT_ARROW_UP:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN:
                            currentIndex-=3
                            break
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
                            // Should not happen
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
                            currentIndex = 0
                            break
                        //{ added by cychoi 2013.12.01 for Move focus to default if disabled has focus
                        default:
                            if(video_model.inputText == "")
                                currentIndex = 0
                            break;
                        //} added by cychoi 2013.12.01
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
                //                    currentIndex = 11
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
            // } modified by cychoi 2013.12.10 // } modified by yungi  2013.12.05

            visualCueState() //added by yungi  2013.12.05 for ITS 211269
            is_jog_event = -1 // added by cychoi 2014.01.23 for ITS 222055
        }
        // } modified by yungi

        // { modified by cychoi 2014.01.23 for ITS 222055
        //onFocus_visibleChanged:
        //{
        //    if(focus_visible && bNumDisabled == true)
        //    {
        //        if(grid.currentIndex < 9 || grid.currentIndex == 10)
        //            grid.currentIndex = 9 // "Done"
        //    }
        //}
        // } modified by cychoi 2014.01.23
        // { added by wspark 2014.01.29 for ITS 223306
        onFocus_visibleChanged:
        {
            if(!focus_visible)
            {
                for(var i=0;i<12;i++)
                {
                    grid_model.setProperty(i,"jog_pressed",false)
                }
            }
        }
        // } added by wspark
    }

    // { added by cychoi 2013.12.18 ITS 216318
    function handleOnMousePressed(curIndex)
    {
        grid.model.get(curIndex).mouse_pressed = true
    }

    function handleOnMouseReleased()
    {
        for(var i = 0; i < grid.model.count; i++)
        {
            if(grid.model.get(i).mouse_pressed == true)
            {
                grid.model.get(i).mouse_pressed = false
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
            id: gridItem

            width: 174
            height:130

            Image
            {
                id: itemIcon_n

                anchors.horizontalCenter: gridItem.horizontalCenter
                anchors.verticalCenter:   gridItem.verticalCenter
                source: icon_n
                opacity: (dim_color == false) ? 1.0 : 0.5 // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            }

            Image
            {
                id: bgSelected
                source: "/app/share/images/settings/btn_search_num_f.png"
                visible: (index == grid.currentIndex) && (main_rect.bPopupShown == false) // added by cychoi 2013.12.28 for ITS 217548
            }

            Image
            {
                id: bgPressed
                source: "/app/share/images/settings/btn_search_num_fp.png"
                // { modified by cychoi 2013.12.18 ITS 216318
                visible: ((gridItemMouse.pressed && mouse_pressed) || jog_pressed) && (dim_color == false) && (main_rect.bPopupShown == false) // added by cychoi 2013.12.28 for ITS 217548 // modified by cychoi 2013.11.27 for ITS 211173
                // } modified by cychoi 2013.12.18
            }

            Image
            {
                id: itemIcon

                anchors.horizontalCenter: gridItem.horizontalCenter
                anchors.verticalCenter:   gridItem.verticalCenter
                source: icon
                opacity: (dim_color == false) ? 1.0 : 0.5 // added by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update
            }

            Text
            {
                id: gridItemText

                anchors.horizontalCenter: gridItem.horizontalCenter
                anchors.verticalCenter:   gridItem.verticalCenter

                color: dim_color ? CONST.const_FONT_COLOR_DIMMED_GREY : "#FAFAFA" // modified by cychoi 2013.11.27 for ITS 211173
                font.family: CONST.const_FONT_FAMILY_NEW_HDB
                font.pointSize: font_size
                text: qsTranslate(CONST.const_LANGCONTEXT, name) // modified by cychoi 2013.12.03 for New UX 
            }

            MouseArea
            {
                id: gridItemMouse

                anchors.fill: parent
                beepEnabled: false // added by cychoi 2013.11.27 for ITS 211173

                // { added by cychoi 2013.12.18 ITS 216318
                onPressed:
                {
                    if(grid.model.get(index).dim_color == false)
                    {
                        if(!grid.focus_visible){
                            main_rect.lostFocusHandle(UIListenerEnum.JOG_DOWN)
                            main_rect.setDefaultFocus(UIListenerEnum.JOG_DOWN)
                            grid.currentIndex = index
                        }
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
                // } added by cychoi 2013.12.18
                
                onClicked:
                {
                    //{ modified by cychoi 2013.11.27 for ITS 211173
                    if(grid.model.get(index).dim_color == false)
                    {
                        UIListener.ManualBeep()
                        grid.currentIndex = index
                        controller.onKeyEntered(grid.model.get(grid.currentIndex).item_value)
                    }
                    //} modified by cychoi 2013.11.27
                    input_lang_list.focus_visible = false
                }

                // { added by wspark 2014.01.24 for ITS 222575
                onPressAndHold:
                {                    
                    if(grid.model.get(index).dim_color == false && grid.model.get(index).item_value == "Delete")
                    {
                        UIListener.ManualBeep()
                        grid.currentIndex = index
                        controller.deleteAllInputText()
                    }
                    input_lang_list.focus_visible = false
                }
                // } added by wspark
            }
            
            // { modified by cychoi 2013.12.03 for New UX 
            Connections
            {
                target: EngineListenerMain
            
                onRetranslateUi:
                {
                    gridItemText.text = qsTranslate(CONST.const_LANGCONTEXT, name)
                    main_rect.updateDelButton();
                }
            }
            // } modified by cychoi 2013.12.03
        }
    }


    ListModel
    {
        id:grid_model


        ListElement
        {
            name: "1"
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "1"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 50
        }
        ListElement
        {
            name: "2"
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "2"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 50
        }
        ListElement
        {
            name: "3"
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "3"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 50
        }
        ListElement
        {
            name: "4"
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "4"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 50
        }
        ListElement
        {
            name: "5"
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "5"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 50
        }
        ListElement
        {
            name: "6"
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "6"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 50
        }
        ListElement
        {
            name: "7"
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "7"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 50
        }
        ListElement
        {
            name: "8"
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "8"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 50
        }
        ListElement
        {
            name: "9"
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "9"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 50
        }
        ListElement
        {
            name: "Done"
            icon_n: "/app/share/images/settings/btn_search_done_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "Done"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 40 //50 //modified by Michael.Kim 2013.07.20 for New UX
        }
        ListElement
        {
            name: "0"
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: ""
            item_value: "0"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 50
        }
        ListElement
        {
            name: ""
            icon_n: "/app/share/images/settings/btn_search_num_n.png" //added by Michael.Kim 2013.07.23 for New UX
            icon: "/app/share/images/bt_phone/icon_dial_del.PNG"
            item_value: "Delete"
            jog_pressed: false
            mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
            dim_color : false // added by cychoi 2013.11.27 for ITS 211173
            font_size: 40 // modified by cychoi 2013.12.03 for New UX 
        }
    }
}
// } modified by Sergey 20.07.2013
