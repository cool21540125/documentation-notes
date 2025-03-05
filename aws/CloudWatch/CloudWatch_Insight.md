# CloudWatch Insights

```sql
--
fields @timestamp, @message                   -- SELECT
| sort @timestamp desc                        -- ORDER BY
| filter @message like "Your Wanted Message"  -- WHERE

--
fields @timestamp, @message
| sort @timestamp desc
| parse '"GET * HTTP/2' as @location  -- 假設要列出 'GET /login HTTP/2' (可取得 location 欄位)
| parse '"GET * */2' as @location, @protocol  -- 藉由 parse 加上 '\*', 可將之視為變數, 並指定到後面去 (可取得 location 及 protocol 兩個欄位)

-- 做統計
fields @timestamp, @message
| filter @logStream = "Error Logs"
| sort @timestamp desc
| parse '"GET * */2' as @location, @protocol
| stats count(*) as sum by @location

-- 針對 CloudTrail logs 做查詢, 查詢出 CreateLogStream 的事件筆數
fields eventSource
| filter eventName = "CreateLogStream"
| stats count() as eventCount by userIdentity.userName
| sort eventCount desc

-- 抓出所有對 favicon.ico 及 *.png 的請求
fields @timestamp, @message
| filter @message LIKE "GET /favicon.ico HTTP/1.1" or @message LIKE "GET /.*\\.png HTTP/1.1"
| sort @timestamp desc
| limit 100

-- 抓出所有造成 404 的請求
fields @timestamp, @message
| filter @message LIKE "404"
| parse @message "GET * HTTP/1.1" as resource
| stats count() as count by resource
| sort count desc

--
fields @timestamp, @message
| filter eventSource = "elasticloadbalancing.amazonaws.com"
| filter requestParameters.targetGroupArn = "arn:aws:elasticloadbalancing:us-west-2:303053866824:targetgroup/ECS-iDingClientProduction/e3b79345705cec5a"
| sort @timestamp desc
```
