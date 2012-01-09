Using the Janrain Engage for iOS PhoneGap Plugin
==========================================================================

If you haven't already, please download the PhoneGap SDK and create an iOS PhoneGap application (http://phonegap.com/start/#ios-x4)


Getting Janrain Engage for iOS
--------------------------------------------------------------------------

Clone the Janrain Engage for iOS library from GitHub:
  $ git clone git://github.com/janrain/engage.iphone.git
  
Check out the phonegap branch:
  $ git checkout phonegap
  $ git pull
  
  
Add the Library to Your Xcode Project (Xcode 4)
--------------------------------------------------------------------------

1. Open your project in Xcode.

2. Make sure the "Project Navigator" pane is showing. (View → Navigators → Show Project Navigator ⌘1)

3. In the "Project Navigator" pane of your Xcode project, right-click the root project node for your application — with the blue Xcode icon — and select the menu option New Group, to create a new group in your project tree. Rename this group "JREngage".

4. Right-click the JREngage group, and select the menu option Add Files To "[your project name]"...

5. Navigate to the location where you placed the engage.iphone, open that folder, and then open the JREngage subdirectory. Select the directories "Classes", "Resources", and "Security", and the file "JREngage-Info.plist".  Do NOT add the "JSONKit" directory, or, if you have already added JREngage to your project, remove this directory.

6. In the dialog, do NOT check the "Copy items into destination group's folder (if needed)" box*, make sure the "Create groups for any added folders" is selected, and that the "Add to targets" check box is selected for your app lication's targets. Click Add.

7. You must also add the Security framework and the MessageUI framework to your project. As the MessageUI framework is not available on all iOS devices and versions, you must designate the framework as "weak-linked". Instructions for adding frameworks in Xcode 4 can be found in Apple's iOS Developer Documentation.

* If you just created a PhoneGap application, this box may still be checked.  Be sure to uncheck it.  The JREngage folder should appear yellow.


Add the Javascript Plugin
--------------------------------------------------------------------------

To use the JREngage plugin, you must add the JREngagePlugin.js file to your www directory.

Following PhoneGap's instructions, the www directory should have been added as a "folder reference" to your Xcode project (denoted with a blue folder).  Copying the JREngagePlugin file to this directory should add it to your Xcode project.

Copy* the engage.iphone/JREngage/JREngagePlugin.js file to the www directory.

* If you copy the file, as opposed to moving it, updating the plugin will be easier in the future.  After you update, please make sure to copy the latest version of the file into the www directory.

You will also have to whitelist the domains that are called by the JREngage library.

In the file PhoneGap.plist, if it is not already present, add the ExternalHosts key to the xml dictionary, add an array as the value, and add strings to the array for each host you would like to white list.

  <key>ExternalHosts</key>
    <array>
      <string>*.rpxnow.com</string>   <!-- Engage Server -->
      <string>*.appspot.com</string>  <!-- Token URL -->
      <string>*.facebook.com</string> <!-- Provider -->
      <string>*.google.com</string>   <!-- Provider -->
      <string>*.yahoo.com</string>    <!-- Provider -->
      <string>*.myspace.com</string>  <!-- Provider -->
        ...
    </array>

You will have to add the domain for rpxnow, your token URL, and for any of the providers for which you have configured your rp.
  
  
Using the Library
--------------------------------------------------------------------------

Initialization
--------------
Load the Javascript plugin from your index.html file (or whichever html file is most appropriate):

      <script type="text/javascript" charset="utf-8" src="JREngagePlugin.js"></script>

You will want to instantiate the JREngage plugin before you need to use it, so that it can obtain your configured providers from the Engage server.  In the appropriate Javascript function, create the JREngage instance and initialize the instance with your Engage application's Application ID, your server's token URL, and callback functions:

  jrEngage = window.plugins.jrEngagePlugin;

  var appId    = "<your_app_id>";
  var tokenUrl = "<your_token_url>";

  jrEngage.initialize(
      appId,
      tokenUrl,

      function(result)
      {
        /* Function callback to handle successful initialization */
      },

      function(error)
      {
        /* Function callback to handle failed initialization */
      }
  );

The jrEngage.initialize takes four arguments, your RP's Application ID, your 
server's token URL, and success and failure callback functions.

Note: Most errors that occur during initialization will not be reported to your application until you try and sign-in or share through the library.  This is an intentional optimization primarily to reduce network traffic.  If the library does fail to initialize, and you attempt to call showAuthentication or showSharing methods, you will receive an error, and the library will then attempt to reconfigure itself.  Many errors that occured during configuration, such as network issues, will be resolved by the time the library is needed.  In these cases, the library will reinitialize itself and become available for you to use.

Sign-In
-------

To begin authentication, call the showAuthentication method on your JREngage instance:

  jrEngage.showAuthentication(
      function(result)
      {
        /* Function callback to handle successful initialization */
      },

      function(error)
      {
        /* Function callback to handle failed initialization */
      }
  );

