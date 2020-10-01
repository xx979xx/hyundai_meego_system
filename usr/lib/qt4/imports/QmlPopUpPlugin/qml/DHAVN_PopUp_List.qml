import Qt 4.7
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

DHAVN_PopUp_Base
{
    id: popup

    /** --- Input parameters --- */
    property ListModel listmodel: ListModel {}
    property int nCurIndex

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal selected( variant index )

    /** --- Child object --- */
    type: RES.const_POPUP_TYPE_D
    content: DHAVN_PopUp_Item_List
    {
        list: listmodel
        itemHeight: CONST.const_LIST_LIST_ITEM_HEIGHT
        separatorPath: RES.const_POPUP_LINE
        currentIndex: nCurIndex
        onLostFocus: parent.lostFocus( arrow, focusID )
        onItemClicked:
        {
           popup.selected( itemId )
        }
    }
}
