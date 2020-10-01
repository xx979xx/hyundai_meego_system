import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_BottomArea.js" as BOTTOMAREA

Image
{
    /* Incoming ListModel parameter */
    property ListModel btnModel
    property bool focus_visible: false
    property int focus_id: -1
    property bool is_focusable: true

    /** Signals */
    signal cmdBtnArea_clicked( variant btnId );
    signal cmdBtnArea_pressed( variant btnId );
    signal cmdBtnArea_pressedAndHold( variant btnId );
    signal cmdBtnArea_pressedAndHoldCritical( variant btnId );
    signal cmdBtnArea_released( variant btnId );
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
        var res = -1
        switch ( arrow )
        {
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
                focus_index = -1
                res = focusNext( arrow )
            }
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                focus_index = btnModel.count
                res = focusPrev( arrow )
            }
            default:
            {
                if ( focus_index >= 0 ) focus_index--;
                res = focusNext( arrow );
            }
        }
        return res;
    }

/*----------------------------------------------------------------*/
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*----------------------------------------------------------------*/
/* ------------- Private mothods and functions ------------------ */
/*----------------------------------------------------------------*/

    onBtnModelChanged: focus_index = -1

    function focusNext( dir )
    {
        for( var i = focus_index + 1; i < btnModel.count; i++ )
        {
            if ( btnModel.get( i ).is_dimmed == true )
            {
                continue
            }
            else
            {
                focus_index = i
                return focus_id
            }
        }

        cmd_btn_area.lostFocus( dir, focus_id );
        return -1;
    }

    function focusPrev( dir )
    {
        for( var i = focus_index - 1; i >= 0; i-- )
        {
            if ( btnModel.get( i ).is_dimmed == true )
            {
                continue
            }
            else
            {
                focus_index = i
                return focus_id
            }
        }

        cmd_btn_area.lostFocus( dir, focus_id );
        return -1
    }

    Connections
    {
        target: focus_visible ? UIListener : null
        onSignalJogCenterClicked: if ( focus_index >= 0 ) cmdBtnArea_clicked( btnModel.get( focus_index ).btn_id )
        onSignalJogCenterPressed:
        {
            button_pressed = true
            if ( focus_index >= 0 ) cmdBtnArea_pressed( btnModel.get( focus_index ).btn_id )
        }
        onSignalJogCenterReleased:
        {
            button_pressed = false
            if ( focus_index >= 0 ) cmdBtnArea_released( btnModel.get( focus_index ).btn_id )
        }
        onSignalJogCenterLongPressed: if ( focus_index >= 0 ) cmdBtnArea_pressedAndHold( btnModel.get( focus_index ).btn_id )
        onSignalJogCenterCriticalPressed: if ( focus_index >= 0 ) cmdBtnArea_pressedAndHoldCritical( btnModel.get( focus_index ).btn_id )
        onSignalJogNavigation:
        {
// modified by Dmitry 15.05.13
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_LEFT:
                    case UIListenerEnum.JOG_RIGHT:                    
                        break;
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                    {
                        button_pressed = false
                        focusPrev( arrow )
                        break;
                    }
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                    {
                        button_pressed = false
                        focusNext( arrow )
                        break;
                    }
                }
            }
            else if (status == UIListenerEnum.KEY_STATUS_RELEASED)
            {
               switch ( arrow )
               {
                  default:
                     cmd_btn_area.lostFocus( arrow, focus_id )
                     break;
               }
            }
        }
    }
// modified by Dmitry 15.05.13

    id: cmd_btn_area

    property int focus_index: -1
    anchors.bottom: parent.bottom
    source: BOTTOMAREA.const_WIDGET_CMDBTN_IMG_NORMAL
    property bool button_pressed: false
    property string __lang_context: BOTTOMAREA.const_WIDGET_LANGCONTEXT
    property string __emptyString: ""

    Row
    {
        id: bottomElements
        Repeater
        {
            model: btnModel
            delegate: btnDelegate
        }
    }

    Component
    {
        id: btnDelegate

        Image
        {
            width: btn_width + BOTTOMAREA.const_WIDGET_CMDBTN_BORDER_WIDHT
            height: BOTTOMAREA.const_WIDGET_CMDBTN_HEIGHT
            fillMode: Image.TileHorizontally
            source: ( ( bPressed || mouseArea.pressed ) && !is_dimmed ) ?
                        BOTTOMAREA.const_WIDGET_CMDBTN_IMG_PRESSED : ""

            property string icon_p: model.icon_p || ""
            property string icon_n: model.icon_n || ""
            property bool isHighlighted: false
            property bool isHoldButton: false
            property bool is_dimmed: model.is_dimmed || false
            property bool bPressed: button_pressed && focus_visible && ( focus_index == index )

            /** Icon image */
            Image
            {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: BOTTOMAREA.const_WIDGET_CMDBTN_ICON_OFFSET
                source: ( bPressed || mouseArea.pressed ) ?
                              ( model.icon_p || "" ) : ( model.icon_n || "" )
            }

            /** Focus image */
            Rectangle
            {
               anchors { left: parent.left; bottom: parent.bottom }
               width: btn_width
               height: BOTTOMAREA.const_WIDGET_CMDBTN_HEIGHT
               visible: ( focus_visible && ( focus_index == index ) )
               border { width: 5; color: BOTTOMAREA.const_WIDGET_BTN_FOCUS_COLOR }
               radius: 3
               gradient: Gradient
               {
                  GradientStop { position: 0.5; color: "transparent" }
                  GradientStop { position: 1.0; color: BOTTOMAREA.const_WIDGET_BTN_FOCUS_COLOR }
               }
               smooth: true
            }

            /** Button text */
            Text
            {
                id: text_loader
                anchors.centerIn: parent
                color: is_dimmed ? BOTTOMAREA.const_WIDGET_CMDBTN_DIMMED_TEXT_COLOR : BOTTOMAREA.const_WIDGET_CMDBTN_TEXT_COLOR
                font.pointSize: BOTTOMAREA.const_WIDGET_CMDBTN_TEXT_SIZE
                text: qsTranslate( cmd_btn_area.__lang_context, (name || "")) + cmd_btn_area.__emptyString
                style: Text.Sunken
            }

            /** Buttons separator */
            Image
            {
                anchors.right: parent.right
                source: BOTTOMAREA.const_WIDGET_CMDBTN_LINE_NORMAL
            }

            MouseArea
            {
                id: mouseArea
                property bool isHoldNow: false
                anchors.fill: parent
                enabled: !is_dimmed

                onClicked: cmd_btn_area.cmdBtnArea_clicked( model.btn_id )
                onPressed: cmd_btn_area.cmdBtnArea_pressed( model.btn_id )
                onReleased:
                {                    
                    timerPressedAndHoldCritical.stop()
                    if(!model.isHoldButton && isHoldNow ) cmd_btn_area.cmdBtnArea_clicked( model.btn_id )
                    cmd_btn_area.cmdBtnArea_released( model.btn_id )
                    isHoldNow = false
                }
                onPressAndHold:
                {
                   cmd_btn_area.cmdBtnArea_pressedAndHold( model.btn_id )
                   isHoldNow = true
                   timerPressedAndHoldCritical.start()
                }

                Timer
                {
                    id: timerPressedAndHoldCritical
                    interval: 4200
                    running: false
                    onTriggered:
                    {
                       mouseArea.isHoldNow = false
                       cmd_btn_area.cmdBtnArea_pressedAndHoldCritical( model.btn_id )
                    }
                }
            }
        }
    }
}
