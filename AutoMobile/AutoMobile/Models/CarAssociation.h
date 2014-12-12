//
//  CarAssiciation.h
//  AutoMobile
//
//  Created by Zune Moe on 29/1/14.
//  Copyright (c) 2014 Ignite. All rights reserved.
//

#import "JSONModel.h"

@interface CarAssociation : JSONModel
@property (strong, nonatomic) NSArray<Optional> *country;
@property (strong, nonatomic) NSArray<Optional> *condition;
@property (strong, nonatomic) NSArray<Optional> *bodytype;
@property (strong, nonatomic) NSArray<Optional> *drive;
@property (strong, nonatomic) NSArray<Optional> *fuel;
@property (strong, nonatomic) NSArray<Optional> *trans;
@property (strong, nonatomic) NSArray<Optional> *equipment;
@property (strong, nonatomic) NSArray<Optional> *color;

+ (void)getCarAssociation:(void(^)(CarAssociation *association, NSError *error))callback;
+ (void) getEnginePower:(void(^)(NSArray *brands, NSError *error))callback;

@end
