//
//  JivePersonTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/14/12.
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

#import "JivePersonTests.h"
#import "JiveAddress.h"
#import "JivePersonJive.h"
#import "JiveName.h"
#import "JiveEmail.h"
#import "JivePhoneNumber.h"
#import "JiveResourceEntry.h"
#import "JiveProfileEntry.h"
#import "JiveSortedRequestOptions.h"

#import "Jive_internal.h"
#import <OCMock/OCMock.h>
#import "OCMockObject+MockJiveURLResponseDelegate.h"
#import "JiveHTTPBasicAuthCredentials.h"
#import "JiveMobileAnalyticsHeader.h"
#import "MockJiveURLProtocol.h"
#import "JiveObject_internal.h"
#import "NSError+Jive.h"

@interface JivePersonTests (){
    id mockJiveURLResponseDelegate;
    id mockJiveURLResponseDelegate2;
    id mockAuthDelegate;
}

@property (nonatomic, strong) NSString *instanceURL;

@end

@implementation JivePersonTests

- (NSString *)instanceURL {
    if (!_instanceURL) {
        _instanceURL = @"https://testing.jiveland.com";
    }
    
    return _instanceURL;
}

- (void) mockJiveURLDelegate:(NSURL*) url returningContentsOfFile:(NSString*) path {
    
    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    // Mock Response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:200
                                                             HTTPVersion:@"1.0"
                                                            headerFields:@{JiveHTTPHeaderFields.contentType:@"application/json"}];
    
    [[[mockJiveURLResponseDelegate expect] andReturn:response] responseForRequest];
    
    // Mock data
    NSData *mockResponseData = [NSData dataWithContentsOfFile:path];
    
    [[[mockJiveURLResponseDelegate expect] andReturn:mockResponseData] responseBodyForRequest];
}

// Create the Jive API object, using mock auth delegate
- (void)createJiveAPIObjectWithResponsePath:(NSString *)contentPath andAuthDelegate:(id)authDelegate {
    
    // This can be anything. The mock objects will return local data
    NSURL* url = [NSURL URLWithString:self.instanceURL];
    
    // Mock response delegate
    [self mockJiveURLDelegate:url returningContentsOfFile:contentPath];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    self.instance = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:authDelegate];
    self.person.jiveInstance = self.instance;
}

- (void)createJiveAPIObjectWithErrorCode:(NSInteger)errorCode
                 andAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    assert(mockAuthURLCheck);
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    };
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    // This can be anything. The mock objects will return local data
    NSURL* url = [NSURL URLWithString:self.instanceURL];
    
    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    // Mock Response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:errorCode
                                                             HTTPVersion:@"1.0"
                                                            headerFields:@{JiveHTTPHeaderFields.contentType:@"application/json"}];
    
    [[[mockJiveURLResponseDelegate expect] andReturn:response] responseForRequest];
    [[[mockJiveURLResponseDelegate expect] andReturn:nil] responseBodyForRequest];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    self.instance = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    self.person.jiveInstance = self.instance;
}

- (void)createJiveAPIObjectWithTermsAndConditionsFailureAndAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    assert(mockAuthURLCheck);
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    };
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    // This can be anything. The mock objects will return local data
    NSURL* url = [NSURL URLWithString:self.instanceURL];
    
    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    // Mock Response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:500
                                                             HTTPVersion:@"1.0"
                                                            headerFields:@{JiveHTTPHeaderFields.contentType:@"application/json",
                                                                           @"X-JIVE-TC":@"/api/core/v3/people/@me/termsAndConditions"}];
    NSString *responseText = @"<html><head><title>Apache Tomcat - Error report</title><style><!--H1 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:22px;} H2 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:16px;} H3 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:14px;} BODY {font-family:Tahoma,Arial,sans-serif;color:black;background-color:white;} B {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;} P {font-family:Tahoma,Arial,sans-serif;background:white;color:black;font-size:12px;}A {color : black;}A.name {color : black;}HR {color : #525D76;}--></style> </head><body><h1>HTTP Status 451 - Unavailable For Legal Reasons</h1><HR size=\"1\" noshade=\"noshade\"><p><b>type</b> Status report</p><p><b>message</b> <u>Unavailable For Legal Reasons</u></p><p><b>description</b> <u>No description available</u></p><HR size=\"1\" noshade=\"noshade\"><h3>Apache Tomcat</h3></body></html>";
    NSData *responseBody = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    [[[mockJiveURLResponseDelegate expect] andReturn:response] responseForRequest];
    [[[mockJiveURLResponseDelegate expect] andReturn:responseBody] responseBodyForRequest];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    self.instance = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    self.person.jiveInstance = self.instance;
}

- (void)createJiveAPIObject_ExpectingNoCalls {
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        return NO;
    };
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    self.instance = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:self.instanceURL]
                                 authorizationDelegate:mockAuthDelegate];
    self.person.jiveInstance = self.instance;
}

- (void)createJiveAPIObjectWithResponse:(NSString *)resourceName
                andAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    assert(mockAuthURLCheck);
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    };
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    // Reponse file containing data from JIVE My request
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:resourceName
                                                                             ofType:@"json"];
    
    [self createJiveAPIObjectWithResponsePath:contentPath andAuthDelegate:mockAuthDelegate];
}

- (void)createJiveAPIObjectWithImageResponse:(NSString *)resourceName
                     andAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    assert(mockAuthURLCheck);
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    };
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    // Reponse file containing data from JIVE My request
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:resourceName
                                                                             ofType:@"png"];
    
    [self createJiveAPIObjectWithResponsePath:contentPath andAuthDelegate:mockAuthDelegate];
}

- (void)loadPerson:(JivePerson *)target fromJSONNamed:(NSString *)jsonName {
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:jsonName
                                                                          ofType:@"json"];
    NSData *rawJson = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:rawJson
                                                         options:0
                                                           error:NULL];
    [target deserialize:JSON fromInstance:self.instance];
}

- (void)setUp {
    [super setUp];
    self.object = [[JivePerson alloc] init];
    [NSURLProtocol registerClass:[MockJiveURLProtocol class]];
}

- (void)tearDown {
    mockAuthDelegate = nil;
    mockJiveURLResponseDelegate = nil;
    mockJiveURLResponseDelegate2 = nil;
    
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:nil];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:nil];
    [NSURLProtocol unregisterClass:[MockJiveURLProtocol class]];

    [super tearDown];
}

- (JivePerson *)person {
    return (JivePerson *)self.typedObject;
}

- (void)testType {
    XCTAssertEqualObjects(self.person.type, @"person", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [@{JiveTypedObjectAttributes.type:self.person.type} mutableCopy];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.person class], @"Person class not registered with JiveTypedObject.");
}

