
#title Emacs Wiki Journal

## Emacs Wiki Journal

最近更新: 2013-12-25

**本页目录**

#contents 4


### 简要介绍

关于 EmacsWiki 的简单介绍请看[这里](scratch#EmacsWiki)。

而 EmacsWikiJournal 则是建立在 EmacsWiki 上的一个 Blog 系统，支持生成
RSS 种子，日历和存档连接，软件按月份存档，并可以自定义首页的记录数目。不
过即便如此，相比如今的各种 Blog 系统，EmacsWikiJournal 的功能还是很有限
的。

EmacsWikiJournal 和 EmacsWiki 的语法规则一样，配置的过程也差不多，而且可
以作为 EmacsWiki 的一个 project 来管理，和 EmacsWiki 其他的 project 是一
样的。

### 下载说明


<https://github.com/lalawue/emacs-wiki-journal><br />
<https://github.com/emacsmirror/emacs-wiki-mode><br />

适配最新的 Emacs 24，我目前使用的版本是 GNU Emacs 24.3.50.1。


### 配置及使用说明

#### 初次接触 Emacs Wiki Journal

如果你是第一次接触 EmacsWikiJournal，不妨 M-x customize-group，输入
emacs-wiki-journal 来进行配置，对于每个变量的设置都有简短的英文说明，只
是完成它要花一点时间。如果你选择这样建立配置文件，下面的部分就不用看了。

#### 一些设置说明

下面的配置部分假设你已经配置好了原来的 EmacsWiki 和 EmacsWikiJournal。在
对原来的配置文件做出改动前，请做好必要的备份，所谓有备无患。
##### 需注释掉的变量

请将这一部分注释掉，以免和修改过的代码冲突。只需在每行的前面加上一个分号';'。

```source
; '(emacs-wiki-journal-date-format "%Y-%m-%dT%T%z")
; '(emacs-wiki-journal-date-tag-template "<!-- date: %s -->")
```

##### 需增添的变量

下面的这一部分，请作相应的修改，添你的 ~/.emacs 文件或 load 进来的外部 EmacsWiki 配置文件即可。

```source
(custom-set-variables
; emacs-wiki-journal-wiki 是最新月份记录的拷贝，是一个“静态”页面，下面定义
; 它的文件名以及标题
 '(emacs-wiki-journal-wiki "index")
 '(emacs-wiki-journal-welcome-page-title "Title")

; 定义指向当前记录的自连接的名字
 '(emacs-wiki-journal-self-link-name "Permalink")

; 定义是否产生最新月份的 RSS 种子，t 表示肯定，nil 表示否定
 '(emacs-wiki-journal-generate-rss-file t)

; 定义 RSS 的文件头，请对应作相应的修改
 '(emacs-wiki-journal-rss-initial-content
"<?xml version=\"1.0\" encoding=\"utf-8\"?>
<?xml-stylesheet href=\"rss_style.css\" type=\"text/css\"?>
<rss version=\"2.0\"
     xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"
     xmlns:dc=\"http://purl.org/dc/elements/1.1/\"
     xmlns:admin=\"http://webns.net/mvcb/\"
     >
  <channel>
    <title>Sucha's Blog</title>
    <link>http://suchang.net/blog/index.html</link>
    <description>linux, emacs, programming, live and essay</description>
    <dc:language>zh-CN</dc:language>
    <dc:creator>sucha</dc:creator>
    <dc:date>%s</dc:date>
    <admin:generatorAgent rdf:resource=\"http://suchang.net\"/> \n\n")

; 定义 RSS 种子包含路径的文件名
 '(emacs-wiki-journal-rss-file-name
   "~/path/to/your/publish/dir/rss.xml")

; 定义首页的记录数目
 '(emacs-wiki-journal-wiki-max-entries 11)

; 定义指向 blog 的连接
 '(emacs-wiki-journal-rss-link
 "http://suchang.net/blog/index.html")

; 你的网络 ID
 '(emacs-wiki-journal-maintainer "sucha")
 )
```

##### 需增添的布局

下面是将日历和存档连接插入页眉的例子，或者，你也可以将它们插入到页脚。为
了在产生日历和存档连接后更好地控制版面，建议使用 div 容器来存放各部分的
内容。

```source
<?xml version=\"1.0\" encoding=\"utf-8\">
<html>
  <head><!-- Original text/样本页眉的原来部分 --></head>
  <body>
      <h1>title/你的标题</h1>

      <div class=\"side_bar\">
      <!-- 你可以在这里或其他地方增加一些固定连接，像通往首页、你的
      RSS 种子连接、友情连接或者是你的分类文件连接以及广告等等 -->

      <!-- 如果你需要日历，就将这部分加入 -->
      <lisp>(emacs-wiki-journal-insert-calendar)</lisp>

      <!-- 如果你需要产生存档连接，就将这部分加入 -->
      <lisp>(emacs-wiki-journal-generate-archive-links)</lisp> 
      </div><!-- side_bar -->

      <div class=\"body\">
      <!-- Page published by Emacs Wiki begins here -->
     
      <!-- 记录文档的插入部分，上面是页眉，下面是页脚 -->

      <!-- Page published by Emacs Wiki ends here -->
      </div><!-- body -->
    </body>
</html>
```

##### 建议使用以下部分

这部分是我从 **薛瑞尼** 个人网站中的 EmacsWiki 部分得来的，作者是现在维护
Planner 的 sacha。实在是非常好用，可以省去每次保存后还要发布成 html 的麻
烦——每次修改后只需保存即可自动发布，强烈建议大家都尝试一下。只需拷贝进你
的 ~/.emacs 或 load 进来的外部 EmacsWiki 配置文档。

```source
;; emacs-wiki auto-publish from sacha, add my hack.
(defun sacha-emacs-wiki-auto-publish()
  (when (derived-mode-p 'emacs-wiki-mode)
    (unless emacs-wiki-publishing-p
      (let ((emacs-wiki-publishing-p t)
	    (emacs-wiki-after-wiki-publish-hook nil))
	(emacs-wiki-journal-publish-this-page)
;	(emacs-wiki-publish-index) ; 如果你需要在保存的同时自动发布 
	))))                       ; WikiIndex，请将行首的';'去掉

(add-hook 'emacs-wiki-mode-hook
	  (lambda () (add-hook 'after-save-hook
			       'sacha-emacs-wiki-auto-publish
			       nil t)))
```

##### 我的个人设置文件

下面是我的个人 EmacsWiki 和 EmacsWikiJournal 设置，我用它们来维护我的个
人网站和 blog。由于使用上的需要，相比原来的样本页眉页脚，已经修改了很多
地方，也许没有什么借鉴意义。

不管怎么说，在这里权且充当能够成功使用的一个例子吧，header 和 footer 是
相应主页以及 blog 的文件头和文件尾。注意，下面的文件都是 utf-8 编码。

[emacs-wiki-conf.el](code#emacs-wiki-conf.el.htm)<br />
[site-header.htm](code#.site-header.htm)<br />
[site-footer](code#.site-footer.htm)<br />
[blog-header.htm](code#.blog-header.htm)<br />
[blog-footer.htm](code#.blog-footer.htm)<br />


### 感谢

感谢 [Mwolson](http://www.mwolson.org/) 的 [EmacsWiki](EmacsWikiProject)，使得维护一个网站变得如此简单。<br />
感谢 Yamagata Yoriyuki 的 [EmacsWikiJournal](http://www15.ocn.ne.jp/~rodinia/emacs-wiki-journal.el)，给我有了现实中修改的基础。<br />
感谢 [gswamina](http://www.sfu.ca/~gswamina) 的 [EmacsWikiBlog](http://www.sfu.ca/~gswamina/EmacsWikiBlog.html)，带给了我如此多的灵感。

感谢 长弓无敌 (junshen365 AT 163 DOT com)，解决了第一次使用时无法插入首
页的 bug。


### 臭虫？

有什么问题，可以联系我 <a class="nonexistent" href="mailto:suchaaa@gmail.com">EmailMe</a>，同时欢迎任何建议和意见，有编程经验的童鞋，
不妨 github 上面直接给我 patch 吧。
