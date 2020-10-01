/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass Theme
   \title Theme
   \section1 Theme
   The Theme contains all theme defined values. For example font sizes and colors. You can access them by creating a Theme object
   in your qml and get the desired value via <objectname>.<value>. It's recommended to create the Theme object in the highest possible
   parent to  give all children access.

  \section2 Example
  \qml
    Text {
      id: textItem

      Theme { id: theme }

      font.pixelSize: theme.fontPixelSizeLargest
    }
  \endqml
*/

import Qt 4.7

Item {
    // This qml holds theme variables for the entire components.
    // Instantiate it in the top most parent of your widgets to gain access to the values

    /* font family */
    property string fontFamily: (typeof theme_fontFamily == "undefined") ? "Droid Sans" : theme_fontFamily

    /* Headers, Places */
    property int fontPixelSizeLarge: (typeof theme_fontPixelSizeLarge == "undefined") ? 21 : theme_fontPixelSizeLarge

    /* Standard Text, Menus
       this was formerly 14, changing to follow new specs*/
    property int fontPixelSizeNormal: (typeof theme_fontPixelSizeNormal == "undefined") ? 18 : theme_fontPixelSizeNormal

    /* Dimmed Text, Lists
       this was formerly 10, changing to follow new specs*/
    property int fontPixelSizeSmall: (typeof theme_fontPixelSizeSmall == "undefined") ? 15 : theme_fontPixelSizeSmall

    /* Calendars, Disclaimer Text
       this was formerly 6, changing to follow new specs*/
    property int fontPixelSizeTiny: (typeof theme_fontPixelSizeTiny == "undefined") ? 13 : theme_fontPixelSizeTiny

    /* THIS STUFF IS DEPCRECATED. Please merge in the 'font-sizes' branch found in your app's repo soon. */
    property int fontPixelSizeLargest3: (typeof theme_fontPixelSizeLargest3 == "undefined") ? 40 : theme_fontPixelSizeLargest3
    property int fontPixelSizeLargest2: (typeof theme_fontPixelSizeLargest2 == "undefined") ? 35 : theme_fontPixelSizeLargest2
    property int fontPixelSizeLargest: (typeof theme_fontPixelSizeLargest == "undefined") ? 26 : theme_fontPixelSizeLargest
    property int fontPixelSizeLarger: (typeof theme_fontPixelSizeLarger == "undefined") ? 22 : theme_fontPixelSizeLarger
    property int fontPixelSizeMediumLarge: (typeof theme_fontPixelSizeMediumLarge == "undefined") ? 17 : theme_fontPixelSizeMediumLarge
    property int fontPixelSizeMedium: (typeof theme_fontPixelSizeMedium == "undefined") ? 14 : theme_fontPixelSizeMedium
    property int fontPixelSizeSmaller: (typeof theme_fontPixelSizeSmaller == "undefined") ? 8 : theme_fontPixelSizeSmaller
    property int fontPixelSizeSmallest: (typeof theme_fontPixelSizeSmallest == "undefined") ? 6 : theme_fontPixelSizeSmallest
    /* END DEPCRECATED BLOCK */

    /* generic font colors */
    property string fontColorNormal: (typeof theme_fontColorNormal == "undefined") ? "#4e4e4e" : theme_fontColorNormal
    property string fontColorHighlight: (typeof theme_fontColorHighlight == "undefined") ? "white" : theme_fontColorHighlight
    property string fontColorHighlightBlue: (typeof theme_fontColorHighlightBlue == "undefined") ? "#2fa7d4" : theme_fontColorHighlightBlue
    property string fontColorInactive: (typeof theme_fontColorInactive == "undefined") ? "grey" : theme_fontColorInactive
    property string fontColorMediaHighlight: (typeof theme_fontColorMediaHighlight == "undefined") ? "white" : theme_fontColorMediaHighlight
    property string fontBackgroundColor: (typeof theme_fontBackgroundColor == "undefined") ? "#fba2ff" : theme_fontBackgroundColor
    // generic font colors from intel theme.ini
    property string fontColorSelected: (typeof theme_fontColorSelected == "undefined") ? "#ffffff" : theme_fontColorSelected

    /* modal dialog properties */
    property string dialogFogColor: (typeof theme_dialogFogColor == "undefined") ? "#000000" : theme_dialogFogColor
    property real dialogFogOpacity: (typeof theme_dialogFogOpacity == "undefined") ? 0.6 : theme_dialogFogOpacity
    property string dialogTitleFontColor: (typeof theme_dialogTitleFontColor == "undefined") ? "#383838" : theme_dialogTitleFontColor
    property int dialogTitleFontPixelSize: (typeof theme_dialogTitleFontPixelSize == "undefined") ? 18 : theme_dialogTitleFontPixelSize
    property int dialogAnimationDuration: (typeof theme_dialogAnimationDuration == "undefined") ? 300 : theme_dialogAnimationDuration
    property string dialogBackgroundColor: (typeof theme_dialogBackgroundColor == "undefined") ? "white" : theme_dialogBackgroundColor
    property int dialogLeftMarginPixelSize: (typeof theme_dialogLeftMarginPixelSize == "undefined") ? 20 : theme_dialogLeftMarginPixelSize
    property int dialogRightMarginPixelSize: (typeof theme_dialogRightMarginPixelSize == "undefined") ? 20 : theme_dialogRightMarginPixelSize
    property int dialogWidthPixelSize: (typeof theme_dialogWidthPixelSize == "undefined") ? 504 : theme_dialogWidthPixelSize
    property int dialogTitleAreaHeightPixelSize: (typeof theme_dialogTitleAreaHeightPixelSize == "undefined") ? 55 : theme_dialogTitleAreaHeightPixelSize
    property int dialogTitleBaselineFromTopPixelSize: (typeof theme_dialogTitleBaselineFromTopPixelSize == "undefined") ? 35 : theme_dialogTitleBaselineFromTopPixelSize
    property int dialogButtonsBottomMarginPixelSize: (typeof theme_dialogButtonsBottomMarginPixelSize == "undefined") ? 10 : theme_dialogButtonsBottomMarginPixelSize
    property int dialogButtonSpacingPixelSize: (typeof theme_dialogButtonSpacingPixelSize == "undefined") ? 10 : theme_dialogButtonSpacingPixelSize
    property int dialogContentAreaTopAndBottomMarginPixelSize: (typeof theme_dialogContentAreaTopAndBottomMarginPixelSize == "undefined") ? 20 : theme_dialogContentAreaTopAndBottomMarginPixelSize
    
    //deprecated
    property int dialogMargins: (typeof theme_dialogMargins == "undefined") ? 10 : theme_dialogMargins

    /* button properties */
    property string buttonFontColor: (typeof theme_buttonFontColor == "undefined") ? "white" : theme_buttonFontColor
    property string buttonFontColorActive: (typeof theme_buttonFontColorActive == "undefined") ? "#1fa0d3" : theme_buttonFontColorActive
    property string buttonFontColorInactive: (typeof theme_buttonFontColorInactive == "undefined") ? "grey" : theme_buttonFontColorInactive
    property real buttonActiveOpacity: (typeof theme_buttonActiveOpacity == "undefined") ? 1.0 : theme_buttonActiveOpacity
    property real buttonInactiveOpacity: (typeof theme_buttonInactiveOpacity == "undefined") ? 0.5 : theme_buttonInactiveOpacity
    property int buttonRowSpacingPixelSize: (typeof theme_buttonRowSpacingPixelSize == "undefined") ? 10 : theme_buttonRowSpacingPixelSize

    /* list properties ( One and Two refer to the lines of text in each list item ) */
    property int listBackgroundPixelHeightOne: (typeof theme_listBackgroundPixelHeightOne == "undefined") ? 75 : theme_listBackgroundPixelHeightOne
    property int listBackgroundPixelHeightTwo: (typeof theme_listBackgroundPixelHeightTwo == "undefined") ? 90 : theme_listBackgroundPixelHeightTwo

    /* toolbar properties */
    property int toolbarFontPixelSize: (typeof theme_toolbarFontPixelSize == "undefined") ? 21 : theme_toolbarFontPixelSize
    property string toolbarFontColor: (typeof theme_toolbarFontColor == "undefined") ? "white" : theme_toolbarFontColor

    /* thumbnail properties */
    property int thumbSize: (typeof theme_thumbSize == "undefined") ? 230 : theme_thumbSize
    property int thumbColumnCountLandscape: (typeof theme_thumbColumnCountLandscape == "undefined") ? 5 : theme_thumbColumnCountLandscape
    property int thumbColumnCountPortrait: (typeof theme_thumbColumnCountPortrait == "undefined") ? 3 : theme_thumbColumnCountPortrait

    /* search bar properties */
    property int searchbarFontPixelSize: (typeof theme_searchbarFontPixelSize == "undefined") ? 20 : theme_searchbarFontPixelSize
    property string searchbarFontColor: (typeof theme_searchbarFontColor == "undefined") ? "#383838" : theme_searchbarFontColor

    /* context menu properties */
    property string contextMenuBackgroundColor: (typeof theme_contextMenuBackgroundColor == "undefined") ? "white" : theme_contextMenuBackgroundColor
    property string contextMenuFontColor: (typeof theme_contextMenuFontColor == "undefined") ? "#666666" : theme_contextMenuFontColor
    property int contextMenuFontPixelSize: (typeof theme_contextMenuFontPixelSize == "undefined") ? 20 : theme_contextMenuFontPixelSize

    /* application menu properties */
    property string appMenuBackgroundColor: (typeof theme_appMenuBackgroundColor == "undefined") ? "white" : theme_appMenuBackgroundColor
    property string appMenuFontColor: (typeof theme_appMenuFontColor == "undefined") ? "#383838" : theme_appMenuFontColor
    property int appMenuFontPixelSize: (typeof theme_appMenuFontPixelSize == "undefined") ? 35 : theme_appMenuFontPixelSize

    /* window properties */
    property string backgroundColor: (typeof theme_backgroundColor == "undefined") ? "black" : theme_backgroundColor
    property string sidepanelBackgroundColor: (typeof theme_sidepanelBackgroundColor == "undefined") ? "black" : theme_sidepanelBackgroundColor
    property string highlightColor: (typeof theme_highlightColor == "undefined") ? "#def1f9" : theme_highlightColor
    property string textInputBackgroundColor: (typeof theme_textInputBackgroundColor == "undefined") ? "white" : theme_textInputBackgroundColor

    /* progress bar properties */
    property string fontColorProgress: (typeof theme_fontColorProgress == "undefined") ? "black" : theme_fontColorProgress
    property string fontColorProgressFilled: (typeof theme_fontColorProgressFilled == "undefined") ? "white" : theme_fontColorProgressFilled

    /* task switcher / homescreen icon properties */
    property int iconTextPadding: (typeof theme_iconTextPadding == "undefined") ? 5 : theme_iconTextPadding
    property int iconFontPixelSize: (typeof theme_iconFontPixelSize == "undefined") ? 18 : theme_iconFontPixelSize
    property string iconFontColor: (typeof theme_iconFontColor == "undefined") ? "white" : theme_iconFontColor
    property string iconFontBackgroundColor: (typeof theme_iconFontBackgroundColor == "undefined") ? "#000000" : theme_iconFontBackgroundColor
    property real iconFontBackgroundOpacity: (typeof theme_iconFontBackgroundOpacity == "undefined") ? 0.15 : theme_iconFontBackgroundOpacity
    property string iconFontDropshadowColor: (typeof theme_iconFontDropshadowColor == "undefined") ? "#383838" : theme_iconFontDropshadowColor


    /* taskswitcher properties */
    property int taskSwitcherNumRows: (typeof theme_taskSwitcherNumRows == "undefined") ? 3 : theme_taskSwitcherNumRows
    property int taskSwitcherNumCols: (typeof theme_taskSwitcherNumCols == "undefined") ? 3 : theme_taskSwitcherNumCols
    property bool taskSwitcherShowGridIcon: (typeof theme_taskSwitcherShowGridIcon == "undefined") ? true : theme_taskSwitcherShowGridIcon
    property int taskSwitcherIconWidth: (typeof theme_taskSwitcherIconWidth == "undefined") ? 100 : theme_taskSwitcherIconWidth
    property int taskSwitcherIconHeight: (typeof theme_taskSwitcherIconHeight == "undefined") ? 100 : theme_taskSwitcherIconHeight
    property int taskSwitcherIconContainerWidth: (typeof theme_taskSwitcherIconContainerWidth == "undefined") ? 120 : theme_taskSwitcherIconContainerWidth
    property int taskSwitcherIconContainerHeight: (typeof theme_taskSwitcherIconContainerHeight == "undefined") ? 120 : theme_taskSwitcherIconContainerHeight
    property string taskSwitcherVerticalSeperatorColor: (typeof theme_taskSwitcherVerticalSeperatorColor == "undefined") ? "#3d3d3d" : theme_taskSwitcherVerticalSeperatorColor
    property int taskSwitcherVerticalSeperatorMargin: (typeof theme_taskSwitcherVerticalSeperatorMargin == "undefined") ? 20 : theme_taskSwitcherVerticalSeperatorMargin
    property int taskSwitcherVerticalSeperatorThickness: (typeof theme_taskSwitcherVerticalSeperatorThickness == "undefined") ? 1 : theme_taskSwitcherVerticalSeperatorThickness
    property string taskSwitcherHorizontalSeperatorColor: (typeof theme_taskSwitcherHorizontalSeperatorColor == "undefined") ? "#3d3d3d" : theme_taskSwitcherHorizontalSeperatorColor
    property int taskSwitcherHorizontalSeperatorMargin: (typeof theme_taskSwitcherHorizontalSeperatorMargin == "undefined") ? 0 : theme_taskSwitcherHorizontalSeperatorMargin
    property int taskSwitcherHorizontalSeperatorThickness: (typeof theme_taskSwitcherHorizontalSeperatorThickness == "undefined") ? 1 : theme_taskSwitcherHorizontalSeperatorThickness
    property int taskSwitcherDialogMargin: (typeof theme_taskSwitcherDialogMargin == "undefined") ? 20 : theme_taskSwitcherDialogMargin

    /* status bar properties */
    property string statusBarBackgroundColor: (typeof theme_statusBarBackgroundColor == "undefined") ? "#000000" : theme_statusBarBackgroundColor
    property real statusBarOpacity: (typeof theme_statusBarOpacity == "undefined") ? 1.0 : theme_statusBarOpacity
    property string statusBarFontColor: (typeof theme_statusBarFontColor == "undefined") ? "#ffffff" : theme_statusBarFontColor
    property int statusBarFontPixelSize: (typeof theme_statusBarFontPixelSize == "undefined") ? 11 : theme_statusBarFontPixelSize
    property int statusBarHeight: (typeof theme_statusBarHeight == "undefined") ? 25 : theme_statusBarHeight

    /* temporary value for controlling just the statusbar used for the
       application grid and the panels view. As soon as the normal Window
       can correctly place the statusbar on top of the application background,
       then this should be removed. */
    property real panelStatusBarOpacity: (typeof theme_panelStatusBarOpacity == "undefined") ? 0.4 : theme_panelStatusBarOpacity
    property string panelFontColor: (typeof theme_panelFontColor == "undefined") ? "white" : theme_panelFontColor

    /* add a value to control where the inner child of the panels should be placed relative to the background image */
    property int panelBodyMargin: (typeof theme_panelBodyMargin == "undefined") ? 12 : theme_panelBodyMargin

    /* notifications properties */
    property string statusBatteryPowerGoodColor: (typeof theme_statusBatteryPowerGoodColor == "undefined") ? "#57e601" : theme_statusBatteryPowerGoodColor
    property string statusBatteryPowerMediumColor: (typeof theme_statusBatteryPowerMediumColor == "undefined") ? "#e6b301" : theme_statusBatteryPowerMediumColor
    property string statusBatteryPowerLowColor: (typeof theme_statusBatteryPowerLowColor == "undefined") ? "#e60101" : theme_statusBatteryPowerLowColor

    /* lockscreen properties */
    property int lockscreenTimeFontPixelSize: (typeof theme_lockscreenTimeFontPixelSize == "undefined") ? 60 : theme_lockscreenTimeFontPixelSize
    property string lockscreenTimeFontColor: (typeof theme_lockscreenTimeFontColor == "undefined") ? "white" : theme_lockscreenTimeFontColor
    property string lockscreenTimeFontDropshadowColor: (typeof theme_lockscreenTimeFontDropshadowColor == "undefined") ? "#383838" : theme_lockscreenTimeFontDropshadowColor
    property int lockscreenDateFontPixelSize: (typeof theme_lockscreenDateFontPixelSize == "undefined") ? 21 : theme_lockscreenDateFontPixelSize
    property string lockscreenDateFontColor: (typeof theme_lockscreenDateFontColor == "undefined") ? "white" : theme_lockscreenDateFontColor
    property string lockscreenDateFontDropshadowColor: (typeof theme_lockscreenDateFontDropshadowColor == "undefined") ? "#383838" : theme_lockscreenDateFontDropshadowColor
    property string lockscreenShapeTimeColor: (typeof theme_lockscreenShapeTimeColor == "undefined") ? "#111212" : theme_lockscreenShapeTimeColor
    property real lockscreenShapeTimeOpacity: (typeof theme_lockscreenShapeTimeOpacity == "undefined") ? 0.1 : theme_lockscreenShapeTimeOpacity
    property string lockscreenShapeMusicColor: (typeof theme_lockscreenShapeMusicColor == "undefined") ? "#daele5" : theme_lockscreenShapeMusicColor
    property real lockscreenShapeMusicAlbumOpacity: (typeof theme_lockscreenShapeMusicAlbumOpacity == "undefined") ? 0.5 : theme_lockscreenShapeMusicAlbumOpacity
    property real lockscreenShapeMusicMetadataOpacity: (typeof theme_lockscreenShapeMusicMetadataOpacity == "undefined") ? 0.8 : theme_lockscreenShapeMusicMetadataOpacity

    /* box properties */
    property string commonBoxColor: (typeof theme_commonBoxColor == "undefined") ? "#ffffff" : theme_commonBoxColor
    property int commonBoxHeight: (typeof theme_commonBoxHeight == "undefined") ? 100 : theme_commonBoxHeight

    /* autocomplete drop list properties */
    property int suggestionItemPixelHeight: (typeof theme_suggestionItemPixelHeight == "undefined") ? 57 : theme_suggestionItemPixelHeight
    property string suggestionColor: (typeof theme_suggestionColor == "undefined") ? "4e4e4e" : theme_suggestionColor

    /* Omnibox properties */
    property string urlBarHighlightColor: (typeof theme_urlBarHighlightColor == "undefined") ? "#2CACE3" : theme_urlBarHighlightColor

    /* Media grid title background */
    property string mediaGridTitleBackgroundColor: (typeof theme_mediaGridTitleBackgroundColor == "undefined") ? "#000000" : theme_mediaGridTitleBackgroundColor
    property real mediaGridTitleBackgroundAlpha: (typeof theme_mediaGridTitleBackgroundAlpha == "undefined") ? 0.7 : theme_mediaGridTitleBackgroundAlpha

    /* General separator */
    property string separatorLightColor: (typeof theme_separatorLightColor == "undefined") ? "#FFFFFF" : theme_separatorLightColor
    property real separatorLightAlpha: (typeof theme_separatorLightAlpha == "undefined") ? 1 : theme_separatorLightAlpha
    property string separatorDarkColor: (typeof theme_separatorDarkColor == "undefined") ? "#000000" : theme_separatorDarkColor
    property real separatorDarkAlpha: (typeof theme_separatorDarkAlpha == "undefined") ? 0.15 : theme_separatorDarkAlpha

    /* Action bar divider */
    property string actionBarDividerColor: (typeof theme_actionBarDividerColor == "undefined") ? "#454646" : theme_actionBarDividerColor
    property real actionBarDividerAlpha: (typeof theme_actionBarDividerAlpha == "undefined") ? 1 : theme_actionBarDividerAlpha

    /* date picker properties */
    property string datePickerSelectedColor: (typeof theme_datePickerSelectedColor == "undefined") ? "#2fa7d4" : theme_datePickerSelectedColor
    property string datePickerUnselectedColor: (typeof theme_datePickerUnselectedColor == "undefined") ? "white" : theme_datePickerUnselectedColor
    property string datePickerUnselectableColor: (typeof theme_datePickerUnselectableColor == "undefined") ? "lightgrey" : theme_datePickerUnselectableColor
}
