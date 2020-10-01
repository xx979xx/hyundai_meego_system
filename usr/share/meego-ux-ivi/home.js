/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

function textToSpeech(sentence) {
    if(ttsControl && ttsControl.isOn) {
        ttsControl.say(sentence)
    }
}

function showVoiceCommand(sentence) {
    ttsOverlay.text = sentence
    ttsOverlay.textColor = "white"
    ttsOverlay.fadeaway.start()
}

function desktopMenuGrabFocus() {
    if (appwindow.state != "showDesktopMenu" ) {
        console.log ("desktopMenuGrabFocus()")
        desktopmenu.forceActiveFocus()
    }
}

function scrollMenuGrabFocus() {
    if (appwindow.state != "showScrollMenu" ) {
        console.log ("scrollMenuGrabFocus()")
        scrollmenu.forceActiveFocus()
    }
}

function taskMenuGrabFocus() {
    if (appwindow.state != "showTaskMenu" ) {
        console.log ("taskMenuGrabFocus()")
        taskmenu.forceActiveFocus()
    }
}

function handleVoiceCommand(sentence) {
    showVoiceCommand(sentence)

    if(sentence == "HOME") {
        qApp.goHome()
    }
    else if(sentence == "MENU") {
        topmenu.homeClicked()
    }
    else if(sentence == "BACK") {
        topmenu.backClicked()
    }
    else if(sentence == "CANCEL") {
        topmenu.backClicked()
    }
    else if(sentence == "OPEN") {
        if (appwindow.state == "showScrollMenu") {
            scrollmenu.enterClicked()
        }
    }
    else if(sentence == "CLOSE" || sentence == "CLOSE(2)") {
        topmenu.backClicked()
    }
    else if(sentence == "NEXT" || sentence == "NEXT(2)") {
        if (appwindow.state == "showScrollMenu")
            scrollmenu.nextClicked()
        else if (appwindow.state == "showTaskMenu")
            taskmenu.nextClicked()
        else
            desktopmenu.nextClicked()
    }
    else if(sentence == "PREVIOUS") {
        if (appwindow.state == "showScrollMenu")
            scrollmenu.previousClicked()
        else if (appwindow.state == "showTaskMenu")
            taskmenu.previousClicked()
        else
            desktopmenu.previousClicked()
    }
    else if(sentence == "TASKS") {
        qApp.toggleSwitcher()
    }
    else if(appwindow.state != "showScrollMenu" && appwindow.state != "showTaskMenu") {
        if(sentence == "NAVIGATION" ||
           sentence == "SETTINGS" ||
           sentence == "DIALER" ||
           sentence == "WEB" ||
           sentence == "PANELS") {
            console.log ("go to application")
            desktopmenu.goToApplication(sentence)
        }
    }
    else if(sentence == "OPEN DIALER") {
        qApp.launcherDesktopByName("/usr/share/applications/dialer.desktop")
    }
    else if(sentence == "OPEN CONTACTS") {
        qApp.launcherDesktopByName("/usr/share/meego-ux-ivi/applications/meego-app-contacts.desktop")
    }
    else if(sentence == "OPEN WEB" || sentence == "OPEN BROWSER") {
        qApp.launcherDesktopByName("/usr/share/applications/meego-app-browser.desktop")
    }
    else if(sentence == "OPEN PHOTOS") {
        qApp.launcherDesktopByName("/usr/share/applications/meego-app-photos.deskto")
    }
    else if(sentence == "OPEN MUSIC") {
        qApp.launcherDesktopByName("/usr/share/applications/meego-app-music.desktop")
    }
    else if(sentence == "OPEN VIDEOS") {
        qApp.launcherDesktopByName("/usr/share/applications/meego-app-videos.desktop")
    }
    else if(sentence == "OPEN SETTINGS") {
        qApp.launcherDesktopByName("/usr/share/meego-ux-ivi/applications/meego-ux-settings.desktop")
    }
    else if(sentence == "OPEN PANELS") {
        qApp.showPanels()
    }
}
