import QtQuick 1.0
import QmlPopUpPlugin 1.0
import com.filemanager.uicontrol 1.0
import "DHAVN_AppFileManager_General.js" as FM
import PopUpConstants 1.0

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
        popupClosed()
    }

	// { added by Sergey 10.11.2013 new DivX popups
    onPopup_typeChanged:
    {
        textModel.clear()

        switch ( root.popup_type )
        {
            case UIDef.POPUP_TYPE_UNSUPPORTED_FILE:
            {
                textModel.set( 0, { "msg": QT_TR_NOOP("STR_MEDIA_UNAVAILABLE_FILE") } )

                break
            }

            case UIDef.POPUP_TYPE_AUDIO_FORMAT_UNSUPPORTED:
            {
                textModel.set( 0, { "msg": QT_TR_NOOP("STR_MEDIA_UNAVAILABLE_AUDIO_FORMAT") } )

                break
            }

            case UIDef.POPUP_TYPE_RESOLUTION_UNSUPPORTED:
            {
                textModel.set( 0, { "msg": QT_TR_NOOP("STR_MEDIA_UNAVAILABLE_RESOLUTION") } )

                break
            }
        }
    }
    // } added by Sergey 10.11.2013 new DivX popups

    //PopUpText
    DHAVN_AppFileManager_PopUp_Text
    {
        id: popup

        property int focus_x: 0
        property int focus_y: 0
        property string name: "PopUpText"
        focus_id: 0

    //    title: ""
    //    icon_title: EPopUp.WARNING_ICON

        buttons: buttonModel
        message: textModel

        onBtnClicked:
        {
            popupTimer.stop()
            popupClosed()
        }

        Component.onCompleted:
        {        	
            //popupTimer.start() //remove by edo.lee 2013.05.29
        }

        onVisibleChanged:
        {
        	//remove by edo.lee 2013.05.29
            /*if(visible)
                popupTimer.start()
            else
                popupTimer.stop()*/
        }

        Timer
        {
            id: popupTimer
            interval: 5000
            repeat: false
            triggeredOnStart: false
            onTriggered:
            {
                popupClosed()
            }
        }
    }

    ListModel
    {
        id: buttonModel

        ListElement
        {
            msg: QT_TR_NOOP("STR_POPUP_OK")
            btn_id: "OKId"
        }
    }

    ListModel
    {
        id: textModel

        ListElement { msg: "" } // added by Sergey 10.11.2013 new DivX popups
    }
}
