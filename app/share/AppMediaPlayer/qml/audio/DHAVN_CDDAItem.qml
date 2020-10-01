import QtQuick 1.0
import AudioControllerEnums 1.0
import ListViewEnums 1.0  //added by junam 2013.08.29 for ITS_KOR_185043

import "DHAVN_AppMusicPlayer_General.js" as MPC
import "DHAVN_AppMusicPlayer_Resources.js" as RES

/* Jukebox Tab view */

Item
{
// { removed by junam 2012.11.02 for unusing code.
//    height: parent.height
//    width:  parent.width
// } removed by junam

    property int currentCategoryIndexUSB: 0; // modified by lssanh 2013.01.26 for 68936
    property int currentCategoryIndexJukeBox: 0; // modified by lssanh 2013.01.26 for 68936

    property ListModel categoryModel: categoryModelList
    property variant itemViewListModel: AudioListViewModel

    //property int iconSize :  -1;//removed by junam 2012.11.02 for unusing code.
    property int historyStack: 0;

    property string currentCategory;
    property string currentModeAreaText;

    signal editMode( string commandID , int mode);

    function backHandler()
    {
        /* Add additional functionality to handle back hsitory. */
        /* If no any history info return false */
        //{modified by aettie 2013.04.10 for QA 41
        //{modified by aettie 2013.04.05 for QA 41
        if (currentCategory =="Folder"&&AudioListViewModel.folderHistoryStack>-1){
               if (AudioListViewModel.folderHistoryStack == 1){
                    historyStack = -- AudioListViewModel.folderHistoryStack;
                    AudioListViewModel.requestListData(currentCategory, -1, AudioListViewModel.folderHistoryStack, false, true);
                     return true;
               }
                else if (AudioListViewModel.folderHistoryStack > 1)
                {
                    historyStack = -- AudioListViewModel.folderHistoryStack;
                    AudioListViewModel.requestListData(currentCategory, -1, AudioListViewModel.folderHistoryStack);
                    return true;
                }
                return false;
        }
        if (historyStack == 1){
             AudioListViewModel.requestListData(currentCategory, -1, --historyStack, false, true);
             return true;

         }
        else if (historyStack > 1)
        {
            // { changed by junam 2012.11.29 for CR16170
            //AudioListViewModel.requestListData("", -1, --historyStack);
            AudioListViewModel.requestListData(currentCategory, -1, --historyStack);
        //}modified by aettie 2013.04.05 for QA 41
        //}modified by aettie 2013.04.10 for QA 41
            // } changed by junam
            return true;
        }
        return false;
    }

    function editHandler(mode)
    {
        editMode("switchCheckBoxes", mode);
        return;
    }
        //{modified by aettie 2013.04.05 for QA 41
    function categoryTabHandler(index, isCopyMode, callFromCategory)
    {
        // { changed by junam 2012.08.08 for ITS_KOR_183029
        EngineListenerMain.qmlLog ("categoryTab was pressed currentCategory = "+ currentCategory+"=>"+categoryModel.get(index).cat_id);
        //if( currentCategory == categoryModel.get(index).cat_id)
        if( currentCategory == categoryModel.get(index).cat_id && categoryModel.get(index).cat_id != "Folder")
        { //}changed by junam
            //historyStack = AudioListViewModel.requestUpdateListData();
            historyStack = AudioListViewModel.requestUpdateListData(callFromCategory);
        }
        else
        {
            currentCategory = categoryModel.get(index).cat_id;

            AudioListViewModel.folderHistoryStack = 0;  // history initialize, added by sungha.choi 2013.08.23 for ITS 0185510
            historyStack = AudioListViewModel.folderHistoryStack; // modified by sungha.choi 2013.08.23 for ITS 0185510

            //AudioListViewModel.requestListData(currentCategory, 0, 0);
            //AudioListViewModel.requestListData(currentCategory, 0, historyStack);
            AudioListViewModel.requestListData(currentCategory, 0, historyStack, false, callFromCategory);
        //}modified by aettie 2013.04.05 for QA 41

            //{ added by sam 2013.10.01
            __LOG("category tab is clicked.. Save Audio data. currentTab: "+currentCategory)
            AudioController.saveCategoryTab(currentCategory);
                        //} added by sam 2013.10.01
        }

        EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_ADD_TO_PLAYLIST,
                                                  (currentCategory == "Play_list") ? false : true);
        // { added by kihyung 2012.07.25 for CR 9546
        EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_MOVE,
                                                  (currentCategory == "Play_list") ? false : true);
        EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_COPY_TO_JUKEBOX,
                                                  (currentCategory == "Play_list") ? false : true);
        EngineListener.optionMenuModel.itemEnabled(MP.OPTION_MENU_DELETE,
                                                  (currentCategory == "Play_list") ? false : true);
        // } added by kihyung
    }

    function itemElementHandler(index, isCheckBoxEnabled)
    {
        if (isCheckBoxEnabled)
        {
            AudioListViewModel.toggleItemCheckbox(index);
        }
        else
        {
            //{added by junam 2013.08.29 for ITS_KOR_185043
            if( !AudioListViewModel.IsFileSupported(index) )
            {
                popup_loader.showPopup(LVEnums.POPUP_TYPE_PLAY_UNAVAILABLE_FILE);
                return;
            }
            //}added by junam

//{modified by aettie 2013.04.10 for QA 41
            // { changed by junam 2012.11.29 for CR16170
            //AudioListViewModel.requestListData("", index, ++historyStack, true);
                if (currentCategory =="Folder"&&AudioListViewModel.folderHistoryStack>-1){

                    //AudioListViewModel.folderHistoryStack++;
                    historyStack = ++AudioListViewModel.folderHistoryStack;
                    AudioListViewModel.requestListData(currentCategory, index, AudioListViewModel.folderHistoryStack, true);

                }else
                {
                    AudioListViewModel.requestListData(currentCategory, index, ++historyStack, true);
                }
            // } changed by junam
//}modified by aettie 2013.04.10 for QA 41
        }
    }

    // { Add by Naeo 2012.07.09 for CR 10970
    function itemElementHandlerCD(index, isCheckBoxEnabled)
    {
        // { modified by cychoi 2014.03.07 for ITS 228996 CDDA list flickering on item selection
        AudioListViewModel.onItemClick( index );
        //itemViewListModel = TreeModel;
        //TreeModel.onItemClickCD( index );
        // } modified by cychoi 2014.03.07
    }

    function itemElementHandlerCDback()
    {
        //itemViewListModel = AudioListViewModel; // commented by cychoi 2014.03.07 for ITS 228996 CDDA list flickering on item selection
    }
    // } Add by Naeo 2012.07.09 for CR 10970

