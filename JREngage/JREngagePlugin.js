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

 File:   JREngagePlugin.js
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Wednesday, January 4th, 2012
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

var PgCdv;
JREngagePlugin.prototype.JREngagePhonegapError                =  -1;
JREngagePlugin.prototype.JRUrlError                           = 100;
JREngagePlugin.prototype.JRDataParsingError                   = 101;
JREngagePlugin.prototype.JRJsonError                          = 102;
JREngagePlugin.prototype.JRConfigurationInformationError      = 103;
JREngagePlugin.prototype.JRSessionDataFinishGetProvidersError = 104;
JREngagePlugin.prototype.JRDialogShowingError                 = 105;
JREngagePlugin.prototype.JRProviderNotConfiguredError         = 106;
JREngagePlugin.prototype.JRMissingAppIdError                  = 107;
JREngagePlugin.prototype.JRGenericConfigurationError          = 108;
JREngagePlugin.prototype.JRAuthenticationFailedError          = 200;
JREngagePlugin.prototype.JRAuthenticationTokenUrlFailedError  = 201;
JREngagePlugin.prototype.JRAuthenticationCanceled             = 202;
JREngagePlugin.prototype.JRPublishFailedError                 = 300;
JREngagePlugin.prototype.JRPublishErrorActivityNil            = 301;
JREngagePlugin.prototype.JRPublishErrorBadActivityJson        = 302;
JREngagePlugin.prototype.JRPublishCanceledError               = 303;
JREngagePlugin.prototype.JRPublishErrorBadConnection          = 304;
JREngagePlugin.prototype.JRPublishErrorMissingParameter       = 305;
JREngagePlugin.prototype.JRPublishErrorMissingApiKey          = 306;
JREngagePlugin.prototype.JRPublishErrorCharacterLimitExceeded = 307;
JREngagePlugin.prototype.JRPublishErrorFacebookGeneric        = 308;
JREngagePlugin.prototype.JRPublishErrorInvalidFacebookSession = 309;
JREngagePlugin.prototype.JRPublishErrorInvalidFacebookMedia   = 310;
JREngagePlugin.prototype.JRPublishErrorTwitterGeneric         = 311;
JREngagePlugin.prototype.JRPublishErrorDuplicateTwitter       = 312;
JREngagePlugin.prototype.JRPublishErrorLinkedInGeneric        = 313;
JREngagePlugin.prototype.JRPublishErrorMyspaceGeneric         = 314;
JREngagePlugin.prototype.JRPublishErrorYahooGeneric           = 315;
JREngagePlugin.prototype.JRPublishErrorFeedActionRequestLimit = 316;


function JREngagePlugin()
{

}

JREngagePlugin.prototype.print = function(message, success, fail)
{
    PgCdv.exec(success, fail, 'JREngagePlugin', 'print', [message]);
};

JREngagePlugin.prototype.initialize = function(appid, tokenurl, success, fail)
{
    PgCdv.exec(success, fail, 'JREngagePlugin', 'initializeJREngage', [appid, tokenurl]);
};

JREngagePlugin.prototype.showAuthentication = function(success, fail)
{
    PgCdv.exec(success, fail, 'JREngagePlugin', 'showAuthenticationDialog', []);
};

JREngagePlugin.prototype.showSharing = function(activity, success, fail)
{
    PgCdv.exec(success, fail, 'JREngagePlugin', 'showSharingDialog', [activity]);
};

JREngagePlugin.install = function()
{
    if(!window.plugins)
    {
        window.plugins = {};
    }

    window.plugins.jrEngagePlugin = new JREngagePlugin();

    return window.plugins.jrEngagePlugin;
};

if (typeof Cordova === 'undefined')
{
    PgCdv = PhoneGap;
}
else
{
    PgCdv = Cordova;
}

PgCdv.addConstructor(JREngagePlugin.install);