- (void)testToJSON {
    JivePerson *person = [[JivePerson alloc] init];
    JiveAddress *address = [[JiveAddress alloc] init];
    JivePersonJive *personJive = [[JivePersonJive alloc] init];
    JiveName *name = [[JiveName alloc] init];
    NSString *tag = @"First";
    JiveEmail *email = [[JiveEmail alloc] init];
    JivePhoneNumber *phoneNumber = [[JivePhoneNumber alloc] init];
    NSString *photoURI = @"http://dummy.com/photo.png";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSDictionary *JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"person", @"Wrong type");
    
    personJive.username = @"Philip";
    address.value = @{@"postalCode": @"80215"};
    name.familyName = @"family name";
    email.value = @"email@jive.com";
    phoneNumber.value = @"555-5555";
    [resource setValue:[NSURL URLWithString:photoURI] forKey:JiveResourceEntryAttributes.ref];
    person.addresses = @[address];
    [person setValue:@"testName" forKey:JivePersonAttributes.displayName];
    person.emails = @[email];
    [person setValue:@4 forKey:JivePersonAttributes.followerCount];
    [person setValue:@6 forKey:JivePersonAttributes.followingCount];
    [person setValue:@"1234" forKey:JiveObjectAttributes.jiveId];
    person.jive = personJive;
    person.location = @"USA";
    person.name = name;
    person.phoneNumbers = @[phoneNumber];
    [person setValue:@[photoURI] forKey:JivePersonAttributes.photos];
    [person setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JivePersonAttributes.published];
    [person setValue:@{@"manager":resource} forKey:JiveTypedObjectAttributesHidden.resources];
    person.status = @"Status update";
    person.tags = @[tag];
    [person setValue:@"1111" forKey:JivePersonAttributes.thumbnailId];
    [person setValue:@"http://dummy.com/thumbnail.png" forKey:JivePersonAttributes.thumbnailUrl];
    [person setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JivePersonAttributes.updated];
    
    JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)10, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[@"id"], person.jiveId, @"Wrong id.");
    XCTAssertEqualObjects(JSON[JivePersonAttributes.location], person.location, @"Wrong location");
    XCTAssertEqualObjects(JSON[JivePersonAttributes.status], person.status, @"Wrong status update");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], person.type, @"Wrong type");
    
    NSDictionary *nameJSON = JSON[JivePersonAttributes.name];
    
    XCTAssertTrue([[nameJSON class] isSubclassOfClass:[NSDictionary class]], @"Name not converted");
    XCTAssertEqual([nameJSON count], (NSUInteger)1, @"Name dictionary had the wrong number of entries");
    XCTAssertEqualObjects(nameJSON[@"familyName"], name.familyName, @"Wrong family name");
    
    NSArray *addressJSON = JSON[JivePersonAttributes.addresses];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Address array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[[addressJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"Address object not converted");
    
    NSDictionary *jiveJSON = JSON[JivePersonAttributes.jive];
    
    XCTAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([jiveJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(jiveJSON[JivePersonJiveAttributes.username], personJive.username, @"Wrong user name");
    
    NSArray *tagsJSON = JSON[JivePersonAttributes.tags];
    
    XCTAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    XCTAssertEqual([tagsJSON count], (NSUInteger)1, @"Wrong number of elements in the tags array");
    XCTAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Tag object not converted");
    
    NSArray *emailsJSON = JSON[JivePersonAttributes.emails];
    NSDictionary *emailJSON = [emailsJSON objectAtIndex:0];
    
    XCTAssertTrue([[emailsJSON class] isSubclassOfClass:[NSArray class]], @"Emails array not converted");
    XCTAssertEqual([emailsJSON count], (NSUInteger)1, @"Wrong number of elements in the emails array");
    XCTAssertTrue([[emailJSON class] isSubclassOfClass:[NSDictionary class]], @"Emails object not converted");
    XCTAssertEqualObjects(emailJSON[@"value"], email.value, @"Wrong email");
    
    NSArray *phoneNumbersJSON = JSON[JivePersonAttributes.phoneNumbers];
    NSDictionary *numberJSON = [phoneNumbersJSON objectAtIndex:0];
    
    XCTAssertTrue([[phoneNumbersJSON class] isSubclassOfClass:[NSArray class]], @"Phone numbers array not converted");
    XCTAssertEqual([phoneNumbersJSON count], (NSUInteger)1, @"Wrong number of elements in the phone numbers array");
    XCTAssertTrue([[numberJSON class] isSubclassOfClass:[NSDictionary class]], @"Phone numbers object not converted");
    XCTAssertEqualObjects(numberJSON[@"value"], phoneNumber.value, @"Wrong phone number");
}

- (void)testToJSON_alternate {
    JivePerson *person = [[JivePerson alloc] init];
    JiveName *name = [[JiveName alloc] init];
    JivePersonJive *personJive = [[JivePersonJive alloc] init];
    NSString *tag = @"Giant";
    
    personJive.username = @"Reginald";
    name.familyName = @"Bushnell";
    person.jive = personJive;
    person.name = name;
    person.tags = @[tag];
    person.location = @"Foxtrot";
    person.status = @"Working for the man";
    
    NSDictionary *JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)6, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"person", @"Wrong type");
    XCTAssertEqualObjects(JSON[JivePersonAttributes.location], person.location, @"Wrong location");
    XCTAssertEqualObjects(JSON[JivePersonAttributes.status], person.status, @"Wrong status update");
    
    NSDictionary *nameJSON = JSON[JivePersonAttributes.name];
    
    XCTAssertTrue([[nameJSON class] isSubclassOfClass:[NSDictionary class]], @"Name not converted");
    XCTAssertEqual([nameJSON count], (NSUInteger)1, @"Name dictionary had the wrong number of entries");
    XCTAssertEqualObjects(nameJSON[@"familyName"], name.familyName, @"Wrong family name");
    
    NSDictionary *jiveJSON = JSON[JivePersonAttributes.jive];
    
    XCTAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([jiveJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(jiveJSON[JivePersonJiveAttributes.username], personJive.username, @"Wrong user name");
    
    NSArray *tagsJSON = JSON[JivePersonAttributes.tags];
    
    XCTAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    XCTAssertEqual([tagsJSON count], (NSUInteger)1, @"Wrong number of elements in the tags array");
    XCTAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Tag object not converted");
}

- (void)testToJSON_address {
    JivePerson *person = [[JivePerson alloc] init];
    JiveAddress *address1 = [[JiveAddress alloc] init];
    JiveAddress *address2 = [[JiveAddress alloc] init];
    
    address1.value = @{@"postalCode": @"80215"};
    address2.value = @{@"postalCode": @"80303"};
    [person setValue:@[address1] forKey:JivePersonAttributes.addresses];
    
    NSDictionary *JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = JSON[JivePersonAttributes.addresses];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Address array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Address object not converted");
    XCTAssertEqualObjects(object1[@"value"], address1.value, @"Wrong address label");

    [person setValue:[person.addresses arrayByAddingObject:address2] forKey:JivePersonAttributes.addresses];
    
    JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    addressJSON = JSON[JivePersonAttributes.addresses];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Address array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Address 1 object not converted");
    XCTAssertEqualObjects(object1[@"value"], address1.value, @"Wrong address 1 label");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"Address 2 object not converted");
    XCTAssertEqualObjects(object2[@"value"], address2.value, @"Wrong address 2 label");
}

- (void)testToJSON_email {
    JivePerson *person = [[JivePerson alloc] init];
    JiveEmail *email1 = [[JiveEmail alloc] init];
    JiveEmail *email2 = [[JiveEmail alloc] init];
    
    email1.value = @"Address 1";
    email2.value = @"Address 2";
    [person setValue:@[email1] forKey:JivePersonAttributes.emails];
    
    NSDictionary *JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = JSON[JivePersonAttributes.emails];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Email array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the email array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Email object not converted");
    XCTAssertEqualObjects(object1[@"value"], email1.value, @"Wrong email label");
    
    [person setValue:[person.emails arrayByAddingObject:email2] forKey:JivePersonAttributes.emails];
    
    JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    addressJSON = JSON[JivePersonAttributes.emails];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Email array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the email array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Email 1 object not converted");
    XCTAssertEqualObjects(object1[@"value"], email1.value, @"Wrong email 1 label");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"Email 2 object not converted");
    XCTAssertEqualObjects(object2[@"value"], email2.value, @"Wrong email 2 label");
}

- (void)testToJSON_phoneNumbers {
    JivePerson *person = [[JivePerson alloc] init];
    JivePhoneNumber *phoneNumber1 = [[JivePhoneNumber alloc] init];
    JivePhoneNumber *phoneNumber2 = [[JivePhoneNumber alloc] init];
    
    phoneNumber1.value = @"Address 1";
    phoneNumber2.value = @"Address 2";
    [person setValue:@[phoneNumber1] forKey:JivePersonAttributes.phoneNumbers];
    
    NSDictionary *JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = JSON[JivePersonAttributes.phoneNumbers];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Phone number array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the phone number array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Phone number object not converted");
    XCTAssertEqualObjects(object1[@"value"], phoneNumber1.value, @"Wrong phone number label");
    
    [person setValue:[person.phoneNumbers arrayByAddingObject:phoneNumber2] forKey:JivePersonAttributes.phoneNumbers];
    
    JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    addressJSON = JSON[JivePersonAttributes.phoneNumbers];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Phone number array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the phone number array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Phone number 1 object not converted");
    XCTAssertEqualObjects(object1[@"value"], phoneNumber1.value, @"Wrong phone number 1 label");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"Phone number 2 object not converted");
    XCTAssertEqualObjects(object2[@"value"], phoneNumber2.value, @"Wrong phone number 2 label");
}

