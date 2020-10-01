// { modified by Sergey 09.10.2013 for ITS#188248
import Qt 4.7
import QtQuick 1.1
import AppEngineQMLConstants 1.0

import "../../DHAVN_VP_CONSTANTS.js" as CONST
import "../../DHAVN_VP_RESOURCES.js" as RES
import "../../components"


DHAVN_VP_FocusedItem
{
    id: main

    width: CONST.const_SCREEN_WIDTH
    height: CONST.const_SCREEN_HEIGHT

    LayoutMirroring.enabled: east
    LayoutMirroring.childrenInherit: east

    name: "FS_Captions"
    default_x: east ? 1 : 0
    default_y: 0
    focus_visible: true

    state: video_model.uiState


    property bool isLeftFocused: true
    property bool east: EngineListenerMain.middleEast



    states:
        [
        State
        {
            name: "CAPTION_VIEW"

            StateChangeScript
            {
                script:
                {
                    viewInfoText.visible = true;
                    radioListLoader.visible = false;
                    menuFrame.cueState = "upActive";
                }
            }
        },
        State
        {
            name: "CAPTION_LANG"

            StateChangeScript
            {
                script:
                {
                    viewInfoText.visible = false;
                    radioListLoader.visible = true;
                    radioListLoader.item.countDispalyedItems = 6;
                    radioListLoader.item.bFontSizePreview = false;
                    radioListLoader.item.bInteractive = true;// added for ITS 235039 2014.04.17
                }
            }
        },
        State
        {
            name: "CAPTION_FONT_SIZE"

            StateChangeScript
            {
                script:
                {
                    viewInfoText.visible = false;
                    radioListLoader.visible = true;
                    radioListLoader.item.countDispalyedItems = 3;
                    radioListLoader.item.bFontSizePreview = true;
                    radioListLoader.item.bInteractive = false;// added for ITS 235039 2014.04.17
                }
            }
        }
    ]





    // { commented by oseong.kwon 2014.06.26 for ITS 241442
    //onFocus_visibleChanged:
    //{
    //    if(!focus_visible)
    //        menuFrame.cueState = "downActive"
    //}
    // } commented by oseong.kwon 2014.06.26


    // { modified by Sergey 23.10.2013 for ITS#196877
    Connections
    {
        target: controller

        // onLoadingCompleted: main.initScreen();

        onInitScreen:
        {
            main.initScreen();
            default_x = east ? 1 : 0 // added by cychoi 2014.03.19 for ITS 230078
        }

        onSetDefaultFocus:
        {
            if(!main.focus_visible)
                SM.setFocusFromModeAreaToScreen();

            main.visible = true;
            main.setDefaultFocus(UIListenerEnum.JOG_DOWN);
            main.showFocus();
        }
    }
    // } modified by Sergey 23.10.2013 for ITS#196877


    Connections
    {
        target: menu

        onFocus_visibleChanged:
        {
            // To avoid double focus in left and right menues
            if(menu.focus_visible)
            {
                radioListLoader.hideFocus()

                menuFrame.state = "left"

                if(main.state == "CAPTION_VIEW")
                {
                    menuFrame.cueState = "upActive";
                    default_x = east ? 1 : 0 // added by cychoi 2014.03.19 for ITS 230078
                }
                else
                {
                    if(east)
                    {
                        menuFrame.cueState = "upleftActive";
                    }
                    else
                    {
                        menuFrame.cueState = "uprightActive";
                    }
                    default_x = east ? 1 : 0 // modified by oseong.kwon 2014.06.26 for ITS 241442 // added by cychoi 2014.03.19 for ITS 230078
                }
            }
            // { added by cychoi 2014.03.19 for ITS 230078
            else if(radioListLoader.focus_visible)
            {
                default_x = east ? 1 : 0 // modified by oseong.kwon 2014.06.26 for ITS 241442
            }
            // } added by cychoi 2014.03.19
        }

        // { added by cychoi 2014.12.22 for for ITS 223313
        onSignalItemFlicked:
        {
            if(!main.focus_visible)
            {
                SM.setFocusFromModeAreaToScreen();
            }
    
            main.moveFocusHandle((EngineListenerMain.middleEast ? 1 : -1), radioListLoader.focus_y)
    
            if(!menu.focus_visible) menu.showFocus()
        }
        // } added by cychoi 2014.12.22
    }


    Connections
    {
        target: radioListLoader

        onFocus_visibleChanged:
        {
            if(radioListLoader.focus_visible)
            {
                menuFrame.state = "right"
                if(east)
                {
                    menuFrame.cueState = "uprightActive";
                }
                else
                {
                    menuFrame.cueState = "upleftActive";
                }
                default_x = east ? 1 : 0 // modified by oseong.kwon 2014.06.26 for ITS 241442 // added by cychoi 2014.03.19 for ITS 230078
            }
            // { added by cychoi 2014.03.19 for ITS 230078
            else if(menu.focus_visible)
            {
                if(main.state == "CAPTION_VIEW")
                {
                    default_x = east ? 1 : 0
                }
                else
                {
                    default_x = east ? 1 : 0 // modified by oseong.kwon 2014.06.26 for ITS 241442
                }
            }
            // } added by cychoi 2014.03.19
        }
    }


    // { added by oseong.kwon 2014.06.26 for ITS 241442
    Connections
    {
        target: SM

        onSigModeAreaFocused:
        {
            if(focused)
            {
                menuFrame.cueState = "downActive"
		        if(main.state == "CAPTION_VIEW")
		            return;
                default_x = east ? 0 : 1
            }
        }
    }
    // } added by oseong.kwon 2014.06.26


    // { added by Sergey 23.10.2013 for ITS#196877
    Connections
    {
        target: radioListLoader.item

        onRadioItemSelected:
        {
            if(!main.focus_visible)
            {
                SM.setFocusFromModeAreaToScreen();
            }

            if(!radioListLoader.focus_visible)
            {
                main.moveFocusHandle((east ? -1 : 1), 0); // modified by Sergey 12.12.2013 for double focus issue
                radioListLoader.item.setFocusToSelectedItem();
                radioListLoader.showFocus();
            }
        }
        // { added by cychoi 2014.12.22 for visual cue animation on quick scroll
        onSignalRadioFocusIndexChanged:
        {
            menuFrame.currentFocusIndex = radioItem
        }
        // } added by cychoi 2014.12.22
    }
	// } added by Sergey 23.10.2013 for ITS#196877


    // =================================== FUNCTIONS ========================================================

    // { modified by Sergey 13.09.2013 for ITS#188762, 196877
    function initScreen()
    {
        menu.selected_item = 0;
        menu.menu_model.get(0).isChekedState = video_model.captionEnable;
        menu.menu_model.get(1).isDimmed = (!video_model.captionEnable || !video_model.multipleCaptions);
        menu.menu_model.get(2).isDimmed = (!video_model.captionEnable || !video_model.smiCaptions);
        video_model.uiState = "CAPTION_VIEW";
    }
    // } modified by Sergey 13.09.2013 for ITS#188762, 196877


    // { added by Sergey 23.10.2013 for ITS#196877
    function logger(str)  // modified by Sergey 16.11.2013 for ITS#209528
    {
        EngineListenerMain.qmlLog( "[QML]["+ main.name +"]: " + str );
    }
    // } added by Sergey 23.10.2013 for ITS#196877



    // =================================== SUB ELEMENTS ========================================================

	// { modified by Sergey 02.10.2013 for ITS#192280
    MouseArea
    {
    	anchors.fill: parent
		beepEnabled: false
    }
    // } modified by Sergey 02.10.2013 for ITS#192280

    //MouseArea { anchors.fill: parent }


    Image
    {
        id: mainBg
        source: RES.const_URL_DVD_SETTINGS_BG
    }

    Image
    {
        id: titleFrame

        z: main.z+2
        anchors.top: main.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: main.bottom
        anchors.left: main.left
        mirror: east
        visible: menuFrame.state != "right" // modified by cychoi 2014.03.19 for ITS 230078
        source: "/app/share/images/video/bg_menu_l_s.png"
    }

    // { added by cychoi 2014.03.19 for ITS 230078
    Image
    {
        id: titleFrameBG

        anchors.top: main.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: main.bottom
        anchors.left: main.left
        mirror: east
        visible: menuFrame.state != "right"
        source: "/app/share/images/video/bg_menu_l.png"
    }
    // } added by cychoi 2014.03.19

    Image
    {
        id: chapterFrame

        z: main.z+2
        anchors.top: main.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: main.bottom
        anchors.right: main.right
        mirror: east
        visible: menuFrame.state == "right" // modified by cychoi 2014.03.19 for ITS 230078
        source: "/app/share/images/video/bg_menu_r_s.png"
    }

    // { added by cychoi 2014.03.19 for ITS 230078
    Image
    {
        id: chapterFrameBG

        anchors.top: main.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.bottom: main.bottom
        anchors.right: main.right
        mirror: east
        visible: menuFrame.state == "right"
        source: "/app/share/images/video/bg_menu_r.png"
    }
    // } added by cychoi 2014.03.19



    DHAVN_VP_CueBg
    {
        id: menuFrame

        z: main.z + 3
        anchors.top: main.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET
        anchors.left: main.left
        anchors.right: main.right

        bVertical: true
        sVertArrow: main.focus_visible ? "up" : "down"
        cueState: "upActive"

        east: main.east

        currentFocusIndex : 0 // added by cychoi 2014.12.22 for visual cue animation on quick scroll
    }



    DHAVN_VP_Menu
    {
        id: menu

        anchors.top:  parent.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET - 5 // modified by Sergey 16.11.2013 for ITS#209528
        anchors.left: parent.left

        menu_model: list_model
        currentPageLoop: false // modified by Sergey 16.11.2013 for ITS#209528

        focus_x: east ? 1 : 0
        focus_y: 0

        property bool captionEnable: video_model.captionEnable
        property bool multipleCaptions: video_model.multipleCaptions
        property bool smiCaptions: video_model.smiCaptions

        onSmiCaptionsChanged:
        {
            list_model.get(2).isDimmed = (!captionEnable || !smiCaptions)
        }

        onMultipleCaptionsChanged:
            {
            list_model.get(1).isDimmed = (!captionEnable || !multipleCaptions)
            }

        onCaptionEnableChanged:
        {
            list_model.get(0).isChekedState = captionEnable
            list_model.get(1).isDimmed = (!captionEnable || !multipleCaptions)
            list_model.get(2).isDimmed = (!captionEnable || !smiCaptions)
        }

        ListModel
        {
            id: list_model

            Component.onCompleted:
            {
                list_model.append({"isCheckNA":true, "isDimmed":false, "isChekedState":menu.captionEnable,
                                  name:QT_TR_NOOP("STR_MEDIA_CAPTION_VIEW")})
                list_model.append({"isCheckNA":false, "isDimmed": (!menu.captionEnable || !menu.multipleCaptions), "isChekedState":false,
                                  name:QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG")})
                list_model.append({"isCheckNA":false, "isDimmed":(!menu.captionEnable || !menu.smiCaptions), "isChekedState":false,
                                  name:QT_TR_NOOP("STR_MEDIA_CAPTION_FONT_SIZE")})
            }
        }

        // { modified by Sergey 19.10.2013 for ITS#196877
        onItemFocused:
        {
            controller.onMenuItem(item);
            // { added by cychoi 2014.04.16 for ITS 234702
            if(!menu.focus_visible)
            {
                menu.showFocus();
            }
            // } added by cychoi 2014.04.16
            menuFrame.currentFocusIndex = item // added by cychoi 2014.12.22 for visual cue animation on quick scroll
        }

        onSelectItem:
        {
            if(item == 0)
                controller.onSetEnabledCaption(!list_model.get(0).isChekedState);

            controller.onMenuItem(item);

            // { added by Sergey 23.10.2013 for ITS#196877
            if(!main.focus_visible)
            {
                SM.setFocusFromModeAreaToScreen();
                main.showFocus();
            }
            // } added by Sergey 23.10.2013 for ITS#196877

        }
        // } modified by Sergey 19.10.2013 for ITS#196877

        onFocusMoved:
        {
            isLeftFocused = isMenuFocused
        }
    }



    DHAVN_VP_FocusedLoader
    {
        id: radioListLoader

        name: "CaptionFontSize"
        anchors.top: parent.top
        anchors.topMargin: CONST.const_CONTENT_AREA_TOP_OFFSET + 5 // modified by Sergey 16.11.2013 for ITS#209528
        anchors.left: parent.left
        anchors.leftMargin: 708 // modified by cychoi 2014.02.28 for UX & GUI fix

        focus_x: east ? 0 : 1
        focus_y: 0

        visible: false

        onVisibleChanged:
        {
            if ( ( visible ) && status != Loader.Ready )
            {
                source = "DHAVN_VP_FS_CaptionSizeList.qml"
            }
        }

        // { commented by cychoi 2014.02.21 for visual cue press animation
        //function handleJogEvent( event, status )
        //{
            // lost focus not triggred by focus loader. emit lost focus to move to mode area
            // remove below code if same is handled in caption list item in future
        //    if ( event === UIListenerEnum.JOG_UP  && status == UIListenerEnum.KEY_STATUS_RELEASED)
        //    {
        //        main.lostFocus( event, status);
        //    }
        //}
        // } commented by cychoi 2014.02.21
    }

    Text
    {
        id: viewInfoText

        width: CONST.const_FS_CAPTION_TEXT_WIDTH
        height: CONST.const_FS_CAPTION_TEXT_HEIGHT

        //anchors.top: main.top
        //anchors.topMargin: 350
        anchors.left: main.left
        anchors.leftMargin: 720
        anchors.verticalCenter: menu.verticalCenter

        text: qsTranslate(CONST.const_LANGCONTEXT,QT_TR_NOOP("STR_MEDIA_CAPTION_SETTING_TYPE_INFO"))+ LocTrigger.empty
        wrapMode: Text.WordWrap
        color: CONST.const_FONT_COLOR_BRIGHT_GREY
        font.family: CONST.const_FONT_FAMILY_NEW_HDR
        font.pointSize: CONST.const_FS_CAPTION_TEXT_SIZE
        horizontalAlignment: Text.Center
        verticalAlignment: Text.AlignVCenter //Text.Center
    }// modified by Hyejin 19.02.2014 for ITS#0225690

}
// } modified by Sergey 09.10.2013 for ITS#188248
