import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import PopUpConstants 1.0

Image
{
    id: popup
    visible: false
    anchors.centerIn: parent

    signal closed()

    /** --- Input parameters --- */
    property string msg
    property int icon: EPopUp.NONE_ICON

    /** --- Object property --- */
    /** Popup type */
    source: RES.const_POPUP_TYPE_PHOTO_ZOOM;   

    /** --- Child object --- */
    Row
    {
        id: row1
        spacing: 49 - zoom_image.width
        anchors.centerIn: parent

        /** Loading icon */
        Image
        {
            id: zoom_image
            source: (icon == EPopUp.ZOOM_X) ? RES.const_POPUP_PHOTO_ZOOM_X : ""
            anchors.verticalCenter: parent.verticalCenter
        }
        /** Text message */
        Text
        {
            id: dimmed_text
            text: msg
            color: CONST.const_TEXT_COLOR;
            font.pixelSize: 70
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    function show()
    {
        visible = true
        close_timer.restart()
    }
    function hide()
    {
        visible = false
        close_timer.stop()
        popup.closed()
    }

    Timer
    {
        id: close_timer
        interval: 3000
        running: false
        onTriggered: hide()
    }
}