- (void)testToJSON_tags {
    JivePerson *person = [[JivePerson alloc] init];
    NSString *tag1 = @"First";
    NSString *tag2 = @"Last";
    
    [person setValue:@[tag1] forKey:JivePersonAttributes.tags];
    
    NSDictionary *JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = JSON[JivePersonAttributes.tags];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the tags array");
    XCTAssertEqualObjects([addressJSON objectAtIndex:0], tag1, @"Wrong tag value");
    
    [person setValue:[person.tags arrayByAddingObject:tag2] forKey:JivePersonAttributes.tags];
    
    JSON = [person toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    addressJSON = JSON[JivePersonAttributes.tags];
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the tags array");
    XCTAssertEqualObjects([addressJSON objectAtIndex:0], tag1, @"Wrong tag 1 value");
    XCTAssertEqualObjects([addressJSON objectAtIndex:1], tag2, @"Wrong tag 2 value");
}

- (void)testPersonParsing {
    JivePerson *basePerson = [[JivePerson alloc] init];
    JiveAddress *address = [[JiveAddress alloc] init];
    JivePersonJive *personJive = [[JivePersonJive alloc] init];
    JiveName *name = [[JiveName alloc] init];
    NSString *tag = @"First";
    JiveEmail *email = [[JiveEmail alloc] init];
    JivePhoneNumber *phoneNumber = [[JivePhoneNumber alloc] init];
    NSString *photoURI = @"http://dummy.com/photo.png";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    
    address.value = @{@"postalCode": @"80215"};
    personJive.username = @"Address 1";
    name.familyName = @"family name";
    phoneNumber.value = @"555-5555";
    email.value = @"email";
    [resource setValue:[NSURL URLWithString:photoURI] forKey:JiveResourceEntryAttributes.ref];
    [resource setValue:@[] forKey:JiveResourceEntryAttributes.allowed];
    [basePerson setValue:@"testName" forKey:JivePersonAttributes.displayName];
    [basePerson setValue:@"1234" forKey:JiveObjectAttributes.jiveId];
    basePerson.location = @"USA";
    basePerson.status = @"Status update";
    [basePerson setValue:@"1111" forKey:JivePersonAttributes.thumbnailId];
    [basePerson setValue:@"http://dummy.com/thumbnail.png" forKey:JivePersonAttributes.thumbnailUrl];
    [basePerson setValue:@4 forKey:JivePersonAttributes.followerCount];
    [basePerson setValue:@6 forKey:JivePersonAttributes.followingCount];
    [basePerson setValue:name forKey:JivePersonAttributes.name];
    [basePerson setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JivePersonAttributes.published];
    [basePerson setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JivePersonAttributes.updated];
    [basePerson setValue:@[address] forKey:JivePersonAttributes.addresses];
    [basePerson setValue:personJive forKey:JivePersonAttributes.jive];
    [basePerson setValue:@[tag] forKey:JivePersonAttributes.tags];
    [basePerson setValue:@[email] forKey:JivePersonAttributes.emails];
    [basePerson setValue:@[phoneNumber] forKey:JivePersonAttributes.phoneNumbers];
    [basePerson setValue:@[photoURI] forKey:JivePersonAttributes.photos];
    [basePerson setValue:@{resourceKey:resource} forKey:JiveTypedObjectAttributesHidden.resources];
//    [JSON setValue:@[photoURI] forKey:JivePersonAttributes.photos];
    
    NSDictionary *JSON = [basePerson persistentJSON];
    JivePerson *newPerson = [JivePerson objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([newPerson class], [JivePerson class], @"Wrong item class");
    XCTAssertEqualObjects(newPerson.displayName, basePerson.displayName, @"Wrong display name");
    XCTAssertEqualObjects(newPerson.followerCount, basePerson.followerCount, @"Wrong follower count");
    XCTAssertEqualObjects(newPerson.followingCount, basePerson.followingCount, @"Wrong following count");
    XCTAssertEqualObjects(newPerson.jiveId, basePerson.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newPerson.jive.username, basePerson.jive.username, @"Wrong Jive Person");
    XCTAssertEqualObjects(newPerson.location, basePerson.location, @"Wrong location");
    XCTAssertEqualObjects(newPerson.name.familyName, basePerson.name.familyName, @"Wrong name");
    XCTAssertEqualObjects(newPerson.published, basePerson.published, @"Wrong published date");
    XCTAssertEqualObjects(newPerson.status, basePerson.status, @"Wrong status");
    XCTAssertEqualObjects(newPerson.thumbnailId, basePerson.thumbnailId);
    XCTAssertEqualObjects(newPerson.thumbnailUrl, basePerson.thumbnailUrl, @"Wrong thumbnailUrl");
    XCTAssertEqualObjects(newPerson.type, @"person", @"Wrong type");
    XCTAssertEqualObjects(newPerson.updated, basePerson.updated, @"Wrong updated date");
    XCTAssertEqual([newPerson.addresses count], [basePerson.addresses count], @"Wrong number of address objects");
    if ([newPerson.addresses count] > 0) {
        id convertedAddress = [newPerson.addresses objectAtIndex:0];
        XCTAssertEqual([convertedAddress class], [JiveAddress class], @"Wrong address object class");
        if ([[convertedAddress class] isSubclassOfClass:[JiveAddress class]])
            XCTAssertEqualObjects([(JiveAddress *)convertedAddress value],
                                 [(JiveAddress *)[basePerson.addresses objectAtIndex:0] value],
                                 @"Wrong Address object");
    }
    XCTAssertEqual([newPerson.emails count], [basePerson.emails count], @"Wrong number of email objects");
    if ([newPerson.emails count] > 0) {
        id convertedEmail = [newPerson.emails objectAtIndex:0];
        XCTAssertEqual([convertedEmail class], [JiveEmail class], @"Wrong email object class");
        if ([[convertedEmail class] isSubclassOfClass:[JiveEmail class]])
            XCTAssertEqualObjects([(JiveEmail *)convertedEmail value],
                                 [(JiveEmail *)[basePerson.emails objectAtIndex:0] value],
                                 @"Wrong email object");
    }
    XCTAssertEqual([newPerson.phoneNumbers count], [basePerson.phoneNumbers count], @"Wrong number of phone number objects");
    if ([newPerson.phoneNumbers count] > 0) {
        id convertedPhoneNumber = [newPerson.phoneNumbers objectAtIndex:0];
        XCTAssertEqual([convertedPhoneNumber class], [JivePhoneNumber class], @"Wrong phone number object class");
        if ([[convertedPhoneNumber class] isSubclassOfClass:[JivePhoneNumber class]])
            XCTAssertEqualObjects([(JivePhoneNumber *)convertedPhoneNumber value],
                                 [(JivePhoneNumber *)[basePerson.phoneNumbers objectAtIndex:0] value],
                                 @"Wrong phone number object");
    }
//    STAssertEquals([newPerson.photos count], [basePerson.photos count], @"Wrong number of photo objects");
//    STAssertEqualObjects([newPerson.photos objectAtIndex:0], [basePerson.photos objectAtIndex:0], @"Wrong photo object class");
    XCTAssertEqual([newPerson.tags count], [basePerson.tags count], @"Wrong number of tag objects");
    XCTAssertEqualObjects([newPerson.tags objectAtIndex:0], [basePerson.tags objectAtIndex:0], @"Wrong tag object class");
    XCTAssertEqual([newPerson.resources count], [basePerson.resources count], @"Wrong number of resource objects");
    XCTAssertEqualObjects([(JiveResourceEntry *)newPerson.resources[resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testPersonParsingAlternate {
    JivePerson *basePerson = [JivePerson new];
    JiveAddress *address = [JiveAddress new];
    JivePersonJive *personJive = [JivePersonJive new];
    JiveProfileEntry *profileEntry = [JiveProfileEntry new];
    JiveName *name = [JiveName new];
    NSString *tag = @"Gigantic";
    JiveEmail *email = [JiveEmail new];
    JivePhoneNumber *phoneNumber = [JivePhoneNumber new];
    NSString *photoURI = @"http://com.dummy/png.photo";
    JiveResourceEntry *resource = [JiveResourceEntry new];
    NSString *resourceKey = @"followers";
    NSString *profileValue = @"department";
    
    address.value = @{@"postalCode": @"80303"};
    [profileEntry setValue:profileValue forKey:JiveProfileEntryAttributes.jive_label];
    personJive.username = @"name";
    [personJive setValue:@[profileEntry] forKey:JivePersonJiveAttributes.profile];
    name.familyName = @"Bushnell";
    phoneNumber.value = @"777-7777";
    email.value = @"something.com";
    [resource setValue:[NSURL URLWithString:photoURI] forKey:JiveResourceEntryAttributes.ref];
    [resource setValue:@[] forKey:JiveResourceEntryAttributes.allowed];
    [basePerson setValue:@"display name" forKey:JivePersonAttributes.displayName];
    [basePerson setValue:@"87654" forKey:JiveObjectAttributes.jiveId];
    basePerson.location = @"New Mexico";
    basePerson.status = @"No status";
    [basePerson setValue:@"531" forKey:JivePersonAttributes.thumbnailId];
    [basePerson setValue:@"http://com.dummy/png.thumbnail" forKey:JivePersonAttributes.thumbnailUrl];
    [basePerson setValue:@6 forKey:JivePersonAttributes.followerCount];
    [basePerson setValue:@4 forKey:JivePersonAttributes.followingCount];
    [basePerson setValue:name forKey:JivePersonAttributes.name];
    [basePerson setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                  forKey:JivePersonAttributes.published];
    [basePerson setValue:[NSDate dateWithTimeIntervalSince1970:0]
                  forKey:JivePersonAttributes.updated];
    [basePerson setValue:@[address] forKey:JivePersonAttributes.addresses];
    [basePerson setValue:personJive forKey:JivePersonAttributes.jive];
    [basePerson setValue:@[tag] forKey:JivePersonAttributes.tags];
    [basePerson setValue:@[email] forKey:JivePersonAttributes.emails];
    [basePerson setValue:@[phoneNumber] forKey:JivePersonAttributes.phoneNumbers];
    [basePerson setValue:@[photoURI] forKey:JivePersonAttributes.photos];
    [basePerson setValue:@{resourceKey:resource} forKey:JiveTypedObjectAttributesHidden.resources];
//    [JSON setValue:@[photoURI] forKey:JivePersonAttributes.photos];
    
    NSDictionary *JSON = [basePerson persistentJSON];
    JivePerson *newPerson = [JivePerson objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([newPerson class], [JivePerson class], @"Wrong item class");
    XCTAssertEqualObjects(newPerson.displayName, basePerson.displayName, @"Wrong display name");
    XCTAssertEqualObjects(newPerson.followerCount, basePerson.followerCount, @"Wrong follower count");
    XCTAssertEqualObjects(newPerson.followingCount, basePerson.followingCount, @"Wrong following count");
    XCTAssertEqualObjects(newPerson.jiveId, basePerson.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newPerson.jive.username, basePerson.jive.username, @"Wrong Jive Person");
    XCTAssertEqualObjects(newPerson.location, basePerson.location, @"Wrong location");
    XCTAssertEqualObjects(newPerson.name.familyName, basePerson.name.familyName, @"Wrong name");
    XCTAssertEqualObjects(newPerson.published, basePerson.published, @"Wrong published date");
    XCTAssertEqualObjects(newPerson.status, basePerson.status, @"Wrong status");
    XCTAssertEqualObjects(newPerson.thumbnailId, basePerson.thumbnailId);
    XCTAssertEqualObjects(newPerson.thumbnailUrl, basePerson.thumbnailUrl, @"Wrong thumbnailUrl");
    XCTAssertEqualObjects(newPerson.type, @"person", @"Wrong type");
    XCTAssertEqualObjects(newPerson.updated, basePerson.updated, @"Wrong updated date");
    XCTAssertEqual([newPerson.addresses count], [basePerson.addresses count], @"Wrong number of address objects");
    if ([newPerson.addresses count] > 0) {
        id convertedAddress = [newPerson.addresses objectAtIndex:0];
        XCTAssertEqual([convertedAddress class], [JiveAddress class], @"Wrong address object class");
        if ([[convertedAddress class] isSubclassOfClass:[JiveAddress class]])
            XCTAssertEqualObjects([(JiveAddress *)convertedAddress value],
                                 [(JiveAddress *)[basePerson.addresses objectAtIndex:0] value],
                                 @"Wrong Address object");
    }
    XCTAssertEqual([newPerson.emails count], [basePerson.emails count], @"Wrong number of email objects");
    if ([newPerson.emails count] > 0) {
        id convertedEmail = [newPerson.emails objectAtIndex:0];
        XCTAssertEqual([convertedEmail class], [JiveEmail class], @"Wrong email object class");
        if ([[convertedEmail class] isSubclassOfClass:[JiveEmail class]])
            XCTAssertEqualObjects([(JiveEmail *)convertedEmail value],
                                 [(JiveEmail *)[basePerson.emails objectAtIndex:0] value],
                                 @"Wrong email object");
    }
    XCTAssertEqual([newPerson.phoneNumbers count], [basePerson.phoneNumbers count], @"Wrong number of phone number objects");
    if ([newPerson.phoneNumbers count] > 0) {
        id convertedPhoneNumber = [newPerson.phoneNumbers objectAtIndex:0];
        XCTAssertEqual([convertedPhoneNumber class], [JivePhoneNumber class], @"Wrong phone number object class");
        if ([[convertedPhoneNumber class] isSubclassOfClass:[JivePhoneNumber class]])
            XCTAssertEqualObjects([(JivePhoneNumber *)convertedPhoneNumber value],
                                 [(JivePhoneNumber *)[basePerson.phoneNumbers objectAtIndex:0] value],
                                 @"Wrong phone number object");
    }
//    STAssertEquals([person.photos count], [basePerson.photos count], @"Wrong number of photo objects");
//    STAssertEqualObjects([person.photos objectAtIndex:0], [basePerson.photos objectAtIndex:0], @"Wrong photo object class");
    XCTAssertEqual([newPerson.tags count], [basePerson.tags count], @"Wrong number of tag objects");
    XCTAssertEqualObjects([newPerson.tags objectAtIndex:0], [basePerson.tags objectAtIndex:0], @"Wrong tag object class");
    XCTAssertEqual([newPerson.resources count], [basePerson.resources count], @"Wrong number of resource objects");
    XCTAssertEqualObjects([(JiveResourceEntry *)newPerson.resources[resourceKey] ref], resource.ref, @"Wrong resource object");
    XCTAssertEqual([newPerson.jive.profile count], (NSUInteger)1, @"Wrong number of profile objects");
    if ([newPerson.jive.profile count] > 0) {
        JiveProfileEntry *convertedProfile = [newPerson.jive.profile objectAtIndex:0];
        XCTAssertEqual([convertedProfile class], [JiveProfileEntry class], @"Wrong profile object class");
        if ([[convertedProfile class] isSubclassOfClass:[JiveProfileEntry class]])
            XCTAssertEqualObjects(convertedProfile.jive_label, profileValue, @"Wrong profile object");
    }
}

- (void) testRefreshOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person refreshOperationWithOptions:options
                                             onComplete:^(JivePerson *person) {
                                                 XCTAssertEqual(person, self.person, @"Person object not updated");
                                                 XCTAssertEqualObjects(self.person.jiveId, @"5316", @"Wrong jiveId");
                                                 completionBlock(person);
                                             }
                                                onError:errorBlock];
    }
                  withResponse:@"person_response"
                         setup:^{
                             [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
                             XCTAssertEqualObjects(self.person.jiveId, @"3550", @"PRECONDITION: Wrong jiveId");
                         }
                           URL:@"https://testing.jiveland.com/api/core/v3/people/3550?fields=id"
                 expectedClass:[JivePerson class]];
}

- (void) testRefreshServiceCall {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316?fields=name,id"];
    
    XCTAssertEqualObjects(self.person.jiveId, @"5316", @"PRECONDITION: Wrong jiveId");
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person refreshWithOptions:options
                             onComplete:^(JivePerson *person) {
                                 XCTAssertEqual([person class], [JivePerson class], @"Wrong item class");
                                 XCTAssertEqualObjects(self.person.jiveId, @"3550", @"Wrong jiveId");
                                 
                                 // Check that delegates where actually called
                                 [mockAuthDelegate verify];
                                 [mockJiveURLResponseDelegate verify];
                                 finishedBlock();
                             } onError:^(NSError *error) {
                                 XCTFail(@"%@", [error localizedDescription]);
                                 finishedBlock();
                             }];
    });
}

- (void) testRefreshServiceCall_wrongClassResponse {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"task"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316?fields=name,id"];
    
    XCTAssertEqualObjects(self.person.jiveId, @"5316", @"PRECONDITION: Wrong jiveId");
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person refreshWithOptions:options
                             onComplete:^(JivePerson *person) {
                                 XCTFail(@"The person object should not be updated with a task response");
                                 finishedBlock();
                             } onError:^(NSError *error) {
                                 XCTAssertEqualObjects([error domain], JiveErrorDomain);
                                 XCTAssertEqual([error code], JiveErrorCodeInvalidJSON);
                                 finishedBlock();
                             }];
    });
}

