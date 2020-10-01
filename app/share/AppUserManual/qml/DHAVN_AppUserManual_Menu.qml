import Qt 4.7
//import QmlOptionMenu 1.0
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0
import ManualMenuEnums 1.0

import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

DHAVN_OptionMenu_Base
//OptionMenu
{
    id: appUserManualMenu

    menumodel: EngineListener.optionMenuModel

    y: 93   // 92일 경우 option menu show 시 statusbar가 위로 살짝 올라감
    z: Dimensions.const_AppUserManual_Z_1000

    autoHiding: appUserManual.focusIndex == Dimensions.const_AppUserManual_OptionMenu_FocusIndex // true
    //autoHiding: true
    autoHideInterval: Dimensions.const_AppUserManual_OptionsMenu_AutoHide

    focus_id: Dimensions.const_AppUserManual_OptionMenu_FocusIndex
    focus_visible: ( appUserManual.focusIndex == Dimensions.const_AppUserManual_OptionMenu_FocusIndex )

    property int menuOptionFocus: -1

    property int setIndexValue: 0

    signal handleFocusChange()

    visible: focus_visible // false

    onTextItemSelect:
    {
        switch( itemId )
        {
        case MANUALMENU.OPTION_MANUAL_SEARCH:
            appUserManual.launchSearch( 1 );
            break;
        case MANUALMENU.OPTION_MANUAL_GOTO:
            appUserManual.tmpFocusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
            appUserManual.setKeyboardFocus()
            handleFocusChange()
            appUserManual.launchSearch( 2 );
            break;
        case MANUALMENU.OPTION_MANUAL_EXIT_SEARCH:
            appUserManual.tmpFocusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
            handleFocusChange()
            appUserManual.searchText = ""
            appUserManual.searchOKTextEnable( false )
            appUserManual.clearSearchLocation()
            appUserManual.setFullScreen( false )
            appUserManual.exitSearch()
            break;
        case MANUALMENU.OPTION_MANUAL_EXIT_ZOOM:
            appUserManual.tmpFocusIndex = Dimensions.const_AppUserManual_PDF_Screen_FocusIndex
            handleFocusChange()
            appUserManual.exitZoom()
            break;
        default:
            break;
        }
        setIndexValue = 1
        appUserManualMenu.visible = false;
        console.log(" Menu.qml :: onTextItemSelect = visible : false")
    }

    onIsHidden:
    {
        console.log(" Menu.qml :: onIsHidden")
//        if( setIndexValue == 0 )
//            handleFocusChange()
        setIndexValue = 0

        if ( !appUserManualMenu.visible )
            {
            return;
        }

        appUserManualMenu.visible = false;
        appUserManual.handleBackKey( true , false , false )
    }

    function hideMenu()
    {
        appUserManualMenu.hide()
    }

    function menuHandler( index )
    {
        console.log("Menu.qml : menuHandler index : ", index)
        createMenu( index );        

        if( menuOptionFocus == 1 )
        {
            menuOptionFocus = 0
            appUserManualMenu.setDefaultFocus( UIListenerEnum.JOG_DOWN )
        }

        appUserManualMenu.visible = true;
        console.log(" Menu.qml :: menuHandler = visible : true")
    }

    function createMenu( index )
    {
        console.log("Menu.qml : createMenu index : ", index)
        switch( index )
        {
        case 0:
            EngineListener.onSetOptionMenu( 0 )
            break;
        case 1:
            EngineListener.onSetOptionMenu( 1 )
            break;
        case 2:
            EngineListener.onSetOptionMenu( 2 )
            break;
        case 3:
            EngineListener.onSetOptionMenu(  1) //3 )
            break;
        default:
            break;
        }
    }

    function setFocus( toBeFocused )
    {
        console.log("Menu.qml : setFocus toBeFocused : ", toBeFocused)
        menuOptionFocus = toBeFocused
    }

    Connections
    {
        target: ( appUserManualMenu.focus_visible && !disable_popup.visible ) ? UIListener : null

        onSignalJogNavigation:
        {
        }
    }

    Component.onCompleted:
    {
    }
}
