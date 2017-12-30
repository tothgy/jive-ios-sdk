//
//  JiveMessageTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/27/12.
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

#import "JiveMessageTests.h"
#import "JiveAttachment.h"
#import "JiveOutcomeType.h"
#import "JiveVia.h"

@implementation JiveMessageTests

- (void)setUp {
    [super setUp];
    self.object = [JiveMessage new];
}

- (JiveMessage *)message {
    return (JiveMessage *)self.content;
}

- (void)testType {
    XCTAssertEqualObjects(self.message.type, @"message", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.message.type
                                                                            forKey:JiveTypedObjectAttributes.type];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.message class], @"Message class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.message class], @"Message class not registered with JiveContent.");
}

- (void)initializeMessage {
    JiveAttachment *attachment = [JiveAttachment new];
    JiveGenericPerson *onBehalfOf = [JiveGenericPerson new];
    JiveVia *via = [JiveVia new];
    
    attachment.contentType = @"person";
    [attachment setValue:@55 forKeyPath:JiveAttachmentAttributes.size];
    onBehalfOf.name = @"fred";
    via.displayName = @"george";
    self.message.attachments = @[attachment];
    [self.message setValue:@"/person/5432" forKey:JiveMessageAttributes.discussion];
    self.message.fromQuest = @"ring";
    self.message.helpful = @YES;
    self.message.onBehalfOf = onBehalfOf;
    self.message.via = via;
}

- (void)initializeAlternateMessage {
    JiveAttachment *attachment = [JiveAttachment new];
    JivePerson *henry = [JivePerson new];
    JiveGenericPerson *onBehalfOf = [JiveGenericPerson new];
    JiveVia *via = [JiveVia new];
    
    attachment.contentType = @"place";
    [attachment setValue:@294812 forKeyPath:JiveAttachmentAttributes.size];
    [henry setValue:@"henry" forKeyPath:JivePersonAttributes.displayName];
    [onBehalfOf setValue:henry forKeyPath:JiveGenericPersonAttributes.person];
    via.displayName = @"george";
    self.message.attachments = @[attachment];
    [self.message setValue:@"/place/123456" forKey:JiveMessageAttributes.discussion];
    self.message.answer = @YES;
    self.message.fromQuest = @"sword";
    self.message.onBehalfOf = onBehalfOf;
    self.message.via = via;
}

- (void)testMessageToJSON {
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"message", @"Wrong type");
    
    [self initializeMessage];
    
    JSON = [self.message toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.helpful], self.message.helpful, @"Wrong helpful flag");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.fromQuest], self.message.fromQuest, @"Wrong fromQuest");
    
    NSArray *attachmentsJSON = JSON[JiveMessageAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    XCTAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(itemJSON[JiveAttachmentAttributes.contentType],
                         ((JiveAttachment *)self.message.attachments[0]).contentType,
                         @"Wrong value");
    
    NSDictionary *onBehalfOfJSON = JSON[JiveMessageAttributes.onBehalfOf];
    
    XCTAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(onBehalfOfJSON[JiveGenericPersonAttributes.name],
                         self.message.onBehalfOf.name, @"Wrong value");
    
    NSDictionary *viaJSON = JSON[JiveMessageAttributes.via];
    
    XCTAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([viaJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.message.via.displayName, @"Wrong value");
}

- (void)testMessageToJSON_alternate {
    [self initializeAlternateMessage];
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.answer], self.message.answer, @"Wrong answer flag");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.fromQuest], self.message.fromQuest, @"Wrong fromQuest");
    
    NSArray *attachmentsJSON = JSON[JiveMessageAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    XCTAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(itemJSON[JiveAttachmentAttributes.contentType],
                         ((JiveAttachment *)self.message.attachments[0]).contentType,
                         @"Wrong value");
    
    NSDictionary *onBehalfOfJSON = JSON[JiveMessageAttributes.onBehalfOf];
    
    XCTAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([onBehalfOfJSON count], (NSUInteger)0, @"Jive dictionary had the wrong number of entries");
    
    NSDictionary *viaJSON = JSON[JiveMessageAttributes.via];
    
    XCTAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([viaJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.message.via.displayName, @"Wrong value");
}

- (void)testMessagePersistentJSON {
    NSDictionary *JSON = [self.message persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"message", @"Wrong type");
    
    [self initializeMessage];
    
    JSON = [self.message persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.helpful], self.message.helpful, @"Wrong helpful flag");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.fromQuest], self.message.fromQuest, @"Wrong fromQuest");
    
    NSArray *attachmentsJSON = JSON[JiveMessageAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    XCTAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(itemJSON[JiveAttachmentAttributes.contentType],
                         ((JiveAttachment *)self.message.attachments[0]).contentType,
                         @"Wrong value");
    XCTAssertEqualObjects(itemJSON[JiveAttachmentAttributes.size],
                         ((JiveAttachment *)self.message.attachments[0]).size,
                         @"Wrong value");
    
    NSDictionary *onBehalfOfJSON = JSON[JiveMessageAttributes.onBehalfOf];
    
    XCTAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(onBehalfOfJSON[JiveGenericPersonAttributes.name],
                         self.message.onBehalfOf.name, @"Wrong value");
    
    NSDictionary *viaJSON = JSON[JiveMessageAttributes.via];
    
    XCTAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([viaJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.message.via.displayName, @"Wrong value");
}

- (void)testMessagePersistentJSON_alternate {
    [self initializeAlternateMessage];
    
    NSDictionary *JSON = [self.message persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.answer], self.message.answer, @"Wrong answer flag");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.fromQuest], self.message.fromQuest, @"Wrong fromQuest");
    
    NSArray *attachmentsJSON = JSON[JiveMessageAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    XCTAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(itemJSON[JiveAttachmentAttributes.contentType],
                         ((JiveAttachment *)self.message.attachments[0]).contentType,
                         @"Wrong value");
    XCTAssertEqualObjects(itemJSON[JiveAttachmentAttributes.size],
                         ((JiveAttachment *)self.message.attachments[0]).size,
                         @"Wrong value");
    
    NSDictionary *onBehalfOfJSON = JSON[JiveMessageAttributes.onBehalfOf];
    
    XCTAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    
    NSDictionary *viaJSON = JSON[JiveMessageAttributes.via];
    
    XCTAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([viaJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.message.via.displayName, @"Wrong value");
}

- (void)testMessageToJSON_helpful {
    self.message.helpful = @YES;
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.helpful], self.message.helpful, @"Wrong helpful");
}

