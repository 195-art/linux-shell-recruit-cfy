<img width="1250" height="456" alt="image" src="https://github.com/user-attachments/assets/5c9262c0-b007-4f8c-9bcd-d83760480199" />
task01-09已完成。

# 关于我的做题思路

## task01

1. 使用`find workspace -type f`遍历`workspace`中所有普通文件，再搭配`grep -l`得到对应文件名，打开得到项目编号，用echo将编号写入文件。

2. 当前目标文件真实路径：`workspace/.project/metadata`，参考位置：`workspace/src/utils/`，两次`../`退到`workspace`再访问 `.project/metadata`，echo写入文件。

## task02

1. 首先尝试直接输入 `./tools/recruit‑info`，报 Permission denied，再`ls -l tools/recruit-info`，x没有打开，说明缺少执行权限，要求不能使用sudo改权限，换为`chmod +x tools/recruit-info`加上权限即可。

2. 直接输入`recruit‑info`只会在PATH中搜寻，但原本的PATH中没有对应的文件，无法直接执行，想到将把项目下的`tools`目录追加进 PATH，要求不能修改`~/.bashrc`写入 PATH，于是临时`export`实现。

## task03

1. 寻找所有包含 TODO 或 FIXME 的普通文件：grep搜索。

2. 每个路径只出现一次，按字典序排列，每行一个路径，写入 output/03_code_search.txt：
- -l只输出文件名且不重复输出
- -E同时匹配多个关键词
- -r递归扫描文件夹

拿到文件名列表` sort `做字典序排序，再重定向保存到文件。

## task04

1. 先`grep`筛选全部带`ERROR`的行，再`wc -l`统计行数，重定向写入`output/04_error_count.txt`。

2. - 筛选带 ERROR 的行
- `cut`切出`user=xxx`字段，再切掉`=`拿到用户名
- `sort`字典排序，`uniq`去重

3. 统计出现最多的错误码

- 拿到`code=xxx`字段，截取等号后面错误码
- `sort | uniq -c`统计每个 code 出现次数
- `sort -nr`按次数数字倒序，最多的放第一行
- `head -1`拿第一行，`awk`只输出 code，丢弃计数字段

  
## task05

1. 先查看`logs/access.log`，发现每一行的第一列就是IP，空格分隔。

2. - 提取每一行第一列：`cut -d' ' -f1`
- 排序并统计次数：`sort | uniq -c`
- 按数字倒序并只取第一行：`sort -nr | head -1`
- 丢掉前面的计数字，只输出 IP 地址：`awk '{print $2}'`

3. 要求全程管道连接，全部加上`|`即可。

## task06

1. 运行`./tools/check-project`，该程序会同时产生 stdout 正常输出、stderr 错误输出。
   
2. `>` 只捕获标准输出 stdout，stderr 依旧会直接打印屏幕，`2>`专门重定向错误输出，而 stdout 打印屏幕。分别重定向即可。
   
3. tee 可以同时输出到屏幕和写入目标文件，而且管道`|`只传递 stdout，stderr 不会进管道，使用`./tools/check-project | tee output/06_tee.txt`即可实现。
   
## task07

1. 要写`scripts/analyze.sh`脚本，日志路径得从命令行参数传，不能写死，用`$1`就能拿到第一个参数。

2. 先判断有没有传参数，用`$#`看个数，等于0就打印Usage提示，然后`exit 1`退出，得是非零状态。

3. 再检查文件存不存在，用`[[ ! -f "$1" ]]`判断，不存在就报错，也`exit 1`。加双引号好像是怕文件名带空格出问题。

4. 文件没问题的话，grep找ERROR，`wc -l`数行数，用`$()`把结果存变量里。

5. 再找出现最多的错误码，把code那列切出来，排序，`uniq -c`数次数，倒序排取第一个，awk只拿出code的值。

6. 按要求格式输出结果，给脚本加执行权限`chmod +x`。
   
## task08

1. 原脚本遇到带空格的文件名就出错，因为变量没加双引号，空格会把文件名拆成好几段。

2. 把循环里的`$@`改成`"$@"`，还有脚本里面用`$file`变量的地方也要加上双引号写成`"$file"`。

3. 在`answers/08.md`写：不加双引号会按空格拆分内容，加双引号会当成一整个完整字符串。

4. 改完给脚本加执行权限。
   
## task09

1. 先给`scripts/worker.sh`加上执行权限，`start-workers.sh`是统一调用这个脚本、再传入不同worker名称参数的，权限不对进程启动后会直接退出。

2. 运行`./scripts/start-workers.sh`，启动三个后台worker进程。

3. 查找worker-beta的PID不能直接搜进程名，程序本体是worker.sh，worker-beta只是传入的参数，要用pgrep匹配带对应参数的进程行。

4. 拿到PID后用普通kill命令终止进程即可，不能用kill -9强制结束。

5. 确认另外两个worker仍在运行后，完成校验，通过。
