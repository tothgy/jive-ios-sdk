//
//  JiveStreamTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
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

#import "JiveTypedObjectTests.h"
#import "JiveStream_internal.h"
#import "JiveResourceEntry.h"
#import "JiveTypedObject_internal.h"


@interface JiveStreamTests : JiveTypedObjectTests

@property (nonatomic, readonly) JiveStream *stream;
@property (nonatomic, strong) JivePerson *person;

@end


@implementation JiveStreamTests

- (JiveStream *)stream {
    return (JiveStream *)self.typedObject;
}

- (void)setUp {
    [super setUp];
    self.object = [JiveStream new];
    self.person = [JivePerson new];
}

- (void)tearDown {
    self.person = nil;
    [super tearDown];
}

- (void)setupTestStream {
    self.person.location = @"location";
    self.stream.name = @"name";
    self.stream.receiveEmails = @YES;
    [self.stream setValue:@5 forKeyPath:JiveStreamAttributes.count];
    [self.stream setValue:@"1234" forKey:JiveObjectAttributes.jiveId];
    [self.stream setValue:self.person forKey:JiveStreamAttributes.person];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0]
                   forKey:JiveStreamAttributes.published];
    [self.stream setValue:JiveStreamSourceValues.connections forKey:JiveStreamAttributes.source];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                   forKey:JiveStreamAttributes.updated];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:56789]
                   forKey:JiveStreamAttributes.updatesNew];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:3456]
                   forKey:JiveStreamAttributes.updatesPrevious];
}

- (void)setupAlternateTestStream {
    self.person.location = @"Tower";
    self.stream.name = @"William";
    [self.stream setValue:@"Writing" forKey:@"subject"];
    [self.stream setValue:@"another non-type" forKey:JiveTypedObjectAttributes.type];
    [self.stream setValue:@"8743" forKey:JiveObjectAttributes.jiveId];
    [self.stream setValue:self.person forKey:JiveStreamAttributes.person];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                   forKey:JiveStreamAttributes.published];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0]
                   forKey:JiveStreamAttributes.updated];
    [self.stream setValue:@50 forKeyPath:JiveStreamAttributes.count];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:3456]
                   forKey:JiveStreamAttributes.updatesNew];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:56789]
                   forKey:JiveStreamAttributes.updatesPrevious];
}

- (void)testStreamToJSON {
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self setupTestStream];
    [self.stream setValue:@"not a real type" forKey:JiveTypedObjectAttributes.type];
    
    XCTAssertNoThrow(JSON = [self.stream toJSONDictionary], @"This is the method under test");
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.name], self.stream.name, @"Wrong name");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.receiveEmails],
                         self.stream.receiveEmails, @"Wrong receiveEmails");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.source], self.stream.source, @"Wrong source");
}

- (void)testStreamToJSON_alternate {
    [self setupAlternateTestStream];
    
    NSDictionary *JSON;
    
    XCTAssertNoThrow(JSON = [self.stream toJSONDictionary], @"This is the method under test");
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.name], self.stream.name, @"Wrong name");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.source],
                         JiveStreamSourceValues.custom, @"Wrong source");
}

