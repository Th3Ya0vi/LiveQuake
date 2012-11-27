//
//  EMSCXmlParserDelegate.m
//  LiveQuake
//
//  Created by Massimo Chericoni on 11/27/12.
//  Copyright (c) 2012 Massimo Chericoni. All rights reserved.
//

#import "EMSCXmlParserDelegate.h"

@implementation EMSCXmlParserDelegate

+ (id)sharedEMSCXmlParserDelegate
{
    static dispatch_once_t onceQueue;
    static EMSCXmlParserDelegate *eMSCXmlParserDelegate = nil;
    
    dispatch_once(&onceQueue, ^{ eMSCXmlParserDelegate = [[self alloc] init]; });
    return eMSCXmlParserDelegate;
}

#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"didStartElement - %@", elementName);
} //parser:didStartElement:namespaceURI:qualifiedName:attributes:


//===========================================================
// This returns the string of the characters encountered thus far. You may not necessarily get the longest character run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:
//
//===========================================================
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"foundCharacters - %@", string);
} //parser:foundCharacters:

@end
