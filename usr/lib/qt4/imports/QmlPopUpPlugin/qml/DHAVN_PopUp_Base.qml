import Qt 4.7
import QtQuick 1.1
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import AppEngineQMLConstants 1.0
import PopUpConstants 1.0
import QmlStatusBar 1.0

Item
{
    id: popupbase
    /** --- Input parameters --- */
    property string title
    property int title_size : 44
    property int content_size : 32
    property string title_font: "DH_HDB"
    property string type
    property int icon_title: EPopUp.NONE_ICON
    property bool enableCloseBtn: false
    property int widthImage: bgImage.width - 90
    property int heightImage: bgImage.height
    property string fontFamily: "DH_HDR"
    //property int countryVariant: UIListener.GetCountryVariantFromQML();
    property Item content
    property int langID: UIListener.GetLanguageFromQML()

    property bool focus_visible: true
    property int focus_id: -1
    property bool is_focusable: true
    property int focus_index: 0
    property bool statusbar_visible: false

    property int offset_y: 0
    property bool _useAnimation:false
    property bool startLoadingAnimation:false

    /** --- Signals --- */
    signal closeBtnClicked()
    signal closeByTouch()
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
        case UIListenerEnum.KEY_STATUS_PRESSED:
            focus_visible=true
            //focus_index=1
            popupbase.lostFocus( arrow, focus_id )
            break;
//        case UIListenerEnum.KEY_STATUS_PRESSED:
//            //focus_index=1
//            popupbase.lostFocus( arrow, focus_id )
//            break;
//        case UIListenerEnum.KEY_STATUS_RELEASED:
//            //focus_visible=true
//            break;
        }

    }



    /** --- Object property --- */
    Rectangle{
        id:id_DIM_Rect
        y: 0//statusBar.visible == true ? 93 : 350
        width: CONST.const_DISPLAY_WIDHT
        height:  CONST.const_DISPLAY_HEIGTH
        color: "black"//Qt.rgba( 0, 0, 0, 1 )
        //color:"blue"
        opacity:parent.type == RES.const_POPUP_TYPE_C || parent.type == RES.const_POPUP_TYPE_F ? 0 : 0.6
        visible:true
    }
    MouseArea {
        id: id_touch_filter
        y: 0//statusBar.visible == true ? 93 : 350
        width: CONST.const_DISPLAY_WIDHT
        height:  CONST.const_DISPLAY_HEIGTH
        beepEnabled: false
        enabled:parent.type == RES.const_POPUP_TYPE_C || parent.type == RES.const_POPUP_TYPE_F ? false : true
        onPressed: {
            console.log("[SystemPopUp] MouseArea onPressed!!!!!!!!!!!")
//            if( parent.type == RES.const_POPUP_TYPE_C || parent.type == RES.const_POPUP_TYPE_F ){
//                id_touch_filter.enabled=false;
//                popupbase.closeByTouch();
//                popupbase.btnClicked( 1 );
//            }
        }
        onReleased: {
            console.log("[SystemPopUp] MouseArea onReleased!!!!!!!!!!!")
        }
    }
    QmlStatusBar {
                         id: statusBar
                         x: 0; y: 0; z:10; width: 1280; height: 93
                         homeType: "button"
                         visible:false//statusbar_visible
                         middleEast: /*countryVariant == 4*/langID == 20 ? true : false
               }

    Connections
    {
        target: focus_visible && ( focus_index == 0 ) ? UIListener : null
        onSignalJogNavigation: { doJogNavigation( arrow, status ); }
        onSignalPopupJogNavigation: { doJogNavigation( arrow, status ); }
    }
    Connections
    {
        target: UIListener
        onSignalLanguageChanged:{
            popupbase.langID = lang;
             fontFamily = "DH_HDR"
            LocTrigger.retrigger();
        }
    }
    function getFont(languageId)
    {

        return "DH_HDR";
       /* switch(languageId)
        {
            case 3:
            case 4:
            //case 5:
            {
                console.log("DFHeiW5-A Font");
            return  "DH_HDR";
            }
            default:
            {
                console.log("DH_HDR  Font");
                return "DH_HDR";
            }
        }*/
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
    Rectangle{
        color:"transparent"
        anchors.horizontalCenter: id_DIM_Rect.horizontalCenter
        anchors.verticalCenter: id_DIM_Rect.verticalCenter
        anchors.verticalCenterOffset: getCenterOffset()
        function getCenterOffset()
        {
            switch(type)
            {
                case RES.const_POPUP_TYPE_C:
                    return 198;
                case RES.const_POPUP_TYPE_F:
                    return 173;
                default:
                    return 0;
            }
        }

//        clip:true

//        NumberAnimation on width { running: true; from: 10; to: 1280;  duration: 100 }
//        NumberAnimation on height { running: true; from: 10; to: 720;  duration: 170 }
        Image
        {
            id:bgImage
            source: type
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            scale: _useAnimation == true ? 0.8 : 1.0
            opacity: _useAnimation == true ? 0 : 1.0
            MouseArea{
                anchors.fill: parent
                beepEnabled: false
                visible:bgImage.source == RES.const_POPUP_TYPE_C || bgImage.source == RES.const_POPUP_TYPE_F ? true : false
                onReleased: {
                    UIListener.ManualBeep();
                    popupbase.closeByTouch()
                    popupbase.visible=false
                }
            }
            ParallelAnimation{
                id: id_PopAnimation
                SequentialAnimation
                {
                    PropertyAnimation {
                        target: bgImage
                        property: "scale"
                        to: 1.2
                        duration: 100
                    }
                    PropertyAnimation {
                        target:bgImage
                        property: "scale"
                        to: 1.0
                        duration: 100
                    }
                }
                PropertyAnimation {
                    id:id_FadeIn_ani
                    target: bgImage
                    property: "opacity"
                    to: 1.0
                    duration: 200
                }
                onRunningChanged: {
                    startLoadingAnimation=id_PopAnimation.running;
                }

//                onCompleted: {
//                    startLoadingAnimation=true;
//                }
            }
        onVisibleChanged: {
            console.log("[SystemPopUp] ################# popupBase BGImage visible change = " + bgImage.visible)
            if(bgImage.visible==true && _useAnimation == true)
                id_PopAnimation.running=true
            else
                id_PopAnimation.running=false
        }
            function getTopMargin()
            {
                switch(type)
                {
                case RES.const_POPUP_TYPE_A:
                    return CONST.const_POPUPTYPE_A_TOP_MARGIN
                case RES.const_POPUP_TYPE_B:
                    return CONST.const_POPUPTYPE_B_TOP_MARGIN
                case RES.const_POPUP_TYPE_C:
                    return CONST.const_POPUPTYPE_C_TOP_MARGIN
                case RES.const_POPUP_TYPE_D:
                    return CONST.const_POPUPTYPE_D_TOP_MARGIN
                case RES.const_POPUP_TYPE_E:
                    return CONST.const_POPUPTYPE_E_TOP_MARGIN
                case RES.const_POPUP_TYPE_F:
                    return CONST.const_POPUPTYPE_F_TOP_MARGIN
                case RES.const_POPUP_TYPE_G:
                    return CONST.const_POPUPTYPE_G_TOP_MARGIN
                case RES.const_POPUP_TYPE_ETC_01:
                    return CONST.const_POPUPTYPE_ETC01_TOP_MARGIN + offset_y
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


//            Image
//            {
//                id: icon
//                source: icon_title === EPopUp.LOADING_ICON ? RES.const_LOADING_IMG : ""
//                anchors{
//                    left: bgImage.left; leftMargin: buttons.count>0? CONST.const_TEXT_CENTERALIGN_LEFT_MARGIN+CONST.const_LOADING_LEFT_MARGIN : 57+439;
//                    top: bgImage.top; topMargin: CONST.const_LOADING_TOP_MARGIN
//                }
//                NumberAnimation on rotation { running: icon.visible; from: 0; to: 360; loops: Animation.Infinite; duration: 2400 }
//                //RotationAnimation {running: true; duration: 2000; direction: RotationAnimation.Clockwise; onCompleted: console.log("Loading animation is stopped!!!!!!!!!!!!!!!") }
//            }

            Text
            {
                text: title.substring(0, 4) == "STR_" ?
                            qsTranslate( CONST.const_LANGCONTEXT + LocTrigger.empty, title ) :
                            title
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter//langID != 20 ? Text.AlignLeft : Text.AlignRight
                font.pointSize: title_size
                font.family: title_font
                height: CONST.const_TITLE_MY * 2
                width:983
                color: Qt.rgba(250/255, 250/255, 250/255, 1) // bright grey
                style: Text.Sunken
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: icon_title != EPopUp.NONE_ICON ? 90 : 55 }
//                anchors
//                {
//                   left:
//                   top: parent.top;
//                   leftMargin:
//            }

            Component.onCompleted :
            {
                content.parent = bgImage
                //content.anchors.fill = bgImage
                content.top = bgImage.top
                content.left = bgImage.left
                content.right = bgImage.right
                content.bottom = bgImage.bottom


                content.clip = true
                //content.

            }
        }
    }
    Binding{ target: content; property: "focus_visible"; value: ( focus_index == 1 ) && focus_visible }

}

