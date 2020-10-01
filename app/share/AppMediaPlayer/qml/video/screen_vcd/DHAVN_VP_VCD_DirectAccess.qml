// { modified by Sergey 09.05.2013
import Qt 4.7
import QtQuick 1.1
import AppEngineQMLConstants 1.0

import "../components/listView"
import "../components"
import "../models"
import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../DHAVN_VP_RESOURCES.js" as RES //added by yungi 2013.09.05 for ITS 187311

DHAVN_VP_FocusedItem
{
    id: main

    width: CONST.const_SCREEN_WIDTH
    height: CONST.const_SCREEN_HEIGHT
    default_x:0
    default_y:0

    property bool east: EngineListenerMain.middleEast
    property int index_ok : 5 // added by yungi 2013.11.12 SmokeTest DirectAccess for MiddleEast
    property int index_delete : 11 // added by yungi 2013.11.12 SmokeTest DirectAccess for MiddleEast
    property bool bPopupShown: false // added by cychoi 2013.12.05 for ITS 213053
    //property bool bNumDisabled: false // added by cychoi 2014.01.23 for ITS 222055

    // { added by yungi 2013.11.06 for ITS 206837
    property bool bFocusOnTopMostRow : (grid.currentIndex == 0 || grid.currentIndex == 1 || grid.currentIndex == 2 ||
                                        grid.currentIndex == 3 || grid.currentIndex == 4 || grid.currentIndex == 5 ) ? true : false
    // { added by cychoi 2013.12.10 for UX for Jog HK
    property bool bFocusOnLeftMostCol: (grid.currentIndex == 0 || grid.currentIndex == 6) ? true : false
    property bool bFocusOnRightMostCol: (grid.currentIndex == 5 || grid.currentIndex == 11) ? true : false
    // } added by cychoi 2013.12.10
    //property bool bTempMode: false // commented by cychoi 2014.07.15 seperation isTempMode memeber variable // added by cychoi 2013.12.19 for ITS 215825 Default focus
    property int nLastIndex: 0 // added by cychoi 2014.01.08 for ITS 218624 keep input box & grid focus on DRS ON <-> OFF

    // { added by cychoi 2014.01.23 for ITS 222055
    function updateGridButton()
    {
        //if(video_model.index1 == "-" ||
        //   video_model.index2 == "-")
        //{
        //    bNumDisabled = false
        //}
        //else
        //{
        //    bNumDisabled = true
        //}
        //if(east)
        //{
        //    gridModel.setProperty(5,"dim_color",bNumDisabled)
        //    gridModel.setProperty(11,"dim_color",bNumDisabled)
        //}
        //else
        //{
        //    gridModel.setProperty(0,"dim_color",bNumDisabled)
        //    gridModel.setProperty(6,"dim_color",bNumDisabled)
        //}
        //gridModel.setProperty(1,"dim_color",bNumDisabled)
        //gridModel.setProperty(2,"dim_color",bNumDisabled)
        //gridModel.setProperty(3,"dim_color",bNumDisabled)
        //gridModel.setProperty(4,"dim_color",bNumDisabled)
        //gridModel.setProperty(7,"dim_color",bNumDisabled)
        //gridModel.setProperty(8,"dim_color",bNumDisabled)
        //gridModel.setProperty(9,"dim_color",bNumDisabled)
        //gridModel.setProperty(10,"dim_color",bNumDisabled)
        // { modified by yungi 2013.11.12 SmokeTest DirectAccess for MiddleEast
        gridModel.setProperty(index_ok,"dim_color",(video_model.index1 == "-") ? true : false)
        gridModel.setProperty(index_delete,"dim_color",(video_model.index1 == "-") ? true : false)
        // } modified by yungi
        //{ modified by cychoi 2013.12.01 for SmokeTest Should not focus to disabled
        if(grid.currentIndex == index_ok ||
           grid.currentIndex == index_delete)
        {
            if(video_model.index1 == "-")
                grid.currentIndex = east ? 1 : 0
        }
        //else
        //{
        //    if(bNumDisabled == true)
        //        grid.currentIndex = index_ok
        //}
        //} modified by cychoi 2013.12.01
    }
    // } added by cychoi 2014.01.23
    
    Connections
    {
        target: video_model
        onIndex1Changed:
        {
            updateGridButton() // modified by cychoi 2014.01.23 for ITS 222055
        }
        // { added by cychoi 2014.01.23 for ITS 222055
        //onIndex2Changed:
        //{
        //    updateGridButton()
        //}
        // } added by cychoi 2014.01.23
    }
    // } added by yungi

    //{ added by cychoi 2013.12.05 for ITS 213053
    Connections
    {
        target: VideoEngine

        onSystemPopupShow:
        {
            // { modified by yungi 2014.02.11 No CR Fixed Focus now show // { modified by yungi 2014.01.23 for ITS 221843
            if( disp == SM.disp)
                bPopupShown = bShown
            else
                bPopupShown = false
            // } modified by yungi 2014.02.11 // } modified by yungi 2014.01.23
        }

        onLocalPopupShow:
        {
            // { modified by yungi 2014.02.11 No CR Fixed Focus now show // { modified by yungi 2014.01.23 for ITS 221843
            if( disp == SM.disp)
                bPopupShown = bShown
            else
                bPopupShown = false
            // } modified by yungi 2014.02.11  // } modified by yungi 2014.01.23

            // { added by cychoi 2013.12.28 for ITS 217548
            if(bShown == false)
            {
                controller.setDefaultInputText()
            }
            // } added by cychoi 2013.12.28
        }
    }
    //} added by cychoi 2013.12.05

    // { added by yungi 2013.09.05 for ITS 187311
    Connections
    {
        target: controller

        onShowLockout:
        {
            // { added by cychoi 2014.01.08 for ITS 218624 keep input box & grid focus on DRS ON <-> OFF
            if(lockoutRect.visible != onShow) // modified by cychoi 2014.01.09 for ITS 218948
            {
                // { added by cychoi 2014.10.06 for ITS 249771 exception handling
                if(nLastIndex < 0)
                    nLastIndex = east ? 1 : 0
                // } added by cychoi 2014.10.06
                grid.currentIndex = nLastIndex
            }
            // } added by cychoi 2014.01.08
            lockoutRect.visible  = onShow;
        }

        // { commented by cychoi 2014.07.15 seperation isTempMode memeber variable // { added by cychoi 2013.12.19 for ITS 215825 Default focus
        //onSetDirectAccessUI:
        //{
        //    main.bTempMode = onTempMode
        //    EngineListenerMain.qmlLog("onSetDirectAccessUI bTempMode = " + main.bTempMode)
        //}
        // } commented by cychoi 2014.07.15 // } added by cychoi 2013.12.19
    }

    // { added by wspark 2014.02.10 for ITS 224249
    Connections
    {
        target: EngineListenerMain
        onClearInputText:
        {
            if(disp == SM.disp)
            {
                controller.setDefaultInputText()
                grid.currentIndex = east ? 1 : 0
                grid.hideFocus()
                main.setDefaultFocus(UIListenerEnum.JOG_DOWN)
            }
        }
    }
    // } added by wspark
    Rectangle
    {
        id: lockoutRect

        visible: false
        anchors.fill:parent
        color: "black"

        Image
        {
            id : lockoutImg
            anchors.left: parent.left
            anchors.leftMargin: 562
            anchors.top: parent.top
            anchors.topMargin: CONST.const_LOCKOUT_ICON_TOP_OFFSET
            source: RES.const_URL_IMG_LOCKOUT_ICON
        }

        Text
        {
            width: parent.width
            horizontalAlignment:Text.AlignHCenter
            anchors.top: lockoutImg.bottom
            text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_DISC_VCD_DRIVING_REGULATION") + LocTrigger.empty
            font.pointSize: 32//36 //modified by edo.lee 2013.05.24
            color: "white"
        }
    }
    // } added by yungi 2013.09.05 for ITS 187311

    // { added by cychoi 2013.11.18 for ITS 209813
    onVisibleChanged:
    {
        if (main.visible)
        {
            EngineListenerMain.qmlLog("VCD_DirectAccess_onVisibleChanged = " + visible + " TempMode : " +VideoEngine.isVideoTempMode() + " Local TempMode : " +VideoEngine.isLocalTempMode()/*main.bTempMode*/) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
            // { modified by cychoi 2013.12.19 for ITS 215825 Default focus
            if(VideoEngine.isVideoTempMode()==false || VideoEngine.isLocalTempMode()==false/*main.bTempMode==false*/) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
            {
                // { modified by cychoi 2014.01.08 for ITS 218624 keep input box & grid focus on DRS ON <-> OFF
                if((VideoEngine.isLocalTempMode()==true/*main.bTempMode==true*/) && // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
                   (EngineListenerMain.IsChangeToDriving() || EngineListenerMain.IsChangeToParking() || EngineListenerMain.getCamInFG())) // modified by wspark 2014.02.05 for ITS 223741
                {
                    nLastIndex = grid.currentIndex
                    return
                }

                controller.setDefaultInputText() // added by cychoi 2013.12.16 ITS 215825
                grid.currentIndex = east ? 1 : 0
                //{ modified by cychoi 2013.11.26 for SmokeTest Should not focus to disabled
                main.setDefaultFocus(UIListenerEnum.JOG_DOWN)
                //main.showFocus()
                //} modified by cychoi 2013.11.26
                // } modified by cychoi 2014.01.08
                // { modified by cychoi 2014.07.15 seperation isTempMode memeber variable
                VideoEngine.setLocalTempMode(true)
                //main.bTempMode = true
                // } commented by cychoi 2014.07.15
            }
            // } modified by cychoi 2013.12.19
        }
    }
    // } added by cychoi 2013.11.18

    onEastChanged:
    {
        // { modified by yungi 2013.11.12 SmokeTest DirectAccess for MiddleEast
        if(east)
        {
            if(gridModel.get(0).item_value == "1")
            {
                gridModel.move(5, 0, 1)
                gridModel.move(11, 6, 1)
            }
            index_ok = 0
            index_delete = 6
        }
        else
        {
            if(gridModel.get(0).item_value == "OK")
            {
                gridModel.move(0, 5, 1)
                gridModel.move(6, 11, 1)
            }
            index_ok = 5
            index_delete = 11
        }
        // } added by yungi
    }





    // ========================================== Sub elements =================================================
    // { modified by yungi 2013.09.05 for ITS 187311
    Image
    {
        id: trackNoBg
        source: "/app/share/images/video/bg_track_num.png"
        anchors.left: parent.left
        anchors.leftMargin: 528
        anchors.top: parent.top
        anchors.topMargin: 290
        Text
        {
           id: trackNo
           anchors.verticalCenter:  trackNoBg.verticalCenter
           anchors.horizontalCenter: trackNoBg.horizontalCenter
           text: video_model.index1 + video_model.index2
           color: "#FAFAFA"
           font.pointSize:120
           font.family:  CONST.const_FONT_FAMILY_NEW_HDR
           style: Text.Outline;
           styleColor: "#000000"
        }
    }
    // } modified by yungi 2013.09.05 for ITS 187311

    DHAVN_VP_FocusedGrid
    {
        id: grid
        width: 213*6
        height: 78*2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1
        anchors.left: parent.left
        anchors.leftMargin: 1
        cellWidth: 213
        cellHeight: 78
        name: "FocusedGrid"
        focus: true
        focus_x: 0
        focus_y: 0
        model: gridModel
        delegate: gridDelegate
        interactive: false

        //{ modified by yongkyun.lee 2013-07-20 for : ITS 180917
        onLostFocus:
        {
             EngineListenerMain.qmlLog("DirectAccess.qml:: onLostFocus ");
        }

        // { modified by yungi 2014.02.14 for ITS 225174 // { modified by yungi 2013.11.06 for ITS 206837
        onMoveCurrentIndex:
        {
            switch (direction)
            {
                case UIListenerEnum.JOG_UP:
                {
                    if(bFocusOnTopMostRow)
                        grid.lostFocus( UIListenerEnum.JOG_UP )
                    else
                        grid.currentIndex -= 6
                    break
                }
                case UIListenerEnum.JOG_DOWN:
                {
                    if(bFocusOnTopMostRow)
                        grid.currentIndex += 6
                    break
                }
                case UIListenerEnum.JOG_LEFT:
                {
                    if(bFocusOnLeftMostCol)
                        return
                    else
                        grid.currentIndex -= 1
                }
                case UIListenerEnum.JOG_RIGHT:
                {
                    if(bFocusOnRightMostCol)
                        return
                    else
                        grid.currentIndex += 1
                }
                case UIListenerEnum.JOG_TOP_RIGHT:
                {
                    if(bFocusOnRightMostCol || bFocusOnTopMostRow)
                        return
                    grid.currentIndex -= 5
                    break
                }
                case UIListenerEnum.JOG_BOTTOM_RIGHT:
                {
                    if(bFocusOnRightMostCol)
                        return
                    if(bFocusOnTopMostRow)
                        grid.currentIndex += 7
                    break
                }
                case UIListenerEnum.JOG_TOP_LEFT:
                {
                    if(bFocusOnLeftMostCol || bFocusOnTopMostRow)
                        return
                    grid.currentIndex -= 7
                    break
                }
                case UIListenerEnum.JOG_BOTTOM_LEFT:
                {
                    if(bFocusOnLeftMostCol)
                        return
                    if(bFocusOnTopMostRow)
                        grid.currentIndex += 5
                    break
                }
            }
        }
        // } modified by yungi 2014.02.14 for ITS 225174 // } modified by yungi 2013.11.06 //modified by yongkyun.lee 2013-07-20
        
// modified by Dmitry 15.05.13
        onJogSelected:
        {
            if((status == UIListenerEnum.KEY_STATUS_RELEASED || status == UIListenerEnum.KEY_STATUS_CANCELED) // modified by yungi 2013.10.23 for ITS 198052
                    && grid.model.get(grid.currentIndex).jog_pressed == true) // modified by sjhyun 2013.11.04 for ITS 206259
            {
                grid.model.setProperty(grid.currentIndex, "jog_pressed", false)
                controller.onVCDMenuItemPressed(grid.model.get(currentIndex).item_value);
            }
            else if(status == UIListenerEnum.KEY_STATUS_PRESSED)
            {
                grid.model.setProperty(grid.currentIndex, "jog_pressed", true)
            }
        }

        // { added by yungi 2013.11.08 for ITS 207748
        onCurrentIndexChanged:
        {
            if(grid.model.get(grid.currentIndex).dim_color)
            {
                // { modified by cychoi 2013.12.10 for UX for Jog HK
                // { modified by yungi 2013.11.29 for NoCR PBC Disabled Focus Not move Update // { modified by yungi 2013.11.12 SmokeTest DirectAccess for MiddleEast
                if(currentIndex == index_ok)
                {
                    switch(is_jog_event)
                    {
                        case CONST.const_JOG_EVENT_ARROW_UP:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_LEFT:
                            if(main.east)
                                currentIndex++
                            break
                        case CONST.const_JOG_EVENT_ARROW_RIGHT:
                            if(!main.east)
                                currentIndex--
                            break
                        // { added by yungi 2014.02.14 for ITS 225174
                        case CONST.const_JOG_EVENT_ARROW_UP_LEFT:
                            if(main.east)
                                currentIndex = 7
                            break
                        case CONST.const_JOG_EVENT_ARROW_UP_RIGHT:
                            if(!main.east)
                                currentIndex = 10
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN_LEFT:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN_RIGHT:
                            // Should not happen
                            break
                        // } added by yungi 2014.02.14
                        case CONST.const_JOG_EVENT_WHEEL_LEFT:
                            if(main.east)
                                currentIndex = 11
                            else
                                currentIndex--
                            break
                        case CONST.const_JOG_EVENT_WHEEL_RIGHT:
                            currentIndex++
                            break
                        //{ added by cychoi 2013.12.01 for Move focus to default if disabled has focus
                        default:
                            if(video_model.index1 == "-")
                                currentIndex = east ? 1 : 0
                            break;
                        //} added by cychoi 2013.12.01
                    }
                }
                else if(currentIndex == index_delete)
                {
                    switch(is_jog_event)
                    {
                        case CONST.const_JOG_EVENT_ARROW_UP:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN:
                            // Should not happen
                            break
                        case CONST.const_JOG_EVENT_ARROW_LEFT:
                            if(main.east)
                                currentIndex++
                            break
                        case CONST.const_JOG_EVENT_ARROW_RIGHT:
                            if(!main.east)
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
                            if(main.east)
                                currentIndex = 1
                            break
                        case CONST.const_JOG_EVENT_ARROW_DOWN_RIGHT:
                            if(!main.east)
                                currentIndex = 4
                            break
                        // } added by yungi 2014.02.14
                        case CONST.const_JOG_EVENT_WHEEL_LEFT:
                            currentIndex--
                            break;
                        case CONST.const_JOG_EVENT_WHEEL_RIGHT:
                            main.east ? currentIndex++ : currentIndex = 0
                            break;
                        //{ added by cychoi 2013.12.01 for Move focus to default if disabled has focus
                        default:
                            if(video_model.index1 == "-")
                                currentIndex = east ? 1 : 0
                            break;
                        //} added by cychoi 2013.12.01
                    }
                }
                // } modified by yungi
                // } modified by cychoi 2013.12.10
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
                //                if(!main.east)
                //                {
                //                    if(currentIndex < 5)
                //                        currentIndex = index_ok
                //                    else if(currentIndex > 5)
                //                        currentIndex = index_delete
                //                }
                //                break
                //            case CONST.const_JOG_EVENT_ARROW_RIGHT:
                //                if(main.east)
                //                {
                //                    if(currentIndex < 6)
                //                        currentIndex = index_ok
                //                    else if(currentIndex > 6)
                //                        currentIndex = index_delete
                //                }
                //                break
                //            case CONST.const_JOG_EVENT_WHEEL_LEFT:
                //                if(main.east)
                //                {
                //                    if(currentIndex < 6)
                //                        currentIndex = index_ok
                //                    else if(currentIndex > 6)
                //                        currentIndex = index_delete
                //                }
                //                else
                //                {
                //                    if(currentIndex < 5)
                //                        currentIndex = index_delete
                //                    else if(currentIndex > 5)
                //                        currentIndex = index_ok
                //                }
                //                break;
                //            case CONST.const_JOG_EVENT_WHEEL_RIGHT:
                //                if(main.east)
                //                {
                //                    if(currentIndex < 6)
                //                        currentIndex = index_delete
                //                    else if(currentIndex > 6)
                //                        currentIndex = index_ok
                //                }
                //                else
                //                {
                //                    if(currentIndex < 5)
                //                        currentIndex = index_ok
                //                    else if(currentIndex > 5)
                //                        currentIndex = index_delete
                //                }
                //                break;
                //            default:
                //                currentIndex = index_ok
                //                break;
                //        }
                //    }
                //}
                // } added by cychoi 2014.01.23
            }

            is_jog_event = -1 // added by cychoi 2014.01.23 for ITS 222055
        }
        // } added by yungi

        // { modified by cychoi 2014.01.23 for ITS 222055
        //onFocus_visibleChanged:
        //{
        //    if(focus_visible && bNumDisabled == true)
        //    {
        //        if(grid.currentIndex != index_ok && grid.currentIndex != index_delete)
        //            grid.currentIndex = index_ok // "OK"
        //    }
        //}
        // } modified by cychoi 2014.01.23
    }
// modified by Dmitry 15.05.13

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
       id: gridDelegate

       Item
       {
           id: gridItem

           width: 213
           height: 78

           Image
           {
               id: bgNorm
               source: "/app/share/images/video/btn_direct_n.png"
           }

           Image
           {
               id: bgSelected
               source: "/app/share/images/video/btn_direct_f.png"
               visible: (index == grid.currentIndex) && (main.bPopupShown == false) // modified by cychoi 2013.12.05 for ITS 213053
           }

           Image
           {
               id: bgPressed
               source: "/app/share/images/video/btn_direct_fp.png"
               // { modified by cychoi 2013.12.18 ITS 216318
               visible: ((gridItemMouse.pressed && mouse_pressed) || jog_pressed) && (dim_color == false) && (main.bPopupShown == false) // modified by cychoi 2013.12.05 for ITS 213053 // modified by cychoi 2013.11.27 for ITS 211173
               // } modified by cychoi 2013.12.18
           }


           Text
           {
               id: gridItemText
               anchors.horizontalCenter: gridItem.horizontalCenter
               anchors.verticalCenter: gridItem.verticalCenter
               color: dim_color ? CONST.const_FONT_COLOR_DIMMED_GREY : "#FAFAFA" // modified by yungi 2013.11.06 for ITS 206837
               font.family: CONST.const_FONT_FAMILY_NEW_HDB
               font.pointSize: font_size
               text: qsTranslate(CONST.const_LANGCONTEXT, name)
           }

           MouseArea
           {
               id: gridItemMouse

               anchors.fill: parent
               //{ modified by yungi 2013.11.08 for ITS 207748
               beepEnabled: false

               // { added by cychoi 2013.12.18 ITS 216318
               onPressed:
               {
                   if(grid.model.get(index).dim_color == false)
                   {
                       //added by shkim for ITS 181234
                       if(!grid.focus_visible){
                           EngineListenerMain.qmlLog("[QML] VCD_DirctAccess :: !grid.focus_visible ");
                           main.lostFocusHandle(UIListenerEnum.JOG_DOWN)
                           main.setDefaultFocus(UIListenerEnum.JOG_DOWN)
                           grid.currentIndex = index
                       }
                       //added by shkim for ITS 181234
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
                   handleOnMouseReleased() // added by cychoi 2013.12.18 ITS 216318

                   //{ modified by cychoi 2013.12.18 //{ modified by cychoi 2013.12.01 for Hide focus if opened popup
                   if(grid.model.get(index).dim_color == false)
                   {
                       UIListener.ManualBeep()
                       grid.currentIndex = index
                       controller.onVCDMenuItemPressed(item_value)
                   }
                   //} modified by cychoi 2013.12.18 //} added by cychoi 2013.12.01
               }
               // } modified by yungi

               Connections
               {
                   target: EngineListenerMain

                   onRetranslateUi: gridItemText.text = qsTranslate(CONST.const_LANGCONTEXT, name)
               }
           }
       }
    }

    ListModel
    {
        id: gridModel

        ListElement
        {
           name: "1"
           item_value: "1"
           font_size: 46
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : false  // added by yungi 2013.11.06 for ITS 206837
        }

        ListElement
        {
           name: "2"
           item_value: "2"
           font_size: 46
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : false // added by yungi 2013.11.06 for ITS 206837
        }
        ListElement
        {
           name: "3"
           item_value: "3"
           font_size: 46
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : false // added by yungi 2013.11.06 for ITS 206837
        }
        ListElement
        {
           name: "4"
           item_value: "4"
           font_size: 46
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : false // added by yungi 2013.11.06 for ITS 206837
        }
        ListElement
        {
           name: "5"
           item_value: "5"
           font_size: 46
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : false // added by yungi 2013.11.06 for ITS 206837
        }
        ListElement
        {
           name: QT_TR_NOOP("STR_MEDIA_OK_BUTTON")
           item_value: "OK"
           font_size: 36
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : true // added by yungi 2013.11.06 for ITS 206837
        }
        ListElement
        {
           name: "6"
           item_value: "6"
           font_size: 46
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : false // added by yungi 2013.11.06 for ITS 206837
        }
        ListElement
        {
           name: "7"
           item_value: "7"
           font_size: 46
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : false // added by yungi 2013.11.06 for ITS 206837
        }
        ListElement
        {
           name: "8"
           item_value: "8"
           font_size: 46
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : false // added by yungi 2013.11.06 for ITS 206837
        }
        ListElement
        {
           name: "9"
           item_value: "9"
           font_size: 46
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : false // added by yungi 2013.11.06 for ITS 206837
        }
        ListElement
        {
           name: "0"
           item_value: "0"
           font_size: 46
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : false // added by yungi 2013.11.06 for ITS 206837
        }
        ListElement
        {
           name: QT_TR_NOOP("STR_MEDIA_MNG_DELETE")
           item_value: "Delete"
           font_size: 36
           jog_pressed: false
           mouse_pressed: false // added by cychoi 2013.12.18 ITS 216318
           dim_color : true // added by yungi 2013.11.06 for ITS 206837
        }
    }
}
// } modified by Sergey 09.05.2013
