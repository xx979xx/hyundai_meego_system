import QtQuick 1.0
import AudioControllerEnums 1.0 //added by junam 2013.07.12 for music app

import "DHAVN_AppMusicPlayer_General.js" as MPC
import "DHAVN_AppMusicPlayer_Resources.js" as RES

/* iPod Tab view */

Item
{
    //{changed by junam 2013.07.12 for music app
    //property int currentCategoryIndex: 3;
    property int currentCategoryIndex: -1;
    //}chagned by junam

    signal editMode( string commandID );
    //signal findHiddenFocus(); //removed by junam 2013.10.30

    property ListModel cmdButtonModel: cmdBtnListModel
    property ListModel categoryModel: categoryModelList
    property ListModel categoryEtc: etcList
    property variant itemViewListModel: AudioListViewModel
    //property int iconSize : -1;//removed by junam 2012.11.02 for unusing code.
    property int historyStack: 0;
    property string currentCategory;
    property bool isEditActive: false;
    property string currentModeAreaText;
    property bool isEtcList: false
    property int currentEtcIndex: 0 //added by junam 2013.06.09 for etc focus

    // { added by junam 2012.11.29 for CR16170
    function isEtcCategory(categoryID)
    {
        var index;
        for(index = 0; index < etcList.count ; index++)
        {
            if(etcList.get(index).cat_id == categoryID)
                return true;
        }
        return false;
    }
    // } added by junam

    //{added by junam 2013.05.19 for album entry
    function setCurrentCategory(categoryID)
    {
//{ removed 2013.10.30
//        var index;
//        for(index = 0; index < categoryModelList.count ; index++)
//        {
//            if(categoryModelList.get(index).cat_id == categoryID)
//                return index;
//        }
//} removed 2013.10.30

        //{ added 2013.10.30
        var idx;
        var categoryList = AudioController.categoryList;

        for ( idx = 0; idx < categoryList.length; idx++)
        {
            if(categoryList[idx] >= categoryTableModel.count)
            {
                EngineListenerMain.qmlLog("ERROR Invalid index boundary");
                break;
            }
            if (categoryTableModel.get(categoryList[idx]).cat_id == categoryID)
            {
                EngineListenerMain.qmlLog("setCurrentCategory : " + idx + " " + categoryID);
                return idx;
            }
        }
        //} added 2013.10.30

        return 4;   //ETC
    }
    //}added by junam

    function backHandler()
    {
        /* Add additional functionality to nahdle back hsitory. */
        /* If no any history info return false */
        if (historyStack > 0)
        {
            if(AudioListViewModel.getCurrentRequestCount()<= 0)
            {
                AudioListViewModel.requestListData(currentCategory, -1, --historyStack);
            }
            return true;
        }//{added by junam 2013.03.25 for ISV76018
        else if ( currentCategory != "Etc" && isEtcCategory(currentCategory))
        {
            AudioListViewModel.resetPartialFetchData();    // added for ITS 195287
            //itemViewListModel.updateTextItemView("");//moved by junam 2013.07.03 for ITS177762
            currentCategory = "Etc";
            itemViewListModel = etcList;
            isEtcList = true;
            //AudioListViewModel.currentPlayingItem = -1;    // removed for ITS 195287
            historyStack = 0;
            etcList.signalUpdateCountInfo(); //added by junam 2013.06.03 for etc count
            etcList.updateTextItemView("", 0); //changed by junam 2013.09.06 for ITS_KOR_188332
            etcList.signalQuickScrollInfo(false);//added by junam 2013.06.10 for ITS_179109
            return true;
        }
        //}added by junam

        return false;
    }

    function editHandler()
    {
        editMode("iPODEdit");
        return;
    }

    function categoryTabHandler (index)
    {
        EngineListenerMain.qmlLog ("categoryTab was pressed currentCategory = " + currentCategory);
        isEditActive = false;

        if(categoryModel.get(index).cat_id == "Etc")
        {
            if(isEtcCategory(currentCategory))
            {
                historyStack = AudioListViewModel.requestUpdateListData();
            }
            else
            {
                currentCategory = categoryModel.get(index).cat_id;
                itemViewListModel = etcList;
                isEtcList = true;
                AudioListViewModel.currentPlayingItem = -1; // added by junam 2012.09.03  CR13014
                historyStack = 0; // Added by Radhakrushna CR 13443 20120921
                etcList.signalQuickScrollInfo(false);//added by junam 2013.06.10 for ITS_179109
            }
        }
        else if( currentCategory == categoryModel.get(index).cat_id)
        {
            historyStack = AudioListViewModel.requestUpdateListData();
        }
        else
        {
            currentCategory = categoryModel.get(index).cat_id;
            historyStack = 0;
            isEtcList = false;   // added by dongjin 2012.09.13 for CR13257
            itemViewListModel = AudioListViewModel; //moved by junam 2012.11.21 for CR15719
            AudioListViewModel.requestListData(currentCategory, 0, 0);
        }
        // added 2013.10.30
        //__LOG("category tab is clicked.. Save Audio data. currentTab: "+currentCategory)
        //AudioController.saveCategoryTab(currentCategory);//removed by junam 2013.11.14 for ITS_EU_208749

    }

    function itemElementHandler (index)
    {
        //{added by junam 2013.08.29 for bt call disable selection
        if(EngineListenerMain.getisBTCall())
        {
            EngineListenerMain.qmlLog("BT call mode disable list selection");
            return;
        }
        //}added by junam

        if (currentCategory != "Etc")
        {
            EngineListenerMain.qmlLog ("itemElementHandler historyDeep = " + historyStack);
	    // { changed by junam 2012.11.29 for CR16170
            //AudioListViewModel.requestListData("", index, ++historyStack);
            // { modified by sangmin.seol 2014.02.17 for ITS_0225498 prevent abnormal increase of historyStack
            if(AudioListViewModel.getCurrentRequestCount() <= 0 )
                ++historyStack;

            AudioListViewModel.requestListData(currentCategory, index, historyStack, true);
            // } modified by sangmin.seol 2014.02.17 for ITS_0225498 prevent abnormal increase of historyStack
	    // } changed by junam
        }
        else
        {
            if (!isEditActive)
            {
                historyStack = 0;
                currentCategory = etcList.get(index).cat_id;

                isEtcList = false;   // added by dongjin 2012.09.13 for CR13257
                itemViewListModel = AudioListViewModel;// added by junam 2013.03.21 for scroll to current play
                AudioListViewModel.requestListData(currentCategory, 0, 0);
                //itemViewListModel = AudioListViewModel; // removed by junam 2013.03.21 for scroll to current play
                //isEtcList = false;   // removed by dongjin 2012.09.13 for CR13257
                isEditActive = false;
                currentEtcIndex = index; //added by junam 2013.06.09 for etc focus
            }
        }
        //findHiddenFocus();  //removed by junam 2013.10.30
    }

    //{added by junam 2013.07.12 for music app
    function loadCategoryModel()
    {
        var idx
        var categoryList = AudioController.categoryList;
        EngineListenerMain.qmlLog("loadCategoryModel : "+categoryList);

        for ( idx = 0; idx < categoryList.length; idx++)
        {
            if(categoryList[idx] >= categoryTableModel.count)
            {
                EngineListenerMain.qmlLog("ERROR In valid index boundary");
                break;
            }

            if (idx < 4)
            {
                categoryModelList.set( idx,
                                      {"categoryName": categoryTableModel.get(categoryList[idx]).name,
                                      "cat_id":categoryTableModel.get(categoryList[idx]).cat_id,
                                      "isSelectable": !AudioController.isControllerDisable(categoryTableModel.get(categoryList[idx]).ctrl_disable, false)});  // modified ITS 233219
            }
            else
            {
                etcList.set( idx - 4,
                            {"itemViewTitle": categoryTableModel.get(categoryList[idx]).name,
                            "cat_id": categoryTableModel.get(categoryList[idx]).cat_id,
                            "isSelectable": !AudioController.isControllerDisable(categoryTableModel.get(categoryList[idx]).ctrl_disable, false)});  // modified ITS 233219
            }
        }
        for(idx = 0; idx < etcList.count ; idx++)
        {
            if(etcList.get(idx).isSelectable)
                break;
        }
        categoryModelList.set( 4, {"isSelectable": idx != etcList.count});  //ETC

        if(currentCategoryIndex < 0)
        {
            currentCategoryIndex = setCurrentCategory("Song");
        }

        //Find selectable category... // modified 2013.11.01
        if (categoryModelList.count <= currentCategoryIndex)
        {
            currentCategoryIndex = categoryModelList.count - 1;
        }
        else
        {
            for(idx = 0; idx < categoryModelList.count ; idx++)
            {
                if(categoryModelList.get( (idx+currentCategoryIndex) % categoryModelList.count).isSelectable)
                {
                    currentCategoryIndex = (idx+currentCategoryIndex) % categoryModelList.count;
                    break;
                }
            }
        }
    }

    function loadCategoryEditModel(model)
    {
        var categoryList = AudioController.categoryList;
        EngineListenerMain.qmlLog("loadCategoryEditModel :  "+categoryList);
        model.clear();
        for (var idx = 0; idx < categoryList.length; idx++)
        {
            if(categoryList[idx] >= categoryTableModel.count)
            {
                EngineListenerMain.qmlLog("ERROR: In valid index boundary");
                break;
            }
            model.append( categoryTableModel.get(categoryList[idx]));
            model.setProperty( idx,"cat_type", (idx < 4) ? "Category" : "More")
        }
    }

    function saveCategoryEditModel(model)
    {
        var categoryList = new Array(model.count);        
        for (var idx = 0; idx < model.count; idx++)
        {
            categoryList[idx] = model.get(idx).cat_index;
            //{added by junam 2013.08.12 disabled item category edit
            if( idx < categoryList.length && categoryList[idx] < categoryTableModel.count)
            {
                if (idx < 4)
                    categoryModelList.set( idx, {"isSelectable": !AudioController.isControllerDisable(categoryTableModel.get(categoryList[idx]).ctrl_disable, false)});
                else if(idx < etcList.count + 4)
                    etcList.set( idx - 4, {"isSelectable": !AudioController.isControllerDisable(categoryTableModel.get(categoryList[idx]).ctrl_disable, false)});
            }
            //}added by junam
        }
        AudioController.categoryList = categoryList;
        AudioController.SaveAudioData();        
    }
    //}added by junam

    /* List model for iPod cmdBottomArea Widget*/
    ListModel
    {
        id: cmdBtnListModel

        property Component  btn_text_style: Component
        {
            Text
            {
                color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BUTTON_GREY
                /* According to SPEC it should be const_FONT_SIZE_TEXT_TIME_FONT but it's very big*/
                /* font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_TIME_FONT */
                font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_24_FONT
            }
        }

        ListElement
        {
            name: ""
            btn_width: 178
            icon_n: "/app/share/images/music/btn_prev.png"
            icon_p: "/app/share/images/music/btn_prev.png"
            bg_image_p: ""
            isHoldButton: true
            btn_id: "prev"

        }
        ListElement
        {
            name: ""
            btn_width: 178
            icon_n: "/app/share/images/music/btn_play.png"
            icon_p: "/app/share/images/music/btn_play.png"
            bg_image_p: ""
            btn_id: "play"

        }
        ListElement
        {
            name: ""
            btn_width: 178
            icon_n: "/app/share/images/music/btn_next.png"
            icon_p: "/app/share/images/music/btn_next.png"
            bg_image_p: ""
            btn_id: "next"
        }
        ListElement
        {
            name: ""
            btn_width: 178
            icon_n: "/app/share/images/music/btn_repeat.png"
            icon_p: "/app/share/images/music/btn_repeat.png"
            bg_image_p: ""
            isHoldButton: true
            btn_id: "repeat"
        }
        ListElement
        {
            name: ""
            btn_width: 178
            icon_n: "/app/share/images/music/btn_random.png"
            icon_p: "/app/share/images/music/btn_random.png"
            bg_image_p: ""
            btn_id: "random"
        }
        ListElement
        {
            name: QT_TR_NOOP("STR_MEDIA_SCAN")
            btn_width: 178
            icon_n: ""
            icon_p: ""
            bg_image_p: ""
            btn_id: "Scan"
        }
        ListElement
        {
            name: QT_TR_NOOP("STR_MEDIA_LIST")
            btn_width: 176
            icon_n: ""
            icon_p: ""
            bg_image_p: ""
            btn_id: "List"
        }
    }

    ListModel
    {
        id: categoryModelList

        ListElement
        {
            categoryName: QT_TR_NOOP("STR_MEDIA_PLAYLIST")
            //{removed by junam 2013.07.12 for music app
            //categoryIcon_s: "/app/share/images/music/ico_usb_list_s.png"
            //categoryIcon_n: "/app/share/images/music/ico_usb_list_n.png"
            //categoryIcon_f:   "/app/share/images/music/ico_usb_list_f.png"
            //categoryIcon_fp:  "/app/share/images/music/ico_usb_list_p.png"
            //}removed by junam

            categoryImage_s: "/app/share/images/music/ipod_tab_01_s.png"
            categoryImage_n: "/app/share/images/music/ipod_tab_01_n.png"
            categoryImage_f: "/app/share/images/music/ipod_tab_01_f.png"
            categoryImage_fp: "/app/share/images/music/ipod_tab_01_p.png"
            itemHeight: ""
            isSelectable : true
            cat_id: "Play_list"
        }

        ListElement
        {
            categoryName: QT_TR_NOOP("STR_MEDIA_ARTIST")
            //{removed by junam 2013.07.12 for music app
            //categoryIcon_s: "/app/share/images/music/ico_usb_artist_s.png"
            //categoryIcon_n: "/app/share/images/music/ico_usb_artist_n.png"
            //categoryIcon_f:   "/app/share/images/music/ico_usb_artist_f.png"
            //categoryIcon_fp:  "/app/share/images/music/ico_usb_artist_p.png"
            //}removed by junam
            categoryImage_s: "/app/share/images/music/ipod_tab_02_s.png"
            categoryImage_n: "/app/share/images/music/ipod_tab_02_n.png"
            categoryImage_f: "/app/share/images/music/ipod_tab_02_f.png"
            categoryImage_fp: "/app/share/images/music/ipod_tab_02_p.png"
            itemHeight: ""
            isSelectable : true //added by junam 2013.07.12 for music app
            cat_id: "Artist"
        }

        ListElement
        {
            categoryName: QT_TR_NOOP("STR_MEDIA_ALBUM")
            //{removed by junam 2013.07.12 for music app
            //categoryIcon_s: "/app/share/images/music/ico_usb_album_s.png"
            //categoryIcon_n: "/app/share/images/music/ico_usb_album_n.png"
            //categoryIcon_f:   "/app/share/images/music/ico_usb_album_f.png"
            //categoryIcon_fp:  "/app/share/images/music/ico_usb_album_p.png"
            //}removed by junam
            categoryImage_s: "/app/share/images/music/ipod_tab_03_s.png"
            categoryImage_n: "/app/share/images/music/ipod_tab_03_n.png"
            categoryImage_f: "/app/share/images/music/ipod_tab_03_f.png"
            categoryImage_fp: "/app/share/images/music/ipod_tab_03_p.png"
            itemHeight: ""
            isSelectable : true //added by junam 2013.07.12 for music app
            cat_id: "Album"
        }

        ListElement
        {
            categoryName: QT_TR_NOOP("STR_MEDIA_SONG")
            //{removed by junam 2013.07.12 for music app
            //categoryIcon_s: "/app/share/images/music/ico_usb_song_s.png"
            //categoryIcon_n: "/app/share/images/music/ico_usb_song_n.png"
            //categoryIcon_f:   "/app/share/images/music/ico_usb_song_f.png"
            //categoryIcon_fp:  "/app/share/images/music/ico_usb_song_p.png"
            //}removed by junam
            categoryImage_s: "/app/share/images/music/ipod_tab_04_s.png"
            categoryImage_n: "/app/share/images/music/ipod_tab_04_n.png"
            categoryImage_f: "/app/share/images/music/ipod_tab_04_f.png"
            categoryImage_fp: "/app/share/images/music/ipod_tab_04_p.png"
            itemHeight: ""
            isSelectable : true //added by junam 2013.07.12 for music app
            cat_id: "Song"
        }
        //}changed by junam

        ListElement
        {
            categoryName: QT_TR_NOOP("STR_MEDIA_MORE")
            //{removed by junam 2013.07.12 for music app
            //categoryIcon_s: "/app/share/images/music/ico_etc_s.png"
            //categoryIcon_n: "/app/share/images/music/ico_etc_n.png"
            //categoryIcon_f:   "/app/share/images/music/ico_etc_f.png"
            //categoryIcon_fp:  "/app/share/images/music/ico_etc_p.png"
            //}removed by junam
            categoryImage_s: "/app/share/images/music/ipod_tab_05_s.png"
            categoryImage_n: "/app/share/images/music/ipod_tab_05_n.png"
            categoryImage_f: "/app/share/images/music/ipod_tab_05_f.png"
            categoryImage_fp: "/app/share/images/music/ipod_tab_05_p.png"
            itemHeight: ""
            isSelectable : true //added by junam 2013.07.12 for music app
            cat_id: "Etc"
        }
    }

    ListModel
    {
        id: etcList

        signal closeList();
        signal disableListBtn();
        signal enableListBtn ();
        signal signalUpdateCountInfo();//added by junam 2013.06.03 for etc count
        //{added by junam 2013.07.03 for ITS177762
        signal clearSelection();
        signal setCurrentPlayingItemPosition();
        //}added by junam
        signal signalQuickScrollInfo(bool quickInfo);//added by junam 2013.06.10 for ITS_179109
        signal updateTextItemView(string title, int historyStack); //changed by junam 2013.09.06 for ITS_KOR_188332

        property int currentPlayingItem : -1;//added by junam 2013.03.25 for ISV76018
        function isQuickViewVisible(){ return false; }// added by junam 2013.06.10 for ITS_179109


        ListElement
        {
            itemViewTitle: QT_TR_NOOP("STR_MEDIA_ITUNES_U")
            itemViewImage: ""
            itemURL: ""
            selected: ""
            itemHeight: ""
            isCheckBoxMarked: false
            isSelectable: true
            isImageVisible: false// added by junam 2012.10.15 for CR14040
            cat_id: "itunes"
        }
        ListElement
        {
            itemViewTitle: QT_TR_NOOP("STR_MEDIA_PODCAST")
            itemViewImage: ""
            itemURL: ""
            selected: ""
            itemHeight: ""
            isCheckBoxMarked: false
            isSelectable: true
            isImageVisible: false// added by junam 2012.10.15 for CR14040
            cat_id: "Podcast"
        }

        ListElement
        {
            itemViewTitle: QT_TR_NOOP("STR_MEDIA_AUDIOBOOK")
            itemViewImage: ""
            itemURL: ""
            selected: ""
            itemHeight: ""
            isCheckBoxMarked: false
            isSelectable: true
            isImageVisible: false// added by junam 2012.10.15 for CR14040
            cat_id: "Audiobook"
        }

        ListElement
        {
            itemViewTitle: QT_TR_NOOP("STR_MEDIA_COMPOSER")
            itemViewImage: ""
            itemURL: ""
            selected: ""
            itemHeight: ""
            isCheckBoxMarked: false
            isSelectable: true
            isImageVisible: false// added by junam 2012.10.15 for CR14040
            cat_id: "Composer"
        }
        ListElement
        {
            itemViewTitle: QT_TR_NOOP("STR_MEDIA_GENRE")
            itemViewImage: ""
            itemURL: ""
            selected: ""
            itemHeight: ""
            isCheckBoxMarked: false
            isSelectable: true
            isImageVisible: false// added by junam 2012.10.15 for CR14040
            cat_id: "Genre"
        }
    }

    //{added by junam 2013.07.04 for ITS172937
    ListModel
    {
        id: categoryTableModel
        ListElement
        {
            cat_index: 0
            name: QT_TR_NOOP("STR_MEDIA_PLAYLIST")
            itemHeight: ""
            cat_id: "Play_list"
            cat_type:"Category"
            ctrl_disable:  MP.CTRL_DISABLE_LIST_PLAYLIST  //added by junam 2013.07.12 for music app
        }
        ListElement
        {
            cat_index: 1
            name: QT_TR_NOOP("STR_MEDIA_ARTIST")
            itemHeight: ""
            cat_id: "Artist"
            cat_type:"Category"
            ctrl_disable:  MP.CTRL_DISABLE_LIST_ARTIST //added by junam 2013.07.12 for music app
        }
        ListElement
        {
            cat_index: 2
            name: QT_TR_NOOP("STR_MEDIA_ALBUM")
            itemHeight: ""
            cat_id: "Album"
            cat_type:"Category"
            ctrl_disable:  MP.CTRL_DISABLE_LIST_ALBUM //added by junam 2013.07.12 for music app
        }
        ListElement
        {
            cat_index: 3
            name: QT_TR_NOOP("STR_MEDIA_SONG")
            itemHeight: ""
            cat_id: "Song"
            cat_type:"Category"
            ctrl_disable:  MP.CTRL_DISABLE_LIST_SONG //added by junam 2013.07.12 for music app
        }
        ListElement
        {
            cat_index: 4
            name: QT_TR_NOOP("STR_MEDIA_ITUNES_U")
            itemHeight: ""
            cat_id: "itunes"
            cat_type:"More"
            ctrl_disable:  MP.CTRL_DISABLE_LIST_ITUNES //added by junam 2013.07.12 for music app
        }        
        ListElement
        {
            cat_index: 5
            name: QT_TR_NOOP("STR_MEDIA_PODCAST")
            itemHeight: ""
            cat_id: "Podcast"
            cat_type:"More"
            ctrl_disable:  MP.CTRL_DISABLE_LIST_PODCAST //added by junam 2013.07.12 for music app
        }        
        ListElement
        {
            cat_index: 6
            name: QT_TR_NOOP("STR_MEDIA_AUDIOBOOK")
            itemHeight: ""
            cat_id: "Audiobook"
            cat_type:"More"
            ctrl_disable:  MP.CTRL_DISABLE_LIST_AUDIOBOOK //added by junam 2013.07.12 for music app
        }        
        ListElement
        {
            cat_index: 7
            name: QT_TR_NOOP("STR_MEDIA_COMPOSER")
            itemHeight: ""
            cat_id: "Composer"
            cat_type:"More"
            ctrl_disable:  MP.CTRL_DISABLE_LIST_COMPOSER //added by junam 2013.07.12 for music app
        }        
        ListElement
        {
            cat_index: 8
            name: QT_TR_NOOP("STR_MEDIA_GENRE")
            itemHeight: ""
            cat_id: "Genre"
            cat_type:"More"
            ctrl_disable:  MP.CTRL_DISABLE_LIST_GENRE //added by junam 2013.07.12 for music app
        }
    }
    //}added by junam
 }
