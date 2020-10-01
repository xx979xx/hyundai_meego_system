import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_MP_PopUp_Constants.js" as CONST
import "DHAVN_MP_PopUp_Resources.js" as RES


/** Buttons */
Column
{
    id: btnArea

    width: btnItem.sourceSize.width
    /** --- Input parameters --- */
    property ListModel btnModel: ListModel {}
    property bool focus_visible: false
    property int focus_id: -1
    property int focus_index: 0
    property string popupType//:CONST.const_POPUPTYPE_A
    property int popup_id: -1 // added by cychoi 2015.09.15 for ITS 268801
    property string _connectionTarget:"UIListener" //added by suilyou 20140430
    /** --- Signals --- */
    signal lostFocus( int arrow, int focusID );

    // { modified by cychoi 2014.11.25 for ITS 244644 Popup button focus index (ITS 224751, ITS 225560, ITS 229126, ITS 233195)
    onVisibleChanged:
    {
        EngineListenerMain.qmlLog("buttons onVisibleChanged " + visible)
        if(visible == true)
        {
            if(EngineListenerMain.getCamInFG() == true || EngineListenerMain.isFrontLCDOff() == true)
            {
                // should keep focus index on Camera On or Display Off
                return
            }

            btnArea.focus_index = 0 // added by Sergey for DRM 30.07.2013 // removed by Michael.Kim 2014.02.13 for ITS 224751
        }
    }
    // } modified by cychoi 2014.11.25

    onFocus_visibleChanged:
    {
        EngineListenerMain.qmlLog("buttons onFocus_VisibleChanged")
        //btnArea.focus_index = 0 //removed by Michael.Kim 2014.02.17 for ITS 225560
    }
    
    // removed by cychoi 2014.11.25 for ITS 244644 Popup button focus index

    // { added by cychoi 2015.09.15 for ITS 268801
    onPopup_idChanged:
    {
        EngineListenerMain.qmlLog("buttons onPopup_idChanged " + popup_id)
        btnArea.focus_index = 0
    }
    // } added by cychoi 2015.09.15

    function setDefaultFocus( arrow )
    {
        var ret = btnModel.count ? focus_id : -1
        if ( ret == -1 ) lostFocus( arrow, focus_id )
        return ret
    }

// modified by Dmitry 15.05.13
    function doJogNavigation( arrow, status )
    {
        switch(status)
        {
            case UIListenerEnum.KEY_STATUS_RELEASED:
            {
	    //removed by aettie Focus moves when pressed 20131015
            //    switch(arrow)
             //   {
		// modified by ravikanth 28-09-13 for ITS 0184462
                /*case UIListenerEnum.JOG_UP:
		// modified by ravikanth 07-07-13 for ITS 0178184
                    if( focus_index > 0 )
                       {
                        focus_index--;
                       if(btnModel.get(focus_index).is_dimmed)
                           doJogNavigation(arrow,status)
                       }
                    break;
                case UIListenerEnum.JOG_DOWN:
                    if( focus_index < btnModel.count - 1 )
                       {
                        focus_index++;
                       if(btnModel.get(focus_index).is_dimmed)
                           doJogNavigation(arrow,status)
                       }
                    break;*/
                //}
                break;
            }

            case UIListenerEnum.KEY_STATUS_PRESSED:
            {
                switch(arrow)
                {
		////modified for CCP wheel direction for ME 20131024
                    case UIListenerEnum.JOG_LEFT:
                        btnArea.lostFocus( arrow, focus_id )
                        break;
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                        if( EngineListenerMain.middleEast )
                        {
                               if( focus_index < btnModel.count - 1 )
                               {
                                    focus_index++;
                                    if(btnModel.get(focus_index).is_dimmed)
                                        doJogNavigation(arrow,status)
                               }
                        }
                        else
                        {
                               if( focus_index > 0 )
                               {
                                    focus_index--;
                                    if(btnModel.get(focus_index).is_dimmed)
                                        doJogNavigation(arrow,status)
                               }
                        }
                        break;
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                        if( EngineListenerMain.middleEast )
                        {
                               if( focus_index > 0 )
                               {
                                    focus_index--;
                                    if(btnModel.get(focus_index).is_dimmed)
                                        doJogNavigation(arrow,status)
                               }
                        }
                        else
                        {
                               if( focus_index < btnModel.count - 1 )
                               {
                                    focus_index++;
                                    if(btnModel.get(focus_index).is_dimmed)
                                        doJogNavigation(arrow,status)
                               }
                        }
                        break;
                }
                break;
            }
            default:
              break;
        }

    } // doJogNavigation
// modified by Dmitry 15.05.13

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

    visible: buttons.count

    Repeater
    {
        id: bthRepeater
        model: btnModel       

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        DHAVN_MP_PopUp_Item_Button
        {
            id:btnItem

            anchors.left: parent.left

            is_dimmed: btnModel.get(index).is_dimmed // modified by ravikanth 07-07-13 for ITS 0178184
            bg_img_n: __btnImageN[ index ]
            bg_img_p: __btnImageP[ index ]
            bg_img_f: __btnImageF[ index ]
            caption: msg
            btnId: btn_id
            bFocused:( btnArea.focus_index == index ) && btnArea.focus_visible
            onBtnClicked: { btnArea.btnClicked( btnId ) }
            onFocusHide: {btnArea.focusHide(btnId ) }
            //    onBtnPressed: { btnArea.btnPressed(btnId) }
            connectionTarget: _connectionTarget // added by suilyou 02140430
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
