//
//  JiveDocumentTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
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

#import "JiveDocumentTests.h"
#import "JivePerson.h"
#import "JiveAttachment.h"
#import "JiveOutcomeType.h"

@implementation JiveDocumentTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveDocument alloc] init];
}

- (JiveDocument *)document {
    return (JiveDocument *)self.authorableContent;
}

- (void)testType {
    XCTAssertEqualObjects(self.document.type, @"document", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.document.type forKey:@"type"];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.document class],
                         @"Document class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.document class],
                         @"Document class not registered with JiveContent.");
}

- (void)initializeDocument {
    JiveAttachment *attachment = [JiveAttachment new];
    JivePerson *approver = [JivePerson new];
    JivePerson *editor = [JivePerson new];
    JivePerson *updater = [JivePerson new];
    
    attachment.contentType = @"person";
    [attachment setValue:@55 forKey:JiveAttachmentAttributes.size];
    approver.location = @"Tower";
    [approver setValue:approver.location forKey:JivePersonAttributes.displayName];
    editor.location = @"Spire";
    [editor setValue:editor.location forKey:JivePersonAttributes.displayName];
    updater.location = @"cloud";
    [updater setValue:updater.location forKey:JivePersonAttributes.displayName];
    self.document.approvers = @[approver];
    self.document.attachments = @[attachment];
    [self.document setValue:editor forKey:JiveDocumentAttributes.editingBy];
    self.document.fromQuest = @"fromQuest";
    self.document.restrictComments = @YES;
    [self.document setValue:updater forKey:JiveDocumentAttributes.updater];
}

- (void)initializeAlternateDocument {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    JivePerson *approver = [[JivePerson alloc] init];
    JivePerson *editor = [JivePerson new];
    JivePerson *updater = [JivePerson new];
    
    attachment.contentType = @"place";
    [attachment setValue:@938272 forKey:JiveAttachmentAttributes.size];
    approver.location = @"Restaurant";
    [approver setValue:approver.location forKey:JivePersonAttributes.displayName];
    editor.location = @"Elevator";
    [editor setValue:editor.location forKey:JivePersonAttributes.displayName];
    updater.location = @"Taxi";
    [updater setValue:updater.location forKey:JivePersonAttributes.displayName];
    self.document.approvers = @[approver];
    self.document.attachments = @[attachment];
    [self.document setValue:editor forKey:JiveDocumentAttributes.editingBy];
    self.document.fromQuest = @"toAnyone";
    [self.document setValue:updater forKey:JiveDocumentAttributes.updater];
}

