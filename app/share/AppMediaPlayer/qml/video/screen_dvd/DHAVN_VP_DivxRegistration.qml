// { modified by Sergey 25.10.2013 for new DivX
import Qt 4.7
import QtQuick 1.1
import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../DHAVN_VP_RESOURCES.js" as RES
import "../components"
import AppEngineQMLConstants 1.0

DHAVN_VP_FocusedItem
{
    id: main

    width: CONST.const_SCREEN_WIDTH
    height: CONST.const_SCREEN_HEIGHT

    name: "DivxRegistration"
    default_x: 0
    default_y: 0
    focus_visible: true

    state: video_model.scrState

    property int const_TEXT_WIDTH: 980


    Connections
    {
        target: controller

        onSetDefaultFocus:
        {
            main.visible = true;
            main.setDefaultFocus(UIListenerEnum.JOG_DOWN);
        }
    }

    function logger(str)
    {
        EngineListenerMain.qmlLog("DHAVN_VP_DivXReg " + str);
    }

    states: [
        State
        {
            name: "RegistrationCode"
            PropertyChanges { target: text1; visible: true }
	    //modified by aettie 20130802 for ITS 181594
            PropertyChanges { target: text1; anchors.topMargin: 233 - height/2 + 40 }
            PropertyChanges { target: text1; text: qsTranslate(CONST.const_LANGCONTEXT,"STR_SETTING_DIVX_REGISTER_INFO") + LocTrigger.empty }

            PropertyChanges { target: text2; visible: true }
            PropertyChanges { target: text2; anchors.topMargin: text1.height/2 + 60  }
            PropertyChanges { target: text2; text: qsTranslate(CONST.const_LANGCONTEXT,"STR_SETTING_DIVX_REGISTER_CODE") + LocTrigger.empty }

            PropertyChanges { target: text3; visible: true }
	    //modified by aettie 20130802 for ITS 181594
            PropertyChanges { target: text3; anchors.top: text2.bottom; anchors.topMargin:0}
            PropertyChanges { target: text3; text:  video_model.regCode}

            PropertyChanges { target: text4; visible: true }
            PropertyChanges { target: text4; anchors.topMargin: text3.height/2 + 60}
            PropertyChanges { target: text4; text: qsTranslate(CONST.const_LANGCONTEXT,"STR_SETTING_DIVX_REGISTER_SITE") + LocTrigger.empty }

            PropertyChanges { target: divxButton; visible: true }
            PropertyChanges { target: divxButton; divxButtonText: qsTranslate( CONST.const_LANGCONTEXT,"STR_MEDIA_OK_BUTTON") + LocTrigger.empty }

            PropertyChanges { target: divxButtonCancel; visible: false }
        },
        State
        {
            name: "AlreadyRegistered"
            PropertyChanges { target: text1; visible: true }
            PropertyChanges { target: text1; anchors.topMargin: 288 } // modified by Sergey 07.08.2013
            PropertyChanges { target: text1; text: qsTranslate(CONST.const_LANGCONTEXT,"STR_SETTING_DIVX_REGISTERED_INFO") + LocTrigger.empty }
            //modified by aettie 20130806 for ISV 85222 
	    PropertyChanges { target: text1; color: CONST.const_COLOR_TEXT_BRIGHT_GREY}
            PropertyChanges { target: text1; font.pointSize: 40 }

            PropertyChanges { target: text2; visible: false }
            PropertyChanges { target: text3; visible: false }
            PropertyChanges { target: text4; visible: false }

            PropertyChanges { target: divxButton; visible: true }
            //modified by aettie 20130806 for ISV 85222 
            PropertyChanges { target: divxButton; divxButtonText: qsTranslate( CONST.const_LANGCONTEXT,"STR_MEDIA_MNG_YES") + LocTrigger.empty }
 //           PropertyChanges { target: divxButton; divxButtonText: qsTranslate( CONST.const_LANGCONTEXT,"STR_SETTING_DIVX_REGISTERED_CLEAR") + LocTrigger.empty }

            PropertyChanges { target: divxButtonCancel; visible: true }
            PropertyChanges { target: divxButtonCancel; divxButtonText: qsTranslate( CONST.const_LANGCONTEXT,"STR_MEDIA_CANCEL_BUTTON") + LocTrigger.empty }
        },
        State
        {
            name: "DeregistrationCode"
            PropertyChanges { target: text1; visible: true }
            PropertyChanges { target: text1; anchors.topMargin: 233 - height/2 }
            //modified by aettie 20130806 for ISV 85222 
            PropertyChanges { target: text1; text: qsTranslate(CONST.const_LANGCONTEXT,"STR_SETTING_DIVX_REGISTERED_CLEAR_CODE") + LocTrigger.empty}
            PropertyChanges { target: text1; color: CONST.const_COLOR_TEXT_BRIGHT_GREY}
            PropertyChanges { target: text1; font.pointSize: 40 }
            
            PropertyChanges { target: text2; visible: true }
	    //modified by aettie 20130802 for ITS 181594
            PropertyChanges { target: text2; anchors.top: text1.bottom; anchors.topMargin:0}
            PropertyChanges { target: text2; text:  video_model.deregCode }            
            PropertyChanges { target: text2; color: CONST.const_COLOR_TEXT_BRIGHT_GREY}
            PropertyChanges { target: text2; font.pointSize: 40 }
            
            PropertyChanges { target: text3; visible: true }
            PropertyChanges { target: text3; anchors.topMargin: text1.height/2 + 50 } // modified by wonseok.heo for ITS 226589 2014.02.21
            PropertyChanges { target: text3; text: qsTranslate(CONST.const_LANGCONTEXT,"STR_SETTING_DIVX_REGISTERED_CLEAR_SITE") + LocTrigger.empty }
            PropertyChanges { target: text3; color: CONST.const_COLOR_TEXT_DIMMED_GREY}
            PropertyChanges { target: text3; font.pointSize: 32 }
            
            PropertyChanges { target: text4; visible: true }
            //modified by aettie 20130802 for ITS 181594
            PropertyChanges { target: text4; anchors.top: text3.bottom; anchors.topMargin: text2.height/2 } // modified by wonseok.heo for ITS 226589 2014.02.21 // modified by Sergey 07.08.2013
            PropertyChanges { target: text4; text: qsTranslate(CONST.const_LANGCONTEXT,"STR_SETTING_DIVX_REGISTER_CONTINUE_INFO") + LocTrigger.empty }
            PropertyChanges { target: text4; color: CONST.const_COLOR_TEXT_BRIGHT_GREY} // modified by Sergey 07.08.2013
            PropertyChanges { target: text4; font.pointSize: 40 } // modified by Sergey 07.08.2013
            
           // PropertyChanges { target: text4; visible: false }

            PropertyChanges { target: divxButton; visible: true }
            PropertyChanges { target: divxButton; divxButtonText: qsTranslate( CONST.const_LANGCONTEXT,"STR_MEDIA_OK_BUTTON") + LocTrigger.empty }
    //        PropertyChanges { target: divxButton; divxButtonText: qsTranslate( CONST.const_LANGCONTEXT,"STR_SETTING_DIVX_REGISTER") + LocTrigger.empty }
            PropertyChanges { target: divxButtonCancel; visible: true }
            PropertyChanges { target: divxButtonCancel; divxButtonText: qsTranslate( CONST.const_LANGCONTEXT,"STR_MEDIA_CANCEL_BUTTON") + LocTrigger.empty }
        }
    ]

    MouseArea { 
    anchors.fill: parent 
    beepEnabled: false // added by Puneet on 2013.08.11 for ISV 88893 
    } // added by Sergey 26.07.2013 ITS#181721

    Image
    {
        id: mainBg
        source: RES.const_URL_DVD_SETTINGS_BG
    }

    Text
    {
        id: text1

        width: const_TEXT_WIDTH
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        font.pointSize: 32
        font.family: CONST.const_FONT_FAMILY_NEW_HDR
//        color: CONST.const_COLOR_TEXT_BRIGHT_GREY
        color: CONST.const_COLOR_TEXT_DIMMED_GREY             //modified by aettie 20130806 for ISV 85222 
    }

    Text
    {
        id: text2

        width: const_TEXT_WIDTH
        anchors.top: text1.top
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

//        font.pointSize: 32
        font.pointSize: 40 //modified by aettie 20130806 for ISV 85222
        font.family: CONST.const_FONT_FAMILY_NEW_HDR
        color: CONST.const_COLOR_TEXT_BRIGHT_GREY
    }

    Text
    {
        id: text3

        width: const_TEXT_WIDTH
        anchors.top: text2.top
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

//        font.pointSize: 32
        font.pointSize: 40 //modified by aettie 20130806 for ISV 85222
        font.family: CONST.const_FONT_FAMILY_NEW_HDR
        color: CONST.const_COLOR_TEXT_BRIGHT_GREY
    }

    Text
    {
        id: text4;

        width: const_TEXT_WIDTH
        anchors.top: text3.top
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        font.pointSize: 32
        font.family: CONST.const_FONT_FAMILY_NEW_HDR
        //color: "#8DB3FF"
        color: CONST.const_COLOR_TEXT_DIMMED_GREY //modified by aettie 20130806 for ISV 85222
    }


    DHAVN_VP_DivxButton
    {
        id: divxButton

        anchors.top: main.top
        anchors.topMargin: 582
        anchors.left: parent.left
        anchors.leftMargin: EngineListenerMain.middleEast ? (divxButtonCancel.visible ? 660 : 420) : (divxButtonCancel.visible ? 150 : 420)

        focus_x: 0
        focus_y: 0

        onDivxButtonClicked: controller.onButtonClicked("OK");


        function handleJogEvent( event, status )
        {
            logger("divxButton handleJogEvent focused = " + focus_visible + " event = " + event + " status = " + status);

            if(!focus_visible)
                return;

            if((/*event ==  UIListenerEnum.JOG_RIGHT || event ==  UIListenerEnum.JOG_WHEEL_LEFT ||*/ event ==  UIListenerEnum.JOG_WHEEL_RIGHT)//modified for ITS 225961 2014.02.19
                    && status ==  UIListenerEnum.KEY_STATUS_PRESSED)
            {
                lostFocus(UIListenerEnum.JOG_RIGHT, 0);
            }
            else if(event ==  UIListenerEnum.JOG_UP && status ==  UIListenerEnum.KEY_STATUS_PRESSED)
            {
                lostFocus(event, 0);
            }
            else if(event ==  UIListenerEnum.JOG_CENTER)
            {
                jogSelected(status);
            }
        }
    }


    DHAVN_VP_DivxButton
    {
        id: divxButtonCancel

        anchors.top: main.top
        anchors.topMargin: 582
        anchors.left: parent.left
        anchors.leftMargin: EngineListenerMain.middleEast ? 150 : 660

        focus_x: 1
        focus_y: 0

        onDivxButtonClicked: controller.onButtonClicked("CANCEL");


        function handleJogEvent( event, status )
        {
            logger("divxButtonCancel handleJogEvent focused = " + focus_visible + " event = " + event + " status = " + status);

            if(!focus_visible)
                return;

            if((/*event ==  UIListenerEnum.JOG_LEFT || event ==  UIListenerEnum.JOG_WHEEL_RIGHT ||*/ event ==  UIListenerEnum.JOG_WHEEL_LEFT)//modified for ITS 225961 2014.02.19
                    && status ==  UIListenerEnum.KEY_STATUS_PRESSED)
            {
                lostFocus(UIListenerEnum.JOG_LEFT, 0);
            }
            else if(event ==  UIListenerEnum.JOG_UP && status ==  UIListenerEnum.KEY_STATUS_PRESSED)
            {
                lostFocus(event, 0);
            }
            else if(event ==  UIListenerEnum.JOG_CENTER)
            {
                jogSelected(status);
            }
        }
    }
}
// } modified by Sergey 25.10.2013 for new DivX
