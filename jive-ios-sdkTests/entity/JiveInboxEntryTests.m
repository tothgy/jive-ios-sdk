//
//  JiveInboxEntryTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
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

#import "JiveInboxEntryTests.h"
#import "JiveActivityObject.h"
#import "JiveMediaLink.h"
#import "JiveExtension.h"
#import "JiveOpenSocial.h"
#import "JiveObject_internal.h"

@implementation JiveInboxEntryTests

- (void)setUp {
    [super setUp];
    self.object = [JiveInboxEntry new];
}

- (JiveInboxEntry *)inboxEntry {
    return (JiveInboxEntry *)self.object;
}

- (void)testDescription {
    
    JiveActivityObject *activity = [[JiveActivityObject alloc] init];

    [self.inboxEntry setValue:activity forKey:JiveInboxEntryAttributes.object];
    XCTAssertEqualObjects(self.inboxEntry.description, @"(null) (null) -'(null)'", @"Empty description");
    
    activity.displayName = @"object";
    XCTAssertEqualObjects(self.inboxEntry.description, @"(null) (null) -'object'", @"Just a display name");
    
    self.inboxEntry.verb = @"walking";
    XCTAssertEqualObjects(self.inboxEntry.description, @"(null) walking -'object'", @"Verb and display name");
    
    [activity setValue:[NSURL URLWithString:@"http://test.com"] forKey:@"url"];
    XCTAssertEqualObjects(self.inboxEntry.description, @"http://test.com walking -'object'", @"URL, verb and display name");
    
    activity.displayName = @"tree";
    XCTAssertEqualObjects(self.inboxEntry.description, @"http://test.com walking -'tree'", @"A different display name");
    
    self.inboxEntry.verb = @"sitting";
    XCTAssertEqualObjects(self.inboxEntry.description, @"http://test.com sitting -'tree'", @"A different verb");
    
    [activity setValue:[NSURL URLWithString:@"http://bad.net"] forKey:@"url"];
    XCTAssertEqualObjects(self.inboxEntry.description, @"http://bad.net sitting -'tree'", @"A different url");
}

- (void)initializeInboxEntry {
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    
    actor.jiveId = @"2345";
    generator.jiveId = @"3456";
    object.jiveId = @"4567";
    provider.jiveId = @"5678";
    target.jiveId = @"6789";
    [icon setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:JiveInboxEntryAttributes.url];
    jive.state = JiveExtensionStateValues.accepted;
    [jive setValue:@"12345" forKey:JiveExtensionAttributes.collection];
    [openSocial setValue:@[@"/person/54321"] forKey:@"deliverTo"];
    self.inboxEntry.content = @"text";
    self.inboxEntry.jiveId = @"1234";
    self.inboxEntry.title = @"President";
    self.inboxEntry.verb = @"Running";
    [self.inboxEntry setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveInboxEntryAttributes.published];
    [self.inboxEntry setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveInboxEntryAttributes.updated];
    [self.inboxEntry setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:JiveInboxEntryAttributes.url];
    [self.inboxEntry setValue:actor forKey:JiveInboxEntryAttributes.actor];
    [self.inboxEntry setValue:generator forKey:JiveInboxEntryAttributes.generator];
    [self.inboxEntry setValue:object forKey:JiveInboxEntryAttributes.object];
    [self.inboxEntry setValue:provider forKey:JiveInboxEntryAttributes.provider];
    [self.inboxEntry setValue:target forKey:JiveInboxEntryAttributes.target];
    [self.inboxEntry setValue:icon forKey:JiveInboxEntryAttributes.icon];
    [self.inboxEntry setValue:jive forKey:JiveInboxEntryAttributes.jive];
    [self.inboxEntry setValue:openSocial forKey:JiveInboxEntryAttributes.openSocial];
}

