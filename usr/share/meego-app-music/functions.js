/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

function selectionCount()
{
    switch(multiSelectModel.type) {
    case MusicListModel.NowPlaying:
    case MusicListModel.MusicPlaylist:
        return multiSelectModel.selectionCount(MusicListModel.SelectByIndex);
    default:
        return multiSelectModel.selectionCount(MusicListModel.SelectByID);
    }
}

function clearSelected()
{
    switch(multiSelectModel.type) {
    case MusicListModel.NowPlaying:
    case MusicListModel.MusicPlaylist:
        multiSelectModel.clearSelected(MusicListModel.SelectByIndex);
        break;
    default:
        multiSelectModel.clearSelected(MusicListModel.SelectByID);
    }
}

function getSelectedURIs()
{
    switch(multiSelectModel.type) {
    case MusicListModel.NowPlaying:
    case MusicListModel.MusicPlaylist:
        return multiSelectModel.getSelectedURIs(MusicListModel.SelectByIndex);
    default:
        return multiSelectModel.getSelectedURIs(MusicListModel.SelectByID);
    }
}

function getSelectedIDs()
{
    switch(multiSelectModel.type) {
    case MusicListModel.NowPlaying:
    case MusicListModel.MusicPlaylist:
        return multiSelectModel.getSelectedIDs(MusicListModel.SelectByIndex);
    default:
        return multiSelectModel.getSelectedIDs(MusicListModel.SelectByID);
    }
}

function playlistNameValidate(parm,val) {
    if (parm == "") return true;
    for (var i=0; i<parm.length; i++) {
        if (val.indexOf(parm.charAt(i),0) != -1) return false;
    }
    return true;
}

function addToPlayqueue(item) {
    playqueueModel.addItems(item.mitemid);
    updateNowNextPlaying();
}

function addMultipleToPlayqueue() {
    playqueueModel.addItems(getSelectedIDs());
    updateNowNextPlaying();
    clearSelected();
    shareObj.clearItems();
    multiSelectMode = false;
}

function removeFromPlayqueue() {
    if(playqueueModel.playindex == targetIndex)
    {
        audio.stop();
        resourceManager.userwantsplayback = false;
    }
    playqueueModel.removeIndex(targetIndex);
    updateNowNextPlaying();
}

function removeFromPlaylist(list) {
    list.removeIndex(targetIndex);
    clearSelected();
}

function removeMultipleFromPlayqueue() {
    var playid = playqueueModel.datafromIndex(playqueueModel.playindex, MediaItem.ID);
    var ids = getSelectedIDs();
    var i;
    for (i in ids) {
        if(ids[i] == playid)
        {
            audio.stop();
            resourceManager.userwantsplayback = false;
            break;
        }
    }
    playqueueModel.removeSelected();
    updateNowNextPlaying();
    clearSelected();
    shareObj.clearItems();
    multiSelectMode = false;
}

function removeMultipleFromPlaylist(list) {
    list.removeSelected();
    clearSelected();
    shareObj.clearItems();
    multiSelectMode = false;
}

function addToPlayqueueAndPlay(item)
{
    var idx = playqueueModel.count;
    addToPlayqueue(item);
    playqueueModel.playindex = idx;
    playNewSong();
    updateNowNextPlaying();
}

function addMultipleToPlayqueueAndPlay()
{
    var ids = getSelectedIDs();
    var idx = playqueueModel.count;
    playqueueModel.addItems(ids);
    playqueueModel.playindex = idx;
    playNewSong();
    updateNowNextPlaying();
    clearSelected();
    shareObj.clearItems();
    multiSelectMode = false;
}

function changeItemFavorite(item, val) {
    editorModel.setFavorite(item.mitemid,val);
}

function changeMultipleItemFavorite(val) {
    var ids = getSelectedIDs();
    var i;
    for (i in ids) {
        editorModel.setFavorite(ids[i], val);
    }
    clearSelected();
    shareObj.clearItems();
    multiSelectMode = false;
}

function audioplay()
{
    resourceManager.userwantsplayback = true;
    dbusControl.updateNowNextTracks();
    dbusControl.playbackState = 1;
    playqueueModel.playstatus = MusicListModel.Playing;
    toolbar.playing = true;
}

function pause()
{
    audio.pause();
    resourceManager.userwantsplayback = false;
    dbusControl.playbackState = 2;
    playqueueModel.playstatus = MusicListModel.Paused;
    toolbar.playing = false;
}

function stop()
{
    audio.stop();
    resourceManager.userwantsplayback = false;
    dbusControl.updateNowNextTracks();
    dbusControl.playbackState = 3;
    playqueueModel.playstatus = MusicListModel.Stopped;
    toolbar.playing = false;
}


function play()
{
    if (audio.paused ) {
        audioplay();
    } else {
        return playNewSong();
    }
    return true;
}

