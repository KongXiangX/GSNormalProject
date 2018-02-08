//1. 屏幕宽 高
/***********屏幕适配*************/
#define GSScreenW [UIScreen mainScreen].bounds.size.width
#define GSScreenH [UIScreen mainScreen].bounds.size.height

//2.手机型号判定
#define iphone6P  (GSScreenH == 736)
#define iphone6   (GSScreenH == 667)
#define iphone5   (GSScreenH == 568)
#define iphone4   (GSScreenH == 480)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


//3.iOS版本 判定
#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue] //系统版本
#define iOS7  ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS8  ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

#define iOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)

//4.导航栏
/** 状态栏的高度 */
#define  GSStatusBarH   (iPhoneX ? 44.f : 20.f)
/** 导航栏的最大Y值 */
#define GSNavMaxY       (44.f + GSStatusBarH)

/** UITabBar的高度 */
#define  GSTabbarSafeBottomMargin     (iPhoneX ? 34.f : 0.f)
/** UITabBar的高度 */
#define GSTabBarH       (49.f + GSTabbarSafeBottomMargin)


/** 标题栏的高度 */
#define  GSTitlesViewH  35


/** 视图安全区 */
#define  GSViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})


//5.TabBar重复点击判定
/** TabBarButton被重复点击的通知 */
#define  GSTabBarButtonDidRepeatClickNotification @"GSTabBarButtonDidRepeatClickNotification"

/** TitleButton被重复点击的通知 */
#define  GSTitleButtonDidRepeatClickNotification @"GSTitleButtonDidRepeatClickNotification"
