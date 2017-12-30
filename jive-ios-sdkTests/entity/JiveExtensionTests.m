//
//  JiveExtensionTests.m
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

#import "JiveExtension.h"
#import "JiveActivityObject.h"
#import "JiveVia.h"
#import "JiveObject_internal.h"

#import "JiveObjectTests.h"


@interface JiveExtensionTests : JiveObjectTests

@property (nonatomic, readonly) JiveExtension *extension;

@end


@implementation JiveExtensionTests

- (void)setUp {
    [super setUp];
    self.object = [JiveExtension new];
}

- (JiveExtension *)extension {
    return (JiveExtension *)self.object;
}

- (void)initializeExtension {
    JiveActivityObject *parent = [JiveActivityObject new];
    JiveActivityObject *parentActor = [JiveActivityObject new];
    JiveActivityObject *mentioned = [JiveActivityObject new];
    JiveGenericPerson *onBehalfOf = [JiveGenericPerson new];
    JiveGenericPerson *parentOnBehalfOf = [JiveGenericPerson new];
    JiveVia *via = [JiveVia new];
    JivePerson *personOnBehalfOf = [JivePerson new];
    
    onBehalfOf.email = @"behalf@email.com";
    [personOnBehalfOf setValue:@"person" forKey:JivePersonAttributes.displayName];
    [parentOnBehalfOf setValue:personOnBehalfOf forKey:JiveGenericPersonAttributes.person];
    
    mentioned.jiveId = @"87654";
    [mentioned setValue:@YES forKey:@"canComment"];
    parent.jiveId = @"3456";
    [parent setValue:@YES forKey:@"canReply"];
    parentActor.jiveId = @"13579";
    [parentActor setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    via.displayName = @"via name";
    
    [self.extension setValue:[NSURL URLWithString:@"http://answer.com"]
                      forKey:JiveExtensionAttributes.answer];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canComment];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canLike];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canReply];
    [self.extension setValue:@"text" forKey:JiveExtensionAttributes.collection];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.collectionRead];
    [self.extension setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                      forKey:JiveExtensionAttributes.collectionUpdated];
    self.extension.display = @"1234";
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.followingInStream];
    [self.extension setValue:@"icon style" forKey:JiveExtensionAttributes.iconCss];
    [self.extension setValue:@5 forKey:JiveExtensionAttributes.likeCount];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.liked];
    [self.extension setValue:mentioned forKey:JiveExtensionAttributes.mentioned];
    [self.extension setValue:@345 forKey:JiveExtensionAttributes.objectID];
    [self.extension setValue:@2 forKey:JiveExtensionAttributes.objectType];
    self.extension.onBehalfOf = onBehalfOf;
    [self.extension setValue:@"comment" forKey:JiveExtensionAttributes.outcomeComment];
    [self.extension setValue:@"outcome" forKey:JiveExtensionAttributes.outcomeTypeName];
    [self.extension setValue:parent forKey:JiveExtensionAttributes.parent];
    [self.extension setValue:parentActor forKey:JiveExtensionAttributes.parentActor];
    [self.extension setValue:@7 forKey:JiveExtensionAttributes.parentLikeCount];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.parentLiked];
    self.extension.parentOnBehalfOf = parentOnBehalfOf;
    [self.extension setValue:@3 forKey:JiveExtensionAttributes.parentReplyCount];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.question];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.read];
    [self.extension setValue:@6 forKey:JiveExtensionAttributes.replyCount];
    [self.extension setValue:@"open" forKey:JiveExtensionAttributes.resolved];
    self.extension.state = @"state";
    [self.extension setValue:[NSURL URLWithString:@"http://dummy.com"]
                      forKey:JiveExtensionAttributes.update];
    [self.extension setValue:[NSURL URLWithString:@"http://collection.com"]
                      forKey:JiveExtensionAttributes.updateCollection];
    self.extension.via = via;
    [self.extension setValue:[NSURL URLWithString:@"http://productIcon.com"]
                      forKey:JiveExtensionAttributes.productIcon];
    [self.extension setValue:@33 forKey:JiveExtensionAttributes.imagesCount];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.objectViewed];
}

