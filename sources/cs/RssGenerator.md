
#title Rss generator

## Rss generator

最近更新: 2013-12-25

**本页目录**

#contents 3

### 下载试用

<https://github.com/lalawue/shell_script_stuff> <br />

bash 版本信息：GNU bash, version 2.05b.0(1)-release (i486-slackware-linux-gnu)

emacs-wiki: 2.69<br />
emacs-wiki-journal: latest


### 使用方法

generator 从 emacs-wiki-journal 文本文档产生 rss feeds 需要一些条件:

#### anchor

这个很重要，所有的 rss item 信息的定位都要依靠 #anchor。所以请提供足够的 anchor 前缀，比如 "#categorymisc"，只需去掉最后 的数字即可。

#### sub title

二级标题，也就是 emacs-wiki-journal 默认的标题，item 的 title 是从这里搜集得到的。

#### <'!'-- date: %s -->

item 的 date 信息是从这里搜集的，所以格式要像上面那样，至少它应该存在，而且前 12 个字符相同。因为我是暴力分解的……(因为是 html 的原因，实际的格式是 "<叹号-- date: %s -->")

如果你的一切设置是默认的，那么应该没有问题。具体的设置 shell script 里有，不需要填什么东西，不再累赘。如果还有什么问题，也可以联系我 <a class="nonexistent" href="mailto:suchaaa@gmail.com">EmailMe</a>。


### 它是如何工作的?

1. 按这个顺序扫描 emacs-wiki-journal 文本文件。Journal1，Journal2，...，Journal_maxnum，最后是 Journal，也就是最新的文件。然后依次访问它们(文件名不一定要是 Journal，但它们的前缀必须一样，比如 file1，file2)。如果你觉得这样扫描的文件太多的话，可以让程序只关心 Jouranl 这个文件，具体的做法就是把 scan_entries 的前一部分 for 循环注释掉。

2. 按照这个 anchor 前缀的顺序扫描文件，#anchor0， #anchor1，...，最后是文件里的 #anchor_maxnum，依次分解得到的元素为 title，date 和 description，将分解得到的元素传到 rss generator 中，依照 rss feeds 的格式写入 rss 文件。

3. 访问下一个文件，直到所有文件都访问完了为止。


### 其它的生成工具

分解文件需要文件有统一的格式，如果是用 emacs-wiki 原来的变量来做就简单多了，我这里其实就是暴力分解文件，:D。

所以，如果你的 emacs-wiki 发布形式跟我的不同的话，I have no idea...不过你不必急着用 shell script 来产生你的 rss 文档(暴力分解)，还有别的 .el 文件可以使用，不过我找到的不多，而且最头疼的它是不起作用。

 - [Rss for Emacs Wiki](http://larve.net/people/hugo/2003/scratchpad/RssForEmacsWiki.html): 一个法国人写的 .el，03 年的东西了，只支持 emacs-wiki(?)，不支持 projects，一个简单的小程序。