- (void)alternateInitializeInboxEntry {
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    
    actor.jiveId = @"9876";
    generator.jiveId = @"8765";
    object.jiveId = @"7654";
    provider.jiveId = @"6543";
    target.jiveId = @"5432";
    [icon setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:JiveInboxEntryAttributes.url];
    jive.state = JiveExtensionStateValues.rejected;
    [jive setValue:@"54321" forKey:JiveExtensionAttributes.collection];
    [openSocial setValue:@[@"/place/23456"] forKey:@"deliverTo"];
    self.inboxEntry.content = @"html";
    self.inboxEntry.jiveId = @"4321";
    self.inboxEntry.title = @"Grunt";
    self.inboxEntry.verb = @"Toil";
    [self.inboxEntry setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveInboxEntryAttributes.published];
    [self.inboxEntry setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveInboxEntryAttributes.updated];
    [self.inboxEntry setValue:[NSURL URLWithString:@"http://super.com"] forKey:JiveInboxEntryAttributes.url];
    [self.inboxEntry setValue:actor forKey:JiveInboxEntryAttributes.actor];
    [self.inboxEntry setValue:generator forKey:JiveInboxEntryAttributes.generator];
    [self.inboxEntry setValue:object forKey:JiveInboxEntryAttributes.object];
    [self.inboxEntry setValue:provider forKey:JiveInboxEntryAttributes.provider];
    [self.inboxEntry setValue:target forKey:JiveInboxEntryAttributes.target];
    [self.inboxEntry setValue:icon forKey:JiveInboxEntryAttributes.icon];
    [self.inboxEntry setValue:jive forKey:JiveInboxEntryAttributes.jive];
    [self.inboxEntry setValue:openSocial forKey:JiveInboxEntryAttributes.openSocial];
}

