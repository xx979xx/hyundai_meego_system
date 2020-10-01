import Qt 4.7




Item {
    id:imageInfo

    // image path
    //property string imgPath: "/app/share/images/AppXMData/"
    property string imgPath: UIListener.m_sImageRoot

    // app image path ( Sort A -> Z )
    property string imgFolderBt_phone :imgPath + "bt_phone/"
    property string imgFolderDmb :imgPath + "dmb/"
    property string imgFolderGeneral :imgPath + "general/"
    property string imgFolderMusic :imgPath + "music/"
    property string imgFolderPopup :imgPath + "popup/"
    property string imgFolderRadio :imgPath + "radio/"
    property string imgFolderRadio_Xm :imgPath + "radio_xm/"
    property string imgFolderRadio_SXM :imgPath + "radio_sxm/"
    property string imgFolderSettings :imgPath + "settings/"
    property string imgFolderXMData :imgPath + "xm_data/"
    property string imgFolderXMDataWeather : imgPath + "xm_data/weather/"
    property string imgFolderXMDataFuel :imgPath + "xm_data/fuel/"
    property string imgFolderVR :imgPath + "vr/"
    property string imgFolderKeypad: imgPath + "Qwertykeypad/"
    property string imgFolderAha_radio : imgPath + "aha_radio/"
    property string imgFolderXMDataSports :imgPath + "xm_data/sports/"
}
