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
 
 File:	 JREngage+CustomInterface.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Friday, January 21, 2011
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import <Foundation/Foundation.h>
#import "JREngage.h"

/**
 * @file JREngage-Info.plist
 *
 * Property list for the JREngage SDK
 * @include JREngage-Info.plist
 */

/**
 * @defgroup customInterface Custom User Interface
 * @brief Customize the user interface with your application's colors, images, native login, etc.
 *
 * @detail
 * The Engage for iPhone SDK provides the ability to customize the look and feel of the user interface, as well as
 * the ability to add your own native login experience, through the \ref customInterface "Custom Interface API".  
 * You can set many of the interface defaults in the JREngage-Info.plist file and override these defaults
 * programmatically through any of the \ref showMethods "...CustomInterface" functions.  
 *
 * The SDK accepts a dictionaries of values, indexed by a \ref customInterfaceKeys "pre-defined set of keys", 
 * and uses these to set the properties of the library's user interface.
 *
 * First, the library loads the DefaultValues dictionary from the JREngage.CustomInterface section of the 
 * JREngage-Info.plist file, and uses these values when configuring the library's user interface.
 * Then, the library loads the CustomValues dictionary from the JREngage.CustomInterface section of the 
 * JREngage-Info.plist file.  Any values specified in this section of the property list will override
 * the corresponding default value specified in the DefaultValues section.  You should only makes changes
 * to the CustomValues section.
 *
 * To configure the SDK programmatically (e.g., dynamically integrating your native login experience above or below the
 * library's social logins), create an NSDictionary object, indexed by a \ref customInterfaceKeys "pre-defined set of keys"
 * and pass this to the library through the JREngage#setCustomInterface: method.
 * Any values specified in this dictionary will override the corresponding values specified in the JREngage-Info.plist. 
 *
 * You can also launch authentication and social sharing with a custom interface dictionary through the
 * JREngage#showAuthenticationDialogWithCustomInterface: or
 * JREngage#showSocialPublishingDialogWithActivity:andCustomInterface:
 * methods.  Any values passed into the \c show...Dialog methods will override the corresponding values passed into 
 * the JREngage#setCustomInterface: method.
 *
 * @{
 **/

/** 
 * @anchor customInterfaceKeys
 * @name Navigation Bar Tint
 * @brief Keys to specify the tint color of the library's navigation bar
 **/
/*@{*/

/**
 * @deprecated
 * This function has been deprecated. If you want to set the color of the navigation bar, 
 * you can push the library's dialogs onto your own navigation controller, using the 
 * JREngage#setCustomNavigationController: method, or create a navigation bar, set the tint, 
 * and pass it to the library with the define #kJRUseCustomModalNavigationController
 **/
#define kJRNavigationBarTintColor  @"NavigationBar.TintColor"

/**
 * @deprecated
 *
 * @note This function has been deprecated. If you want to set the color of the navigation bar, 
 * you can push the library's dialogs onto your own navigation controller, using the 
 * JREngage#setCustomNavigationController: method, or create a navigation bar, set the tint, 
 * and pass it to the library with the define #kJRUseCustomModalNavigationController
 **/
#define kJRNavigationBarTintColorRGBa  @"NavigationBar.TintColor.RGBa"

/**
 * Key for your app's main UINavigationController on which to push the sign-in and sharing dialogs
 */
#define kJRUseApplicationNavigationController @"Application.NavigationController"

/**
 * Key for a UINavigationController, that you own but aren't currently using, to push the dialogs' views onto
 * when embedded in a UIPopoverController or UIModalViewController (form sheet presentation) on the iPad
 **/
#define kJRUseCustomModalNavigationController @"ModalDialog.NavigationController" 
/*@}*/

/** 
 * @name Background Colors
 * Keys to specify the background colors of the library's dialogs
 **/
/*@{*/

/**
 * Key for a \c UIColor object to set as the background color of the Providers Table and the User Landing screen.
 **/
#define kJRAuthenticationBackgroundColor  @"Authentication.Background.Color"

/**
 * Key for a \c UIColor object to set as the background color of the Social Sharing screen.
 **/
#define kJRSocialSharingBackgroundColor   @"SocialSharing.Background.Color"

/**
 * @deprecated This value will not be used. define #kJRAuthenticationBackgroundColor will be used instead.
 **/
#define kJRAuthenticationBackgroundColorRGBa  @"Authentication.Background.Color.RGBa"

/**
 * @deprecated This value will not be used. define #kJRSharingBackgroundColor will be used instead.
 **/
#define kJRSocialSharingBackgroundColorRGBa   @"SocialSharing.Background.Color.RGBa"
/*@}*/

/** 
 * @name Background Images
 * Keys to specify the name of the images to be used as the background of the library's dialogs
 **/
/*@{*/

/**
 * Key for the \c NSString name of the image to be set as the background image of the Providers Table on the iPhone.
 **/
