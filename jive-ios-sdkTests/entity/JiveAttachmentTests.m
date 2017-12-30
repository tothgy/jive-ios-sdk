//
//  Jiveself.attachmentTests.m
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

#import "JiveAttachmentTests.h"
#import "JiveAttachment.h"
#import "JiveResourceEntry.h"
#import "Jive_internal.h"
#import "NSError+Jive.h"

#import <OCMock/OCMock.h>


@interface Jive (JiveAttachmentTests)

- (NSMutableURLRequest *) credentialedRequestWithOptions:(NSObject<JiveRequestOptions>*)options
                                                template:(NSString*)template
                                            andArguments:(va_list)args;

@end

@implementation JiveAttachmentTests

NSString * const JiveAttachmentTestSelfKey = @"self";
NSString * const JiveAttachmentTestFollowersKey = @"followers";

- (void)setUp {
    [super setUp];
    self.object = [JiveAttachment new];
}

- (JiveAttachment *)attachment {
    return (JiveAttachment *)self.object;
}

- (void)initializeAttachment {
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    
    [resource setValue:[NSURL URLWithString:@"http://First.com"] forKey:JiveResourceEntryAttributes.ref];
    [resource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    self.attachment.contentType = @"parent";
    self.attachment.name = @"Subject";
    self.attachment.url = [NSURL URLWithString:@"http://dummy.com/item.txt"];
    self.attachment.doUpload = @YES;
    [self.attachment setValue:@"1234" forKey:JiveAttachmentAttributes.jiveId];
    [self.attachment setValue:@50 forKey:JiveAttachmentAttributes.size];
    [self.attachment setValue:@{JiveAttachmentTestSelfKey: resource}
                       forKey:JiveAttachmentAttributes.resources];
}

- (void)initializeAlternateAttachment {
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    
    [resource setValue:[NSURL URLWithString:@"https://Gigantic.com"] forKey:JiveResourceEntryAttributes.ref];
    [resource setValue:@[@"GET", @"PUT"] forKey:JiveResourceEntryAttributes.allowed];
    self.attachment.contentType = @"dummy";
    self.attachment.name = @"Required";
    self.attachment.url = [NSURL URLWithString:@"http://super.com/item.html"];
    [self.attachment setValue:@"5432" forKey:JiveAttachmentAttributes.jiveId];
    [self.attachment setValue:@500 forKey:JiveAttachmentAttributes.size];
    [self.attachment setValue:@{JiveAttachmentTestFollowersKey: resource}
                       forKey:JiveAttachmentAttributes.resources];
}

- (void)testToJSON {
    NSDictionary *JSON = [self.attachment toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeAttachment];
    
    JSON = [self.attachment toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.attachment.jiveId, @"Wrong id");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.contentType], self.attachment.contentType, @"Wrong contentType");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.name], self.attachment.name, @"Wrong name");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.url], [self.attachment.url absoluteString], @"Wrong url");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.size], self.attachment.size, @"Wrong size");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.doUpload], self.attachment.doUpload, @"Wrong doUpload");
}

- (void)testToJSON_alternate {
    [self initializeAlternateAttachment];
    
    NSDictionary *JSON = [self.attachment toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.attachment.jiveId, @"Wrong id");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.contentType], self.attachment.contentType, @"Wrong contentType");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.name], self.attachment.name, @"Wrong name");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.url], [self.attachment.url absoluteString], @"Wrong url");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.size], self.attachment.size, @"Wrong size");
}

- (void)testPersistentJSON {
    NSDictionary *JSON = [self.attachment persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeAttachment];
    
    JSON = [self.attachment persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.attachment.jiveId, @"Wrong id");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.contentType], self.attachment.contentType, @"Wrong contentType");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.name], self.attachment.name, @"Wrong name");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.url], [self.attachment.url absoluteString], @"Wrong url");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.size], self.attachment.size, @"Wrong size");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.doUpload], self.attachment.doUpload, @"Wrong doUpload");
    
    NSDictionary *resourcesJSON = [JSON objectForKey:JiveAttachmentAttributes.resources];
    
    XCTAssertTrue([[resourcesJSON class] isSubclassOfClass:[NSDictionary class]], @"Resources not converted");
    XCTAssertEqual([resourcesJSON count], (NSUInteger)1, @"Resources dictionary had the wrong number of entries");
    
    NSDictionary *selfResourceJSON = [resourcesJSON objectForKey:JiveAttachmentTestSelfKey];
    JiveResourceEntry *resource = (JiveResourceEntry *)self.attachment.resources[JiveAttachmentTestSelfKey];
    
    XCTAssertTrue([[selfResourceJSON class] isSubclassOfClass:[NSDictionary class]], @"Resources not converted");
    XCTAssertEqual([selfResourceJSON count], (NSUInteger)2, @"Resources dictionary had the wrong number of entries");
    XCTAssertEqualObjects(selfResourceJSON[JiveResourceEntryAttributes.ref],
                         resource.ref.absoluteString, @"Wrong resource");
    XCTAssertEqualObjects(selfResourceJSON[JiveResourceEntryAttributes.allowed], resource.allowed, @"Wrong resource");
}

