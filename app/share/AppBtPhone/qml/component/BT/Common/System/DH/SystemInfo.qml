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

    property int headlineHeight: 165                                // status+title  93 + 72 = 165
    property int statusBarHeight: 93
    property int titleAreaHeight: headlineHeight - statusBarHeight  // band  165 - 93 = 72

    property int upperAreaHeight: headlineHeight + contentTopMargin // 165 + 6 = 171
    property int contentTopMargin: 6                                // 171 - 165 = 6
}
/* EOF */