function playNewSong() {
    audio.stop();

    // if there are no songs or the index is out of range, do nothing
    if((playqueueView.count <= 0)||
       (playqueueModel.playindex >= playqueueView.count))
    {
        return false;
    }

    if (playqueueModel.playindex == -1)
        playqueueModel.playindex = 0;

    toolbar.trackName = playqueueModel.datafromIndex(playqueueModel.playindex, MediaItem.Title);
    toolbar.artistName = playqueueModel.datafromIndex(playqueueModel.playindex, MediaItem.Artist)[0];

    audio.source = playqueueModel.datafromIndex(playqueueModel.playindex, MediaItem.URI);
    audioplay();
    editorModel.setViewed(playqueueModel.datafromIndex(playqueueModel.playindex, MediaItem.ID));
    return true;
}

function playNextSong() {
    if (playqueueModel.playindex < (playqueueView.count -1))
    {
        playqueueModel.playindex++;
    }
    else
    {
        if (loop){
            playqueueModel.playindex = 0;
        }else{
            stop();
            return;
        }
    }
    audio.source = "";
    playNewSong();
    updateNowNextPlaying();
}

function playPrevSong() {
    if (playqueueModel.playindex == 0)
    {
        if (loop) {
            playqueueModel.playindex = playqueueView.count - 1;
        }else {
            stop();
            return;
        }
    }
    else
    {
        playqueueModel.playindex--;
    }
    audio.source = "";
    playNewSong();
    updateNowNextPlaying();
}

function updateNowNextPlaying()
{
    if (dbusControl.state == "stopped") {
        dbusControl.nextItem1 = -1;
        dbusControl.nextItem2 = -1;
    } else  if (playqueueModel.playindex == 0) {
        if (playqueueView.count == 1) {
            dbusControl.nextItem1 = -1;
            dbusControl.nextItem2 = -1;
        } else if (playqueueView.count == 2) {
            dbusControl.nextItem1 = 1;
            dbusControl.nextItem2 = -1;
        } else {
            dbusControl.nextItem1 = 1;
            dbusControl.nextItem2 = 2;
        }
    } else {
        if (playqueueModel.playindex+1 < playqueueView.count) {
            dbusControl.nextItem1 = playqueueModel.playindex+1;

            if (dbusControl.nextItem1+1 < playqueueView.count) {
                dbusControl.nextItem2 = dbusControl.nextItem1+1;
            } else if (loop && playqueueView.count > 2) {
                dbusControl.nextItem2 = 0
            } else {
                dbusControl.nextItem2 = -1;
            }

        } else if (loop && playqueueView.count > 1) {
            dbusControl.nextItem1 = 0;
            if (playqueueView.count > 2) {
                dbusControl.nextItem2 = 1;
            } else {
                dbusControl.nextItem2 = -1
            }
        } else {
            dbusControl.nextItem1 = -1;
            dbusControl.nextItem2 = -1;
        }
    }
    dbusControl.updateNowNextTracks();

}

function formatLength(time)
{
    var val = parseInt(time);
    var dec = parseInt((time-val)*10);
    return (dec == 0)?val:(val + "." + dec)
}

function formatAlbumLength(length)
{
    var hours = parseInt(length/3600);
    var mins = parseInt( (length%3600)/60 );
    var time = "";
    if( hours == 0 && mins == 0 )
    {//only show seconds
        var secs = parseInt( length%3600 );
        time = (secs==1) ? qsTr("1 second") : qsTr("%1 seconds").arg(secs);
    }
    else
    {
        if( hours == 0 )
        {//only show minutes
            time = (mins==1) ? qsTr("1 minute") : qsTr("%1 minutes").arg(mins);
        }
        else
        {
            if( mins == 0 )
            {//only show hours
                time = ((hours == 1) ? qsTr("1 hour") : qsTr("%1 hours").arg(hours));
            }
            else
            {//show hours and minutes
                time = ((hours == 1) ? qsTr("1 hour") : qsTr("%1 hours").arg(hours)) + ((mins == 1) ? qsTr(" 1 minute") : qsTr(" %1 minutes").arg(mins));
            }
        }
    }
    return time
}

function formatTime(time)
{
    var min = parseInt(time/60);
    var sec = parseInt(time%60);
    return min+ (sec<10 ? ":0":":") + sec
}

function openItemInDetailView(fromPage, item)
{
    switch(item.mitemtype) {
    case 2:
        // type is song
        // no detail view
        break;
    case 3:
        // type is artist
        labelArtist = item.mtitle;
        window.addPage(artistDetailViewContent);
        break;
    case 4:
        // type is album
        thumbnailUri = item.mthumburi;
        labelAlbum = item.mtitle;
        currentAlbum = item;
        window.addPage(albumDetailViewContent);
        break;
    case 5:
        // type is playlist
        thumbnailUri = item.mthumburi;
        labelPlaylist = item.mtitle;
        labelPlaylistURN = item.murn;
        window.addPage(playlistDetailViewContent);
        break;
    default:
        break;
    }
}

function appendItemToPlaylist(item, playlistItem)
{
    miscModel.type = MusicListModel.MusicPlaylist;
    miscModel.clear();
    miscModel.playlist = playlistItem.mtitle;
    miscModel.addItems(item.mitemid);
}
