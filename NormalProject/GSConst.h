//  宏定义文件

// 0.自定义Log
#ifdef DEBUG
#define GSLog(...) NSLog(__VA_ARGS__)
#else
#define GSLog(...)
#endif

// 1.主请求路径
#define GSMainURL       @"http://"

#define GSMainURLImg    @""
#define GS_NO_NETWORK   @"哦，似乎网络开小差了~,请检查网络连接！"
#define GS_DONT_HAVE_ANYMORE_REFRESH @"没有更多内容了！"


//2. 颜色
#define GSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


//3. 全局色 默认背景色
#define GSGlobalColor GSColor(251, 252, 254)
#define GSLineColor   GSColor(245, 246, 247)


//4.1字体
/** 一般情况的页面字体 */
#define  GSDefaultFont       [UIFont systemFontOfSize:17]
#define  GSDefaultSubFont    [UIFont systemFontOfSize:14]
//4.2.导航栏字体
#define GSNavTitleFont [UIFont fontWithName:@"Helvetica-Bold" size:18]   //导航栏标题字体
#define GSNavigationItemFont [UIFont systemFontOfSize:17] //导航栏item字体
#define GSNormalFont  [UIFont systemFontOfSize:15]        //一般lab默认字体

//5.常用View 的宽高与间距
/** 一般情况的页面  大的间距 */
#define  GSBigViewMargin    20

/** 一般情况的页面  小的间距 */
#define  GSSmallViewMargin    10

/** 一般情况的页面 按钮的高度 */
#define  BtnH           45
#define  BtnSamllH      40
/** 箭头高 */
#define  ArrowH         40

/** 箭头宽 */
#define  ArrowW         40

/** 分割线    的高 */
#define  LineH          1.0
#define  LabH           30





//6.登录数据
#define GSLogin             @"GSLogin"                    //记录登录的信息
#define GSLogined           @"GSLogined"                  //是否已经登录 （YES/NO）
//主要用于 用户 更正手机号 的时候使用，以及更改 支付密码  获取验证码的时候
#define GSNickName          @"GSNickName"
#define GSUserName          @"GSUserName"
#define GSUserImgStr        @"GSUserImgStr"
#define GSToken             @"GSToken"
#define GSUUID              @"GSUUID"
#define GSCurrentRoomID     @"GSCurrentRoomID"


//7.Userdefault
#define GSDefaulets  [NSUserDefaults standardUserDefaults]





