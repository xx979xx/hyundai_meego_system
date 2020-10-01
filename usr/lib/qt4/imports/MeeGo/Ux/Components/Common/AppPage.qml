/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
 \qmlclass AppPage
 \title AppPage
 \section1 AppPage
 This is a basic meego-ux-components page. It provides functionality and access to the
 windows action menu and should be the base for every page used.

  \section2 API Properties

  \qmlproperty string pageTitle
  \qmlcm sets the title of the page displayed in the toolbar.

  \qmlproperty variant actionMenuModel
  \qmlcm holds the action menus clickable entries.

  \qmlproperty variant actionMenuPayload
  \qmlcm holds the action menus data for each entry.

  \qmlproperty bool enableCustomActionMenu
  \qmlcm enables custom action menus set by the AppPage.

  \qmlproperty bool fullScreen
  \qmlcm hides the statusbar if true.

  \qmlproperty bool fullContent
  \qmlcm hides the statusbar and the toolbar if true.

  \qmlproperty bool pageUsingFullScreen
  \qmlcm If set to true, the page will use the complete space available. Statusbar and
  toolbar will still be visible above it and obfuscate what's below. If set to false,
  the page will always occupy the space below the toolbar, stretching/squeezing to fit it.

  \qmlproperty bool actionMenuHighlightSelection
  \qmlcm set true if the actionMenu should highlight the last selected item

  \qmlproperty bool actionMenuOpen
  \qmlcm true if the actionMenu is currently open

  \qmlproperty bool backButtonLocked
  \qmlcm set to true to lock the backButton

  \qmlproperty bool fastPageSwitch
  \qmlcm if true, allows multiple addPage and popPage. If false, addPage
         and popPage calls are ignored while the page switch animation is
         busy. Default is false.

  \qmlproperty string actionMenuTitle
  \qmlcm holds the title of the actionMenu

  \qmlproperty bool showSearch
  qmlcm extends the searchbar if set to true, hides it on false. Default is false.

  \qmlproperty bool disableSearch
  qmlcm disables the searchbar on true, enables it on false. Default is false.

  \qmlproperty bool allowActionMenuSignal: true
  qmlcm allows the page to receive actionMenuTriggered() signals

  \qmlproperty bool fastPageSwitch: false
  qmlcm on false, the page switch in the window waits until the animation has finished until a new page can be added.
  On true, you can add as many pages as you want and the window will show the latest.

  \section2 Signals

  \qmlproperty [signal] actionMenuTriggered
  \qmlcm is emitted when the an action menu entry was selected
  and returns the corrsponding item from the payload.

  \qmlproperty [signal] actionMenuIconClicked
  \qmlcm provides the context menu position for own action menus.

  \qmlproperty [signal] activating
  \qmlcm Signal that fires when the page is about to be shown.

  \qmlproperty [signal] activated
  \qmlcm Signal that fires when the page has been shown.

  \qmlproperty [signal] deactivating
  \qmlcm Signal that fires when the page is being hidden.

  \qmlproperty [signal] deactivated
  \qmlcm Signal that fires when the page has been hidden.

  \qmlproperty [signal] focusChanged
  \qmlcm Signal that fires if the focus was changed.
        \param bool appPageHasFocus
        \qmlpcm true if the page has focus. \endparam

  \qmlproperty [signal] searchExtended
  \qmlcm Signal that fires when the searchbar is extending.

  \qmlproperty [signal] searchRetracted
  \qmlcm Signal that fires when the searchbar retracted.

  \qmlproperty [signal] search
  \qmlcm is sent when a string was typed into the searchbar
        \param string needle
        \qmlpcm The text that was typed into the searchbar. This signal is sent for every key pressed. \endparam

  \section2 Functions
  \qmlfn addPage
  \qmlcm adds a page to the page stack and sets it as the current page. This
  function is defined in Window.qml.
           \param  AppPage pageComponent
           \qmlpcm page which sould be added \endparam

  \section2 Example
  \qml

    AppPage {
       id: singlePage

       pageTitle: "My first page"

       actionMenuModel: [ "First choice", "Second choice" ]
       actionMenuPayload: [ 1, 2 ]

       onActionMenuTriggered: {
           // an action menu entry was clicked, action menu hidden
           // and '1' or '2' returned in selectedItem
       }
    }
  \endqml   
 */

