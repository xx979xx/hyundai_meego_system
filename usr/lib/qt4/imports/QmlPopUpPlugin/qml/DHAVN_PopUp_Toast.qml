import Qt 4.7
import AppEngineQMLConstants 1.0
import PopUpConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

DHAVN_PopUp_Base
{
    id: popup
    /** --- Input parameters --- */
    property ListModel listmodel: ListModel {}
    property int item_list_height
    property bool bHideByTimer: true

    property int contentHeight: icon_title == EPopUp.LOADING_ICON ? idImageContainer.height + id_toast_text.height : id_toast_text.height
    signal closed()

    states: [
        State {
            name: "small_toast"
            when: contentHeight < 145
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_C;
            }
        },
        State {
            name: "large_toast"
            when: contentHeight >= 145
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_F;
            }
        }
    ]

    content: Item
    {
    id: popup_content
    width:parent.width
    height:parent.height
    property int focus_index: 0
    property int focus_id: -1
    property bool focus_visible: false
    signal lostFocus( int arrow, int focusID )
    function setDefaultFocus( arrow )
    {
        focus_index = 0
        if ( listmodel.count > 0 ) return focus_id
        if ( buttons.count > 0 )
        {
            focus_index = 1
            return focus_id
        }
        lostFocus( arrow, focus_id )
        return -1
    }

    Image {
        id: idImageContainer

        width: 52; height: 52
        anchors.left: parent.left
        anchors.leftMargin: 34 + 318
        anchors.top: parent.top
        anchors.topMargin: 36
        source: RES.const_LOADING_IMG
        visible:icon_title == EPopUp.LOADING_ICON ? true : false
        NumberAnimation on rotation { running: idImageContainer.visible; from: 0; to: 360; loops: Animation.Infinite; duration: 1300 }
    }
    Text //content
    {
        id:id_toast_text
        anchors.verticalCenter:parent.verticalCenter
        anchors.verticalCenterOffset: icon_title == EPopUp.LOADING_ICON ? 45 : 0
        anchors.left: parent.left
        anchors.leftMargin:34
        font.pointSize: 32
        font.family: popup.fontFamily
        horizontalAlignment: Text.AlignHCenter
        color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
        width: CONST.const_TOAST_TEXTAREA_WIDTH
        clip: true
        style:Text.Sunken
        text:  ( listmodel.get(0).msg.substring( 0, 4 ) === "STR_" ) ?
                                           qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, listmodel.get(0).msg):
                                           listmodel.get(0).msg
        wrapMode: Text.WordWrap
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
}
