#ifndef CDBUSWRAPPER_H
#define CDBUSWRAPPER_H

#include <QObject>
#include <QString>
#include <QtDBus/QtDBus>
#include <QMetaType>
#include <QDBusArgument>
#include "GNDBusWrapper_global.h"
#include <QtSparql/QSparqlResult>
#include <QtSparql/QSparqlConnection>
#include "playlistresults.h"

typedef void* gnplaylist_results_handle_t;


//Constants
/**
  * QSparql query for retrieving playlist Data for each media file in the Playlist
  *  from the Tracker Store.
  */
const QString gRetrievePlaylistQuery = "SELECT ?playlist ?url WHERE {?playlist a nmm:Playlist ; nie:title '%1' .?playlist nfo:hasMediaFileListEntry ?entry . ?entry nfo:entryUrl ?url}";

/**
  * QSparql query for inserting the playlist details in the Tracker Store.
  */
const QString gInsertPlaylistQuery = ("INSERT {<%1> "
                                                    "a nmm:Playlist; nie:title '%2';"
                                                    "nfo:entryCounter %3;");
/**
  * QSparql query for fetching the media file list information from
  *  the Tracker Store.
  */
const QString gMediaListEntry = ("nfo:hasMediaFileListEntry "
                                                 "[ a nfo:MediaFileListEntry;"
                                                 "nfo:entryUrl '%1';"
                                                 "nfo:listPosition %2]");

 /* * QSparql query for checking a playlist in the Tracker Store.  */
const QString gCheckPlaylist = ("SELECT ?playlist WHERE {?playlist a nmm:Playlist}");

 
class CGracenotePlaylist;

class GNDBUSWRAPPERSHARED_EXPORT CDBusWrapper : public QDBusAbstractAdaptor
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.lge.moreLikeThisWrapper")
    Q_CLASSINFO("D-Bus Introspection", ""
"  <interface name=\"org.lge.moreLikeThisWrapper\">\n"
"    <!-- CreatePlaylist():  Create a playlist as per the field type and field matching string specified by the user-->\n"
"    <method name=\"CreatePlaylist\">\n"
"      <arg direction=\"in\" type=\"s\" name=\"filed\"/>\n"
"      <arg direction=\"in\" type=\"s\" name=\"matchingString\"/>\n"
"    </method>\n"
"    <!-- CreateMoreLikeThis():  Create a playlist from a seed track, album, artist etc-->\n"
"    <method name=\"CreateMoreLikeThis\">\n"
"      <arg direction=\"in\" type=\"s\" name=\"seedType\"/>\n"
"      <arg direction=\"in\" type=\"s\" name=\"seedString\"/>\n"
"    </method>\n"
"    <signal name=\"PlaylistDataReceived\">\n"
"      <annotation value=\"PlaylistResults\" name=\"com.trolltech.QtDBus.QtTypeName.In0\"/>\n"
"      <arg direction=\"out\" type=\"(i(ssssssiiiiii))\" name=\"results\"/>\n"
"    </signal>\n"
"  </interface>\n"
        "")
public:
    CDBusWrapper(QObject *parent = 0);
    ~CDBusWrapper();

public Q_SLOTS: // METHODS    
    Q_INVOKABLE void    CreatePlaylist(const QString &field, const QString &matchingString);
    Q_INVOKABLE void    CreateMoreLikeThis(const QString &seedType, const QString &seedString);

public:    
    bool                CheckIfPlaylistExistsInTracker(QString playlistCriteria);
    bool                UpdateTrackerWithPlaylistInfo(QString playlistCriteria, PlaylistResults playlistData);
    PlaylistResults     RetrievePlaylistFromTracker(QString playlistCriteria);

Q_SIGNALS:
    void PlaylistDataReceived(PlaylistResults results);
    
private:
    void                ParsePlaylistFromTracker();
    void                CreatePlaylistUsingGracenote(QString strField, QString strMatchingString);
    void                CreateMoreLikeThisUsingGracenote(QString strSeedType, QString strSeedString);
    void                ParsePlaylistDataFromGracenote(gnplaylist_results_handle_t hResult);
    void                PrintPlaylistResult(int nMaxPrintCount);

    bool                ExecuteQuery(QString query , QSparqlQuery::StatementType type );
    QString             ModifyString(QString inputStr);
    QString             ModifyFileName(QString originalFileName);
    
    PlaylistResults                 m_PlaylistResults;
    CGracenotePlaylist             *m_pGNPlaylist;
    QSparqlConnection              *m_pSparqlConnection;
};

#endif // CDBUSWRAPPER_H
