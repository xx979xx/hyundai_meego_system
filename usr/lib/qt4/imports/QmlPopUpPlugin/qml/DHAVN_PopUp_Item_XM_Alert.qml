import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES
Item
{
    id:flick_item

    property ListModel list: ListModel {}
    property int itemHeight
    property bool focusWidth: false
    property bool bIsActiv: true
    property bool focus_visible: false
    property int focus_id: -1
    property bool bPressed: false
    property int location_x
    property int location_y
    property int map_x
    property int map_y
    property int langID: UIListener.GetLanguageFromQML();

    /** --- Signals --- */
    signal itemClicked( variant itemId )
    signal lostFocus( int arrow, int focusID );
    signal jogSelect(int selected_index)
    signal hideFocus()
    /** --- Private property --- */
    property int focus_index: 0
    function setDefaultFocus( arrow )
    {
        var ret = focus_id
        if ( count <= 0 || bIsActiv == false)
        {
            lostFocus( arrow, focus_id )
            ret = -1
        }
        return ret
    }
    Connections
    {
        target: focus_visible ? UIListener : null
        onSignalJogNavigation: { doJogNavigation(arrow, status); }
        onSignalPopupJogNavigation: { doJogNavigation(arrow, status); }
        onRetranslateUi:{
            langID = languageId;
        }
    }
    function doJogNavigation( arrow, status )
    {
        switch(status)
        {
        case UIListenerEnum.KEY_STATUS_PRESSED:
        {
            switch(arrow)
            {
                //case UIListenerEnum.JOG_DOWN:
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    console.log("[SystemPopUp] jog_wheel_right contentHeight "+ flic_view.contentHeight + " contentY " + flic_view.contentY )
                    if( flic_view.contentY+ 40 <= flic_view.contentHeight - flic_view.height )
                        flic_view.contentY = flic_view.contentY + 40
                    else
                        flic_view.contentY = flic_view.contentHeight - flic_view.height
                    break;
                }
                //case UIListenerEnum.JOG_UP:
                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    console.log("[SystemPopUp] jog_wheel_left")
                    if( flic_view.contentY > 0  )
                        flic_view.contentY = flic_view.contentY - 40
                    break;
                }

                case UIListenerEnum.JOG_RIGHT:
                {
                    flick_item.lostFocus( arrow, focus_id )
                    break;
                }
            }

            break;
        }
//        case UIListenerEnum.KEY_STATUS_PRESSED:
//        {
//            switch(arrow)
//            {
//                case UIListenerEnum.JOG_DOWN:
//                case UIListenerEnum.JOG_WHEEL_RIGHT:
//                {
////                    if(focus_index < list.count - 1 )
////                        focus_index++;
//                    break;
//                }
//                case UIListenerEnum.JOG_UP:
//                case UIListenerEnum.JOG_WHEEL_LEFT:
//                {
////                    if ( focus_index > 0 )
////                        focus_index--;
//                    break;
//                }
//                case UIListenerEnum.JOG_CENTER:
//                {
//                    bPressed = true;
//                    break;
//                }
//                case UIListenerEnum.JOG_RIGHT:
//                {
//                    flick_item.lostFocus( arrow, focus_id )
//                    break;
//                }
//            }
//            break;
//        }
        case UIListenerEnum.KEY_STATUS_RELEASED:
        {
            switch(arrow)
            {
                case UIListenerEnum.JOG_CENTER:
                {
                    flick_item.itemClicked( focus_index )
                    break;
                }
                    break;
            }
        }
        case UIListenerEnum.KEY_STATUS_LONG_PRESSED:
        {
            switch(arrow)
            {
                case UIListenerEnum.JOG_DOWN:
                {
            //        focus_index = list.count - 1
                    UIListener.ManualBeep();
//		    controller.callBeepSound();
                    break;
                }
                case UIListenerEnum.JOG_UP:
                {
         //           focus_index = 0
                    UIListener.ManualBeep();
//		    controller.callBeepSound();
                    break;
                }
            }
            break;
        }
        }
    }

    Image
    {
        id:id_focus_image
        height: parent.height
        //width: focusWidth ? parent.width : focus.sourceSize.width
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.leftMargin: 26
        source: RES.const_POPUP_TYPE_ETC_01_f
        visible: focus_visible
    }

    /** --- Object property --- */
    //clip: true
    Flickable
    {
    id: flic_view
    width:parent.width
    height:parent.height-10
    anchors.left : parent.left
    anchors.leftMargin: 57
    anchors.top:parent.top
    anchors.topMargin: 24 + 4
    clip: true
    contentHeight: id_title.height + id_map_container.height + id_content.height + id_date.height + 100

        /** Focused Img */

 Item{
        Text //Title
        {
            id:id_title
            anchors.top: parent.top
            anchors.topMargin:16
            anchors.left: parent.left
            font.pointSize: 36
            font.family: "DH_HDB"
            color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
            width: 670
            clip: true
            style:Text.Sunken
            text: list.get(0).head
        }

        Rectangle{
            color:Qt.rgba(55/255,62/255,70/255, 1)
            width:449
            height:254
            anchors.top: id_title.bottom
            anchors.topMargin:23
            anchors.left: id_map_container.left
            anchors.leftMargin:-2
            visible:true
        }
        Flickable{
            id: id_map_container
            width:445
            height:250
            anchors.top: id_title.bottom
            anchors.topMargin:25
            anchors.left:parent.left
            anchors.leftMargin:2
            clip: true
            contentHeight: 720
            contentWidth: 1280
            contentX: map_view_x
            contentY: map_view_y
            Image // map
            {

                id: id_map
                visible: true
                source: RES.const_POPUP_RES_PATH + "us_1280.png"
                anchors.top: parent.top
                //anchors.topMargin:25
                anchors.left:parent.left
                //anchors.leftMargin:2
                Image // map
                {
                    id: id_map_location
                    visible: true
                    source: RES.const_POPUP_RES_PATH + "ico_map_location.png"
                    width:48
                    height:58
                    x:location_x - 24
                    y: location_y - 54
                }
            }
        }
        Text //content
        {
            id:id_content
            anchors.top: id_map_container.bottom
            anchors.topMargin:25
            anchors.leftMargin: 23
            font.pointSize: 32
            font.family: "DH_HDR"
            color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
            width: 670
            clip: true
            style:Text.Sunken
            text: list.get(1).contents
            wrapMode: Text.WordWrap
        }
        Text //date
        {
            id:id_date
            anchors.top : id_content.bottom
            anchors.topMargin:23
            anchors.leftMargin: 23
            font.pointSize: 32
            font.family: "DH_HDR"
            color: Qt.rgba(212/255, 212/255, 212/255, 1) //sub Text Grey
            width: 670
            clip: true
            text:list.get(2).date
        }

        MouseArea
        {
            anchors.fill: parent
            beepEnabled: false
            onClicked:
            {
                UIListener.ManualBeep();
                flick_item.itemClicked( index )
            }
        }
    }


    }
    Image
    {
        id: id_text_mask_n
        visible: true
        source: id_focus_image.visible==true ?RES.const_POPUP_RES_PATH + "bg_text_mask_f.png":  RES.const_POPUP_RES_PATH + "bg_text_mask_n.png"
        anchors.top: parent.top
        anchors.topMargin: 443
        anchors.left: parent.left
        anchors.leftMargin:26
    }
    DHAVN_PopUp_Item_SXM_VerticalScrollBar
    {
        anchors.left:  parent.left
        anchors.leftMargin: 748
        anchors.top:parent.top
        anchors.topMargin: 37
      //  anchors.topMargin: CONST.const_V_SCROLLBAR_TOP_MARGIN
        position: flic_view.visibleArea.yPosition
        pageSize: flic_view.contentHeight / flic_view.height
        visible: flic_view.height < flic_view.contentHeight

    }
}


