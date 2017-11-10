//
//  BWSubjectTableViewCell.m
//  BanWeb
//
//  Created by Will Cobb on 3/5/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWSubjectTableViewCell.h"
#import "BWSubject.h"

@interface BWSubjectTableViewCell () {
    UILabel         *subjectName;
}

@end

@implementation BWSubjectTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        subjectName = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height/2 - 10, self.frame.size.width - 20, 20)];
        [self.contentView addSubview:subjectName];
        self.clipsToBounds = YES;
    }
    return self;
}


- (void)setSubject:(BWSubject *)subject
{
    _subject = subject;
    
    subjectName.text = subject.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end

