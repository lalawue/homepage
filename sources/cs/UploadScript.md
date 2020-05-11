
#title Upload Script

## Upload Script/上传文件的 Shell Script

 最近更新: 2014-01-04

本页目录 

#contents 2

### 简介

这个脚本将新增，或更新过的本地文件、目录通过 ftp 上传到你对应的远程目录
中，每次只上传更新过的文件、目录，节省时间。

一般 low-cost 的站点，服务端只支持 ftp，使用这个脚本最好不过了。

脚本通过 bash 下 find 命令的 -cnewer 对比文件、目录的 modify time 来达到
检测的目的，对于目录下的文件是没有版本概念的，只有修改时间的概念。

另外，这个脚本不支持删除远程文件、目录。

### 下载试用

这个 bash 脚本需要 ftp 的支持，在 MacOS 下运行正常，估计 Linux 下也没啥
问题，Win 下也许需要 Cygwin 环境，或者 UnixUtils 工具组。

<https://github.com/lalawue/shell_script_stuff><br />

### 设置

<table class="ewiki-table" border="2" cellpadding="5">
<thead>
<tr>
<th>需设置的变量</th><th>说明</th>
</tr>
</thead>
<tbody>
<tr>
<td>publish_dir</td><td>本地发布文件的路径</td>
</tr>
<tr>
<td>server</td><td>ftp 地址</td>
</tr>
<tr>
<td>user</td><td>ftp 用户名</td>
</tr>
<tr>
<td>passwd</td><td>ftp 密码</td>
</tr>
<tr>
<td>rdir</td><td>ftp 上的存放目录</td>
</tr>
</tbody>
</table>


### 运行流程

- 如果是第一次运行程序，将会创建用于记录、比较修改时间的文件. 
- 使用 find 命令来找出发布文件夹下所有修改过的文件(文件的修改时间比记录
文件的修改时间要新)，将其记录到临时脚本中
- 运行脚本，使用系统提供的 ftp 命令上传

### 脚本历史

脚本在我这里运行还好，如果你有什么问题或建议，请联系我 <a class="nonexistent" href="mailto:suchaaa@gmail.com">EmailMe</a>。 

我最开始是想找一个软件用来上传更新过的文件，而不必将整个文件夹一股脑都上传。

后来找到了 Liyu 大哥编的 elisp 小程序 upload-remote.el，但不知道为什么，
这个程序在我这里用不了，而当时我一点都不了解 elisp，搞得使用 emacs-wiki
写网页容易但上传很麻烦。

不过很感谢他提出用 ncftpput 上传的方法，给了我灵感，加上自己正在学习
bash 编程，于是花了不少时间编了这个 upload script，正好用它来更新我的网
站。

感谢 zhao wang (arithboy AT gmail DOT com)提出的上传失败后的问题。

2014 年改成脚本上传了，只需要一次 ftp 连接，将方便很多，连接失败的情况则
未处理。

