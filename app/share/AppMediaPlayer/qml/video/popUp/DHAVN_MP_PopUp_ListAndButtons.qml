import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_MP_PopUp_Constants.js" as CONST
import "DHAVN_MP_PopUp_Resources.js" as RES

DHAVN_MP_PopUp_Base
{
    id: popup

    /** --- Input parameters --- */
    property ListModel listmodel: ListModel {}
    property ListModel buttons: ListModel {}
    property bool bIsNoActiv: false
    property int visibleLine
    property int nCurIndex
    property int item_list_height

    property int offset_y:0 //added by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded
    
    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal listItemClicked( variant index )
    signal lostFocus( int arrow, int focusID )

    states: [
        State {
            name: "PopupA"
            when: listmodel.count <= 3 && title.length== 0 && buttons.count <= 2
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_A;
            }
        },
        State {
            name: "PopupB"
            when: (listmodel.count > 3 || buttons.count > 2)  && title.length==0
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_B;
            }
        },
        State {
            name: "PopupD"
            when: listmodel.count <= 3 && title.length>0 && buttons.count <= 2
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_D;
            }
        },
        State {
            name: "PopupE"
            when: (listmodel.count > 3  || buttons.count > 2) && title.length>0
            PropertyChanges {
                target: popup
                type: RES.const_POPUP_TYPE_E;
            }
        }
   ]

  function getMargin()
  {
      switch(popup.type)
      {
      case RES.const_POPUP_TYPE_D:
      case RES.const_POPUP_TYPE_E:
          return CONST.const_POPUPTYPE_D_CONTEXT_TOP_MARGIN
      default:
          return 0
      }
  }
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

    Image
    {
       id: content
       source: type

       anchors
       {
          left: parent.left; leftMargin: getTopMargin()
          top: parent.top; topMargin: getLeftMargin()
       }

        DHAVN_MP_PopUp_Item_List
        {
            id: itemList

            focus_id: 0
            focus_visible: ( parent.focus_index == 0 ) && parent.focus_visible
            height: listmodel.count>3 ? itemHeight * 4 :  itemHeight * listmodel.count//itemHeight * item_list_height//( listmodel.count > 3 ) ? itemHeight * 4 : itemHeight * 3
            width: CONST.const_BUTTON_LEFT_MARGIN+CONST.const_V_SCROLLBAR_WIDTH
            list: popup.listmodel
            itemHeight: CONST.const_LIST_AND_BUTTONS_ITEM_HEIGHT
            separatorPath: RES.const_POPUP_LIST_LINE
            currentIndex: nCurIndex
            boundsBehavior: Flickable.StopAtBounds

            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter

            onItemClicked: popup.listItemClicked( itemId )

            onLostFocus:
            {
                if ( arrow == UIListenerEnum.JOG_RIGHT && buttons.count > 0 )
                    popup_content.focus_index = 1
                else popup_content.lostFocus( arrow, popup_content.focus_id )
            }
            function getTopMargin()
            {
                switch(listmodel.count)
                {
                case 1:
                    return CONST.const_LIST_1_LINE_TOP_MARGIN;
                case 2:
                    return CONST.const_LIST_2_LINE_TOP_MARGIN;
                case 3:
                    return CONST.const_LIST_3_LINE_TOP_MARGIN;
                case 4:
                default:
                    return CONST.const_LIST_4_LINE_TOP_MARGIN;
                }
            }
        }

         DHAVN_MP_PopUp_Item_Buttons
         {
            id: itemButtons
            focus_id: 1
            focus_visible: popup.focus_visible
            btnModel: popup.buttons
            anchors.right: parent.right
            anchors.rightMargin: CONST.const_POPUP_BUTTON_RIGHT_MARGIN
            anchors.verticalCenter: parent.verticalCenter
            popupType: popup.type
            onBtnClicked: popup.btnClicked( btnId )
            onLostFocus:
            {
                if ( arrow == UIListenerEnum.JOG_LEFT && listmodel.count > 0 )
                    popup_content.focus_index = 0
                else popup_content.lostFocus( arrow, popup_content.focus_id )
            }
         }
    }
}
