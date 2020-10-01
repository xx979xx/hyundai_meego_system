import QtQuick 1.0

import "../DHAVN_VP_CONSTANTS.js" as CONST

ListModel
{
    ListElement
    {
       icon_p: "/app/share/images/general/dummy.png"
       icon_n: "/app/share/images/general/dummy.png"
       icon_d: "/app/share/images/general/dummy.png"
       icon_f: "/app/share/images/general/dummy.png"

       btn_id: "dummy"
       btn_width: 52
       btn_height: 1
       is_dimmed: false
       jog_pressed: false
   } // added for expand touch area

   ListElement
   {
      icon_p: "/app/share/images/general/media_rew_p.png"
      icon_n: "/app/share/images/general/media_rew_n.png"
      icon_d: "/app/share/images/general/media_rew_d.png"
      icon_f: "/app/share/images/general/media_rew_f.png"

      btn_id: "Prev"
      btn_width: 90 //CONST.const_FF_REW_ICON_WIDTH
      btn_height: 81 //CONST.const_FF_REW_ICON_HEIGHT
      is_dimmed: false
      jog_pressed: false
   }

   ListElement
   {
      icon_n: "/app/share/images/general/media_visual_cue_n.png"
      icon_d: "/app/share/images/general/media_visual_cue_d.png"
      icon_f: "/app/share/images/general/media_visual_cue_f.png"
      icon_p: "/app/share/images/general/media_visual_cue_p.png" //added for [KOT][ITS][195505][comment] 
      // { modified by wspark 2012.08.17 for DQA #21
      /*
      icon2_p: "/app/share/images/general/media_play_p.png"
      icon2_n: "/app/share/images/general/media_play_n.png"
      icon2_d: "/app/share/images/general/media_play_d.png"
      icon2_f: "/app/share/images/general/media_play_f.png"
      */
      icon2_p: "/app/share/images/general/media_play_02_p.png"
      icon2_n: "/app/share/images/general/media_play_02_n.png"
      icon2_d: "/app/share/images/general/media_play_02_d.png"
      icon2_f: "/app/share/images/general/media_play_02_f.png"
      // } modified by wspark 2012.08.17 for DQA #21

      text: ""

      btn_id: "PlayButton"
      btn_width: 148 //modified by aettie 20130625 for New GUI
      btn_height: 157 //modified by aettie 20130625 for New GUI
      is_dimmed: false
      jog_pressed: false
   }

   ListElement
   {
      icon_p: "/app/share/images/general/media_for_p.png"
      icon_n: "/app/share/images/general/media_for_n.png"
      icon_d: "/app/share/images/general/media_for_d.png"
      icon_f: "/app/share/images/general/media_for_f.png"
      btn_id: "Next"
      btn_width: 90 //CONST.const_FF_REW_ICON_WIDTH
      btn_height: 81 // CONST.const_FF_REW_ICON_HEIGHT
      is_dimmed: false
      jog_pressed: false
   }
}
