import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import "."

Image
{
    id: popup

    signal closed()

    /** --- Input parameters --- */
    property ListModel message: ListModel {}
    property int typePopup: CONST.const_DIMMED_DEFAULT_TYPE

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
    source:
    {
        var ret;
        switch ( popup.typePopup )
        {
        case CONST.const_DIMMED_DEFAULT_TYPE:
            ret = RES.const_POPUP_TYPE_DIMMED
            break

        case CONST.const_DIMMED_PHOTO_1_TYPE:
            ret = RES.const_POPUP_TYPE_DIMMED_PHOTO_1
            break

        case CONST.const_DIMMED_PHOTO_2_TYPE:
            ret = RES.const_POPUP_TYPE_DIMMED_PHOTO_2
            break
        }
        return ret;
    }

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    /** --- Child object --- */
    /** Text message */
    Column
    {
        spacing: CONST.const_DIMMED_TEXT_SPACING

        anchors.centerIn: parent

        Repeater
        {
            model: message

            Loader
            {
                sourceComponent: Text
                {
                    text: ( msg.substring(0, 4) == "STR_" ) ? qsTranslate( __lang_context, msg) + __emptyString : msg
                    color: CONST.const_TEXT_COLOR;
                    font.pixelSize:
                    {
                        var ret = CONST.const_DIMMED_TEXT_PT
                        if( popup.typePopup == CONST.const_DIMMED_PHOTO_1_TYPE)
                        {
                            ret = CONST.const_DIMMED_TEXT_PT_FOR_PHOTO_1_TYPE
                        }
                        return ret
                    }
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

        }
    }
}
