/**
 * /QML_arabic/DH/MPopup.qml
 *
 */
import QtQuick 1.1


MComponent
{
    id: abstractPopup

    // PROPERTIES
    property string popupName: "";
    property bool prev_visible: false;

    // SIGNALS
    signal show();
    signal hide();


    /* EVENT handlers */
    Component.onCompleted: {
        prev_visible = true;
        show();
    }

    Component.onDestruction: {
        hide();
    }

    onVisibleChanged: {
        if(prev_visible == visible) {
            // do nothing
        } else {
            prev_visible = visible;

            // 실제 visible이 바뀔때(false에서 false로 또는 true에서 true로 바뀌는 경우 제외) 동작
            if(true == visible) {
                show();
            } else {
                hide();
            }
        }
    }
}
/* EOF */
