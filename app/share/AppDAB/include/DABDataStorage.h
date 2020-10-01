#ifndef DABDATASTORAGE_H
#define DABDATASTORAGE_H

/**
 * FileName: DABDataStorage.h
 * Author: David.Bae
 * Time: 2011-08-43 16:44
 * Description:
 *          This file is used for Data Management for DAB.
 */

#include <QObject>
#include "ListModel.h"
#include "DABChannelItem.h"

//#define DAB_MODE_MAX_COUNT 3 //DAB1, DAB2, DAB3
//#define MAX_CHANNEL_COUNT 200
//#define MAX_PRESET_COUNT 24

/*
const int maxCount = 9;
static int count = 0;
;
struct m_stChannelInfo_ {
    QString chInfo;
    QString sName;
    QString eName;
}_stChannelInfo;

m_stChannelInfo_ m_aCh[100] = { {"7C", "Break News", "BBC"},
                               {"5A", "Music Life", "D2"},
                               {"8A", "Sports News", "YTN"},
                               {"6B", "Weather Broadcasting", "MBN"},
                               {"12C", "News Today", "MBC"},
                               {"10C", "Radio! Radio! Radio!", "Aljajira"},
                               {"11D", "Frech Cafe", "France"},
                               {"13D", "SamDaSu", "JeJu"},
                               {"13F", "BYC Panty", "BYC"}, };
*/
class DABDataStorage : public QObject
{
    Q_OBJECT
public:
    explicit DABDataStorage(QObject *parent = 0);
    ~DABDataStorage();

    //void loadData(void);
    //void saveData(void);
    /*
    bool setDABMode(int modeNum);
    int getDABMode(void); //DAB1, DAB2, DAB3

    inline QString getCurrentChannelNumber(void) {return (m_CurrentChannel[m_iCurrentDABMode] != NULL)?m_CurrentChannel[m_iCurrentDABMode]->frequencyLabel():"";}
    inline QString getCurrentServiceName(void) { return (m_CurrentChannel[m_iCurrentDABMode] != NULL )?m_CurrentChannel[m_iCurrentDABMode]->label():"";}
    inline QString getCurrentEnsembleName(void) { return(m_CurrentChannel[m_iCurrentDABMode] != NULL)?m_CurrentChannel[m_iCurrentDABMode]->ensembleLabel():"";}
    inline QString getCurrentPtyName(void) { return m_sCurrentPtyName[m_iCurrentDABMode]; }
    inline ListModel* getCurrentChannelList(void) { return m_listChannel[m_iCurrentDABMode];}
    inline ListModel* getCurrentPresetList(void) { return m_listPresetChannel[m_iCurrentDABMode];}

    inline DABChannelItem* getCurrentChannelItem(void) { return m_CurrentChannel[m_iCurrentDABMode];}

    //
    inline int getCurrentChannelCount(void) { return this->m_listChannel[m_iCurrentDABMode]->rowCount(); }
    inline bool isEmpty(void) { return (this->m_listChannel[m_iCurrentDABMode]->rowCount() == 0); }
    */

    //Preset
//    int  makePresetListFromChannelList(void);
//    bool addPresetChannelFromCurrentChannel(void);
//    bool removePresetChannel(int index);
//    bool movePositionOfPresetChannel(int fromIndex, int toIndex);

    //Select Service
//    DABChannelItem* getChannelItemFromChannelList(int index);
//    DABChannelItem* getChannelItemFromPresetList(int index);
//    void setCurrentChannelInfoFromChannelList(int index);
//    void setCurrentChannelInfoFromPresetList(int index);
//    void setCurrentChannelInfoFromItem(DABChannelItem* pItem);

    //Seek Service


    //setting
    //inline void setSkinMode(QString skin) {this->m_sSkinMode = skin;}
    //inline QString getSkinMode(void) {return this->m_sSkinMode;}
    //quint8 getCurrentBand(void){ return this->m_iSettingBand;}

//    void washOffCurrentChannelData(void);

signals:

public slots:
    /*
    void addChannelItem(quint32 freq,
                        quint16 eId,
                        QString eLabel,
                        quint8 sCount,
                        quint32 sID,
                        quint16 cer,
                        quint8 sType,
                        quint8 subChId,
                        quint16 bitrate,
                        quint8 ps,
                        quint8 charset,
                        QString sLabel);
                        */
private:
    //stDABChannelInfo m_aChannelInfo[DAB_MODE_MAX_COUNT][MAX_CHANNEL_COUNT];

//    int m_iCurrentDABMode;
//    DABChannelItem* m_CurrentChannel[DAB_MODE_MAX_COUNT];
//    ListModel* m_listChannel[DAB_MODE_MAX_COUNT];
//    QString m_sCurrentPtyName[DAB_MODE_MAX_COUNT];

//    ListModel* m_listPresetChannel[DAB_MODE_MAX_COUNT];

//    void loadDataFromFile(QString fileName, DABChannelItem* cItem, ListModel* listModel, ListModel* presetListModel);
//    void saveDataToFile(QString fileName, DABChannelItem* cItem, ListModel* listModel, ListModel* presetListModel);


//    //Settings
//    int m_iSettingBand;
//    QString m_sSkinMode;
//    void loadSettingFromFile(QString fileName);
//    void saveSettingToFile(QString fileName);
};

#endif // DABDATASTORAGE_H
