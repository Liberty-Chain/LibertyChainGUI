// Copyright (c) 2021, The Liberty Project
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

import "." as LibertyComponents

LibertyComponents.Dialog {
    id: root
    title: (editMode ? qsTr("Edit remote node") : qsTr("Add remote node")) + translationManager.emptyString

    property var callbackOnSuccess: null
    property bool editMode: false
    property bool success: false

    onActiveFocusChanged: activeFocus && remoteNodeAddress.forceActiveFocus()

    function add(callbackOnSuccess) {
        root.editMode = false;
        root.callbackOnSuccess = callbackOnSuccess;

        open();
    }

    function edit(remoteNode, callbackOnSuccess) {
        const hostPort = remoteNode.address.match(/^(.*?)(?:\:?(\d*))$/);
        if (hostPort) {
            remoteNodeAddress.daemonAddrText = hostPort[1];
            remoteNodeAddress.daemonPortText = hostPort[2];
        }
        daemonUsername.text = remoteNode.username;
        daemonPassword.text = remoteNode.password;
        setTrustedDaemonCheckBox.checked = remoteNode.trusted;
        root.callbackOnSuccess = callbackOnSuccess;
        root.editMode = true;

        open();
    }

    onClosed: {
        if (root.success && callbackOnSuccess) {
            callbackOnSuccess({
                address: remoteNodeAddress.getAddress(),
                username: daemonUsername.text,
                password: daemonPassword.text,
                trusted: setTrustedDaemonCheckBox.checked,
            });
        }

        remoteNodeAddress.daemonAddrText = "";
        remoteNodeAddress.daemonPortText = "";
        daemonUsername.text = "";
        daemonPassword.text = "";
        setTrustedDaemonCheckBox.checked = false;
        root.success = false;
    }

    LibertyComponents.RemoteNodeEdit {
        id: remoteNodeAddress
        Layout.fillWidth: true
        placeholderFontSize: 15

        daemonAddrLabelText: qsTr("Address") + translationManager.emptyString
        daemonPortLabelText: qsTr("Port") + translationManager.emptyString
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 32

        LibertyComponents.LineEdit {
            id: daemonUsername
            Layout.fillWidth: true
            Layout.minimumWidth: 220
            labelText: qsTr("Daemon username") + translationManager.emptyString
            placeholderText: qsTr("(optional)") + translationManager.emptyString
            placeholderFontSize: 15
            labelFontSize: 14
            fontSize: 15
        }

        LibertyComponents.LineEdit {
            id: daemonPassword
            Layout.fillWidth: true
            Layout.minimumWidth: 220
            labelText: qsTr("Daemon password") + translationManager.emptyString
            placeholderText: qsTr("Password") + translationManager.emptyString
            password: true
            placeholderFontSize: 15
            labelFontSize: 14
            fontSize: 15
        }
    }

    LibertyComponents.CheckBox {
        id: setTrustedDaemonCheckBox
        activeFocusOnTab: true
        text: qsTr("Mark as Trusted Daemon") + translationManager.emptyString
    }

    RowLayout {
        Layout.alignment: Qt.AlignRight
        spacing: parent.spacing

        LibertyComponents.StandardButton {
            activeFocusOnTab: true
            fontBold: false
            primary: false
            text: qsTr("Cancel")  + translationManager.emptyString

            onClicked: root.close()
        }

        LibertyComponents.StandardButton {
            activeFocusOnTab: true
            fontBold: false
            enabled: remoteNodeAddress.getAddress() != ""
            text: qsTr("Ok") + translationManager.emptyString

            onClicked: {
                root.success = true;
                root.close();
            }
        }
    }
}
