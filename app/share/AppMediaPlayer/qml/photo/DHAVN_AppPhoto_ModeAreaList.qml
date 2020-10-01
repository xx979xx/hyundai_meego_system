import Qt 4.7

ListModel
{
   id: mode_area_model

   ListElement
   {
   //modified by aettie 20130806 for ITS 0182945
      name:QT_TR_NOOP("STR_MEDIA_PHOTO_JUKEBOX")
      isVisible: false
      tab_id: "Jukebox"
   }
   //[KOR][ITS][181982][minor](aettie.ji)
   ListElement
   {
      name:QT_TR_NOOP("STR_MEDIA_PHOTO_USB_FRONT")
      name_fr:QT_TR_NOOP("STR_MEDIA_FRONT") // added by AVP for  VI GUI 2014.04.28
      isVisible: false
      tab_id: "USB1"
   }
   ListElement
   {
      name:QT_TR_NOOP("STR_MEDIA_PHOTO_USB_REAR")
      name_fr:QT_TR_NOOP("STR_MEDIA_REAR") // added by AVP for  VI GUI 2014.04.28
      isVisible: false
      tab_id: "USB2"
   }
   //[KOR][ITS][180278](aettie.ji)
   ListElement
   {
      name:QT_TR_NOOP("STR_MEDIA_PHOTO_USB")
      isVisible: false
      tab_id: "USB"
   }
   property string rb_text: QT_TR_NOOP("STR_MEDIA_LIST_MENU")	
   property bool rb_visible: true
   property string mb_text: QT_TR_NOOP("STR_SETTING_SYSTEM_DISPLAY");
   property bool mb_visible: true;
   property bool isTrBG: true; //[KOR][ITS][0181269][minor](aettie.ji)

}
