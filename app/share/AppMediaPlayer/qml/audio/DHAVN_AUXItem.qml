import Qt 4.7
import AppEngineQMLConstants 1.0
import ListViewEnums 1.0
import "DHAVN_AppMusicPlayer_General.js" as MPC
import "DHAVN_AppMusicPlayer_Resources.js" as RES

Item
{
    height: MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_HEIGHT
    width: MPC.const_APP_MUSIC_PLAYER_MAIN_SCREEN_WIDTH

    function changeSelection_onJogDial( arrow, status )
    {
        // __LOG ("changeSelection_onJogDial arrow = " +arrow);
        if (mediaPlayer.focus_index == LVEnums.FOCUS_NONE)
        {
            mediaPlayer.focus_index = LVEnums.FOCUS_CONTENT;
        }

        coverCarousel.lostFocus ( UIListenerEnum.JOG_UP );
    }
    //{ deleted 20131025 for ITS 194604	// { added by hyochang.ryu 20130604
    /*Image
    {
        id: aux_bg_image

        anchors.fill: parent

        source:RES.const_APP_MUSIC_PLAYER_URL_IMG_GENERAL_BACKGROUND_5;
     }*/
    //} deleted 20131025 for ITS 194604	// } added by hyochang.ryu 20130604 
    // { added by eunhye 2013.03.07 for New UX
    Image
    {
        id: visual_cue
        anchors.top : parent.top
        anchors.left:parent.left
        anchors.leftMargin : MPC.const_APP_MUSIC_PLAYER_AUX_LIST_X_IMAGE
        anchors.topMargin : MPC.const_APP_MUSIC_PLAYER_AUX_LIST_Y_IMAGE
        source: "/app/share/images/music/ico_aux.png"
    }
    // } modified by eunhye 2013.03.07
    // { removed by eunhye 2013.03.07 for New UX
    /*Text
    {
       id: auxText

       y: MPC.const_APP_MUSIC_PLAYER_AUX_LIST_TEXT_Y
       anchors.horizontalCenter: parent.horizontalCenter
       // { added by aettie.ji 2012.10.24 for New UX : Music(LGE) #6
       //anchors.verticalCenter: parent.vertialCenter // added by eunhye.yoo 2012.08.28 for New UX : Music(LGE) #41
       text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,"STR_MEDIA_AUX") + LocTrigger.empty
       //font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDB 
       font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_HDR // modified by eunhye 2013.03.06 for New UX
      // font.pixelSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_AUX
       font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_AUX    //modified by aettie.ji 2012.11.28 for uxlaunch update
       //color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
       color: MPC.const_APP_MUSIC_PLAYER_COLOR_SUB_TEXT_GREY 
       // } added by aettie.ji 2012.10.24 for New UX : Music(LGE) #6
    }*/
    // } removed by eunhye 2013.03.07

/*
{ removed by eunhye.yoo 2012.08.14 for New UX : Music(LGE) #41
    Text
    {
       id: auxText2
       y:MPC.const_APP_MUSIC_PLAYER_AUX_LIST_TEXT_Y_TRANSF

       anchors.horizontalCenter: parent.horizontalCenter
       text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT,"STR_MEDIA_AUX") + LocTrigger.empty
       font.pixelSize:MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_AUX
       color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY


       transform: Rotation {
                    origin.x: auxText2.width / 2
                    origin.y: auxText2.height / 2
                    axis.x: 1; axis.y: 0; axis.z: 0
                    angle: 180 }
    }

    Image
    {
        y: MPC.const_APP_MUSIC_PLAYER_AUX_LIST_Y_IMAGE
        source: "/app/share/images/music/aux_reflection_mask.png"
    }
} removed by eunhye.yoo 2012.08.14
*/
    Connections
    {
        target: visible ? mediaPlayer:null

        onChangeHighlight:
        {
            changeSelection_onJogDial( arrow, status )
        }
    }
}
