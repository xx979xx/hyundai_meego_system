import QtQuick 1.1
import QmlPopUpPlugin 1.0 as PopUps
import com.settings.variables 1.0
import com.settings.defines 1.0
import PopUpConstants 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES

DHAVN_AppSettings_FocusedItem{
    id: rootConnectivity
    name: "RootConnectivity"
    property int currentRegion : SettingsStorage.currentRegion

    //x: 0; y: 0;
    anchors.top: parent.top
    anchors.left: parent.left
    width: 1280; height: 554

    focus_x: 0
    focus_y: 0
    default_x: 0
    default_y: 0

    function init()
    {
        content_Connectivity.hideFocus()
        content_Connectivity.setFocusHandle(0,0)
        content_Connectivity.showFocus()
    }

    function setVisualCue(up, down, left, right)
    {
        visualCue.upArrow = up
        visualCue.downArrow = down
        visualCue.leftArrow = left
        visualCue.rightArrow = right
    }

    function getItemIndex(itemNumber)
    {
        var retVal = -1
        for(var index=0; index < connectivity_list_model.count; index++)
        {
            if(connectivity_list_model.get(index).itemNum == itemNumber)
            {
                retVal = index
                return retVal
            }
        }
        return retVal
    }

    function setRootState( index )
    {
        rootConnectivity.state = connectivity_list_model.get(index).nameOfState
    }

    function setVisualCueOnMenu( index )
    {
        switch (connectivity_list_model.get(index).itemNum)
        {
        case APP.const_SETTINGS_CONNECTIVITY_IOS                       : setVisualCue(true, false, true, false); visualCue.longkey_other = true;  break
        case APP.const_SETTINGS_CONNECTIVITY_ANDROID                  : setVisualCue(true, false, true, false); visualCue.longkey_other = true;  break

        }
    }

    function initialyseMenuItems()
    {
        //        for (var i = 0; i < connectivity_list_model.count; i++ )
        //        {
        //            if (connectivity_list_model.get(i).isCheckNA == true)
        //            {
        //                switch(connectivity_list_model.get(i).dbID)
        //                {
        //                case Settings.DB_KEY_APPROVAL:
        //                {
        //                    Connectivity_list_model.setProperty(i,"isChekedState",SettingsStorage.approval)
        //                }
        //                break;
        //                case Settings.DB_KEY_LOCKREARMONITOR_FUNCTION:
        //                {
        //                    Connectivity_list_model.setProperty(i,"isChekedState",SettingsStorage.rearLockScreen)
        //                }
        //                break;
        //                default:
        //                    //console.log("Connectivity.qml : DbID=>" + Connectivity_list_model.get(i).dbID + ", Reading Fail")
        //                    break;
        //                }
        //            }
        //        }
    }

    function setFocusCurrentMenu()
    {
        content_Connectivity.__current_x = 0
        content_Connectivity.__current_y = 0

        var index = content_Connectivity.searchIndex( content_Connectivity.__current_x, content_Connectivity.__current_y)
        content_Connectivity.__current_index = index

        content_Connectivity.setFocus(content_Connectivity.focus_x, content_Connectivity.focus_y)
    }

    DHAVN_AppSettings_FocusedItem{
        id: content_Connectivity
        anchors.fill:parent
        name: "content Connectivity"
        anchors.top: parent.top
        anchors.left: parent.left
        focus_x: 0
        focus_y: 0
        default_x: 0
        default_y: 0

        //property bool bLeftMenuFocused: false

        onFocus_visibleChanged:
        {
            if(focus_visible)
            {
                if(is_focused_BackButton)
                    connectivityMenu.moveFocus(1,0)

                is_focused_BackButton = false
            }
        }

        // Bg Border
        DHAVN_AppSettings_Cue_Bg_Main{
            id: idCueSettings
            property bool isRightBg:false
            z:1
        }

        Image{
            anchors.top: idCueSettings.top
            anchors.topMargin:73
            anchors.left: idCueSettings.left
            visible: (!idCueSettings.isRightBg) && (isBrightEffectShow)
            source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_L_BRIGHT
        }

        Image{
            anchors.top: idCueSettings.top
            anchors.topMargin:73
            anchors.left: idCueSettings.left
            visible: idCueSettings.isRightBg && (isBrightEffectShow)
            source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_R_BRIGHT
        }

        DHAVN_AppSettings_Menu{
            id: connectivityMenu

            property bool tempValue

            //x: 0; y: 73
            anchors.top: parent.top
            anchors.topMargin: 73
            anchors.right: parent.right
            menu_model: connectivity_list_model

            focus_x: 0
            focus_y: 0

            onSelectItem:
            {
                if(!bJog)
                {
                    content_Connectivity.hideFocus()
                    setFocusCurrentMenu()
                }

                setRootState(item)


                if(!bJog)
                {
                    moveFocus(1,0)

                    content_connectivity.showFocus()
                }
            }

            onCurrentIndexChanged:
            {
                setRootState(currentIndex)

                if(focus_visible)
                    rootConnectivity.setVisualCueOnMenu(currentIndex)

                if(currentIndex >= 0)
                    connectivityMenu.selected_item = currentIndex
            }

            onFocus_visibleChanged:
            {
                //content_general.bLeftMenuFocused = focus_visible
                if(focus_visible)
                {
                    idCueSettings.isRightBg = false
                    rootConnectivity.setVisualCueOnMenu(connectivityMenu.selected_item)
                }
            }

            onMovementEnded:
            {
                if(!focus_visible)
                {
                    content_Connectivity.hideFocus()
                    content_Connectivity.setFocusHandle(0,0)
                    if(isShowSystemPopup == false)
                    {
                        content_Connectivity.showFocus()
                    }
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: iOSSettings

            focus_x: 1
            focus_y: 0

            visible: rootConnectivity.state == APP.const_APP_SETTINGS_CONNECTIVITY_STATE_IOS
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready )
                    {
                        source = "DHAVN_AppSettings_Connectivity_iOS.qml"
                    }
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    iOSSettings.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = iOSSettings.focus_visible
                    connectivityMenu.hideFocus()
                }
            }
        }

        DHAVN_AppSettings_FocusedLoader{
            id: androidSettings

            focus_x: 1
            focus_y: 0

            visible: rootConnectivity.state == APP.const_APP_SETTINGS_CONNECTIVITY_STATE_ANDRIOID
            opacity: visible ? 1 : 0

            onVisibleChanged:
            {
                if ( visible )
                {
                    if( status != Loader.Ready ) source = "DHAVN_AppSettings_Connectivity_Android.qml"
                }
                else
                {
                    hideFocus()
                }
            }

            onStatusChanged:
            {
                if( status == Loader.Ready )
                    androidSettings.item.init()
            }

            onFocus_visibleChanged:
            {
                if(focus_visible)
                {
                    idCueSettings.isRightBg = androidSettings.focus_visible
                    connectivityMenu.hideFocus()
                }
            }
        }
    }

    ListModel{
        id: connectivity_list_model

        Component.onCompleted:
        {
            connectivity_list_model.append({"itemNum": APP.const_SETTINGS_CONNECTIVITY_ANDROID , "isCheckNA": false,  "isChekedState": false, "isDimmed": false, "isPopupItem":false, "dbID": 0,
                                          name: QT_TR_NOOP("STR_SETTING_CONNECTIVITY_MENU_ANDROID"),
                                          nameOfState: APP.const_APP_SETTINGS_CONNECTIVITY_STATE_ANDRIOID})
            connectivity_list_model.append({"itemNum": APP.const_SETTINGS_CONNECTIVITY_IOS , "isCheckNA": false,  "isChekedState": true, "isDimmed": false, "isPopupItem":false, "dbID": 0,
                                          name: QT_TR_NOOP("STR_SETTING_CONNECTIVITY_MENU_IOS"),
                                          nameOfState: APP.const_APP_SETTINGS_CONNECTIVITY_STATE_IOS})
            initialyseMenuItems()
        }
    }

    states:
        [
        State{
            name: APP.const_APP_SETTINGS_CONNECTIVITY_STATE_ANDRIOID
            PropertyChanges { target: connectivityMenu; selected_item: getItemIndex(APP.const_SETTINGS_CONNECTIVITY_ANDROID ) }
        },
        State{
            name:APP.const_APP_SETTINGS_CONNECTIVITY_STATE_IOS
            PropertyChanges { target: connectivityMenu; selected_item: getItemIndex(APP.const_SETTINGS_CONNECTIVITY_IOS ) }
        }
    ]


}

