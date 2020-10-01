/*
******************************************************************
*        COPYRIGHT (C) Teleca AB      *
*----------------------------------------------------------------*
* MODULE     :  DHAVN_TrackerAbstractor                             *
*
* PROGRAMMER :  Chetan Nanda                                   *
* DATE       :  12 September 2011                                    *
* VERSION    :  1.0                                              *
*
*----------------------------------------------------------------*
*                                                                *
* MODULE SUMMARY : This file defines class which interact with    *
*                  different contect providers (e.g. Media, Text Search, Contact)             *
*                  and used by application to retrieve information from respective    *
*                  content provider.           *
*                                                                *
*----------------------------------------------------------------*
*
* MODIFICATION RECORDS :                                         *
*
* VERSION   DATE                     PROGRAMMER              COMMENT
******************************************************************
* 1.0       12 September 2011  Chetan Nanda           Draft version
******************************************************************
*/

#ifndef DHAVN_SQLITEABSTRACTOR_H
#define DHAVN_SQLITEABSTRACTOR_H

#include <QQueue>
#include <QtSql/QSqlDatabase>
#include <QStringList>
#include <QVector>
#include "DHAVN_SQLiteAbstractor_constants.h"

/**
   * forward declartion
   */
class CContactsDataProvider;
class CSQLiteDataUpdater;
class QTimer;

/**
   * This class will handle the request from the application and forward it to
   *  respective data provider class. This class exposes the signal that the application
   *  would be calling for any operation like receiving data
   */
class  CSQLiteAbstractor  : public QObject
{
	Q_OBJECT

public:

    /**
       * Default Constructor
       */
    CSQLiteAbstractor();

    /**
       * Default Destructor
       */
    ~CSQLiteAbstractor();

	/* @@@ For PhoneBook DB - SQLite @@@ */
    bool RequestPBData(const QString& searchData, const ESQLiteAbstarctor_Query_Ids queryId);
	bool RequestPBData(const QString& searchData1, const QString& searchData2
                        , const ESQLiteAbstarctor_Query_Ids queryId);
	bool RequestPBData(const QString& bd_address, const BT_PBAP_DB_SORTING sortBy
                        , const ESQLiteAbstarctor_Query_Ids queryId);

	bool RequestPBData(const QString& bd_address
						, const QString& firstName, const QString& lastName
						, const QString& phoneNumber
                        , const ESQLiteAbstarctor_Query_Ids queryId);
/////SUPPORT_MIDDLE_NAME
	bool RequestPBData(const QString& bd_address
						, const QString& firstName, const QString& lastName, const QString& middleName
						, const QString& phoneNumber
                        , const ESQLiteAbstarctor_Query_Ids queryId);

/////SUPPORT_MIDDLE_NAME
    bool RequestPBData(const QString& bd_address, const QString& phoneNumber
                        , const int section, const ESQLiteAbstarctor_Query_Ids queryId);

	bool RequestPBData(const QString& bd_address
						, const QString& firstName, const QString& lastName
						, const QString& phoneNumber, const int section
                        , const ESQLiteAbstarctor_Query_Ids queryId);

    bool UpdatePBData(void* data, ESQLiteAbstarctor_Query_Ids const queryId);



    
    /*This API is to set a offset variable to specified queries*/
    void setQueryOffset(int offset);
    /*This API is to set a limit variable to specified queries*/
    void setQueryLimit(int limit);
	
    //{added by junam 2013.05.23 for sorting
    static int GetCountryVariant() { return m_CountryVariant; }
    static void SetCountryVariant(int var) { m_CountryVariant = var; }
    //}added by junam

signals:

    /**
       * Signal to notify the application on query completion
       */
    void RequesteComplete(QVector<QStringList> dataList, ESQLiteAbstarctor_Query_Ids queryId, uint reqUID = 0);

    void Error(int, uint reqUID = 0);
    void RequestState(int, uint reqUID = 0);

private slots:

    /**
       * Slot to get notification from providers on query completion
       */
    void DataReceived(QVector<QStringList> dataList, ESQLiteAbstarctor_Query_Ids queryId);
    /**
       * Slot to get notification from providers on query completion for dynamic fetching
       */
//    void DataLimitReceived(QVector<QStringList> dataList, ESQLiteAbstarctor_Query_Ids queryId, int offset);
    void ErrorReceived(int error);

public slots:

private:
    /* This API is to handle the Query Requests */
    void HandleError(int nError);

private:

    /**
       * contacts data provider object to request call contacts related APIs
       */
    CContactsDataProvider* m_ContactsDataProvider;

    /**
      * SQLite data updater object
      */
    CSQLiteDataUpdater* m_DataUpdater;
	
    /**
      * A offset value for specifed queries
      */
    int m_Query_Offset;

    /**
      * A limit value for specifed queries
      */
    int m_Query_Limit;

//    QTimer  *m_QueueRequestTimer;

	QString m_Removed_DeviceId; // added by eugene.seo 2013.04.29
    static int m_CountryVariant;//added by junam 2013.05.23 for sorting

    QStringList m_DevId;
    QString m_deviceid;

    QSqlDatabase* m_SQLitePhonebookDBPointer;
};

#endif // DHAVN_TRACKERABSTRACTOR_H
