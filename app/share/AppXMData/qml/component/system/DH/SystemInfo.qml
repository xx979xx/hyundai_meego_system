import Qt 4.7

Item {
    id:systemInfo

    property int lcdWidth: 1280
    property int lcdHeight: 720 - statusBarHeight
    property int lcdHeight_VEXT: 720 //for AppMobileTv(VEXTEngine)

    // Plan B
    property int subMainHeight: lcdHeight                             // 720 - 93 = 627
    property int contentAreaHeight: 554                               // 720 - 166 = 554

    property int headlineHeight: 166                                // status+title  93 + 73 = 166
    property int statusBarHeight: 93
    property int titleAreaHeight: headlineHeight - statusBarHeight  // band  166 - 93 = 73

    property int upperAreaHeight: headlineHeight + contentTopMargin // 166 + 6 = 172
    property int contentTopMargin: 6                                // 172 - 166 = 6

    property int context_BG: 0
    property int context_CONTENT_LOW: 5
    property int context_STATUSBAR: 10
    property int context_POPUP_LOW: 40
    property int context_CONTENT: 20
    property int context_OPTIONMENU: 30
    property int context_POPUP: 40
    property string font_NewHDB: "DH_HDB"
    property string font_NewHDR: "DH_HDR"
}