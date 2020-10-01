import QtQuick 1.1
import "DHAVN_MP_PopUp_Resources.js" as RES
import "DHAVN_MP_PopUp_Constants.js" as CONST
import AppEngineQMLConstants 1.0
//import PopUpConstants 1.0  remove by edo.lee 2013.01.26
import "DHAVN_MP_PopUp_Constants.js" as EPopUp //added by edo.lee 2013.01.26

Item
{
    id: popupbase

    width: CONST.const_DISPLAY_WIDHT
    height: CONST.const_DISPLAY_HEIGTH

    LayoutMirroring.enabled: EngineListenerMain.middleEast
    LayoutMirroring.childrenInherit: EngineListenerMain.middleEast

    /** --- Input parameters --- */
    property string title
    property string type
    property int icon_title: EPopUp.NONE_ICON
    property bool enableCloseBtn: false
    property string fontFamily

    property bool focus_visible: ( focus_index == 1 ) && focus_visible
    property int focus_id: -1
    property bool is_focusable: true
    property int focus_index: 0

    property int offset_y: 0

    /** --- Signals --- */
    signal closeBtnClicked()
    signal lostFocus( int arrow, int focusID );

    /** Focus interface functions */
    function hideFocus() { /*focus_visible = false*/ }
    function showFocus() { focus_visible = true }
    function handleJogEvent( arrow, status ) {}
    function setDefaultFocus( arrow )
    {
        focus_id = 1
        return ( focus_index >= 0 ) ? focus_id : -1
    }

// modified by Dmitry 15.05.13
    function doJogNavigation( arrow, status )
    {
        switch(status)
        {
        case UIListenerEnum.KEY_STATUS_PRESSED:

            break;
        case UIListenerEnum.KEY_STATUS_RELEASED:

            break;
        }
    }
// modified by Dmitry 15.05.13

    function onRetranslateUi()
    {
    }

    /** --- Object property --- */
    Rectangle{
        // modified by aettie 20130611 for popup dimming
        y: 0 // added by cychoi 2013.06.10 for ITS 172874 popup dimming //modified by eugene.seo 2013.06.01

        anchors.fill: parent
        color: "black"//Qt.rgba( 0, 0, 0, 1 )
        //color:"blue"
        opacity:0.6 // youngsim.jo 20131216 DH Genesis_Guideline_Popup_v2.0.9
        visible:true

        MouseArea {
            anchors.fill: parent
            beepEnabled: false
        }
    }

    Connections
    {
        target: UIListener//focus_visible && ( focus_index == 0 ) ? UIListener : null
        onSignalJogNavigation: { doJogNavigation( arrow, status ); } //added by edo.lee 2013.01.22
        onSignalPopupJogNavigation: { doJogNavigation( arrow, status ); }
//        onRetranslateUi:{
//            fontFamily = getFont(languageId);
//            LocTrigger.retrigger();

//        }
    }

    function getFont(languageId)
    {
        switch(languageId)
        {
            case 3:
            case 4:
            case 5:
            {
                EngineListenerMain.qmlLog("DFHeiW5-A Font");
            return  "DFHeiW5-A";
            }
            default:
            {
                EngineListenerMain.qmlLog("HDB Font");
//                return "HDB";
                return "DH_HDB";
            }
        }
    }

    function getTopMargin()
    {
        switch(type)
        {
        case RES.const_POPUP_TYPE_A:
            return CONST.const_POPUPTYPE_A_TOP_MARGIN  +  offset_y
        case RES.const_POPUP_TYPE_B:
            return CONST.const_POPUPTYPE_B_TOP_MARGIN  +  offset_y
        case RES.const_POPUP_TYPE_C:
            return CONST.const_POPUPTYPE_C_TOP_MARGIN  +  offset_y
        case RES.const_POPUP_TYPE_D:
            return CONST.const_POPUPTYPE_D_TOP_MARGIN  +  offset_y
        case RES.const_POPUP_TYPE_E:
            return CONST.const_POPUPTYPE_E_TOP_MARGIN  +  offset_y
        case RES.const_POPUP_TYPE_F:
            return CONST.const_POPUPTYPE_F_TOP_MARGIN  +  offset_y
        case RES.const_POPUP_TYPE_G:
            return CONST.const_POPUPTYPE_G_TOP_MARGIN  +  offset_y
        case RES.const_POPUP_TYPE_ETC_01:
            return CONST.const_POPUPTYPE_ETC01_TOP_MARGIN + offset_y  -  offset_y
        }
    }

    function getLeftMargin()
    {
        switch(type)
        {
        case RES.const_POPUP_TYPE_A:
            return CONST.const_POPUPTYPE_A_LEFT_MARGIN
        case RES.const_POPUP_TYPE_B:
            return CONST.const_POPUPTYPE_B_LEFT_MARGIN
        case RES.const_POPUP_TYPE_C:
            return CONST.const_POPUPTYPE_C_LEFT_MARGIN
        case RES.const_POPUP_TYPE_D:
            return CONST.const_POPUPTYPE_D_LEFT_MARGIN
        case RES.const_POPUP_TYPE_E:
            return CONST.const_POPUPTYPE_E_LEFT_MARGIN
        case RES.const_POPUP_TYPE_F:
            return CONST.const_POPUPTYPE_F_LEFT_MARGIN
        case RES.const_POPUP_TYPE_G:
            return CONST.const_POPUPTYPE_G_LEFT_MARGIN
        case RES.const_POPUP_TYPE_ETC_01:
            return CONST.const_POPUPTYPE_ETC01_LEFT_MARGIN
        }
    }
}