- (void) testDeletePersonOperation {
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/3550"];
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person deleteOperationOnComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            XCTFail(@"%@", [error localizedDescription]);
            finishedBlock();
        }];
        
        XCTAssertEqualObjects(JiveHTTPMethodTypes.DELETE, operation.request.HTTPMethod, @"Wrong http method used");
        [operation start];
    });
}

- (void) testDeletePersonServiceCall {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person deleteOnComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            XCTFail(@"%@", [error localizedDescription]);
            finishedBlock();
        }];
    });
}

- (void) testUpdatePersonOperation {
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        NSDictionary *JSON = [self.person toJSONDictionary];
        NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
        AFURLConnectionOperation *operation = [self.person updateOperationOnComplete:^(JivePerson *person) {
            XCTAssertEqual(person, self.person, @"Person object not updated");
            XCTAssertEqualObjects(self.person.jiveId, @"5316", @"Wrong jiveId");
            XCTAssertEqualObjects(self.person.location, @"home on the range", @"New object not created");
            completionBlock(person);
        }
                                                                             onError:errorBlock];

        XCTAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        XCTAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        XCTAssertEqualObjects([operation.request valueForHTTPHeaderField:JiveHTTPHeaderFields.contentType], @"application/json; charset=UTF-8", @"Wrong content type");
        XCTAssertEqual([[operation.request valueForHTTPHeaderField:JiveHTTPHeaderFields.contentLength] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"person_response"
                         setup:^{
                             [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
                             self.person.location = @"alternate";
                             XCTAssertEqualObjects(self.person.jiveId, @"3550", @"PRECONDITION: Wrong jiveId");
                         }
                           URL:@"https://testing.jiveland.com/api/core/v3/people/3550"
                 expectedClass:[JivePerson class]];
}

- (void) testUpdatePerson {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person updateOnComplete:^(JivePerson *person) {
            XCTAssertEqual(person, self.person, @"Person object not updated");
            XCTAssertEqualObjects(self.person.jiveId, @"3550", @"Wrong jiveId");
            XCTAssertEqualObjects(person.location, @"Portland", @"New object not created");

            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            XCTFail(@"%@", [error localizedDescription]);
            finishedBlock();
        }];
    });
}

