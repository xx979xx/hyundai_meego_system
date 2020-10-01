import QtQuick 1.1

Item {
    id:systemInfo

    property int lcdWidth: 1280
    property int lcdHeight: 720
    property int statusBarHeight: 93
    property int modeAreaHeight: 72

    property int avmMenuBarWidth : 790
    property int avmMenuBarHeight : 114 // = 9+96+9
    property int avmMenuBarY: 616 //606+9
    property int avmMenuBarX: 11

    property int normalFontSize: 40
    property int btnFontSize: 40
    property int alertFontSize: 32
    property int listNumberFontSize: 32
    property int smallFontSize: 25

    property int aVMButtonCarWidth: 154
    property int aVMButtonCarWidth2: 202
    property int aVMButtonCarWidthFrontNormal: 125
    property int aVMButtonCarHeight: 96
    property int aVMButtonWidth: 154//151//160-9
    property int aVMButtonHeight: 96
    property int settingCompY: statusBarHeight+modeAreaHeight+14
    property int menuHeight: 89
    property int bandHeight: 166
    property int avmParkingButtonWidth: 154
    property int avmManualTextWidth: 718 //743

    property string imageInternal : "/app/share/images/AppCamera/"
    property string imgFolderGeneral : "/app/share/images/general/"
    property string waveFolder : "/app/share/AppCamera/wav/"

    property string dhLogoBLImageURI : "/app/share/images/AppStandBy/Logo_bluelink_On.png"
    property string dhLogoNoBLImageURI :  "/app/share/images/AppStandBy/Logo_bluelink_Off.png"

    //DHPE Only
    property string dhpeLogoBLImageURI : "/app/share/images/AppCamera/logo/DH_PE_GENESIS_1280x720_bluelink.png"
    property string dhpeLogoNoBLImageURI :  "/app/share/images/AppCamera/logo/DH_PE_GENESIS_1280x720.png"

    //AVM setting
    property int righMenuListWidth : 568
    property int righMenuItemButtonWidth : 528//538
    property int righMenuItemButtonHeight : 136

    //Back key
    property int backKeyX: 1136
    property int backKeyY: 93
    property int widthBackKey: 141
    property int heightBackKey: modeAreaHeight
    property string bgImageBackKey: (cppToqml.IsArab)? imageInternal+"btn_title_back_n-rev.png" : imageInternal+"btn_title_back_n.png"
    property string bgImagePressBackKey: (cppToqml.IsArab)? imageInternal+"btn_title_back_p-rev.png" : imageInternal+"btn_title_back_p.png"
    property string bgImageFocusPressBackKey: (cppToqml.IsArab)? imageInternal+"btn_title_back_p-rev.png" : imageInternal+"btn_title_back_p.png"
    property string bgImageFocusBackKey: (cppToqml.IsArab)? imageInternal+"btn_title_back_f-rev.png" : imageInternal+"btn_title_back_f.png"
}
