//
//  JiveActivityTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/9/13.
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

#import "JiveActivityTests.h"
#import "JiveEmbedded.h"

@implementation JiveActivityTests

- (void)setUp {
    [super setUp];
    self.object = [JiveActivity new];
}

- (JiveActivity *)activity {
    return (JiveActivity *)self.object;
}

- (void)testType {
    XCTAssertEqualObjects(self.activity.type, @"activity", @"Wrong type.");
}

- (void)initializeActivity {
    JiveActivityObject *actor = [JiveActivityObject new];
    JiveActivityObject *generator = [JiveActivityObject new];
    JiveActivityObject *object = [JiveActivityObject new];
    JiveActivityObject *provider = [JiveActivityObject new];
    JiveActivityObject *target = [JiveActivityObject new];
    JiveMediaLink *icon = [JiveMediaLink new];
    JiveMediaLink *previewImage = [JiveMediaLink new];
    JiveExtension *jive = [JiveExtension new];
    JiveOpenSocial *openSocial = [JiveOpenSocial new];
    JiveEmbedded *embed = [JiveEmbedded new];
    
    actor.jiveId = @"3456";
    [actor setValue:@YES forKey:JiveActivityObjectAttributes.canReply];
    generator.jiveId = @"2345";
    [generator setValue:@YES forKey:JiveActivityObjectAttributes.canReply];
    object.jiveId = @"6543";
    [object setValue:@YES forKey:JiveActivityObjectAttributes.canReply];
    provider.jiveId = @"5432";
    [provider setValue:@YES forKey:JiveActivityObjectAttributes.canReply];
    target.jiveId = @"7890";
    [target setValue:@YES forKey:JiveActivityObjectAttributes.canReply];
    [icon setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:@"url"];
    [previewImage setValue:[NSURL URLWithString:@"http://dummy.com/preview.png"] forKey:@"url"];
    jive.state = JiveExtensionStateValues.accepted;
    [jive setValue:@"12345" forKey:JiveExtensionAttributes.collection];
    [embed setValue:@"previewImage" forKey:@"previewImage"];
    [openSocial setValue:embed forKey:@"embed"];
    self.activity.content = @"1234";
    self.activity.icon = icon;
    [self.activity setValue:@"45678" forKey:JiveActivityAttributes.jiveId];
    self.activity.jive = jive;
    self.activity.object = object;
    self.activity.openSocial = openSocial;
    [self.activity setValue:previewImage forKey:JiveActivityAttributes.previewImage];
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:0]
                     forKey:JiveActivityAttributes.published];
    self.activity.target = target;
    self.activity.title = @"title";
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                     forKey:JiveActivityAttributes.updated];
    self.activity.url = [NSURL URLWithString:@"http://dummy.com"];
    self.activity.verb = @"verb";
    [self.activity setValue:actor forKey:JiveActivityAttributes.actor];
    [self.activity setValue:generator forKey:JiveActivityAttributes.generator];
    [self.activity setValue:provider forKey:JiveActivityAttributes.provider];
}

