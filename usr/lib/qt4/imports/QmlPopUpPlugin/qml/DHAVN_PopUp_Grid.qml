import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import AppEngineQMLConstants 1.0

DHAVN_PopUp_Base
{
    id: popUpBase

    /** --- Input parameters --- */
    property ListModel message: ListModel {}
    property ListModel buttons: ListModel {}

    /** --- Signals --- */
    signal btnClicked( variant btnId )

    /** Contenet of PopUp */
    type: RES.const_POPUP_TYPE_D
    content: Column
    {
        property bool focus_visible: false
        property int focus_id: -1

        /** --- Signals --- */
        signal lostFocus( int arrow, int focusID );

        /** Focus interface functions */
        function setDefaultFocus( arrow )
        {
            popupBtn.focus_id = focus_id
            return popupBtn.setDefaultFocus( arrow )
        }

        spacing: CONST.const_GRID_SPACING_TO_BTNS
        anchors.centerIn: parent

        Grid
        {
            id: gridArea

            rows: CONST.const_GRID_ROWS_COUNT
            spacing: CONST.const_GRID_ITEM_SPACING
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater
            {
                model: message

                Column
                {
                    spacing: CONST.const_GRID_ITEM_SPACING

                    Rectangle
                    {
                        id: picture

                        color: icon
                        height: CONST.const_GRID_ITEM_HEIGHT
                        width: CONST.const_GRID_ITEM_WIDTH
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image
                        {
                            source: icon
                            anchors.fill: parent
                        }
                    }

                    Text
                    {
                       id: gridTxt
                        text: name.substring(0, 4) == "STR_" ?
                                    qsTranslate( CONST.const_LANGCONTEXT + LocTrigger.empty, name):
                                    name
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                }

            }

        }

        DHAVN_PopUp_Item_Buttons
        {
            id: popupBtn

            anchors.horizontalCenter: parent.horizontalCenter
            focus_visible: parent.focus_visible
            btnModel: popUpBase.buttons
            onBtnClicked: { popUpBase.btnClicked( btnId ) }
            onLostFocus: parent.lostFocus( arrow, focusID )
        }
    }
}
