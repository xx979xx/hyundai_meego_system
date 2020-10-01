import QtQuick 1.1
import "DHAVN_AppFileManager_PopUp_Resources.js" as RES
import "DHAVN_AppFileManager_PopUp_Constants.js" as CONST
import AppEngineQMLConstants 1.0
import PopUpConstants 1.0

DHAVN_AppFileManager_FocusedItemNew
{
    id: popupbase
    node_id: 6

    width: CONST.const_DISPLAY_WIDHT
    height: CONST.const_DISPLAY_HEIGTH

    LayoutMirroring.enabled: EngineListener.middleEast
    LayoutMirroring.childrenInherit: EngineListener.middleEast

    /** --- Input parameters --- */
    property string title
    property string type
    property int icon_title: EPopUp.NONE_ICON
    property bool enableCloseBtn: false
    property string fontFamily

    property int focus_index: 0

    focus_visible: true
    property int focus_id: 0

    property int offset_y: 0

    /** --- Object property --- */
    Rectangle{
       y: 0

       anchors.fill: parent
       color: "black"//Qt.rgba( 0, 0, 0, 1 )
       //color:"blue"
       opacity:0.6
       visible:true

       MouseArea {
           anchors.fill: parent
           beepEnabled: false
       }
    }

    Connections
    {
       target: EngineListener
       onRetranslateUi:
       {
           fontFamily = getFont(langId);
       }
    }

    function getFont(languageId)
    {
        switch(languageId)
        {
            case 3:
            case 4:
            case 5:
            {
                EngineListener.qmlLog("DFHeiW5-A Font");
            return  "DFHeiW5-A";
            }
            default:
            {
                // { modified by sangmin.seol 2016.05.24 NOCR filemanger popup font is bold. change to regular for consistency
                EngineListener.qmlLog("HDR Font"/*"HDB Font"*/);
//modified by aettie.ji for ME font 20131015
                return "DH_HDR;"
                //return "DH_HDB";
                // } modified by sangmin.seol 2016.05.24
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

