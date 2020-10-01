import Qt 4.7

import "../../Info/CarSetting" as MCarSetting
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idInfoCarSettingMain
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderSettings : imageInfo.imgFolderSettings

    onActiveFocusChanged:{ console.log(" # InfoCarSettingMain activeFocus:" + idInfoCarSettingMain.activeFocus) }

    //--------------- Background Image #
    Image {
        y: -systemInfo.statusBarHeight
        source: imgFolderGeneral+"bg_1.png"
    } // End Image

    //--------------- InfoSettingMain Flickable Menu #
    InfoCarSettingFlickable { id : idInfoCarSettingFlickable }

    //--------------- Shadow Image #
    Image{
        source:imgFolderSettings+"shadow_bottom_01.png"
        anchors.bottom:parent.bottom
        anchors.left: parent.left
    } // End Image
    Image{
        source:imgFolderSettings+"shadow_bottom_02.png"
        anchors.bottom:parent.bottom
        anchors.right: parent.right
    } // End Image

    //--------------- InfoCarSetting Band #
    InfoCarSettingBand{ id: idInfoCarSettingBand }

    onBackKeyPressed: {
        console.log(" # InfoCarSettingMain Back")
        gotoBackScreen()
    }
} // End FocusScope