- (void)testMessageToJSON_boolProperties {
    self.message.answer = @YES;
    self.message.helpful = @YES;
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.answer], self.message.answer, @"Wrong answer");
    XCTAssertEqualObjects(JSON[JiveMessageAttributes.helpful], self.message.helpful, @"Wrong helpful");
}

- (void)testToJSON_attachments {
    JiveAttachment *attachment1 = [JiveAttachment new];
    JiveAttachment *attachment2 = [JiveAttachment new];
    
    attachment1.contentType = @"message";
    attachment2.contentType = @"question";
    [self.message setValue:@[attachment1] forKey:JiveMessageAttributes.attachments];
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    
    NSArray *addressJSON = JSON[JiveMessageAttributes.attachments];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    XCTAssertEqualObjects(object1[JiveAttachmentAttributes.contentType], attachment1.contentType, @"Wrong value");
    
    [self.message setValue:[self.message.attachments arrayByAddingObject:attachment2]
                    forKey:JiveMessageAttributes.attachments];
    
    JSON = [self.message toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    
    addressJSON = JSON[JiveMessageAttributes.attachments];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    XCTAssertEqualObjects(object1[JiveAttachmentAttributes.contentType], attachment1.contentType, @"Wrong value 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    XCTAssertEqualObjects(object2[JiveAttachmentAttributes.contentType], attachment2.contentType, @"Wrong value 2");
}

- (void)testMessageParsing {
    [self initializeMessage];
   
    id JSON = [self.message persistentJSON];
    JiveMessage *newContent = [JiveMessage objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.message class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.message.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.answer, self.message.answer, @"Wrong answer");
    XCTAssertEqual([newContent.attachments count], [self.message.attachments count], @"Wrong number of attachment objects");
    XCTAssertEqualObjects(((JiveAttachment *)newContent.attachments[0]).contentType,
                         ((JiveAttachment *)self.message.attachments[0]).contentType,
                         @"Wrong attachment object");
    XCTAssertEqualObjects(((JiveAttachment *)newContent.attachments[0]).size,
                         ((JiveAttachment *)self.message.attachments[0]).size,
                         @"Wrong attachment object");
    XCTAssertEqualObjects(newContent.discussion, self.message.discussion, @"Wrong discussion");
    XCTAssertEqualObjects(newContent.fromQuest, self.message.fromQuest, @"Wrong fromQuest");
    XCTAssertEqualObjects(newContent.helpful, self.message.helpful, @"Wrong helpful");
    XCTAssertEqualObjects(newContent.onBehalfOf.name, self.message.onBehalfOf.name, @"Wrong onBehalfOf");
    XCTAssertEqualObjects(newContent.via.displayName, self.message.via.displayName, @"Wrong via");
}

- (void)testMessageParsingAlternate {
    [self initializeAlternateMessage];
    
    id JSON = [self.message persistentJSON];
    JiveMessage *newContent = [JiveMessage objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.message class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.message.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.answer, self.message.answer, @"Wrong answer");
    XCTAssertEqual([newContent.attachments count], [self.message.attachments count], @"Wrong number of attachment objects");
    XCTAssertEqualObjects(((JiveAttachment *)newContent.attachments[0]).contentType,
                         ((JiveAttachment *)self.message.attachments[0]).contentType,
                         @"Wrong attachment object");
    XCTAssertEqualObjects(((JiveAttachment *)newContent.attachments[0]).size,
                         ((JiveAttachment *)self.message.attachments[0]).size,
                         @"Wrong attachment object");
    XCTAssertEqualObjects(newContent.discussion, self.message.discussion, @"Wrong discussion");
    XCTAssertEqualObjects(newContent.fromQuest, self.message.fromQuest, @"Wrong fromQuest");
    XCTAssertEqualObjects(newContent.helpful, self.message.helpful, @"Wrong helpful");
    XCTAssertEqualObjects(newContent.onBehalfOf.person.displayName,
                         self.message.onBehalfOf.person.displayName, @"Wrong onBehalfOf");
    XCTAssertEqualObjects(newContent.via.displayName, self.message.via.displayName, @"Wrong via");
}

@end