- (void)alternateInitializeExtension {
    JiveActivityObject *parent = [JiveActivityObject new];
    JiveActivityObject *parentActor = [JiveActivityObject new];
    JiveActivityObject *mentioned = [JiveActivityObject new];
    JiveGenericPerson *onBehalfOf = [JiveGenericPerson new];
    JiveGenericPerson *parentOnBehalfOf = [JiveGenericPerson new];
    JiveVia *via = [JiveVia new];
    JivePerson *personOnBehalfOf = [JivePerson new];
    
    [personOnBehalfOf setValue:@"person" forKey:JivePersonAttributes.displayName];
    [onBehalfOf setValue:personOnBehalfOf forKey:JiveGenericPersonAttributes.person];
    parentOnBehalfOf.email = @"trombone@email.com";
    
    mentioned.jiveId = @"12345";
    [mentioned setValue:@YES forKey:@"canReply"];
    parent.jiveId = @"3456";
    [parent setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    parentActor.jiveId = @"2468";
    [parentActor setValue:@YES forKey:@"canComment"];
    via.displayName = @"gang busters";
    
    [self.extension setValue:[NSURL URLWithString:@"http://question.com"]
                      forKey:JiveExtensionAttributes.answer];
    [self.extension setValue:@"html" forKey:JiveExtensionAttributes.collection];
    [self.extension setValue:[NSDate dateWithTimeIntervalSince1970:0]
                      forKey:JiveExtensionAttributes.collectionUpdated];
    self.extension.display = @"6541";
    [self.extension setValue:@"wrong style" forKey:JiveExtensionAttributes.iconCss];
    [self.extension setValue:@6 forKey:JiveExtensionAttributes.likeCount];
    [self.extension setValue:mentioned forKey:JiveExtensionAttributes.mentioned];
    [self.extension setValue:@543 forKey:JiveExtensionAttributes.objectID];
    [self.extension setValue:@1 forKey:JiveExtensionAttributes.objectType];
    self.extension.onBehalfOf = onBehalfOf;
    [self.extension setValue:@"outcome" forKey:JiveExtensionAttributes.outcomeComment];
    [self.extension setValue:@"type name" forKey:JiveExtensionAttributes.outcomeTypeName];
    [self.extension setValue:parent forKey:JiveExtensionAttributes.parent];
    [self.extension setValue:parentActor forKey:JiveExtensionAttributes.parentActor];
    [self.extension setValue:@4 forKey:JiveExtensionAttributes.parentLikeCount];
    self.extension.parentOnBehalfOf = parentOnBehalfOf;
    [self.extension setValue:@8 forKey:JiveExtensionAttributes.parentReplyCount];
    [self.extension setValue:@60 forKey:JiveExtensionAttributes.replyCount];
    [self.extension setValue:@"resolved" forKey:JiveExtensionAttributes.resolved];
    self.extension.state = @"loco";
    [self.extension setValue:[NSURL URLWithString:@"http://super.com"]
                      forKey:JiveExtensionAttributes.update];
    [self.extension setValue:[NSURL URLWithString:@"http://update.com"]
                      forKey:JiveExtensionAttributes.updateCollection];
    self.extension.via = via;
    [self.extension setValue:[NSURL URLWithString:@"http://underworld.com"]
                      forKey:JiveExtensionAttributes.productIcon];
    [self.extension setValue:@3 forKey:JiveExtensionAttributes.imagesCount];
}

- (void)testBoolProperties {
    NSDictionary *JSON = [self.extension persistentJSON];
    NSUInteger propertyCount = 0;
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], propertyCount, @"Initial dictionary is not empty");
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canComment];
    JSON = [self.extension persistentJSON];
    XCTAssertEqual([JSON count], ++propertyCount);
    XCTAssertEqual([JSON[JiveExtensionAttributes.canComment] boolValue],
                   [self.extension commentAllowed]);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canLike];
    JSON = [self.extension persistentJSON];
    XCTAssertEqual([JSON count], ++propertyCount);
    XCTAssertEqual([JSON[JiveExtensionAttributes.canLike] boolValue],
                   [self.extension likeAllowed]);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canReply];
    JSON = [self.extension persistentJSON];
    XCTAssertEqual([JSON count], ++propertyCount);
    XCTAssertEqual([JSON[JiveExtensionAttributes.canReply] boolValue],
                   [self.extension replyAllowed]);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.collectionRead];
    JSON = [self.extension persistentJSON];
    XCTAssertEqual([JSON count], ++propertyCount);
    XCTAssertEqual([JSON[JiveExtensionAttributes.collectionRead] boolValue],
                   [self.extension isCollectionRead]);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.followingInStream];
    JSON = [self.extension persistentJSON];
    XCTAssertEqual([JSON count], ++propertyCount);
    XCTAssertEqual([JSON[JiveExtensionAttributes.followingInStream] boolValue],
                   [self.extension isFollowingInStream]);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.liked];
    JSON = [self.extension persistentJSON];
    XCTAssertEqual([JSON count], ++propertyCount);
    XCTAssertEqual([JSON[JiveExtensionAttributes.liked] boolValue],
                   [self.extension isLiked]);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.parentLiked];
    JSON = [self.extension persistentJSON];
    XCTAssertEqual([JSON count], ++propertyCount);
    XCTAssertEqual([JSON[JiveExtensionAttributes.parentLiked] boolValue],
                   [self.extension isParentLiked]);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.question];
    JSON = [self.extension persistentJSON];
    XCTAssertEqual([JSON count], ++propertyCount);
    XCTAssertEqual([JSON[JiveExtensionAttributes.question] boolValue],
                   [self.extension isQuestion]);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.read];
    JSON = [self.extension persistentJSON];
    XCTAssertEqual([JSON count], ++propertyCount);
    XCTAssertEqual([JSON[JiveExtensionAttributes.read] boolValue],
                   [self.extension isRead]);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.objectViewed];
    JSON = [self.extension persistentJSON];
    XCTAssertEqual([JSON count], ++propertyCount);
    XCTAssertEqual([JSON[JiveExtensionAttributes.objectViewed] boolValue],
                   [self.extension hasBeenViewed]);
}

