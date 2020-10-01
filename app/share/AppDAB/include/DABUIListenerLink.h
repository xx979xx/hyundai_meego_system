#ifndef DABUILISTENERLINK_H
#define DABUILISTENERLINK_H

#include <QObject>

class DABUIListener;
class DABChannelItem;
class DABUIListenerLink : public QObject
{
public:
    explicit DABUIListenerLink(DABUIListener &aDABUIListener, /*DABChannelManager *pChannelManager,*/ QObject* parent = 0);
    ~DABUIListenerLink();

    bool setNextChannelInfoForTuneUpDown(void);
    bool setPrevChannelInfoForTuneUpDown(void);
    bool setNextChannelInfoForShortSeek(void);
    bool setPrevChannelInfoForShortSeek(void);
    void changeNormalMode(void);
    bool checkCurrentChannelItem(void);
    void removeTempFiles(void);
    void removeSLSFile(QString sls);
    QString getTAType(quint16 flags);
    void setAnnouncementFlag(quint16 flag);
    void setViewChannelInfoFromItem(DABChannelItem* pItem);
    void setCurrentChannelInfoFromItem(DABChannelItem* pItem);
    void setCurrentPresetIndex(DABChannelItem* pItem);
    QString getSectionStatus(quint32 freq);
    void washOffCurrentChannelData(void);
    bool setCurrentChannelInfoFromPresetList(int index);

private:
    DABUIListener &m_dabUIListener;
};

#endif // DABUILISTENERLINK_H
