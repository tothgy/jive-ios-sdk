//
//  JiveDiscussonTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
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

#import "JiveDiscussionTests.h"
#import "JiveVia.h"


@implementation JiveDiscussionTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveDiscussion alloc] init];
}

- (JiveDiscussion *)discussion {
    return (JiveDiscussion *)self.categorizedContent;
}

- (void)testType {
    XCTAssertEqualObjects(self.discussion.type, @"discussion", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.discussion.type
                                                                            forKey:JiveTypedObjectAttributes.type];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.discussion class], @"Discussion class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.discussion class], @"Discussion class not registered with JiveContent.");
}

- (void)initializeDiscussion {
    JiveAttachment *attachment = [JiveAttachment new];
    JiveGenericPerson *person = [JiveGenericPerson new];
    JiveVia *via = [JiveVia new];
    
    attachment.contentType = @"doc";
    [attachment setValue:@50 forKey:JiveAttachmentAttributes.size];
    person.name = @"dummy";
    via.displayName = @"via…";
    self.discussion.answer = @"answer";
    self.discussion.attachments = @[attachment];
    self.discussion.helpful = @[@"not very"];
    self.discussion.onBehalfOf = person;
    self.discussion.question = @YES;
    self.discussion.resolved = JiveDiscussionResolvedState.open;
    [self.discussion setValue:@YES forKey:JiveDiscussionAttributes.restrictReplies];
    self.discussion.via = via;
    
}

- (void)initializeAlternateDiscussion {
    JiveAttachment *attachment = [JiveAttachment new];
    JiveGenericPerson *person = [JiveGenericPerson new];
    JivePerson *user = [JivePerson new];
    JiveVia *via = [JiveVia new];
    
    attachment.contentType = @"firework";
    [attachment setValue:@1000 forKey:JiveAttachmentAttributes.size];
    [person setValue:user forKey:JiveGenericPersonAttributes.person];
    user.location = @"location";
    [user setValue:@"no name" forKey:JivePersonAttributes.displayName];
    via.displayName = @"Henry";
    self.discussion.answer = @"/person/12345";
    self.discussion.attachments = @[attachment];
    self.discussion.helpful = @[@"/person/54321"];
    self.discussion.onBehalfOf = person;
    self.discussion.question = @YES;
    self.discussion.resolved = JiveDiscussionResolvedState.resolved;
    self.discussion.via = via;
}

- (void)testDiscussionToJSON {
    NSDictionary *JSON = [self.discussion toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"discussion", @"Wrong type");
    
    [self initializeDiscussion];
    
    JSON = [self.discussion toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.discussion.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveDiscussionAttributes.answer], self.discussion.answer, @"Wrong answer");
    XCTAssertEqualObjects(JSON[JiveDiscussionAttributes.resolved], self.discussion.resolved, @"Wrong resolved");
    
    NSArray *attachmentsJSON = JSON[JiveDiscussionAttributes.attachments];
    NSDictionary *attachmentJSON = attachmentsJSON.lastObject;
    
    XCTAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([attachmentsJSON count], (NSUInteger)1, @"Attachments array had the wrong number of entries");
    XCTAssertTrue([[attachmentJSON class] isSubclassOfClass:[NSDictionary class]], @"JiveAttachment not converted");
    XCTAssertEqual([attachmentJSON count], (NSUInteger)2, @"Attachment dictionary had the wrong number of entries");
    XCTAssertEqualObjects(attachmentJSON[JiveAttachmentAttributes.contentType],
                         ((JiveAttachment *)self.discussion.attachments[0]).contentType, @"Wrong contentType");
    
    NSArray *helpfulJSON = JSON[JiveDiscussionAttributes.helpful];
    
    XCTAssertTrue([[helpfulJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([helpfulJSON count], (NSUInteger)1, @"Helpful array had the wrong number of entries");
    XCTAssertEqualObjects([helpfulJSON objectAtIndex:0], self.discussion.helpful[0], @"Wrong value");
    
    NSDictionary *onBehalfOfJSON = JSON[JiveDiscussionAttributes.onBehalfOf];
    
    XCTAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"JiveGenericPerson not converted");
    XCTAssertEqual([onBehalfOfJSON count], (NSUInteger)1, @"onBehalfOf array had the wrong number of entries");
    XCTAssertEqualObjects(onBehalfOfJSON[JiveGenericPersonAttributes.name],
                         self.discussion.onBehalfOf.name, @"Wrong value");
    
    NSDictionary *viaJSON = JSON[JiveDiscussionAttributes.via];
    
    XCTAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]], @"JiveGenericPerson not converted");
    XCTAssertEqual([viaJSON count], (NSUInteger)1, @"Via array had the wrong number of entries");
    XCTAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.discussion.via.displayName, @"Wrong value");
}