#define kJRProviderTableBackgroundImageName   @"ProviderTable.Background.Image.Name"

/**
 * Key for the \c NSString name of the image to be set as the background image of the User Landing screen on the iPhone.
 **/
#define kJRUserLandingBackgroundImageName     @"UserLanding.Background.Image.Name"

/**
 * Key for the \c NSString name of the image to be set as the background image of the Social Sharing screen on the iPhone.
 **/
#define kJRSocialSharingBackgroundImageName   @"SocialSharing.Background.Image.Name"

/**
 * @deprecated This value will not be used. define #kJRProviderTableBackgroundImageName will be used instead.
 **/
#define kJRProviderTableBackgroundImageName_iPad   @"ProviderTable.Background.Image.Name-iPad"

/**
 * @deprecated This value will not be used. define #kJRUserLandingBackgroundImageName will be used instead.
 **/
#define kJRUserLandingBackgroundImageName_iPad     @"UserLanding.Background.Image.Name-iPad"

/**
 * @deprecated This value will not be used. define #kJRSocialSharingBackgroundImageName will be used instead.
 **/
#define kJRSocialSharingBackgroundImageName_iPad   @"SocialSharing.Background.Image.Name-iPad"
/*@}*/

/** 
 * @anchor titleViews
 *
 * @name Title Views
 * Keys to specify the UIViews to be used as the title views of the library's dialogs
 **/
/*@{*/

/**
 * Key for the \c UIView object to be set as the title view of the Providers Table on the iPhone.
 *
 * @note If this value is set, it will override any string value set for define #kJRProviderTableTitleString,
 * although the define #kJRProviderTableTitleString value will be used as the text on the back button.
 **/
#define kJRProviderTableTitleView        @"ProviderTable.Title.View"

/**
 * Key for the \c UIView object to be set as the title view of the Social Sharing screen on the iPhone.
 *
 * @note If this value is set, it will override any string value set for define #kJRSocialSharingTitleString,
 * although the define #kJRSocialSharingTitleString value will be used as the text on the back button.
 **/
#define kJRSocialSharingTitleView        @"SocialSharing.Title.View"

/**
 * @deprecated This value will not be used. define #kJRProviderTableTitleView will be used instead.
 **/
#define kJRProviderTableTitleView_iPad   @"ProviderTable.Title.View-iPad"

/**
 * @deprecated This value will not be used. define #kJRSocialSharingTitleView will be used instead.
 **/
#define kJRSocialSharingTitleView_iPad   @"SocialSharing.Title.View-iPad"
/*@}*/

/** 
 * @anchor titleStrings
 *
 * @name Title Strings
 * Keys to specify the NSString titles to be used as the titles of the library's dialogs
 **/
/*@{*/

/**
 * Key for the \c NSString title to be set as the title of the Providers Table.
 * 
 * @note If a UIView* is set for define #kJRProviderTableTitleView or define #kJRProviderTableTitleView_iPad
 * are set, this string will not appear as the title on the navigation bar.  It will only be used as the text on the back button.
 **/
#define kJRProviderTableTitleString   @"ProviderTable.Title.String"

/**
 * Key for the \c NSString title to be set as the title of the Social Sharing screen.
 * 
 * @note If a UIView* is set for define #kJRSocialSharingTitleView or define #kJRSocialSharingTitleView_iPad
 * are set, this string will not appear as the title on the navigation bar.  It will only be used as the text on the back button.
 **/
#define kJRSocialSharingTitleString   @"SocialSharing.Title.String"
/*@}*/

/** 
 * @name Provider Table Header and Footer Views
 * Keys to specify the UIViews to be used as the Provider Table's header and footer views
 **/
/*@{*/

/**
 * Key for the \c UIView object to be set as the header view of the Providers Table on the iPhone.
 **/
#define kJRProviderTableHeaderView       @"ProviderTable.Table.Header.View"

/**
 * Key for the \c UIView object to be set as the footer view of the Providers Table on the iPhone.
 **/
#define kJRProviderTableFooterView       @"ProviderTable.Table.Footer.View"

/**
 * @deprecated This value will not be used. define #kJRProviderTableHeaderView will be used instead.
 **/
#define kJRProviderTableHeaderView_iPad  @"ProviderTable.Table.Header.View-iPad"

/**
 * @deprecated This value will not be used. define #kJRProviderTableFooterView will be used instead.
 **/
#define kJRProviderTableFooterView_iPad  @"ProviderTable.Table.Footer.View-iPad"
/*@}*/

/** 
 * @anchor tableSectionViews
 *
 * @name Provider Table Section Header and Footer Views
 * Keys to specify the UIViews to be used as the Provider Table's providers section header and footer views
 **/
/*@{*/

/**
 * Key for the \c UIView object to be set as the view of the providers section header in the Providers Table on the iPhone.
 * 
 * @note Setting this value overrides any string set as the define #kJRProviderTableSectionHeaderTitleString.
 **/