- (void)alternateInitializeActivity {
    JiveActivityObject *actor = [JiveActivityObject new];
    JiveActivityObject *generator = [JiveActivityObject new];
    JiveActivityObject *object = [JiveActivityObject new];
    JiveActivityObject *provider = [JiveActivityObject new];
    JiveActivityObject *target = [JiveActivityObject new];
    JiveMediaLink *icon = [JiveMediaLink new];
    JiveMediaLink *previewImage = [JiveMediaLink new];
    JiveExtension *jive = [JiveExtension new];
    JiveOpenSocial *openSocial = [JiveOpenSocial new];
    JiveEmbedded *embed = [JiveEmbedded new];
    
    actor.jiveId = @"6543";
    [actor setValue:@YES forKey:JiveActivityObjectAttributes.canComment];
    generator.jiveId = @"5432";
    [generator setValue:@YES forKey:JiveActivityObjectAttributes.canComment];
    object.jiveId = @"3456";
    [object setValue:@YES forKey:JiveActivityObjectAttributes.canComment];
    provider.jiveId = @"2345";
    [provider setValue:@YES forKey:JiveActivityObjectAttributes.canComment];
    target.jiveId = @"9876";
    [target setValue:@YES forKey:JiveActivityObjectAttributes.canComment];
    [icon setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:@"url"];
    [previewImage setValue:[NSURL URLWithString:@"http://super.com/preview.png"] forKey:@"url"];
    jive.state = JiveExtensionStateValues.rejected;
    [jive setValue:@"54321" forKey:JiveExtensionAttributes.collection];
    [embed setValue:@"http://dummy.com/icon.png" forKey:@"previewImage"];
    [openSocial setValue:embed forKey:@"embed"];
    self.activity.content = @"4321";
    self.activity.icon = icon;
    [self.activity setValue:@"87654" forKey:JiveActivityAttributes.jiveId];
    self.activity.jive = jive;
    self.activity.object = object;
    self.activity.openSocial = openSocial;
    [self.activity setValue:previewImage forKey:JiveActivityAttributes.previewImage];
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                     forKey:JiveActivityAttributes.published];
    self.activity.target = target;
    self.activity.title = @"bad";
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:0]
                     forKey:JiveActivityAttributes.updated];
    self.activity.url = [NSURL URLWithString:@"http://super.com"];
    self.activity.verb = @"longingly";
    [self.activity setValue:actor forKey:JiveActivityAttributes.actor];
    [self.activity setValue:generator forKey:JiveActivityAttributes.generator];
    [self.activity setValue:provider forKey:JiveActivityAttributes.provider];
}

