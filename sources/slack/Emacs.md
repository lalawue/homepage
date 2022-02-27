
#title Emacs

## EMACS

最近更新: 2008-07-02

Emacs 拥有几乎无限的可扩展能力，如果你稍微懂一点 elisp，将更能体会这种感觉。和[ RobinH.ood](http://202.38.99.17/~huxw/) 一样，我更愿意将她看成是一个操作系统，而不仅仅只是一个文本编辑器。

**本页目录**

#contents 4


### 简单介绍

不妨看一下[王垠主页](http://learn.tsinghua.edu.cn/homepage/2001315450/emacs.html)和[李宇主页](http://liyu2000.nease.net/webpage/Emacs.html)上的 Emacs 部分，介绍得很详细，在这里我可以偷懒了，:)



### Emacs 的历史

刚开始使用 Linux 那会儿，只顾着摆弄 Emacs，却没有注意到其实 Emacs 是一个很有历史的软件，比我的岁数还要大！直到有一天看了 [Liyu](http://liyu2000.nease.net/webpage/WelcomePage.html) 的主页上的 Emacs 历史介绍，才发觉 Emacs 的来头真是不小。

 1. [EmacsWiki](http://www.emacswiki.org) 上介绍 [Emacs 历史](http://www.emacswiki.org/cgi-bin/wiki/EmacsHistory)的文章
 2. [JamieZawinski](http://www.emacswiki.org/cgi-bin/wiki/JamieZawinski) 写的 [Emacs Timeline](http://www.jwz.org/doc/emacs-timeline.html), 这是一个<a href="http://www.aisee.com/graph_of_the_month/emacs.gif">图形化的版本</a >



### 一些有用的设置

#### Compile function

很多时候，我们编程只是为了做习题，所以往往只需要编译一两个文件，用到
Makefile 的时候并不多，而 Emacs 原配的 compile 命令对于小小的编译工作稍
显麻烦，得先设置编译命令，之后再运行。

下面的函数可以根据预设的文件类型选用不同的编译器编译当前正在编辑的文件，
对于做题等等非常有帮助，省了不少力气。还可以很方便地如法炮制不同的匹配。

```lisp
;; C-f5, 设置编译命令，用 Emacs 原来的 compile 
;; f5, 保存当前窗口并选用不同的编译器编译，可如法往上添加匹配
(defun sucha-smart-compile ()
  "Simply compile your file according to the file type."
  (interactive)
  (save-some-buffers t)
  (let
      ((compile-command nil)
       (alist
	(list '("\\.c$" .  "gcc")
	      '("\\.cc$" . "g++")
	      '("\\.cpp$" . "g++"))))
    (while (not (null alist))
      (if (string-match (caar alist) (buffer-file-name))
	  (setq compile-command
		(concat (cdar alist) " " (buffer-file-name))))
	(setq alist (cdr alist)))

    (if (null compile-command)
	 (setq compile-command
	       (read-from-minibuffer "Compile command: ")))
    (compile compile-command)))
(global-set-key [C-f5] 'compile)
(global-set-key [f5] 'sucha-smart-compile)
```


#### Tags and speedbar

Emacs 本身就提供了许多代码浏览的工具，对我来说，Emacs + Speedbar + TAGS 就已经很好用了。下面是一些方便查找、跳转 TAGS 的函数和快捷键。

```lisp
;; 生成 TAGS, adong 提供 (in LinuxForum GNU Emacs/XEmacs)
;; find -name "*.[ch]*" | xargs etags -a

;; 查找 TAGS 文件
(global-set-key [(f7)] 'visit-tags-table)

;; 以下由 zslevin 提供(LinuxForum GNU Emacs/XEmacs)

;; C-. 在另一窗口处查看光标处的 tag
;; C-, 只留下当前查看代码的窗口（关闭查看 tag 的小窗）
;; M-. 查找光标处的 tag，并跳转
;; M-, 跳回原来查找 tag 的地方
;; C-M-, 提示要查找的 tag，并跳转
;; C-return, 查找 tag 自动补全

(global-set-key [(control .)] '(lambda () (interactive) (lev/find-tag t)))
(global-set-key [(control ,)] 'delete-other-windows)
(global-set-key [(meta .)] 'lev/find-tag)
(global-set-key [(meta ,)] 'pop-tag-mark)
(global-set-key (kbd "C-M-,") 'find-tag)
(global-set-key [(shift return)] 'complete-tag)

(defun lev/find-tag (&optional show-only)
  "Show tag in other window with no prompt in minibuf."
  (interactive)
  (let ((default (funcall (or find-tag-default-function
			      (get major-mode 'find-tag-default-function)
			      'find-tag-default))))
    (if show-only
	(progn (find-tag-other-window default)
	       (shrink-window (- (window-height) 12)) ;; 限制为 12 行
	       (recenter 1)
	       (other-window 1))
      (find-tag default))))
```

而 Speedbar 根本不用设置，我个人只是不大喜欢它默认使用 image 的方式和过快的更新速度，只要重新设置一下就可以了。Speedbar 里面也提供很好用的快捷键，C-h m 就可以看到很多说明。

```lisp
(setq speedbar-update-speed 3)
(setq speedbar-use-images nil)  ;; clear face, :)
```



#### CSCOPE &#38; GTAGS

当你需要处理更大量的代码时，可以考虑使用 CSCOPE 和 GTAGS 来浏览代码，在
使用上也不会很复杂，这两个工具我都有用过一段时间，最后一直是在使用
GTAGS，它的效率更好一些。

一些配置和使用上的文章请点击下面的链接：

 - [GTAGS 和 company-mode](blog#2008-06#p1)，有关 GTAGS 配置和非常炫的补全前端
 - [CSCOPE 和 GTAGS](blog#2008-03#p0)，有关 CSCOPE 配置的，这是较早使用 CSCOPE 时留下的记录

不管是 GTAGS 还是 CSCOPE，都和 TAGS 类似，浏览前需要生成 TAG 文件，对一些
文件编辑之后也需要更新相应的 TAG 文件，否则会出现搜索上的误差。


#### hippie-expend

自从我使用过 hippie-expend 之后，我就决定将 dabbrev-expand 的默认按键用来
绑定 hippie-expend，这将大大节省你的重复性体力劳动。

hippie-expend 和 dabbrev-expand 一样，也是对当前的输入字符进行自动扩展，
但是它的功能更多，因为它根据的是你定义的 hippie-expend-try－
functions-list 这个变量里各个函数的顺序来进行尝试性扩展的，因此“适用范围
”要比 dabbrev-expand 大得多，除了尝试 dabbrev-&#42; 系列，还可以自定义其
他方面，下面是我从 LinuxForum 上面抄过来的设置：

```lisp
;; 定义你的 hippie-expend-try－functions-list
(setq hippie-expand-try-functions-list
      '( ;;senator-complete-symbol
	try-expand-dabbrev
	try-expand-dabbrev-visible
	try-expand-dabbrev-all-buffers
	try-expand-dabbrev-from-kill
	try-complete-file-name-partially
	try-complete-file-name
	try-expand-all-abbrevs
	try-expand-list
	try-expand-line
	try-complete-lisp-symbol-partially
	try-complete-lisp-symbol))
;; 绑定按键
(global-set-key [(meta ?/)] 'hippie-expend)
```

这个函数在平常的使用中频率还是很高的，特别是编程的时候，既能省力又保证不
会出错。



### 资源链接

下面是我知道的有关 Emacs 的资料站点和个人主页，以及一些教程。

#### 外文站点

[Emacs](http://www.gnu.org/software/emacs/emacs.html): GNU Emacs 的主页<br />
[XEmacs](http://www.xemacs.org/): XEmacs 的主页

[www.emacswiki.org](http://www.emacswiki.org/): Emacs 和 XEmacs 的 wiki 站点， 强烈推荐<br />
[www.dotemacs.de](http://www.dotemacs.de/): 一个教你如何配置 .emacs 的站点

[Emacs Lisp List](http://www.damtp.cam.ac.uk/user/sje30/emacs/ell.html):  这里保留了一份维护者已知的 Emacs lisp 文件列表<br />
[Emacs Tiny Tools](http://tiny-tools.sourceforge.net/): 如题，用于 Emacs 的小工具


#### 中文站点

[Emacs 中文站点:](http://www.emacs.cn/) Emacs 的中文站点，Wiki 建站，资源膨胀中……<br />
[Emacs 快速指南](http://www.gnu.org/software/chinese/manual/TUTORIAL.cn): Emacs 菜单->Help->Emacs Tutorial(choose language...)，选择语言<br />
[Emacs 中文化指南](http://zhdotemacs.sourceforge.net/emacs/index.html): 中文使用者当然不能错过了

[Shredder](http://learn.tsinghua.edu.cn/homepage/2001315450/emacs.html): 王垠个人主页的 Emacs 部分<br/>
[Liyu](http://liyu2000.nease.net/webpage/Emacs.html): 李宇个人主页的 Emacs 部分<br/>
[Xueruini](http://learn.tsinghua.edu.cn/homepage/2003214890/publish/GNU/emacs.html): 薛瑞尼个人主页的 Emacs 部分

[ChunYe Wang](http://ann77.stu.cdut.edu.cn/Emacs/EmacsIndex.html): 王纯业个人主页的 Emacs 部分<br/>
[RobinH.ood](http://202.38.99.17/~huxw/): RobinH.ood 的个人网站


#### 一些 elisp 的教程

[GNU Emacs Lisp Reference Manual](doc#elisp_html_node.tar.gz)<br />
[An Introduction to Programming in Emacs Lisp](doc#emacs-lisp-intro.html)
