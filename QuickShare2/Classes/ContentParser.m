//
//  ContentParser.m
//  QuickShare
//
//  Created by lilli on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#import "ContentParser.h"

@implementation ContentParser
@synthesize currentElement;
@synthesize currentContent;
@synthesize theStringsBetweenElements;
@synthesize images;

- (id)init
{
	if (self = [super init]) 
	{
        allTheContent = [[NSMutableArray alloc] initWithCapacity:1];
        images = [[NSMutableArray alloc] initWithCapacity:1];
        elementStack = [[NSMutableArray alloc] initWithCapacity:20];
        theStringsBetweenElements = [[NSMutableArray alloc] initWithCapacity:20];
        
    }   
    
    return self;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
    //-------------------------------------------------------------------//
	NSLog(@"found file and started parsing");
    //-------------------------------------------------------------------//
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{    
    //-------------------------------------------------------------------//
	NSString *errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" 
                                                         message:errorString 
                                                        delegate:self 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil];
	[errorAlert show];
    //-------------------------------------------------------------------//
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI 
 qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    currentElement = elementName;

	if ([elementName isEqualToString:@"img"]) 
    {
    }
    else if ([elementName isEqualToString:@"a"]);
    {
    }
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName
{
    if (currentContent) 
    {
        [allTheContent addObject:currentContent];
        [currentContent release];
    }
    
    if ([elementName isEqualToString:@"img"]) 
    {
    }
    else if ([elementName isEqualToString:@"a"]);
    {
    }
    
    currentElement = nil;
    currentContent = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!currentContent)
        currentContent = [NSString stringWithString:string];
    else
        currentContent = [currentContent stringByAppendingString:string]; 
}
//
//- (void)parserDidEndDocument:(NSXMLParser *)parser 
//{
//}
//
//
//- (void)processContent:(NSString*)content
//{
//    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
//	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
//    
//	[parser setDelegate:self];
//    
//	[parser setShouldProcessNamespaces:NO];
//	[parser setShouldReportNamespacePrefixes:NO];
//	[parser setShouldResolveExternalEntities:NO];
//    
//    //    [xmlParsers setObject:feed forKey:parser.systemID];
//	[parser parse];    
//}


- (void)regexParse:(NSString*)theString
{
    NSError *error = NULL;
    NSRegularExpression *imgRegex = [NSRegularExpression regularExpressionWithPattern:@"<img(.|\n)*?>"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];

    if (error)
        return;    
    
    NSArray *matches = [imgRegex matchesInString:theString
                                         options:0
                                           range:NSMakeRange(0, [theString length])];

    for (NSTextCheckingResult *match in matches) 
    {
        NSRange matchRange = [match range]; 
        
        if (!NSEqualRanges(matchRange, NSMakeRange(NSNotFound, 0))) 
        {
            NSString *substringForImageTag = [theString substringWithRange:matchRange];
//            DLog("match: %@", substringForImageTag);
            
            NSRegularExpression *imgRegex = [NSRegularExpression regularExpressionWithPattern:@"src=\"(.*?)\""
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:&error];
            
            NSRange rangeOfFirstMatch = [imgRegex rangeOfFirstMatchInString:substringForImageTag 
                                                                 options:0 
                                                                   range:NSMakeRange(0, [substringForImageTag length])];

            if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) 
            {
                NSString *substringForImgSrc = [substringForImageTag substringWithRange:
                                                NSMakeRange(rangeOfFirstMatch.location+5, rangeOfFirstMatch.length-6)];
                [images addObject:substringForImgSrc];
            }
            
//            NSRange rangeOfWidthAttr = [substringForMatch rangeOfString:@""];
//            NSRange rangeOfEndQuoteW = [substringForMatch rangeOfString:@"\"" 
//                                                               options:nil 
//                                                                 range:
//                                       NSRangeMake(rangeOfWidthAttr.location+rangeOfWidthAttr.length,
//                                                   [substringForMatch length] - rangeOfWidthAttr.location+rangeOfWidthAttr.length)];
//            
//            NSString* imgWdth = [substringForMatch substringWithRange:
//                                 NSRangeMake(rangeOfWidthAttr.location,
//                                             rangeOfEndQuoteW.location - rangeOfWidthAttr.location+rangeOfWidthAttr.length)];
//            
//            
//            NSInteger width = [imgWdth integerValue];
//            
//            NSRange rangeOfHeightAttr = [substringForMatch rangeOfString:@""];
//            NSRange rangeOfEndQuoteH = [substringForMatch rangeOfString:@"\"" 
//                                                                options:nil 
//                                                                  range:
//                                        NSRangeMake(rangeOfHeightAttr.location+rangeOfHeightAttr.length,
//                                                    [substringForMatch length] - rangeOfHeightAttr.location+rangeOfHeightAttr.length)];
//
//            NSString* imgHeight = [substringForMatch substringWithRange:
//                                   NSRangeMake(rangeOfHeightAttr.location,
//                                               rangeOfEndQuoteH.location - rangeOfHeightAttr.location+rangeOfHeightAttr.length)];
//
//            NSInteger height = [imgHeight integerValue];
//            
//            double ratio = width/300;
//            
//            width = width/ratio;
//            height = height/ratio;            
        }
    }

    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(.|\n)*?>(\n)*"
                                                                           options:0
                                                                             error:&error];
    if (error)
        return;    

    NSString *modifiedString = [[regex stringByReplacingMatchesInString:theString
                                                                options:0
                                                                  range:NSMakeRange(0, [theString length])
                                                           withTemplate:@" "]
                                stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                
//    DLog("new string: %@", modifiedString);
    
    currentContent = [modifiedString retain];
}