import Qt 4.7
import MeeGo.Ux.Components.Common 0.1

Item {
    id: appPage

    width:  parent ? parent.width : 0
    height: parent ? parent.height : 0

    visible: false
    
    property string pageTitle: ""
    property variant actionMenuModel: []
    property variant actionMenuPayload: []
    property string actionMenuTitle: ""
    property string name: ""
    property bool actionMenuHighlightSelection: false
    property int actionMenuSelectedIndex: -1
    property bool actionMenuOpen: false
    property bool fullScreen: false
    property bool fullContent: false
    property bool pageUsingFullScreen: false
    property bool backButtonLocked: false
    property bool enableCustomActionMenu: false
    property bool allowActionMenuSignal: false
    property bool showSearch: false
    property bool disableSearch: false
    property bool fastPageSwitch: false
    property bool pageActive: false

    property string lockOrientationIn: "" // DEPRECATED

    signal actionMenuTriggered( variant selectedItem )
    signal actionMenuIconClicked( int mouseX, int mouseY )
    signal activating // emitted by PageStack.qml
    signal activated // emitted by PageStack.qml
    signal deactivating // emitted by PageStack.qml
    signal deactivated // emitted by PageStack.qml    
    signal focusChanged(bool appPageHasFocus)

    signal searchExtended()
    signal searchRetracted()
    signal search( string needle )

    signal newPageTitle( string pageTitle )
    signal newFastPageSwitch( bool fastPageSwitch )
    signal newFullScreen( bool fullScreen )
    signal newFullContent( bool fullContent )
    signal newActionMenuOpen( bool actionMenuOpen )
    signal newActionMenuSelectedIndex( int actionMenuSelectedIndex )
    signal newActionMenuModel( variant actionMenuModel )
    signal newActionMenuPayload( variant actionMenuPayload )
    signal newActionMenuTitle( string actionMenuTitle )
    signal newBackButtonLocked( bool backButtonLocked )

    anchors.fill:  parent
    anchors.topMargin: pageUsingFullScreen? 0 : top.windowBarsHeight

    TopItem{ id: top }

    onActivating: { // from PageStack.qml
        newFullScreen( fullScreen )
        newFullContent( fullContent )
        newPageTitle( pageTitle )

        window.actionMenuHighlightSelection = actionMenuHighlightSelection

        newActionMenuSelectedIndex( actionMenuSelectedIndex )
        newBackButtonLocked( backButtonLocked )

        window.lockOrientationIn = lockOrientationIn
        window.showToolBarSearch = showSearch
        window.disableToolBarSearch = disableSearch
    }
    
    onActivated: { // from PageStack.qml
        window.customActionMenu = enableCustomActionMenu

        newActionMenuModel( actionMenuModel )
        newActionMenuPayload( actionMenuPayload )
        newActionMenuTitle( actionMenuTitle)
        pageActive = true
    }

    onDeactivating: {
        actionMenuSelectedIndex = -1
        pageActive = false // from PageStack.qml
    }
    onPageTitleChanged: newPageTitle( pageTitle )

    onFastPageSwitchChanged: newFastPageSwitchChanged( fastPageSwitch )

    onFullScreenChanged: newFullScreen( fullScreen )

    onFullContentChanged: newFullContent( fullContent )

    onActionMenuOpenChanged: newActionMenuOpen( actionMenuOpen )

    onActionMenuSelectedIndexChanged: newActionMenuSelectedIndex( actionMenuSelectedIndex )

    onActionMenuModelChanged: newActionMenuModel( actionMenuModel )

    onActionMenuPayloadChanged: newActionMenuPayload( actionMenuPayload )

    onActionMenuTitleChanged: newActionMenuTitle( actionMenuTitle)

    onBackButtonLockedChanged: newBackButtonLocked( backButtonLocked )

    Component.onCompleted: newPageTitle( pageTitle )

    Connections{
        target: window

        onSearch: if( pageActive ) appPage.search( needle )
        onSearchExtended: if( pageActive ) appPage.searchExtended()
        onSearchRetracted: if( pageActive ) appPage.searchRetracted()
    }
}
