/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 File:   main.js
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Wednesday, January 4th, 2012
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

var jrEngage;
function testJREngagePlugin()
{
    jrEngage.print
    (
        "Hello World",

        function(result)
        {
            alert("Success: " + result);
        },

        function(error)
        {
            alert("Error: " + error);
        }
    );
}

function onBodyLoad()
{
    document.addEventListener("deviceready", onDeviceReady, false);
}

function onDeviceReady()
{
    jrEngage = window.plugins.jrEngagePlugin;

//    var appId    = <your_app_id>;
//    var tokenUrl = <your_token_url>;

    if (typeof appId === 'undefined')
    {
        alert("Please add your Engage app id and token URL");
        return;
    }

    jrEngage.initialize(
        appId,
        tokenUrl,

        function(result)
        {
           console.log(result);
        },

        function(error)
        {
           console.log(error);
        }
    );
}

function moveLogo(upOrDown)
{
    var logo = document.getElementById("logo");

    if (upOrDown == "up") {
        logo.style.marginTop = "40px";
    } else { /* if (upOrDown == "down") */
        logo.style.marginTop = "100px";
    }
}

function makeSectionVisible(sectionId, visible)
{
    var section = document.getElementById(sectionId);

    if (visible) {
        section.style.display = "block";
    } else {
        section.style.display = "none";
    }
}

function removeTheChildren(sectionId) {
    var section = document.getElementById(sectionId);

    for (var i = 0; i < 3; i++) {
        var table   = section.children[i];
        var numRows = table.rows.length;

        for (var j = numRows - 1; j > 0; j--) {
            table.deleteRow(j);
        }
    }
}

function addValueToRowInTable(value, table, baseClassAttr, indentationClassAttr)
{
    var row      = document.createElement("tr");
    var cell     = document.createElement("td");
    var textNode = document.createTextNode(value);

    if (baseClassAttr) {
        row.className += baseClassAttr;
    }

    if (indentationClassAttr) {
        cell.className += indentationClassAttr;
    }

    if (baseClassAttr != "keyRow") {
        var div = document.createElement("div");
        div.className += "ellipsize";

        var nobr = document.createElement("nobr");

        nobr.appendChild(textNode);
        div.appendChild(nobr);

        cell.appendChild(div);
    } else {
        cell.appendChild(textNode);
    }

    row.appendChild(cell);
    table.appendChild(row);
}

function updateAuthTables(resultDictionary)
{
    addValueToRowInTable(resultDictionary.provider, document.getElementById("providerTable"), "singleRow", "levelOne");
    addValueToRowInTable(resultDictionary.tokenUrl, document.getElementById("tokenUrlTable"), "singleRow", "levelOne");

    var profile = resultDictionary.auth_info.profile;

    console.log(profile);

    var profileTable = document.getElementById("profileTable");

    for (var key in profile) {
        if (profile.hasOwnProperty(key)) {

            addValueToRowInTable(key, profileTable, "keyRow", "levelOne");

         /* Yeah, yeah, should be recursive, but for now the auth_info profile
            is only ever two levels deep */
            if (profile[key] && typeof profile[key] === 'object') {
                var subobject = profile[key];
                for (var subkey in subobject) {
                    if (subobject.hasOwnProperty(subkey)) {
                        addValueToRowInTable(subkey, profileTable, "keyRow", "levelTwo");
                        addValueToRowInTable(subobject[subkey], profileTable, "valueRow", "levelTwo");
                    }
                }
            } else {
                addValueToRowInTable(profile[key], profileTable, "valueRow", "levelOne");
            }
        }
    }

    moveLogo("up");
    makeSectionVisible("authTables", true);
}

function updateShareTables(resultDictionary)
{
    var signins = resultDictionary.signIns;
    var shares  = resultDictionary.shares;

    if (signins) {
        makeSectionVisible("signInsTable", true);

        for (var i = 0; i < signins.length; i++) {
            var provider = signins[i].provider;
            var profile = signins[i].auth_info.profile;
            var name;

            if (profile.displayName) name = profile.displayName;
            else if (profile.name.formatted) name = profile.name.formatted;
            else if (profile.name.givenName) name = profile.name.givenName;
            else name = profile.identifier;

            addValueToRowInTable(provider, document.getElementById("signInsTable"), "valueRow", "levelOne");
            addValueToRowInTable(name, document.getElementById("signInsTable"), "keyRow", "levelOne");
        }
    } else {
        makeSectionVisible("signInsTable", false);
    }

    var numGoodShares = 0;
    var numBadShares  = 0;

    if (shares) {
        for (i = 0; i < shares.length; i++) {
            var share = shares[i];

            if (share.stat == "ok") {
                addValueToRowInTable("Activity Shared On", document.getElementById("goodSharesTable"), "valueRow", "levelOne");
                addValueToRowInTable(share.provider, document.getElementById("goodSharesTable"), "keyRow", "levelOne");

                numGoodShares++;
            } else { /* if (share.stat == "fail") */
                addValueToRowInTable("Activity Failed On", document.getElementById("badSharesTable"), "valueRow", "levelOne");
                addValueToRowInTable(share.provider, document.getElementById("badSharesTable"), "keyRow", "levelOne");

                addValueToRowInTable("Reason", document.getElementById("badSharesTable"), "valueRow", "levelOne");
                addValueToRowInTable(share.message, document.getElementById("badSharesTable"), "keyRow", "levelOne");

                numBadShares++;
            }
        }
    }

    if (numGoodShares) makeSectionVisible("goodSharesTable", true);
    else makeSectionVisible("goodSharesTable", false);

    if (numBadShares) makeSectionVisible("badSharesTable", true);
    else makeSectionVisible("badSharesTable", false);

    moveLogo("up");
    makeSectionVisible("shareTables", true);
}

