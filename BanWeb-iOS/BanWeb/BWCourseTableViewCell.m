//
//  BWCourseTableViewCell.m
//  
//
//  Created by Will Cobb on 3/5/16.
//
//

#import "BWCourseTableViewCell.h"
#import "BWCourse.h"
#import "BWClass.h"
#import "AppDelegate.h"

#define rowCount self.courses.count
#define animationDuration (((rowCount-1)*0.12)+.27) //rowCount*(.25 * powf(0.9, rowCount-1))

@interface BWCourseTableViewCell () {
    UILabel         *courseName;
    UIView          *topView;
    UIView          *shadowView;
    
    
    NSMutableArray  *courseViews;
    BOOL            frameCorrected;
}

@end

@implementation BWCourseTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutIfNeeded];
        topView = [[UIView alloc] initWithFrame:self.bounds];
        topView.backgroundColor = [UIColor whiteColor];
        topView.layer.shadowOffset = CGSizeZero;
        topView.layer.shadowRadius = 2.0;
        //topView.layer.shouldRasterize = YES;
        [self.contentView addSubview:topView];
        
        shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        shadowView.backgroundColor = [UIColor whiteColor];
        shadowView.layer.shadowOffset = CGSizeZero;
        shadowView.layer.shadowRadius = 1.0;
        //shadowView.layer.shouldRasterize = YES;
        [self.contentView addSubview:shadowView];
        
        courseName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width - 20, self.frame.size.height)];
        [topView addSubview:courseName];
        
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (!frameCorrected) {
        frameCorrected = frame.size.height != 44;
        topView.frame = [self boundsFromFrame:frame];
    }
    shadowView.frame = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
    [self.contentView bringSubviewToFront:shadowView];
}


- (CGRect)boundsFromFrame:(CGRect)frame
{
    return CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setCourses:(NSArray *)courses
{
    _courses = courses;
    
    BWCourse *anyCourse = [courses objectAtIndex:0];
    
    courseName.text = [NSString stringWithFormat:@"%ld - %@", [anyCourse courseNumber], [anyCourse name]];
    
    /*  Create Course Views  */
    courseViews = [NSMutableArray new];
    for (NSInteger i = 0; i < self.courses.count; i++) {
        BWCourse *course = self.courses[i];
        UIView * courseView = [[UIView alloc] initWithFrame:self.bounds];
        courseView.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:245/255.0 alpha:1];
        /// CRN  ///
        UILabel *crn = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, 57, 20)];
        crn.text = [NSString stringWithFormat:@"%ld", course.crn];
        [courseView addSubview:crn];
        
        /// Teacher Name ///
        UILabel *teacher = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, self.frame.size.width - 100, 20)];
        teacher.textAlignment = NSTextAlignmentCenter;
        teacher.text = course.teacherName;
        teacher.minimumScaleFactor = 0.5;
        teacher.adjustsFontSizeToFitWidth = YES;
        [courseView addSubview:teacher];
        
        /// Attributes  ///
        UILabel *attributes = [[UILabel alloc] initWithFrame:CGRectMake(courseView.frame.size.width - 127, 7, 120, 20)];
        if (course.attributes.length != 0) {
            NSMutableArray *attributesArray = [NSMutableArray new];
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(F[0-9])" options:NSRegularExpressionCaseInsensitive error:nil];
            [regex enumerateMatchesInString:course.attributes options:0 range:NSMakeRange(0, course.attributes.length) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                NSString *stringMatch = [course.attributes substringWithRange:[match rangeAtIndex:1]];
                [attributesArray addObject:stringMatch];
            }];
            if (attributesArray.count > 0) {
                attributes.text = [attributesArray componentsJoinedByString:@", "];
            } else {
                attributes.text = @"-";
            }
        } else {
            attributes.text = @"-";
        }
        attributes.textAlignment = NSTextAlignmentRight;
        [courseView addSubview:attributes];
        
        /// Classes ///
        NSArray *classes = course.classes;
        CGFloat yMargin = 30;
        CGFloat lineHeight = 20;
        CGFloat extraSpace = self.frame.size.height - (yMargin + lineHeight * classes.count);
        for (int i = 0; i < classes.count; i++) {
            CGFloat startY = lineHeight * i + yMargin;// + extraSpace/2;
            BWClass *class = classes[i];
            
            // Time //
            UILabel *times = [[UILabel alloc] initWithFrame:CGRectMake(7, startY + 1, 150, 18)];
            times.font = [UIFont systemFontOfSize:13];
            times.text = [NSString stringWithFormat:@"%@ - %@", class.startTime, class.endTime];
            [courseView addSubview:times];
            
            // Days //
            UILabel *days = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 25, startY + 1, 50, 18)];
            days.font = [UIFont systemFontOfSize:13];
            days.text = class.days;
            days.textAlignment = NSTextAlignmentCenter;
            [courseView addSubview:days];
            
            // Location //
            UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + 30, startY + 1, self.frame.size.width - (self.frame.size.width/2 + 37), 18)];
            location.font = [UIFont systemFontOfSize:13];
            location.text = class.location;
            location.textAlignment = NSTextAlignmentRight;
            [courseView addSubview:location];
        }
        
        /// Separators  ///
        if (i > 0) {
            NSInteger frameMargins = 0;
            CALayer *separator = [[CALayer alloc] init];
            separator.frame = CGRectMake(frameMargins, courseView.frame.size.height - 0.5, courseView.frame.size.width - frameMargins*2, 0.5);
            separator.backgroundColor = [UIColor colorWithWhite:190/255.0 alpha:1].CGColor;
            [courseView.layer addSublayer:separator];
        }
        
        [self.contentView addSubview:courseView];
        [courseViews insertObject:courseView atIndex:0];
    }
    [self.contentView bringSubviewToFront:topView];
}

