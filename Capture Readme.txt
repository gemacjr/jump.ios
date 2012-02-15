Janrain Capture for iOS
==============================================
==============================================

The Janrain Engage for iOS library comes with a Capture helper library, which you can use to help create, authenticate, and manage your Capture users.  As Capture instances may vary, the Janrain Capture for iOS library comes with a Perl script which takes your Capture schema and generates Objective-C code specific to your Capture users. To use this script, you will need to have Perl installed on your machine, as well as Makamaka Hannyaharamitu's json-parsing module, http://search.cpan.org/~makamaka/JSON-2.53/lib/JSON.pm.  In addition, you will need to have your Capture schema, the JSON file that describes your Capture instance's entities.

Make sure you have downloaded correctly added the Engage for iOS library to you Xcode project, first.  Directions for doing so can be found here: https://rpxnow.com/docs/iphone#get_lib.

Getting the Library
==============================================

Prerequisites
----------------------------------------------
In addition to the prerequisites of the Janrain for Engage library (https://rpxnow.com/docs/iphone#prereqs) you will also need the following:

 - A Janrain Capture application
 - Your Capture schema (further directions to be added later)
 - Perl (further directions to be added later)
 - Makamaka Hannyaharamitu's JSON-2.53 module (further directions to be added later)
     + http://search.cpan.org/~makamaka/JSON-2.53/lib/JSON.pm



Generate the Code
----------------------------------------------
Once you have downloaded the engage.iphone library from github, obtained your Capture schema, and installed the necessary Perl module, open a terminal, and change into the engage.iphone/JRCapture directory.

$ cd engage.iphone/JRCapture

Run the Perl script, CaptureSchemaParser.pl, passing in your Capture schema as an argument with the '-f' flag.

$ ./CaptureSchemaParser.pl -f <path_to_schema>/<schema_name>

Once the script has completed, there should be the directory engage.iphone/JRCapture/iOS/JRCapture, which will contain all the files necessary to use Janrain Capture from your iOS application.


Add the Library to Your Xcode Project
----------------------------------------------
Directions for adding Engage for iOS: https://rpxnow.com/docs/iphone#xcode

Xcode 4
--------------------
Open your project in Xcode.
Make sure the "Project Navigator" pane is showing. (View → Navigators → Show Project Navigator ⌘1)
In the "Project Navigator" pane of your Xcode project, right-click the root project node for your application — with the blue Xcode icon — and select the menu option New Group, to create a new group in your project tree. Rename this group "JRCapture".

Right-click the JRCapture group, and select the menu option Add Files To "[your project name]"...

Navigate to the location where you placed the engage.iphone, open that folder, and then continue down to the JRCapture/iOS/JRCapture directory. Select all the Objective-C files in this directory and click 'Choose'.

In the dialog, do NOT check the "Copy items into destination group's folder (if needed)" box, make sure the "Create groups for any added folders" is selected, and that the "Add to targets" check box is selected for your application's targets. Click Add.

Working with ARC
--------------------
The Janrain Capture for iOS library does not, itself, use automatic reference counting (ARC), but you can easily add the library to a project that does.

To use the Capture for iOS library with an ARC project, please follow the instructions below:

Add the JRCapture files to your project by following the above instructions for Xcode 4.
Go to your project settings, select your application's target(s) and click the "Build Phases" tab.
Expand the section named "Compile Sources".
Select all the files from the JRCapture library.
Hit Enter to edit all the files at once, and in the floating text-box add the -fno-objc-arc compiler flag.


Using the Janrain Engage Library with Capture
==============================================
Here is a basic overview of using the Janrain Engage for iOS library with Capture:
1. Instantiate the JRCapture library with your Capture application's Client ID, your Capture Url, and the name of your Capture entity type
2. Instantiate the JREngage library with your Engage application's Application ID, your Capture Mobile Endpoint Url, and the delegate class that implements the JREngageDelegate protocol
3. Begin authentication or sharing by calling one of the "show...Dialog" methods
4. Implement the JREngageDelegate protocol to receive notifications and profile information for your authenticating users
5. If a Capture record already exists, you will receive an access_token, with which you can access the user record
6. If a Capture record does not already exist, you will receive a create_token, with which you can create the new user record



Quick Start Guide
----------------------------------------------
To begin, sign in to Engage and configure the providers you wish to use for authentication and/or social sharing. You will also need your 20-character Application ID from the Engage Dashboard.

TODO: Fill out Capture stuff

Import the Janrain headers:

#import "JREngage.h"
#import "JRCaptureInterface.h"


Initialize
----------------------
First, initialize Capture with your Capture Client ID, Capture domain, and entity type:

NSString *captureDomain  = @"<you_capture_domain_or_nil>";
NSString *clientId       = @"<you_capture_client_id_or_nil>";
NSString *entityTypeName = @"<you_capture_entity_type_or_nil>";

...

[JRCaptureInterface setCaptureDomain:captureDomain clientId:clientId andEntityTypeName:entityTypeName];


Next, initialize an instance of the JREngage class with your Engage Application ID; your Capture mobile endpoint URL as the token URL; and the JREngageDelegate delegate.  You can use the JRCaptureInterface method captureMobileEndpointUrl to obtain your Capture mobile endpoint URL:

NSString *appId = @"<your app id>";
NSString *captureMobileEndpointUrl = [JRCaptureInterface captureMobileEndpointUrl]

...

JREngage *jrEngage = [JREngage jrEngageWithAppId:appId andTokenUrl:nil delegate:self];

Start Authentication
----------------------
In the section of code where you wish to launch the library's authentication process, send the showAuthenticationDialog message to your JREngage object:

[jrEngage showAuthenticationDialog];

To receive the user's basic profile data, as returned by Engage, implement the jrAuthenticationDidSucceedForUser:forProvider: method from the JREngageDelegate protocol:

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)engageUser
                              forProvider:(NSString*)provider
{
  self.engageUser = engageUser;
  
  NSDictionary *engageUserProfile = [engageUser objectForKey:@"profile"];
  NSString     *preferredUserName = [engageUserProfile objectForKey:@"preferredUserName"];
    
  NSLog (@"%@ signing in to %@", preferredUserName, provider);
}

