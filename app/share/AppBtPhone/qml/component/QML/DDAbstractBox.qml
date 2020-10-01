/**
 * /QML/DDAbstractBox.qml
 *
 */
import QtQuick 1.1


Item
{
    id: idAbstractBoxContainer

    // PROPERTIES
    property bool checkCondition: false

    property string imageUncheck: ""
    property string imageCheck: ""


    /* EVENT handlers */
    onCheckConditionChanged: {
        if(true == checkCondition) {
            idImageBox.source = imageCheck;
        } else {
            idImageBox.source = imageUncheck;
        }
    }


    /* WIDGETS */
    Image {
        id: idImageBox

        source: (true == checkCondition) ? imageCheck : imageUncheck

        anchors.verticalCenter: idAbstractBoxContainer.verticalCenter
        anchors.horizontalCenter: idAbstractBoxContainer.horizontalCenter
    }
}
/* EOF */
