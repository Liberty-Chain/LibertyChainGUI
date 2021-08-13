// The Liberty Project
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

import "../components" as LibertyComponents
import libertyComponents.Clipboard 1.0

import "../js/TxUtils.js" as TxUtils

Rectangle {
    color: "transparent"
    property alias txkeyHeight: mainLayout.height

    Clipboard { id: clipboard }

    /* main layout */
    ColumnLayout {
        id: mainLayout
        anchors.margins: 20
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        spacing: 20

        // solo
        ColumnLayout {
            id: soloBox
            spacing: 20

            LibertyComponents.Label {
                id: soloTitleLabel
                fontSize: 24
                text: qsTr("Prove Transaction") + translationManager.emptyString
            }

            LibertyComponents.TextPlain {
                Layout.fillWidth: true
                text: qsTr("Generate a proof of your incoming/outgoing payment by supplying the transaction ID, the recipient address and an optional message. \n" +
                           "For the case of outgoing payments, you can get a 'Spend Proof' that proves the authorship of a transaction. In this case, you don't need to specify the recipient address.") + translationManager.emptyString
                wrapMode: Text.Wrap
                font.family: LibertyComponents.Style.fontRegular.name
                font.pixelSize: 14
                color: LibertyComponents.Style.defaultFontColor
            }

            LibertyComponents.LineEdit {
                id: getProofTxIdLine
                Layout.fillWidth: true
                labelFontSize: 14
                labelText: qsTr("Transaction ID") + translationManager.emptyString
                fontSize: 16
                placeholderFontSize: 16
                placeholderText: qsTr("Paste tx ID") + translationManager.emptyString
                readOnly: false
                copyButton: true
            }

            LibertyComponents.LineEdit {
                id: getProofAddressLine
                Layout.fillWidth: true
                labelFontSize: 14
                labelText: qsTr("Address") + translationManager.emptyString
                fontSize: 16
                placeholderFontSize: 16
                placeholderText: qsTr("Recipient's wallet address") + translationManager.emptyString;
                readOnly: false
                copyButton: true
            }

            LibertyComponents.LineEdit {
                id: getProofMessageLine
                Layout.fillWidth: true
                fontSize: 16
                labelFontSize: 14
                labelText: qsTr("Message") + translationManager.emptyString
                placeholderFontSize: 16
                placeholderText: qsTr("Optional message against which the signature is signed") + translationManager.emptyString;
                readOnly: false
                copyButton: true
            }

            LibertyComponents.StandardButton {
                Layout.topMargin: 16
                small: true
                text: qsTr("Generate") + translationManager.emptyString
                enabled: TxUtils.checkTxID(getProofTxIdLine.text) && (getProofAddressLine.text.length == 0 || TxUtils.checkAddress(getProofAddressLine.text, appWindow.persistentSettings.nettype))
                onClicked: {
                    console.log("getProof: Generate clicked: txid " + getProofTxIdLine.text + ", address " + getProofAddressLine.text + ", message: " + getProofMessageLine.text);
                    root.getProofClicked(getProofTxIdLine.text, getProofAddressLine.text, getProofMessageLine.text)
                }
            }

            // underline
            Rectangle {
                height: 1
                color: LibertyComponents.Style.dividerColor
                opacity: LibertyComponents.Style.dividerOpacity
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                anchors.bottomMargin: 3
            }

            LibertyComponents.Label {
                id: soloTitleLabel2
                fontSize: 24
                text: qsTr("Check Transaction") + translationManager.emptyString
            }

            LibertyComponents.TextPlain {
                text: qsTr("Verify that funds were paid to an address by supplying the transaction ID, the recipient address, the message used for signing and the signature.\n" +
                           "For the case with Spend Proof, you don't need to specify the recipient address.") + translationManager.emptyString
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.family: LibertyComponents.Style.fontRegular.name
                font.pixelSize: 14
                color: LibertyComponents.Style.defaultFontColor
            }

            LibertyComponents.LineEdit {
                id: checkProofTxIdLine
                Layout.fillWidth: true
                labelFontSize: 14
                labelText: qsTr("Transaction ID") + translationManager.emptyString
                fontSize: 16
                placeholderFontSize: 16
                placeholderText: qsTr("Paste tx ID") + translationManager.emptyString
                readOnly: false
                copyButton: true
            }

            LibertyComponents.LineEdit {
                id: checkProofAddressLine
                Layout.fillWidth: true
                labelFontSize: 14
                labelText: qsTr("Address") + translationManager.emptyString
                fontSize: 16
                placeholderFontSize: 16
                placeholderText: qsTr("Recipient's wallet address") + translationManager.emptyString;
                readOnly: false
                copyButton: true
            }

            LibertyComponents.LineEdit {
                id: checkProofMessageLine
                Layout.fillWidth: true
                fontSize: 16
                labelFontSize: 14
                labelText: qsTr("Message") + translationManager.emptyString
                placeholderFontSize: 16
                placeholderText: qsTr("Optional message against which the signature is signed") + translationManager.emptyString;
                readOnly: false
                copyButton: true
            }

            LibertyComponents.LineEdit {
                id: checkProofSignatureLine
                Layout.fillWidth: true
                fontSize: 16
                labelFontSize: 14
                labelText: qsTr("Signature") + translationManager.emptyString
                placeholderFontSize: 16
                placeholderText: qsTr("Paste tx proof") + translationManager.emptyString;
                readOnly: false
                copyButton: true
            }

            LibertyComponents.StandardButton {
                Layout.topMargin: 16
                small: true
                text: qsTr("Check") + translationManager.emptyString
                enabled: TxUtils.checkTxID(checkProofTxIdLine.text) && TxUtils.checkSignature(checkProofSignatureLine.text) && ((checkProofSignatureLine.text.indexOf("SpendProofV") === 0 && checkProofAddressLine.text.length == 0) || (checkProofSignatureLine.text.indexOf("SpendProofV") !== 0 && TxUtils.checkAddress(checkProofAddressLine.text, appWindow.persistentSettings.nettype)))
                onClicked: {
                    console.log("checkProof: Check clicked: txid " + checkProofTxIdLine.text + ", address " + checkProofAddressLine.text + ", message " + checkProofMessageLine.text + ", signature " + checkProofSignatureLine.text);
                    root.checkProofClicked(checkProofTxIdLine.text, checkProofAddressLine.text, checkProofMessageLine.text, checkProofSignatureLine.text)
                }
            }

            // underline
            Rectangle {
                height: 1
                color: LibertyComponents.Style.dividerColor
                opacity: LibertyComponents.Style.dividerOpacity
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                anchors.bottomMargin: 3
            }

            LibertyComponents.TextPlain {
                text: qsTr("If a payment had several transactions then each must be checked and the results combined.") + translationManager.emptyString
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.family: LibertyComponents.Style.fontRegular.name
                font.pixelSize: 14
                color: LibertyComponents.Style.defaultFontColor
            }
        }
    }

    function onPageCompleted() {
        console.log("TxKey page loaded");

    }
}
