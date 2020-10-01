import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

Item
{
    id: checkbox_item
    property string stateCheck: "false"

    signal  itemClicked(variant itemId);
    anchors.fill: parent
    width:check.width
    height:check.height
    Connections
    {
        target: UIListener
        onSignalJogNavigation:
        {
            if ( status === UIListenerEnum.KEY_STATUS_RELEASED )
            {
                if (arrow === UIListenerEnum.JOG_CENTER)
                {
                 //   checkbox_item.checkToggle()
                    if(focus_visible==true)
                        checkToggle()
                    //console.log("checkbox toggle")
                }
            }
        }
    }

    Image{
        id: id_check
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        width: sourceSize.width
        height: sourceSize.height
        source : stateCheck === "true" ? RES.const_BTN_CHECK_ON_IMG : RES.const_BTN_CHECK_OFF_IMG
    }

    function checkToggle()
    {
        if( list_view.currentIndex == index )
        {
            list_view.list.setProperty(index, "check", getToggle())
            checkbox_item.itemClicked(index)
            console.log("[SystemPopUp] checkToggle()" + getToggle())
            //stateCheck = getToggle()
        }

    }
    function getToggle()
    {
        if(stateCheck == "false") return  "true"
        else return "false"
    }
}