- (void) testGetBlogOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person blogOperationWithOptions:options
                                          onComplete:completionBlock
                                             onError:errorBlock];
    }
                  withResponse:@"blog"
                           URL:@"https://testing.jiveland.com/api/core/v3/people/3550/blog?fields=id"
                 expectedClass:[JiveBlog class]];
}

- (void) testGetBlog {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"blog"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/blog?fields=name,id"];

    // Make the call
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person blogWithOptions:options
                          onComplete:^(JiveBlog *blog) {
                              XCTAssertEqual([blog class], [JiveBlog class], @"Wrong item class");
                              
                              // Check that delegates where actually called
                              [mockAuthDelegate verify];
                              [mockJiveURLResponseDelegate verify];
                              finishedBlock();
                          } onError:^(NSError *error) {
                              XCTFail(@"%@", [error localizedDescription]);
                              finishedBlock();
                          }];
    });
}

- (void) testGetManagerOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person managerOperationWithOptions:options
                                             onComplete:^(JivePerson *person) {
                                                 XCTAssertFalse(person == self.person, @"Failed to create a new JivePerson object");
                                                 XCTAssertFalse(person.jiveId == self.person.jiveId, @"Failed to create the correct JiveObject");
                                                 XCTAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                                 completionBlock(person);
                                             }
                                                onError:errorBlock];
    }
                  withResponse:@"person_response"
                           URL:@"https://testing.jiveland.com/api/core/v3/people/3550/@manager?fields=id"
                 expectedClass:[JivePerson class]];
}

- (void) testGetManager {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/@manager?fields=name,id"];

    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person managerWithOptions:options
                             onComplete:^(JivePerson *person) {
                                 XCTAssertEqual([person class], [JivePerson class], @"Wrong item class");
                                 XCTAssertFalse(person == self.person, @"Failed to create a new JivePerson object");
                                 XCTAssertFalse(person.jiveId == self.person.jiveId, @"Failed to create the correct JiveObject");
                                 XCTAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                 
                                 // Check that delegates where actually called
                                 [mockAuthDelegate verify];
                                 [mockJiveURLResponseDelegate verify];
                                 finishedBlock();
                             } onError:^(NSError *error) {
                                 XCTFail(@"%@", [error localizedDescription]);
                                 finishedBlock();
                             }];
    });
}

- (void) testColleguesOperation {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 5;
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person colleguesOperationWithOptions:options
                                               onComplete:completionBlock
                                                  onError:errorBlock];
    }
                      withResponse:@"collegues_response"
                               URL:@"https://testing.jiveland.com/api/core/v3/people/3550/@colleagues?startIndex=5"
                     expectedCount:9];
}

- (void) testColleguesServiceCall {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"collegues_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/@colleagues?startIndex=10"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person colleguesWithOptions:options
                               onComplete:^(NSArray *people) {
                                   XCTAssertEqual([people count], (NSUInteger)9, @"Wrong number of items parsed");
                                   XCTAssertEqual([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
                                   for (JivePerson *person in people) {
                                       XCTAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                                       XCTAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                   }
                                   
                                   // Check that delegates where actually called
                                   [mockAuthDelegate verify];
                                   [mockJiveURLResponseDelegate verify];
                                   finishedBlock();
                               } onError:^(NSError *error) {
                                   XCTFail(@"%@", [error localizedDescription]);
                                   finishedBlock();
                               }];
    });
}

- (void) testGetReportsOperation {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 10;
    self.instanceURL = @"http://gigi-eae03.eng.jiveland.com/";
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person reportsOperationWithOptions:options
                                             onComplete:completionBlock
                                                onError:errorBlock];
    }
                      withResponse:@"people_response"
                               URL:@"http://gigi-eae03.eng.jiveland.com/api/core/v3/people/3550/@reports?count=10"
                     expectedCount:20];
}

- (void) testGetReports {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 3;
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"people_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/@reports?count=3"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person reportsWithOptions:options
                             onComplete:^(NSArray *people) {
                                 XCTAssertEqual([people count], (NSUInteger)20, @"Wrong number of items parsed");
                                 XCTAssertEqual([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
                                 for (JivePerson *person in people) {
                                     XCTAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                                     XCTAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                 }
                                 
                                 // Check that delegates where actually called
                                 [mockAuthDelegate verify];
                                 [mockJiveURLResponseDelegate verify];
                                 finishedBlock();
                             } onError:^(NSError *error) {
                                 XCTFail(@"%@", [error localizedDescription]);
                                 finishedBlock();
                             }];
    });
}

- (void) testFollowersOperationWithOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    options.count = 10;
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person followersOperationWithOptions:options
                                               onComplete:completionBlock
                                                  onError:errorBlock];
    }
                      withResponse:@"followers_response"
                               URL:@"https://testing.jiveland.com/api/core/v3/people/3550/@followers?count=10&startIndex=10"
                     expectedCount:23];
}

- (void) testFollowersServiceCallWithOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 0;
    options.count = 5;
    [options addField:@"dummy"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"followers_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/@followers?fields=dummy&count=5"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person followersWithOptions:options
                               onComplete:^(NSArray *people) {
                                   XCTAssertEqual([people count], (NSUInteger)23, @"Wrong number of items parsed");
                                   XCTAssertEqual([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
                                   for (JivePerson *person in people) {
                                       XCTAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                                       XCTAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                   }
                                   
                                   // Check that delegates where actually called
                                   [mockAuthDelegate verify];
                                   [mockJiveURLResponseDelegate verify];
                                   finishedBlock();
                               } onError:^(NSError *error) {
                                   XCTFail(@"%@", [error localizedDescription]);
                                   finishedBlock();
                               }];
    });
}

- (void) testFollowersServiceCallWithDifferentOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 6;
    options.count = 3;
    [options addField:@"dummy"];
    [options addField:@"second"];
    [options addField:@"third"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"followers_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/@followers?fields=dummy,second,third&count=3&startIndex=6"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person followersWithOptions:options
                               onComplete:^(NSArray *people) {
                                   XCTAssertEqual([people count], (NSUInteger)23, @"Wrong number of items parsed");
                                   XCTAssertEqual([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
                                   for (JivePerson *person in people) {
                                       XCTAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                                       XCTAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                   }
                                   
                                   // Check that delegates where actually called
                                   [mockAuthDelegate verify];
                                   [mockJiveURLResponseDelegate verify];
                                   finishedBlock();
                               } onError:^(NSError *error) {
                                   XCTFail(@"%@", [error localizedDescription]);
                                   finishedBlock();
                               }];
    });
}

