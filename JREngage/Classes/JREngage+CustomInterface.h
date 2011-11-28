/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

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

 File:   JREngage+CustomInterface.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Friday, January 21, 2011
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>
#import "JREngage.h"

/**
 * @defgroup customInterface Custom User Interface
 * @brief Customize the user interface with your application's colors, images, native login, etc.
 *
 * @detail
 * The Engage for iPhone SDK provides the ability to customize the look and feel of the user
 * interface, as well as the ability to add your own native login experience, through the
 * \ref customInterface "Custom Interface API". You can set many of the custom interface defaults
 * through the JREngage#setCustomInterfaceDefaults:() method and override these defaults
 * programmatically through any of the \ref showMethods "...CustomInterfaceOverrides" functions.
 *
 * The SDK accepts a mutable dictionary of values, indexed by a
 * \ref customInterfaceKeys "pre-defined set of keys", and uses these to set the properties of the
 * library's user interface. To configure the SDK programmatically (e.g., dynamically integrating
 * your native login experience above or below the library's social logins), create an
 * \e NSMutableDictionary object, indexed by a \ref customInterfaceKeys "pre-defined set of keys"
 * and pass this to the library through the JREngage#setCustomInterfaceDefaults: method.
 *
 * You can also override these default customizations by launching the authentication and social
 * sharing with a new dictionary of the \ref customInterfaceKeys "pre-defined set of keys" and
 * values with the JREngage#showAuthenticationDialogWithCustomInterface:
 * or JREngage#showSocialPublishingDialogWithActivity:andCustomInterface: methods. Any overlapping
 * values passed into the \e show...Dialog methods will override the corresponding values passed
 * into the JREngage#setCustomInterfaceDefaults: method.
 *
 * @{
 **/

/**
 * @name Navigation Controller
 * @brief Keys to customize the behavior and presentation of the library's navigation bar
 **/
/*@{*/

/**
 * Key for your application's main \e UINavigationController object on which to push the sign-in
 * and sharing dialogs
 **/
#define kJRApplicationNavigationController @"Application.NavigationController"

/**
 * Key for a \e UINavigationController object that your application owns.
 *
 * If you want to push your own views onto the library’s navigation controller, but your application
 * does not have a navigation controller or your application is running on the iPad or if you want
 * the library’s dialogs to present themselves using the \e UIModalTransitionStyleCoverVertical
 * transition style, you can use the \e kJRCustomModalNavigationController key. This is also necessary
 * if you want to tint the navigation bar’s color.
 **/
#define kJRCustomModalNavigationController @"ModalDialog.NavigationController"

/**
 * Key for a boolean value represented by an \e NSObject to indicate if the dialog's "Cancel"
 * button should be hidden.
 *
 * If you want to hide the "Cancel" button on the Providers Table or Social Sharing screen, pass in
 * an \e NSObject containing a positive integer or the strings \c \@"YES" or \c \@"TRUE". This will
 * remove the "Cancel" button from the library's dialogs.
 *
 * @par Warning:
 * Do not cancel social sharing or authentication by popping the navigation controller back to one
 * of your views, as this could potentially leave the library in an unexpected state. If you wish
 * to cancel sign in or social sharing, please use the JREngage#cancelAuthentication or
 * JREngage#cancelPublishing methods.
 **/
#define kJRNavigationControllerHidesCancelButton @"NavigationController.HidesCancelButton"
/*@}*/

/**
 * @name Background Colors
 * Keys to specify the background color of the library's dialogs
 **/
/*@{*/

/**
 * Key for a \e UIColor object to set as the background color of the Providers Table and the
 * User Landing screen.
 **/
#define kJRAuthenticationBackgroundColor  @"Authentication.Background.Color"

/**
 * Key for a \e UIColor object to set as the background color of the Social Sharing screen.
 **/
#define kJRSocialSharingBackgroundColor   @"SocialSharing.Background.Color"
/*@}*/

/**
 * @name Background Images
 * Keys to specify image views to be used as the background of the library's dialogs
 **/
