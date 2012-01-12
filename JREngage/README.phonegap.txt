Using the Janrain Engage for iOS and Android PhoneGap Plugin
==========================================================================

If you haven't already, please download the PhoneGap SDK and create a PhoneGap application 
(http://phonegap.com/start/#ios-x or http://phonegap.com/start/#android)


Getting Janrain Engage for iOS
--------------------------------------------------------------------------

Clone the Janrain Engage for iOS library from GitHub:
  $ git clone git://github.com/janrain/engage.iphone.git
  
Check out the phonegap branch:
  $ git checkout phonegap
  $ git pull


Getting Janrain Engage for Android
--------------------------------------------------------------------------

Clone the Janrain Engage for Android library from GitHub:
  $ git clone git://github.com/janrain/engage.android.git
  
Check out the phonegap branch:
  $ git checkout phonegap
  $ git pull
  
  
  
Add the Library to Your Xcode Project (Xcode 4)
--------------------------------------------------------------------------

1. Open your project in Xcode.

2. Make sure the "Project Navigator" pane is showing.
   (View → Navigators → Show Project Navigator ⌘1)

3. In the "Project Navigator" pane of your Xcode project, right-click the root project node for 
   your application — with the blue Xcode icon — and select the menu option New Group, to create
   a new group in your project tree. Rename this group "JREngage".

4. Right-click the JREngage group, and select the menu option Add Files To "[your project name]"...

5. Navigate to the location where you placed the engage.iphone, open that folder, and then open the
   JREngage subdirectory. Select the directories "Classes", "Resources", and "Security", and the 
   file "JREngage-Info.plist".  Do NOT add the "JSONKit" directory, or, if you have already added 
   JREngage to your project, remove this directory.

6. In the dialog, do NOT check the "Copy items into destination group's folder (if needed)" box*,
   make sure the "Create groups for any added folders" is selected, and that the "Add to targets" 
   check box is selected for your app location's targets. Click Add.

7. You must also add the Security framework and the MessageUI framework to your project. As the
   MessageUI framework is not available on all iOS devices and versions, you must designate the 
   framework as "weak-linked". Instructions for adding frameworks in Xcode 4 can be found in 
   Apple's iOS Developer Documentation.

* If you just created a PhoneGap application, this box may still be checked.  Be sure to uncheck it.
  The JREngage folder should appear yellow.


Add the Library to Your Eclipse Project (Eclipse Indigo)
--------------------------------------------------------------------------

1. Open your project in Eclipse.

2. Import the JREngage project into your workspace:
 2.1 File > Import... 
 2.2 Choose General > Existing Projects into Workspace
 2.3 Click Select root directory
 2.4 Click Browse
 2.5 Browse to engage.android, click Open
 2.6 Click Deselect All
 2.7 Check JREngagePhonegapPlugin
 2.8 Check JREngage
 2.9 Click Finish

3. Configure your projects build SDK to API level 13 or higher.
   Note that the build SDK is not the lowest required version of Android, and it is not the
   targeted version of Android, it is only the version of Android used to compile.

4. Add a dependency to JREngagePhonegapPlugin: 
 4.1 Open the Properties dialog for your Phonegap project
 4.2 Select the Android section from the list on the left.
 4.2.1 In the Library section of the open pane click Add
 4.2.2 Choose JREngagePhonegapPlugin
 4.2.3 Click OK
 4.2.4 In the Library section of the open pane click Add
 4.2.5 Choose JREngage
 4.2.6 Click OK
 4.3 Select the Java Build Path section from the list on the left
 4.3.1 Select the Libraries tab
 4.3.2 Select Add JARs...
 4.3.3 Choose JREngage/libs/android-support-v4.jar

5. Add the plugin declaration to res/xml/plugins.xml:
 5.1 Open res/xml/plugins.xml with a text editor
 5.2 As a child node of the <plugins> node, add the following:
       <plugin name="JREngagePlugin" value="com.janrain.android.engage.JREngagePhonegapPlugin"/> 

6. Add the JREngage activity declarations to your Phonegap project's AndroidManifest.xml:
 6.1 Open your Phonegap project's AndroidManifest.xml with a text editor
 6.2 Open JREngage/AndroidManifest.xml with a text editor
 6.3 Copy the activity declarations from the JREngage manifest into your project's manifest.
     Add them as child nodes of the <application> node.


Add the Javascript Plugin
--------------------------------------------------------------------------

To use the JREngage plugin, you must add the JREngagePlugin.js file to your www directory.

Xcode: 
    Following PhoneGap's instructions, the www directory should have been added as a "folder reference" 
    to your Xcode project (denoted with a blue folder).  Copying the JREngagePlugin file to this
    directory should add it to your Xcode project. 

    Copy* the engage.iphone/JREngage/JREngagePlugin.js file to the www directory.

Eclipse: 
    Copy engage.android/JREngagePhonegapPlugin/JREngagePlugin.js to the www directory.

* If you copy the file, as opposed to moving it, updating the plugin will be easier in the future. 
After you update, please make sure to copy the latest version of the file into the www directory.

You will also have to whitelist the domains that are called by the JREngage library.

Xcode:
    In the file PhoneGap.plist, if it is not already present, add the ExternalHosts key to the xml
    dictionary, add an array as the value, and add strings to the array for each host you would
    like to white list.

  <key>ExternalHosts</key>
    <array>
      <string>*.rpxnow.com</string>        <!-- Engage Server -->
      <string>*.yourtokenurl.com</string>  <!-- Token URL -->
      <string>*.facebook.com</string>      <!-- Provider -->
      <string>*.google.com</string>        <!-- Provider -->
      <string>*.yahoo.com</string>         <!-- Provider -->
      <string>*.myspace.com</string>       <!-- Provider -->
        ...
    </array>

You will have to add the domain for rpxnow, your token URL, and for any of the providers for 
which you have configured your rp.
  
  
Using the Library
--------------------------------------------------------------------------

Initialization
--------------
Load the Javascript plugin from your index.html file (or whichever html file is most appropriate):

      <script type="text/javascript" charset="utf-8" src="JREngagePlugin.js"></script>

You will want to initialize the JREngage plugin before you need to use it, so that it can obtain 
your configured providers from the Engage server.  In the appropriate Javascript function, create 
the JREngage instance and initialize the instance with your Engage application's Application ID, 
your server's token URL, and callback functions:

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

The jrEngage.initialize takes four arguments, your Engage Application ID, your 
server's token URL, and success and failure callback functions.

Note: Most errors that occur during initialization will not be reported to your application until
you try and sign-in or share through the library.  This is an intentional optimization primarily
to reduce network traffic.  If the library does fail to initialize, and you attempt to call
showAuthentication or showSharing methods, you will receive an error, and the library will 
then attempt to reconfigure itself.  Many errors that occured during configuration, such as 
network issues, will be resolved by the time the library is needed.  In these cases, the library 
will reinitialize itself and become available for you to use.

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

The showAuthentication function takes two arguments, a success callback function and a failure
callback function.  The callback functions should take one argument each, result and error, 
respectively (though you can name your arguments however you choose).

Both the result and error arguments will contain a JSON object that your application can parse to 
get the appropriate information from the JREngage plugin.

The result JSON object contains the following keys and values:
Key               Type        Value
stat              String      'ok'
auth_info         Object      An object containing the profile data of the 
                              authenticating user.  Detailed documentation of the
                              auth_info object can be found at 
                              http://documentation.janrain.com/engage/api/auth_info
provider          String      The provider on which the user authenticated.
tokenUrl          String      The token URL you provided
tokenUrlPayload   String      The response returned to the library from your token URL.    
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


The error JSON object contains the following keys and values:
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

To parse the error code based on its type, do as follows:
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

The showSharing function takes three arguments, a JSON encoded activity object, a success callback
function, and a failure callback function.  The callback functions should take one argument each, 
result and error, respectively (though you can name your arguments however you choose).

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
actionLinks         Array       An array of action link objects, each having two 
                                attributes: text and href. An action link is a link a user
                                can use to take action on an activity update on the provider.
media               Array       An array of media objects, of type image, flash, or mp3.
properties          Object      An object with attributes describing properties of 
                                the update. An attribute value can be a string or an object 
                                with two attributes, text and href.
email               Object      An object containing the subject and message body of 
                                an email, if the user wishes to share via email.
sms                 Object      An object containing the message body of an SMS, if 
                                the user wishes to share via SMS.
 
 
An action link object should contain the following keys and values:
Key                 Type        Value
href                String      The link URL
text                String      The string text of the URL


An image media object should contain the following keys and values:
Key                 Type        Value
src                 String      The photo's URL
href                String      The URL where a user should be taken if he or she clicks the photo


A flash media object should contain the following keys and values:
Key                 Type        Value
swfsrc              String      The URL of the Flash object to be rendered
imgsrc              String      The URL of an photo that should be displayed in place of
                                the flash object 
width               Integer     Used to override the default width     
height              Integer     Used to override the default height                                      
expanded_width      Integer     Width the video will resize to once the user clicks it                    
expanded_height     Integer     Height the video will resize to once the user clicks it                   


An mp3 media object should contain the following keys and values:
Key                 Type        Value
src                 String      The URL of the MP3 file to be rendered
title               String      The title of the song
artist              String      The artist
album               String      The album


An email object should contain the following keys and values:
Key                 Type        Value
subject             String      The desired email subject
messageBody         String      The desired message body
isHtml              String      Specify YES if the body parameter contains HTML content or specify 
                                NO if it contains plain text
urls                String      An array of URLs that will be shortened to the http://rpx.me domain 
                                so that click-through rates can be tracked


An SMS object should contain the following keys and values:
Key                 Type        Value
message             String      The desired message
urls                String      An array of URLs that will be shortened to the http://rpx.me domain 
                                so that click-through rates can be tracked


Action Links Example:
  ...
  "action_links":
  [
    {
      "text": "Rate this quiz result",
      "href": "http://example.com/quiz/12345/result/6789/rate"
    }
  ]
  ... 


Image Media Object Example:
  ...
  "media":
  [
    {
      "type":"image",
      "src":"http://www.google.com/logos/1998/googleburn.jpg",
      "href":"http://www.google.com/doodles/burning-man-festival"
    }
  ],
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
  

Email Object Example:
  ...
  "email":
  {
    "subject":"subject text",
    "messageBody":"body text",
    "isHtml":"NO",
    "urls":["http://google.com","http://janrain.com"]
  },
  ...
  

Sms Object Example:
  ...
  "sms":
  {
    "message":"",
    "urls":["http://google.com","http://janrain.com"]
  }
  ...



Both the result and error arguments will contain a JSON object that your application can parse to
get the appropriate information from the JREngage plugin.

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


