//{modified by aettie 2013.01.16 for ISV 68135/68124
    ListModel
    {
        id: categoryModelList

        ListElement
        {
                categoryName: QT_TR_NOOP("STR_MEDIA_SONG") // modified by wonseok.heo for new UX 2013.11.11
                categoryImage_s: ""
                categoryImage_n: ""
                categoryImage_f: "" // modified by wonseok.heo for ISV 94815 2013.11.19
                categoryImage_fp: "" // modified by wonseok.heo for ISV 94815 2013.11.19

                //{remove by junam 2013.07.12 for music app
                //categoryIcon_n:   "/app/share/images/music/ico_usb_folder_n.png"
                //categoryIcon_s:   "/app/share/images/music/ico_usb_folder_s.png"
                //categoryIcon_f:   "/app/share/images/music/ico_usb_folder_f.png"
                //categoryIcon_fp:   "/app/share/images/music/ico_usb_folder_p.png"
                //}removed by junam
                itemHeight: ""
                isSelectable : true //added by junam 2013.07.12 for music app
                cat_id: "Folder"


            }

            ListElement
            {
                categoryName: ""//QT_TR_NOOP("STR_MEDIA_SONG")
                categoryImage_s: ""
                categoryImage_n: ""
                categoryImage_f: ""//app/share/images/music/ipod_tab_02_f.png"
                categoryImage_fp: ""//app/share/images/music/ipod_tab_02_p.png"

                //{remove by junam 2013.07.12 for music app
                //categoryIcon_n:   "/app/share/images/music/ico_usb_song_n.png"
                //categoryIcon_s:   "/app/share/images/music/ico_usb_song_s.png"
                //categoryIcon_f:   "/app/share/images/music/ico_usb_song_f.png"
                //categoryIcon_fp:   "/app/share/images/music/ico_usb_song_p.png"
                //}removed by junam

                itemHeight: ""
                isSelectable : true //added by junam 2013.07.12 for music app
                cat_id: "Songa"


            }

            ListElement
            {
                categoryName: ""//QT_TR_NOOP("STR_MEDIA_ALBUM")
                categoryImage_s: ""
                categoryImage_n: ""
                categoryImage_f: ""//app/share/images/music/ipod_tab_03_f.png"
                categoryImage_fp: ""//app/share/images/music/ipod_tab_03_p.png"

                //{remove by junam 2013.07.12 for music app
                //categoryIcon_n:   "/app/share/images/music/ico_usb_album_n.png"
                //categoryIcon_s:   "/app/share/images/music/ico_usb_album_s.png"
                //categoryIcon_f:   "/app/share/images/music/ico_usb_album_f.png"
                //categoryIcon_fp:   "/app/share/images/music/ico_usb_album_p.png"
                //}removed by junam
                itemHeight: ""
                isSelectable : true //added by junam 2013.07.12 for music app
                cat_id: "Albuma"

            }

            ListElement
            {
                categoryName: ""//QT_TR_NOOP("STR_MEDIA_ARTIST")
                categoryImage_s: ""
                categoryImage_n: ""
                categoryImage_f: ""//app/share/images/music/ipod_tab_04_f.png"
                categoryImage_fp: ""//app/share/images/music/ipod_tab_04_p.png"

                //{remove by junam 2013.07.12 for music app
                //categoryIcon_n:   "/app/share/images/music/ico_usb_artist_n.png"
                //categoryIcon_s:   "/app/share/images/music/ico_usb_artist_s.png"
                //categoryIcon_f:   "/app/share/images/music/ico_usb_artist_f.png"
                //categoryIcon_fp:  "/app/share/images/music/ico_usb_artist_p.png"
                //}removed by junam
                itemHeight: ""
                isSelectable : true //added by junam 2013.07.12 for music app
                cat_id: "Artista"

            }

            ListElement
            {
                categoryName: ""//QT_TR_NOOP("STR_MEDIA_GENRE")
                categoryImage_s: ""
                categoryImage_n: ""
                categoryImage_f: ""//app/share/images/music/ipod_tab_05_f.png"
                categoryImage_fp: ""//app/share/images/music/ipod_tab_05_p.png"

                //{remove by junam 2013.07.12 for music app
                //categoryIcon_n:   "/app/share/images/music/ico_usb_genre_n.png"
                //categoryIcon_s:   "/app/share/images/music/ico_usb_genre_s.png"
                //categoryIcon_f:   "/app/share/images/music/ico_usb_genre_f.png"
                //categoryIcon_fp:   "/app/share/images/music/ico_usb_genre_p.png"
                //}removed by junam
                itemHeight: ""
                isSelectable : true //added by junam 2013.07.12 for music app
                cat_id: "Genrea"
            }
        }

  }
