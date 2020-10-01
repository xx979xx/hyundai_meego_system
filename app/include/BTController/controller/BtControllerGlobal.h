#ifndef __BT_CONTROLLER_GLOBAL_H__
#define __BT_CONTROLLER_GLOBAL_H__

#include <QtCore/qglobal.h>

#if defined(BTCONTROLLER_LIBRARY)
#  define BTCONTROLLER_EXPORT Q_DECL_EXPORT
#else
#  define BTCONTROLLER_EXPORT Q_DECL_IMPORT
#endif

#endif // __BT_CONTROLLER_GLOBAL_H__