import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_BottomArea.js" as BOTTOMAREA

Item {
    /* Incoming ListModel parameter */
    property ListModel btnModel
    property bool focus_visible: false
    property int focus_id: -1
    property bool is_focusable: true

    /** Signals */
    signal indepthBtnArea_clicked( variant btnId );
    signal lostFocus( int arrow, int focusID )

    /** Public function for Translate */
    function retranslateUI( context )
    {
        if ( context ) { __lang_context = context }
        __emptyString = " "
        __emptyString = ""
    }

    /** Focus interface functions */
    function hideFocus() { focus_visible = false }
    function showFocus() { focus_visible = true }
    function handleJogEvent( arrow, status ) {}
    function setDefaultFocus( arrow )
    {
        switch ( arrow )
        {
            case UIListenerEnum.JOG_WHEEL_RIGHT: { focus_index = 0 }
            case UIListenerEnum.JOG_WHEEL_LEFT: { focus_index = btnModel.count - 1 }
            default: { if ( focus_index < 0 ) focus_index = 0 }
        }
        return focus_id;
    }
/*----------------------------------------------------------------*/
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*----------------------------------------------------------------*/
/* ------------- Private mothods and functions ------------------ */
/*----------------------------------------------------------------*/

    onBtnModelChanged: focus_index = -1

    Connections
    {
        target: focus_visible ? UIListener : null
        onSignalJogCenterClicked: indepthBtnArea_clicked( btnModel.get( focus_index ).btnId )
        onSignalJogCenterPressed: button_pressed = true
        onSignalJogCenterReleased: button_pressed = false
        onSignalJogNavigation:
        {
//{modified by aettie.ji 2013.05.01 for Click event deletion (for Focus ->Pressed / for Action -> Released) 
//            if ( status == UIListenerEnum.KEY_STATUS_CLICKED )
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_LEFT:
                    case UIListenerEnum.JOG_RIGHT:
                    {break;}
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                    {
                        button_pressed = false
                        if ( focus_index == 0 )
                            indepth_btn_area.lostFocus( arrow, focus_id )
                        else
                            focus_index--

                        break;
                    }
                    //case UIListenerEnum.JOG_RIGHT:
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                    {
                        button_pressed = false
                        if ( focus_index == btnModel.count - 1 )
                            indepth_btn_area.lostFocus( arrow, focus_id )
                        else
                            focus_index++

                        break;
                    }
                    default: { indepth_btn_area.lostFocus( arrow, focus_id ); break; }
                } // modified by Dmitry 03.05.13
            }
        }
    }

    /** Private variables */
    property string __lang_context: BOTTOMAREA.const_WIDGET_LANGCONTEXT
    property string __emptyString: ""
    property int focus_index: -1
    property bool button_pressed: false

    id: indepth_btn_area


    width: BOTTOMAREA.const_WIDGET_WIDTH
    height: BOTTOMAREA.const_WIDGET_INDEPTH_HEIGTH
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    Row
    {
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater
        {
            model: btnModel;
            delegate:
            Image
            {
                id: btn_images

                source: bPressed || mouseArea.pressed ?
                                            BOTTOMAREA.const_WIDGET_INDBTN_IMG_PRESSED :
                                            BOTTOMAREA.const_WIDGET_INDBTN_IMG_NORMAL

                property bool bPressed: button_pressed && focus_visible && ( focus_index == index )

                /** Button text */
                Text
                {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: BOTTOMAREA.const_WIDGET_INDBTN_TEXT_TOP_MARGIN
                    color: BOTTOMAREA.const_WIDGET_INDBTN_TEXT_COLOR
                    font.pointSize: BOTTOMAREA.const_WIDGET_INDBTN_TEXT_SIZE
                    style: Text.Sunken
                    text: qsTranslate( __lang_context, name ) + indepth_btn_area.__emptyString
                }

                /** Focus image */
                Image
                {
                    anchors.centerIn: parent
                    source: ( focus_visible && ( focus_index == index ) ) ?
                                BOTTOMAREA.const_WIDGET_HIGHLIGHT_BTN : ""
                }

                MouseArea
                {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: indepth_btn_area.indepthBtnArea_clicked( btn_id )
                }
            }
        }
    }
}

