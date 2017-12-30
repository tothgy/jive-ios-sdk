//
//  JiveProjectTests.m
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

#import "JiveProjectTests.h"

@implementation JiveProjectTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveProject alloc] init];
}

- (JiveProject *)project {
    return (JiveProject *)self.place;
}

- (void)testType {
    XCTAssertEqualObjects(self.project.type, @"project", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.project.type forKey:@"type"];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.project class], @"Project class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JivePlace entityClass:typeSpecifier], [self.project class], @"Project class not registered with JivePlace.");
}

- (void)testTaskToJSON {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *locale = @"Jiverado";
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.project toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], @"project", @"Wrong type");
    
    creator.location = @"location";
    [self.project setValue:creator forKey:@"creator"];
    [self.project setValue:@"started" forKey:@"projectStatus"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"dueDate"];
    self.project.locale = locale;
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"startDate"];
    [self.project setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    JSON = [self.project toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.project.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:@"projectStatus"], self.project.projectStatus, @"Wrong projectStatus");
    XCTAssertEqualObjects([JSON objectForKey:@"dueDate"], @"1970-01-01T00:00:00.000+0000", @"Wrong due date");
    XCTAssertEqualObjects([JSON objectForKey:JiveProjectAttributes.locale], locale, @"Wrong locale");
    XCTAssertEqualObjects([JSON objectForKey:@"startDate"], @"1970-01-01T00:16:40.123+0000", @"Wrong start date");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    XCTAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSDictionary *creatorJSON = [JSON objectForKey:@"creator"];
    
    XCTAssertTrue([[creatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([creatorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([creatorJSON objectForKey:@"location"], creator.location, @"Wrong value");
}

- (void)testTaskToJSON_alternate {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *locale = @"Club Fed";
    NSString *tag = @"concise";
    
    creator.location = @"Tower";
    [self.project setValue:creator forKey:@"creator"];
    [self.project setValue:@"complete" forKey:@"projectStatus"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"dueDate"];
    self.project.locale = locale;
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"startDate"];
    [self.project setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    NSDictionary *JSON = [self.project toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.project.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:@"projectStatus"], self.project.projectStatus, @"Wrong projectStatus");
    XCTAssertEqualObjects([JSON objectForKey:@"dueDate"], @"1970-01-01T00:16:40.123+0000", @"Wrong due date");
    XCTAssertEqualObjects([JSON objectForKey:JiveProjectAttributes.locale], locale, @"Wrong locale");
    XCTAssertEqualObjects([JSON objectForKey:@"startDate"], @"1970-01-01T00:00:00.000+0000", @"Wrong start date");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    XCTAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSDictionary *creatorJSON = [JSON objectForKey:@"creator"];
    
    XCTAssertTrue([[creatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([creatorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([creatorJSON objectForKey:@"location"], creator.location, @"Wrong value");
}

- (void)testPostParsing {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *locale = @"Jiverado";
    NSString *tag = @"wordy";
    
    creator.location = @"location";
    [self.project setValue:creator forKey:@"creator"];
    [self.project setValue:@"started" forKey:@"projectStatus"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"dueDate"];
    self.project.locale = locale;
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"startDate"];
    [self.project setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.project toJSONDictionary];
    JiveProject *newProject = [JiveProject objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newProject class] isSubclassOfClass:[self.project class]], @"Wrong item class");
    XCTAssertEqualObjects(newProject.type, self.project.type, @"Wrong type");
    XCTAssertEqualObjects(newProject.projectStatus, self.project.projectStatus, @"Wrong projectStatus");
    XCTAssertEqualObjects(newProject.dueDate, self.project.dueDate, @"Wrong due date");
    XCTAssertEqualObjects(newProject.locale, locale, @"Wrong locale");
    XCTAssertEqualObjects(newProject.startDate, self.project.startDate, @"Wrong start date");
    XCTAssertEqual([newProject.tags count], [self.project.tags count], @"Wrong number of tags");
    XCTAssertEqualObjects([newProject.tags objectAtIndex:0], tag, @"Wrong tag");
    XCTAssertEqualObjects(newProject.creator.location, creator.location, @"Wrong creator location");
}

- (void)testPostParsingAlternate {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *locale = @"Club Fed";
    NSString *tag = @"concise";
    
    creator.location = @"Tower";
    [self.project setValue:creator forKey:@"creator"];
    [self.project setValue:@"complete" forKey:@"projectStatus"];
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"dueDate"];
    self.project.locale = locale;
    [self.project setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"startDate"];
    [self.project setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.project toJSONDictionary];
    JiveProject *newProject = [JiveProject objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newProject class] isSubclassOfClass:[self.project class]], @"Wrong item class");
    XCTAssertEqualObjects(newProject.type, self.project.type, @"Wrong type");
    XCTAssertEqualObjects(newProject.projectStatus, self.project.projectStatus, @"Wrong projectStatus");
    XCTAssertEqualObjects(newProject.dueDate, self.project.dueDate, @"Wrong due date");
    XCTAssertEqualObjects(newProject.locale, locale, @"Wrong locale");
    XCTAssertEqualObjects(newProject.startDate, self.project.startDate, @"Wrong start date");
    XCTAssertEqual([newProject.tags count], [self.project.tags count], @"Wrong number of tags");
    XCTAssertEqualObjects([newProject.tags objectAtIndex:0], tag, @"Wrong tag");
    XCTAssertEqualObjects(newProject.creator.location, creator.location, @"Wrong creator location");
}

@end
