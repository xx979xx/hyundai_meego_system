#ifndef DHAVN_CONTENTMENUAREA_UTILS_H
#define DHAVN_CONTENTMENUAREA_UTILS_H

#include <QObject>
#include "QVariant"

#define UTILS DHAVN_ContentMenuArea_Utils

const uint MAX_URL_LENGHT = 256;

class DHAVN_ContentMenuArea_Utils : public QObject
{
   Q_OBJECT
   Q_ENUMS( CONTENT_MENU_ID_ITEM_T );

public:
   enum CONTENT_MENU_ID_ITEM_T
   {
      ID_ITEM_ENABLED,
      ID_ITEM_ICON_URL,
      ID_ITEM_TEXT,
      ID_ITEM_CHECKBOX,
      ID_ITEM_CHECKBOX_VALUE,
      ID_ITEM_RIGHT_CONTENT,
      ID_ITEM_RIGHT_CONTENT_QML_URL,

      ID_ITEM_MAX
   };

   struct CONTENT_MENU_ITEM_T
   {
      bool    enabled;
      wchar_t icon_url[MAX_URL_LENGHT];
      wchar_t text[MAX_URL_LENGHT];
      bool    checkbox;
      bool    checkbox_value;
      bool    right_content;
      wchar_t right_content_qml_url[MAX_URL_LENGHT];
   };

   DHAVN_ContentMenuArea_Utils( QObject *parent = 0 );
   QVariantList create_menu( CONTENT_MENU_ITEM_T* menu, int size );
   QVariant get_value( QVariantList &model, int index_x, CONTENT_MENU_ID_ITEM_T index_y );
   void set_value( QVariantList &model, int index_x, CONTENT_MENU_ID_ITEM_T index_y, QVariant value );
};

#endif // DHAVN_CONTENTMENUAREA_CONST_H
