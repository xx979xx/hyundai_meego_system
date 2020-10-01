import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_BottomArea.js" as BOTTOMAREA

Row
{
    id: tab_btn_area
    height: BOTTOMAREA.const_WIDGET_TABBTN_HEIGHT
    width: BOTTOMAREA.const_WIDGET_WIDTH
    anchors.bottom: parent.bottom

    /* Incoming ListModel parameter */
    property ListModel btnModel
    property int selectedIndex: -1
    property bool focus_visible: false
    property int focus_id: -1
    property bool is_focusable: true

    /** Signals */
    signal tabBtnArea_clicked( variant tabId )
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
// modified by Dmitry 15.05.13
        onSignalJogCenterPressed: button_pressed = true
        onSignalJogCenterReleased:
        {
           if ( focus_index >= 0 )
           {
              selectedIndex = focus_index
              tab_btn_area.tabBtnArea_clicked( btnModel.get(selectedIndex).tab_id )
           }
           button_pressed = false
        }
        onSignalJogNavigation:
        {
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
                        if ( focus_index == 0 )
                            tab_btn_area.lostFocus( arrow, focus_id )
                        else
                            focus_index--

                        break;
                    }

                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                    {
                        button_pressed = false
                        if ( focus_index == btnModel.count - 1 )
                            tab_btn_area.lostFocus( arrow, focus_id )
                        else
                            focus_index++

                        break;
                    }
                }
            }
            else if (status == UIListenerEnum.KEY_STATUS_RELEASED)
            {
               switch ( arrow )
               {
                  default:
                     tab_btn_area.lostFocus( arrow, focus_id )
                     break;
               }
            }
        }
    }
// modified by Dmitry 15.05.13

    /** Private variables */
    property string __lang_context: BOTTOMAREA.const_WIDGET_LANGCONTEXT
    property string __emptyString: ""
    property int focus_index: -1
    property bool button_pressed: false

    Repeater { model: btnModel; delegate: btnDelegate }

    Component
    {
        id: btnDelegate

        Image
        {
            id: btn_images
            width: BOTTOMAREA.const_WIDGET_WIDTH / btnModel.count + BOTTOMAREA.const_WIDGET_TABBTN_RIGHTMARGIN
            fillMode: Image.TileHorizontally
            anchors.leftMargin: BOTTOMAREA.const_WIDGET_TABBTN_LEFTMARGIN
            property bool bPressed: button_pressed && focus_visible && ( focus_index == index )

            /** Icon on button */
            Image
            {
                id: icon_image;
                anchors.centerIn: parent;
                anchors.horizontalCenterOffset: BOTTOMAREA.const_WIDGET_TABBTN_ICON_OFFSET
                source: ( bPressed || mouseArea.pressedButtons ) ?
                                      ( model.icon_p || "" ) : ( model.icon_n || "" )
            }

            /** Focus image */
            Rectangle
            {
               anchors { left: parent.left; bottom: parent.bottom }
               width: parent.width
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
                anchors.centerIn: parent
                color: BOTTOMAREA.const_WIDGET_TABBTN_TEXT_COLOR
                font.pointSize: BOTTOMAREA.const_WIDGET_TABBTN_TEXT_SIZE
                text: qsTranslate( tab_btn_area.__lang_context, name) + tab_btn_area.__emptyString
            }

            /** Button separator */
            Image {
                anchors.right: btn_images.right
                source: BOTTOMAREA.const_WIDGET_TABBTN_LINE_NORMAL
            }

            states: [
                State
                {
                    name: "pressed"; when: ( mouseArea.pressed || bPressed )
                    PropertyChanges { target: btn_images; source: BOTTOMAREA.const_WIDGET_TABBTN_IMG_NORMAL }
                },
                State
                {
                    name: "normal"; when: ( ( index != tab_btn_area.selectedIndex ) &&
                                            ( !mouseArea.pressed || !bPressed ) )
                    PropertyChanges { target: btn_images; source: BOTTOMAREA.const_WIDGET_TABBTN_IMG_PRESSED }
                },
                State
                {
                    name: "highlight"; when: ( ( index == tab_btn_area.selectedIndex ) &&
                                               ( !mouseArea.pressed || !bPressed ) )
                    PropertyChanges { target: btn_images; source: BOTTOMAREA.const_WIDGET_TABBTN_IMG_SELECTED }
                }
            ]

            MouseArea {
                id: mouseArea
                anchors.fill: parent

                onClicked: {
                    tab_btn_area.selectedIndex = index
                    tab_btn_area.tabBtnArea_clicked( tab_id );
                }
            }

            Component.onCompleted:
            {
                if ( model.selected || false )
                    tab_btn_area.selectedIndex = index
            }
        }
    }
}