- (void)testPersistentJSON {
    NSDictionary *JSON = [self.inboxEntry persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeInboxEntry];
    JSON = [self.inboxEntry persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)15, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.content], self.inboxEntry.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.inboxEntry.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.title], self.inboxEntry.title, @"Wrong title.");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.verb], self.inboxEntry.verb, @"Wrong verb.");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.published], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.updated], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.url], [self.inboxEntry.url absoluteString], @"Wrong url.");
    
    NSDictionary *actorJSON = JSON[JiveInboxEntryAttributes.actor];
    
    XCTAssertTrue([[actorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([actorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(actorJSON[JiveObjectConstants.id], self.inboxEntry.actor.jiveId, @"Wrong value");
    
    NSDictionary *generatorJSON = JSON[JiveInboxEntryAttributes.generator];
    
    XCTAssertTrue([[generatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([generatorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(generatorJSON[JiveObjectConstants.id], self.inboxEntry.generator.jiveId, @"Wrong value");
    
    NSDictionary *objectJSON = JSON[JiveInboxEntryAttributes.object];
    
    XCTAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([objectJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(objectJSON[JiveObjectConstants.id], self.inboxEntry.object.jiveId, @"Wrong value");
    
    NSDictionary *providerJSON = JSON[JiveInboxEntryAttributes.provider];
    
    XCTAssertTrue([[providerJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([providerJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(providerJSON[JiveObjectConstants.id], self.inboxEntry.provider.jiveId, @"Wrong value");
    
    NSDictionary *targetJSON = JSON[JiveInboxEntryAttributes.target];
    
    XCTAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([targetJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(targetJSON[JiveObjectConstants.id], self.inboxEntry.target.jiveId, @"Wrong value");
    
    NSDictionary *iconJSON = JSON[JiveInboxEntryAttributes.icon];
    
    XCTAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(iconJSON[@"url"], [self.inboxEntry.icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = JSON[JiveInboxEntryAttributes.jive];
    
    XCTAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([jiveJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(jiveJSON[@"state"], self.inboxEntry.jive.state, @"Wrong value");
    XCTAssertEqualObjects(jiveJSON[JiveExtensionAttributes.collection],
                         self.inboxEntry.jive.collection, @"Wrong value");
    
    NSDictionary *openSocialJSON = JSON[JiveInboxEntryAttributes.openSocial];
    NSArray *deliverToArray = openSocialJSON[@"deliverTo"];
    
    XCTAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertTrue([[deliverToArray class] isSubclassOfClass:[NSArray class]], @"Sub-array not converted");
    XCTAssertEqual([deliverToArray count], (NSUInteger)1, @"Sub-array had the wrong number of entries");
    XCTAssertEqualObjects([deliverToArray objectAtIndex:0],
                         [self.inboxEntry.openSocial.deliverTo objectAtIndex:0], @"Wrong value");
}

- (void)testPersistentJSON_alternate {
    NSDictionary *JSON = [self.inboxEntry persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self alternateInitializeInboxEntry];
    JSON = [self.inboxEntry persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)15, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.content], self.inboxEntry.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.inboxEntry.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.title], self.inboxEntry.title, @"Wrong title.");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.verb], self.inboxEntry.verb, @"Wrong verb.");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.published], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.updated], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.url], [self.inboxEntry.url absoluteString], @"Wrong url.");
    
    NSDictionary *actorJSON = JSON[JiveInboxEntryAttributes.actor];
    
    XCTAssertTrue([[actorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([actorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(actorJSON[JiveObjectConstants.id], self.inboxEntry.actor.jiveId, @"Wrong value");
    
    NSDictionary *generatorJSON = JSON[JiveInboxEntryAttributes.generator];
    
    XCTAssertTrue([[generatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([generatorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(generatorJSON[JiveObjectConstants.id], self.inboxEntry.generator.jiveId, @"Wrong value");
    
    NSDictionary *objectJSON = JSON[JiveInboxEntryAttributes.object];
    
    XCTAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([objectJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(objectJSON[JiveObjectConstants.id], self.inboxEntry.object.jiveId, @"Wrong value");
    
    NSDictionary *providerJSON = JSON[JiveInboxEntryAttributes.provider];
    
    XCTAssertTrue([[providerJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([providerJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(providerJSON[JiveObjectConstants.id], self.inboxEntry.provider.jiveId, @"Wrong value");
    
    NSDictionary *targetJSON = JSON[JiveInboxEntryAttributes.target];
    
    XCTAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([targetJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(targetJSON[JiveObjectConstants.id], self.inboxEntry.target.jiveId, @"Wrong value");
    
    NSDictionary *iconJSON = JSON[JiveInboxEntryAttributes.icon];
    
    XCTAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(iconJSON[@"url"], [self.inboxEntry.icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = JSON[JiveInboxEntryAttributes.jive];
    
    XCTAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([jiveJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(jiveJSON[@"state"], self.inboxEntry.jive.state, @"Wrong value");
    XCTAssertEqualObjects(jiveJSON[JiveExtensionAttributes.collection],
                         self.inboxEntry.jive.collection, @"Wrong value");
    
    NSDictionary *openSocialJSON = JSON[JiveInboxEntryAttributes.openSocial];
    NSArray *deliverToArray = openSocialJSON[@"deliverTo"];
    
    XCTAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertTrue([[deliverToArray class] isSubclassOfClass:[NSArray class]], @"Sub-array not converted");
    XCTAssertEqual([deliverToArray count], (NSUInteger)1, @"Sub-array had the wrong number of entries");
    XCTAssertEqualObjects([deliverToArray objectAtIndex:0],
                         [self.inboxEntry.openSocial.deliverTo objectAtIndex:0], @"Wrong value");
}

- (void)testToJSON {
    NSDictionary *JSON = [self.inboxEntry toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeInboxEntry];
    JSON = [self.inboxEntry toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.content], self.inboxEntry.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.inboxEntry.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.title], self.inboxEntry.title, @"Wrong title.");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.verb], self.inboxEntry.verb, @"Wrong verb.");
}

- (void)testToJSON_alternate {
    NSDictionary *JSON = [self.inboxEntry toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self alternateInitializeInboxEntry];
    JSON = [self.inboxEntry toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.content], self.inboxEntry.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.inboxEntry.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.title], self.inboxEntry.title, @"Wrong title.");
    XCTAssertEqualObjects(JSON[JiveInboxEntryAttributes.verb], self.inboxEntry.verb, @"Wrong verb.");
}

- (void)testPlaceParsing {
    [self initializeInboxEntry];
    
    id JSON = [self.inboxEntry persistentJSON];
    JiveInboxEntry *entry = [JiveInboxEntry objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([entry class], [self.inboxEntry class], @"Wrong item class");
    XCTAssertEqualObjects(entry.jiveId, self.inboxEntry.jiveId, @"Wrong id");
    XCTAssertEqualObjects(entry.content, self.inboxEntry.content, @"Wrong content");
    XCTAssertEqualObjects(entry.title, self.inboxEntry.title, @"Wrong title");
    XCTAssertEqualObjects(entry.verb, self.inboxEntry.verb, @"Wrong verb");
    XCTAssertEqualObjects(entry.published, self.inboxEntry.published, @"Wrong published");
    XCTAssertEqualObjects(entry.updated, self.inboxEntry.updated, @"Wrong updated");
    XCTAssertEqualObjects(entry.url, self.inboxEntry.url, @"Wrong url");
    XCTAssertEqualObjects(entry.actor.jiveId, self.inboxEntry.actor.jiveId, @"Wrong actor");
    XCTAssertEqualObjects(entry.generator.jiveId, self.inboxEntry.generator.jiveId, @"Wrong generator");
    XCTAssertEqualObjects(entry.object.jiveId, self.inboxEntry.object.jiveId, @"Wrong object");
    XCTAssertEqualObjects(entry.provider.jiveId, self.inboxEntry.provider.jiveId, @"Wrong provider");
    XCTAssertEqualObjects(entry.target.jiveId, self.inboxEntry.target.jiveId, @"Wrong target");
    XCTAssertEqualObjects(entry.icon.url, self.inboxEntry.icon.url, @"Wrong icon");
    XCTAssertEqualObjects(entry.jive.state, self.inboxEntry.jive.state, @"Wrong jive");
    XCTAssertEqual([entry.openSocial.deliverTo count], [self.inboxEntry.openSocial.deliverTo count], @"Wrong number of deliverTo objects");
    XCTAssertEqualObjects([entry.openSocial.deliverTo objectAtIndex:0],
                         [self.inboxEntry.openSocial.deliverTo objectAtIndex:0], @"Wrong deliverTo object");
}

- (void)testPlaceParsingAlternate {
    [self alternateInitializeInboxEntry];
    
    id JSON = [self.inboxEntry persistentJSON];
    JiveInboxEntry *entry = [JiveInboxEntry objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([entry class], [self.inboxEntry class], @"Wrong item class");
    XCTAssertEqualObjects(entry.jiveId, self.inboxEntry.jiveId, @"Wrong id");
    XCTAssertEqualObjects(entry.content, self.inboxEntry.content, @"Wrong content");
    XCTAssertEqualObjects(entry.title, self.inboxEntry.title, @"Wrong title");
    XCTAssertEqualObjects(entry.verb, self.inboxEntry.verb, @"Wrong verb");
    XCTAssertEqualObjects(entry.published, self.inboxEntry.published, @"Wrong published");
    XCTAssertEqualObjects(entry.updated, self.inboxEntry.updated, @"Wrong updated");
    XCTAssertEqualObjects(entry.url, self.inboxEntry.url, @"Wrong url");
    XCTAssertEqualObjects(entry.actor.jiveId, self.inboxEntry.actor.jiveId, @"Wrong actor");
    XCTAssertEqualObjects(entry.generator.jiveId, self.inboxEntry.generator.jiveId, @"Wrong generator");
    XCTAssertEqualObjects(entry.object.jiveId, self.inboxEntry.object.jiveId, @"Wrong object");
    XCTAssertEqualObjects(entry.provider.jiveId, self.inboxEntry.provider.jiveId, @"Wrong provider");
    XCTAssertEqualObjects(entry.target.jiveId, self.inboxEntry.target.jiveId, @"Wrong target");
    XCTAssertEqualObjects(entry.icon.url, self.inboxEntry.icon.url, @"Wrong icon");
    XCTAssertEqualObjects(entry.jive.state, self.inboxEntry.jive.state, @"Wrong jive");
    XCTAssertEqual([entry.openSocial.deliverTo count], [self.inboxEntry.openSocial.deliverTo count], @"Wrong number of deliverTo objects");
    XCTAssertEqualObjects([entry.openSocial.deliverTo objectAtIndex:0],
                         [self.inboxEntry.openSocial.deliverTo objectAtIndex:0], @"Wrong deliverTo object");
}

@end