- (void)testToJSON {
    NSDictionary *JSON = [self.activity toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.type], self.activity.type, @"Wrong type");
    
    [self initializeActivity];
    JSON = [self.activity toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.content], self.activity.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.activity.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.title], self.activity.title, @"Wrong title.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.url], [self.activity.url absoluteString], @"Wrong url.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.verb], self.activity.verb, @"Wrong verb");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.type], self.activity.type, @"Wrong type");
    
    NSDictionary *iconJSON = JSON[JiveActivityAttributes.icon];
    
    XCTAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(iconJSON[@"url"], [self.activity.icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = JSON[JiveActivityAttributes.jive];
    
    XCTAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([jiveJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(jiveJSON[JiveExtensionAttributes.state], self.activity.jive.state, @"Wrong value");
    
    NSDictionary *objectJSON = JSON[JiveActivityAttributes.object];
    
    XCTAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([objectJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(objectJSON[JiveObjectConstants.id], self.activity.object.jiveId, @"Wrong value");
    
    NSDictionary *openSocialJSON = JSON[JiveActivityAttributes.openSocial];
    NSDictionary *embedJSON = openSocialJSON[@"embed"];
    
    XCTAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertTrue([[embedJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([embedJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(embedJSON[@"previewImage"], self.activity.openSocial.embed.previewImage, @"Wrong value");
    
    NSDictionary *targetJSON = JSON[JiveActivityAttributes.target];
    
    XCTAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([targetJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(targetJSON[JiveObjectConstants.id], self.activity.target.jiveId, @"Wrong value");
}

- (void)testToJSON_alternate {
    [self alternateInitializeActivity];
    
    NSDictionary *JSON = [self.activity toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.content], self.activity.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.activity.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.title], self.activity.title, @"Wrong title.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.url], [self.activity.url absoluteString], @"Wrong url.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.verb], self.activity.verb, @"Wrong verb");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.type], self.activity.type, @"Wrong type");
    
    NSDictionary *iconJSON = JSON[JiveActivityAttributes.icon];
    
    XCTAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(iconJSON[@"url"], [self.activity.icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = JSON[JiveActivityAttributes.jive];
    
    XCTAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([jiveJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(jiveJSON[JiveExtensionAttributes.state], self.activity.jive.state, @"Wrong value");
    
    NSDictionary *objectJSON = JSON[JiveActivityAttributes.object];
    
    XCTAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([objectJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(objectJSON[JiveObjectConstants.id], self.activity.object.jiveId, @"Wrong value");
    
    NSDictionary *openSocialJSON = JSON[JiveActivityAttributes.openSocial];
    NSDictionary *embedJSON = openSocialJSON[@"embed"];
    
    XCTAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertTrue([[embedJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([embedJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(embedJSON[@"previewImage"], self.activity.openSocial.embed.previewImage, @"Wrong value");
    
    NSDictionary *targetJSON = JSON[JiveActivityAttributes.target];
    
    XCTAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([targetJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(targetJSON[JiveObjectConstants.id], self.activity.target.jiveId, @"Wrong value");
}

- (void)testPersistentJSON {
    NSDictionary *JSON = [self.activity persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.type], self.activity.type, @"Wrong type");
    
    [self initializeActivity];
    JSON = [self.activity persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)17, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.content], self.activity.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.activity.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.title], self.activity.title, @"Wrong title.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.url], [self.activity.url absoluteString], @"Wrong url.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.verb], self.activity.verb, @"Wrong verb");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.published],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.updated],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.type], self.activity.type, @"Wrong type");
    
    NSDictionary *actorJSON = JSON[JiveActivityAttributes.actor];
    
    XCTAssertTrue([[actorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([actorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(actorJSON[JiveObjectConstants.id], self.activity.actor.jiveId, @"Wrong value");
    XCTAssertEqualObjects(actorJSON[JiveActivityObjectAttributes.canReply],
                         self.activity.actor.canReply, @"Wrong value");
    
    NSDictionary *generatorJSON = JSON[JiveActivityAttributes.generator];
    
    XCTAssertTrue([[generatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([generatorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(generatorJSON[JiveObjectConstants.id], self.activity.generator.jiveId, @"Wrong value");
    XCTAssertEqualObjects(generatorJSON[JiveActivityObjectAttributes.canReply],
                         self.activity.generator.canReply, @"Wrong value");
    
    NSDictionary *iconJSON = JSON[JiveActivityAttributes.icon];
    
    XCTAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(iconJSON[@"url"], [self.activity.icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = JSON[JiveActivityAttributes.jive];
    
    XCTAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([jiveJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(jiveJSON[JiveExtensionAttributes.state], self.activity.jive.state, @"Wrong value");
    XCTAssertEqualObjects(jiveJSON[JiveExtensionAttributes.collection], self.activity.jive.collection, @"Wrong value");
    
    NSDictionary *objectJSON = JSON[JiveActivityAttributes.object];
    
    XCTAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([objectJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(objectJSON[JiveObjectConstants.id], self.activity.object.jiveId, @"Wrong value");
    XCTAssertEqualObjects(objectJSON[JiveActivityObjectAttributes.canReply],
                         self.activity.object.canReply, @"Wrong value");
    
    NSDictionary *openSocialJSON = JSON[JiveActivityAttributes.openSocial];
    NSDictionary *embedJSON = openSocialJSON[@"embed"];
    
    XCTAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertTrue([[embedJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([embedJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(embedJSON[@"previewImage"], self.activity.openSocial.embed.previewImage, @"Wrong value");
    
    NSDictionary *previewImageJSON = JSON[JiveActivityAttributes.previewImage];
    
    XCTAssertTrue([[previewImageJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([previewImageJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(previewImageJSON[@"url"], [self.activity.previewImage.url absoluteString], @"Wrong value");
    
    NSDictionary *providerJSON = JSON[JiveActivityAttributes.provider];
    
    XCTAssertTrue([[providerJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([providerJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(providerJSON[JiveObjectConstants.id], self.activity.provider.jiveId, @"Wrong value");
    XCTAssertEqualObjects(providerJSON[JiveActivityObjectAttributes.canReply],
                         self.activity.provider.canReply, @"Wrong value");
    
    NSDictionary *targetJSON = JSON[JiveActivityAttributes.target];
    
    XCTAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([targetJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(targetJSON[JiveObjectConstants.id], self.activity.target.jiveId, @"Wrong value");
    XCTAssertEqualObjects(targetJSON[JiveActivityObjectAttributes.canReply],
                         self.activity.target.canReply, @"Wrong value");
}

- (void)testPersistentJSON_alternate {
    [self alternateInitializeActivity];
    
    NSDictionary *JSON = [self.activity persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)17, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.content], self.activity.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.activity.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.title], self.activity.title, @"Wrong title.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.url], [self.activity.url absoluteString], @"Wrong url.");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.verb], self.activity.verb, @"Wrong verb");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.published],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.updated],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    XCTAssertEqualObjects(JSON[JiveActivityAttributes.type], self.activity.type, @"Wrong type");
    
    NSDictionary *actorJSON = JSON[JiveActivityAttributes.actor];
    
    XCTAssertTrue([[actorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([actorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(actorJSON[JiveObjectConstants.id], self.activity.actor.jiveId, @"Wrong value");
    XCTAssertEqualObjects(actorJSON[JiveActivityObjectAttributes.canComment],
                         self.activity.actor.canComment, @"Wrong value");
    
    NSDictionary *generatorJSON = JSON[JiveActivityAttributes.generator];
    
    XCTAssertTrue([[generatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([generatorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(generatorJSON[JiveObjectConstants.id], self.activity.generator.jiveId, @"Wrong value");
    XCTAssertEqualObjects(generatorJSON[JiveActivityObjectAttributes.canComment],
                         self.activity.generator.canComment, @"Wrong value");
    
    NSDictionary *iconJSON = JSON[JiveActivityAttributes.icon];
    
    XCTAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(iconJSON[@"url"], [self.activity.icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = JSON[JiveActivityAttributes.jive];
    
    XCTAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([jiveJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(jiveJSON[JiveExtensionAttributes.state], self.activity.jive.state, @"Wrong value");
    XCTAssertEqualObjects(jiveJSON[JiveExtensionAttributes.collection], self.activity.jive.collection, @"Wrong value");
    
    NSDictionary *objectJSON = JSON[JiveActivityAttributes.object];
    
    XCTAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([objectJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(objectJSON[JiveObjectConstants.id], self.activity.object.jiveId, @"Wrong value");
    XCTAssertEqualObjects(objectJSON[JiveActivityObjectAttributes.canComment],
                         self.activity.object.canComment, @"Wrong value");
    
    NSDictionary *openSocialJSON = JSON[JiveActivityAttributes.openSocial];
    NSDictionary *embedJSON = openSocialJSON[@"embed"];
    
    XCTAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertTrue([[embedJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([embedJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(embedJSON[@"previewImage"], self.activity.openSocial.embed.previewImage, @"Wrong value");
    
    NSDictionary *previewImageJSON = JSON[JiveActivityAttributes.previewImage];
    
    XCTAssertTrue([[previewImageJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([previewImageJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(previewImageJSON[@"url"], [self.activity.previewImage.url absoluteString], @"Wrong value");
    
    NSDictionary *providerJSON = JSON[JiveActivityAttributes.provider];
    
    XCTAssertTrue([[providerJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([providerJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(providerJSON[JiveObjectConstants.id], self.activity.provider.jiveId, @"Wrong value");
    XCTAssertEqualObjects(providerJSON[JiveActivityObjectAttributes.canComment],
                         self.activity.provider.canComment, @"Wrong value");
    
    NSDictionary *targetJSON = JSON[JiveActivityAttributes.target];
    
    XCTAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([targetJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(targetJSON[JiveObjectConstants.id], self.activity.target.jiveId, @"Wrong value");
    XCTAssertEqualObjects(targetJSON[JiveActivityObjectAttributes.canComment],
                         self.activity.target.canComment, @"Wrong value");
}

- (void)testActivityParsing {
    [self initializeActivity];
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[self.activity persistentJSON];
    JiveActivity *newActivity = [JiveActivity objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([newActivity class], [self.activity class], @"Wrong item class");
    XCTAssertEqualObjects(newActivity.actor.jiveId, self.activity.actor.jiveId, @"Wrong actor");
    XCTAssertEqualObjects(newActivity.actor.canReply, self.activity.actor.canReply, @"Wrong actor");
    XCTAssertEqualObjects(newActivity.content, self.activity.content, @"Wrong content");
    XCTAssertEqualObjects(newActivity.generator.jiveId, self.activity.generator.jiveId, @"Wrong generator");
    XCTAssertEqualObjects(newActivity.generator.canReply, self.activity.generator.canReply, @"Wrong generator");
    XCTAssertEqualObjects(newActivity.icon.url, self.activity.icon.url, @"Wrong icon");
    XCTAssertEqualObjects(newActivity.jiveId, self.activity.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newActivity.jive.state, self.activity.jive.state, @"Wrong jive");
    XCTAssertEqualObjects(newActivity.jive.collection, self.activity.jive.collection, @"Wrong jive");
    XCTAssertEqualObjects(newActivity.object.jiveId, self.activity.object.jiveId, @"Wrong object");
    XCTAssertEqualObjects(newActivity.object.canReply, self.activity.object.canReply, @"Wrong object");
    XCTAssertEqualObjects(newActivity.openSocial.embed.previewImage,
                         self.activity.openSocial.embed.previewImage, @"Wrong openSocial");
    XCTAssertEqualObjects(newActivity.provider.jiveId, self.activity.provider.jiveId, @"Wrong provider");
    XCTAssertEqualObjects(newActivity.provider.canReply, self.activity.provider.canReply, @"Wrong provider");
    XCTAssertEqualObjects(newActivity.published, self.activity.published, @"Wrong published");
    XCTAssertEqualObjects(newActivity.target.jiveId, self.activity.target.jiveId, @"Wrong target");
    XCTAssertEqualObjects(newActivity.target.canReply, self.activity.target.canReply, @"Wrong target");
    XCTAssertEqualObjects(newActivity.title, self.activity.title, @"Wrong title");
    XCTAssertEqualObjects(newActivity.updated, self.activity.updated, @"Wrong updated");
    XCTAssertEqualObjects(newActivity.url, self.activity.url, @"Wrong url");
    XCTAssertEqualObjects(newActivity.verb, self.activity.verb, @"Wrong verb");
    XCTAssertFalse(newActivity.extraFieldsDetected);
}

- (void)testActivityParsingAlternate {
    [self alternateInitializeActivity];
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[self.activity persistentJSON];
    JiveActivity *newActivity = [JiveActivity objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([newActivity class], [self.activity class], @"Wrong item class");
    XCTAssertEqualObjects(newActivity.actor.jiveId, self.activity.actor.jiveId, @"Wrong actor");
    XCTAssertEqualObjects(newActivity.actor.canComment, self.activity.actor.canComment, @"Wrong actor");
    XCTAssertEqualObjects(newActivity.content, self.activity.content, @"Wrong content");
    XCTAssertEqualObjects(newActivity.generator.jiveId, self.activity.generator.jiveId, @"Wrong generator");
    XCTAssertEqualObjects(newActivity.generator.canComment, self.activity.generator.canComment, @"Wrong generator");
    XCTAssertEqualObjects(newActivity.icon.url, self.activity.icon.url, @"Wrong icon");
    XCTAssertEqualObjects(newActivity.jiveId, self.activity.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newActivity.jive.state, self.activity.jive.state, @"Wrong jive");
    XCTAssertEqualObjects(newActivity.jive.collection, self.activity.jive.collection, @"Wrong jive");
    XCTAssertEqualObjects(newActivity.object.jiveId, self.activity.object.jiveId, @"Wrong object");
    XCTAssertEqualObjects(newActivity.object.canComment, self.activity.object.canComment, @"Wrong object");
    XCTAssertEqualObjects(newActivity.openSocial.embed.previewImage,
                         self.activity.openSocial.embed.previewImage, @"Wrong openSocial");
    XCTAssertEqualObjects(newActivity.provider.jiveId, self.activity.provider.jiveId, @"Wrong provider");
    XCTAssertEqualObjects(newActivity.provider.canComment, self.activity.provider.canComment, @"Wrong provider");
    XCTAssertEqualObjects(newActivity.published, self.activity.published, @"Wrong published");
    XCTAssertEqualObjects(newActivity.target.jiveId, self.activity.target.jiveId, @"Wrong target");
    XCTAssertEqualObjects(newActivity.target.canComment, self.activity.target.canComment, @"Wrong target");
    XCTAssertEqualObjects(newActivity.title, self.activity.title, @"Wrong title");
    XCTAssertEqualObjects(newActivity.updated, self.activity.updated, @"Wrong updated");
    XCTAssertEqualObjects(newActivity.url, self.activity.url, @"Wrong url");
    XCTAssertEqualObjects(newActivity.verb, self.activity.verb, @"Wrong verb");
}

@end
