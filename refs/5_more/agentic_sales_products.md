#  拆解Clay：31亿美金估值，OpenAI的"销售数据中台"  
原创 AI最新  AI最新   2025-12-01 22:03  
  
OpenAI的销售团队曾经有个头疼的问题  
：潜在客户的数据覆盖率只有40%。邮箱找不到、公司信息不全、联系人职位过时——典型的B2B销售噩梦。  
  
用了Clay之后，数据覆盖率升至  
80%+  
。  
  
![Image](469041ab0f46433c61aed73dd9ae2a1a.png)  
  
不只是OpenAI，Anthropic、Canva、Ramp这些明星公司都在用同一个工具做销售自动化。这个工具叫  
Clay  
，一个看起来像Excel、实际上是"销售工作流操作系统"的产品。  
  
看看融资数据：  
2025年5月估值15亿美元，8月就翻到  
31亿美元  
。3个月翻倍，领投方是Google母公司Alphabet的CapitalG。  
  
一个"给销售团队用的表格工具"，凭什么让硅谷顶级VC抢着投？  
# 产品拆解：这不是CRM，是"销售数据的操作系统"  
  
Clay不是什么  
：它不是Salesforce那样的CRM，也不是Apollo那样的销售执行工具。  
  
Clay是什么？  
一个把150+个数据源、AI研究能力、工作流自动化整合到一个类似Excel界面的"数据中台"。  
  
![Image](6d0ad2e09378b2838a0d84bf54ad248e.png)  
## 架构拆解  
  
Layer 1：数据聚合层   
Clay接入了150+数据提供商：  
- 传统数据库：ZoomInfo、Apollo、Clearbit、Lusha  
  
- 意向信号：6sense、Koala（监测网站访问、职位变动、融资事件）  
  
- 用户自有数据：可以接入自己的API Key  
  
核心创新：Waterfall Enrichment（瀑布流丰富）  
  
传统做法是订阅ZoomInfo，找不到数据就算了。Clay的逻辑是：  
  
```
如果Apollo没找到邮箱 → 自动尝试Hunter → 再试RocketReach → 直到找到为止
```  
  
  
Layer 2：AI处理层（核心竞争力）  
  
Claygent - Clay的AI研究Agent  
，本质是一个  
可编程的GPT-4网络爬虫  
。  
  
给它一个prompt："这家公司是否SOC-II认证？"它会：  
1. 1.   
自动搜索相关网页  
  
1. 2.   
访问公司官网/安全页面  
  
1. 3.   
提取关键信息  
  
1. 4.   
返回结构化答案  
  
真实使用数据  
：  
- 30%的Clay用户每天使用Claygent  
  
- 每天执行50万次AI研究任务  
- 相当于给每个销售团队配了个24小时不睡觉的研究助理  
  
典型场景：判断潜在客户是否B2B公司、抓取最近融资新闻、分析竞品技术栈、从招聘JD里提取公司痛点。  
  
Layer 3：工作流自动化层  
  
Clay的界面看起来像Excel，但底层是一个  
无代码编程环境  
。  
  
举个例子：  
  
```
IF 公司规模 > 500人   → 用ZoomInfo查数据（贵但准确）ELSE   → 用Apollo查（便宜）
```  
  
  
还能调用任何HTTP API，接入自己的数据源，同时还有  
Webhook触发  
：新leads进CRM → 自动触发Clay enrichment流程。  
# Credit制度 + PLG增长 = 资本疯抢的原因  
  
Clay不按座位收费，而是按  
消耗的数据credits  
收费。  
  
![Image](96e4ed0ea60e55ad547d54711ce990ce.png)  
  
为什么不按座位收费？  
  
✅   
Unlimited users  
（无限用户）→ 降低扩张摩擦，整个销售团队都能用  
  
✅   
用多少付多少  
 → 收入与价值直接挂钩  
  
✅   
Credits可滚动  
 → 降低用户"浪费"焦虑  
  
这是典型的PLG（Product-Led Growth）策略：让用户自然增长，而不是靠销售push。  
# 为什么Google、Sequoia抢着投31亿？  
## 投资价值点  
1. 1.   
明星客户背书：  
OpenAI、Anthropic、Canva、Ramp都在用。这些公司对工具的要求极高，选择Clay本身就是信任票。  
  
1. 2.   
150+数据源的整合壁垒：  
接入150+个API不是技术难题，难在  
维护成本  
。每个API的格式、鉴权、限流规则都不同，这需要持续的工程投入。  
  
1. 3.   
Claygent的技术护城河：  
不只是调用OpenAI API，Clay在prompt engineering和网络爬虫上有独特积累。这是别人短期模仿不了的。  
  
1. 4.   
GTM赛道的爆发期：  
GTM（Go-To-Market）自动化是2025年最热的SaaS赛道。为什么？因为  
AI让"数据驱动销售"从口号变成现实  
。  
  
1. 5.   
从工具到平台的想象空间：  
Clay已经推出了原生Sequencer（邮件自动化）。未来可能推出CRM，成为"GTM全栈平台"。  
  
## 3个月估值翻倍的市场信号  
  
2025年5月，Clay估值15亿（Sequoia领投）。  
  
2025年8月，Clay估值31亿（CapitalG领投）。  
  
这背后是什么？  
- AI应用层的"iPhone时刻"到了  
  
