import Qt 4.7

Item {
    id:imageInfo

    // image path
    //property string imgPath: "/usr/share/PlanB/img/"
    property string imgPath: UIListener.m_sImageRoot
    //property string imgPath: "/home/meego/Hyunge_Work/v5.3.41_PlanB_Window/AppDAB/qml/images/"

    // app image path ( Sort A -> Z )
    property string imgFolder5finger :imgPath + "5finger_preset/"
    property string imgFolderAutocare :imgPath + "autocare/"
    property string imgFolderBt_phone :imgPath + "bt_phone/"
    property string imgFolderCamera :imgPath + "camera/"
    property string imgFolderClimate :imgPath + "climate/"
    property string imgFolderClock :imgPath + "clock/"
    property string imgFolderDmb :imgPath + "dmb/"
    property string imgFolderGeneral :imgPath + "general/"
    property string imgFolderHome :imgPath + "home/"
    property string imgFolderMusic :imgPath + "music/"
    property string imgFolderPhoto :imgPath + "photo/"
    property string imgFolderPopup :imgPath + "popup/"
    property string imgFolderRadio :imgPath + "radio/"
    property string imgFolderRadio_Dab :imgPath + "radio_dab/"
    property string imgFolderRadio_Hd :imgPath + "radio_hd/"
    property string imgFolderRadio_Rds :imgPath + "radio_rds/"
    property string imgFolderRadio_Xm :imgPath + "radio_xm/"
    property string imgFolderSeat_control :imgPath + "seat_control/"
    property string imgFolderSettings :imgPath + "settings/"
    property string imgFolderSound_therapy :imgPath + "sound_therapy/"
    property string imgFolderVideo :imgPath + "video/"
    property string imgFolderVisual_cue :imgPath + "visual_cue/"
    property string imgFolderVoice :imgPath + "voice/"
    property string imgFolderXMData :imgPath + "xm_data/"
    property string imgFolderRadio_SXM : imgPath + "radio_sxm/"
}