/* This function recursively processes an html string, pulling out elements, their attibutes,
   and the data in between */
- (void)processContent:(NSString*)theString
{
    /* First, trim any whitespace */
    theString = [[theString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                            stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    
//    NSLog(@"\n\n\n");
//    DLog("Parsing the string: %@", theString);
//    DLog("Length of theString: %d", [theString length]);
    
    /* Find the next "<" */
    NSRange lt = [theString rangeOfString:@"<"];
    
    /* Find the next ">" */
    NSRange gt = [theString rangeOfString:@">"];
        
    DLog("'<' found at index %d", lt.location);
    DLog("'>' found at index %d", gt.location);
    
    /* If there aren't any remaining tags... */
    if (lt.location == NSNotFound || gt.location == NSNotFound)
    {
        DLog("< or > not found");
        
        /* If there aren't any remaining tags, but there are remaining characters, save them. */
        if ([theString length]) 
        {
            DLog("Adding the remaining string: %@", theString);
            
            [theStringsBetweenElements addObject:theString];
        }
        
        /* Then return, because we're done... */
        DLog("return");
        return;
    }

    /* First, get the string before the tag and add it to our array... */
    if (lt.location > 0)
    {
        @try
        {
            DLog("Adding the string: %@", [theString substringToIndex:lt.location]);
            
            [theStringsBetweenElements addObject:[theString substringToIndex:lt.location]];            
        }
        @catch (NSException *e)
        {
            /* There really is no reason to expect an exception, but just to be safe... */
            DLog("NSRangeException caught while trying to store the characters between the beginning of the string and the first '<'");
        }
    }
    
    /* Get the range between the angle brackets */
    NSRange lt_to_gt = {lt.location+1, gt.location-lt.location};

    /* This is the whole tag (attributes included) */
    NSString *wholeTag;
    
    @try
    {
        wholeTag = [theString substringWithRange:lt_to_gt];
    }
    @catch (NSException *e)
    {
        /* There really is no reason to expect an exception, but just to be safe... */
        DLog("NSRangeException caught while trying to pull the element from index %d to index %d of %@",
             lt_to_gt.location, lt_to_gt.location, theString);
    }
    
    /* Trim any whitespace from the start/end of the tag */
    wholeTag = [wholeTag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    DLog("The wholeTag: %@", wholeTag);
    
    @try
    {
        /* Is this a close-tag? (Since we trimmed the whitespace, the first character should be a "/") */
        if ([wholeTag characterAtIndex:0] == '/' )
        {
//            DLog("The wholeTag's characterAtIndex 0 equals '/'");
            /* If this is a close-tag, then there should be no reason that it wouldn't match the last
               element on the element stack, but we'll check anyway... */
            if ([wholeTag isEqualToString:[elementStack lastObject]])
            {
//                DLog("Removing %@ from the elementStack", [elementStack lastObject]);
                [elementStack removeLastObject];
            }
            else
            {
                DLog("ContentParser detected the CLOSE element '%@', but this did not match the last OPEN element '%@'", 
                     wholeTag, [elementStack lastObject]);
                     
            }
        }
    }
    @catch (NSException *e)
    {
        /* There really is no reason to expect an exception, but just to be safe... */
        DLog("NSRangeException caught while trying to get the character right after the '<'");        
    }

    /* Now split the element up by whitespace */
    NSMutableArray *tagPieces = [NSMutableArray arrayWithArray:
                                 [wholeTag componentsSeparatedByCharactersInSet:
                                  [NSCharacterSet whitespaceCharacterSet]]];

    NSString *lastChunk = [tagPieces lastObject];
//    DLog("The lastChunk: %@", lastChunk);
    
    /* Is this an open&close-tag? */
    /* (Either the last chunk or the last character of the last chunk would be a "/" character) */
    
    /* If the last chunk is a "/", remove it so we can process the rest of the chunks */
    if ([lastChunk isEqualToString:@"/"])
    {    
        [tagPieces removeLastObject];
    }
    /* If the last character of the last chunk is a "/", strip it from the chunk and store the new chunk in the elementPieces array */ 
    else if ([lastChunk characterAtIndex:([lastChunk length]-1)] == '/')
    {
        lastChunk = [lastChunk substringToIndex:[lastChunk length]-1];
        [tagPieces removeLastObject];
        [tagPieces addObject:lastChunk];
    }
    /* Otherwise, this must be a an OPEN element, and the first piece should be the element name. */
    else
    {
        /* It is just an OPEN element, so we'll add the the element name to our stack of open tags. */
        [elementStack addObject:[tagPieces objectAtIndex:0]];
        DLog("Adding %@ to the elementStack", [tagPieces objectAtIndex:0]);
    }
    
    /* The first chunk is the element name */
    NSString *elementName = [tagPieces objectAtIndex:0];
    
    /* If there's more than one chunk in the array, assume they're attributes, and parse them */
    /* Oh, also, only do this if it's an image, because for now, that's all we care about */
    if ([tagPieces count] > 1 && [elementName isEqualToString:@"img"])
    {
        DLog("We have an image!");
        
        NSMutableDictionary *image = [[NSMutableDictionary alloc] initWithCapacity:[tagPieces count]-1];
        NSRange subArrRange = {1, [tagPieces count]-1};
        
        /* For each chunk, except the first... */
        for (NSString *attribute in [tagPieces subarrayWithRange:subArrRange])
        {
            /* Split the chunk at the "=" character */
            NSArray *key_and_value = [attribute componentsSeparatedByString:@"="];
            
            /* Not that the remaining array should be anything other than 2 objects long */
            if ([key_and_value count] == 2)
            {
                /* Now get the key and value (and trim the quotes off of the value) */
                NSString *key = [key_and_value objectAtIndex:0];
                NSString *value = [[key_and_value objectAtIndex:1] 
                                   stringByTrimmingCharactersInSet:
                                   [NSCharacterSet characterSetWithCharactersInString:@"\""]];
                
                DLog("Image key/value: %@ %@", key, value);
                /* And add them to our image dictionary */
                [image setObject:value forKey:key];
            }
        }
        
        DLog("Done with the image");
        
        /* And then add the image to the array of images */
        [images addObject:image];
    }
       

    /* We're done.  Recurse. */

    
    /* If the ">" character was the last character, just return. */
    if ([theString length] <= gt.location+1)
    {
        /* There's nothing left to parse.  Just return. */
        return;
    }
    else
    {
        /* Recurse. */
        return [self processContent:[theString substringFromIndex:gt.location+1]];
    }    
}

- (void)dealloc
{
    [currentElement release];
    [currentContent release];
    [elementStack release];
    [allTheContent release];
    [theStringsBetweenElements release];
    [images release];
    
    [super dealloc];
}



@end
