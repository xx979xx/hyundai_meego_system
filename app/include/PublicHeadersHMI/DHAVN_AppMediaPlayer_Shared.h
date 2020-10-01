#ifndef DHAVN_APPMEDIAPLAYER_GLOBAL_H
#define DHAVN_APPMEDIAPLAYER_GLOBAL_H

#define MAX_LENGTH 255

typedef enum
{
    SET_PLAYING_AUDIO_FILE,
    SET_PLAYING_VIDEO_FILE
} MEDIAPLAYER_COMMANDS_T;

//typedef enum
//{
//    SET_PLAYING_AUDIO_FILE,
//    SET_PLAYING_VIDEO_FILE
//} MEDIAP_COMMANDS_T;

typedef enum
{
    USB = 0,
    DVD,
    JUKEBOX,
    VCD,
    DATACD,
    IPOD,
    SSD,
    SDCARD 
} MEDIA_FILE_SOURCE_T;

typedef struct
{
    wchar_t sSongTitle[MAX_LENGTH];
    wchar_t sSongURL[MAX_LENGTH];
    wchar_t sNameArtist[MAX_LENGTH];
    wchar_t sNameAlbum[MAX_LENGTH];
    wchar_t sNameGenre[MAX_LENGTH];
}  MEDIA_SEARCH_INFO_T;


//VideoPlayer stuff
#define FILE_NAME_SIZE 1024
#define DIR_TREE_FILE_NAME_SIZE 64
#define DIR_TREE_BLOCK_NUM 10
#define VP_SETTINGS_FILE_DB "/home/meego/.config/VideoPlayerSettings.db"
#define VP_SETTINGS_MP_DB "video_player_app"
#define VP_PERSISTMAN_MGR_CONTROL_SAVING
#define VP_SETTINGS_VIDEO_URL_MAX_LENGHT 256

enum PLAYBACK_NOTIFY
{
   PLAYBACK_STARTED = 100
};

enum DEC_COMMANDS
{
   DEC_NONE = 1000,
   DEC_PLAY,                // 1001
   DEC_STOP,                // 1002
   DEC_PAUSE,               // 1003
   DEC_NEXT,                // 1004
   DEC_PREV,                // 1005
   DEC_INSERT,              // 1006
   DEC_RELOAD,              // 1007
   DEC_EJECT,               // 1008
   DEC_FASTFORWARD,         // 1009
   DEC_REWIND,              // 1010
   DEC_NORMALPLAY,          // 1011
   DEC_SCAN_OFF,            // 1012
   DEC_SCAN_FILE,           // 1013
   DEC_SCAN_FOLDER,         // 1014
   DEC_REPEAT_OFF,          // 1015
   DEC_REPEAT_FILE,         // 1016
   DEC_REPEAT_FOLDER,       // 1017
   DEC_RANDOM_OFF,          // 1018
   DEC_RANDOM_FILE,         // 1019
   DEC_RANDOM_FOLDER,       // 1020
   AUDIO_CD_INSERTED,       // 1021
   AUDIO_CD_RELOADED,       // 1022
   MP3_CD_INSERTED,         // 1023
   MP3_CD_RELOADED,         // 1024
   REQUEST_DISK_STATE,      // 1025
   DISK_STATE_NOT_PRESENT,  // 1026
   AUDIO_CD_TOC,            // 1027
   DEC_PREV_VR,             // 1028
   REQUEST_FOLDER_CHUNK,    // 1029
   RESPONSE_FOLDER_CHUNK,   // 1030
   AUDIO_DVD_INSERTED,      // 1031
   AUDIO_DVD_RELOADED,      // 1032

   DEC_LAST
};

enum PLAYBACK_STATE
{
   STATE_PLAY = 2000,
   STATE_PAUSE,
   STATE_STOP,
   STATE_LAST
};

enum PLAYBACK_META_DATA
{
   TRACK_NAME = 3000,
   TRACK_DURATION,
   TRACK_POSITION,
   TRACK_COUNT,
   TRACK_INDEX,
   TRACK_LAST,
   TRACKS_DELETED,
   TRACK_TAG_INFO,
   TRACKS_CHANGED
};

enum RANDOM_STATE
{
   RANDOM_OFF = 4000,
   RANDOM_FILE,
   RANDOM_FOLDER
};

enum REPEAT_STATE
{
   REPEAT_OFF = 5000,
   REPEAT_FILE,
   REPEAT_FOLDER
};

enum START_PARAMETER
{
   /*HardCode. Don't change this enum!!!*/
   START_BY_SETTINGS = 6000,
   START_BY_SETTINGS_SCREEN_SETTINGS
};

struct Deck_TrackName
{
   char fileName[FILE_NAME_SIZE];
};

enum OSD_EVENT
{
   VP_OSD_EVENT_AV_OFF,
   VP_OSD_EVENT_FORMAT_ERR_MSG,
   VP_OSD_EVENT_DISC_EJECT_ERROR,
   VP_OSD_EVENT_USB_READING,
   VP_OSD_EVENT_USB_ERR_MSG,
   VP_OSD_EVENT_DISC_READING,
   VP_OSD_EVENT_DISC_ERROR,
   VP_OSD_EVENT_DEVICE_CONNECTED,
   VP_OSD_EVENT_OPERATION_IS_NOT_SUPPORTED
};

struct FolderDataRequest
{
    int folderId;
    int blockIndex;
};

struct DvdDirEntryMsg
{
    int type; // Indicates type of the entry such as file(WMA/MP3) or folder
    int playing_now_or_next;
    int file_folder_num; // file/folder index on the disc.
    wchar_t file_folder_name[DIR_TREE_FILE_NAME_SIZE]; // file/folder name.
};

struct DvdDirTreeMsg
{
    int curr_folder; // folder id
    int block_no; //current block number. One block contains 10 file/folder.
    wchar_t folder_name[DIR_TREE_FILE_NAME_SIZE];
    int unicode;  // Indicate if Unicode characters used.
    int chld_folder_num; // Number of child folders.
    int chld_file_num; // Number of child files.
    DvdDirEntryMsg entry[DIR_TREE_BLOCK_NUM];
};

struct VP_DB_KEYS_T
{
   const char *keyString;
};

struct DeletedFiles
{
   bool typeSource;
   char mPathToDeletedFiles [32000];
};

enum VP_DB_KEY_T
{
   VP_DB_KEY_LMDATA,
   VP_DB_KEY_DVD_PRESENT
#ifdef VP_PERSISTMAN_MGR_CONTROL_SAVING
   ,VP_DB_KEY_FIX_SAVE
#endif
};

static const VP_DB_KEYS_T VP_DB_KEYS[] =
{
   { "database" },
   { "dvd_present" }
   #ifdef VP_PERSISTMAN_MGR_CONTROL_SAVING
   ,{ "fix_save" }
   #endif
};

#endif // DHAVN_APPMEDIAPLAYER_GLOBAL_H
