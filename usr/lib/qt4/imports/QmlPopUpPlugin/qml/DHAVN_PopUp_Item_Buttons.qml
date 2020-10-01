import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES


/** Buttons */
Column
{
    id: btnArea

    /** --- Input parameters --- */
    property ListModel btnModel: ListModel {}

    property bool focus_visible: false
    property int focus_id: -1
    property int focus_index: 0
    property string popupType//:CONST.const_POPUPTYPE_A
    property string __fontFamily

    /** --- Signals --- */
    signal lostFocus( int arrow, int focusID );
    signal stopPopupTimer_(variant btnId)
    signal restartPopupTimer_(variant btnId)

    // SANGWOO_TEMP
    signal resetTimerPopupButton()
//    onFocus_visibleChanged:
//    {
//        console.log("onFocus_VisibleChanged")
//        btnArea.focus_index = 0
//    }

    function setDefaultFocus( arrow )
    {
        var ret = btnModel.count ? focus_id : -1
        if ( ret == -1 ) lostFocus( arrow, focus_id )
        return ret
    }

    function doJogNavigation( arrow, status )
    {
        switch(status)
        {
        case UIListenerEnum.KEY_STATUS_PRESSED:
            switch(arrow)
            {
            //case UIListenerEnum.JOG_UP:
            case UIListenerEnum.JOG_WHEEL_LEFT:
                if( focus_index > 0 ){
                    focus_index--;
                     resetTimerPopupButton() 
                }
                break;
            //case UIListenerEnum.JOG_DOWN:
            case UIListenerEnum.JOG_WHEEL_RIGHT:
                if( focus_index < btnModel.count - 1 ){
                    focus_index++;
                    resetTimerPopupButton() 
                }
                break;
            case UIListenerEnum.JOG_LEFT:
                btnArea.lostFocus( arrow, focus_id )
                break;
            }
            break;
        case UIListenerEnum.KEY_STATUS_RELEASED:
//            switch(arrow)
//            {
////            //case UIListenerEnum.JOG_UP:
////            case UIListenerEnum.JOG_WHEEL_LEFT:
////                if( focus_index > 0 )
////                    focus_index--;
////                break;
////            //case UIListenerEnum.JOG_DOWN:
////            case UIListenerEnum.JOG_WHEEL_RIGHT:
////                if( focus_index < btnModel.count - 1 )
////                    focus_index++;
////                break;
////            case UIListenerEnum.JOG_LEFT:
////                btnArea.lostFocus( arrow, focus_id )
////                break;
//            }

            break;
        }

    } // doJogNavigation

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal focusHide(variant btnId )

    Connections
    {
        target: focus_visible ? UIListener : null
        onSignalJogNavigation: { doJogNavigation( arrow, status ); }
        onSignalPopupJogNavigation: { doJogNavigation( arrow, status ); }
    }

/** --- Private property --- */
// ============================
    /** --- Images for buttons --- */
    property variant __btnImageN:getResourceN(btnModel.count)
    property variant __btnImageP:getResourceP(btnModel.count)
    property variant __btnImageF:getResourceF(btnModel.count)


    /** --- Object property --- */
    visible: buttons.count
    anchors.horizontalCenter: parent.horizontalCenter
//    spacing: CONST.const_BUTTON_SPACING

    /** --- Child object --- */
    Repeater
    {
        id: bthRepeater
        model: btnModel

        DHAVN_PopUp_Item_Button
        {
            id:btnItem

            bg_img_n: __btnImageN[ index ]
            bg_img_p: __btnImageP[ index ]
            bg_img_f: __btnImageF[ index ]
            caption: msg
            btnId: btn_id
            _fontFamily:__fontFamily
            bFocused: ( btnArea.focus_index == index ) && btnArea.focus_visible
            count: buttons.count
            onBtnClicked: {
                btnArea.btnClicked( btnId )
                btnArea.focus_index = index
            }
            onFocusHide: {btnArea.focusHide(btnId ) }
            onBtnPressed: { /*btnArea.focus_index = index*//*btnArea.btnPressed(btnId)*/ }
            onStopPopupTimer:  {
                console.log("[SystemPopUp] DHAVN_PopUp_Item_Buttons onStopPopUpTimer")
                stopPopupTimer_( btnId)
            }
            onRestartPopupTimer: {
                console.log("[SystemPopUp] DHAVN_PopUp_Item_Buttons onRestartPopupTimer")
                restartPopupTimer_(btnId)
            }
        }

    }
    function getResourceN(num)
    {
        switch(popupType)
        {
            case RES.const_POPUP_TYPE_A:
            case RES.const_POPUP_TYPE_D:
            {
                switch(num){
                case 1:
                    return  [ RES.const_POPUP_A_01_BUTTON_N ]
                case 2:
                    return [RES.const_POPUP_A_02_01_BUTTON_N,
                            RES.const_POPUP_A_02_02_BUTTON_N]
                }
                break;
            }
            case RES.const_POPUP_TYPE_B:
            case RES.const_POPUP_TYPE_E:
            {
                switch(num){
                case 1:
                    return  [ RES.const_POPUP_B_01_BUTTON_N ]
                case 2:
                    return [RES.const_POPUP_B_02_01_BUTTON_N,
                            RES.const_POPUP_B_02_02_BUTTON_N]
                case 3:
                    return [RES.const_POPUP_B_03_01_BUTTON_N,
                            RES.const_POPUP_B_03_02_BUTTON_N,
                            RES.const_POPUP_B_03_03_BUTTON_N]
                case 4:
                    return [RES.const_POPUP_B_04_01_BUTTON_N,
                            RES.const_POPUP_B_04_02_BUTTON_N,
                            RES.const_POPUP_B_04_03_BUTTON_N,
                            RES.const_POPUP_B_04_04_BUTTON_N]
                }
                break;
            }
            case RES.const_POPUP_TYPE_ETC_01:
                return [RES.const_POPUP_ETC01_02_01_BUTTON_N,
                        RES.const_POPUP_ETC01_02_02_BUTTON_N]
        }
    }


    function getResourceP(num)
    {
        switch(popupType)
        {
            case RES.const_POPUP_TYPE_A:
            case RES.const_POPUP_TYPE_D:
            {
                switch(num){
                case 1:
                    return  [ RES.const_POPUP_A_01_BUTTON_P ]
                case 2:
                    return [RES.const_POPUP_A_02_01_BUTTON_P,
                               RES.const_POPUP_A_02_02_BUTTON_P]
                }
                break;
            }
            case RES.const_POPUP_TYPE_B:
            case RES.const_POPUP_TYPE_E:
            {
                switch(num){
                case 1:
                    return  [ RES.const_POPUP_B_01_BUTTON_P ]
                case 2:
                    return [RES.const_POPUP_B_02_01_BUTTON_P,
                              RES.const_POPUP_B_02_02_BUTTON_P]
                case 3:
                    return [RES.const_POPUP_B_03_01_BUTTON_P,
                                RES.const_POPUP_B_03_02_BUTTON_P,
                                RES.const_POPUP_B_03_03_BUTTON_P]
                case 4:
                    return [RES.const_POPUP_B_04_01_BUTTON_P,
                                RES.const_POPUP_B_04_02_BUTTON_P,
                                RES.const_POPUP_B_04_03_BUTTON_P,
                                RES.const_POPUP_B_04_04_BUTTON_P]
                }
                break;
            }
            case RES.const_POPUP_TYPE_ETC_01:
                return [RES.const_POPUP_ETC01_02_01_BUTTON_P,
                        RES.const_POPUP_ETC01_02_02_BUTTON_P]
        }
    }
    function getResourceF(num)
    {
        switch(popupType)
        {
            case RES.const_POPUP_TYPE_A:
            case RES.const_POPUP_TYPE_D:
            {
                switch(num){
                case 1:
                    return  [ RES.const_POPUP_A_01_BUTTON_F ]
                case 2:
                    return [RES.const_POPUP_A_02_01_BUTTON_F,
                               RES.const_POPUP_A_02_02_BUTTON_F]
                }
                break;
            }
            case RES.const_POPUP_TYPE_B:
            case RES.const_POPUP_TYPE_E:
            {
                switch(num){
                case 1:
                    return  [ RES.const_POPUP_B_01_BUTTON_F ]
                case 2:
                    return [RES.const_POPUP_B_02_01_BUTTON_F,
                              RES.const_POPUP_B_02_02_BUTTON_F]
                case 3:
                    return [RES.const_POPUP_B_03_01_BUTTON_F,
                                RES.const_POPUP_B_03_02_BUTTON_F,
                                RES.const_POPUP_B_03_03_BUTTON_F]
                case 4:
                    return [RES.const_POPUP_B_04_01_BUTTON_F,
                                RES.const_POPUP_B_04_02_BUTTON_F,
                                RES.const_POPUP_B_04_03_BUTTON_F,
                                RES.const_POPUP_B_04_04_BUTTON_F]
                }
                break;
            }
            case RES.const_POPUP_TYPE_ETC_01:
                return [RES.const_POPUP_ETC01_02_01_BUTTON_F,
                        RES.const_POPUP_ETC01_02_02_BUTTON_F]

        }
    }


}