function handleAuthenticationResult(resultDictionary)
{
    // TODO: Check the stat to make sure it's ok
    // TODO: Do something with the payload
    // var stat    = resultDictionary.stat;
    // var payload = resultDictionary.payload;

    updateAuthTables(resultDictionary);
}

function handleSharingResult(resultDictionary)
{
    updateShareTables(resultDictionary);
}

function configurationError(code, message)
{
    alert("There was a problem configuring the JREngage library.\n" + message);
}

function authenticationError(code, message)
{
    alert("There was a problem authenticating.\n" + message);
}

function sharingError(code, message)
{
    alert("There was a problem sharing.\n" + message);
}

function handleAuthenticationError(errorDictionary)
{
    var code    = errorDictionary.code;
    var message = errorDictionary.message;

    if (code == jrEngage.JRUrlError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRDataParsingError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRJsonError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRConfigurationInformationError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRSessionDataFinishGetProvidersError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRDialogShowingError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRProviderNotConfiguredError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRMissingAppIdError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRGenericConfigurationError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRAuthenticationFailedError) {
        authenticationError(code, message);
    } else if (code == jrEngage.JRAuthenticationTokenUrlFailedError) {
        authenticationError(code, message);
    } else if (code == jrEngage.JRAuthenticationCanceled) {
        /* Do nothing in this case */
    } else {
        authenticationError(code, message);
    }
}

function handleSharingError(errorDictionary)
{
    var code    = errorDictionary.code;
    var message = errorDictionary.message;

    if (code == jrEngage.JRUrlError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRDataParsingError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRJsonError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRConfigurationInformationError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRSessionDataFinishGetProvidersError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRDialogShowingError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRProviderNotConfiguredError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRMissingAppIdError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRGenericConfigurationError) {
        configurationError(code, message);
    } else if (code == jrEngage.JRPublishCanceledError) {
        /* Do nothing in this case */
    } else {
        sharingError(code, message);
    }
}

function cleanTheUI()
{
    removeTheChildren("authTables");
    removeTheChildren("shareTables");
    makeSectionVisible("authTables", false);
    makeSectionVisible("shareTables", false);
    moveLogo("down");
}

function showAuthenticationDialog()
{
    console.log("first here");
    cleanTheUI();

    jrEngage.showAuthentication(
        function(result)
        {
            var resultDictionary = JSON.parse(result);

            console.log(result);

            handleAuthenticationResult(resultDictionary);
        },

        function(error)
        {
            var errorDictionary = JSON.parse(error);

            console.log(error);

            handleAuthenticationError(errorDictionary);
        }
    );
}

function showSharingDialog()
{
    cleanTheUI();

    var activity =
        '{\
            "action":"is sharing a link",\
            "url":"http://www.google.com/doodles/burning-man-festival",\
            "resourceTitle":"Google\'s first Doodle",\
            "resourceDescription":"This is Google\'s very first Doodle, the one that started them all.",\
            "actionLinks":\
            [\
                {"text":"Google","href":"http://google.com"}\
            ],\
            "media":\
            [\
                {\
                    "type":"image",\
                    "src":"http://www.google.com/logos/1998/googleburn.jpg",\
                    "href":"http://www.google.com/doodles/burning-man-festival"\
                }\
            ],\
            "email":\
            {\
                "subject":"subject text",\
                "messageBody":"body text",\
                "isHtml":"NO",\
                "urls":["http://google.com","http://janrain.com"]\
            },\
            "sms":\
            {\
                "message":"",\
                "urls":["http://google.com","http://janrain.com"]\
            }\
        }';

    jrEngage.showSharing(
        activity,
        function(result)
        {
            var resultDictionary = JSON.parse(result);

            console.log(result);

            handleSharingResult(resultDictionary);
        },

        function(error)
        {
            var errorDictionary = JSON.parse(error);

            console.log(error);

            handleSharingError(errorDictionary);
        }

    );
}
