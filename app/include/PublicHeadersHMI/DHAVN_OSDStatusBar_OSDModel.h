#ifndef DHAVN_OSDSTATUSBAR_OSDMODEL_H
#define DHAVN_OSDSTATUSBAR_OSDMODEL_H

#include "DHAVN_StatusControl_Def.h"

#include <QAbstractListModel>
#include <QModelIndex>
#include <QVariant>
#include <QTimer>
#include <QTime>
#include <QUrl>


class OSDItem
{
public:
   OSDItem() : m_nSlotType(SB_OSD_Enum_Def::OSD_MEDIA_BAR_NONE),
      m_vBarIcon(""),
      m_vBarText(""),
      m_vFirstIcon(""),
      m_vSecondIcon(""),
      m_vFirstText(""),
      m_vFirstTextColor(""),
      m_nFirstTextWidth(0),
      m_vSecondText(""),
      m_vSecondTextColor(""),
      m_nSecondTextWidth(0),
      m_vThirdText(""),
      m_vThirdTextColor(""),
      m_nThirdTextWidth(0),
      m_nSpaceBetweenText(0),
      m_bScanEnable(false),
      m_bShuffleEnable(false),
      m_bRepeatEnable(false),
      m_bRepeatAll(true),
      m_vCountText(""),
      m_vPlaybackTime(""),
      m_nPlaybackTimeMargin(0),
      m_bHDEnable(false),
      m_vRadioText(""),
      m_vRadioTextColor(""),
      m_nModeType(SB_OSD_Enum_Def::OSD_MEDIA_MODE_NONE),
      m_bWindDirectionSingle(false),
      m_nWindStrength(0),
      m_nWindStrengthModeType(SB_OSD_Enum_Def::OSD_CLIMATE_CLEAN_AIRMODE_OFF),
      m_bEnabledAC(false),
      m_bAutoMode(false) {};
   ~OSDItem() {};

   void clear()
   {
      m_nSlotType = SB_OSD_Enum_Def::OSD_MEDIA_BAR_NONE;
      m_vBarIcon = QVariant("");
      m_vBarText = QVariant("");
      m_vFirstIcon = QVariant("");
      m_vSecondIcon = QVariant("");
      m_vFirstText = QVariant("");
      m_vFirstTextColor = QVariant("");
      m_nFirstTextWidth = 0;
      m_nSpaceBetweenText = 0;
      m_vSecondText = QVariant("");
      m_vSecondTextColor = QVariant("");
      m_nSecondTextWidth = 0;
      m_vThirdText = QVariant("");
      m_vThirdTextColor = QVariant("");
      m_nThirdTextWidth = 0;
      m_bScanEnable = false;
      m_bShuffleEnable = false;
      m_bRepeatEnable = false;
      m_bRepeatAll = true;
      m_vCountText = QVariant("");
      m_vPlaybackTime = QVariant("");
      m_nPlaybackTimeMargin = 0;
      m_bHDEnable = false;
      m_vRadioText = QVariant("");
      m_vRadioTextColor = QVariant("");
      m_nModeType = SB_OSD_Enum_Def::OSD_MEDIA_MODE_NONE;
      m_bWindDirectionSingle = false;
      m_nWindStrength = 0;
      m_nWindStrengthModeType = 0;
      m_bEnabledAC = false;
      m_bAutoMode = false;
   };

public:
   int m_nSlotType;
   QVariant m_vBarIcon;
   QVariant m_vBarText;
   QVariant m_vFirstIcon;
   QVariant m_vSecondIcon;
   QVariant m_vFirstText;
   QVariant m_vFirstTextColor;
   int m_nFirstTextWidth;
   QVariant m_vSecondText;
   QVariant m_vSecondTextColor;
   int m_nSecondTextWidth;
   QVariant m_vThirdText;
   QVariant m_vThirdTextColor;
   int m_nThirdTextWidth;
   int m_nSpaceBetweenText;
   bool m_bScanEnable;
   bool m_bShuffleEnable;
   bool m_bRepeatEnable;
   bool m_bRepeatAll;
   QVariant m_vCountText;
   QVariant m_vPlaybackTime;
   int m_nPlaybackTimeMargin;
   bool m_bHDEnable;
   QVariant m_vRadioText;
   QVariant m_vRadioTextColor;
   int m_nModeType;
   bool m_bWindDirectionSingle;    // single/ double
   int m_nWindStrength;            // 0~8
   int m_nWindStrengthModeType;    // OFF/ Clean air/ Ion air
   bool m_bEnabledAC;
   bool m_bAutoMode;
};

class OSDModel : public QAbstractListModel
{
   Q_OBJECT

public:
   enum Roles
   {
      SlotType = Qt::UserRole + 1,
      BarIcon,
      BarText,
      FirstIcon,
      SecondIcon,
      FirstText,
      FirstTextColor,
      FirstTextWidth,
      SecondText,
      SecondTextColor,
      SecondTextWidth,
      ThirdText,
      ThirdTextColor,
      ThirdTextWidth,
      SpaceBetweenText,
      ScanEnable,
      ShaffleEnable,
      RepeatEnable,
      RepeatAll,
      CountText,
      PlaybackTime,
      HDEnable,
      RadioText,
      RadioTextColor,
      ModeType,
      WindDirectionSingle,
      WindStrength,
      WindStrengthModeType,
      AC_EnabledAC,
      AC_AutoMode,
      PlaybackTimeMargin
   };

   OSDModel( QObject *parent = 0 );
   ~OSDModel( ) {};

   QVariant data(const QModelIndex &index, int role) const;
   int rowCount(const QModelIndex &parent = QModelIndex()) const;

   void processData(OSD_MEDIA_INFO* nInfo );
   void processClimateData(OSD_CLIMATE_INFO* nInfo );
   void changePlayTime( int msec );

public slots:
   void hideOSD();
   void updateOSD();

signals:
   void updateRadioText(QVariant str);

private:
   OSDItem m_OSDItem;
   QList<OSDItem> m_OSDModel;
   QTimer *m_tOSD_Timer;
   QTimer *m_tDrawOSD_Timer;
   int m_nOSDFrameCount;

   QVariant getIconBarMode( int );
   QVariant getTextBarMode( int );
   QVariant getInfoIcon( int );
   QVariant getClimateIcon( int );

   void setPlaybackTime( const QTime &time, int nModeType );
   bool isAudioModeType( int nModeType );
   void clearOSD();

   bool processRadioTVData(OSD_MEDIA_INFO* nInfo );
   void processVolumeData( OSD_MEDIA_INFO* nInfo );
   void processMediaData(OSD_MEDIA_INFO* nInfo );
   void processInfoData( OSD_MEDIA_INFO* nInfo );
   void processIBoxData(OSD_MEDIA_INFO* nInfo );
   void processCenterInfoData( OSD_MEDIA_INFO* nInfo );
   void processPandoraData(OSD_MEDIA_INFO* nInfo );

   void processACData( OSD_CLIMATE_INFO* nInfo );
   void processGarageData( OSD_MEDIA_INFO* nInfo );
};

#endif // DHAVN_OSDSTATUSBAR_OSDMODEL_H