#define kJRProviderTableSectionHeaderView       @"ProviderTable.Section.Header.View"

/**
 * Key for the \c UIView object to be set as the view of the providers section footer in the Providers Table on the iPhone.
 * 
 * @note Setting this value overrides any string set as the define #kJRProviderTableSectionFooterTitleString.
 **/
#define kJRProviderTableSectionFooterView       @"ProviderTable.Section.Footer.View"

/**
 * @deprecated This value will not be used. define #kJRProviderTableSectionHeaderView will be used instead.
 **/
#define kJRProviderTableSectionHeaderView_iPad  @"ProviderTable.Section.Header.View-iPad"

/**
 * @deprecated This value will not be used. define #kJRProviderTableSectionFooterView will be used instead.
 **/
#define kJRProviderTableSectionFooterView_iPad  @"ProviderTable.Section.Footer.View-iPad"
/*@}*/

/** 
 * @anchor tableSectionStrings
 * 
 * @name Provider Table Section Header and Footer Strings
 * Keys to specify the UIViews to be used as the Provider Table's providers section header and footer views
 **/
/*@{*/

/**
 * Key for the \c NSString to be set as the title of the providers section header in the Providers Table.
 * 
 * @note If a UIView* is set for define #kJRProviderTableSectionHeaderView or 
 * define #kJRProviderTableSectionHeaderView_iPad  are set, this string will not be used.
 **/
#define kJRProviderTableSectionHeaderTitleString  @"ProviderTable.Section.Header.Title.String"

/**
 * Key for the \c NSString to be set as the title of the providers section footer in the Providers Table.
 * 
 * @note If a UIView* is set for define #kJRProviderTableSectionFooterView or
 * define #kJRProviderTableSectionFooterView_iPad  are set, this string will not be used.
 **/
#define kJRProviderTableSectionFooterTitleString  @"ProviderTable.Section.Footer.Title.String"
/*@}*/

/** 
 * @anchor popover
 * 
 * @name Popover Frame
 * Keys to specify the origin of the popover modal view on the iPad
 **/
/*@{*/

/**
 * Key specifying the \c NSValue of a \c CGRect representing the from of the control from 
 * which the authentication and sharing dialogs originate if 
 * using a modal popover view on the iPad.
 *
 * CGRect rect = CGRectMake(x,y,w,h);
 * NSValue *rectValue = [NSValue valueWithCGRect:rect];
 *
 * CGRect rect = [someNSValue CGRectValue];
 **/
#define kJRPopoverPresentationFrameValue @"Popover.Presentation.Frame.Value"

#define kJRPopoverPresentationBarButtonItem @"Popover.Presentation.BarButtonItem"
/**
 * [NSNumber numberWithInt:UIPopoverArrowDirectionDown],
 **/
#define kJRPopoverPresentationArrowDirection @"Popover.Presentation.ArrowDirection"
/*@}*/

/** @} */

//@class JREngage;

@interface JREngage (CustomInterface)

/** @anchor customInterface **/
/** 
 * @name Configure the User Interface
 * Methods used to customize the JREngage's user interface
 **/
/*@{*/

/**
 * If you want to push the JREngage dialogs on your own navigation controller, pass
 * the \c UINavigationController to the JREngage library before calling any of the 
 * \link showMethods show... methods\endlink.
 *
 * @param navigationController
 *   Your application's navigation controller
 *
 * @warning This function will be deprecated soon.  It does the exact same thing as 
 * the function setCustomApplicationController:.  Please use this function instead.
 **/
- (void)setCustomNavigationController:(UINavigationController*)navigationController;

/**
 * If you want to push the JREngage dialogs on your application's navigation controller, pass
 * the \c UINavigationController to the JREngage library before calling any of the 
 * \link showMethods show... methods\endlink.
 *
 * @param navigationController
 *   Your application's navigation controller
 *
 * @note this function does the exact same thing as the function setCustomNavigationController:,
 * which will be deprecated soon.  Please use this function.
 **/
- (void)setApplicationNavigationController:(UINavigationController*)navigationController;

/**
 * @anchor setCustomUI
 * Use this function if you want to customize the look and feel of the user interface or add 
 * your own native login experience, by passing an NSDictionary object indexed by the set of 
 * \link customInterface pre-defined custom interface keys\endlink.  
 *
 * @param customizations
 *   A dictionary of objects and properties, indexed by the set of 
 *   \link customInterface pre-defined custom interface keys\endlink,
 *   to be used by the library to customize the look and feel of the user 
 *   interface and/or add a native login experience
 *
 * @note Any values specified in the \c customizations dictionary will override the 
 * corresponding values specified in both the JREngage-Info.plist and the dictionary 
 * passed into the setCustomInterface:(NSDictionary*) method.
 **/
- (void)setCustomInterface:(NSDictionary*)customizations;
- (void)setCustomInterfaceDefaults:(NSDictionary*)customInterfaceDefaults;
/*@}*/
@end
