//
//  ViewController.m
//  PhoneTableView
//
//  Created by 韩冲 on 14/12/1.
//  Copyright (c) 2014年 tmachc. All rights reserved.
//

#import "ViewController.h"
#import "ChineseString.h"
#import "pinyin.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *nameAry;           // 未排序的通讯录
@property (nonatomic, strong) NSMutableArray *phoneNameAry;           // 排序后的通讯录
@property (nonatomic, strong) UITableView *table;                //
@property (nonatomic, strong) NSMutableDictionary *dataDic;      // 整理后的通讯录dic
@property (nonatomic, strong) NSMutableArray *listAry;           // 索引数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataDic = [NSMutableDictionary dictionary];
    self.listAry = [NSMutableArray array];
    self.nameAry = [@[
                      @"乔布斯",
                      @"tmachc",
                      @"再见",
                      @"暑假作业",
                      @"键盘",
                      @"ICY",
                      @"鼠标",
                      @"电脑",
                      @"显示器",
                      @"你好",
                      @"推特",
                      @"谷歌",
                      @"苹果",
                      @"A苹果",
                      @"china",
                      @""
                      ] mutableCopy];
    
    self.phoneNameAry = [NSMutableArray array];
    for (int i = 0; i < [self.nameAry count]; i++){
        ChineseString *chineseString = [[ChineseString alloc]init];
        
        chineseString.string = [NSString stringWithString:self.nameAry[i]];
        
        if (!chineseString.string){
            chineseString.string = @"";
        }
        
        if (![chineseString.string isEqualToString:@""]) {
            NSString *pinYinResult = [NSString string];
            for(int j = 0; j < chineseString.string.length; j ++){
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",(char)pinyinFirstLetter([chineseString.string characterAtIndex:j])] uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
            [self.phoneNameAry addObject:chineseString];
            NSLog(@"原String:%@----拼音首字母String:%@ -----拼音首字母:%@", chineseString.string, chineseString.pinYin, [chineseString.pinYin substringToIndex:1]);
            
            NSMutableArray *mAry = [self.dataDic[[chineseString.pinYin substringToIndex:1]] mutableCopy];
            if (!mAry) {
                mAry = [NSMutableArray array];
                [self.listAry addObject:@{@"key": [chineseString.pinYin substringToIndex:1]}];
            }
            [mAry addObject:chineseString.string];
            [self.dataDic setObject:mAry forKey:[chineseString.pinYin substringToIndex:1]];
        } else {
            chineseString.pinYin = @"";
            NSLog(@"有个空的");
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithArray:@[sort]];
    NSArray *ary;
    ary = [self.listAry sortedArrayUsingDescriptors:sortDescriptors];
    [self.listAry removeAllObjects];
    for (NSDictionary *dic in ary) {
        [self.listAry addObject:dic[@"key"]];
    }
    NSLog(@"self.listAry----->>>>%@",self.listAry);
    NSLog(@"self.dataDic----->>>>%@",self.dataDic);
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
}

// 有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataDic count];
}
// 字母排序搜索
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.listAry;
}
// 搜索时候显示按索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    NSLog(@"%@",title);
    for (NSString *character in self.listAry) {
        if ([character isEqualToString:title]) {
            return count;
        }
        count ++;
    }
    return count;
}
// 组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.listAry[section];
}
// 每组的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataDic[self.listAry[section]] count];
}
// 每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
// 每一行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSUInteger sectionMy = [indexPath section];
    
    cell.textLabel.text = self.dataDic[self.listAry[sectionMy]][row]; //每一行显示的文字
    
    return cell;
}

@end
