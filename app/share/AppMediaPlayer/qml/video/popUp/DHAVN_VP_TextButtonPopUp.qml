// { modified by Sergey for CR#15744
import QtQuick 1.0
//import QmlPopUpPlugin 1.0
//import PopUpConstants 1.0 remove by edo.lee 2013.01.26
import "../popUp/DHAVN_MP_PopUp_Constants.js" as EPopUp //added by edo.lee 2013.01.26
import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../models"
import "../components"
import "../popUp"

DHAVN_VP_FocusedItem
{
    id: main
    anchors.fill: parent

    default_x:0
    default_y:0
    name: "TextButtonPopup"

    property string sText: video_model.sText

    onSTextChanged:
    {
        infoPopupModel.set(0, {"msg": main.sText })
    }

    // { commented by Sergey 27.10.2013 for ITS#198669
    //added by edo.lee 2013.09.14
//    Rectangle
//    {
//        //objectName: "lockoutMode"
//        id: lockoutRect //added by edo.lee 2013.02.26

//        visible: false//video_model.lockoutMode
//        anchors.fill:parent

//        // { added by Sergey Vetugov. CR#10273
//        color: "black"

//        Image
//        {
//            //[KOR][ITS][181226][comment](aettie.ji)
//            id: lockoutImg

//            anchors.left: parent.left
//            anchors.leftMargin: 562
//            y: ( video_model.progressBarMode == "AUX" )? CONST.const_NO_PBCUE_LOCKOUT_ICON_TOP_OFFSET:CONST.const_LOCKOUT_ICON_TOP_OFFSET // modified by lssanh 2013.05.24 ISV84099
//            source: RES.const_URL_IMG_LOCKOUT_ICON
//        }

//        Text
//        {

//            width: parent.width
//            horizontalAlignment:Text.AlignHCenter//added by edo.lee 2013.06.22

//            anchors.top : lockoutImg.bottom
//            text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_DISC_VCD_DRIVING_REGULATION") + LocTrigger.empty  //added by edo.lee 2013.05.24
//            font.pointSize: 32//36//modified by edo.lee 2013.05.24
//            color: "white"
//            // { modified by Sergey Vetugov. CR#10273
//        }


//    }
//added by edo.lee 2013.09.14
// } commented by Sergey 27.10.2013 for ITS#198669

    Connections
    {
        target: controller
        
        // { commented by Sergey 27.10.2013 for ITS#198669
        //added by edo.lee 2013.09.14
//    onShowLockout:
//        {
//            EngineListenerMain.qmlLog("[MP][QML] VP TextButton Popup :: onShowLockout");
//            lockoutRect.visible  = onShow;
//        }
	//added by edo.lee 2013.09.14
	// } commented by Sergey 27.10.2013 for ITS#198669
        onUpdateButtonModel:
        {
            infoButtonModel.clear()
            if(btn1 != "")
                infoButtonModel.append({"msg": QT_TR_NOOP(btn1), "btn_id": "Id_0"});
            if(btn2 != "")
                infoButtonModel.append({"msg": QT_TR_NOOP(btn2), "btn_id": "Id_1"});
        }

        //{ added by yongkyun.lee 20130324 for : ISV 77052
        onPopUpTimerOut:
        {
            popupUnavailableFormatTimer.start();
            popupUnavailableFormatTimer.running= true;
        }
        //} added by yongkyun.lee 20130324 
    }

    function retranslateUi()
    {
        popupImageInfo.retranslateUI(CONST.const_APP_VIDEO_PLAYER_LANGCONTEXT)
    }


    //PopUpText
    DHAVN_MP_PopUp_Text
    {
        id: popupTextButton

        property int focus_x: 0
        property int focus_y: 0
        focus_id: 0
        title: qsTr("")
        buttons: infoButtonModel
        message: infoPopupModel
        icon_title: video_model.isWarningIcon ? EPopUp.WARNING_ICON : EPopUp.NONE_ICON;
        focus_visible: visible // added by Sergey 23.04.2013
        popup_id: video_model.popupId  // added by cychoi 2015.09.15 for ITS 268801

        onBtnClicked:
        {
            if(!popupTextButton.visible) return;//added by edo.lee 01.19
            switch(btnId)
            {
            case "Id_0":
            {
                controller.onSoftkeyBtn("btn1");
                break;
            }
            case "Id_1":
            {
                controller.onSoftkeyBtn("btn2");
                break;
            }
            }
        }
    }

    ListModel
    {
        id: infoPopupModel
    }

    ListModel
    {
        id: infoButtonModel
    }

    //{ added by yongkyun.lee 20130324 for : ISV 77052
    Timer
    {
        id: popupUnavailableFormatTimer
        interval: 5000
        repeat: false
        running: false
        onTriggered:
        {
            running= false;
            popupTextButton.btnClicked("Id_0");
        }
    }
    //} added by yongkyun.lee 20130324 
    
}
// } modified by Sergey for CR#15744.
