import Qt 4.7

import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

/** Slider background image */
Image
{
    id: slider_bg

    /** --- Input parameters --- */
    property string slider_bg_img: RES.const_POPUP_SLIDER_N_IMG
    property string slider_img: RES.const_POPUP_SLIDER_P_IMG
    property string cursor_n_img: RES.const_SLIDER_CURSOR_N_IMG
    property string cursor_p_img: RES.const_SLIDER_CURSOR_S_IMG

    property variant min_value
    property variant max_value
    property variant step_value
    property variant cur_value

    property int focus_id: -1
    property bool focus_visible: false
    function setDefaultFocus( arrow )
    {
        return focus_id
    }

    /** --- Signals --- */
    signal sliderMoved( variant cur_value )
    signal lostFocus( int arrow, int focusID )

    Connections
    {
        target: focus_visible ? UIListener : null
        onSignalJogNavigation:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                if ( ( arrow == UIListenerEnum.JOG_WHEEL_RIGHT ) &&
                     ( max_value > cur_value + step_value ) )
                {
                    slider_bg.sliderMoved( cur_value + step_value )
                    return
                }
                if ( ( arrow == UIListenerEnum.JOG_WHEEL_LEFT ) &&
                     ( min_value < cur_value - step_value ) )
                {
                    slider_bg.sliderMoved( cur_value - step_value )
                    return
                }

                list_view.lostFocus( arrow, focus_id )
            }
        }
    }

    /**--- Functions ---*/
    function calc_cur_value( mouse_x_pos  )
    {
        if ( ( mouse_x_pos >= 0 ) &&
             ( mouse_x_pos <= slider_bg.width ) )
        {
            var real_value = mouse_x_pos * ( slider_bg.max_value - slider_bg.min_value ) /
                             slider.sourceSize.width +
                             slider_bg.min_value

            if ( slider_bg.step_value )
            {
                var index = Math.round( real_value / slider_bg.step_value );
                real_value = slider_bg.step_value * index;
            }

            /** Send signal */
            slider_bg.sliderMoved( real_value )
        }
    }

    /** --- Object property --- */
    width: sourceSize.width; height: sourceSize.height
    source: slider_bg_img

    anchors.horizontalCenter: parent.horizontalCenter

    /** --- Child object --- */
    /** Slider image */
    Image
    {
        id: slider

        width: ( ( slider_bg.cur_value - slider_bg.min_value ) /
                 ( slider_bg.max_value - slider_bg.min_value ) *
                 ( sourceSize.width ) )
        fillMode: Image.Tile
        source: slider_img

        anchors{ top: parent.top; bottom: parent.bottom; left: parent.left }

    }

    Image
    {
        id: slider_cursor

        source: cursor_n_img

        anchors{ verticalCenter: slider.verticalCenter; horizontalCenter: slider.right }

        MouseArea
        {
            anchors.fill: parent
            beepEnabled: false

            onPressed: { slider_cursor.source = cursor_p_img }
            onReleased: { UIListener.ManualBeep();slider_cursor.source = cursor_n_img }
        }

    }

    MouseArea
    {
        anchors.fill: parent
        beepEnabled: false
        onPositionChanged: { calc_cur_value( mouseX ) }
        onClicked:{ UIListener.ManualBeep();calc_cur_value( mouseX ) }
    }

    Image
    {
        id: img_focus

        width: slider_bg.width + 50; height: slider_bg.height + 50
        visible: focus_visible
        source:RES.const_POPUP_LIST_ITEM_FOCUSED_IMG

        anchors.centerIn: slider_bg        
    }

}
