import Qt 4.7
import QtQuick 1.1 // added by Dmitry 03.05.13
import AppEngineQMLConstants 1.0
import "DHAVN_BottomArea.js" as BOTTOMAREA

Image
{
    /* Incoming ListModel parameter */
    property ListModel btnModel
    property bool focus_visible: false
    property int focus_id: -1
    property bool is_focusable: true
// removed by Dmitry 02.08.13 for ITS0181495
    property bool middleEast: false // added by Dmitry 03.05.13

    /** Signals */
    signal cmdBtnArea_clicked( variant btnId );
    signal cmdBtnArea_pressed( variant btnId );
    signal cmdBtnArea_pressedAndHold( variant btnId );
    signal cmdBtnArea_pressedAndHoldCritical( variant btnId );
    signal cmdBtnArea_released( variant btnId );
    signal lostFocus( int arrow, int focusID )
    signal beep(); //added by Michael.Kim 2014.06.19 for ITS 240741

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
// modified by Dmitry 02.08.13 for ITS0181495
    function setDefaultFocus( arrow )
    {
        var res = -1
        switch ( arrow )
        {
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
	    //{modified by aettie CCP wheel direction for ME 20131014
                if(middleEast)
                {
                    focus_index = btnModel.count
                    res = focusPrev( arrow )
                }
                else
                {
                    focus_index = -1
                    res = focusNext( arrow )
                }
                break
            }
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                if(middleEast)
                {
                    focus_index = -1
                    res = focusNext( arrow )
                }
                else
                {
                    focus_index = btnModel.count
                    res = focusPrev( arrow )
                }
	    //}modified by aettie CCP wheel direction for ME 20131014
                break
            }
            default:
            {
                if ( focus_index >= 0 ) focus_index--;
                res = focusNext( arrow );
                break
            }
        }
        return res;
    }

/*----------------------------------------------------------------*/
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*----------------------------------------------------------------*/
/* ------------- Private mothods and functions ------------------ */
/*----------------------------------------------------------------*/

   onBtnModelChanged:
   {
      handleModelChange()
   }

   function handleModelChange()
   {
      // { modified by cychoi 2015.09.07 for ITS 268407 & ITS 268412
      if(focus_visible)
      {
          if (btnModel.get(focus_index) != undefined && btnModel.get(focus_index).is_dimmed == true) // modified by Dmitry 03.08.13
              if(!middleEast)
                setDefaultFocus(UIListenerEnum.JOG_WHEEL_RIGHT)
              else
                setDefaultFocus(UIListenerEnum.JOG_WHEEL_LEFT)
      }
      else
      {
          focus_index = -1
      }
      // } modified by cychoi 2015.09.07
   }

    function focusNext( dir )
    {
        var i = focus_index + 1
        for( i; i < btnModel.count; i++ )
        {
// removed by Dmitry 03.08.13
            if ( btnModel.get( i ).is_dimmed == false )
            {
                focus_index = i
                return focus_id
            }
        }
        if( dir == UIListenerEnum.JOG_DOWN) // modified by ravikanth 17-05-13 for ISV 82715, 82713
            cmd_btn_area.lostFocus( dir, focus_id );
        return -1;
    }

    function focusPrev( dir )
    {
        var i = focus_index - 1
        for( i; i >= 0; i-- )
        {
            if ( btnModel.get( i ).is_dimmed == false )
            {
                focus_index = i
                return focus_id
            }
        }
        if( dir == UIListenerEnum.JOG_UP) // modified by ravikanth 17-05-13  for ISV 82715, 82713
            cmd_btn_area.lostFocus( dir, focus_id );
        return -1
    }
// modified by Dmitry 02.08.13 for ITS0181495
    Connections
    {
        target: focus_visible ? UIListener : null
        onSignalJogCenterPressed:
        {
            button_pressed = true
            if ( focus_index >= 0 ) cmdBtnArea_pressed( btnModel.get( focus_index ).btn_id )
        }
        onSignalJogCenterReleased:
        {
            button_pressed = false
            if ( focus_index >= 0 ) cmdBtnArea_released( btnModel.get( focus_index ).btn_id )
            if( btnModel.get( focus_index ).is_dimmed == true) // modified by ravikanth 23-04-13
                focusPrev( UIListenerEnum.JOG_UP )
        }
        onSignalJogCenterLongPressed: if ( focus_index >= 0 ) cmdBtnArea_pressedAndHold( btnModel.get( focus_index ).btn_id )
        onSignalJogCenterCriticalPressed: if ( focus_index >= 0 ) cmdBtnArea_pressedAndHoldCritical( btnModel.get( focus_index ).btn_id )
        
// modified by Dmitry 15.05.13
        onSignalJogNavigation:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_UP:
                    case UIListenerEnum.JOG_DOWN:
                        break;
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                    {
		    //modified by aettie CCP wheel direction for ME 20131014
                        button_pressed = false
                        if(middleEast) focusNext( arrow )
                        else focusPrev( arrow )
                        break;
                    }
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                    {
		    //modified by aettie CCP wheel direction for ME 20131014
                        button_pressed = false
                        if(middleEast) focusPrev( arrow )
                        else focusNext( arrow )
                        break;
                    }
                    case UIListenerEnum.JOG_CENTER:
                    {
                       button_pressed = true;
                       break;
                    }
                }
            }
            else if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_CENTER:
                    {
			//modified by aettie 20130607 for ITS 171768
                        if ( focus_index >= 0 ) cmdBtnArea_clicked( btnModel.get( focus_index ).btn_id )
                        button_pressed = false;     
                        setDefaultFocus(0);
                        break;
			//modified by aettie 20130607 for ITS 171768
                    }
		    // { modified by ravikanth 17-05-13  for ISV 82715, 82713
                    case UIListenerEnum.JOG_UP:
                    {
		    	// modified for ITS 0190695
                        cmd_btn_area.lostFocus( arrow, focus_id );
                        //focusPrev( arrow )
                        break;
                    }
                    case UIListenerEnum.JOG_DOWN:
                    {
                        //focusNext( arrow )
                        break;
                    }
		    // } modified by ravikanth 17-05-13
                    default: { cmd_btn_area.lostFocus( arrow, focus_id ); break; }
                }
            }