- (void)testPersistentJSON_alternate {
    [self initializeAlternateAttachment];
    
    NSDictionary *JSON = [self.attachment persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.attachment.jiveId, @"Wrong id");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.contentType], self.attachment.contentType, @"Wrong contentType");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.name], self.attachment.name, @"Wrong name");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.url], [self.attachment.url absoluteString], @"Wrong url");
    XCTAssertEqualObjects(JSON[JiveAttachmentAttributes.size], self.attachment.size, @"Wrong size");
    
    NSDictionary *resourcesJSON = [JSON objectForKey:JiveAttachmentAttributes.resources];
    
    XCTAssertTrue([[resourcesJSON class] isSubclassOfClass:[NSDictionary class]], @"Resources not converted");
    XCTAssertEqual([resourcesJSON count], (NSUInteger)1, @"Resources dictionary had the wrong number of entries");
    
    NSDictionary *selfResourceJSON = [resourcesJSON objectForKey:JiveAttachmentTestFollowersKey];
    JiveResourceEntry *resource = (JiveResourceEntry *)self.attachment.resources[JiveAttachmentTestFollowersKey];
    
    XCTAssertTrue([[selfResourceJSON class] isSubclassOfClass:[NSDictionary class]], @"Resources not converted");
    XCTAssertEqual([selfResourceJSON count], (NSUInteger)2, @"Resources dictionary had the wrong number of entries");
    XCTAssertEqualObjects(selfResourceJSON[JiveResourceEntryAttributes.ref],
                         resource.ref.absoluteString, @"Wrong resource");
    XCTAssertEqualObjects(selfResourceJSON[JiveResourceEntryAttributes.allowed], resource.allowed, @"Wrong resource");
}

- (void)testAttachmentParsing {
    [self initializeAttachment];
    
    id JSON = [self.attachment persistentJSON];
    JiveAttachment *newAttachment = [JiveAttachment objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newAttachment class] isSubclassOfClass:[self.attachment class]], @"Wrong item class");
    XCTAssertEqualObjects(newAttachment.jiveId, self.attachment.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newAttachment.contentType, self.attachment.contentType, @"Wrong contentType");
    XCTAssertEqualObjects(newAttachment.name, self.attachment.name, @"Wrong name");
    XCTAssertEqualObjects(newAttachment.url, self.attachment.url, @"Wrong url");
    XCTAssertEqualObjects(newAttachment.size, self.attachment.size, @"Wrong size");
    XCTAssertEqualObjects(newAttachment.doUpload, self.attachment.doUpload, @"Wrong doUpload");
    XCTAssertEqualObjects(newAttachment.resources.allKeys, self.attachment.resources.allKeys, @"Wrong resource object");
}

- (void)testAttachmentParsingAlternate {
    [self initializeAlternateAttachment];
    
    id JSON = [self.attachment persistentJSON];
    JiveAttachment *newAttachment = [JiveAttachment objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newAttachment class] isSubclassOfClass:[self.attachment class]], @"Wrong item class");
    XCTAssertEqualObjects(newAttachment.jiveId, self.attachment.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newAttachment.contentType, self.attachment.contentType, @"Wrong contentType");
    XCTAssertEqualObjects(newAttachment.name, self.attachment.name, @"Wrong name");
    XCTAssertEqualObjects(newAttachment.url, self.attachment.url, @"Wrong url");
    XCTAssertEqualObjects(newAttachment.size, self.attachment.size, @"Wrong size");
    XCTAssertEqualObjects(newAttachment.doUpload, self.attachment.doUpload, @"Wrong doUpload");
    XCTAssertEqualObjects(newAttachment.resources.allKeys, self.attachment.resources.allKeys, @"Wrong resource object");
}