- (void)testStreamPersistentJSON {
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self setupTestStream];
    [self.stream setValue:@"not a real type" forKey:JiveTypedObjectAttributes.type];
    
    XCTAssertNoThrow(JSON = [self.stream persistentJSON], @"This is the method under test");
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.receiveEmails],
                         self.stream.receiveEmails, @"Wrong receiveEmails");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.count], self.stream.count);
    XCTAssertEqualObjects([JSON objectForKey:JiveObjectConstants.id], self.stream.jiveId);
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.name], self.stream.name);
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.source],
                         JiveStreamSourceValues.connections);
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type);
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.published],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.updated],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamJSONAttributes.newUpdates],
                         @"1970-01-01T15:46:29.000+0000", @"Wrong published");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamJSONAttributes.previousUpdates],
                         @"1970-01-01T00:57:36.000+0000", @"Wrong updated");
    
    NSDictionary *personJSON = [JSON objectForKey:JiveStreamAttributes.person];
    
    XCTAssertTrue([[personJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([personJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([personJSON objectForKey:JivePersonAttributes.location],
                         self.person.location, @"Wrong value");
}

- (void)testStreamPersistentJSON_alternate {
    [self setupAlternateTestStream];
    
    NSDictionary *JSON;
    
    XCTAssertNoThrow(JSON = [self.stream persistentJSON], @"This is the method under test");
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)10, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.count], self.stream.count);
    XCTAssertEqualObjects([JSON objectForKey:JiveObjectConstants.id], self.stream.jiveId);
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.name], self.stream.name);
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.source],
                         JiveStreamSourceValues.custom);
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type);
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.published],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.updated],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamJSONAttributes.newUpdates],
                         @"1970-01-01T00:57:36.000+0000", @"Wrong published");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamJSONAttributes.previousUpdates],
                         @"1970-01-01T15:46:29.000+0000", @"Wrong updated");
    
    NSDictionary *personJSON = [JSON objectForKey:JiveStreamAttributes.person];
    
    XCTAssertTrue([[personJSON class] isSubclassOfClass:[NSDictionary class]]);
    XCTAssertEqual([personJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([personJSON objectForKey:JivePersonAttributes.location],
                         self.person.location, @"Wrong value");
}

- (void)testStreamParsing {
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    
    [self setupTestStream];
    [resource setValue:[NSURL URLWithString:contentType] forKey:JiveResourceEntryAttributes.ref];
    [resource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    [self.stream setValue:@{resourceKey:resource}
               forKeyPath:JiveTypedObjectAttributesHidden.resources];
    
    NSDictionary *JSON;
    
    XCTAssertNoThrow(JSON = [self.stream persistentJSON], @"PRECONDITION");
    
    JiveStream *newStream = [JiveStream objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newStream class] isSubclassOfClass:[self.stream class]], @"Wrong item class");
    XCTAssertEqualObjects(newStream.jiveId, self.stream.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newStream.type, self.stream.type, @"Wrong type");
    XCTAssertEqualObjects(newStream.name, self.stream.name, @"Wrong name");
    XCTAssertEqualObjects(newStream.receiveEmails, self.stream.receiveEmails, @"Wrong receiveEmails");
    XCTAssertEqualObjects(newStream.source, self.stream.source, @"Wrong source");
    XCTAssertEqualObjects(newStream.person.location, self.stream.person.location, @"Wrong person");
    XCTAssertEqualObjects(newStream.published, self.stream.published, @"Wrong published");
    XCTAssertEqualObjects(newStream.updated, self.stream.updated, @"Wrong updated");
    XCTAssertEqual([newStream.resources count], [self.stream.resources count], @"Wrong number of resource objects");
    XCTAssertEqualObjects([(JiveResourceEntry *)[newStream.resources objectForKey:resourceKey] ref],
                         resource.ref, @"Wrong resource object");
    XCTAssertEqualObjects(newStream.count, self.stream.count);
    XCTAssertEqualObjects(newStream.updatesNew, self.stream.updatesNew);
    XCTAssertEqualObjects(newStream.updatesPrevious, self.stream.updatesPrevious);
}

- (void)testStreamParsingAlternate {
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    
    [self setupAlternateTestStream];
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    [resource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    [self.stream setValue:@{resourceKey:resource}
               forKeyPath:JiveTypedObjectAttributesHidden.resources];
    
    NSDictionary *JSON;
    
    XCTAssertNoThrow(JSON = [self.stream persistentJSON], @"PRECONDITION");
    
    JiveStream *newStream = [JiveStream objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newStream class] isSubclassOfClass:[self.stream class]], @"Wrong item class");
    XCTAssertEqualObjects(newStream.jiveId, self.stream.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newStream.type, self.stream.type, @"Wrong type");
    XCTAssertEqualObjects(newStream.name, self.stream.name, @"Wrong name");
    XCTAssertEqualObjects(newStream.receiveEmails, self.stream.receiveEmails, @"Wrong receiveEmails");
    XCTAssertEqualObjects(newStream.source, @"custom", @"Wrong source");
    XCTAssertEqualObjects(newStream.person.location, self.stream.person.location, @"Wrong person");
    XCTAssertEqualObjects(newStream.published, self.stream.published, @"Wrong published");
    XCTAssertEqualObjects(newStream.updated, self.stream.updated, @"Wrong updated");
    XCTAssertEqual([newStream.resources count], [self.stream.resources count], @"Wrong number of resource objects");
    XCTAssertEqualObjects([(JiveResourceEntry *)[newStream.resources objectForKey:resourceKey] ref],
                         resource.ref, @"Wrong resource object");
    XCTAssertEqualObjects(newStream.count, self.stream.count);
    XCTAssertEqualObjects(newStream.updatesNew, self.stream.updatesNew);
    XCTAssertEqualObjects(newStream.updatesPrevious, self.stream.updatesPrevious);
}

@end
