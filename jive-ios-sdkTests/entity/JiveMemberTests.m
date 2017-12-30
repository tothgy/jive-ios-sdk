//
//  JiveMemberTests.m
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

#import "JiveMemberTests.h"
#import "JiveResourceEntry.h"

@implementation JiveMemberTests

- (JiveMember *)member {
    return (JiveMember *)self.typedObject;
}

- (void)setUp {
    [super setUp];
    self.object = [[JiveMember alloc] init];
}

- (void)testToJSON {
    JivePerson *person = [[JivePerson alloc] init];
    JiveGroup *group = [[JiveGroup alloc] init];
    NSDictionary *JSON = [self.member toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], @"member", @"Wrong type");
    
    person.location = @"location";
    group.displayName = @"group";
    self.member.state = @"banned";
    [self.member setValue:@"1234" forKey:@"jiveId"];
    [self.member setValue:person forKey:@"person"];
    [self.member setValue:group forKey:@"group"];
    [self.member setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.member setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    
    JSON = [self.member toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"id"], self.member.jiveId, @"Wrong id");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.member.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:@"state"], self.member.state, @"Wrong state");
    XCTAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    XCTAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    
    NSDictionary *personJSON = [JSON objectForKey:@"person"];
    
    XCTAssertTrue([[personJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([personJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([personJSON objectForKey:@"location"], person.location, @"Wrong value");
    
    NSDictionary *groupJSON = [JSON objectForKey:@"group"];
    
    XCTAssertTrue([[groupJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([groupJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([groupJSON objectForKey:@"displayName"], group.displayName, @"Wrong value");
}

- (void)testToJSON_alternate {
    JivePerson *person = [[JivePerson alloc] init];
    JiveGroup *group = [[JiveGroup alloc] init];
    
    person.location = @"Tower";
    group.displayName = @"group";
    self.member.state = @"member";
    [self.member setValue:@"8743" forKey:@"jiveId"];
    [self.member setValue:person forKey:@"person"];
    [self.member setValue:group forKey:@"group"];
    [self.member setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.member setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    
    NSDictionary *JSON = [self.member toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"id"], self.member.jiveId, @"Wrong id");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.member.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:@"state"], self.member.state, @"Wrong state");
    XCTAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    XCTAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    
    NSDictionary *personJSON = [JSON objectForKey:@"person"];
    
    XCTAssertTrue([[personJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([personJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([personJSON objectForKey:@"location"], person.location, @"Wrong value");
    
    NSDictionary *groupJSON = [JSON objectForKey:@"group"];
    
    XCTAssertTrue([[groupJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([groupJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([groupJSON objectForKey:@"displayName"], group.displayName, @"Wrong value");
}

- (void)testContentParsing {
    JivePerson *person = [[JivePerson alloc] init];
    JiveGroup *group = [[JiveGroup alloc] init];
    NSString *memberType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:memberType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:memberType] forKey:@"ref"];
    person.location = @"location";
    group.displayName = @"group";
    self.member.state = @"banned";
    [self.member setValue:@"1234" forKey:@"jiveId"];
    [self.member setValue:person forKey:@"person"];
    [self.member setValue:group forKey:@"group"];
    [self.member setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.member setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [self.member setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [self.member toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveMember *newMember = [JiveMember objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newMember class] isSubclassOfClass:[self.member class]], @"Wrong item class");
    XCTAssertEqualObjects(newMember.jiveId, self.member.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newMember.type, self.member.type, @"Wrong type");
    XCTAssertEqualObjects(newMember.person.location, self.member.person.location, @"Wrong person");
    XCTAssertEqualObjects(newMember.group.displayName, self.member.group.displayName, @"Wrong group");
    XCTAssertEqualObjects(newMember.published, self.member.published, @"Wrong published");
    XCTAssertEqualObjects(newMember.updated, self.member.updated, @"Wrong updated");
    XCTAssertEqualObjects(newMember.state, self.member.state, @"Wrong state");
    XCTAssertEqual([newMember.resources count], [self.member.resources count], @"Wrong number of resource objects");
    XCTAssertEqualObjects([(JiveResourceEntry *)[newMember.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testContentParsingAlternate {
    JivePerson *person = [[JivePerson alloc] init];
    JiveGroup *group = [[JiveGroup alloc] init];
    NSString *memberType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:memberType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:memberType] forKey:@"ref"];
    person.location = @"Tower";
    group.displayName = @"group";
    self.member.state = @"member";
    [self.member setValue:@"8743" forKey:@"jiveId"];
    [self.member setValue:person forKey:@"person"];
    [self.member setValue:group forKey:@"group"];
    [self.member setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.member setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.member setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [self.member toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveMember *newMember = [JiveMember objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newMember class] isSubclassOfClass:[self.member class]], @"Wrong item class");
    XCTAssertEqualObjects(newMember.jiveId, self.member.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newMember.type, self.member.type, @"Wrong type");
    XCTAssertEqualObjects(newMember.person.location, self.member.person.location, @"Wrong person");
    XCTAssertEqualObjects(newMember.group.displayName, self.member.group.displayName, @"Wrong group");
    XCTAssertEqualObjects(newMember.published, self.member.published, @"Wrong published");
    XCTAssertEqualObjects(newMember.updated, self.member.updated, @"Wrong updated");
    XCTAssertEqualObjects(newMember.state, self.member.state, @"Wrong state");
    XCTAssertEqual([newMember.resources count], [self.member.resources count], @"Wrong number of resource objects");
    XCTAssertEqualObjects([(JiveResourceEntry *)[newMember.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
