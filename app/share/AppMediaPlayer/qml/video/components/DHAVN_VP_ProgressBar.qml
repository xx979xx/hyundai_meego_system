// { modified by Sergey 05.05.2013
import QtQuick 1.1

import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../DHAVN_VP_RESOURCES.js" as RES

Item
{
    id: progressBar

    width: CONST.const_SCREEN_WIDTH
    anchors.bottom: parent.bottom

    property string name: "VP_ProgressBar" // added by Sergey 26.09.2013 for ITS#191542

    /**This property have value tru, when user pressed on cursor */
    property bool bPressed: false
    /** Visible property for Cursor on progressbar */
    property bool bCursorVisible: true
    /** Visible property of progress bar */
    property bool bTuneSameFile: video_model.tuneSameFile    // added by yongkyun.lee  2012.10.17  for Current file is white color
    /** change color of text to RED */
    property bool bTuneTextColor: video_model.tuneMode
    /** Minimal value is always 0 */
    /** Current time can be more then total time */
    property int nCurrentTime: video_model.position
    /** Total time, any integer value */
    property int nTotalTime: video_model.duration
    /** Repeat status: 0 - none, 1 - all, 2 - file */
    property int nRepeatStatus: video_model.repeatMode
    /** Random status: 0 - none, 1 - all */
    property int nRandomStatus: video_model.randomMode
    // { added by kihyung 2012.07.26 for CR 11894
    /** Scan status: 0 - none, 1 - all, 2 - file */
    property int nScanStatus: video_model.scanMode
    // } added by kihyung
    /** Disable mouse interaction */
    property bool bSeekable: true
    /** Change UI state of progress bar **/
    property string sState: video_model.progressBarMode
    /** Progress bar displayed on screen **/
    property bool onScreen: true
    property bool bFullScreenAnimation: true // added by Sergey 03.08.2013 for ITS#0180899

    property bool bPbcMode : video_model.pbcMode // added by wspark 2013.04.15 for ITS 162431

    /** This private property is needed for proper displaying of repeat & random icon, when user press on it.**/
    property bool __randomPressed: false;
    property bool __repeatPressed: false;

    //{ modified by yongkyun.lee 2013-08-15 for :  ISV 85716
    property bool isSeekPressed: false
    property bool is_ff_rew: false
    //} modified by yongkyun.lee 2013-08-15 

    /** For middle east variant UI should be mirrored **/
    property bool east: EngineListenerMain.middleEast
    property string strEast: ""
    // removed by Sergey 04.10.2013 for ITS#193346

    onEastChanged:
    {
        strEast = east ? "east" : ""
        state = sState + strEast
    }

    onSStateChanged:
    {
        state = sState + strEast
    }

    onOnScreenChanged:
    {
        if(sState == "AUX")
            return

        if(onScreen)
        {
            visible = true
            anchors.bottomMargin = 0
        }
        else
        {
            anchors.bottomMargin =  -CONST.const_FULL_SCREEN_OFFSET //-height//  modified by edo.lee 2013.08.10 ITS 183057
            invisiblityTimer.start() // to save CPU should "visible=false" PB when it is out of screen.
        }
    }

    onNCurrentTimeChanged:
    {
        if(!progressBar.bPressed) // modified by Sergey 15.05.2013
            animateProgressBar(nCurrentTime)
    }


    // { added by Sergey 26.09.2013 for ITS#191542
    Connections
    {
        target: EngineListener

        onFsAnimation: progressBar.bFullScreenAnimation = bOn
    }
	// } added by Sergey 26.09.2013 for ITS#191542
    
    // { modified by Sergey 03.08.2013 for ITS#0180899
    Behavior on anchors.bottomMargin
    {
        PropertyAnimation
        {
            duration: (bFullScreenAnimation) ? CONST.const_FULLSCREEN_DURATION_ANIMATION : 0

            onRunningChanged:
            {
                if(!running && bFullScreenAnimation == false)
                    bFullScreenAnimation = true;
            }
        }
    }
    // } modified by Sergey 03.08.2013 for ITS#0180899

    /*
     * There are 7 different UI layouts of Progress bar. These states support their dynamic change.
     * If position or visibility of your element depends on the states carefully add it here and don't forget to correct all states!
     */
    states: [
        State
        {
            name: "AUX"
            PropertyChanges { target: progressBar; visible: false  }
        },
        State
        {
            name: "AUXeast"
            PropertyChanges { target: progressBar; visible: false  }
        },
        State
        {
            name: "FS"
            PropertyChanges { target: progressBar; visible: true  }
            PropertyChanges { target: pb_empty_line; visible: true  }

            //Current time
            // { modified by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
            PropertyChanges { target: curTime; width: CONST.const_PB_CURR_TIME_WIDTH }
            AnchorChanges { target: curTime; anchors.left: parent.left; anchors.right: undefined; }
            PropertyChanges { target: curTime; anchors.leftMargin: CONST.const_PB_CURR_TIME_OFFSET }
            //PropertyChanges { target: curTime; width: undefined }
            //AnchorChanges { target: curTime; anchors.left: progressBar.left; anchors.right: undefined; }
            //PropertyChanges { target: curTime; anchors.leftMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            // } modified by cychoi 2014.04.02

            //Total time
            // { modified by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
            PropertyChanges { target: totalTime; width: CONST.const_PB_TOTAL_TIME_WIDTH }
            AnchorChanges { target: totalTime; anchors.right: parent.right; anchors.left: undefined; }
            PropertyChanges { target: totalTime; anchors.rightMargin: CONST.const_PB_TOTAL_TIME_OFFSET }
            //PropertyChanges { target: totalTime; width: undefined }
            //AnchorChanges { target: totalTime; anchors.right: progressBar.right; anchors.left: undefined; }
            //PropertyChanges { target: totalTime; anchors.rightMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            // } modified by cychoi 2014.04.02
            PropertyChanges { target: totalTime; visible: true }

            //File
            PropertyChanges { target: mainName; width: undefined } // modified by Sergey 04.10.2013 for ITS#193346
            AnchorChanges { target: mainName; anchors.bottom: curTime.top; anchors.left: progressBar.left; anchors.right: progressBar.right; anchors.top: undefined } // modified by cychoi 2014.04.18 for SmokeTest file name position
            PropertyChanges { target: mainName; anchors.leftMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET } // added by cychoi 2014.04.18 for SmokeTest file name position
            PropertyChanges { target: mainName; anchors.bottomMargin: -3; anchors.rightMargin: 180 } // "-3" gap between File and Current time
            PropertyChanges { target: mainName.textItem; width: parent.width }
            PropertyChanges { target: mainName; horizontalAlignment: Text.AlignLeft }
            PropertyChanges { target: mainName; text: video_model.filename } // added by Sergey 04.10.2013 for ITS#193346


            //Folder
            PropertyChanges { target: subName; width: undefined }
            AnchorChanges { target: subName; anchors.bottom: mainName.top; anchors.left: mainName.left; anchors.right: undefined; anchors.top: undefined }
            PropertyChanges { target: subName; anchors.bottomMargin: -8 } // gap between File and Folder
            PropertyChanges { target: subName; horizontalAlignment: Text.AlignLeft }
            PropertyChanges { target: subName; font.pointSize: CONST.const_FONT_SIZE_TEXT_HDR_26_FONT }
            PropertyChanges { target: subName; visible: true }

            //Random
            PropertyChanges { target: randomIcon; width: undefined }
            AnchorChanges { target: randomIcon; anchors.bottom: curTime.top; anchors.left: progressBar.left; anchors.right: undefined;/* anchors.bottom: undefined;*/ }
            PropertyChanges { target: randomIcon; anchors.leftMargin: CONST.const_PB_RANDOM_LEFT_OFFSET; anchors.bottomMargin: CONST.const_PB_REPEAT_BOTTOM_MARGIN; }
            PropertyChanges { target: randomIcon; visible: true }

            //Repeat
            PropertyChanges { target: repeatIcon; width: undefined }
            AnchorChanges { target: repeatIcon; anchors.bottom: curTime.top; anchors.left: progressBar.left; anchors.right: undefined }
            PropertyChanges { target: repeatIcon; anchors.leftMargin: CONST.const_PB_REPEAT_LEFT_OFFSET; anchors.bottomMargin: CONST.const_PB_REPEAT_BOTTOM_MARGIN; }
            PropertyChanges { target: repeatIcon; visible: true }
        },
        State
        {
            name: "FSeast"
            PropertyChanges { target: progressBar; visible: true  }
            PropertyChanges { target: pb_empty_line; visible: true  }

            //Current time
            // { modified by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
            PropertyChanges { target: curTime; width: CONST.const_PB_CURR_TIME_WIDTH }
            AnchorChanges { target: curTime; anchors.left: parent.left; anchors.right: undefined; }
            PropertyChanges { target: curTime; anchors.leftMargin: CONST.const_PB_CURR_TIME_OFFSET }
            //PropertyChanges { target: curTime; width: undefined }
            //AnchorChanges { target: curTime; anchors.left: progressBar.left; anchors.right: undefined; }
            //PropertyChanges { target: curTime; anchors.leftMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            // } modified by cychoi 2014.04.02

            //Total time
            // { modified by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
            PropertyChanges { target: totalTime; width: CONST.const_PB_TOTAL_TIME_WIDTH }
            AnchorChanges { target: totalTime; anchors.right: parent.right; anchors.left: undefined; }
            PropertyChanges { target: totalTime; anchors.rightMargin: CONST.const_PB_TOTAL_TIME_OFFSET }
            //PropertyChanges { target: totalTime; width: undefined }
            //AnchorChanges { target: totalTime; anchors.right: progressBar.right; anchors.left: undefined; }
            //PropertyChanges { target: totalTime; anchors.rightMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            // } modified by cychoi 2014.04.02
            PropertyChanges { target: totalTime; visible: true }

            //File
            PropertyChanges { target: mainName; width: undefined } // modified by Sergey 04.10.2013 for ITS#193346
            AnchorChanges { target: mainName; anchors.bottom: curTime.top; anchors.left: progressBar.left; anchors.right: progressBar.right; anchors.top: undefined; }
            PropertyChanges { target: mainName; anchors.bottomMargin: -3; anchors.leftMargin:CONST.const_PB_FILE_LEFT_OFFSET_ME; anchors.rightMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET } // "-3" gap between File and Current time
            PropertyChanges { target: mainName.textItem; width: parent.width }
            PropertyChanges { target: mainName; horizontalAlignment: Text.AlignRight }
            PropertyChanges { target: mainName; text: video_model.filename } // added by Sergey 04.10.2013 for ITS#193346

            //Folder
            PropertyChanges { target: subName; width: undefined }
            AnchorChanges { target: subName; anchors.bottom: mainName.top; anchors.left: progressBar.left; anchors.right: progressBar.right; anchors.top: undefined; }
            PropertyChanges { target: subName; anchors.bottomMargin: -8; anchors.leftMargin: CONST.const_PB_FOLDER_LEFT_OFFSET_ME; anchors.rightMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET } // "-8" gap between File and Folder
            PropertyChanges { target: subName; horizontalAlignment: Text.AlignRight }
            PropertyChanges { target: subName; font.pointSize: CONST.const_FONT_SIZE_TEXT_HDR_26_FONT }
            PropertyChanges { target: subName; font.family: CONST.const_FONT_FAMILY_NEW_HDR }
            PropertyChanges { target: subName; visible: true }

            //Random
            PropertyChanges { target: randomIcon; width: undefined }
            AnchorChanges { target: randomIcon; anchors.bottom: curTime.top; anchors.left: progressBar.left; anchors.right: undefined;/*anchors.bottom: undefined;*/}
            PropertyChanges { target: randomIcon; anchors.leftMargin: CONST.const_PB_RANDOM_LEFT_OFFSET_ME; anchors.bottomMargin: CONST.const_PB_REPEAT_BOTTOM_MARGIN; }
            PropertyChanges { target: randomIcon; visible: true }

            //Repeat
            PropertyChanges { target: repeatIcon; width: undefined }
            AnchorChanges { target: repeatIcon; anchors.bottom: curTime.top; anchors.left: progressBar.left; anchors.right: undefined;/* anchors.bottom: undefined;*/ }
            PropertyChanges { target: repeatIcon; anchors.leftMargin: CONST.const_PB_REPEAT_LEFT_OFFSET_ME; anchors.bottomMargin: CONST.const_PB_REPEAT_BOTTOM_MARGIN; }
            PropertyChanges { target: repeatIcon; visible: true }
        },
        State
        {
            name: "DVD"
            PropertyChanges { target: progressBar; visible: true  }
            PropertyChanges { target: pb_empty_line; visible: false }

            //Current time
            // { modified by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
            PropertyChanges { target: curTime; width: CONST.const_PB_TOTAL_TIME_WIDTH }
            AnchorChanges { target: curTime; anchors.left: undefined; anchors.right: parent.right; }
            PropertyChanges { target: curTime; anchors.rightMargin: CONST.const_PB_TOTAL_TIME_OFFSET }
            //PropertyChanges { target: curTime; width: undefined }
            //AnchorChanges { target: curTime; anchors.left: undefined; anchors.right: progressBar.right; }
            //PropertyChanges { target: curTime; anchors.rightMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            // } modified by cychoi 2014.04.02

            //Total time
            PropertyChanges { target: totalTime; visible: false }

            //Title
            PropertyChanges { target: mainName.textItem; width: undefined }
            PropertyChanges { target: mainName; width: mainName.textItem.width } // modified by Sergey 04.10.2013 for ITS#193346
            AnchorChanges { target: mainName; anchors.left: progressBar.left; anchors.right: undefined; anchors.bottom: progressBar.bottom; anchors.top: undefined; }
            PropertyChanges { target: mainName; anchors.leftMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET; anchors.bottomMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            PropertyChanges { target: mainName; horizontalAlignment: Text.AlignLeft }

            //Chapter
            PropertyChanges { target: subName; width: undefined }
            AnchorChanges { target: subName;  anchors.left: mainName.right; anchors.right: progressBar.right; anchors.bottom: progressBar.bottom; anchors.top: undefined;  }
            PropertyChanges { target: subName; anchors.leftMargin: CONST.const_PB_TITLE_CHAPTER_GAP; anchors.rightMargin: CONST.const_PB_CHAPTER_RIGHT_OFFSET; anchors.bottomMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            PropertyChanges { target: subName; horizontalAlignment: Text.AlignLeft }
            PropertyChanges { target: subName; font.pointSize: CONST.const_FONT_SIZE_TEXT_HDR_30_FONT }
            PropertyChanges { target: subName; font.family: CONST.const_FONT_FAMILY_NEW_HDR }//modified by aettie 20130906
            PropertyChanges { target: subName; visible: true }

            //Random
            PropertyChanges { target: randomIcon; visible: false }

            //Repeat
            PropertyChanges { target: repeatIcon; visible: false }
        },
        State
        {
            name: "DVDeast"
            PropertyChanges { target: progressBar; visible: true  }
            PropertyChanges { target: pb_empty_line; visible: false }

            //Current time
            // { modified by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
            PropertyChanges { target: curTime; width: CONST.const_PB_CURR_TIME_WIDTH }
            AnchorChanges { target: curTime; anchors.left: parent.left; anchors.right: undefined; }
            PropertyChanges { target: curTime; anchors.leftMargin: CONST.const_PB_CURR_TIME_OFFSET }
            //PropertyChanges { target: curTime; width: undefined }
            //AnchorChanges { target: curTime; anchors.left: progressBar.left; anchors.right: undefined; }
            //PropertyChanges { target: curTime; anchors.leftMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            // } modified by cychoi 2014.04.02

            //Total time
            PropertyChanges { target: totalTime; visible: false }

            //Title
            PropertyChanges { target: mainName; horizontalAlignment: Text.AlignRight }
            PropertyChanges { target: mainName.textItem; width: undefined }
            PropertyChanges { target: mainName; width: mainName.textItem.width } // modified by Sergey 04.10.2013 for ITS#193346
            AnchorChanges { target: mainName; anchors.left: undefined; anchors.right: progressBar.right; anchors.bottom: progressBar.bottom; anchors.top: undefined; }
            PropertyChanges { target: mainName; anchors.rightMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET; anchors.bottomMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }

            //Chapter
            PropertyChanges { target: subName; width: undefined }
            AnchorChanges { target: subName;  anchors.left: progressBar.left; anchors.right: mainName.left; anchors.bottom: progressBar.bottom; anchors.top: undefined;  }
            PropertyChanges { target: subName; anchors.leftMargin: CONST.const_PB_CHAPTER_LEFT_OFFSET_ME; anchors.rightMargin: CONST.const_PB_TITLE_CHAPTER_GAP; anchors.bottomMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            PropertyChanges { target: subName; horizontalAlignment: Text.AlignRight }
            PropertyChanges { target: subName; font.pointSize: CONST.const_FONT_SIZE_TEXT_HDR_30_FONT }
            PropertyChanges { target: subName; font.family: CONST.const_FONT_FAMILY_NEW_HDR }//modified by aettie 20130906
            PropertyChanges { target: subName; visible: true }

            //Random
            PropertyChanges { target: randomIcon; visible: false }

            //Repeat
            PropertyChanges { target: repeatIcon; visible: false }
        },
        State
        {
            name: "VCD"
            PropertyChanges { target: progressBar; visible: true  }
            PropertyChanges { target: pb_empty_line; visible: false }

            //Current time
            // { modified by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
            PropertyChanges { target: curTime; width: CONST.const_PB_TOTAL_TIME_WIDTH }
            AnchorChanges { target: curTime; anchors.left: undefined; anchors.right: parent.right; }
            PropertyChanges { target: curTime; anchors.rightMargin: CONST.const_PB_TOTAL_TIME_OFFSET }
            //PropertyChanges { target: curTime; width: undefined }
            //AnchorChanges { target: curTime; anchors.left: undefined; anchors.right: progressBar.right; }
            //PropertyChanges { target: curTime; anchors.rightMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            // } modified by cychoi 2014.04.02

            //Total time
            PropertyChanges { target: totalTime; visible: false }

            //Track
            PropertyChanges { target: mainName; width: undefined } // modified by Sergey 04.10.2013 for ITS#193346
            AnchorChanges { target: mainName; anchors.left: progressBar.left; anchors.right: progressBar.right; anchors.bottom: progressBar.bottom; anchors.top: undefined; }
            PropertyChanges { target: mainName; anchors.leftMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET; anchors.rightMargin: CONST.const_PB_VCD_TRACK_RIGHT_OFFSET; anchors.bottomMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            PropertyChanges { target: mainName.textItem; width: parent.width }
            PropertyChanges { target: mainName; horizontalAlignment: Text.AlignLeft }

            //Chapter/Folder
            PropertyChanges { target: subName; visible: false }

            //Random
            PropertyChanges { target: randomIcon; visible: false }

            //Repeat
            PropertyChanges { target: repeatIcon; width: undefined }
            AnchorChanges { target: repeatIcon; anchors.left: mainName.right; anchors.right: undefined; anchors.bottom: progressBar.bottom; anchors.top: undefined; }
            PropertyChanges { target: repeatIcon; anchors.leftMargin: CONST.const_PB_VCD_TRACK_REPEAT_GAP; anchors.bottomMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            PropertyChanges { target: repeatIcon; visible: true }
        },
        State
        {
            name: "VCDeast"
            PropertyChanges { target: progressBar; visible: true  }
            PropertyChanges { target: pb_empty_line; visible: false }

            //Current time
            // { modified by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
            PropertyChanges { target: curTime; width: CONST.const_PB_CURR_TIME_WIDTH }
            AnchorChanges { target: curTime; anchors.left: parent.left; anchors.right: undefined; }
            PropertyChanges { target: curTime; anchors.leftMargin: CONST.const_PB_CURR_TIME_OFFSET }
            //PropertyChanges { target: curTime; width: undefined }
            //AnchorChanges { target: curTime; anchors.left: progressBar.left; anchors.right: undefined; }
            //PropertyChanges { target: curTime; anchors.leftMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            // } modified by cychoi 2014.04.02

            //Total time
            PropertyChanges { target: totalTime; visible: false }

            //Track
            PropertyChanges { target: mainName; width: undefined } // modified by Sergey 04.10.2013 for ITS#193346
            AnchorChanges { target: mainName; anchors.left: progressBar.left; anchors.right: progressBar.right; anchors.bottom: progressBar.bottom; anchors.top: undefined; }
            PropertyChanges { target: mainName; anchors.leftMargin: CONST.const_PB_VCD_TRACK_LEFT_OFFSET_ME; anchors.rightMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET; anchors.bottomMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            PropertyChanges { target: mainName.textItem; width: parent.width }
            PropertyChanges { target: mainName; horizontalAlignment: Text.AlignRight }

            //Chapter/Folder
            PropertyChanges { target: subName; visible: false }

            //Random
            PropertyChanges { target: randomIcon; visible: false }

            //Repeat
            PropertyChanges { target: repeatIcon; width: undefined }
            AnchorChanges { target: repeatIcon; anchors.left: curTime.right; anchors.right: undefined; anchors.bottom: progressBar.bottom; anchors.top: undefined; }
            PropertyChanges { target: repeatIcon; anchors.leftMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET; anchors.bottomMargin: CONST.const_PB_DEFAULT_PARENT_OFFSET }
            PropertyChanges { target: repeatIcon; visible: true }
        }
    ]






    // ==================================== Functions ========================================================

    // { added by Sergey 26.09.2013 for ITS#191542
    function log(str)
    {
        EngineListenerMain.qmlLog("QML " + progressBar.name + ": " + str);
    }
    // } added by Sergey 26.09.2013 for ITS#191542


    // { modified by Sergey 15.05.2013
    function animateProgressBar(pos)
    {
        // { added by Sergey 28.112013 for ITS#211490 logs for error cases
        if ( pos < 0 )
        {
            EngineListenerMain.qmlLog(progressBar.name, "animateProgressBar position = " + pos); // modified by sangmin.seol 2014.09.12 reduce high log // added by Sergey 28.112013 for ITS#211490
            return;
        }

        // { modified by cychoi 2015.06.17 update progress bar in seconds (not milliseconds)
        var posSec = Math.floor( pos / 1000 )
        var totalTimeSec = Math.floor( nTotalTime / 1000 )

        if ( posSec <= totalTimeSec )
        {
            selected_pb.width = bCursorVisible * ( cursor_image.sourceSize.width / 4 )

            if ( totalTimeSec )
            {
                selected_pb.width += ( posSec / totalTimeSec ) *
                        ( pb_empty_line.width - bCursorVisible * cursor_image.sourceSize.width / 2 )

                if(selected_pb.width <= 0)
                {
                    EngineListenerMain.qmlLog(progressBar.name, "animateProgressBar width = " + selected_pb.width + " pb_empty_line.width + "
                                              + pb_empty_line.width + " cursor_image.sourceSize.width = " + cursor_image.sourceSize.width); // modified by sangmin.seol 2014.09.12 reduce high log // added by Sergey 28.112013 for ITS#211490
                }
            }
            //else
            //{
                // { added by cychoi 2014.07.10 for removed too many logs...
                //if(progressBar.state == "DVD" || progressBar.state == "VCD")
                //    return
                // } added by cychoi 2014.07.10
                //EngineListenerMain.qmlCritical(progressBar.name, "animateProgressBar totalTimeSec = " + totalTimeSec); // added by Sergey 28.112013 for ITS#211490
            //}
        }
        // } modified by cychoi 2015.06.17
        //else
        //{
            // { added by cychoi 2014.06.27 for removed too many logs...
            //if(progressBar.state == "DVD" || progressBar.state == "VCD")
            //    return
            // } added by cychoi 2014.06.27
            //EngineListenerMain.qmlCritical(progressBar.name, "animateProgressBar position = " + posSec + " totalTimeSec = " + nTotalTime); // added by Sergey 28.112013 for ITS#211490
        //}
        // } added by Sergey 28.112013 for ITS#211490 logs for error cases
    }
    // } modified by Sergey 15.05.2013


    function convertTime( ms )
    {
        // { modified by cychoi 2015.07.10 for HMC new spec (time >= 1 hour - HH:MM:SS, time < 1 hour - MM:SS, wo leading zero)
        var t = Math.floor( ms / 1000 )
        var totalMin = Math.floor( t / 60 )
        var hour = Math.floor( t / 3600 )
        t = t % 3600
        var min = Math.floor( t / 60 )
        var sec = t % 60
        var str = min + ":" + sec
        if (totalMin > 59)
        {
            str = str.replace( /^(\d):/, "0" + min + ":" )
            str = str.replace( /:(\d)$/, ":0" + sec )
            str = hour + ":" + str
            //str = str.replace( /^(\d):/, "0" + hour + ":" ) // wo leading zero
        }
        else
        {
            //str = str.replace( /^(\d):/, "0" + min + ":" ) // wo leading zero
            str = str.replace( /:(\d)$/, ":0" + sec )
        }
        // } modified by cychoi 2015.07.10
        return str
    }




    // ==================================== Sub elements ========================================================

    Timer
    {
        id: invisiblityTimer
        interval: CONST.const_FULLSCREEN_DURATION_ANIMATION
        onTriggered:
        {
            if(!onScreen)
            {
               progressBar.visible = onScreen
               progressBar.bPressed = false //modify ys 20140716 its242671
            }
        }
    }

    Image
    {
        id: bg
        anchors.bottom: parent.bottom
        source: RES.const_URL_IMG_PB_BG
    }

    Text
    {
        id:curTime
        text: convertTime( nCurrentTime )
        // { added by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
        anchors.left: parent.left
        anchors.leftMargin: CONST.const_PB_CURR_TIME_OFFSET
        //anchors.verticalCenter: pb_empty_line.verticalCenter
        // } added by cychoi 2014.04.02
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        // { added by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
        horizontalAlignment: (progressBar.state == "DVD" || progressBar.state == "VCD") ? Text.AlignLeft : Text.AlignRight 
        width: CONST.const_PB_CURR_TIME_WIDTH
        // } added by cychoi 2014.04.02
        font.pointSize: CONST.const_FONT_SIZE_TEXT_HDR_30_FONT
        font.family: CONST.const_FONT_FAMILY_NEW_HDB
        color: CONST.const_FONT_COLOR_GREY
        style: Text.Outline
        styleColor: "#000000"
    }

    Text
    {
        id: totalTime
        text: convertTime( nTotalTime )
        // { added by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
        anchors.right: parent.right
        anchors.rightMargin: CONST.const_PB_TOTAL_TIME_OFFSET
        //anchors.verticalCenter: pb_empty_line.verticalCenter
        // } added by cychoi 2014.04.02
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        // { added by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
        horizontalAlignment: Text.AlignLeft 
        width: CONST.const_PB_TOTAL_TIME_WIDTH
        // } added by cychoi 2014.04.02
        font.pointSize: CONST.const_FONT_SIZE_TEXT_HDR_30_FONT
        font.family: CONST.const_FONT_FAMILY_NEW_HDB
        color: CONST.const_FONT_COLOR_GREY
        style: Text.Outline
        styleColor: "#000000"
    }

    DHAVN_VP_Marquee_Text
    {
        id: mainName
        width: CONST.const_PB_FILE_WIDTH // should initialize not to scroll text on first launch.
        text: video_model.filename
        // { modified by cychoi 2014.06.05 for ITS 239376 set tune color to mainName (UX guideline)
        color: (bTuneTextColor && !bTuneSameFile) ? CONST.const_FONT_COLOR_RGB_BLUE_TEXT : CONST.const_FONT_COLOR_BRIGHT_GREY
        //color: ( (bTuneTextColor && !bTuneSameFile) && progressBar.state != "DVD" ) ? CONST.const_FONT_COLOR_RGB_BLUE_TEXT : CONST.const_FONT_COLOR_BRIGHT_GREY
        // } modified by cychoi 2014.06.05
        fontSize: CONST.const_FONT_SIZE_TEXT_HDR_30_FONT
        fontFamily: CONST.const_FONT_FAMILY_NEW_HDR //modified by aettie 20130605
        style: Text.Outline
        styleColor: "#000000"
        // removed by Sergey 04.10.2013 for ITS#193346
    }

    Text
    {
        id: subName
        text: video_model.filename2
        // { modified by kihyung 2013.10.08 for ITS 0194414
        // color: ((bTuneTextColor && !bTuneSameFile) && progressBar.state == "DVD") ? CONST.const_FONT_COLOR_RGB_BLUE_TEXT : CONST.const_FONT_COLOR_BRIGHT_GREY 
        color: (bTuneTextColor && !bTuneSameFile) ? CONST.const_FONT_COLOR_RGB_BLUE_TEXT : CONST.const_FONT_COLOR_BRIGHT_GREY 
        // } modified by kihyung 2013.10.08 for ITS 0194414         
        font.pointSize: CONST.const_FONT_SIZE_TEXT_HDR_26_FONT
        font.family: CONST.const_FONT_FAMILY_NEW_HDR //modified by aettie 20130605
        style: Text.Outline
        styleColor: "#000000"
    }

    // Repeat icons
    // Repeat icons should be displayed as repeat of only if shuffle is activated.
    // In other cases repeat icons should be displayed as repeat all/ repeat one
    Image
    {
        id: repeatIcon
        source: (( nScanStatus != 0 || (progressBar.sState == "VCD" && bPbcMode == true))? RES.const_URL_IMG_PB_REPEAT_OFF :
                 ( (nRepeatStatus == 0) && !__repeatPressed )? RES.const_URL_IMG_PB_REPEAT_ALL :
                 ( (nRepeatStatus == 1) && !__repeatPressed )? RES.const_URL_IMG_PB_REPEAT_FOLDER :
                 ( (nRepeatStatus == 2) && !__repeatPressed )? RES.const_URL_IMG_PB_REPEAT_ONE :
                 ( (nRepeatStatus == 0) && __repeatPressed ) ? RES.const_URL_IMG_PB_REPEAT_ALL_P :
                 ( (nRepeatStatus == 1) && __repeatPressed ) ? RES.const_URL_IMG_PB_REPEAT_FOLDER_P :
                 ( (nRepeatStatus == 2) && __repeatPressed ) ? RES.const_URL_IMG_PB_REPEAT_ONE_P :
                 RES.const_URL_IMG_PB_REPEAT_ALL)

        MouseArea
        {
            property bool touchCanceled: false // added by Sergey 01.11.2013 for ITS#199058

            anchors.fill: parent
            beepEnabled : false;

            onPressed: 
            {
                //{ modified by yongkyun.lee 2013-08-15 for :  ISV 85716
                /*
                if(progressBar.isSeekPressed || progressBar.is_ff_rew ) //modify youngsim.jo 20140724 its 0241576
                    return;
                */
                //} modified by yongkyun.lee 2013-08-15 
                __repeatPressed = true
                touchCanceled = false; // added by Sergey 01.11.2013 for ITS#199058
            }

            onReleased:
            {
                //{ modified by yongkyun.lee 2013-08-15 for :  ISV 85716
                EngineListenerMain.ManualBeep();
                EngineListenerMain.qmlLog("repeatIcon: touchCanceled : "+ touchCanceled+", isSeekPressed: "+progressBar.isSeekPressed+", progressBar.is_ff_rew: "+progressBar.is_ff_rew);
                if(touchCanceled /*|| progressBar.isSeekPressed || progressBar.is_ff_rew*/) //modify youngsim.jo 20140724 its 0241576// modified by Sergey 01.11.2013 for ITS#199058
                {
                    __repeatPressed = false// modified by yongkyun.lee 2013-08-29 for : ITS 187281
                    return;
                }
                //} modified by yongkyun.lee 2013-08-15 
                controller.onSoftkeyBtnReleased( CONST.const_PB_REPEAT_ID )
                __repeatPressed = false
            }
            // { modified by kihyung 2013.08.08 for ITS 0181817
            onCanceled: 
            {
                EngineListenerMain.qmlLog("repeatIcon : onCanceled");
                __repeatPressed = false
                touchCanceled = true; // added by Sergey 01.11.2013 for ITS#199058
            }
            // } modified by kihyung 2013.08.08 for ITS 0181817
            onExited:
            {
                EngineListenerMain.qmlLog("repeatIcon : onExited");
                __repeatPressed = false
                touchCanceled = true; // added by Sergey 01.11.2013 for ITS#199058
            }


        }
    }

    Image
    {
        id: randomIcon
        source:(( __randomPressed && (nRandomStatus == 0) ) ? RES.const_URL_IMG_PB_SHUFFLE_OFF_P :
                ( __randomPressed && (nRandomStatus == 1) ) ? RES.const_URL_IMG_PB_SHUFFLE_OFF_P :
        // { added by kihyung 2012.06.28
                ( __randomPressed && (nRandomStatus == 2) ) ? RES.const_URL_IMG_PB_SHUFFLE_OFF_P :
        // } added by kihyung
                ( nScanStatus   != 0 ) ? RES.const_URL_IMG_PB_SHUFFLE_OFF : // added by kihyung 2012.07.26 for CR 11894
                ( nRandomStatus == 0 ) ? RES.const_URL_IMG_PB_SHUFFLE_OFF :
                ( nRandomStatus == 1 ) ? RES.const_URL_IMG_PB_SHUFFLE_ON :
                ( nRandomStatus == 2 ) ? RES.const_URL_IMG_PB_SHUFFLE_ON :
                RES.const_URL_IMG_PB_SHUFFLE_OFF)

        MouseArea
        {
            property bool touchCanceled: false // added by Sergey 01.11.2013 for ITS#199058

            anchors.fill: parent
            beepEnabled : false;

            onPressed:
            {
                //{ modified by yongkyun.lee 2013-08-15 for :  ISV 85716
                /*
                if(progressBar.isSeekPressed || progressBar.is_ff_rew ) //modify youngsim.jo 20140724 its 0241576
                    return;
                */
                //} modified by yongkyun.lee 2013-08-15 
                __randomPressed = true
                touchCanceled = false; // added by Sergey 01.11.2013 for ITS#199058
            }

            onReleased:
            {
                //{ modified by yongkyun.lee 2013-08-15 for :  ISV 85716
                EngineListenerMain.ManualBeep();
                EngineListenerMain.qmlLog("randomIcon : touchCanceled : "+ touchCanceled+", isSeekPressed: "+progressBar.isSeekPressed+", progressBar.is_ff_rew: "+progressBar.is_ff_rew);
                if(touchCanceled /*|| progressBar.isSeekPressed || progressBar.is_ff_rew*/ ) //modify youngsim.jo 20140724 its 0241576 // modified by Sergey 01.11.2013 for ITS#199058
                {
                    __randomPressed = false// modified by yongkyun.lee 2013-08-29 for : ITS 187281
                    return;
                }
                //} modified by yongkyun.lee 2013-08-15 
                controller.onSoftkeyBtnReleased( CONST.const_PB_RANDOM_ID )
                __randomPressed = false
            }
            
            // { modified by kihyung 2013.08.08 for ITS 0181817
            onCanceled:
            {
                __randomPressed = false    
                touchCanceled = true; // added by Sergey 01.11.2013 for ITS#199058
                EngineListenerMain.qmlLog("randomIcon : onCanceled");
            }

            // { added by Sergey 01.11.2013 for ITS#199058
            onExited:
            {
                __randomPressed = false
                touchCanceled = true;
                EngineListenerMain.qmlLog("randomIcon : onExited");
            }
            // } added by Sergey 01.11.2013 for ITS#199058
            // } modified by kihyung 2013.08.08 for ITS 0181817
        }
    }


    // Background line image of progress bar
    Image
    {
        id: pb_empty_line
        // { modified by cychoi 2014.04.02 for HMC Request - New Progress Bar GUI (total time >= 1 hour - HH:MM:SS, total time < 1 hour - MM:SS)
        anchors.left: curTime.right
        anchors.leftMargin: CONST.const_PB_OFFSET_LEFT_DEFAULT
        //anchors.left: progressBar.left // modified by Sergey 15.05.2013
        //anchors.leftMargin: CONST.const_SCREEN_WIDTH - totalTime.x +  CONST.const_PB_OFFSET_LEFT_DEFAULT // modified by Sergey 15.05.2013
        // } modified by cychoi 2014.04.02
        anchors.right: totalTime.left
        anchors.rightMargin: CONST.const_PB_OFFSET_RIGHT_DEFAULT
        anchors.verticalCenter: curTime.verticalCenter
        fillMode: Image.TileHorizontally
        source: RES.const_URL_IMG_PB_ENPTY_LINE

        // { added by kihyung 2013.07.05 for ITS 0178559 
        onWidthChanged:
        {
            animateProgressBar(nCurrentTime) 
        }
        // } added by kihyung 2013.07.05 for ITS 0178559         

        // Selected image of progress bar
        Image
        {
            id: selected_pb
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.TileHorizontally
            source: RES.const_URL_IMG_PB_SELECTED_LINE

            // Cursor image on progress bar
            Image
            {
                anchors.right: cursor_image.horizontalCenter
                anchors.verticalCenter: cursor_image.verticalCenter
                source: RES.const_URL_IMG_PB_CURSOR_POINT
                width: selected_pb.width > sourceSize.width ? sourceSize.width : selected_pb.width
            }
            Image
            {
                id: cursor_image
                anchors.right: parent.right
                anchors.rightMargin: -sourceSize.width / 2
                anchors.verticalCenter: parent.verticalCenter
                source: RES.const_URL_IMG_PB_CURSOR_CIRCLE
                visible: bCursorVisible
            }
        }

        // { modified by Sergey 15.05.2013
        MouseArea
        {
            id: cursorMA
            enabled: bSeekable
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: -50
            height: 150
            beepEnabled: false // added by Sergey 23.11.2013 to beep when tapp progress bar

            property int lastX      // last mouseX
            property int lastFrameX // mouseX of last shown frame
            property int deltaX     // delta of lastFrameX and current mouseX
            property int second     // "seconds" equivalent of current mouseX
            property int lastSecond // added by kihyung 2013.06.20 for ITS 0172658


            onPressed:
            {
                EngineListenerMain.qmlLog(progressBar.name, "cursor onPressed"); // modified by sangmin.seol 2014.09.12 reduce high log // added by Sergey 28.112013 for ITS#211490
                progressBar.bPressed = true
            	updateProgressBar( mouseX )//added by edo.lee 2013.05.30
            	controller.onProgressBarPressed() // added by kihyung 2013.06.21 for 0175221
            }

            onReleased:
            {
                EngineListenerMain.qmlLog(progressBar.name, "cursor onReleased = " + mouseX); // modified by sangmin.seol 2014.09.12 reduce high log // added by Sergey 28.112013 for ITS#211490

                EngineListenerMain.ManualBeep(); // added by Sergey 23.11.2013 to beep when tapp progress bar

                if(mouseX > -100) // added by Sergey 07.09.2013 for ITS#186722, 188075
                {
                    // { modified by kihyung 2013.07.09 for ITS 0178070
                    t.stop()

                    // { modified by kihyung 2013.08.29 for ITS 0186278
                    if(mouseX < 0)
                    {
                        second = 0;
                    }
                    else if(mouseX >= parent.width)
                    {
                        second = ((parent.width - 1) / parent.width) * nTotalTime
                    }
                    else if(mouseX >= 0 && mouseX < parent.width)
                    {
                        second = (mouseX / parent.width) * nTotalTime
                    }
                    // } modified by kihyung 2013.08.29 for ITS 0186278
                    
                    EngineListenerMain.qmlLog("cursorMA onReleased second: " + second)
                    controller.onProgressBarSetPosition( second )
                    // controller.onProgressBarReleased() // removed by kihyung 2013.09.10
                } // added by Sergey 07.09.2013 for ITS#186722, 188075

                controller.onProgressBarReleased() // added by kihyung 2013.09.10
                progressBar.bPressed = false
                // } modified by kihyung 2013.07.09 for ITS 0178070                 
            }

            // { added by kihyung 2013.08.09 for ITS onPositionChanged
            onCanceled:
            {
                EngineListenerMain.qmlLog(progressBar.name, "cursor onCanceled"); // modified by sangmin.seol 2014.09.12 reduce high log // added by Sergey 28.112013 for ITS#211490
                t.stop()
                controller.onProgressBarReleased() //added by hyejin.noh 20141008 for ITS 0249984
                progressBar.bPressed = false
            }
            // } added by kihyung 2013.08.09 for ITS onPositionChanged

            onPositionChanged:
            {
                if(mouseX < -100)	// added by Sergey 31.08.2013 for ITS#186722 
                    return;

                if(progressBar.bPressed)
                    updateProgressBar( mouseX )
                else
                    EngineListenerMain.qmlLog(progressBar.name, "progressBar.bPressed = false"); // modified by sangmin.seol 2014.09.12 reduce high log //add ys its-0237494
            }

            function updateProgressBar( mX )
            {
                // removed by kihyung 2013.06.20 for ITS 0172658
                //if(Math.abs(lastX - mX) < 15) return // touch works very slowly so ignore some events to increase drag performance

                lastX = mX

                if ( mX >= 0 && mX <= parent.width )
                {
                    second = (mX / parent.width) * nTotalTime
                    animateProgressBar(second)

                    deltaX = Math.abs(lastFrameX - mouseX)

                    if(deltaX > 25)
                        t.restart()
                }
                else
                {
                    // t.stop()

                    if(mX < 0)
                        second = 0
                    else if(mX >= parent.width)
                        second = nTotalTime - 10 // modified by kihyung 2013.06.24

                    if(lastSecond != second)
                    {
                        animateProgressBar(second) // added by kihyung 2013.08.03 for smoke test 24.18
                        t.restart()
                    }
                    else
                    {
                        EngineListenerMain.qmlLog(progressBar.name, "mX= " +mX+", width= "+parent.width+", nTotalTime = "+nTotalTime+", lastSecond="+lastSecond+", second="+second);//add ys its-0237494
                    }
                }
            }

            Timer
            {
                id: t

                interval: 200

                onTriggered:
                {
                    EngineListenerMain.qmlLog("cursorMA onTriggered second: " + cursorMA.second)
                    cursorMA.lastFrameX = cursorMA.mouseX
                    cursorMA.lastSecond = cursorMA.second
                    controller.onProgressBarSetPosition( cursorMA.second )
                }
            }
        } // end of cursorMA
	// } modified by Sergey 15.05.2013
    }
    //modified by aettie 20130906
    Connections
    {
        target:EngineListenerMain
        onTickerChanged:
        {
            EngineListenerMain.qmlLog("onTickerChanged ticker : " + ticker);
            progressBar.scrollingTicker = ticker;
        }
    }

}
// } modified by Sergey 05.05.2013