- (void)testDiscussionToJSON_alternate {
    [self initializeAlternateDiscussion];
    
    NSDictionary *JSON = [self.discussion toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.discussion.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveDiscussionAttributes.answer], self.discussion.answer, @"Wrong answer");
    XCTAssertEqualObjects(JSON[JiveDiscussionAttributes.resolved], self.discussion.resolved, @"Wrong resolved");
    XCTAssertEqual([JSON[JiveDiscussionAttributes.question] boolValue],
                   [self.discussion isAQuestion], @"Wrong question value");
    
    NSArray *attachmentsJSON = JSON[JiveDiscussionAttributes.attachments];
    NSDictionary *attachmentJSON = attachmentsJSON.lastObject;
    
    XCTAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([attachmentsJSON count], (NSUInteger)1, @"Attachments array had the wrong number of entries");
    XCTAssertTrue([[attachmentJSON class] isSubclassOfClass:[NSDictionary class]], @"JiveAttachment not converted");
    XCTAssertEqual([attachmentJSON count], (NSUInteger)2, @"Attachment dictionary had the wrong number of entries");
    XCTAssertEqualObjects(attachmentJSON[JiveAttachmentAttributes.contentType],
                         ((JiveAttachment *)self.discussion.attachments[0]).contentType, @"Wrong contentType");
    
    NSArray *helpfulJSON = JSON[JiveDiscussionAttributes.helpful];
    
    XCTAssertTrue([[helpfulJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([helpfulJSON count], (NSUInteger)1, @"Helpful array had the wrong number of entries");
    XCTAssertEqualObjects([helpfulJSON objectAtIndex:0], self.discussion.helpful[0], @"Wrong value");
    
    NSDictionary *onBehalfOfJSON = JSON[JiveDiscussionAttributes.onBehalfOf];
    
    XCTAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"JiveGenericPerson not converted");
    XCTAssertEqual([onBehalfOfJSON count], (NSUInteger)0, @"onBehalfOf array had the wrong number of entries");
    
    NSDictionary *viaJSON = JSON[JiveDiscussionAttributes.via];
    
    XCTAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]], @"JiveGenericPerson not converted");
    XCTAssertEqual([viaJSON count], (NSUInteger)1, @"Via array had the wrong number of entries");
    XCTAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.discussion.via.displayName, @"Wrong value");
}

- (void)testDiscussionToJSON_boolProperties {
    self.discussion.question = @YES;
    
    NSDictionary *JSON = [self.discussion persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.discussion.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveDiscussionAttributes.question], self.discussion.question, @"Wrong question");
    
    [self.discussion setValue:@YES forKeyPath:JiveDiscussionAttributes.restrictReplies];
    JSON = [self.discussion persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.discussion.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveDiscussionAttributes.question], self.discussion.question, @"Wrong question");
    XCTAssertEqualObjects(JSON[JiveDiscussionAttributes.restrictReplies],
                         self.discussion.restrictReplies, @"Wrong restrictReplies");
    
    self.discussion.question = nil;
    JSON = [self.discussion persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.discussion.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveDiscussionAttributes.restrictReplies],
                         self.discussion.restrictReplies, @"Wrong restrictReplies");
}

- (void)testToJSON_attachments {
    JiveAttachment *attachment1 = [JiveAttachment new];
    JiveAttachment *attachment2 = [JiveAttachment new];
    
    attachment1.contentType = @"doc";
    attachment2.contentType = @"firework";
    [self.discussion setValue:[NSArray arrayWithObject:attachment1]
                       forKey:JiveDiscussionAttributes.attachments];
    
    NSDictionary *JSON = [self.discussion toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.discussion.type, @"Wrong type");
    
    NSArray *array = JSON[JiveDiscussionAttributes.attachments];
    id object1 = [array objectAtIndex:0];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JiveAttachmentAttributes.contentType],
                         attachment1.contentType, @"Wrong value");
    
    [self.discussion setValue:[self.discussion.attachments arrayByAddingObject:attachment2]
                       forKey:JiveDiscussionAttributes.attachments];
    
    JSON = [self.discussion toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.discussion.type, @"Wrong type");
    
    array = JSON[JiveDiscussionAttributes.attachments];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JiveAttachmentAttributes.contentType],
                         attachment1.contentType, @"Wrong value 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:JiveAttachmentAttributes.contentType],
                         attachment2.contentType, @"Wrong value 2");
}

