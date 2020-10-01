#ifndef DHAVN_POPUP_SHARED_H
#define DHAVN_POPUP_SHARED_H

#include <QObject>

class DHAVN_POPUP: public QObject
{
   Q_OBJECT
   Q_ENUMS( TYPE_OF_POPUP_ICON_T );

public:

    enum TYPE_OF_POPUP_ICON_T
    {
       NONE_ICON = 0,
       WARNING_ICON,
       LOADING_ICON,
       ZOOM_X
    };
};

#endif //DHAVN_POPUP_SHARED_H
