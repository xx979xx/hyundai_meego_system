import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import PopUpConstants 1.0

Image
{
    id: popup

    signal closed()

    property bool focus_visible: false
    property int focus_id: -1
    property bool is_focusable: false
    property bool bHideByTimer: true
    property int offset_y: 0

    /** --- Signals --- */
    signal closeBtnClicked()
    signal lostFocus( int arrow, int focusID );

    /** Focus interface functions */
    function hideFocus() {}
    function showFocus() {}
    function handleJogEvent( arrow, status ) {}
    function setDefaultFocus( arrow )
    {
        popup.lostFocus( arrow, focus_id )
        return -1
    }

    /** --- Input parameters --- */
    property ListModel message: ListModel {}
    property int typePopup: CONST.const_DIMMED_DEFAULT_TYPE
    property int icon: EPopUp.NONE_ICON
    property int max_text_width: 0

    function retranslateUI( context )
    {
       if (context) { __lang_context = context }
       __emptyString = " "
       __emptyString = ""
    }

    property string __lang_context: CONST.const_LANGCONTEXT
    property string __emptyString: ""

    /** --- Object property --- */
    /** Popup type */
    source: RES.const_POPUP_TYPE_DIMMED;

    Component.onCompleted:
    {
        console.log( "[SystemPopUp] popup.width: " +  popup.width )
        if ( max_text_width > (popup.width - 50) ) { max_text_width = (popup.width - 50) }
        if ( icon == EPopUp.LOADING_ICON )
        {
            if ( max_text_width > ( popup.width - 50  - animation.width - row1.spacing ) )
                max_text_width -= animation.width + row1.spacing
        }
        console.log( "[SystemPopUp] .max_text_width: " +  popup.max_text_width )
    }

    //anchors.centerIn: parent
    x: CONST.const_POPUP_DIMMED_X_OFFSET
    y: CONST.const_POPUP_DIMMED_Y_OFFSET + offset_y

    /** --- Child object --- */

    Row
    {
        id: row1
        spacing: 35
        anchors.centerIn: parent
        height: col.height

        /** Loading icon */
        AnimatedImage
        {
            id: animation
            source: RES.const_LOADING_IMG
            anchors.verticalCenter: col.verticalCenter
            visible: icon == EPopUp.LOADING_ICON ? true : false
        }

        /** Text message */
        Column
        {
            id: col
            spacing: CONST.const_DIMMED_TEXT_SPACING
            width: max_text_width

            Repeater
            {
                model: message

                Loader
                {
                    sourceComponent: Text
                    {
                        id: dimmed_text
                        property bool painted: false
                        text: ( msg.substring(0, 4) == "STR_" ) ? qsTranslate( __lang_context, msg) + __emptyString : msg
                        color: CONST.const_TEXT_COLOR;
                        font.pixelSize: CONST.const_DIMMED_TEXT_PT
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        style : Text.Sunken
                        Binding
                        {
                            target: dimmed_text
                            property: "width"
                            value: max_text_width
                            when: painted
                        }
                    }
                    onLoaded:
                    {
                       if ( item.width > max_text_width ) { max_text_width = item.width }
                       item.painted = true
                    }
                 }
              }
           }
    }

    Timer
    {
        id: close_timer
        interval: 3000
        running: popup.bHideByTimer
        onTriggered:
        {
            popup.visible = false
            popup.closed();
        }
    }
}
