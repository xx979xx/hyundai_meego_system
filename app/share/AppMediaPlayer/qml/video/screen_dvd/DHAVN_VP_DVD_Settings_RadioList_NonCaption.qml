import QtQuick 1.0
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0
import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../components"


DHAVN_VP_FocusedItem
{
    id: captionLang

	// removed by Sergey 16.05.2013
    width: 570 // modified by raviaknth 15-03-13
    height:535 // modified by cychoi 2014.02.28 for UX & GUI fix

    default_x: 0
    default_y: 0
    property bool checkIndex: false // added by yungi 2013.11.01 for ITS 198981

    signal signalRadioItemSelected(int radioItem); // added by yungi 2013.10.29 for ITS 198333
    signal signalRadioItemFlicked(int radioItem) // added by yungi 2013.12.11 for ITS 213062
    signal signalRadioFocusIndexChanged(int radioItem) // added by cychoi 2014.12.22 for visual cue animation on quick scroll

    RadioList
    {
        id: radiolist

        property int  focus_x: 0
        property int  focus_y: 0

        property int myCurrentIndex: (video_model.activeTab == 1) ? video_model.activeAudioLang : video_model.activeMenuLang
        property int last_status: UIListenerEnum.KEY_STATUS_NONE // added by lssanh 2013.06.28 ITS177124
        property int language_Id : AudioListViewModel.GetLanguage() // added by yungi 2013.10.19 for ITS 196375

        anchors.fill: parent
	//modified by aettie CCP wheel direction for ME 20131014
        middleEast : EngineListenerMain.middleEast
        
        currentindex: 0
        radiomodel: myListModelNonCaptionId // modified by cychoi 2014.09.12 for ISV 102620 // modified by yungi 2013.10.30 for Nex UX - DVD-Setting AR,RUS List Add // modified by yungi 2013.10.19 for ITS 196375
        countDispalyedItems: CONST.const_DVD_SETTINGS_COUNT_FONT_SIZE
        focus_id: CONST.const_FS_CAPTION_FOCUS_NONE
        bCheckEnable: false
        bAutoBeep: false // added by Sergey 19.11.2013 for beep issue
        onBeep: EngineListenerMain.ManualBeep(); // added by Sergey 19.11.2013 for beep issue
        bLostLeft: !middleEast
        bLostRight: middleEast // added by Sergey 12.12.2013 for ITS#214007
        bLostEnabled: false // added by cychoi 2014.02.21 for visual cue press animation
        onQmlLog: EngineListenerMain.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log

        onIndexSelected:
        {
            EngineListenerMain.qmlLog( "DVD Setting RadioList No Caption:: onIndexSelected:: RadioList NoCaption " )
            // { added by wspark 2013.04.03 for ISV 78422
            // { modified by yungi 2013.10.29 for ITS 198333  //added by shkikm for ITS 179715
            if(captionLang.visible == false) return;

            checkIndex = true  //added by yungi 2013.11.01 for ITS 198981
            focus_index = nIndex

            controller.radioItemSelected(radiolist.currentindex)
            captionLang.signalRadioItemSelected(nIndex);
            captionLang.showFocus()

            settingsMenuFrame.cueState = middleEast ? "uprightActive" : "upleftActive" // modified by yungi 2013.12.07 for ITS 213009
            settingsMenuFrame.state = "right"

            checkIndex = false // added by wspark 2014.01.10 for ITS 218950
            // } modified by yungi
        }

        // { added by yungi 2013.12.11 for ITS 213062
        onIndexFlickSelected:
        {
            captionLang.signalRadioItemFlicked(moveIndex)
            radiolist.focus_index = moveIndex
            radiolist.setIndexViewBeginning(moveIndex)
        }
        // } added by yungi 2013.12.11

        // { added by cychoi 2014.12.22 for visual cue animation on quick scroll
        onFocus_indexChanged:
        {
            captionLang.signalRadioFocusIndexChanged(focus_index)
        }
        // } added by cychoi 2014.12.22

        onMyCurrentIndexChanged:
        {            
            if (currentindex == myListModelNonCaptionId.count-1) // added by lssanh 2013.05.16 ISV82721
                currentindex = myCurrentIndex
        }

        //{ added by yongkyun.lee 20130627 for : ITS 176480
        function handleJogEvent( event, status )
        {
            switch ( event )
            {
                case  UIListenerEnum.JOG_UP:
                {
                    if ( status ==  UIListenerEnum.KEY_STATUS_RELEASED && last_status == UIListenerEnum.KEY_STATUS_PRESSED) // modified by lssanh 2013.06.28 ITS177124
                        captionLang.lostFocus( event, 0 )
                }
                break;
                case  UIListenerEnum.JOG_CENTER: 
                {
                    if ( status ==  UIListenerEnum.KEY_STATUS_RELEASED )
                        captionLang.jogSelected( status )
                }
                break
                // { added by yungi 2013.11.01 for ITS 198981
                case  UIListenerEnum.JOG_RIGHT:
                case  UIListenerEnum.JOG_LEFT:
                {
                    // { added by cychoi 2014.02.21 for visual cue press animation
                    if ( status == UIListenerEnum.KEY_STATUS_PRESSED)
                        captionLang.lostFocus( event, 0 )
                    // } added by cychoi 2014.02.21
                    captionLang.checkIndex = false
                }
                break
                // } added by yungi
                default:
                {
                    EngineListenerMain.qmlLog( "handleJogEvent - incorrect event" )
                }
                break
            }

            last_status = status; // added by lssanh 2013.06.28 ITS177124
        }
        //} added by yongkyun.lee 20130627 
    }

    // { added by yungi 2013.11.01 for ITS 198981
    function checkModel()
    {
        if(radiolist.currentindex != 0 || radiolist.count == 1)
            radiolist.focus_index = 0
        else
            radiolist.focus_index = 1;

        return true;
    }
    // } added by yungi

    //{ modified by yongkyun.lee 2013-07-09 for : ITS 179039
    function focusIndex( )
    {
        //{ modified by yungi 2013.11.01 for ITS 198981
        if(!captionLang.checkIndex)
            checkModel()
        else
          radiolist.focus_index = (video_model.activeTab == 1) ? video_model.activeAudioLang : video_model.activeMenuLang

        captionLang.checkIndex = false
        //} modified by yungi
    }
    //} modified by yongkyun.lee 2013-07-09 

    // { added by cychoi 2013.06.10 for ITS 171121 DVD Setting
    function setRadioSelected()
    {

         radiolist.currentindex = (video_model.activeTab == 1) ? video_model.activeAudioLang : video_model.activeMenuLang
    }
    // } added by cychoi 2013.06.10

    // { added by yungi 2013.12.11 for ITS 214040
    function setFocusToSelectedItem()
    {
        radiolist.focus_index = radiolist.currentindex;
    }
    // } added by yungi 2013.12.11

    // { modified by cychoi 2014.09.12 for ISV 102620 // { modified by yungi 2013.10.30 for Nex UX - DVD-Setting AR,RUS List Add  // added by yungi 2013.10.19 for ITS 196375
    ListModel
    {
       id: myListModelNonCaptionId

       ListElement
       {
          title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_KOR")
          comment_of_radiobutton: ""
          enable: true
       }

       ListElement
       {
          title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ENG")
          comment_of_radiobutton: ""
          enable: true
       }

       ListElement
       {
          title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_CHN")
          comment_of_radiobutton: ""
          enable: true
       }
       ListElement
       {
          title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_JPN")
          comment_of_radiobutton: ""
          enable: true
       }

       ListElement
       {
          title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_GER")
          comment_of_radiobutton: ""
          enable: true
       }

       ListElement
       {
          title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_FRA")
          comment_of_radiobutton: ""
          enable: true
       }
       ListElement
       {
          title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ESP")
          comment_of_radiobutton: ""
          enable: true
       }
       ListElement
       {
          title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_RUS")
          comment_of_radiobutton: ""
          enable: true
       }
       ListElement
       {
          title_of_radiobutton: QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ARB")
          comment_of_radiobutton: ""
          enable: true
       }
       ListElement
       {
          title_of_radiobutton: QT_TR_NOOP("STR_MEDIA_OTHERS")
          comment_of_radiobutton: ""
          enable: true
       }
    }

    function updateModel()
    {
        switch(radiolist.language_Id)
        {
        case CONST.const_DVD_CAPTION_LANG_KOR:
            myListModelNonCaptionId.set( 0, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_KOR") } )
            myListModelNonCaptionId.set( 1, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ENG") } )
            myListModelNonCaptionId.set( 2, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_CHN") } )
            myListModelNonCaptionId.set( 3, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_JPN") } )
            myListModelNonCaptionId.set( 4, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_GER") } )
            myListModelNonCaptionId.set( 5, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_FRA") } )
            myListModelNonCaptionId.set( 6, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ESP") } )
            myListModelNonCaptionId.set( 7, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_RUS") } )
            myListModelNonCaptionId.set( 8, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ARB") } )
            break
        case CONST.const_DVD_CAPTION_LANG_CHN:
            myListModelNonCaptionId.set( 0, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_CHN") } )
            myListModelNonCaptionId.set( 1, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ENG") } )
            myListModelNonCaptionId.set( 2, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_GER") } )
            myListModelNonCaptionId.set( 3, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ESP") } )
            myListModelNonCaptionId.set( 4, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_FRA") } )
            myListModelNonCaptionId.set( 5, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_RUS") } )
            myListModelNonCaptionId.set( 6, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_KOR") } )
            myListModelNonCaptionId.set( 7, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_JPN") } )
            myListModelNonCaptionId.set( 8, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ARB") } )
            break
        case CONST.const_DVD_CAPTION_LANG_ARB:
            myListModelNonCaptionId.set( 0, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ARB") } )
            myListModelNonCaptionId.set( 1, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ENG") } )
            myListModelNonCaptionId.set( 2, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_GER") } )
            myListModelNonCaptionId.set( 3, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ESP") } )
            myListModelNonCaptionId.set( 4, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_FRA") } )
            myListModelNonCaptionId.set( 5, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_RUS") } )
            myListModelNonCaptionId.set( 6, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_KOR") } )
            myListModelNonCaptionId.set( 7, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_CHN") } )
            myListModelNonCaptionId.set( 8, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_JPN") } )
            break
        default:
            myListModelNonCaptionId.set( 0, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ENG") } )
            myListModelNonCaptionId.set( 1, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_GER") } )
            myListModelNonCaptionId.set( 2, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ESP") } )
            myListModelNonCaptionId.set( 3, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_FRA") } )
            myListModelNonCaptionId.set( 4, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_RUS") } )
            myListModelNonCaptionId.set( 5, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_KOR") } )
            myListModelNonCaptionId.set( 6, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_CHN") } )
            myListModelNonCaptionId.set( 7, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_JPN") } )
            myListModelNonCaptionId.set( 8, { "title_of_radiobutton": QT_TR_NOOP("STR_SETTING_DVD_CAPTION_LANG_ARB") } )
            break
        }
        //myListModelNonCaptionId.set( 9, { "title_of_radiobutton": QT_TR_NOOP("STR_MEDIA_OTHERS") } )
    }
    // } modified by cychoi 2014.09.12 // } modified by yungi

    Connections
    {
        target: EngineListenerMain

        onRetranslateUi:
        {
            radiolist.retranslateUI(CONST.const_LANGCONTEXT)
            radiolist.language_Id = aLanguageId // added by yungi 2013.10.19 for ITS 196375
            EngineListenerMain.qmlLog( "DVD Setting RadioList No Caption:: onRetranslateUi:: language_Id " + aLanguageId )
            updateModel() // added by cychoi 2014.09.12 for ISV 102620
            setRadioSelected()
        }
    }

    // { added by cychoi 2014.09.12 for ISV 102620
    Component.onCompleted:
    {
        updateModel()
    }
    // } added by cychoi 2014.09.12
}
