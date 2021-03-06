
#title SQLite Mode

## SQLite Mode

最近更新: 2006-03-20

**本页目录**

#contents 3

### 简单介绍


SQLite Mode 是一个用来与 SQLite 数据库交互的小型前端，内部使用 shell 命令与 SQLite 交互，拥有命令回顾，语法高亮的简单功能。

### 下载与使用

#### 下载与需求

[sqlite.el (v0.01)](code#sqlite.el.tar.gz)

对 SQLite 的版本没有要求，而对 emacs 则没有做过测试，我使用的是 emacs-22.0.50.1 版本，Win 下和 Linux 下都没有问题。

#### 使用介绍

可以将文件放入 emacs 的 load-path 路径内，或者修改 ~/.emacs，加入 (add-to-list 'load-path "/path/to/sqlite.el/")，然后再添入 (require 'sqlite)，就可以使用了。

使用 “M-x sqlite-mode" 命令运行程序，在这之前，你或许需要修改一下默认的属性，“M-x customize-group sqlite-mode” 来修改。

```example
Program: 一般填 sqlite 程序名即可，或许得加上必要的路径名
Flags: 控制 sqlite 的输出版面，默认是 “-header -column” 详细信息与
       sqlite 交互时输入 ".help" 查询
Database: 需要操作的数据库
Input window height: 输入栏的高度
```

属性也可以在程序运行时 C-c C-s 做临时的修改。下面是一些按键的安排。

```example
C-c C-s   对属性做临时修改
C-c C-e   清空输入缓冲区
M-p       上一条命令
M-n       下一条命令
RET       确认命令
TAB       上一条命令
```

希望对大家有所帮助，:)
### 有臭虫？

有什么问题或建议，都可以联系我 <a class="nonexistent" href="mailto:suchaaa@gmail.com">EmailMe</a>。
