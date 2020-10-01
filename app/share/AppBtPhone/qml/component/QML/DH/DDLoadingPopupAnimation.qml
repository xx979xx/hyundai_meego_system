/**
 * /QML/DH/DDLoadingPopupAnimation.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


Image
{
    id: idImageContainer
    source: ImagePath.imgFolderPopup + "loading/loading_01.png"
    width: 76
    height: 76
    visible: true

    // PROPERTIES
    SequentialAnimation on source {
        running: idImageContainer.visible
        loops: Animation.Infinite

        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_01.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_02.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_03.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_04.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_05.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_06.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_07.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_08.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_09.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_10.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_11.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_12.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_13.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_14.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_15.png"; easing.type: Easing.InOutQuad }
        PropertyAnimation { duration: 100; to: ImagePath.imgFolderPopup + "loading/loading_16.png"; easing.type: Easing.InOutQuad }
    }
}
/* EOF */
