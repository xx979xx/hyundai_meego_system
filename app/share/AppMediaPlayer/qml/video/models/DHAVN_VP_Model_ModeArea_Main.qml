import QtQuick 1.0

ListModel
{
    id: mode_area_model

    ListElement
    {
    //modified by aettie 20130806 for ITS 0182945
        name: QT_TR_NOOP("STR_MEDIA_VIDEO_JUKEBOX")
        isVisible: false
        isSwitchable: false //added by ruinseve for CR#13492
        selected: false
        tab_id: "Jukebox"
    }
//[KOR][ITS][181982][minor](aettie.ji)
    ListElement
    {
        name: QT_TR_NOOP("STR_MEDIA_VIDEO_USB_FRONT") // modified by lssanh 2013.03.01 ISV74413
        isSwitchable: false //added by ruinseve for CR#13492
        isVisible: false
        selected: false
        tab_id: "USB1"
    }

    ListElement
    {
        name: QT_TR_NOOP("STR_MEDIA_VIDEO_USB_REAR") // modified by lssanh 2013.03.01 ISV74413
        isVisible: false
        isSwitchable: false //added by ruinseve for CR#13492
        selected: false
        tab_id: "USB2"
    }

    ListElement
    {
        name: QT_TR_NOOP("STR_MEDIA_MNG_DVD")
        isVisible: false
        selected: false
        tab_id: "DVD"
    }

    ListElement
    {
        name: QT_TR_NOOP("STR_MEDIA_MNG_VCD")
        isVisible: false
        selected: false
        tab_id: "VCD"
    }
    ListElement
    {
        name: QT_TR_NOOP("STR_MEDIA_DISC")
        isVisible: false
        isSwitchable: false //added by ruinseve for CR#13492
        selected: false
        tab_id: "Disc"
    }

    ListElement
    {
        name: QT_TR_NOOP("STR_MEDIA_AUX")
        isVisible: false
        isSwitchable: false //added by ruinseve for CR#13492
        selected: false
        tab_id: "Aux1"
    }

    ListElement
    {
        name: QT_TR_NOOP("STR_MEDIA_AUX")
        isVisible: false
        isSwitchable: false //added by ruinseve for CR#13492
        selected: false
        tab_id: "Aux2"
    }
}