- (void)testSelfReferenceParsedBeforeAnythingElse {
    JiveResourceEntry *selfResource = [JiveResourceEntry new];
    JiveResourceEntry *altResource = [JiveResourceEntry new];
    NSString *expectedURL = @"https://hopback.eng.jiveland.com/";
    
    [selfResource setValue:[NSURL URLWithString:[expectedURL stringByAppendingString:@"api/core/v3/person/321"]]
                    forKey:JiveResourceEntryAttributes.ref];
    [selfResource setValue:@[@"GET", @"PUT"]
                    forKey:JiveResourceEntryAttributes.allowed];
    [altResource setValue:[NSURL URLWithString:@"http://brewspace.com/api/core/v3/person/321"]
                   forKey:JiveResourceEntryAttributes.ref];
    [altResource setValue:@[@"GET", @"DELETE"]
                   forKey:JiveResourceEntryAttributes.allowed];
    self.instance.badInstanceURL = nil;
    
    id selfJSON = selfResource.persistentJSON;
    id altJSON = altResource.persistentJSON;
    NSDictionary *firstResourceJSON = @{JiveAttachmentTestSelfKey:selfJSON,
                                        JiveAttachmentTestFollowersKey:altJSON};
    NSDictionary *firstJSON = @{JiveAttachmentAttributes.resources:firstResourceJSON};
    
    [[self.object class] objectFromJSON:firstJSON withInstance:self.instance];
    XCTAssertEqualObjects(self.instance.badInstanceURL, expectedURL, @"SelfRef was not parsed first.");
    
    self.instance.badInstanceURL = nil;
    
    NSDictionary *secondResourceJSON = @{JiveAttachmentTestFollowersKey:altJSON,
                                         JiveAttachmentTestSelfKey:selfJSON};
    NSDictionary *secondJSON = @{JiveAttachmentAttributes.resources:secondResourceJSON};
    
    [[self.object class] objectFromJSON:secondJSON withInstance:self.instance];
    XCTAssertEqualObjects(self.instance.badInstanceURL, expectedURL, @"SelfRef was not parsed first.");
}

- (void)test_createAttachmentForFile_fileURL {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"blog" ofType:@"json"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileURL path]
                                                                                    error:nil];
    JiveAttachment *attachment;
    
    XCTAssertNoThrow(attachment = [JiveAttachment createAttachmentForURL:fileURL]);
    XCTAssertNotNil(bundle);
    XCTAssertNotNil(path);
    XCTAssertNotNil(attachment);
    XCTAssertNotNil(fileURL);
    XCTAssertNotNil(fileAttributes);
    XCTAssertNotNil(attachment, @"attachment object not created");
    XCTAssertEqualObjects(attachment.url, fileURL, @"Wrong URL");
    XCTAssertEqualObjects(attachment.name, [fileURL lastPathComponent], @"Wrong file name");
    XCTAssertEqualObjects(attachment.doUpload, @YES, @"doUpload not set");
//    STAssertEqualObjects(attachment.contentType, @"application/json", @"Wrong content type");
    XCTAssertEqualObjects(attachment.size, [fileAttributes objectForKey:NSFileSize], @"Wrong file size");
}

- (void)test_createAttachmentForURL_webURL {
    NSURL *webURL = [NSURL URLWithString:@"https://brewspace.jiveland.com/file.php"];
    JiveAttachment *attachment = [JiveAttachment createAttachmentForURL:webURL];
    
    XCTAssertNotNil(attachment, @"attachment object not created");
    XCTAssertEqualObjects(attachment.url, webURL, @"Wrong URL");
    XCTAssertEqualObjects(attachment.name, [webURL lastPathComponent], @"Wrong file name");
    XCTAssertEqualObjects(attachment.doUpload, @YES, @"doUpload not set");
    XCTAssertNil(attachment.contentType, @"Wrong content type");
    XCTAssertNil(attachment.size, @"Wrong file size");
}

