import QtQuick 1.0
import "../DhAvnSimpleItemsResources.js" as RES
import "DHAVN_SimpleItems_IncDecButton.js" as Private

Item
{
    id: incdec_button

    width: Private.const_SCROLL_BAR_BUTTON_WIDTH
    height: Private.const_SCROLL_BAR_BUTTON_HEIGHT

    property bool bIsIncrement: false

    property url __increment_button_n: RES.const_URL_IMG_GENERAL_PLUS_N

    property url __increment_button_p: RES.const_URL_IMG_GENERAL_PLUS_P

    property url __decrement_button_n: RES.const_URL_IMG_GENERAL_MINUS_N

    property url __decrement_button_p: RES.const_URL_IMG_GENERAL_MINUS_P

    property url __image_source_n: (bIsIncrement) ? __increment_button_n : __decrement_button_n

    property url __image_source_p: (bIsIncrement) ? __increment_button_p : __decrement_button_p

    signal click

    Image
    {
        id: button_image
        source: __image_source_n
        anchors.fill: parent
    }

    MouseArea
    {
        anchors.fill: parent

        onPressed:
        {
            button_image.source = __image_source_p
        }

        onReleased:
        {
            button_image.source = __image_source_n
        }

        onClicked:
        {
            click()
        }
    }
}