- (void) testGetFollowingOperation {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 10;
    self.instanceURL = @"http://gigi-eae03.eng.jiveland.com/";
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person followingOperationWithOptions:options
                                               onComplete:completionBlock
                                                  onError:errorBlock];
    }
                      withResponse:@"people_response"
                               URL:@"http://gigi-eae03.eng.jiveland.com/api/core/v3/people/3550/@following?count=10"
                     expectedCount:20];
}

- (void) testGetFollowing {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 3;
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"people_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/@following?count=3"];

    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person followingWithOptions:options
                               onComplete:^(NSArray *people) {
                                   XCTAssertEqual([people count], (NSUInteger)20, @"Wrong number of items parsed");
                                   XCTAssertEqual([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
                                   for (JivePerson *person in people) {
                                       XCTAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                                       XCTAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                   }
                                   
                                   // Check that delegates where actually called
                                   [mockAuthDelegate verify];
                                   [mockJiveURLResponseDelegate verify];
                                   finishedBlock();
                               } onError:^(NSError *error) {
                                   XCTFail(@"%@", [error localizedDescription]);
                                   finishedBlock();
                               }];
    });
}

- (void)checkListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                             JiveErrorBlock errorBlock))createOperation
              withResponse:(NSString *)response
                     setup:(void (^)())setupBlock
                       URL:(NSString *)url
             expectedCount:(NSUInteger)expectedCount
             expectedClass:(Class)clazz {
    
    JiveArrayCompleteBlock completeBlock = ^(NSArray *collection) {
        XCTAssertEqual([collection count], expectedCount, @"Wrong number of items parsed");
        for (id collectionObject in collection) {
            XCTAssertTrue([collectionObject isKindOfClass:clazz], @"Item %@ is not of class %@",
                         collectionObject, clazz);
        }
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    };
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation* operation = createOperation(^(NSArray *streams) {
            completeBlock(streams);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     XCTFail(@"%@", [error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        XCTAssertNotNil(operation, @"Missing operation object");
        [operation start];
    });
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:url];
        setupBlock();
        self.person.jiveInstance.badInstanceURL = @"testing.jiveland.com";
        NSOperation* operation = createOperation(^(NSArray *streams) {
            XCTAssertNil(self.person.jiveInstance.badInstanceURL,
                        @"badInstanceURL was not cleared: %@",
                        self.person.jiveInstance.badInstanceURL);
            completeBlock(streams);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     XCTFail(@"%@", [error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        XCTAssertNotNil(operation, @"Missing clear bad instance check operation object");
        [operation start];
    });
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        NSInteger error_code = 404;
        [self createJiveAPIObjectWithErrorCode:error_code andAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation *operation = createOperation(^(NSArray *streams) {
            XCTFail(@"404 errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     XCTAssertEqual([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    error_code,
                                                                    @"Wrong error reported");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        XCTAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    });
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithTermsAndConditionsFailureAndAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation *operation = createOperation(^(NSArray *streams) {
            XCTFail(@"Terms and Conditions errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     XCTAssertEqual([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    (NSInteger)0,
                                                                    @"Wrong error reported");
                                                     XCTAssertEqualObjects(error.userInfo[JiveErrorKeyTermsAndConditionsAPI],
                                                                          @"/api/core/v3/people/@me/termsAndConditions",
                                                                          @"Wrong terms and conditions api");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        XCTAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    });

    waitForTimeout(^(dispatch_block_t finishedBlock) {
        NSString *proxyInstanceURL = ([self.instanceURL hasSuffix:@"/"] ?
                                      @"http://testing.jiveland.com/" :
                                      @"http://testing.jiveland.com");
        NSString *testURL = [url stringByReplacingOccurrencesOfString:self.instanceURL
                                                           withString:proxyInstanceURL];
        
        self.instanceURL = proxyInstanceURL;
        self.person.jiveInstance.jiveInstanceURL = [NSURL URLWithString:proxyInstanceURL];
        
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:testURL];
        setupBlock();
        self.person.jiveInstance.badInstanceURL = nil;
        NSOperation* operation = createOperation(^(NSArray *streams) {
            XCTAssertNotNil(self.person.jiveInstance.badInstanceURL, @"badInstanceURL not updated.");
            completeBlock(streams);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     XCTFail(@"%@", [error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        XCTAssertNotNil(operation, @"Missing bad instance check operation object");
        [operation start];
    });
}

- (void)checkListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                             JiveErrorBlock errorBlock))createOperation
              withResponse:(NSString *)response
                       URL:(NSString *)url
             expectedCount:(NSUInteger)expectedCount
             expectedClass:(Class)clazz {
    [self checkListOperation:createOperation
                withResponse:response
                       setup:^{ }
                         URL:url
               expectedCount:expectedCount
               expectedClass:clazz];
}

- (void)checkPersonListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                                   JiveErrorBlock errorBlock))createOperation
                    withResponse:(NSString *)response
                           setup:(void (^)())setupBlock
                             URL:(NSString *)url
                   expectedCount:(NSUInteger)expectedCount {
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return createOperation(^(NSArray *people) {
            for (JivePerson *person in people) {
                XCTAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                XCTAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
            }
            completionBlock(people);
        }, errorBlock);
    }
                withResponse:response
                       setup:setupBlock
                         URL:url
               expectedCount:expectedCount
               expectedClass:[JivePerson class]];
}

- (void)checkPersonListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                                   JiveErrorBlock errorBlock))createOperation
                    withResponse:(NSString *)response
                             URL:(NSString *)url
                   expectedCount:(NSUInteger)expectedCount {
    [self checkPersonListOperation:createOperation
                      withResponse:response
                             setup:^{ }
                               URL:url
                     expectedCount:expectedCount];
}

- (void)checkObjectOperation:(NSOperation *(^)(JiveObjectCompleteBlock completionBlock,
                                               JiveErrorBlock errorBlock))createOperation
                withResponse:(NSString *)response
                       setup:(void (^)())setupBlock
                         URL:(NSString *)url
               expectedClass:(Class)clazz {
    
    JiveObjectCompleteBlock completeBlock = ^(id object) {
        XCTAssertEqual([object class], clazz, @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    };
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation* operation = createOperation(^(id object) {
            completeBlock(object);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     XCTFail(@"%@", [error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        XCTAssertNotNil(operation, @"Missing operation object");
        [operation start];
    });
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:url];
        setupBlock();
        self.person.jiveInstance.badInstanceURL = @"brewspace";
        NSOperation* operation = createOperation(^(id object) {
            XCTAssertNil(self.person.jiveInstance.badInstanceURL,
                        @"badInstanceURL was not cleared: %@",
                        self.person.jiveInstance.badInstanceURL);
            completeBlock(object);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     XCTFail(@"%@", [error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        XCTAssertNotNil(operation, @"Missing clear bad instance check operation object");
        [operation start];
    });
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        NSInteger error_code = 404;
        [self createJiveAPIObjectWithErrorCode:error_code andAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation *operation = createOperation(^(id object) {
            XCTFail(@"404 errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     XCTAssertEqual([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    error_code,
                                                                    @"Wrong error reported");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        XCTAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    });
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithTermsAndConditionsFailureAndAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation *operation = createOperation(^(id object) {
            XCTFail(@"Terms and Conditions errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     XCTAssertEqual([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    (NSInteger)0,
                                                                    @"Wrong error reported");
                                                     XCTAssertEqualObjects(error.userInfo[JiveErrorKeyTermsAndConditionsAPI],
                                                                          @"/api/core/v3/people/@me/termsAndConditions",
                                                                          @"Wrong terms and conditions api");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        XCTAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    });
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        NSString *canonicalProxyInstanceURL = @"http://brewspace.com/";
        NSString *proxyInstanceURL = ([self.instanceURL hasSuffix:@"/"] ?
                                      canonicalProxyInstanceURL :
                                      @"http://brewspace.com");
        NSString *instanceURLString = [url stringByReplacingOccurrencesOfString:self.instance.jiveInstanceURL.absoluteString
                                                                     withString:proxyInstanceURL];
        
        self.instanceURL = canonicalProxyInstanceURL;
        
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:instanceURLString];
        setupBlock();
        self.person.jiveInstance.badInstanceURL = nil;
        NSOperation* operation = createOperation(^(id object) {
            XCTAssertNotNil(self.person.jiveInstance.badInstanceURL,
                           @"badInstanceURL not updated: %@",
                           self.person.jiveInstance.badInstanceURL);
            completeBlock(object);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     XCTFail(@"%@", [error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        XCTAssertNotNil(operation, @"Missing bad instance check operation object");
        [operation start];
    });
}

- (void)checkObjectOperation:(NSOperation *(^)(JiveObjectCompleteBlock completionBlock,
                                               JiveErrorBlock errorBlock))createOperation
                withResponse:(NSString *)response
                         URL:(NSString *)url
               expectedClass:(Class)clazz {
    [self checkObjectOperation:createOperation
                  withResponse:response
                         setup:^{ }
                           URL:url
                 expectedClass:clazz];
}

- (void) testFollowingInOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person followingInOperationWithOptions:options
                                                 onComplete:completionBlock
                                                    onError:errorBlock];
    }
                withResponse:@"followingIn_streams"
                         URL:@"https://testing.jiveland.com/api/core/v3/people/3550/followingIn?fields=id"
               expectedCount:1
               expectedClass:[JiveStream class]];
}

- (void) testFollowingIn {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"followingIn_streams"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/followingIn?fields=name,id"];

    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person followingInWithOptions:options
                                 onComplete:^(NSArray *streams) {
                                     XCTAssertEqual([streams count], (NSUInteger)1, @"Wrong number of items parsed");
                                     XCTAssertTrue([[streams objectAtIndex:0] isKindOfClass:[JiveStream class]], @"Wrong item class");
                                     
                                     // Check that delegates where actually called
                                     [mockAuthDelegate verify];
                                     [mockJiveURLResponseDelegate verify];
                                     finishedBlock();
                                 } onError:^(NSError *error) {
                                     XCTFail(@"%@", [error localizedDescription]);
                                     finishedBlock();
                                 }];
    });
}

