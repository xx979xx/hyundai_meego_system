import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

Row
{
    id: radio

    /** --- Input parameters --- */
    property variant btnId
    property bool bFocused: false
    property bool bSelected: false
    property int radio_content_spacing
    property string radio_txt
    property string radio_icon
    property string text_under_bg
    property color radio_txt_color
    property variant radio_txt_pixelsize

    /** --- Signals --- */
    signal btnClicked( variant btnId )

    /** --- Object property --- */
    spacing: CONST.const_RADIO_BTN_SPACING

    /** --- Child object --- */
    DHAVN_PopUp_Item_Button
    {
        id: radio_btn

        bg_img_n: RES.const_RADIO_OFF_IMG
        bg_img_p: RES.const_RADIO_ON_IMG
        bg_img_s: RES.const_RADIO_ON_IMG
        bg_img_f: RES.const_RADIO_FOCUS_IMG
        btnId: btnId
        anchors.verticalCenter: parent.verticalCenter        
        onBtnClicked: radio.btnClicked( btnId )
        bFocused: radio.bFocused
        highlighted: radio.bSelected
    }

    Image
    {
        id: radio_content_bg
        source: RES.const_POPUP_RADIO_BG_IMG

        /** Item name */
        Text
        {
            id: txt
            text: ( text_under_bg.substring( 0, 4 ) == "STR_" ) ?
                        qsTranslate( CONST.const_LANGCONTEXT + LocTrigger.empty, text_under_bg) :
                        text_under_bg
            color: CONST.const_TEXT_COLOR
            font.pixelSize: CONST.const_TEXT_PT
            height: CONST.const_RADIO_TEXT_UNDER_SPACING + font.pixelSize
            verticalAlignment: Text.AlignBottom
            anchors{ horizontalCenter: parent.horizontalCenter; top: parent.bottom }
        }

        Column
        {            
            spacing: radio_content_spacing || CONST.const_RADIO_CONTENT_TEXT_SPACING
            anchors.centerIn: parent

            Image
            {
                source: radio_icon
                anchors.horizontalCenter: parent.horizontalCenter                
            }

            Text
            {
                id: collTxt
                text: ( radio_txt.substring( 0, 4 ) == "STR_" ) ?
                            qsTranslate( CONST.const_LANGCONTEXT + LocTrigger.empty, radio_txt) :
                            radio_txt
                color: CONST.const_RADIO_CONTENT_TEXT_COLOR
                font.pixelSize: radio_txt_pixelsize
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