/*@{*/

/**
 * Key for the \e UIImageView containing the image to be set as the background of the
 * Providers Table and the User Landing screen.
 **/
#define kJRAuthenticationBackgroundImageView  @"Authentication.Background.Image.View"

/**
 * Key for the \e UIImageView containing the image to be set as the background of the
 * Social Sharing screen.
 **/
#define kJRSocialSharingBackgroundImageView   @"SocialSharing.Background.Image.View"
/*@}*/

/**
 * @name Title Views
 * Keys to specify UIViews to be used as the title views of the library's dialogs
 **/
/*@{*/

/**
 * Key for the \e UIView object to be set as the title view of the Providers Table.
 *
 * @note
 * If this value is set, it will override any string value set for define #kJRProviderTableTitleString,
 * although the define #kJRProviderTableTitleString value will be used as the text on the "Back" button.
 **/
#define kJRProviderTableTitleView        @"ProviderTable.Title.View"

/**
 * Key for the \e UIView object to be set as the title view of the Social Sharing screen.
 *
 * @note
 * If this value is set, it will override any string value set for define #kJRSocialSharingTitleString,
 * although the define #kJRSocialSharingTitleString value will be used as the text on the "Back" button.
 **/
#define kJRSocialSharingTitleView        @"SocialSharing.Title.View"
/*@}*/

/**
 * @name Title Strings
 * Keys to specify NSString titles to be used as the titles of the library's dialogs
 **/
/*@{*/

/**
 * Key for the \e NSString title to be set as the title of the Providers Table.
 *
 * @note
 * If a \e UIView* is set for the define #kJRProviderTableTitleView key,  this string will not
 * appear as the title on the navigation bar.  It will only be used as the text on the "Back" button.
 **/
#define kJRProviderTableTitleString   @"ProviderTable.Title.String"

/**
 * Key for the \e NSString title to be set as the title of the Social Sharing screen.
 *
 * @note
 * If a \e UIView* is set for the define #kJRSocialSharingTitleView key, this string will not
 * appear as the title on the navigation bar.  It will only be used as the text on the "Back" button.
 **/
#define kJRSocialSharingTitleString   @"SocialSharing.Title.String"
/*@}*/

/**
 * @name Provider Table Header and Footer Views
 * Keys to specify UIViews to be used as the Provider Table's header and footer views
 **/
/*@{*/

/**
 * Key for the \e UIView object to be set as the header view of the Providers Table.
 **/
#define kJRProviderTableHeaderView       @"ProviderTable.Table.Header.View"

/**
 * Key for the \e UIView object to be set as the footer view of the Providers Table.
 **/
#define kJRProviderTableFooterView       @"ProviderTable.Table.Footer.View"
/*@}*/

/**
 * @name Provider Table Section Header and Footer Views
 * Keys to specify UIViews to be used as the Provider Table's providers section header and footer views
 **/
/*@{*/

/**
 * Key for the \e UIView object to be set as the view of the providers section header in the
 * Providers Table.
 *
 * @note
 * Setting this value overrides any string set as the define #kJRProviderTableSectionHeaderTitleString.
 **/
#define kJRProviderTableSectionHeaderView       @"ProviderTable.Section.Header.View"

/**
 * Key for the \e UIView object to be set as the view of the providers section footer in the
 * Providers Table.
 *
 * @note
 * Setting this value overrides any string set as the define #kJRProviderTableSectionFooterTitleString.
 **/
#define kJRProviderTableSectionFooterView       @"ProviderTable.Section.Footer.View"
/*@}*/

/**
 * @name Provider Table Section Header and Footer Strings
 * Keys to specify NSStrings to be used as the Provider Table's providers section header and footer text
 **/
/*@{*/

/**
 * Key for the \e NSString to be set as the title of the providers section header in the Providers Table.
 *
 * @note
 * If a \e UIView* is set for the define #kJRProviderTableSectionHeaderView key, this string will not be used.
 **/