The engageUser dictionary, or auth_info, contains the following information: http://documentation.janrain.com/engage/api/auth_info

The Capture library makes it very easy for your add the Engage user's information into your Capture user.  Therefore, we recommend that you save this dictionary for later.

After this point, the JREngage library will post the auth_info token to the Capture Mobile End Point URL you supplied as the token URL when you configured the JREngage library.  Once this step is complete, your application will be notifed in the jrAuthenticationDidReachTokenUrl:withResponse:andPayload:forProvider: method from the JREngageDelegate protocol.

The tokenUrlPayload will contain a json object from Capture containing either a creation_token or an access_token and a Capture user object.  You will first need to convert the tokenUrlPayload argument to an NSString and then you can parse with the JSONKit library that comes with JREngage or any other JSON library.

- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl withResponse:(NSURLResponse*)response
                              andPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider;
{
  NSString     *payload           = [[[NSString alloc] initWithData:tokenUrlPayload encoding:NSUTF8StringEncoding] autorelease];
  NSDictionary *payloadDictionary = [payload objectFromJSONString];

If a record already exists for this user, the tokenUrlPayload dictionary will contain the key "access_token".  If a record does not exist, the tokenUrlPayload dictionary will contain the key "creation_token".

...
   
  NSString     *captureAccessToken   = [payloadDictionary objectForKey:@"access_token"];
  NSString     *captureCreationToken = [payloadDictionary objectForKey:@"creation_token"];

...


Finish Authentication
----------------------

Access Token
------------

If the tokenUrlPayload dictionary contains an access_token, then this user has already been created.  

If this is the case, then the tokenUrlPayload dictionary will also contain a key, "profile"*, which is mapped to an NSDictionary representation of a Capture user.

The generated JRCaptureUser class is an Objective-C representation of a user in your Capture instance, and should map perfectly to the dictionary.  As a convenience to you, this class provides methods which serialize/deserialize a JRCaptureUser object to/from an NSDictionary. If you are interested in writing your code to work with the object and its properties, as opposed to the keys and values of an NSDictionary, you can easily do so.

To deserialize the NSDictionary under the key "profile"*, 



* This key will likely change in the future to "captureUser".













