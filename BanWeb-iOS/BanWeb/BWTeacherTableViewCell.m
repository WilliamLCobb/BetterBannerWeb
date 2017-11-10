//
//  BWTeacherTableViewCell.m
//  BanWeb
//
//  Created by Will Cobb on 3/6/16.
//  Copyright © 2016 Will Cobb. All rights reserved.
//

#import "BWTeacherTableViewCell.h"
#import "BWTeacher.h"
@interface BWTeacherTableViewCell () {
    UILabel         *teacherName;
    UIImageView     *teacherImage;
    
    BOOL            frameCorrected;
}

@end

@implementation BWTeacherTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        teacherName = [[UILabel alloc] init];
        [self.contentView addSubview:teacherName];
        
        teacherImage = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 0, 1, 1)];
        [self.contentView addSubview:teacherImage];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (!frameCorrected) {
        frameCorrected = frame.size.height != 44;
        [self setCellNormalAnimated:NO];
    }
}

///  UNUSED  ///

- (void)setCellNormalAnimated:(BOOL)animate
{
    CGFloat animationDuration = 0.2 * animate;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:animationDuration animations:^{
            teacherName.frame = CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.height);
            [teacherName sizeToFit];
            
            teacherImage.hidden = YES;
        }];
    });
}

- (void)setCellPresentingAnimated:(BOOL)animate
{
    CGFloat animationDuration = 0.1 * animate;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:animationDuration animations:^{
            //teacherName.center = CGPointMake(teacherName.center.x + (self.frame.size.width/2 - teacherName.center.x)/2, teacherName.center.y);
            teacherName.alpha = 0.05;
            
            
            teacherImage.hidden = NO;
            CGSize imageSize = self.teacher.image.size;
            imageSize.width /= 2;
            imageSize.height /= 2;
            teacherImage.frame = CGRectMake(self.frame.size.width/2 - imageSize.width/2, 60, imageSize.width, imageSize.height);
            teacherImage.image = self.teacher.image;
        }];
    });
    
    NSLog(@"PRESENting");
}

//////

- (void)setTeacher:(BWTeacher *)teacher
{
    
    _teacher = teacher;
    teacherName.text = teacher.name;
    [teacherName sizeToFit];
    if (teacher.image) {
        teacherImage.hidden = NO;
        
    } else {
        teacherImage.hidden = YES;
    }
}

- (void)setPresenting:(BOOL)presenting
{
    _presenting = presenting;
    if (presenting) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setCellPresentingAnimated:YES];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setCellNormalAnimated:YES];
        });
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