- (void)test_createAttachmentForFile_invalidFileURL {
    NSURL *fileURL = [NSURL URLWithString:@"file://brewspace.jiveland.com"];
    JiveAttachment *attachment = [JiveAttachment createAttachmentForURL:fileURL];
    
    XCTAssertTrue([fileURL isFileURL], @"Should report as a file url.");
    XCTAssertNil(attachment, @"Should not create an attachment object for an invalid file url.");
}

- (void)test_deleteFromInstanceOperation_onComplete_onError_noResources {
    id jiveMock = [OCMockObject mockForClass:[Jive class]];
    __block BOOL operationDone = NO;
    
    XCTAssertNil([self.attachment deleteFromInstanceOperation:jiveMock onComplete:^{
        XCTFail(@"No resources available to make the call");
        operationDone = YES;
    } onError:^(NSError *deliveredError) {
        NSError *expectedError = [NSError errorWithDomain:JiveErrorDomain
                                                     code:JiveErrorCodeCantDeleteAttachment
                                                 userInfo:nil];

        XCTAssertEqualObjects(deliveredError, expectedError, @"%@ != %@", deliveredError, expectedError);
        operationDone = YES;
    }]);
    
    XCTAssertTrue(operationDone);
    XCTAssertNoThrow([jiveMock verify]);
}

- (void)test_deleteFromInstance_onComplete_onError_noResources {
    id jiveMock = [OCMockObject mockForClass:[Jive class]];
    __block BOOL operationDone = NO;
    
    XCTAssertNoThrow([self.attachment deleteFromInstance:jiveMock onComplete:^{
        XCTFail(@"No resources available to make the call");
        operationDone = YES;
    } onError:^(NSError *deliveredError) {
        NSError *expectedError = [NSError errorWithDomain:JiveErrorDomain
                                                     code:JiveErrorCodeCantDeleteAttachment
                                                 userInfo:nil];
        
        XCTAssertTrue([deliveredError isEqual:expectedError], @"%@ != %@", deliveredError, expectedError);
        operationDone = YES;
    }]);
    
    XCTAssertTrue(operationDone);
    XCTAssertNoThrow([jiveMock verify]);
}

- (void)test_deleteFromInstanceOperation_onComplete_onError_deleteNotAllowed {
    id jiveMock = [OCMockObject mockForClass:[Jive class]];
    JiveResourceEntry *selfResource = [JiveResourceEntry new];
    __block BOOL operationDone = NO;
    
    [selfResource setValue:[NSURL URLWithString:@"https://hopback.eng.jiveland.com/api/core/v3/attachments/321"]
                    forKey:JiveResourceEntryAttributes.ref];
    [selfResource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    [self.attachment setValue:@{JiveAttachmentTestSelfKey: selfResource}
                       forKey:JiveAttachmentAttributes.resources];
    
    XCTAssertNil([self.attachment deleteFromInstanceOperation:jiveMock onComplete:^{
        XCTFail(@"No resources available to make the call");
        operationDone = YES;
    } onError:^(NSError *deliveredError) {
        NSError *expectedError = [NSError errorWithDomain:JiveErrorDomain
                                                     code:JiveErrorCodeCantDeleteAttachment
                                                 userInfo:nil];

        XCTAssertEqualObjects(deliveredError, expectedError, @"%@ != %@", deliveredError, expectedError);
        operationDone = YES;
    }]);
    
    XCTAssertTrue(operationDone);
    XCTAssertNoThrow([jiveMock verify]);
}

- (void)test_deleteFromInstance_onComplete_onError_deleteNotAllowed {
    id jiveMock = [OCMockObject mockForClass:[Jive class]];
    JiveResourceEntry *selfResource = [JiveResourceEntry new];
    __block BOOL operationDone = NO;
    
    [selfResource setValue:[NSURL URLWithString:@"https://hopback.eng.jiveland.com/api/core/v3/attachments/321"]
                    forKey:JiveResourceEntryAttributes.ref];
    [selfResource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    [self.attachment setValue:@{JiveAttachmentTestSelfKey: selfResource}
                       forKey:JiveAttachmentAttributes.resources];
    
    XCTAssertNoThrow([self.attachment deleteFromInstance:jiveMock onComplete:^{
        XCTFail(@"No resources available to make the call");
        operationDone = YES;
    } onError:^(NSError *deliveredError) {
        NSError *expectedError = [NSError errorWithDomain:JiveErrorDomain
                                                     code:JiveErrorCodeCantDeleteAttachment
                                                 userInfo:nil];
        
        XCTAssertTrue([deliveredError isEqual:expectedError], @"%@ != %@", deliveredError, expectedError);
        operationDone = YES;
    }]);
    
    XCTAssertTrue(operationDone);
    XCTAssertNoThrow([jiveMock verify]);
}

- (void)test_deleteFromInstanceOperation_onComplete_onError {
    Jive *jive = [Jive new];
    id jiveMock = [OCMockObject partialMockForObject:jive];
    NSOperation *operation = [NSOperation new];
    JiveResourceEntry *selfResource = [JiveResourceEntry new];
    id requestMock = [OCMockObject mockForClass:[NSMutableURLRequest class]];
    JiveCompletedBlock completeBlock = ^{};
    JiveErrorBlock errorBlock = ^(NSError *error){};
    NSURL *url = [NSURL URLWithString:@"https://hopback.eng.jiveland.com/api/core/v3/attachments/321"];
    NSOperation *result = nil;
    
    [selfResource setValue:url forKey:JiveResourceEntryAttributes.ref];
    [selfResource setValue:@[@"GET", @"DELETE"] forKey:JiveResourceEntryAttributes.allowed];
    [self.attachment setValue:@{JiveAttachmentTestSelfKey: selfResource}
                       forKey:JiveAttachmentAttributes.resources];
    [[[[jiveMock expect] andReturn:requestMock] ignoringNonObjectArgs] credentialedRequestWithOptions:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertNil(obj);
        return YES;
    }] template:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, [url path]);
        return YES;
    }] andArguments:nil];
    [[requestMock expect] setHTTPMethod:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JiveHTTPMethodTypes.DELETE);
        return YES;
    }]];
    [[[jiveMock expect] andReturn:operation] emptyOperationWithRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqual(obj, requestMock);
        return YES;
    }] onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqual(obj, (id)completeBlock);
        return YES;
    }] onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqual(obj, (id)errorBlock);
        return YES;
    }]];
    
    XCTAssertNoThrow(result = [self.attachment deleteFromInstanceOperation:jiveMock
                                                               onComplete:completeBlock
                                                                  onError:errorBlock]);
    XCTAssertEqual(result, operation);
    XCTAssertNoThrow([jiveMock verify]);
    XCTAssertNoThrow([requestMock verify]);
}

