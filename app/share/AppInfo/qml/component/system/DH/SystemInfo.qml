import Qt 4.7

Item {
    id:systemInfo

    property int lcdWidth: 1280
    property int lcdHeight: 720

    // Plan A
    /*
    property int statusBarHeight: 83
    property int modeAreaHeight: 68
    property int subMainHeight: lcdHeight-statusBarHeight
    property int bandHeight: 168-statusBarHeight
    */

    // Plan B
    property int subMainHeight: lcdHeight
    property int contentAreaHeight: lcdHeight - statusBarHeight      // 720 - 93 = 627
    property int headlineHeight: 166                                // status+title  93 + 73 = 166
    property int statusBarHeight: 93
    property int titleAreaHeight: 72 //headlineHeight - statusBarHeight  // band  166 - 93 = 73

    property int upperAreaHeight: headlineHeight + contentTopMargin // 166 + 6 = 172
    property int contentTopMargin: 6                                // 172 - 166 = 6

    property int backKeyX: 1136
    property int backKeyY: 93
    property int widthBackKey: 141
    property int heightBackKey: 72 //titleAreaHeight

}
