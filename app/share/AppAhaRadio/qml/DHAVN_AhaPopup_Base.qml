import Qt 4.7
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES
import AppEngineQMLConstants 1.0
//import PopUpConstants 1.0

Item
{
    id: popupbase

    /** --- Input parameters --- */
    property string title
    property string type
    //property int icon_title: EPopUp.NONE_ICON
    property bool enableCloseBtn: false
    property int widthImage: bgImage.width - 90
    property int heightImage: bgImage.height
    property string fontFamily

    property Item content

    property bool focus_visible: true
    property int focus_id: -1
    property bool is_focusable: true
    property int focus_index: 0

    property int offset_y: 0
    property int counter : PR.const_AHA_TIMER_COUNTER_MIN_VAL   //wsuk.kim 130906 loading animation change from gif to png.

    /** --- Signals --- */
    signal closeBtnClicked()
    signal lostFocus( int arrow, int focusID );

    /** Focus interface functions */
    function hideFocus() { /*focus_visible = false*/ }
    function showFocus() { focus_visible = true }
    function handleJogEvent( arrow, status ) {}
    function setDefaultFocus( arrow )
    {
        content.focus_id = 1
        focus_index = content.setDefaultFocus( arrow )
        return ( focus_index >= 0 ) ? focus_id : -1
    }

    function doJogNavigation( arrow, status )
    {
        switch(status)
        {
        //hsryu_0502_jog_control
        case UIListenerEnum.KEY_STATUS_RELEASED:
            focus_visible=true
            //focus_index=1
            popupbase.lostFocus( arrow, focus_id )
            break;
        }

    }

    /** --- Object property --- */
    Rectangle{
//wsuk.kim 131106 loading/fail popup move to AhaRadio.qml    y: -PR.const_AHA_ALL_SCREENS_TOP_OFFSET    //wsuk.kim 131101 status bar dimming during to display popup.   y: -153 //hsryu_0523_change_loading_pos
    width: PR.const_AHA_ALL_SCREEN_WIDTH
    height: PR.const_AHA_MAIN_SCREEN_HEIGHT
    color: "black"
    opacity:0.7
    visible:true

    MouseArea {
        anchors.fill: parent
        //beepEnabled: false
    }
}

    Connections
    {
        target: UIListener
        onSignalJogNavigation: { doJogNavigation( arrow, status ); }
        onSignalPopupJogNavigation: { doJogNavigation( arrow, status ); }
        onRetranslateUi:{
            fontFamily = getFont(languageId);
            LocTrigger.retrigger();

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
                return  "DFHeiW5-A";
            }
            default:
            {
                return "NewHDB";
            }
        }
    }

    Connections
    {
        target: content
        onLostFocus:
        {
            if ( arrow === UIListenerEnum.JOG_UP )
            {
               if ( enableCloseBtn ) focus_index = 0
            }
            else
            {
               popupbase.lostFocus( arrow, focus_id )
            }
        }
    }

    Image
    {
        id:bgImage

        source: type
        anchors{
            top:parent.top; topMargin: getTopMargin()
            left:parent.left; leftMargin: getLeftMargin()
        }
        function getTopMargin()
        {
            switch(type)
            {
            case PR_RES.const_APP_AHA_POPUP_TYPE_A:
                return PR.const_POPUPTYPE_A_TOP_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_B:
                return PR.const_POPUPTYPE_B_TOP_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_C:
                return 454  //wsuk.kim 131106 loading/fail popup move to AhaRadio.qml   PR.const_POPUPTYPE_C_TOP_MARGIN  +   138 //wsuk.kim 131101 status bar dimming during to display popup.
            case PR_RES.const_APP_AHA_POPUP_TYPE_D:
                return PR.const_POPUPTYPE_D_TOP_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_E:
                return PR.const_POPUPTYPE_E_TOP_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_F:
                return PR.const_POPUPTYPE_F_TOP_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_G:
                return PR.const_POPUPTYPE_G_TOP_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_ETC_01:
                return PR.const_POPUPTYPE_ETC01_TOP_MARGIN + offset_y
            }
        }

        function getLeftMargin()
        {
            switch(type)
            {
            case PR_RES.const_APP_AHA_POPUP_TYPE_A:
                return PR.const_POPUPTYPE_A_LEFT_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_B:
                return PR.const_POPUPTYPE_B_LEFT_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_C:
                return PR.const_POPUPTYPE_C_LEFT_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_D:
                return PR.const_POPUPTYPE_D_LEFT_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_E:
                return PR.const_POPUPTYPE_E_LEFT_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_F:
                return PR.const_POPUPTYPE_F_LEFT_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_G:
                return PR.const_POPUPTYPE_F_LEFT_MARGIN
            case PR_RES.const_APP_AHA_POPUP_TYPE_ETC_01:
                return PR.const_POPUPTYPE_ETC01_LEFT_MARGIN
            }
        }

        Text
        {
            text: title.substring(0, 4) == "STR_" ?
                        qsTranslate( PR.const_AHA_LANGCONTEXT + LocTrigger.empty, title ) :
                        title
            verticalAlignment: Text.AlignVCenter
            font.pointSize: PR.const_TITLE_TEXT_PT
            font.family: fontFamily
            height: PR.const_TITLE_MY * 2
            color: Qt.rgba(250/255, 250/255, 250/255, 1) // bright grey
            style: Text.Sunken
            anchors
            {
               left: parent.left;
               top: parent.top;
               leftMargin: /*icon_title != EPopUp.NONE_ICON ? 90 :*/ 55 }
        }

        Component.onCompleted :
        {
            content.parent = bgImage
            content.anchors.fill = bgImage
            content.clip = true

        }
    }
    Binding{ target: content; property: "focus_visible"; value: ( focus_index == 1 ) && focus_visible }
}