- (void)test_deleteFromInstance_onComplete_onError {
    Jive *jive = [Jive new];
    id jiveMock = [OCMockObject partialMockForObject:jive];
    id operationMock = [OCMockObject mockForClass:[NSOperation class]];
    JiveResourceEntry *selfResource = [JiveResourceEntry new];
    id requestMock = [OCMockObject mockForClass:[NSMutableURLRequest class]];
    JiveCompletedBlock completeBlock = ^{};
    JiveErrorBlock errorBlock = ^(NSError *error){};
    NSURL *url = [NSURL URLWithString:@"https://hopback.eng.jiveland.com/api/core/v3/attachments/321"];
    
    [selfResource setValue:url forKey:JiveResourceEntryAttributes.ref];
    [selfResource setValue:@[@"GET", @"DELETE"] forKey:JiveResourceEntryAttributes.allowed];
    [self.attachment setValue:@{JiveAttachmentTestSelfKey: selfResource}
                       forKey:JiveAttachmentAttributes.resources];
    [[[[jiveMock expect] andReturn:requestMock] ignoringNonObjectArgs] credentialedRequestWithOptions:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertNil(obj);
        return YES;
    }] template:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, [url path]);
        return YES;
    }] andArguments:nil];
    [[requestMock expect] setHTTPMethod:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JiveHTTPMethodTypes.DELETE);
        return YES;
    }]];
    [[[jiveMock expect] andReturn:operationMock] emptyOperationWithRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqual(obj, requestMock);
        return YES;
    }] onComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqual(obj, (id)completeBlock);
        return YES;
    }] onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqual(obj, (id)errorBlock);
        return YES;
    }]];
    [(NSOperation *)[operationMock expect] start];
    
    XCTAssertNoThrow([self.attachment deleteFromInstance:jiveMock
                                             onComplete:completeBlock
                                                onError:errorBlock]);
    XCTAssertNoThrow([jiveMock verify]);
    XCTAssertNoThrow([requestMock verify]);
    XCTAssertNoThrow([operationMock verify]);
}

@end
