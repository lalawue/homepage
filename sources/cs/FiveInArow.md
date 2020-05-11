
#title Five In Row

## Windows 下的五子棋游戏

最近更新: 2005-05-06


### 下载试玩

 1. [Download here (include src and .exe)](code#chess.tar.gz)

 2. [Download Win-TC V1.9.1](http://www.google.com/search?hl=zh-CN&newwindow=1&q=win-TC+V1.9.1&btnG=%E6%90%9C%E7%B4%A2&lr=)


### 一些说明

我是用 Win-TC v1.9.1 编译的。虽然 Win-TC 说它是用 TC2.0 的编译器，但我用 TC2.0 编译不了，主要是图形驱动方面的问题。

自我感觉程序在绘图方面还好，但是算法方面就太差了。我是用模拟五子棋棋盘的二维数组存储棋子信息的，虽然很好记录，但在处理 bot 的计算方面就太让人头疼了，搞得我头好大。一开始没有好好规划，我发现我错了…… 

程序的 bug 蛮多，主要就是 bot 太“傻”了，会主动犯错。这是我的算法和程序处理本身的问题，扫描棋盘的时候有错误。不过不要担心，程序对于任何五子相连的情况，都不会犯错，这方面没有 bug，:)
