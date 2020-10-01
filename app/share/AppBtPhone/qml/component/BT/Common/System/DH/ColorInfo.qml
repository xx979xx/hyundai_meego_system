/**
 * ColorInfo.qml
 *
 */
import QtQuick 1.1


Item 
{
    id: idColorInfoContainer

    property color black:           Qt.rgba(0,       0,       0,       1)
    property color white:           Qt.rgba(255,     255,     255,     1)
    property color brightGrey:      Qt.rgba(250/255, 250/255, 250/255, 1)
    property color subTextGrey:     Qt.rgba(212/255, 212/255, 212/255, 1)
    property color grey:            Qt.rgba(193/255, 193/255, 193/255, 1)
    property color dimmedGrey:      (1 == UIListener.invokeGetVehicleVariant()) ? Qt.rgba(164/255, 146/255, 146/255, 1) : Qt.rgba(158/255, 158/255, 158/255, 1)
    property color commonGrey:      Qt.rgba(204/255, 196/255, 196/255, 1)
    property color disableGrey:     (1 == UIListener.invokeGetVehicleVariant()) ? Qt.rgba( 74/255,  66/255,  66/255, 1) : Qt.rgba( 91/255,  91/255,  91/255, 1)
    property color buttonGrey:      Qt.rgba( 47/255,  47/255,  47/255, 1)
    property color bandBlue:        (1 == UIListener.invokeGetVehicleVariant()) ? Qt.rgba(255/255, 126/255, 0/255, 1) : Qt.rgba(124/255, 189/255, 255/255, 1)

    property string transparent:    "transparent"
}
/* EOF */