- (void) testStreamsOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person streamsOperationWithOptions:options
                                             onComplete:completionBlock
                                                onError:errorBlock];
    }
                withResponse:@"person_streams"
                         URL:@"https://testing.jiveland.com/api/core/v3/people/3550/streams?fields=name,id"
               expectedCount:5
               expectedClass:[JiveStream class]];
}

- (void) testStreams {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_streams"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/streams?fields=id"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person streamsWithOptions:options
                             onComplete:^(NSArray *streams) {
                                 XCTAssertEqual([streams count], (NSUInteger)5, @"Wrong number of items parsed");
                                 XCTAssertEqual([[streams objectAtIndex:0] class], [JiveStream class], @"Wrong item class");
                                 
                                 // Check that delegates where actually called
                                 [mockAuthDelegate verify];
                                 [mockJiveURLResponseDelegate verify];
                                 finishedBlock();
                             } onError:^(NSError *error) {
                                 XCTFail(@"%@", [error localizedDescription]);
                                 finishedBlock();
                             }];
    });
}

- (void) testActivitiesOperation {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0.123];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person activitiesOperationWithOptions:options
                                                onComplete:completionBlock
                                                   onError:errorBlock];
    }
                withResponse:@"person_activities"
                         URL:@"https://testing.jiveland.com/api/core/v3/people/3550/activities?after=1970-01-01T00%3A00%3A00.123%2B0000"
               expectedCount:22
               expectedClass:[JiveActivity class]];
}

- (void) testActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_activities"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/activities?after=1970-01-01T00%3A00%3A00.000%2B0000"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person activitiesWithOptions:options
                                onComplete:^(NSArray *activities) {
                                    XCTAssertEqual([activities count], (NSUInteger)22, @"Wrong number of items parsed");
                                    XCTAssertEqual([[activities objectAtIndex:0] class], [JiveActivity class], @"Wrong item class");
                                    
                                    // Check that delegates where actually called
                                    [mockAuthDelegate verify];
                                    [mockJiveURLResponseDelegate verify];
                                    finishedBlock();
                                } onError:^(NSError *error) {
                                    XCTFail(@"%@", [error localizedDescription]);
                                    finishedBlock();
                                }];
    });
}

- (void) testTasksOperation {
    JiveSortedRequestOptions *options = [[JiveSortedRequestOptions alloc] init];
    options.sort = JiveSortOrderTitleAsc;
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person tasksOperationWithOptions:options
                                           onComplete:completionBlock
                                              onError:errorBlock];
    }
                withResponse:@"person_tasks"
                         URL:@"https://testing.jiveland.com/api/core/v3/people/3550/tasks?sort=titleAsc"
               expectedCount:1
               expectedClass:[JiveTask class]];
}

- (void) testTasks {
    JiveSortedRequestOptions *options = [[JiveSortedRequestOptions alloc] init];
    options.sort = JiveSortOrderLatestActivityDesc;
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_tasks"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/tasks?sort=latestActivityDesc"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person tasksWithOptions:options
                           onComplete:^(NSArray *tasks) {
                               // Called 3rd
                               XCTAssertEqual([tasks count], (NSUInteger)1, @"Wrong number of items parsed");
                               XCTAssertEqual([[tasks objectAtIndex:0] class], [JiveTask class], @"Wrong item class");
                               
                               // Check that delegates where actually called
                               [mockAuthDelegate verify];
                               [mockJiveURLResponseDelegate verify];
                               finishedBlock();
                           } onError:^(NSError *error) {
                               XCTFail(@"%@", [error localizedDescription]);
                               finishedBlock();
                           }];
    });
}

- (void) testFollowOperation {
    JivePerson *target = [JivePerson new];
    
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self loadPerson:target fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/3550/@following/5316"];
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person followOperation:target
                                                                onComplete:^() {
                                                                    // Check that delegates where actually called
                                                                    [mockAuthDelegate verify];
                                                                    [mockJiveURLResponseDelegate verify];
                                                                    finishedBlock();
                                                                } onError:^(NSError *error) {
                                                                    XCTFail(@"%@", [error localizedDescription]);
                                                                    finishedBlock();
                                                                }];

        XCTAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        [operation start];
    });
}

- (void) testFollow {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/@following/3550"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        JivePerson *target = [JivePerson new];
        
        [self loadPerson:target fromJSONNamed:@"alt_person_response"];
        [self.person follow:target
                 onComplete:^() {
                     // Check that delegates where actually called
                     [mockAuthDelegate verify];
                     [mockJiveURLResponseDelegate verify];
                     finishedBlock();
                 } onError:^(NSError *error) {
                     XCTFail(@"%@", [error localizedDescription]);
                     finishedBlock();
                 }];
    });
}

- (id) entityForClass:(Class) entityClass
        fromJSONNamed:(NSString *)jsonName {
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:jsonName
                                                                          ofType:@"json"];
    NSData *rawJson = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:rawJson
                                                         options:0
                                                           error:NULL];
    id entity = [entityClass objectFromJSON:JSON withInstance:self.instance];
    return entity;
}

- (void) test_updateFollowingInOperation {
    JiveStream *stream = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    NSData *body = [NSJSONSerialization dataWithJSONObject:@[[stream.selfRef absoluteString]] options:0 error:nil];
    
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation* operation = [self.person updateFollowingInOperation:@[stream]
                                                                          withOptions:options
                                                                           onComplete:completionBlock
                                                                              onError:errorBlock];
        
        XCTAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        XCTAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        XCTAssertEqualObjects([operation.request valueForHTTPHeaderField:JiveHTTPHeaderFields.contentType], @"application/json; charset=UTF-8", @"Wrong content type");
        XCTAssertEqual([[operation.request valueForHTTPHeaderField:JiveHTTPHeaderFields.contentLength] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                withResponse:@"followingIn_streams"
                         URL:@"https://testing.jiveland.com/api/core/v3/people/3550/followingIn?fields=id"
               expectedCount:1
               expectedClass:[JiveStream class]];
}

- (void) test_updateFollowingIn {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"followingIn_streams"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/followingIn?fields=name,id"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        JiveStream *stream = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
        [self.person updateFollowingIn:@[stream]
                           withOptions:options
                            onComplete:^(NSArray *streams) {
                                XCTAssertEqual([streams count], (NSUInteger) 1, @"Wrong number of items parsed");
                                XCTAssertTrue([[streams objectAtIndex:0] isKindOfClass:[JiveStream class]], @"Wrong item class");
                                
                                // Check that delegates where actually called
                                [mockAuthDelegate verify];
                                [mockJiveURLResponseDelegate verify];
                                finishedBlock();
                            } onError:^(NSError *error) {
                                XCTFail(@"%@", [error localizedDescription]);
                                finishedBlock();
                            }];
    });
}

