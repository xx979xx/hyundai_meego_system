import Qt 4.7
import "DHAVN_MP_PopUp_Resources.js" as RES
import "DHAVN_MP_PopUp_Constants.js" as CONST
//import PopUpConstants 1.0  remove by edo.lee 2013.01.26
import "DHAVN_MP_PopUp_Constants.js" as EPopUp //added by edo.lee 2013.01.26

DHAVN_MP_PopUp_Base
{
    id: popUpBase

    /** --- Input parameters --- */
    property ListModel message: ListModel {}
    property ListModel buttons: ListModel {}
    property int alignment: Text.AlignLeft // modified by Sergey 08.09.2013 for ITS#188179
    property int offset_y:0 //added by aettie 20130610 for ITS 0167263 Home btn enabled when popup loaded
    property string connectionTarget:"UIListener" //added by suilyou 20140430
//    icon_title: EPopUp.NONE_ICON
    // icon_title: EPopUp.LOADING_ICON
    property int popup_id: -1 // added by cychoi 2015.09.15 for ITS 268801
    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal lostFocus( int arrow, int focusID );

    function setDefaultFocus( arrow )
    {
        return popupBtn.setDefaultFocus( arrow )
    }

//    width : parent.width
//    height: parent.height - getMargin()
//    anchors.top: parent.top
//    anchors.topMargin: getMargin()

    focus_index: 1

    states: [
        State {
            name: "PopupTypeA"
            when: ( message.count < 5 && buttons.count <= 2 && title.length==0)
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_A
            }
        },
        State {
            name: "PopupTypeB"
            when: ( (message.count  >= 5 ||  buttons.count >= 3)&& title.length==0 )
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_B
            }
        },
        State {
            name: "PopupTypeD"
            when: ( message.count < 5 && buttons.count <= 2 && title.length>0)
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_D
            }
        },
        State {
            name: "PopupTypeE"
            when: ( (message.count  >= 5 ||  buttons.count >= 3)&& title.length>0 )
            PropertyChanges {
                target: popUpBase
                type: RES.const_POPUP_TYPE_E
            }
        }
    ]

   function getMargin()
   {
       switch(popUpBase.type)
       {
       case RES.const_POPUP_TYPE_D:
       case RES.const_POPUP_TYPE_E:
           return CONST.const_POPUPTYPE_D_CONTEXT_TOP_MARGIN
       default:
           return 0
       }
   }

    Image
    {
       id: content
       source: type

       anchors
       {
          left: parent.left; leftMargin: getLeftMargin()
          top: parent.top; topMargin: getTopMargin()
       }
      Image
      {
          id: icon
          source: icon_title === EPopUp.LOADING_ICON ? RES.const_LOADING_IMG : ""
          anchors{
              left: parent.left; leftMargin: buttons.count>0? CONST.const_TEXT_CENTERALIGN_LEFT_MARGIN+CONST.const_LOADING_LEFT_MARGIN:57+439;
              top: parent.top; topMargin: CONST.const_LOADING_TOP_MARGIN
          }
          NumberAnimation on rotation { running: icon.on; from: 0; to: 360; loops: Animation.Infinite; duration: 2400 }
      }

      DHAVN_MP_PopUp_Item_SuperText
      {
          id: supertext
          txtModel: popUpBase.message	//modified by aettie.ji 2013.02.06 for language setting
          width: (buttons.count>=1) ? CONST.const_TEXT_AREA_WIDTH_LEFT_ALIGN : parent.width//CONST.const_POPUP_TYPE_A_CONTENT_AREA_WIDTH_WITH_NOBUTTON

          anchors.left: parent.left
          anchors.leftMargin: alignment == Text.AlignLeft? CONST.const_TEXT_LEFTALIGN_LEFT_MARGIN:57
          anchors.verticalCenterOffset: icon_title === EPopUp.LOADING_ICON ? 50 : 0
          use_icon : (icon_title === EPopUp.NONE_ICON) ? false : true
          alignment: Text.AlignLeft // modified by Sergey 08.09.2013 for ITS#188179
          txtOnly: ( buttons.count < 1 )
      }

      /** Buttons */
      DHAVN_MP_PopUp_Item_Buttons
      {
          id: popupBtn
          focus_id: popUpBase.focus_id
          popupType:popUpBase.type
          anchors.right: parent.right
          anchors.rightMargin: CONST.const_POPUP_BUTTON_RIGHT_MARGIN
          anchors.verticalCenter: parent.verticalCenter
          btnModel: popUpBase.buttons
          onBtnClicked: {
              popUpBase.btnClicked( btnId );
          }
          focus_visible: popUpBase.focus_visible
          popup_id: popUpBase.popup_id // added by cychoi 2015.09.15 for ITS 268801
          onLostFocus: parent.lostFocus( arrow, focusID )
          _connectionTarget: connectionTarget // added by suilyou 20140430
      }
    }
}
