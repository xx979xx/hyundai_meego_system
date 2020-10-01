/**
 * /QML/DDCursorDelegate.qml
 *
 */
import QtQuick 1.1


Item
{
    id: idCursorDelegateContainer

    Image {
        id: idDelegateCursorImage
        source: UIListener.m_sImageRoot + "keypad/cursor.png";
        width: 4
        height: 47

        SequentialAnimation {
            running: idDelegateCursorImage.visible
            loops: Animation.Infinite;

            NumberAnimation {
                target: idDelegateCursorImage
                property: "opacity"
                to: 1
                duration: 0
                //easing.type: Easing.OutCubic
            }

            PauseAnimation  { duration: 800 }

            NumberAnimation {
                target: idDelegateCursorImage
                property: "opacity"
                to: 0
                duration: 0
                //easing.type: Easing.OutCubic
            }

            PauseAnimation  { duration: 800 }
        }
    }
}
/* EOF */