#define kJRProviderTableSectionHeaderTitleString  @"ProviderTable.Section.Header.Title.String"

/**
 * Key for the \e NSString to be set as the title of the providers section footer in the Providers Table.
 *
 * @note
 * If a \e UIView* is set for the define #kJRProviderTableSectionFooterView key, this string will not be used.
 **/
#define kJRProviderTableSectionFooterTitleString  @"ProviderTable.Section.Footer.Title.String"
/*@}*/

/**
 * @name Popover Controller
 * Keys to specify the behavior of the \e UIPopoverController used to present the dialogs on the iPad
 **/
/*@{*/

/**
 * Key specifying the \e NSValue of a \e CGRect from which the authentication and sharing dialogs
 * should originate if using a modal popover view on the iPad.
 *
 * @par Example:
 * @code
 * CGRect rect = CGRectMake(x,y,w,h);
 * NSValue *rectValue = [NSValue valueWithCGRect:rect];
 * @endcode
 **/
#define kJRPopoverPresentationFrameValue @"Popover.Presentation.Frame.Value"

/**
 * Key for the \e UIBarButtonItem object from which the authentication and sharing dialogs
 * should originate if using a modal popover view on the iPad.
 **/
#define kJRPopoverPresentationBarButtonItem @"Popover.Presentation.BarButtonItem"

/**
 * Key for an \e NSNumber object representing the \e UIPopoverArrowDirection enumeration
 * when presenting the dialog from a \e UIPopoverController.
 *
 * The default is \c UIPopoverArrowDirectionAny.
 *
 * @par Example:
 * @code
 * [NSNumber numberWithInt:UIPopoverArrowDirectionDown];
 * @endcode
 **/
#define kJRPopoverPresentationArrowDirection @"Popover.Presentation.ArrowDirection"
/*@}*/

/**
 * @name Custom Authentication
 * Keys to customize the list of providers during sign-in
 **/
/*@{*/

/**
 * Key for an \e NSArray object containing a list of /e NSString provider names that you would like to exclude from table of
 * providers when you launch the sign-in dialog
 *
 * For a list of possible strings, please see the \ref basicProviders "List of Providers"
 **/
#define kJRRemoveProvidersFromAuthentication @"ProviderTable.RemoveProviders"
/*@}*/

/**
* @name Deprecated
* These keys have been deprecated in the current version of the JREngage library
**/
/*@{*/

#ifndef DOXYGEN_SHOULD_SKIP_THIS
///**
// * @deprecated
// * If you want to set the color of the navigation bar,
// * you can push the library's dialogs onto your own navigation controller, using the
// * JREngage#setCustomNavigationController: method, or create a navigation bar, set the tint,
// * and pass it to the library with the define #kJRUseCustomModalNavigationController
// **/
//#define kJRNavigationBarTintColor  @"NavigationBar.TintColor"

///**
// * @deprecated
// * If you want to set the color of the navigation bar,
// * you can push the library's dialogs onto your own navigation controller, using the
// * JREngage#setCustomNavigationController: method, or create a navigation bar, set the tint,
// * and pass it to the library with the define #kJRUseCustomModalNavigationController
// **/
//#define kJRNavigationBarTintColorRGBa  @"NavigationBar.TintColor.RGBa"
#endif /* DOXYGEN_SHOULD_SKIP_THIS */

/**
* @deprecated This value will not be used. define #kJRAuthenticationBackgroundColor will be used instead.
**/
#define kJRAuthenticationBackgroundColorRGBa  @"Authentication.Background.Color.RGBa"

/**
* @deprecated This value will not be used. define #kJRSharingBackgroundColor will be used instead.
**/
#define kJRSocialSharingBackgroundColorRGBa   @"SocialSharing.Background.Color.RGBa"

#ifndef DOXYGEN_SHOULD_SKIP_THIS
///**
// * @deprecated Please use define #kJRAuthenticationBackgroundImageView instead.
// **/
//#define kJRProviderTableBackgroundImageName   @"ProviderTable.Background.Image.Name"

