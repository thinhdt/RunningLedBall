//
//  ViewController.m
//  LedBall
//
//  Created by mac on 6/17/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGFloat _margin;  //> ball radius m > r
    CGFloat _marginHeight;
    int _numberOfBall; //> ball
    CGFloat _ballDiamenter; // d
    CGFloat _space; // s > d
    
    int _rows;
    int _cols;
    int lastONLED; // store last ON LED
    
    NSTimer *_timer;
    int indexColum;
    int indexRows;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self PlaceGreyBallAtX:100 andY:100 withTag:1];
    _margin = 40.0;
    _marginHeight = 40.0;
    _ballDiamenter = 24.0;
    
    _numberOfBall = 10;
    _rows = 10;
    _cols = 10;
    
    lastONLED = 99;
    indexColum = 0;
    indexRows = -1;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(runningLEDW) userInfo:nil repeats:YES];
    
    [self drawRowOfBallsWithRows:_rows WithColums:_cols];
    
}

- (void) PlaceGreyBallAtX:(CGFloat) x
                      andY:(CGFloat) y
                   withTag:(int)tag {
    
    UIImageView *ball = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray"]];
    
    ball.center = CGPointMake(x, y);
    ball.tag = tag;
    [self.view addSubview:ball];
    
    //NSLog(@"with = %3.0f, height = %3.0f", ball.bounds.size.width, ball.bounds.size.height);
    
}

- (void)CheckSizeOfApp{
    //CGSize size =  self.view.bounds.size;
    //NSLog(@"Width = %3.0f , height = %3.0f", size.width , size.height);
}

- (void) numberOfBallSpace {
    bool stop = false;
    int n = 3;
    while (!stop) {
        CGFloat space = [self spaceBetweenBallCenterWhenNumberBallIsKnown: n];
        if (space < _ballDiamenter) {
            stop = true;
        } else {
            NSLog(@"Number of ball %d , space between ball center %3.0f" , n ,space) ;
        }
        
        n++;
    }
}

- (void) drawRowOfBallsWithRows:(int)numberRowsBalls WithColums:(int)numberColumsBalls {
    CGFloat space = [self spaceBetweenBallCenterWhenNumberBallIsKnown:numberColumsBalls];
    CGFloat spaceHeight = [self spaceBetweenRowBallCenterWhenNumberBallIsKnown:numberRowsBalls];
    
    for (int i = 0; i < _rows; i++) {
        for (int j = 0; j < _cols; j++ ) {
            
            // setTags
            [self PlaceGreyBallAtX:(_margin + j * space) andY:(_marginHeight + i * spaceHeight) withTag: [self setTagsAtRowIndex:(i) WithColums:(j) ]];

        }
    }
    
}

- (int) setTagsAtRowIndex:(int)i WithColums:(int)j {
    //NSLog(@"setTags: i = %d, j = %d, value = %d", i, j, (i * _numberOfBall + j) + 100);
    return (i * _numberOfBall + j) + 100;
}

- (int) getTagsAtRowIndex:(int)i WithColums:(int)j {
    return (i * _numberOfBall + j + 100);
}

- (int) getXBasedTags:(int)tags WithNumberOfColum:(int)numberOfColum{
    return (tags - 100)/numberOfColum;
}

- (int) getYBasedTags:(int)tags WithNumberOfColum:(int)numberOfColum {
    //return (tags - 100)/numberOfColum;
    return (tags - 100)% numberOfColum;
}


- (int) getCurrentBallColum:(int)colum WithRow:(int)row {
    return (row * _numberOfBall + colum);
}

-(CGFloat)spaceBetweenBallCenterWhenNumberBallIsKnown: (int)n{
    // w = 2*m + (n-1)*S
    return (self.view.bounds.size.width - 2 * _margin ) / (n -1);
}

-(CGFloat)spaceBetweenRowBallCenterWhenNumberBallIsKnown: (int)n{
    // H = 2 * mH + (n-1)*S
    return (self.view.bounds.size.height - 2 * _marginHeight ) / (n -1);
    
}

- (void) runningLEDZicZac {
        if (lastONLED != 99) {
            [self turnOFFLEDBasedTag:(lastONLED)];
        }
    
        if (lastONLED < [self getTagsAtRowIndex:(_rows -1) WithColums:(_cols -1)]) {
            lastONLED++;
        } else {
            lastONLED = [self getTagsAtRowIndex:(0) WithColums:(0)];
        }
    
        [self turnONLEDBasedTag:(lastONLED)];
}

- (void) runningLEDW {
    if (indexRows != -1 && indexColum != -1) {
        [self turnOFFLEDWithRow:(indexRows) WithColum:(indexColum)];
    }
    
    if (indexColum < _cols) {
       
        if (indexRows < _rows -1) {
            indexRows++;
        } else {
            indexColum++;
            if (indexColum > _cols-1) {
                indexColum = 0;
            }
            indexRows = 0;
        }
        
         NSLog(@"IndexRow = %d, indexColum = %d", indexRows, indexColum);
    }
    
        [self turnONLEDWithRow:(indexRows) WithColum:(indexColum)];
    
//    [self turnONLEDWithRow:(0) WithColum:(1)];
}
- (void) turnONLEDWithRow:(int)row WithColum:(int)colum {
    UIView *view = [self.view viewWithTag:[self getTagsAtRowIndex:(row) WithColums: (colum) ]];
    if (view && [view isMemberOfClass:[UIImageView class]]) {
        UIImageView *ball = (UIImageView*) view;
        ball.image = [UIImage imageNamed:@"green"];
    }
}

- (void) turnOFFLEDWithRow:(int)row WithColum:(int)colum{
    UIView *view = [self.view viewWithTag:[self getTagsAtRowIndex:(row) WithColums: (colum) ]];
    if (view && [view isMemberOfClass:[UIImageView class]]) {
        UIImageView *ball = (UIImageView*) view;
        ball.image = [UIImage imageNamed:@"gray"];
    }
}

- (void) turnOFFLEDBasedTag:(int)tags {
    int x = [self getXBasedTags:(tags) WithNumberOfColum:(_cols)];
    int y = [self getYBasedTags:(tags) WithNumberOfColum:(_cols)];
    
    [self turnOFFLEDWithRow:(x) WithColum:(y)];
}

- (void) turnONLEDBasedTag:(int)tags {
    int x = [self getXBasedTags:(tags) WithNumberOfColum:(_cols)];
    int y = [self getYBasedTags:(tags) WithNumberOfColum:(_cols)];
    
    [self turnONLEDWithRow:(x) WithColum:(y)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
