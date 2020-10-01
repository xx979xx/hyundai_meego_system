import Qt 4.7

import "DHAVN_AppUserManual_Images.js" as Images
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item
{
    width: Dimensions.const_AppUserManual_MainScreenWidth
    height: Dimensions.const_AppUserManual_MainScreenHeight

    Image
    {
        id: backgroundImage
        anchors.fill: parent
        smooth: true
        source: Images.const_AppUserManual_BG_Menu// const_AppUserManual_Background_Image
    }

    Component.onCompleted:
    {
        EngineListener.sendAthenaObject()
    }
}
