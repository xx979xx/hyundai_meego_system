/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

function enterFullscreen()
{
    showVideoToolbar = false;
    fullScreen = true;
}

function exitFullscreen()
{
    fullScreen = false;
    showVideoToolbar = true;
}

function changeItemFavorite(item) {
    editorModel.setFavorite(item.mitemid,!item.mfavorite)
}

function changestatus(videostate)
{
    if(videostate == VideoListModel.Playing)
    {
        // Play
        editorModel.setPlayStatus(currentVideoID, VideoListModel.Playing);
        videoToolbar.ispause = true;
        window.inhibitScreenSaver = true;
        dbusControl.state = "playing";
    }
    else if(videostate == VideoListModel.Paused)
    {
        // Pause
        editorModel.setPlayStatus(currentVideoID, VideoListModel.Paused);
        videoToolbar.ispause = false;
        window.inhibitScreenSaver = false;
        dbusControl.state = "paused";
    }
    else
    {
        // Stop
        editorModel.setPlayStatus(currentVideoID, VideoListModel.Stopped);
        videoToolbar.ispause = false;
        window.inhibitScreenSaver = false;
        dbusControl.state = "stopped";
    }
}

function play()
{
    if (!video.playing || video.paused)
    {
        resourceManager.userwantsplayback = true;
        changestatus(VideoListModel.Playing);
        editorModel.setViewed(currentVideoID);
    }
}

function pause()
{
    video.pause();
    resourceManager.userwantsplayback = false;
    changestatus(VideoListModel.Paused);
}

function stop()
{
    audio.stop();
    resourceManager.userwantsplayback = false;
    changestatus(VideoListModel.Stopped);
}

function playNewVideo(payload)
{
    currentVideoID = payload.mitemid;
    currentVideoFavorite = payload.mfavorite;
    videoSource = payload.muri;
    labelVideoTitle = payload.mtitle;
    editorModel.setViewed(payload.mitemid);

    videoToolbar.ispause = true;
    video.source = videoSource;
    play();
    if(fullScreen)
        showVideoToolbar = false;
    else
        showVideoToolbar = true;
}

function playNextVideo() {
    videoThumbnailView.show(true);
    if (videoThumbnailView.currentIndex < (videoThumbnailView.count -1))
        videoThumbnailView.currentIndex++;
    else
        videoThumbnailView.currentIndex = 0;

    playNewVideo(videoThumbnailView.currentItem);
}

function playPrevVideo() {
    videoThumbnailView.show(false);
    if (videoThumbnailView.currentIndex == 0)
        videoThumbnailView.currentIndex = videoThumbnailView.count - 1;
    else
        videoThumbnailView.currentIndex--;

    playNewVideo(videoThumbnailView.currentItem);
}

function formatTime(time)
{
    var min = parseInt(time/60);
    var sec = parseInt(time%60);
    return min+ (sec<10 ? ":0":":") + sec
}

function formatMinutes(time)
{
    var min = parseInt(time/60);
    return min
}

function openItemInDetailView(item)
{
    videoSource = item.muri;
    videoFullscreen = false;
    landingPage.addApplicationPage(detailViewContent);
    labelVideoTitle = item.mtitle;
    editorModel.setViewed(item.mitemid);
}

function openItemInDetailViewFullscreen(item)
{
    videoSource = item.muri;
    videoFullscreen = true;
    scene.fullscreen = true;
    contentStrip.push(detailViewContent,videosSideContent);
    contentStrip.activeContent.crumb.label = item.mtitle;
    labelVideoTitle = item.mtitle;
    editorModel.setViewed(item.mitemid);
}