- 从"AI能力"（大模型API）到"AI工作流"（整合多个工具）的范式转移  
  
- 资本判断：  
数据中台 > 单点工具  
  
# 本土化机会：直接复制Clay在中国为什么不行？  
## 最直接的障碍  
1. 1.   
数据源缺失  
  
- LinkedIn在中国不可用  
  
- ZoomInfo/Apollo覆盖中国企业数据很弱  
  
- 需要整合企查查、天眼查、脉脉等本土数据源  
  
1. 2.   
B2B成熟度低  
  
- 中国ToB销售更依赖"关系驱动"而非"数据驱动"  
  
- Sales Ops岗位在中国企业不成熟  
  
- 年付$1,800（人民币1.3万）的接受度低  
  
1. 3.   
合规风险  
  
- 自动化抓取数据可能触及《个人信息保护法》  
  
- 电话/邮箱数据使用受限  
  
## 可能的切入点  
  
方向1：垂直行业版Clay  
- 针对医药/金融SaaS（这些行业B2B流程更规范）  
  
- 整合本土数据源：企查查企业信息 + 脉脉职场动态 + 36氪融资数据  
  
- 年费定价：人民币5,000-8,000元（对标国际版1/3价格）  
  
方向2：出海企业服务  
- 中国SaaS出海热潮（TikTok、Shein带动）  
  
- 帮中国企业enrichment海外客户数据  
  
- 反向Clay：连接海外数据源但服务中国团队  
方向3：私域运营工具（中国特色）  
- 企微版Clay：自动化打标签、分层运营、内容推送  
  
- 结合AI生成个性化话术（类似Claygent）  
  
- 适配中国"私域流量"的玩法  
  
## 给创业者的启发  
- "中台思维"的机会：整合碎片化工具 > 重新发明轮子：  
Clay没有自己的数据库，但把150+个数据源整合到一起。这是典型的"中台"打法。对于初创公司来说，不要总想着从0到1做新产品，  
整合已有工具、降低使用门槛，可能是更快的PMF路径  
。  
  
- PLG + Credit制 = 2025年SaaS的标准配置：  
按座位收费已经过时了。Unlimited users + 按使用量付费，才是符合AI时代的定价模式。如果你在做SaaS，考虑"先让用户用起来，再通过消耗收费"的模式。  
  
- AI Agent不是噱头，是真正降低人力成本的生产力工具：  
Claygent每天执行50万次研究任务。这不是"AI辅助"，而是  
“AI替代”  
——替代初级研究岗位的重复劳动。别做"AI套壳"产品。真正有价值的AI应用，是让用户少雇1个人、省掉1个工作流。  
  
Clay的本质不是一个"数据库公司"（数据来自第三方），也不是纯"AI公司"（调用OpenAI API），而是一个  
“销售工作流的操作系统”  
。  
  
它证明了一件事：  
AI时代的机会不只在大模型，更在"把AI能力整合到具体工作流"的应用层  
。  
  
对于创业者，Clay给了一个清晰的方向：找到一个碎片化严重的领域（比如ToB销售），用AI + 中台思维整合现有工具，降低使用门槛。  
  
这比从0做一个"新产品"，可能更快找到Product-Market Fit。  
  
  
扫码添加主理人，备注姓名+来意  
  
![图片](d612d08d8f1b6022758b4203f22b2c95.png)  
  
往期回顾：[AI快讯｜下注平台Kalshi融资10亿美元，估值110亿](https://mp.weixin.qq.com/s?__biz=MzI4MTUzMjYzMQ==&mid=2247485507&idx=1&sn=a3b16c29a7459ed1ef98f0e8af2095d5&scene=21#wechat_redirect)  
  
  
[Google白皮书《Introduction to Agents》解析](https://mp.weixin.qq.com/s?__biz=MzI4MTUzMjYzMQ==&mid=2247485229&idx=1&sn=1bdb16a7c6061d0ac1723de8c29eac84&scene=21#wechat_redirect)  
  
  
[Google 官方白皮书Prompt Engineering 深度解读](https://mp.weixin.qq.com/s?__biz=MzI4MTUzMjYzMQ==&mid=2247485499&idx=1&sn=e13ad1f9a3f3d5a38dad9d07a210ee82&scene=21#wechat_redirect)  
  
  
[一枚估值110亿美金的戒指：Oura Ring拆解](https://mp.weixin.qq.com/s?__biz=MzI4MTUzMjYzMQ==&mid=2247485256&idx=1&sn=b250778044c18b178534ab84543c68b3&scene=21#wechat_redirect)  
  
  
[Inception 融资5000万美元：颠覆GPT的新范式](https://mp.weixin.qq.com/s?__biz=MzI4MTUzMjYzMQ==&mid=2247485138&idx=1&sn=cc09657300f2c03ae8b2711c481005a4&scene=21#wechat_redirect)  
  
  
[拆解Stickerbox ：融资700万美元，孩子的 AI 贴纸打印机](https://mp.weixin.qq.com/s?__biz=MzI4MTUzMjYzMQ==&mid=2247485573&idx=1&sn=a920a6d285eb31ec2ca1b4980edf9128&scene=21#wechat_redirect)  
  
  
  
![图片](a8b60af65b835858caf46b9637533566.png)  
  
  
📍  
直播预告  
  
![](34750131c6d27b979f5c9700a7f0c7a3.png)  
  
  







