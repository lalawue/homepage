
#title Program Lab

学的是 CS，但数学渣，大学期间沉迷于 Linux、Emacs 这些玩意儿...  
好奇心重且编程想法多，各种都想了解一点，涉猎虽广但深度堪忧，无奈半桶水走江湖，>_<



## Tips &#38; Tricks

- [使用 Emacs 作为 IDE](EmacsProgrammingEnv): Emacs 的编程环境设置。
- [TipsAndTricks](TipsAndTricks): Emacs 编写 C/C++/ObjC 的一些快捷操作。



## C &#38; C++

当年课堂上没听懂老师教的 C &#38; C++，都是后来跳坑自学的。还是觉得 C++ 坑太多，自愚跳不完，索性放下，不学了～

- [m_net](blog#2017-09#p0): 跨平台的小型网络库，支持 Linux／MacOS／FreeBSD／Windows
- [JPEG 解码器](blog#2014-12#p0): 当年面试 163 后被问到，那就填充到简历里面去吧。
- [俄罗斯方块游戏](Tetris)： 纯属无聊时的作品。
- [小型 Unix 磁盘文件系统](SmallUnixFilesystem): 大三下的课程设计作业，纯模拟性质，当时选择这个题目是为了更好地理解 Unix 的文件系统，了解其对空闲磁盘和文件的管理。
- [五子棋游戏](FiveInArow): 在大一时编的，趁脸皮厚先放上来，算法绘图什么别想了，bug 又如何，当年老爸放水，我棋连挡 8 招，:-)

## ObjC &#38; Swift

ObjC 和 Swift 都是吃饭的家伙，虽然又渐渐用上了安卓手机，但系统已经习惯 MacOS 了，对苹果是又爱又恨。

- [PinStackView](blog#2021-07#p0): 基于 [PinLayout](https://github.com/layoutBox/PinLayout) 的 StackView，特点是基于 Frame 计算，但是也保留了 UIStackView 的 distribution equal，已经用在正式环境上了。

## Go

Go 语言很早就火了，我没有赶上那个时候，话说 The Language 读了大概有 2、3 遍，直到遇到了合适的项目，才能说学会了一点。

- [MoocHelper](blog#2022-01#p0): [MoonCake](blog#2021-06#p0) 在 vscode 上的 LSP，修改自 [LuaHelper](https://github.com/Tencent/LuaHelper)，有了它，对 MoocScript 的修修补补可太方便了。

## Lua

当初学 Lua 是因为要开发游戏，但后来发现这个脚本语言，跟 C 一样的命令式语法，性能还行，又不用考虑内存管理，方便得很。

- [Cincau](blog#2020-08#p0): 小型化的 MVC web 框架，支持 mnet 或者 nginx，已在公网支撑起了不知名站点。
- [MoonCake](blog#2021-06#p0): 一个类似 Swift 的 Lua 方言（也可以叫 MoocScript），最终编译为 Lua，起因是我不大喜欢 Lua 充满 then、end 关键字的语法。
- [MarkdownProjectCompositor](blog#2019-06#p1): 目前用来构建主页和博客，相比之前的 EmacsWiki 少了一些功能，但稳定性、可维护性高了太多。
- [app_scheduler](https://github.com/lalawue/app_scheduler): 一个监控进程存活、CPU、内存占用的管理程序，基于 'ps u -p PID1 -p PID2' 来实现。



## Bash

Are you bash shell today？

- [UploadScript](UploadScript): 将新增、修改过的文件、目录通过 ftp 命令更新到服务端的脚本。自从托管到 GitHub 后，就不再用啦。
- [RssGenerator](RssGenerator): 根据 emacs-wiki-journal 生成的文本文件来产生 RSS 源的小脚本。早已废弃不用。
- [Tiny script stuff](ScriptStuff): 一些零零碎碎的小函数。



## Elisp

Lisp 的古老方言，用以扩展 Emacs 功能的强大工具。但多年来使用的机会不多，只会一丢丢的配置了。

- [Simple journal](SimpleJournal): 简单的日记本函数，当年就是不喜欢使用 Emacs 自带的 todo 和 diary 来记，直到现在也一样...
- [Emacs Wiki Journal](EmacsWikiJournal): 基于 [EmacsWiki](scratch#EmacsWiki) 实现的 blog 系统，在别人基础上改的。目前已[更换 Markdown Engine 为 cmark-gfm](blog#2019-06#p0) 了。
- [SQLite mode](SQLiteMode): 是用来与 SQLite 数据库交互的小型前端，拥有命令回顾，语法高亮的简单功能。



## Assembly

大三才开始学汇编，而且是简单的 8086 系列，可以说是刚刚入门。虽说汇编足够精炼，但是用这个东西去编程实在是麻烦，太花时间，而且通用性肯定不好。

- [指法练习程序](ShotGame): 没错，仿以前 DOS 下的 TT 打字游戏。字符在屏幕上一个一个地往下掉，若敲中相应的键，对应的字符就消失。可调字符颜色，下落速度以及响铃模式等等，非常简单的一个小游戏，但是编它却很花时间。