// added by Dmitry 18.08.13 for ITS0176369
            else if (status == UIListenerEnum.KEY_STATUS_CANCELED)
            {
               switch ( arrow )
               {
                   case UIListenerEnum.JOG_CENTER:
                   {
                       button_pressed = false;
                       break;
                   }

                   default:
                      break;
               }
            }
        }
    }

    // added by Michael.Kim 2014.04.10 for ISV 99208
    Connections
    {
        target: EngineListener

        onDefaultFocus:
        {
            focus_index = 0;
        }
    }
    // added by Michael.Kim 2014.04.10 for ISV 99208

    id: cmd_btn_area

    mirror: middleEast // added by Dmitry 03.05.13

    property int focus_index: -1
    anchors.bottom: parent.bottom
    source: BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_IMG_BG
    property bool button_pressed: false
    property string __lang_context: BOTTOMAREA.const_WIDGET_LANGCONTEXT
    property string __emptyString: ""

    Column
    {        
        id: bottomElements
	// modified by Dmitry 03.05.13
        LayoutMirroring.enabled: middleEast
        anchors.right: parent.right
        anchors.rightMargin: BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_LEFTMARGIN
	// modified by Dmitry 03.05.13
        anchors.verticalCenter: parent.verticalCenter
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
            source: ( ( bPressed || ( mouseArea.pressed && is_mouse_pressed )) && !is_dimmed )
                      ? BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_IMG_PRESSED
                      : BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_IMG_NORMAL
            property bool isHighlighted: false
            property bool isHoldButton: false
            property bool is_dimmed: model.is_dimmed || false
            property bool bPressed: button_pressed && focus_visible && ( focus_index == index )
            property bool is_mouse_pressed: false //added by nhj 2013.10.08 for ITS0194452

            Image {
                id: highlight_focus
                visible: !is_dimmed&&( focus_visible && ( focus_index == index ) ) //modified by aettie 20130607 for ITS 171768
		//modified by aettie.ji 2013.05.01 for Pressed image when jog clicked
                source: button_pressed || is_mouse_pressed ? BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_IMG_PRESSED : BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_IMG_FOCUS
                //modified by Michael.Kim 2013.10.15 for ITS 195725
            }

            /** Button text */
            Text
            {
                id: text_loader
		//modified by aettie 20130829 for text align center
                //anchors.centerIn: parent
                text: qsTranslate( cmd_btn_area.__lang_context, (name || "")) + cmd_btn_area.__emptyString
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: is_dimmed ? BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_DIMMED_TEXT_COLOR : BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_TEXT_COLOR //modified by ys-20130321 new ux general1.4.4
                horizontalAlignment: Text.AlignHCenter
                property int textWidth_vp : StateManager.getStringWidth(text, BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_TEXT_FONT_NEW, BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_TEXT_SIZE); //added by  hyejin.noh 20140427 for  String Overflow
                property int textWidth_mp : EngineListener.getStringWidth(text, BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_TEXT_FONT_NEW, BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_TEXT_SIZE); //added by  hyejin.noh 20140427 for  String Overflow
                font.pixelSize:  ((textWidth_vp || textWidth_mp) > BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_TEXTAREA_WIDTH )?
                                   BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_TEXT_SMALL_SIZE : BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_TEXT_SIZE  //modified by  hyejin.noh 20140427 for  String Overflow
//                font.family: BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_TEXT_FONT
                font.family: BOTTOMAREA.const_WIDGET_RIGHTCMDBTN_TEXT_FONT_NEW                
                style: Text.Sunken
                wrapMode: Text.WordWrap
            }

            MouseArea
            {
                id: mouseArea
                property bool isHoldNow: false
                anchors.fill: parent
                enabled: !is_dimmed
                beepEnabled: false //added by Michael.Kim 2014.06.19 for ITS 240741

                onClicked:
                {
                    cmd_btn_area.beep() //added by Michael.Kim 2014.06.19 for ITS 240741
                    cmd_btn_area.cmdBtnArea_clicked( model.btn_id )
                }
// modified by Dmitry 02.08.13 for ITS0181495
                onPressed:
                {
                   cmd_btn_area.cmdBtnArea_pressed( model.btn_id )
                   focus_index = index
                   is_mouse_pressed = true
                }
// modified by Dmitry 02.08.13 for ITS0181495
                onReleased:
                {
                    timerPressedAndHoldCritical.stop()
                    if(!model.isHoldButton && isHoldNow ) cmd_btn_area.cmdBtnArea_clicked( model.btn_id )
                    cmd_btn_area.cmdBtnArea_released( model.btn_id )
                    isHoldNow = false
                    is_mouse_pressed = false
                }
                onPressAndHold:
                {
                   cmd_btn_area.cmdBtnArea_pressedAndHold( model.btn_id )
                   isHoldNow = true
                   timerPressedAndHoldCritical.start()
                }
                onCanceled: { is_mouse_pressed = false; isHoldNow = false; } //added by nhj 2013.10.08 for ITS0194452
                onExited: { is_mouse_pressed = false; isHoldNow = false; }

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
