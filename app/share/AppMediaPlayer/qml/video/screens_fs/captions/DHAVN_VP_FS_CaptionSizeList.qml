// { modified by Sergey 20.08.2013 for ITS#184640 
import QtQuick 1.1
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0

import "../../DHAVN_VP_CONSTANTS.js" as CONST
import "../../components"



DHAVN_VP_FocusedItem
{
    id: main

    width: 570
    height:535 // modified by Sergey 16.11.2013 for ITS#209528, 209529

    name: "CaptionSizeList"
    default_x: 0
    default_y: 0

    property alias countDispalyedItems: radiolist.countDispalyedItems
    property bool bFontSizePreview: false
    property bool bInteractive: true // added for ITS 235039 2014.04.17

    signal radioItemSelected(int radioItem); // modified by Sergey 23.10.2013 for ITS#196877
    signal signalRadioFocusIndexChanged(int radioItem) // added by cychoi 2014.12.22 for visual cue animation on quick scroll


    Connections
    {
        target: EngineListenerMain

        onRetranslateUi: radiolist.retranslateUI(CONST.const_LANGCONTEXT)
    }


	// { modified by Sergey 23.10.2013 for ITS#196877
    function setFocusToSelectedItem()
    {
        radiolist.focus_index = radiolist.currentindex;
    }
	// } modified by Sergey 23.10.2013 for ITS#196877

    
    RadioList
    {
        id: radiolist

        property int  focus_x: 0
        property int  focus_y: 0
        property string name: "CaptionSizeRadioList"
        property int last_status: UIListenerEnum.KEY_STATUS_NONE // added by cychoi 2014.02.21 for visual cue press animation

        anchors.fill: parent // modified by Sergey 16.11.2013 for ITS#209528
        focus_id: CONST.const_FS_CAPTION_FOCUS_NONE

        currentindex: 0
        radiomodel:  FSCaptionRadioListModel
        countDispalyedItems: CONST.const_FS_CAPTION_COUNT_FONT_SIZE
        bCheckEnable: false
	//added by aettie CCP wheel direction for ME 20131014
        middleEast : EngineListenerMain.middleEast
        bAutoBeep: false // added by Sergey 19.11.2013 for beep issue
		onBeep: EngineListenerMain.ManualBeep(); // added by Sergey 19.11.2013 for beep issue
		bLostLeft: !middleEast
		bLostRight: middleEast // added by Sergey 12.12.2013 for ITS#214007
        bLostEnabled: false // added by cychoi 2014.02.21 for visual cue press animation
        onQmlLog: EngineListenerMain.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log

        // { added by Sergey 29.10.2013 for ITS#196877
        // { modified by cychoi 2014.12.22 for visual cue animation on quick scroll
        onFocus_indexChanged:
        {
            s_text.setPixelSize(focus_index)
            main.signalRadioFocusIndexChanged(focus_index)
        }
        // } modified by cychoi 2014.12.22
        onFocus_visibleChanged: s_text.setPixelSize(focus_index)
		// } added by Sergey 29.10.2013 for ITS#196877

        interactive: main.bInteractive //modified for ITS 235039 2014.04.17

        onIndexSelected:
        {
            if(main.visible == false) return;
            focus_index = nIndex
            controller.onRadioItem(radiolist.currentindex)
            main.radioItemSelected(nIndex); // added by Sergey 23.10.2013 for ITS#196877
        }

        Connections
        {
            target: FSCaptionRadioListModel

            onSelectedIndexChanged: radiolist.currentindex = FSCaptionRadioListModel.selectedIndex
        }

        // { added by Sergey 23.10.2013 for ITS#196877
        function checkModel()
        {
            if(radiolist.currentindex != 0 || radiolist.count == 1)
                radiolist.focus_index = 0
            else
                radiolist.focus_index = 1;
                
            return true;
        }
        // } added by Sergey 23.10.2013 for ITS#196877

        // { added by cychoi 2014.02.21 for visual cue press animation
        function handleJogEvent( event, status )
        {
            switch ( event )
            {
            case UIListenerEnum.JOG_UP:
            {
                if(status == UIListenerEnum.KEY_STATUS_RELEASED && last_status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
                    main.lostFocus( event, status);
                }
            }
            break;
            case  UIListenerEnum.JOG_RIGHT:
            case  UIListenerEnum.JOG_LEFT:
            {
                if(status == UIListenerEnum.KEY_STATUS_PRESSED)
                    main.lostFocus( event, 0 )
            }
            break
            default:
            {
                EngineListenerMain.qmlLog( "handleJogEvent - incorrect event" )
            }
            break
            }

            last_status = status
        }
        // } added by cychoi 2014.02.21
    }


    Text
    {
        id: s_text

        width: CONST.const_FS_CAPTION_TEXT_WIDTH
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.Center
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 403

        visible: main.bFontSizePreview

        wrapMode: Text.WordWrap
        text:  qsTranslate(CONST.const_LANGCONTEXT,QT_TR_NOOP("STR_MEDIA_CAPTION_SETTING_TYPE_INFO"))+ LocTrigger.empty
        font.family: CONST.const_FONT_FAMILY_NEW_HDR
        font.pointSize: setPixelSize(video_model.captionSize) // modified by Sergey 19.10.2013 for ITS#196728
        color: CONST.const_FONT_COLOR_BRIGHT_GREY


        Connections
        {
            target: video_model

            onCaptionSizeChanged: s_text.setPixelSize(video_model.captionSize)
        }

        function setPixelSize(size)
        {
            switch(size)
            {
            case 0:
                s_text.font.pointSize = CONST.const_CAPTION_SIZE_SMALL
                break;

            case 1:
                s_text.font.pointSize  = CONST.const_CAPTION_SIZE_NORMAL
                break;

            case 2:
                s_text.font.pointSize  = CONST.const_CAPTION_SIZE_LARGE
                break;

            default:
                s_text.font.pointSize  = CONST.const_FS_CAPTION_TEXT_SIZE
                break;
            }
        }
    }
}
// } modified by Sergey 20.08.2013 for ITS#184640 