///**
// * @deprecated Please use define #kJRAuthenticationBackgroundImageView instead.
// **/
//#define kJRUserLandingBackgroundImageName     @"UserLanding.Background.Image.Name"

///**
// * @deprecated Please use define #kJRSocialSharingBackgroundImageView instead.
// **/
//#define kJRSocialSharingBackgroundImageName   @"SocialSharing.Background.Image.Name"

///**
// * @deprecated This value will not be used. define #kJRProviderTableBackgroundImageName will be used instead.
// **/
//#define kJRProviderTableBackgroundImageName_iPad   @"ProviderTable.Background.Image.Name-iPad"

///**
// * @deprecated This value will not be used. define #kJRUserLandingBackgroundImageView will be used instead.
// **/
//#define kJRUserLandingBackgroundImageName_iPad     @"UserLanding.Background.Image.Name-iPad"

///**
// * @deprecated This value will not be used. define #kJRSocialSharingBackgroundImageView will be used instead.
// **/
//#define kJRSocialSharingBackgroundImageName_iPad   @"SocialSharing.Background.Image.Name-iPad"

///**
// * @deprecated This value will not be used. define #kJRProviderTableTitleView will be used instead.
// **/
//#define kJRProviderTableTitleView_iPad   @"ProviderTable.Title.View-iPad"

///**
// * @deprecated This value will not be used. define #kJRSocialSharingTitleView will be used instead.
// **/
//#define kJRSocialSharingTitleView_iPad   @"SocialSharing.Title.View-iPad"

///**
// * @deprecated This value will not be used. define #kJRProviderTableHeaderView will be used instead.
// **/
//#define kJRProviderTableHeaderView_iPad  @"ProviderTable.Table.Header.View-iPad"

///**
// * @deprecated This value will not be used. define #kJRProviderTableFooterView will be used instead.
// **/
//#define kJRProviderTableFooterView_iPad  @"ProviderTable.Table.Footer.View-iPad"

///**
// * @deprecated This value will not be used. define #kJRProviderTableSectionHeaderView will be used instead.
// **/
//#define kJRProviderTableSectionHeaderView_iPad  @"ProviderTable.Section.Header.View-iPad"

///**
// * @deprecated This value will not be used. define #kJRProviderTableSectionFooterView will be used instead.
// **/
//#define kJRProviderTableSectionFooterView_iPad  @"ProviderTable.Section.Footer.View-iPad"
#endif /* DOXYGEN_SHOULD_SKIP_THIS */
/*@}*/

@interface JREngage (CustomInterface)

/**
 * @name Configure the User Interface
 * Methods used to customize the JREngage's user interface
 **/
/*@{*/

/**
 * Use this function if you want to customize the look and feel of the user interface or add
 * your own native login experience, by passing an \e NSMutableDictionary object indexed by the set of
 * \link customInterface pre-defined custom interface keys\endlink.
 *
 * @param customInterfaceDefaults
 *   A dictionary of objects and properties, indexed by the set of
 *   \link customInterface pre-defined custom interface keys\endlink,
 *   to be used by the library to customize the look and feel of the user
 *   interface and/or add a native login experience
 *
 * @note
 * Any values specified in the \e customizationInterfaceOverrides dictionary of the
 * showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary*) or
 * showSocialPublishingDialogWithActivity:andCustomInterfaceOverrides:()
 * methods, will override the corresponding values specified in the dictionary passed into
 * the setCustomInterfaceDefaults:() method.
 **/
- (void)setCustomInterfaceDefaults:(NSMutableDictionary*)customInterfaceDefaults;

#ifndef DOXYGEN_SHOULD_SKIP_THIS
///**
// * @deprecated Please use setCustomInterfaceDefaults() instead.
// **/
- (void)setCustomInterface:(NSDictionary*)customizations
            __attribute__ ((deprecated)) __attribute__ ((unavailable));
#endif /* DOXYGEN_SHOULD_SKIP_THIS */
/*@}*/
@end