- (void)testDiscussionParsing {
    [self initializeDiscussion];
    
    self.discussion.users = nil;
    id JSON = [self.discussion persistentJSON];
    JiveDiscussion *newContent = [JiveDiscussion objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.discussion class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.discussion.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.answer, self.discussion.answer, @"Wrong answer");
    XCTAssertEqualObjects(newContent.onBehalfOf.name, self.discussion.onBehalfOf.name, @"Wrong onBehalfOf");
    XCTAssertEqualObjects(newContent.question, self.discussion.question, @"Wrong question");
    XCTAssertEqualObjects(newContent.resolved, self.discussion.resolved, @"Wrong resolved");
    XCTAssertEqualObjects(newContent.restrictReplies, self.discussion.restrictReplies, @"Wrong restrictReplies");
    XCTAssertEqualObjects(newContent.via.displayName, self.discussion.via.displayName, @"Wrong via");
    XCTAssertEqual([newContent.helpful count], [self.discussion.helpful count], @"Wrong helpful count");
    XCTAssertEqualObjects(newContent.helpful[0], self.discussion.helpful[0], @"Wrong helpful");
    
    XCTAssertEqual([newContent.attachments count], [self.discussion.attachments count], @"Wrong number of user objects");
    if ([newContent.attachments count] > 0) {
        JiveAttachment *convertedAttachment = newContent.attachments[0];
        XCTAssertEqual([convertedAttachment class], [JiveAttachment class], @"Wrong attachment class");
        if ([[convertedAttachment class] isSubclassOfClass:[JiveAttachment class]]) {
            XCTAssertEqualObjects(convertedAttachment.contentType,
                                 ((JiveAttachment *)self.discussion.attachments[0]).contentType, @"Wrong attachment");
            XCTAssertEqualObjects(convertedAttachment.size,
                                 ((JiveAttachment *)self.discussion.attachments[0]).size, @"Wrong attachment");
        }
    }
}

- (void)testDiscussionParsing_alternate {
    [self initializeAlternateDiscussion];
    
    id JSON = [self.discussion persistentJSON];
    JiveDiscussion *newContent = [JiveDiscussion objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.discussion class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.discussion.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.answer, self.discussion.answer, @"Wrong answer");
    XCTAssertEqualObjects(newContent.onBehalfOf.person.displayName,
                         self.discussion.onBehalfOf.person.displayName, @"Wrong onBehalfOf");
    XCTAssertEqualObjects(newContent.question, self.discussion.question, @"Wrong question");
    XCTAssertEqualObjects(newContent.resolved, self.discussion.resolved, @"Wrong resolved");
    XCTAssertEqualObjects(newContent.restrictReplies, self.discussion.restrictReplies, @"Wrong restrictReplies");
    XCTAssertEqualObjects(newContent.via.displayName, self.discussion.via.displayName, @"Wrong via");
    XCTAssertEqual([newContent.helpful count], [self.discussion.helpful count], @"Wrong helpful count");
    XCTAssertEqualObjects(newContent.helpful[0], self.discussion.helpful[0], @"Wrong helpful");
    
    XCTAssertEqual([newContent.attachments count], [self.discussion.attachments count], @"Wrong number of user objects");
    if ([newContent.attachments count] > 0) {
        JiveAttachment *convertedAttachment = newContent.attachments[0];
        XCTAssertEqual([convertedAttachment class], [JiveAttachment class], @"Wrong attachment class");
        if ([[convertedAttachment class] isSubclassOfClass:[JiveAttachment class]]) {
            XCTAssertEqualObjects(convertedAttachment.contentType,
                                 ((JiveAttachment *)self.discussion.attachments[0]).contentType, @"Wrong attachment");
            XCTAssertEqualObjects(convertedAttachment.size,
                                 ((JiveAttachment *)self.discussion.attachments[0]).size, @"Wrong attachment");
        }
    }
}

- (void)testDiscussionWithOnlyAnswerAndHelpful {
    NSString *answer = @"http://example.com/answer";
    NSString *helpful1 = @"http://example.com/helpful/1";
    NSString *helpful2 = @"http://example.com/helpful/2";
    
    id JSON = (@{
               @"answer" : answer,
               @"helpful" : (@[
                             helpful1,
                             helpful2,
                             ]),
               JiveTypedObjectAttributes.type : @"discussion",
               });
    
    JiveDiscussion *discussion = [JiveDiscussion objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqualObjects([discussion class], [JiveDiscussion class]);
    XCTAssertEqualObjects(discussion.answer, answer);
    XCTAssertEqualObjects(discussion.helpful, (@[helpful1, helpful2]));
}

@end