The showAuthentication function takes two arguments, a success callback function and a failure callback function.  The callback functions should take one argument each, result and error, respectively (though you can name your arguments however you choose).

Both the result and error arguments will contain a json object that your application can parse to get the appropriate information from the JREngage plugin.

The result json object contains the following keys and values:
Key               Type        Value
stat              String      'ok'
auth_info         Dictionary  A dictionary containing the profile data of the 
                              authenticating user.  Detailed documentation of the
                              auth_info object can be found at 
                              http://documentation.janrain.com/engage/api/auth_info
provider          String      The provider on which the user authenticated.
tokenUrl          String      The token URL you provided
tokenUrlPayload   Unknown     The data returned to the library from your token URL.    
                              What this data contains depends on your implementation 
                              of your token URL.
                              
Example:
                              
{
  "stat":"ok",
  "auth_info":
  {
    "profile":
    {
      "name":
      {
        ...
      },
      "displayName":"mcspilli",
      "providerName":"Google",
      "identifier":"<users_identifier>",
      ...
    },
      "token":"<auth_info token>"
  },
  "provider":"google",
  "tokenUrl":"<provided token URL>",
  "tokenUrlPayload":"<content returned by my token url>"
}


The error json object contains the following keys and values:
Key               Type        Value
stat              String      'fail'
code              Integer     An enumerated code representing the type of error.
message           String      A human readable string describing the error.

Example:
{
  "stat":"fail",
  "message":"There was a problem communicating with the Janrain server while configuring authentication.",
  "code":"103"
}

To parse the error code based on its type, do something as follows:
    var code = errorDictionary.code;

    if (code == jrEngage.JRUrlError) {
      ...
    } else if (code == jrEngage.JRDataParsingError) {
      ...
    } else if (code == jrEngage.JRJsonError) {
      ...
    } else if (code == jrEngage.JRConfigurationInformationError) {
      ...
    } else if (code == jrEngage.JRSessionDataFinishGetProvidersError) {
      ...
    } else if (code == jrEngage.JRDialogShowingError) {
      ...
    } else if (code == jrEngage.JRProviderNotConfiguredError) {
      ...
    } else if (code == jrEngage.JRAuthenticationFailedError) {
      ...
    } else if (code == jrEngage.JRAuthenticationTokenUrlFailedError) {
      ...
    }


Sharing
-------

Note: This portion of the plugin is still being worked on, and will change in the near future.  

To begin social sharing, call the showSharing method on your JREngage instance:

  jrEngage.showSharing (
      activity,
      
      function(result)
      {
        /* Function callback to handle successful initialization */
      },

      function(error)
      {
        /* Function callback to handle failed initialization */
      }
  );

The showSharing function takes three arguments, a json encoded activity object, a success callback function, and a failure callback function.  The callback functions should take one argument each, result and error, respectively (though you can name your arguments however you choose).

The activity object should contain the following keys and values:
Key                 Type        Value
action              String      A string describing what the user did, written in the 
                                third person (e.g., "wrote a restaurant review", 
                                "posted a comment", "took a quiz").
url                 String      The URL of the resource being mentioned in the 
                                activity update.  The URL must be a well-formed URL, 
                                with a scheme and host. 
resourceTitle       String      The title of the resource being mentioned in the 
                                activity update.
resourceDescription String      A description of the resource mentioned in the
                                activity update.
actionLinks         Array       An array of JRActionLink objects, each having two 
                                attributes: text and href. An action link is a link a user
                                can use to take action on an activity update on the provider.
media               Array       An array of media objects (format TBD).
properties          Dictionary  An object with attributes describing properties of 
                                the update. An attribute value can be a string or an object 
                                with two attributes, text and href.
email               Dictionary  An object containing the subject and message body of 
                                an email, if the user wishes to share via email.
sms                 Dictionary  An object containing the message body of an sms, if 
                                the user wishes to share via sms.
 

Action Links Example:
  ...
  "action_links":
  [
    {
      "text": "Rate this quiz result",
      "href": "http://example.com/quiz/12345/result/6789/rate"
    },
    {
      "text": "Take this quiz",
      "href": "http://example.com/quiz/12345/take"
    }
  ]
  ... 

Properties Example:
  ...
  "properties":
  {
    "Time": "05:00",
    "Location":
    {
      "text": "Portland",
      "href": "http://en.wikipedia.org/wiki/Portland,_Oregon"
    }
 }
 ...


Both the result and error arguments will contain a json object that your application can parse to get the appropriate information from the JREngage plugin.

The result json object contains the following keys and values:
Key               Type        Value
stat              String      'ok'

The rest is TBD.

The error json object contains the following keys and values:
Key               Type        Value
stat              String      'fail'
code              Integer     An enumerated code representing the type of error.
message           String      A human readable string describing the error.

Example:
{
  "stat":"fail",
  "message":"There was a problem communicating with the Janrain server while configuring authentication.",
  "code":"103"
}



































