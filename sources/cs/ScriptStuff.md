
#title Script stuff

## 一些零碎的小函数

**本页目录**

#contents 5

### Google Sitemap Generator

最近更新: 2012-12-25

一个生成为你本地静态网页生成 google sitemap 的小工具，[Google Sitemap Gnerator 的介绍](blog#2008-12#p0)。

<https://github.com/lalawue/shell_script_stuff> (需要 find 命令支持，也可以在 cygwin 等环境下使用)

### 终端下简单的图片浏览器

最近更新: 2005-12-12

在终端下浏览图片很不方便，而开文件管理器又显得麻烦，受到 EMACS 里的一个扩展包 thumbs 的启发，便写了一些小小的函数用于终端下浏览图片。现在这几个函数还是很简陋的，不过还是有点作用。

[w3m images viewer ](code#w3mimages.htm)(需要 w3m 和 ImageMagick)



### 一个简单的 mp3 播放器

最近更新: 2005-12-12

如果你像我一样将所有的 mp3 按歌手（或专辑）分类放在同一个目录下，这个函数或许帮得上忙。函数调用的是 mpg321 来播放某个歌手（专辑）目录下的所有 mp3 文件。

只需将下面的函数拷贝进你的 ~/.bashrc 文件，然后 $ source ~/.bashrc 就可以使用了，又简陋又方便。

[small mp3 player](code#smallmp3player.htm) (需要 mpg321)


### 有问题？

有什么问题，可以联系我 <a class="nonexistent" href="mailto:suchaaa@gmail.com">EmailMe</a>，同时欢迎任何建议和意见。
