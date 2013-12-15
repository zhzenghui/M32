返回的key值规范:
1.如果是对象:那么key一定是:"model"
2,如果是列表,那么key一定是:"list"
3.如果是数量:那么key一定是:num
4.如果其他是{“result”：boolean,“message”:"xxx"}



http://115.29.37.109:8888Cookiejournal/getJournalDetail/5
http://115.29.37.109:8888Cookiejournal/getJournalList/1/4
http://115.29.37.109:8888Cookieinfo/getInfoList/1/4/1/
http://115.29.37.109:8888Cookieinfo/getUnreadedInfoNum/1/20121112/20131212/
http://www.cmdra.com:8888/portal/main.do#edit_info



1.咨询的详细  http://115.29.37.109:8888Cookieinfo/getInfoDetail/1   不能访问
2.咨询 需要一个标记已读的接口
3.获取日志详情 http://115.29.37.109:8888Cookiejournal/getJournalDetail/1 不能访问
3 获取法规 ：http://115.29.37.109:8888Cookieregulation/getRegualtionList/-1/-1/-1/5/1
