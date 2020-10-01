/**
 * /QML/DH_arabic/DDLoadingAnimation.qml
 *
 */
import QtQuick 1.1
import "../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


Image
{
    id: idImageContainer
    source: ImagePath.imgFolderAha_radio + "loading/loading_01.png"
    width: 100
    height: 100
    visible: true

    // PROPERTIES
    SequentialAnimation on source {
        running: idImageContainer.visible
        loops: Animation.Infinite

        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_01.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_02.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_03.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_04.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_05.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_06.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_07.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_08.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_09.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_10.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_11.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_12.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_13.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_14.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_15.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderAha_radio + "loading/loading_16.png"; easing.type: Easing.InOutQuad }
    }
}
/* EOF */
