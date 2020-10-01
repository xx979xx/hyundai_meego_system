import QtQuick 1.0
import AppEngineQMLConstants 1.0
import ListViewEnums 1.0
import "DHAVN_AppMusicPlayer_General.js" as MPC
import "DHAVN_AppMusicPlayer_Resources.js" as RES

/* Disc Tab view */

Item
{
    property int currentCategoryIndex: 4;
    property ListModel categoryModel: categoryModelList
    property variant   itemViewListModel: TreeModel  // modified by yongkyun.lee 2013-07-12 for : NEW UX: Folder Header
    //property int  iconSize;//removed by junam 2012.11.02 for unusing code.
    signal editMode( string commandID );
    property bool justBackCalled: false; //Added by Alexey Edelev 2012.09.19. CR13888

    property int historyStack: 0;
    property string currentModeAreaText;
    property bool isInitialized : false;//added by junam 2012.12.03 for CR16296


    function __LOG(textLog)
    {
        EngineListenerMain.qmlLog("[MP] DHAVN_DiscItem.qml: " + textLog)
    }

    function backHandler()
    {
        /* Add additional functionality to nahdle back hsitory. */
        /* If no any history info return false */
        if (itemViewListModel == TreeModel)
        {
            //{ added by yongkyun.lee 20130520 for : MP3CD Current item List
            // if (TreeModel.openParent() && historyStack > 0)
            // {
            //     //{Added by Alexey Edelev 2012.09.19. CR13888
            //     historyStack--;
            //     justBackCalled = true;
            //     //}Added by Alexey Edelev 2012.09.19. CR13888
            //     return true;
            // }
            if (!TreeModel.isCurrItemRoot())
            {
                 //{ modified by yongkyun.lee 2013-09-10 for : ITS 189280
                justBackCalled = true;
                 return TreeModel.openParent();
                 //} modified by yongkyun.lee 2013-09-10 
            }
            //} added by yongkyun.lee 20130520 
        }
        return false;
    }

    function editHandler()
    {
        return;
    }

    function categoryTabHandler (index)
    {
        var categoryTabID = categoryModel.get(index).cat_id;
        __LOG("categoryTab was pressed categoryTabID = " + categoryTabID); // modified by eugeny.novikov 2012.10.18 for CR 14542
        //iconSize = -1;//removed by junam 2012.11.02 for unusing code.

        switch (categoryTabID)
        {
            case ("Folder"):
            {
                //{ added by yongkyun.lee 20130520 for : MP3CD Current item List
                // // { added by junam 2012.12.03 for CR16296
                // if(!isInitialized)
                // {
                //     isInitialized = true;
                //     TreeModel.reset();
                // }
                // // } added by junam
                // 
                // // { removed by eugeny.novikov 2012.10.18 for CR 14542
                // //                AudioListViewModel.requestListData(categoryTabID, 0, 0); // added by yongkyun.lee@lge.com  2012.09.07 for:(New UX: Music(LGE) # 40 : Total count
                // // } removed by eugeny.novikov
                // itemViewListModel = TreeModel;
                // // { modified by dongjin 2012.08.29 for New UX
                // //iconSize = 52;
                // //iconSize = 78;//removed by junam 2012.11.02 for unusing code.
                // // } modified by dongjin
                    TreeModel.reset();
                itemViewListModel = TreeModel;
                //} added by yongkyun.lee 20130520 
                break;
            }
            default:
            {
                itemViewListModel = itemViewModel;
                break;
            }
        }
    }

    function itemElementHandler (index)
    {
        //{Added by Alexey Edelev 2012.09.19. CR13888
        // { deleted by wspark 2013.03.19 for ISV 74936
        /*
        if(justBackCalled && historyStack > 0) { // modified by dongjin 2012.11.30
            justBackCalled = false;
            return;
        }
        */
        // } deleted by wspark
        //}Added by Alexey Edelev 2012.09.19. CR13888
        if (itemViewListModel == TreeModel)
        {
            historyStack++;
            TreeModel.onItemClick( index );
        }
    }

    function changeSelection_onJogDial( arrow, status )
    {
        // __LOG ("changeSelection_onJogDial arrow = " +arrow);
        if (mediaPlayer.focus_index == LVEnums.FOCUS_NONE)
        {
            mediaPlayer.focus_index = LVEnums.FOCUS_CONTENT;
        }
//{commented by Alexey Edelev 2012.09.19. CR13888
//        if ( arrow == UIListenerEnum.JOG_UP )
//        {
//            coverCarousel.lostFocus ( arrow );
//        }
//        else
//        {
//            coverCarousel.lostFocus ( UIListenerEnum.JOG_DOWN );
//        }
//{commented by Alexey Edelev 2012.09.19. CR13888
    }

    ListModel
    {
        id: categoryModelList

        //{ modified by wonseok.heo NOCR for new UX 2013.11.09
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
        // } modified by wonseok.heo NOCR for new UX 2013.11.09

    }


    ListModel
    {
        id: itemViewModel
        signal closeList();
    }

    Connections
    {
        target: visible ? mediaPlayer:null

        onChangeHighlight:
        {
            changeSelection_onJogDial( arrow, status )
        }
    }
}