- (void)testDocumentToJSON {
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], @"document", @"Wrong type");
    
    [self initializeDocument];
    
    JSON = [self.document toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.fromQuest],
                         self.document.fromQuest, @"Wrong fromQuest");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveDocumentAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    XCTAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.contentType],
                         ((JiveAttachment *)self.document.attachments[0]).contentType, @"Wrong value");
    
    NSArray *approversJSON = [JSON objectForKey:JiveDocumentAttributes.approvers];
    NSDictionary *approverJSON = [approversJSON objectAtIndex:0];
    
    XCTAssertTrue([[approversJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([approversJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([approverJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.document.approvers[0]).location, @"Wrong value");
}

- (void)testDocumentToJSON_alternate {
    [self initializeAlternateDocument];

    NSDictionary *JSON = [self.document toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.fromQuest],
                         self.document.fromQuest, @"Wrong fromQuest");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrictComments");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveDocumentAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    XCTAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.contentType],
                         ((JiveAttachment *)self.document.attachments[0]).contentType, @"Wrong value");
    
    NSArray *approversJSON = [JSON objectForKey:JiveDocumentAttributes.approvers];
    NSDictionary *approverJSON = [approversJSON objectAtIndex:0];
    
    XCTAssertTrue([[approversJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([approversJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([approverJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.document.approvers[0]).location, @"Wrong value");
}

- (void)testDocumentPersistentJSON_boolProperties {
    self.document.restrictComments = @YES;
    
    NSDictionary *JSON = [self.document persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrictComments");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibleToExternalContributors],
                         self.document.visibleToExternalContributors,
                         @"Wrong visibleToExternalContributors");

    [self.document setValue:@YES forKey:JiveDocumentAttributes.visibleToExternalContributors];
    JSON = [self.document persistentJSON];
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrictComments");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibleToExternalContributors],
                         self.document.visibleToExternalContributors,
                         @"Wrong visibleToExternalContributors");

    self.document.restrictComments = @NO;
    JSON = [self.document persistentJSON];
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrictComments");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibleToExternalContributors],
                         self.document.visibleToExternalContributors,
                         @"Wrong visibleToExternalContributors");
}

- (void)testToJSON_attachments {
    JiveAttachment *attachment1 = [[JiveAttachment alloc] init];
    JiveAttachment *attachment2 = [[JiveAttachment alloc] init];
    
    attachment1.contentType = @"document";
    attachment2.contentType = @"question";
    [self.document setValue:[NSArray arrayWithObject:attachment1]
                     forKey:JiveDocumentAttributes.attachments];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveDocumentAttributes.attachments];
    id object1 = [array objectAtIndex:0];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JiveAttachmentAttributes.contentType], attachment1.contentType, @"Wrong value");
    
    [self.document setValue:[self.document.attachments arrayByAddingObject:attachment2]
                     forKey:JiveDocumentAttributes.attachments];
    
    JSON = [self.document toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveDocumentAttributes.attachments];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JiveAttachmentAttributes.contentType], attachment1.contentType, @"Wrong value 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:JiveAttachmentAttributes.contentType], attachment2.contentType, @"Wrong value 2");
}

- (void)testToJSON_approvers {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"location";
    person2.location = @"Tower";
    [self.document setValue:[NSArray arrayWithObject:person1]
                     forKey:JiveDocumentAttributes.approvers];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveDocumentAttributes.approvers];
    id object1 = [array objectAtIndex:0];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"approvers array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.document setValue:[self.document.approvers arrayByAddingObject:person2]
                     forKey:JiveDocumentAttributes.approvers];
    
    JSON = [self.document toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveDocumentAttributes.approvers];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"approvers array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testDocumentPersistentJSON {
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], @"document", @"Wrong type");
    
    [self initializeDocument];
    
    JSON = [self.document persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.authorship],
                         self.document.authorship, @"Wrong authorship");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.fromQuest],
                         self.document.fromQuest, @"Wrong fromQuest");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrict comments");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibility],
                         self.document.visibility, @"Wrong visibility");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveDocumentAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    XCTAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.contentType],
                         ((JiveAttachment *)self.document.attachments[0]).contentType, @"Wrong value");
    XCTAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.size],
                         ((JiveAttachment *)self.document.attachments[0]).size, @"Wrong size");
    
    NSArray *approversJSON = [JSON objectForKey:JiveDocumentAttributes.approvers];
    NSDictionary *approverJSON = [approversJSON objectAtIndex:0];
    
    XCTAssertTrue([[approversJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([approversJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([approverJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.document.approvers[0]).location, @"Wrong value");
    XCTAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.displayName],
                         ((JivePerson *)self.document.approvers[0]).displayName, @"Wrong display name");
    
    NSDictionary *editorJSON = [JSON objectForKey:JiveDocumentAttributes.editingBy];
    
    XCTAssertTrue([[editorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([editorJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([editorJSON objectForKey:JivePersonAttributes.location],
                         self.document.editingBy.location, @"Wrong value");
    XCTAssertEqualObjects([editorJSON objectForKey:JivePersonAttributes.displayName],
                         self.document.editingBy.displayName, @"Wrong display name");
    
    NSDictionary *updaterJSON = [JSON objectForKey:JiveDocumentAttributes.updater];
    
    XCTAssertTrue([[updaterJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([updaterJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([updaterJSON objectForKey:JivePersonAttributes.location],
                         self.document.updater.location,
                         @"Wrong value");
    XCTAssertEqualObjects([updaterJSON objectForKey:JivePersonAttributes.displayName],
                         self.document.updater.displayName, @"Wrong display name");
}

- (void)testDocumentPersistentJSON_alternate {
    [self initializeAlternateDocument];
    
    NSDictionary *JSON = [self.document persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.authorship],
                         self.document.authorship, @"Wrong authorship");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.fromQuest],
                         self.document.fromQuest, @"Wrong fromQuest");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrict comments");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibility],
                         self.document.visibility, @"Wrong visibility");
    XCTAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrictComments");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveDocumentAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    XCTAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.contentType],
                         ((JiveAttachment *)self.document.attachments[0]).contentType, @"Wrong value");
    XCTAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.size],
                         ((JiveAttachment *)self.document.attachments[0]).size, @"Wrong size");
    
    NSArray *approversJSON = [JSON objectForKey:JiveDocumentAttributes.approvers];
    NSDictionary *approverJSON = [approversJSON objectAtIndex:0];
    
    XCTAssertTrue([[approversJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([approversJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([approverJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.document.approvers[0]).location, @"Wrong value");
    XCTAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.displayName],
                         ((JivePerson *)self.document.approvers[0]).displayName, @"Wrong display name");
    
    NSDictionary *editorJSON = [JSON objectForKey:JiveDocumentAttributes.editingBy];
    
    XCTAssertTrue([[editorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([editorJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([editorJSON objectForKey:JivePersonAttributes.location],
                         self.document.editingBy.location,
                         @"Wrong value");
    XCTAssertEqualObjects([editorJSON objectForKey:JivePersonAttributes.displayName],
                         self.document.editingBy.displayName, @"Wrong display name");
    
    NSDictionary *updaterJSON = [JSON objectForKey:JiveDocumentAttributes.updater];
    
    XCTAssertTrue([[updaterJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([updaterJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([updaterJSON objectForKey:JivePersonAttributes.location],
                         self.document.updater.location,
                         @"Wrong value");
    XCTAssertEqualObjects([updaterJSON objectForKey:JivePersonAttributes.displayName],
                         self.document.updater.displayName, @"Wrong display name");
}

- (void)testDocumentParsing {
    [self initializeDocument];
    
    id JSON = [self.document persistentJSON];
    JiveDocument *newContent = [JiveDocument objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.document class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.document.type, @"Wrong type");
    XCTAssertEqual([newContent.approvers count], [self.document.approvers count], @"Wrong number of approver objects");
    XCTAssertEqual([newContent.attachments count], [self.document.attachments count], @"Wrong number of attachment objects");
    XCTAssertEqualObjects(newContent.editingBy.location,
                         self.document.editingBy.location, @"Wrong editor");
    XCTAssertEqualObjects(newContent.fromQuest, self.document.fromQuest, @"Wrong fromQuest");
    XCTAssertEqualObjects(newContent.updater.location,
                         self.document.updater.location, @"Wrong updater");

    if ([newContent.approvers count] > 0) {
        id convertedObject = [newContent.approvers objectAtIndex:0];
        XCTAssertEqual([convertedObject class], [JivePerson class], @"Wrong approver object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([(JivePerson *)convertedObject location],
                         ((JivePerson *)self.document.approvers[0]).location, @"Wrong approver object");
    }
    
    if ([newContent.attachments count] > 0) {
        id convertedObject = [newContent.attachments objectAtIndex:0];
        XCTAssertEqual([convertedObject class], [JiveAttachment class], @"Wrong attachment object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveAttachment class]])
            XCTAssertEqualObjects([(JiveAttachment *)convertedObject contentType],
                                 ((JiveAttachment *)self.document.attachments[0]).contentType, @"Wrong attachment object");
    }
}

- (void)testDocumentParsingAlternate {
    [self initializeAlternateDocument];
    
    id JSON = [self.document persistentJSON];
    JiveDocument *newContent = [JiveDocument objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.document class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.document.type, @"Wrong type");
    XCTAssertEqual([newContent.approvers count], [self.document.approvers count], @"Wrong number of approver objects");
    XCTAssertEqual([newContent.attachments count], [self.document.attachments count], @"Wrong number of attachment objects");
    XCTAssertEqualObjects(newContent.editingBy.location,
                         self.document.editingBy.location, @"Wrong editor");
    XCTAssertEqualObjects(newContent.fromQuest, self.document.fromQuest, @"Wrong fromQuest");
    XCTAssertEqualObjects(newContent.updater.location, self.document.updater.location, @"Wrong updater");
    
    if ([newContent.approvers count] > 0) {
        id convertedObject = [newContent.approvers objectAtIndex:0];
        XCTAssertEqual([convertedObject class], [JivePerson class], @"Wrong approver object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([(JivePerson *)convertedObject location],
                         ((JivePerson *)self.document.approvers[0]).location, @"Wrong approver object");
    }
    
    if ([newContent.attachments count] > 0) {
        id convertedObject = [newContent.attachments objectAtIndex:0];
        XCTAssertEqual([convertedObject class], [JiveAttachment class], @"Wrong attachment object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveAttachment class]])
            XCTAssertEqualObjects([(JiveAttachment *)convertedObject contentType],
                                 ((JiveAttachment *)self.document.attachments[0]).contentType, @"Wrong attachment object");
    }
}

@end
