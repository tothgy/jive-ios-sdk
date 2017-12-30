//
//  JiveOpenSocialTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/26/12.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JiveOpenSocialTests.h"
#import "JiveOpenSocial.h"
#import "JiveEmbedded.h"
#import "JiveActionLink.h"

@implementation JiveOpenSocialTests

- (void)setUp {
    [super setUp];
    self.object = [JiveOpenSocial new];
}

- (JiveOpenSocial *)openSocial {
    return (JiveOpenSocial *)self.object;
}

- (void)testToJSON {
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSString *deliverTo = @"/person/1234";
    NSDictionary *JSON = [self.openSocial toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actionLink.httpVerb = @"GET";
    [embed setValue:[NSURL URLWithString:@"http://embed.com"] forKey:@"url"];
    [self.openSocial setValue:[NSArray arrayWithObject:actionLink] forKey:@"actionLinks"];
    [self.openSocial setValue:[NSArray arrayWithObject:deliverTo] forKey:@"deliverTo"];
    [self.openSocial setValue:embed forKey:@"embed"];
    
    JSON = [self.openSocial toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"deliverTo"], self.openSocial.deliverTo, @"Wrong deliverTo.");
    
    NSDictionary *embedJSON = [JSON objectForKey:@"embed"];
    
    XCTAssertTrue([[embedJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([embedJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([embedJSON objectForKey:@"url"], [embed.url absoluteString], @"Wrong value");
    
    NSArray *deliverToJSON = [(NSDictionary *)JSON objectForKey:@"deliverTo"];
    
    XCTAssertTrue([[deliverToJSON class] isSubclassOfClass:[NSArray class]], @"deliverTo array not converted");
    XCTAssertEqual([deliverToJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[[deliverToJSON objectAtIndex:0] class] isSubclassOfClass:[NSString class]], @"deliverTo object not converted");
    XCTAssertEqualObjects([deliverToJSON objectAtIndex:0], deliverTo, @"Wrong value");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"actionLinks"];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"actionLink array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[[addressJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"actionLink object not converted");
}

- (void)testToJSON_alternate {
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSString *deliverTo = @"/person/5432";
    NSDictionary *JSON = [self.openSocial toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actionLink.httpVerb = @"PUT";
    [embed setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [self.openSocial setValue:[NSArray arrayWithObject:actionLink] forKey:@"actionLinks"];
    [self.openSocial setValue:[NSArray arrayWithObject:deliverTo] forKey:@"deliverTo"];
    [self.openSocial setValue:embed forKey:@"embed"];
    
    JSON = [self.openSocial toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"deliverTo"], self.openSocial.deliverTo, @"Wrong deliverTo.");
    
    NSDictionary *embedJSON = [JSON objectForKey:@"embed"];
    
    XCTAssertTrue([[embedJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([embedJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([embedJSON objectForKey:@"url"], [embed.url absoluteString], @"Wrong value");
    
    NSArray *deliverToJSON = [(NSDictionary *)JSON objectForKey:@"deliverTo"];
    
    XCTAssertTrue([[deliverToJSON class] isSubclassOfClass:[NSArray class]], @"deliverTo array not converted");
    XCTAssertEqual([deliverToJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[[deliverToJSON objectAtIndex:0] class] isSubclassOfClass:[NSString class]], @"deliverTo object not converted");
    XCTAssertEqualObjects([deliverToJSON objectAtIndex:0], deliverTo, @"Wrong value");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"actionLinks"];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"actionLink array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[[addressJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"actionLink object not converted");
}

- (void)testToJSON_actionLinks {
    JiveActionLink *actionLink1 = [[JiveActionLink alloc] init];
    JiveActionLink *actionLink2 = [[JiveActionLink alloc] init];
    id JSON = [self.openSocial toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actionLink1.httpVerb = @"GET";
    actionLink2.httpVerb = @"PUT";
    [self.openSocial setValue:[NSArray arrayWithObject:actionLink1] forKey:@"actionLinks"];
    
    JSON = [self.openSocial toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"actionLinks"];
    id object1 = [addressJSON objectAtIndex:0];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"actionLink array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"actionLink object not converted");
    XCTAssertEqualObjects([(NSDictionary *)object1 objectForKey:@"httpVerb"], actionLink1.httpVerb, @"Wrong http verb");
    
    [self.openSocial setValue:[self.openSocial.actionLinks arrayByAddingObject:actionLink2] forKey:@"actionLinks"];
    
    JSON = [self.openSocial toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = [(NSDictionary *)JSON objectForKey:@"actionLinks"];
    object1 = [addressJSON objectAtIndex:0];
    
    id object2 = [addressJSON objectAtIndex:1];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"actionLink array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"actionLink 1 object not converted");
    XCTAssertEqualObjects([(NSDictionary *)object1 objectForKey:@"httpVerb"], actionLink1.httpVerb, @"Wrong http verb 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"actionLink 2 object not converted");
    XCTAssertEqualObjects([(NSDictionary *)object2 objectForKey:@"httpVerb"], actionLink2.httpVerb, @"Wrong http verb 2");
}

- (void)testOpenSocialParsing {
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSString *deliverTo = @"/person/1234";
    
    actionLink.httpVerb = @"GET";
    [embed setValue:[NSURL URLWithString:@"http://embed.com"] forKey:@"url"];
    [self.openSocial setValue:[NSArray arrayWithObject:actionLink] forKey:@"actionLinks"];
    [self.openSocial setValue:[NSArray arrayWithObject:deliverTo] forKey:@"deliverTo"];
    [self.openSocial setValue:embed forKey:@"embed"];
    
    id JSON = [self.openSocial toJSONDictionary];
    JiveOpenSocial *newOpenSocial = [JiveOpenSocial objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([newOpenSocial class], [JiveOpenSocial class], @"Wrong item class");
    XCTAssertEqualObjects(newOpenSocial.embed.url, self.openSocial.embed.url, @"Wrong embed");
    XCTAssertEqual([newOpenSocial.actionLinks count], [self.openSocial.actionLinks count], @"Wrong number of actionLink objects");
    if ([newOpenSocial.actionLinks count] > 0) {
        id convertedAddress = [newOpenSocial.actionLinks objectAtIndex:0];
        XCTAssertEqual([convertedAddress class], [JiveActionLink class], @"Wrong address object class");
        if ([[convertedAddress class] isSubclassOfClass:[JiveActionLink class]])
            XCTAssertEqualObjects([(JiveActionLink *)convertedAddress httpVerb], actionLink.httpVerb, @"Wrong actionLink object");
    }
    XCTAssertEqual([newOpenSocial.deliverTo count], [self.openSocial.deliverTo count], @"Wrong number of deliverTo objects");
    if ([newOpenSocial.deliverTo count] > 0) {
        XCTAssertEqualObjects((NSString *)[newOpenSocial.deliverTo objectAtIndex:0], deliverTo, @"Wrong deliverTo object");
    }
}

- (void)testOpenSocialParsingAlternate {
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSString *deliverTo = @"/person/5432";
    
    actionLink.httpVerb = @"PUT";
    [embed setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [self.openSocial setValue:[NSArray arrayWithObject:actionLink] forKey:@"actionLinks"];
    [self.openSocial setValue:[NSArray arrayWithObject:deliverTo] forKey:@"deliverTo"];
    [self.openSocial setValue:embed forKey:@"embed"];
    
    id JSON = [self.openSocial toJSONDictionary];
    JiveOpenSocial *newOpenSocial = [JiveOpenSocial objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([newOpenSocial class], [JiveOpenSocial class], @"Wrong item class");
    XCTAssertEqualObjects(newOpenSocial.embed.url, self.openSocial.embed.url, @"Wrong embed");
    XCTAssertEqual([newOpenSocial.actionLinks count], [self.openSocial.actionLinks count], @"Wrong number of actionLink objects");
    if ([newOpenSocial.actionLinks count] > 0) {
        id convertedAddress = [newOpenSocial.actionLinks objectAtIndex:0];
        XCTAssertEqual([convertedAddress class], [JiveActionLink class], @"Wrong address object class");
        if ([[convertedAddress class] isSubclassOfClass:[JiveActionLink class]])
            XCTAssertEqualObjects([(JiveActionLink *)convertedAddress httpVerb], actionLink.httpVerb, @"Wrong actionLink object");
    }
    XCTAssertEqual([newOpenSocial.deliverTo count], [self.openSocial.deliverTo count], @"Wrong number of deliverTo objects");
    if ([newOpenSocial.deliverTo count] > 0) {
        XCTAssertEqualObjects((NSString *)[newOpenSocial.deliverTo objectAtIndex:0], deliverTo, @"Wrong deliverTo object");
    }
}

@end