- (void) testCreateTaskOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        JiveTask *testTask = [[JiveTask alloc] init];
        
        testTask.subject = @"subject";
        testTask.dueDate = [NSDate date];
        XCTAssertNil(testTask.jiveId, @"PRECONDITION: Task jiveId must be nil");
        
        NSData *body = [NSJSONSerialization dataWithJSONObject:[testTask toJSONDictionary] options:0 error:nil];
        
        AFURLConnectionOperation *operation = [self.person createTaskOperation:testTask
                                                                   withOptions:options
                                                                    onComplete:^(JiveTask *task) {
                                                                        XCTAssertEqual(task, testTask, @"Task object not updated");
                                                                        XCTAssertEqualObjects(task.jiveId, @"8991", @"Wrong jiveId");
                                                                        completionBlock(task);
                                                                    }
                                                                       onError:errorBlock];
        
        XCTAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        XCTAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        XCTAssertEqualObjects([operation.request valueForHTTPHeaderField:JiveHTTPHeaderFields.contentType], @"application/json; charset=UTF-8", @"Wrong content type");
        XCTAssertEqual([[operation.request valueForHTTPHeaderField:JiveHTTPHeaderFields.contentLength] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"task"
                           URL:@"https://testing.jiveland.com/api/core/v3/people/3550/tasks?fields=id"
                 expectedClass:[JiveTask class]];
}

- (void) testCreateTask {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"task"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/tasks?fields=name,id"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        JiveTask *testTask = [[JiveTask alloc] init];
        testTask.subject = @"Supercalifragalisticexpialidotious - is that spelled right?";
        testTask.dueDate = [NSDate dateWithTimeIntervalSince1970:0];
        [self.person createTask:testTask
                    withOptions:options
                     onComplete:^(JiveTask *task) {
                         XCTAssertEqual(task, testTask, @"Task object not updated");
                         XCTAssertEqualObjects(task.jiveId, @"8991", @"Wrong jiveId");
                         
                         // Check that delegates where actually called
                         [mockAuthDelegate verify];
                         [mockJiveURLResponseDelegate verify];
                         finishedBlock();
                     } onError:^(NSError *error) {
                         XCTFail(@"%@", [error localizedDescription]);
                         finishedBlock();
                     }];
    });
}

- (void) testCreateTask_wrongClassResponse {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/tasks?fields=name,id"];
    
    XCTAssertEqualObjects(self.person.jiveId, @"5316", @"PRECONDITION: Wrong jiveId");
    waitForTimeout(^(void (^finishedBlock)(void)) {
        JiveTask *testTask = [[JiveTask alloc] init];
        testTask.subject = @"Supercalifragalisticexpialidotious - is that spelled right?";
        testTask.dueDate = [NSDate dateWithTimeIntervalSince1970:0];
        [self.person createTask:testTask
                    withOptions:options
                     onComplete:^(JiveTask *task) {
                         XCTFail(@"The task object should not be updated with a person response");
                         finishedBlock();
                     } onError:^(NSError *error) {
                         XCTAssertEqualObjects([error domain], JiveErrorDomain);
                         XCTAssertEqual([error code], JiveErrorCodeInvalidJSON);
                         finishedBlock();
                     }];
    });
}

- (void) testGetTermsAndConditionsOperation {
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self createJiveAPIObjectWithResponse:@"T_C_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/3550/termsAndConditions"];
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person termsAndConditionsOperation:^(JiveTermsAndConditions *termsAndConditions) {
            XCTAssertEqual([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            XCTAssertTrue(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance should be required");
            XCTAssertNotNil(termsAndConditions.text, @"Missing text");
            XCTAssertNil(termsAndConditions.url, @"Unexpected URL");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            XCTFail(@"%@", [error localizedDescription]);
            finishedBlock();
        }];
        
        XCTAssertNotNil(operation, @"Missing operation");
        [operation start];
    });
}

- (void) testGetTermsAndConditionsOperation_withURL {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    [self createJiveAPIObjectWithResponse:@"T_C_response_w_URL"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/termsAndConditions"];
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person termsAndConditionsOperation:^(JiveTermsAndConditions *termsAndConditions) {
            XCTAssertEqual([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            XCTAssertTrue(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance should be required");
            XCTAssertNil(termsAndConditions.text, @"Unexpected text");
            XCTAssertNotNil(termsAndConditions.url, @"Missing URL");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            XCTFail(@"%@", [error localizedDescription]);
            finishedBlock();
        }];
        
        XCTAssertNotNil(operation, @"Missing operation");
        [operation start];
    });
}

- (void) testGetTermsAndConditionsOperation_alreadyAccepted {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    [self createJiveAPIObjectWithErrorCode:204
                   andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/termsAndConditions"];
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person termsAndConditionsOperation:^(JiveTermsAndConditions *termsAndConditions) {
            XCTAssertEqual([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            XCTAssertFalse(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance is not required");
            XCTAssertNil(termsAndConditions.text, @"Unexpected text");
            XCTAssertNil(termsAndConditions.url, @"Unexpected URL");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            XCTFail(@"%@", [error localizedDescription]);
            finishedBlock();
        }];
        
        XCTAssertNotNil(operation, @"Missing operation");
        [operation start];
    });
}

- (void) testGetTermsAndConditions {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    [self createJiveAPIObjectWithResponse:@"T_C_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/termsAndConditions"];
    
    // Make the call
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person termsAndConditions:^(JiveTermsAndConditions *termsAndConditions) {
            XCTAssertEqual([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            XCTFail(@"%@", [error localizedDescription]);
            finishedBlock();
        }];
    });
}

- (void) testGetTermsAndConditions_doesNotNeedToAccept {
    [self loadPerson:self.person fromJSONNamed:@"my_response"];
    [self createJiveAPIObject_ExpectingNoCalls];
    
    // Make the call
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person termsAndConditions:^(JiveTermsAndConditions *termsAndConditions) {
            XCTAssertEqual([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            XCTAssertFalse(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance is not required");
            XCTAssertNil(termsAndConditions.text, @"Unexpected text");
            XCTAssertNil(termsAndConditions.url, @"Unexpected URL");
            finishedBlock();
        } onError:^(NSError *error) {
            XCTFail(@"%@", [error localizedDescription]);
            finishedBlock();
        }];
    });
}

- (void) testAcceptTermsAndConditionsOperation {
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    
    [self createJiveAPIObjectWithResponse:@"T_C_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/3550/acceptTermsAndConditions"];
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person acceptTermsAndConditionsOperation:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            XCTFail(@"%@", [error localizedDescription]);
            finishedBlock();
        }];
        
        XCTAssertEqualObjects(JiveHTTPMethodTypes.POST, operation.request.HTTPMethod, @"Wrong http method used");
        [operation start];
    });
}

- (void) testAcceptTermsAndConditions {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/acceptTermsAndConditions"];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [self.person acceptTermsAndConditions:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            XCTFail(@"%@", [error localizedDescription]);
            finishedBlock();
        }];
    });
}

//- (void) testAvatarOperation {
//    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
//
//    [self createJiveAPIObjectWithImageResponse:@"person_avatar"
//                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/3550/avatar"];
//    
//    waitForTimeout(^(void (^finishedBlock)(void)) {
//        NSOperation* operation = [self.person avatarOperationOnComplete:^(UIImage *avatarImage) {
//            UIImage *testImage = [UIImage imageNamed:@"avatar.png"];
//            STAssertEqualObjects(testImage, avatarImage, @"Wrong image returned");
//            // Check that delegates where actually called
//            [mockAuthDelegate verify];
//            [mockJiveURLResponseDelegate verify];
//        } onError:^(NSError *error) {
//            STFail([error localizedDescription]);
//        }];
//        
//        
//        STAssertNotNil(operation, @"Missing manager operation");
//        [operation start];
//    }];
//}

//- (void) testAvatarServiceCall {
//    [self loadPerson:self.person fromJSONNamed:@"person_response"];
//    
//    [self createJiveAPIObjectWithResponse:@"person_avatar"
//                  andAuthDelegateURLCheck:@"https://testing.jiveland.com/api/core/v3/people/5316/avatar"];
//    
//    waitForTimeout(^(void (^finishedBlock)(void)) {
//        [self.person avatarOnComplete:^(UIImage *avatarImage) {
//            UIImage *testImage = [UIImage imageNamed:@"avatar.png"];
//            STAssertEqualObjects(testImage, avatarImage, @"Wrong image returned");
//            // Check that delegates where actually called
//            [mockAuthDelegate verify];
//            [mockJiveURLResponseDelegate verify];
//            finishedBlock();
//        } onError:^(NSError *error) {
//            STFail([error localizedDescription]);
//        }];
//    }];
//}

@end
