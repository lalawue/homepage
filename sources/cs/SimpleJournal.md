
#title Simple Journal

## Simple journal

最近更新: 2005-11-13

**本页目录**

#contents 3


### 简要介绍

这是一个方便写日记的简单函数，随时记录，按月分类文件，每条记录包含题目，时间和星期。但是由于没有搜索代码，所以不利于回头搜索。函数的目的只是实现简单的记录。

### 使用方法

在 emacs 里加东西很简单的，要么把它作为一个 .el 文件 load 进去，或者就直接把它写到你的"~/.emacs"文件中。

下面这几个函数很短，直接把它复制到你的"~/.emacs"里就行了。或者把它们写在另外一个 .el 文件中，在"~/.emacs"里用"(load "~/path/file.el")" load 进来就行了。


### 它是如何工作的?

下面是一个增加日记条目的函数。如果是这个月第一次写日记，函数会在"~/path/to/your/journal/dir/"文件夹下根据当月时间建立名为"yyyy-mm"这样按年月分类的文件，并在文件头上写"# user's journal created yyyy-mm-dd"这段文字，接着插入当前的日期、时间和标题。

如果文件已经存在，则只插入日期、时间和标题。

```lisp
(defun sucha-simple-journal-add-entries  (heading)
  "Open the local diary file and add entries today."

  ;;; if you need backup, remove the ';' beginning of the line
  ;(shell-command "tar -czpf backup_filename.tgz ~/path-to/files-dir/;
  ;  mv backup_filename.tgz ~/path-to/backup-dir/")

  (find-file (format "~/path/to/your/journal/dir/%s" 
		     (format-time-string "%Y-%m")))

  (goto-char (point-min))
  (unless (re-search-forward "^# " nil t)
    (insert "# user's journal created "
	    (format-time-string "%Y-%m-%d\n") "\n"))

  (forward-line 1)
  (insert "\n\n\n\n")
  (forward-line -3)
  (insert (concat 
	   "<"
	   (format-time-string "%e")"号, 周"
	   (format-time-string "%a ")
	   (format-time-string "%H:%M")
	   ">  "
	   heading
	   "\n    "))
  (text-mode))
```

下面是一个从 mini-buffer 读取用户日记标题的函数，并将读取到的函数传递到上面的函数中。如果你不想要标题，留空就行了。

```lisp
(defun sucha-simple-journal-add-heading ()
  "Get the local journal heading from minibuffer."
  (interactive)
  (sucha-simple-journal-add-entries
   (read-from-minibuffer "Journal Heading: ")))
```

我希望随时使用它，所以最好把它绑定到一个按键上。比如下面的f11。
```lisp
(global-set-key [(f11)] 'sucha-simple-journal-add-heading)
```


### 不能工作？

有什么问题，你可以随便修改上面的代码，或者联系我吧 <a class="nonexistent" href="mailto:suchaaa@gmail.com">EmailMe</a>，同时欢迎任何意见或建议。