- (void)testPersistentJSON {
    NSDictionary *JSON = [self.extension persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeExtension];
    JSON = [self.extension persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)35, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.answer],
                         [self.extension.answer absoluteString]);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.canComment], self.extension.canComment);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.canLike], self.extension.canLike);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.canReply], self.extension.canReply);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.collection], self.extension.collection);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.collectionRead], self.extension.collectionRead);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.collectionUpdated],
                         @"1970-01-01T00:16:40.123+0000");
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.display], self.extension.display);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.followingInStream],
                         self.extension.followingInStream);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.iconCss], self.extension.iconCss);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.likeCount], self.extension.likeCount);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.liked], self.extension.liked);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.objectID], self.extension.objectID);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.objectType], self.extension.objectType);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.outcomeComment], self.extension.outcomeComment);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.outcomeTypeName],
                         self.extension.outcomeTypeName);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.parentLikeCount],
                         self.extension.parentLikeCount);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.parentLiked], self.extension.parentLiked);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.parentReplyCount],
                         self.extension.parentReplyCount);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.question], self.extension.question);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.read], self.extension.read);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.replyCount], self.extension.replyCount);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.resolved], self.extension.resolved);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.state], self.extension.state);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.update],
                         [self.extension.update absoluteString]);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.updateCollection],
                         [self.extension.updateCollection absoluteString]);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.productIcon],
                         [self.extension.productIcon absoluteString]);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.imagesCount], self.extension.imagesCount);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.objectViewed], self.extension.objectViewed);
    
    NSDictionary *mentionedJSON = JSON[JiveExtensionAttributes.mentioned];
    
    XCTAssertTrue([[mentionedJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([mentionedJSON count], (NSUInteger)2);
    XCTAssertEqualObjects(mentionedJSON[JiveObjectConstants.id], self.extension.mentioned.jiveId);
    XCTAssertEqualObjects(mentionedJSON[@"canComment"], @YES);
    
    NSDictionary *onBehalfOfJSON = JSON[JiveExtensionAttributes.onBehalfOf];
    
    XCTAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(onBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.onBehalfOf.email, @"Wrong value");
    
    NSDictionary *parentJSON = JSON[JiveExtensionAttributes.parent];
    
    XCTAssertTrue([[parentJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([parentJSON count], (NSUInteger)2);
    XCTAssertEqualObjects(parentJSON[JiveObjectConstants.id], self.extension.parent.jiveId);
    XCTAssertEqualObjects(parentJSON[@"canReply"], @YES);
    
    NSDictionary *parentActorJSON = JSON[JiveExtensionAttributes.parentActor];
    
    XCTAssertTrue([[parentActorJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([parentActorJSON count], (NSUInteger)2);
    XCTAssertEqualObjects(parentActorJSON[JiveObjectConstants.id], self.extension.parentActor.jiveId);
    XCTAssertEqualObjects(parentActorJSON[@"updated"], @"1970-01-01T00:00:00.000+0000");
    
    NSDictionary *parentOnBehalfOfJSON = JSON[JiveExtensionAttributes.parentOnBehalfOf];
    
    XCTAssertTrue([[parentOnBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([parentOnBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(parentOnBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.parentOnBehalfOf.email, @"Wrong value");
    
    NSDictionary *viaJSON = JSON[JiveExtensionAttributes.via];
    
    XCTAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([viaJSON count], (NSUInteger)1);
    XCTAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.extension.via.displayName);
}

- (void)testPersistentJSON_alternate {
    [self alternateInitializeExtension];
    
    NSDictionary *JSON = [self.extension persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)25, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.answer],
                         [self.extension.answer absoluteString]);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.canComment], self.extension.canComment);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.canLike], self.extension.canLike);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.canReply], self.extension.canReply);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.collection], self.extension.collection);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.collectionRead], self.extension.collectionRead);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.collectionUpdated],
                         @"1970-01-01T00:00:00.000+0000");
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.display], self.extension.display);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.followingInStream],
                         self.extension.followingInStream);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.iconCss], self.extension.iconCss);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.likeCount], self.extension.likeCount);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.liked], self.extension.liked);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.objectID], self.extension.objectID);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.objectType], self.extension.objectType);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.outcomeComment], self.extension.outcomeComment);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.outcomeTypeName],
                         self.extension.outcomeTypeName);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.parentLikeCount],
                         self.extension.parentLikeCount);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.parentLiked], self.extension.parentLiked);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.parentReplyCount],
                         self.extension.parentReplyCount);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.question], self.extension.question);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.read], self.extension.read);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.replyCount], self.extension.replyCount);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.resolved], self.extension.resolved);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.state], self.extension.state);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.update],
                         [self.extension.update absoluteString]);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.updateCollection],
                         [self.extension.updateCollection absoluteString]);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.productIcon],
                         [self.extension.productIcon absoluteString]);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.imagesCount], self.extension.imagesCount);
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.objectViewed], self.extension.objectViewed);
    
    NSDictionary *mentionedJSON = JSON[JiveExtensionAttributes.mentioned];
    
    XCTAssertTrue([[mentionedJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([mentionedJSON count], (NSUInteger)2);
    XCTAssertEqualObjects(mentionedJSON[JiveObjectConstants.id], self.extension.mentioned.jiveId);
    XCTAssertEqualObjects(mentionedJSON[@"canReply"], @YES);
    
    NSDictionary *onBehalfOfJSON = JSON[JiveExtensionAttributes.onBehalfOf];
    
    XCTAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(onBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.onBehalfOf.email, @"Wrong value");
    
    NSDictionary *parentJSON = JSON[JiveExtensionAttributes.parent];
    
    XCTAssertTrue([[parentJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([parentJSON count], (NSUInteger)2);
    XCTAssertEqualObjects(parentJSON[JiveObjectConstants.id], self.extension.parent.jiveId);
    XCTAssertEqualObjects(parentJSON[@"updated"], @"1970-01-01T00:00:00.000+0000");
    
    NSDictionary *parentActorJSON = JSON[JiveExtensionAttributes.parentActor];
    
    XCTAssertTrue([[parentActorJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([parentActorJSON count], (NSUInteger)2);
    XCTAssertEqualObjects(parentActorJSON[JiveObjectConstants.id], self.extension.parentActor.jiveId);
    XCTAssertEqualObjects(parentActorJSON[@"canComment"], @YES);
    
    NSDictionary *parentOnBehalfOfJSON = JSON[JiveExtensionAttributes.parentOnBehalfOf];
    
    XCTAssertTrue([[parentOnBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([parentOnBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(parentOnBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.parentOnBehalfOf.email, @"Wrong value");
    
    NSDictionary *viaJSON = JSON[JiveExtensionAttributes.via];
    
    XCTAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([viaJSON count], (NSUInteger)1);
    XCTAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.extension.via.displayName);
}

- (void)testToJSON {
    NSDictionary *JSON = [self.extension toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeExtension];
    JSON = [self.extension toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.display], self.extension.display, @"Wrong display.");
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.state], self.extension.state, @"Wrong state.");
    
    NSDictionary *onBehalfOfJSON = JSON[JiveExtensionAttributes.onBehalfOf];
    
    XCTAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(onBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.onBehalfOf.email, @"Wrong value");
    
    NSDictionary *parentOnBehalfOfJSON = JSON[JiveExtensionAttributes.parentOnBehalfOf];
    
    XCTAssertTrue([[parentOnBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([parentOnBehalfOfJSON count], (NSUInteger)0, @"Jive dictionary had the wrong number of entries");
    
    NSDictionary *viaJSON = JSON[JiveExtensionAttributes.via];
    
    XCTAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([viaJSON count], (NSUInteger)1);
    XCTAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.extension.via.displayName);
}

- (void)testToJSON_alternate {
    [self alternateInitializeExtension];
    
    NSDictionary *JSON = [self.extension toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.display], self.extension.display, @"Wrong display.");
    XCTAssertEqualObjects(JSON[JiveExtensionAttributes.state], self.extension.state, @"Wrong state.");
    
    NSDictionary *onBehalfOfJSON = JSON[JiveExtensionAttributes.onBehalfOf];
    
    XCTAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([onBehalfOfJSON count], (NSUInteger)0, @"Jive dictionary had the wrong number of entries");
    
    NSDictionary *parentOnBehalfOfJSON = JSON[JiveExtensionAttributes.parentOnBehalfOf];
    
    XCTAssertTrue([[parentOnBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([parentOnBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(parentOnBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.parentOnBehalfOf.email, @"Wrong value");
    
    NSDictionary *viaJSON = JSON[JiveExtensionAttributes.via];
    
    XCTAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([viaJSON count], (NSUInteger)1);
    XCTAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.extension.via.displayName);
}

- (void)testExtensionParsing {
    [self initializeExtension];
    
    NSDictionary *JSON = [self.extension persistentJSON];
    JiveExtension *newExtension = [JiveExtension objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqualObjects([newExtension.answer absoluteString],
                         [self.extension.answer absoluteString]);
    XCTAssertEqualObjects(newExtension.canComment, self.extension.canComment);
    XCTAssertEqualObjects(newExtension.canLike, self.extension.canLike);
    XCTAssertEqualObjects(newExtension.canReply, self.extension.canReply);
    XCTAssertEqualObjects(newExtension.collection, self.extension.collection);
    XCTAssertEqualObjects(newExtension.collectionRead, self.extension.collectionRead);
    XCTAssertEqualObjects(newExtension.collectionUpdated, self.extension.collectionUpdated);
    XCTAssertEqualObjects(newExtension.display, self.extension.display);
    XCTAssertEqualObjects(newExtension.followingInStream, self.extension.followingInStream);
    XCTAssertEqualObjects(newExtension.iconCss, self.extension.iconCss);
    XCTAssertEqualObjects(newExtension.likeCount, self.extension.likeCount);
    XCTAssertEqualObjects(newExtension.liked, self.extension.liked);
    XCTAssertEqualObjects(newExtension.mentioned.jiveId, self.extension.mentioned.jiveId);
    XCTAssertEqualObjects(newExtension.mentioned.canComment, self.extension.mentioned.canComment);
    XCTAssertEqualObjects(newExtension.mentioned.canReply, self.extension.mentioned.canReply);
    XCTAssertEqualObjects(newExtension.objectID, self.extension.objectID);
    XCTAssertEqualObjects(newExtension.objectType, self.extension.objectType);
    XCTAssertEqualObjects(newExtension.onBehalfOf.email, self.extension.onBehalfOf.email);
    XCTAssertEqualObjects(newExtension.onBehalfOf.person.displayName,
                         self.extension.onBehalfOf.person.displayName);
    XCTAssertEqualObjects(newExtension.outcomeComment, self.extension.outcomeComment);
    XCTAssertEqualObjects(newExtension.outcomeTypeName, self.extension.outcomeTypeName);
    XCTAssertEqualObjects(newExtension.parent.jiveId, self.extension.parent.jiveId);
    XCTAssertEqualObjects(newExtension.parent.canReply, self.extension.parent.canReply);
    XCTAssertEqualObjects(newExtension.parent.updated, self.extension.parent.updated);
    XCTAssertEqualObjects(newExtension.parentActor.jiveId, self.extension.parentActor.jiveId);
    XCTAssertEqualObjects(newExtension.parentActor.canComment, self.extension.parentActor.canComment);
    XCTAssertEqualObjects(newExtension.parentActor.updated, self.extension.parentActor.updated);
    XCTAssertEqualObjects(newExtension.parentLikeCount, self.extension.parentLikeCount);
    XCTAssertEqualObjects(newExtension.parentLiked, self.extension.parentLiked);
    XCTAssertEqualObjects(newExtension.parentOnBehalfOf.email, self.extension.parentOnBehalfOf.email);
    XCTAssertEqualObjects(newExtension.parentOnBehalfOf.person.displayName,
                         self.extension.parentOnBehalfOf.person.displayName);
    XCTAssertEqualObjects(newExtension.parentReplyCount, self.extension.parentReplyCount);
    XCTAssertEqualObjects(newExtension.question, self.extension.question);
    XCTAssertEqualObjects(newExtension.read, self.extension.read);
    XCTAssertEqualObjects(newExtension.replyCount, self.extension.replyCount);
    XCTAssertEqualObjects(newExtension.resolved, self.extension.resolved);
    XCTAssertEqualObjects(newExtension.state, self.extension.state);
    XCTAssertEqualObjects([newExtension.update absoluteString],
                         [self.extension.update absoluteString]);
    XCTAssertEqualObjects([newExtension.updateCollection absoluteString],
                         [self.extension.updateCollection absoluteString]);
    XCTAssertEqualObjects(newExtension.via.displayName, self.extension.via.displayName);
    XCTAssertEqualObjects([newExtension.productIcon absoluteString],
                         [self.extension.productIcon absoluteString]);
    XCTAssertEqualObjects(newExtension.imagesCount, self.extension.imagesCount);
    XCTAssertEqualObjects(newExtension.objectViewed, self.extension.objectViewed);
}

- (void)testExtensionParsing_alternate {
    [self alternateInitializeExtension];
    
    NSDictionary *JSON = [self.extension persistentJSON];
    JiveExtension *newExtension = [JiveExtension objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqualObjects([newExtension.answer absoluteString],
                         [self.extension.answer absoluteString]);
    XCTAssertEqualObjects(newExtension.canComment, self.extension.canComment);
    XCTAssertEqualObjects(newExtension.canLike, self.extension.canLike);
    XCTAssertEqualObjects(newExtension.canReply, self.extension.canReply);
    XCTAssertEqualObjects(newExtension.collection, self.extension.collection);
    XCTAssertEqualObjects(newExtension.collectionRead, self.extension.collectionRead);
    XCTAssertEqualObjects(newExtension.collectionUpdated, self.extension.collectionUpdated);
    XCTAssertEqualObjects(newExtension.display, self.extension.display);
    XCTAssertEqualObjects(newExtension.followingInStream, self.extension.followingInStream);
    XCTAssertEqualObjects(newExtension.iconCss, self.extension.iconCss);
    XCTAssertEqualObjects(newExtension.likeCount, self.extension.likeCount);
    XCTAssertEqualObjects(newExtension.liked, self.extension.liked);
    XCTAssertEqualObjects(newExtension.mentioned.jiveId, self.extension.mentioned.jiveId);
    XCTAssertEqualObjects(newExtension.mentioned.canComment, self.extension.mentioned.canComment);
    XCTAssertEqualObjects(newExtension.mentioned.canReply, self.extension.mentioned.canReply);
    XCTAssertEqualObjects(newExtension.objectID, self.extension.objectID);
    XCTAssertEqualObjects(newExtension.objectType, self.extension.objectType);
    XCTAssertEqualObjects(newExtension.onBehalfOf.email, self.extension.onBehalfOf.email);
    XCTAssertEqualObjects(newExtension.onBehalfOf.person.displayName,
                         self.extension.onBehalfOf.person.displayName);
    XCTAssertEqualObjects(newExtension.outcomeComment, self.extension.outcomeComment);
    XCTAssertEqualObjects(newExtension.outcomeTypeName, self.extension.outcomeTypeName);
    XCTAssertEqualObjects(newExtension.parent.jiveId, self.extension.parent.jiveId);
    XCTAssertEqualObjects(newExtension.parent.canReply, self.extension.parent.canReply);
    XCTAssertEqualObjects(newExtension.parent.updated, self.extension.parent.updated);
    XCTAssertEqualObjects(newExtension.parentActor.jiveId, self.extension.parentActor.jiveId);
    XCTAssertEqualObjects(newExtension.parentActor.canComment, self.extension.parentActor.canComment);
    XCTAssertEqualObjects(newExtension.parentActor.updated, self.extension.parentActor.updated);
    XCTAssertEqualObjects(newExtension.parentLikeCount, self.extension.parentLikeCount);
    XCTAssertEqualObjects(newExtension.parentLiked, self.extension.parentLiked);
    XCTAssertEqualObjects(newExtension.parentOnBehalfOf.email, self.extension.parentOnBehalfOf.email);
    XCTAssertEqualObjects(newExtension.parentOnBehalfOf.person.displayName,
                         self.extension.parentOnBehalfOf.person.displayName);
    XCTAssertEqualObjects(newExtension.parentReplyCount, self.extension.parentReplyCount);
    XCTAssertEqualObjects(newExtension.question, self.extension.question);
    XCTAssertEqualObjects(newExtension.read, self.extension.read);
    XCTAssertEqualObjects(newExtension.replyCount, self.extension.replyCount);
    XCTAssertEqualObjects(newExtension.resolved, self.extension.resolved);
    XCTAssertEqualObjects(newExtension.state, self.extension.state);
    XCTAssertEqualObjects([newExtension.update absoluteString],
                         [self.extension.update absoluteString]);
    XCTAssertEqualObjects([newExtension.updateCollection absoluteString],
                         [self.extension.updateCollection absoluteString]);
    XCTAssertEqualObjects(newExtension.via.displayName, self.extension.via.displayName);
    XCTAssertEqualObjects([newExtension.productIcon absoluteString],
                         [self.extension.productIcon absoluteString]);
    XCTAssertEqualObjects(newExtension.imagesCount, self.extension.imagesCount);
    XCTAssertEqualObjects(newExtension.objectViewed, self.extension.objectViewed);
}

@end
