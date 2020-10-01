// { added by Sergey 15.09.2013 for ITS#185233
import QtQuick 1.1
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM
import PopUpConstants 1.0
import AppEngineQMLConstants 1.0

Item
{
    id: root

    property int popup_type: -1 // modified by ravikanth 23-07-13 for popup close on relaunch
    signal popupClosed()

    anchors.fill: parent

    MouseArea
    {
        anchors.fill: parent
    }

    function retranslateUi()
    {
        popup.retranslateUI(FM.const_APP_FILE_MANAGER_LANGCONTEXT)
    }

    function closePopup()
    {
        //EngineListener.drmReset(UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_FRONT) // commented by cychoi 2016.01.13 for Fixed TrackChanged -> Skip by Seek HK on Divx Popup //modified for ITS 227374 2014.02.27
        popupClosed()
    }

    //PopUpText
    DHAVN_AppFileManager_PopUp_Text
    {
        id: popup

        property int focus_x: 0
        property int focus_y: 0
        property string name: "PopUpText"
        focus_id: 0


        buttons: buttonModel
        message: textModel

        onBtnClicked:
        {
            if(root.popup_type == UIDef.POPUP_TYPE_DRM_CONFIRM)
            {
                if(btnId == "OKId")
                {
                    EngineListener.drmConfirm(UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_FRONT)
                }
            }

            EngineListener.drmReset(UIListener.getCurrentScreen() == UIListenerEnum.SCREEN_FRONT) // added by cychoi 2016.01.13 for Fixed TrackChanged -> Skip by Seek HK on Divx Popup
            closePopup()
        }
    }

    ListModel
    {
        id: buttonModel

        ListElement
        {
            msg: ""
            btn_id: ""
        }
    }

    ListModel
    {
        id: textModel

        ListElement { msg: "" }
    }


    onPopup_typeChanged:
    {
        textModel.clear()
        buttonModel.clear()

        buttonModel.set( 0, { "msg": QT_TR_NOOP("STR_POPUP_OK"), "btn_id": "OKId" } )

        switch ( root.popup_type )
        {
            case UIDef.POPUP_TYPE_DRM_EXPIRED:
            {
                textModel.set( 0, { "msg": QT_TR_NOOP("STR_MEDIA_RENTAL_INFO"), "arguments" : [ { "arg1": EngineListener.drmUsedCount() }, { "arg1": EngineListener.drmLimitCount() } ] } )

                break
            }

            case UIDef.POPUP_TYPE_DRM_NOT_AUTH:
            {
                textModel.set( 0, { "msg": QT_TR_NOOP("STR_SETTING_DIVX_AUTHORIZATION") } )

                break
            }

            case UIDef.POPUP_TYPE_DRM_CONFIRM:
            {
                textModel.set( 0, { "msg": QT_TR_NOOP("STR_MEDIA_RENTAL_CONFIRM"), "arguments" : [ { "arg1": EngineListener.drmUsedCount() }, { "arg1": EngineListener.drmLimitCount() } ] } )
                buttonModel.set( 1, { "msg": QT_TR_NOOP("STR_MEDIA_MNG_CANCEL"), "btn_id": "CancelId" } )

                break
            }
        }
    }
}
// } added by Sergey 15.09.2013 for ITS#185233
