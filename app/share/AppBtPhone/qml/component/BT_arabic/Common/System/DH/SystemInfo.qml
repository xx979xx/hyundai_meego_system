/**
 * SystemInfo.qml
 *
 */
import QtQuick 1.1


Item 
{
    id: idSystemInfoContainer

    property int lcdWidth: 1280
    property int lcdHeight: 720// - statusBarHeight

    // Plan B
    property int subMainHeight: lcdHeight// - statusBarHeight         // 720 - 93 = 627

    // 전체높이 - Status 높이 - Band 높이
    property int contentAreaHeight: 554                               // 720 - 166 = 554

    property int headlineHeight: 166                                // status+title  93 + 73 = 166
    property int statusBarHeight: 93
    property int titleAreaHeight: headlineHeight - statusBarHeight  // band  166 - 93 = 73

    property int upperAreaHeight: headlineHeight + contentTopMargin // 166 + 6 = 172
    property int contentTopMargin: 6                                // 172 - 166 = 6
}
/* EOF */