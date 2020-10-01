import Qt 4.7

Item {
    id : imageInfo

    property string imgPath                         : UIListener.m_sImageRoot;

    //========= Image Folder
    property string imgFolderDmb                    : imgPath + "dmb/"
    property string imgFolderGeneral                : imgPath + "general/"
    property string imgFolderMusic                  : imgPath + "music/"
    property string imgFolderRadio                  : imgPath + "radio/"
    property string imgFolderRadio_Dab              : imgPath + "radio_dab/"
    property string imgFolderRadio_Bt               : imgPath + "bt/"
    property string imgFolderRadio_Rds              : imgPath + "radio_rds/"
    property string imgFolderRadio_Rds_Pty          : imgPath + "radio_rds/pty/"
    property string imgFolderRadio_SXM              : imgPath + "radio_sxm/"
    property string imgFolderSettings               : imgPath + "settings/"
    property string imgFolderPopup                  : imgPath + "popup/"
    property string imgFolderXMData                 : imgPath + "xm_data/"

    //========= Radio Image
    property string imgBtScan                       : imgFolderRadio+"ico_radio_scan.png"

    //========= DMB Image

    //========= General Image
    property string imgBg_Main                      : imgFolderGeneral+"bg_main.png"
    property string imgLineMenuList                 : imgFolderGeneral+"line_menu_list.png"
    property string imgBgMenu_L                     : imgFolderGeneral+"bg_menu_l.png"
    property string imgBgMenu_R                     : imgFolderGeneral+"bg_menu_r.png"
    property string imgBgMenu_L_S                   : imgFolderGeneral+"bg_menu_l_s.png"
    property string imgBgMenu_R_S                   : imgFolderGeneral+"bg_menu_r_s.png"
    property string imgBgMenu_Tab_L_P               : imgFolderGeneral+"bg_menu_tab_l_p.png"
    property string imgBgMenu_Tab_L_F               : imgFolderGeneral+"bg_menu_tab_l_f.png"   
    property string imgBgMenu_Tab_R_P               : imgFolderGeneral+"bg_menu_tab_r_p.png"
    property string imgBgMenu_Tab_R_F               : imgFolderGeneral+"bg_menu_tab_r_f.png"
    property string imgBgScroll_Menu                : imgFolderGeneral+"scroll_menu_bg.png"
    property string imgScroll_Menu                  : imgFolderGeneral+"scroll_menu.png"
    property string imgBgScroll_Menu_List           : imgFolderGeneral+"scroll_menu_list_bg.png"
    property string imgListLine                     : imgFolderGeneral+"list_line.png";
    property string img_List_P                      : imgFolderGeneral+"list_p.png"
    property string img_List_F                      : imgFolderGeneral+"list_f.png"
    property string imgIcoCheck_N                   : imgFolderGeneral+"ico_check_n.png"
    property string imgIcoCheck_S                   : imgFolderGeneral+"ico_check_s.png"

    //========= DAB Image    
    property string imgBgDivider                    : imgFolderRadio_Dab+"bg_divider.png"
    property string imgBg_DLS                       : imgFolderRadio_Dab+"bg_dls.png"
    property string imgBg_SLS_Img                   : imgFolderRadio_Dab+"bg_sls_img.png"
    property string imgBg_SLS_NOT_Img               : imgFolderRadio_Dab+"bg_sls_img_not.png"
    property string img_SLS_TEST_Img                : imgFolderRadio_Dab+"sls_test.jpeg"
    property string imgStation_List_P               : imgFolderRadio_Dab+"station_list_p.png"    
    property string imgStation_List_F               : imgFolderRadio_Dab+"station_list_f.png"
    property string imgIcoArtist                    : imgFolderRadio_Dab+"ico_artist.png"
    property string imgIcoMusic                     : imgFolderRadio_Dab+"ico_music.png"
    property string imgIcoInfo                      : imgFolderRadio_Dab+"ico_info.png"
    property string imgIcoNoSignal                  : imgFolderRadio_Dab+"ico_no_signal.png"   
    property string imgTitleDate_N                  : imgFolderRadio_Dab+"btn_title_date_n.png"
    property string imgTitleDate_P                  : imgFolderRadio_Dab+"btn_title_date_p.png"
    property string imgTitleDate_F                  : imgFolderRadio_Dab+"btn_title_date_f.png"    
    property string imgBgListTab_N                  : imgFolderRadio_Dab+"bg_list_tab_n.png"
    property string imgBgListTab_F                  : imgFolderRadio_Dab+"bg_list_tab_f.png"
    property string imgBgListTab_P                  : imgFolderRadio_Dab+"bg_list_tab_p.png"
    property string imgListArrow_U                  : imgFolderRadio_Dab+"list_arrow_up.png"
    property string imgListArrow_D                  : imgFolderRadio_Dab+"list_arrow_down.png"
    property string imgIconReserve                  : imgFolderRadio_Dab+"icon_reserve.png"
    property string imgListDab_EPG_P                : imgFolderRadio_Dab+"list_dab_epg_p.png"
    property string imgListDab_EPG_F                : imgFolderRadio_Dab+"list_dab_epg_f.png"
    property string imgSLS_Rectangle_F              : imgFolderRadio_Dab+"sls_img_focus_rectangle.png"

    //========= Setting Image
    property string imgIco_radio_N                  : imgFolderSettings + "btn_radio_n.png"
    property string imgIco_radio_S                  : imgFolderSettings + "btn_radio_s.png"

    //========= RDS Image
    property string imgBgTA_N                       : imgFolderRadio_Rds+"bg_ta_n.png"
    property string imgBgTA_Nosignal                : imgFolderRadio_Rds+"bg_ta_nosignal.png"
    property string imgChInfoDivider                : imgFolderRadio_Rds+"ch_info_divider.png"
    property string imgBgPty                        : imgFolderRadio_Rds+"bg_pty.png"
    property string imgIcoList                      : imgFolderRadio_Rds+"ico_list.png"
    property string imgBgStationDefaultLogo         : imgFolderRadio_Rds+"ico_radio.png"


    //========= RDS_PTY Image
    property string imgIcoPty_1                     : imgFolderRadio_Rds_Pty+"ico_pty_01.png"
    property string imgIcoPty_2                     : imgFolderRadio_Rds_Pty+"ico_pty_02.png"
    property string imgIcoPty_3                     : imgFolderRadio_Rds_Pty+"ico_pty_03.png"
    property string imgIcoPty_4                     : imgFolderRadio_Rds_Pty+"ico_pty_04.png"
    property string imgIcoPty_5                     : imgFolderRadio_Rds_Pty+"ico_pty_05.png"
    property string imgIcoPty_6                     : imgFolderRadio_Rds_Pty+"ico_pty_06.png"
    property string imgIcoPty_7                     : imgFolderRadio_Rds_Pty+"ico_pty_07.png"
    property string imgIcoPty_8                     : imgFolderRadio_Rds_Pty+"ico_pty_08.png"
    property string imgIcoPty_9                     : imgFolderRadio_Rds_Pty+"ico_pty_09.png"
    property string imgIcoPty_10                    : imgFolderRadio_Rds_Pty+"ico_pty_10.png"
    property string imgIcoPty_11                    : imgFolderRadio_Rds_Pty+"ico_pty_11.png"
    property string imgIcoPty_12                    : imgFolderRadio_Rds_Pty+"ico_pty_12.png"
    property string imgIcoPty_13                    : imgFolderRadio_Rds_Pty+"ico_pty_13.png"
    property string imgIcoPty_14                    : imgFolderRadio_Rds_Pty+"ico_pty_14.png"
    property string imgIcoPty_15                    : imgFolderRadio_Rds_Pty+"ico_pty_15.png"
    property string imgIcoPty_16                    : imgFolderRadio_Rds_Pty+"ico_pty_16.png"
    property string imgIcoPty_17                    : imgFolderRadio_Rds_Pty+"ico_pty_17.png"
    property string imgIcoPty_18                    : imgFolderRadio_Rds_Pty+"ico_pty_18.png"
    property string imgIcoPty_19                    : imgFolderRadio_Rds_Pty+"ico_pty_19.png"
    property string imgIcoPty_20                    : imgFolderRadio_Rds_Pty+"ico_pty_20.png"
    property string imgIcoPty_21                    : imgFolderRadio_Rds_Pty+"ico_pty_21.png"
    property string imgIcoPty_22                    : imgFolderRadio_Rds_Pty+"ico_pty_22.png"
    property string imgIcoPty_23                    : imgFolderRadio_Rds_Pty+"ico_pty_23.png"
}

