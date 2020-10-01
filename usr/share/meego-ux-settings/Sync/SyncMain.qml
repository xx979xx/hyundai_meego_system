/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1
import MeeGo.Sync 0.1

AppPage {
    id: appContainer
    //: The title of the Sync UI displayed to the user.
    pageTitle: qsTr("Sync Settings")

    AllVisibleSyncProfiles {
        syncParentPage: appContainer
        anchors.fill: parent
    }
}