- (void)showCourses
{
    topView.layer.shadowOpacity = 0.7;
    shadowView.layer.shadowOpacity = 0.7;
    NSInteger rows = courseViews.count;
    for (NSInteger i = 0; i < courseViews.count; i++) {
        UIView *courseView = [courseViews objectAtIndex:i];
        CGFloat yPosition = topView.frame.size.height + courseView.frame.size.height/2 + courseView.frame.size.height * i;
        CGFloat delay = ((rows - i - 1.0) / rows) * animationDuration;
        [UIView animateWithDuration:animationDuration-delay animations:^{
            courseView.center = CGPointMake(courseView.center.x, yPosition);
        }];
    }
}

- (void)hideCourses
{
    NSInteger rows = courseViews.count;
    for (NSInteger i = 0; i < courseViews.count; i++) {
        UIView *courseView = [courseViews objectAtIndex:i];
        CGFloat delay = ((rows - i - 1.0) / rows) * .25;
        [UIView animateWithDuration:.3-delay delay:delay options:nil animations:^{
            courseView.center = topView.center;
        } completion:^(BOOL finished) {
            if (i == courseViews.count - 1) {
                topView.layer.shadowOpacity = 0.0;
                shadowView.layer.shadowOpacity = 0.0;
            }
        }];
    }
}

- (void)setPresenting:(BOOL)presenting
{
    _presenting = presenting;
    if (presenting) {
        [self showCourses];
    } else {
        [self hideCourses];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

//attributes = "";
//
//classes =     (
//               
//               {
//                   
//                   days = T;
//                   
//                   endTime = " 2:50 pm";
//                   
//                   location = "Palmer Hall 203";
//                   
//                   professor = "Alexandra G. Kostina";
//                   
//                   professorProbability = P;
//                   
//                   startDate = "Jan 13, 2016 ";
//                   
//                   startTime = "2:00 pm ";
//                   
//                   type = Lecture;
//                   
//               }
//               
//               );
//
//courseNumber = "<null>";
//
//courseSubNum = 01;
//
//credits = "4.000";
//
//crn = 26723;
//
//endDate = "Apr 28, 2016";
//
//level = Undergraduate;
//
//name = "Elementary Russian";
//
//registrationDate = "Jan 11, 2016 to Jan 20, 2016";
//
//term = "Spring 2016";








