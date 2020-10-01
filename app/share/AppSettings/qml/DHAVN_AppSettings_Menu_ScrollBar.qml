import QtQuick 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES

Item{
    id: menuScroll

    property real listCount
    property real heightRatio
    property real yPosition

    Image{
        y: 32
        x: 582
        source: RES.const_URL_IMG_SETTINGS_CUE_SCROLL_BG
        visible: ( menuScroll.listCount > 5 )

        Item{
            height: menuScroll.heightRatio * 480
            y: menuScroll.yPosition * 480
            Image{
                y: -parent.y
                source: RES.const_URL_IMG_SETTINGS_CUE_SCROLL
            }

            width: parent.width
            clip: true
        }
    }
}
