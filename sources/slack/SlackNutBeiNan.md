
#title Slack Kernel

## Slack kernel

题目：用 Slackware 官方内核源码和脚本来打造适合自己机器的内核 —— 为 Slackware 初初级用户指南<br />
作者：北南南北<br />
来自：[LinuxSir.Org](http://www.linuxsir.org)<br />
提要：用Slackware官方提供的内核源码和脚本来打造适合自己机器的内核，学习编译内核并提高我们的学习和工作效率；

**本页目录**

#contents 4



### 前言：

现在的机器配置越来越高，一个小小的笔记本，可能也能上到 2G 内存，另外服务器的应用，经常用到大内存，从实践的情况来看，Slackware 用默认的内核是不支持大内存的，最高支持 800 多 M，可能 1G 都不到。另外 Slackware 在默认的情况下也不支持多 CPU，如果您有多 CPU 的机器，也要编译内核；

让 Slackware 支持 1G 或者超过 1G 内存的机器，其实解决办法也极为简单。要重新编译一下内核，让其支持 4G 就好了。当然如果有有超过 4G 的，可以选 64G 的那个。

让 Slackware 支持多 CPU 的机器，无非是在配置内核时让他支持 SMP，就是这个 [＊] Symmetric multi-processing support 选项；

只说如何如何解决还不行，一篇文章如果没有操作实例，新手弟兄读起来实在是困难。我写的文章都是写给新手的，我总怕我写的文章新手看不懂，对老鸟来说又一文不值；如果真是新手弟兄看不懂，老手又不值得一看，我看我写的东西一文不值。因此我写东西的时候能详细就详细，最好是写到初次用 Linux 的弟兄看了我所写的文档，也能一步到位的完成。

本文适合：初初级新手

在 Slackware 系统中最省力气编译内核的办法，是用 Slackware 现有的官方资源来进行编译，其它的软件遇到问题，如果 Slackware 的官方有资源，我们同样可以用这种解决办法； 

毕竟从 <http://www.kernel.org> 直接下载，自己配置内核还是有点辛苦。如果是初学 Linux 的弟兄可能要花好长时间来配置，但还不能保证成功。所以我们这些 slack 的追随者来说，要充分利用 Slackware 的资源。

有内核编译经验的弟兄都知道，如果配制好后，编译成功了，要把 .config 文件保存下来，以便下次为了解决一些小问题，重编同一版本的内核而用；相信 Slackware ，相信 Slacware 的官方资源；这样能让我们事倍功半，尤其对初学 Slackware 的弟兄。其实 Slackware 的内核更新并不是太积极，这和 Slackware 的传统（安全）有关。其实一般的情况下，我们有一个比较稳定的内核足够用，如果不是为了解决特定的问题，我们没有必要整天升级来升级去的。在我写本文的时候，Slackware 10.1 的内核版本是 2.4.29；而 current（也就是开发版本）的 test 内核是 2.6.12.3 。由况下此看来 Slackware 不是追新族，是以安全和稳定为主；

在本文我们以 Slackware 的 current 的 test 内核来简要的说明应用 slackware 的官方资源的好处，以及顺便也解决一下大内存支持的问题；



### 一、下载官方current 的testing内核的源码；

地址：<http://www.slackware.com/getslack/>

<ftp://slackware.mirrors.tds.net/pub/slackware/slackware-current/testing/source/linux-2.6.12.3/>

从上面的地址找镜像，一般的情况下美国和日本的要快一点；

比如我们通过下面的地址得到 testing 的内核 linux-2.6.12.3 的源码目录；

我们要把他里面的所有东西都下载下来，Slackware 所提供我们的安装包就是通过这些文件编译生成的；人都都把配置文件和脚本写好了，我们没有必要不用；

比如我们 FTP 镜像中的 linux-2.6.12.3 所有文件都按他 FTP 提供的目录结构存放在到 /usr/src/kernel26 中；

下载好了，我们进入下一步；



### 二、利用Slackware官方提供的 config文件来简单配置自己的内核配置文件 .config ；


#### 1.解压内核及一些基础工作；

```source
bash-3.00# pwd
/usr/src/kernel26
bash-3.00# ls
config-2.6.12.3 kernel-generic linux-2.6.12.3.tar.bz2.sign
kernel-modules linux-2.6.12.3.tar.bz2
bash-3.00#tar jxvf linux-2.6.12.3.tar.bz2
bash-3.00# mv linux-2.6.12.3 .. 把解压手内核目录移到上一级目录中，也就
是 /usr/src 中
bash-3.00# cd ..
bash-3.00# ls
kernel26 linux-2.4.29 linux-2.6.12.3.tar.bz2 speakup-2.4.29
linux linux-2.6.12.3 rpm
bash-3.00#cd linux-2.6.12.3
bash-3.00# pwd
/usr/src/linux-2.6.12.3
bash-3.00# cp ../kernel26/config-2.6.12.3 . 把内核配置文件复制到当前工
作目录 linux-2.6.12.3
bash-3.00#cp config-2.6.12.3 .config 把 config-2.6.12.3 复制为 .config
```

#### 2.简要的配置内核；

bash-3.00# make menuconfig 进入配置内核的配置模式 ；

内核配置有两种方法，一种是直接置入内核；另一种是编成模块；两种方法各有优点；直接编入内核的，比如设备的启动，不再需要加载模块的这一过程了；而编译成模块，则需要加载设备的内核支持的模块；但直接把所有的东西都编入内核也不是可行的，内核体积会变大，系统负载也会过重。我们编内核时最好把极为重要的编入内核；其它的如果您不明白的，最好用默认。slackware 的内核配置文件是最好的教程；


##### 1］移动键盘，选中 Load an Alternate Configuration File 项，把 .config

调进来方便我们配置；因为这个配置文件是 Slackware 已经配置好的，我们只是稍加修改就行。


##### 2]针对自己机器存在的问题进行修改；比如我们在前文所提到的大内存支持的问题；

选择自己机器的CPU；

移动键盘到 Processor type and features ---> ，然后按ENTER进入；

找到 Processor family (486) ---> 按ENTER进入；

进入后我们发现有好多CPU的型号可选；一般的情况下要根据 bash-3.00# cat /proc/cpuinfo 输出的信息来选，比如我们的是 Celeron （P4）一代的，应该选如下的，当然默认的 486 也是可以正常运行的，既然我们重编一次内核，就得选中对应型号的，也许性能有所提高呢； 

Processor family (Pentium-4/Celeron(P4-based)/Pentium-4 M/Xeon)

对大内存支持；如果内存是 1G 或者 1G 以上，但小于 4G 的，就要选 4G 支持；如果超过 4G 的，要选 64G 的支持；

```source
High Memory Support (4GB) --->

(X) 4GB
( ) 64GB
```

还有比如声卡等硬件，需要我们一步一步的查看；如果有不明之处，就要按 [shift]+？的组合键来查看说明。一般的情况下，slackware 的 config 文件早都配置好了，只需要我们来查看一下就可以了。

再举个例子：比如我现在所用的声卡是 intel ac97 的，我应该怎么配置呢？

首先要知道自己的声卡的芯片组，我们要通过 lspci -v 来查看；

```source
bash-3.00# lspci -v
```

只查看声卡的，应该用如下的方法：

```source
bash-3.00# lspci -v |grep audio
00:1f.5 Multimedia audio controller: Intel Corp. 82801DB (ICH4) AC'97
Audio Controller (rev 03)
```

通过上面的输出，我们知道这台机器用的是 intel AC97 声卡；所以我们要特别注意 AC97 的配置；

```source
找到 Device Drivers ---> Sound --->
< M > Sound card support 声卡的支持，这个是一定要选中的吧；

< M > Advanced Linux Sound Architecture 对声卡支持的 ALSA 驱动的支持；下
面有 OSS 驱动，只是一部份。如果想用 OSS 的驱动更全的，可以去买；其它的就看
如下的选吧；

< M > Sequencer support
< M > Sequencer dummy client
< M > OSS Mixer API
< M > OSS PCM (digital audio) API [*] OSS Sequencer API
< M > RTC Timer support [*] Verbose printk
[ ] Debug
```

然后我们再向下看有

```source
Generic devices ---> 进入里面
< M > Dummy (/dev/null) soundcard
< M > Virtual MIDI soundcard
< M > MOTU MidiTimePiece AV multiport MIDI
< M > UART16550 serial MIDI driver
< M > Generic MPU-401 UART driver
ISA devices ---> 如果您用 ISA 声卡就在这里面选；
PCI devices ---> 如果您用 PCI 声卡，就在这里面选，集成声卡也在这里；
USB devices ---> 这是 USB 声卡内核支持选项；我有一个这样的声卡，但没有试过；
PCMCIA devices ---> 这是 PCMCIA 声卡的选项，我还没有看过这样的声卡呢；
                    如果您有，就在这里面动动手吧。
因为我用的是 Intel 集成的声卡，所以要在 PCI 中选择，我们在 中可以看到
有两个与 INTEL 有关的；
< M > Intel/SiS/nVidia/AMD/ALi AC97 Controller 这个才是 Intel AC97 声卡的；
< > Intel/SiS/nVidia/AMD MC97 Modem (EXPERIMENTAL) 这个是机器集成的
INTEL 猫的蜂鸣器的；
```

因为我发现如果把猫的蜂鸣器的驱动也选上，可能造成两个冲突。所以只能选上面的那个；

我们再回到 Open Sound System ---> 中看看，与我用的声卡是不是有关的？

```source
< M > Open Sound System (DEPRECATED)
< M > Intel ICH (i8xx) audio support
< M > OSS sound modules
< M > Loopback MIDI device support
< M > Microsoft Sound System support
```

我们也可以看到 Open Sound System 中也有好多的声卡驱动，大家根据前面的 lspci -v 来选择吧。


##### 3]对于操作系统所采用的文件系统的支持要编入内核，最好不要编成模块；（重要）

```source
File systems --->
<*> Reiserfs support
```

比如我的 Slackware 所采用的文件系统用的是 reiserfs，所以我要把它直接编入内核；好处是不受模块丢失或者损坏而不能启动系统；而有时您把系统所采用的文件系统编译成模块，出现 VFS 错误，也有这方面的事，可能是您没有把 reiserfs 加入到相应的加载模块的配置文件中，所以我们为了减少麻烦，把风险降到最低，还是要直接置入内模的好；

如果您还有其它的硬盘分区要读取，比如是 ext3、ext2、fat、fat32、ntfs 等，这样的可以编成模块来支持； 

再举一例：如果您的的操作系统用的是 ext3 的文件系统，当然就要把 ext3 的直接编入内核，其它的可以编成模块来支持了； 


##### 4］对于硬盘及 RAID 的支持，要直接编入内核

比如 ATA、SATA、SCSI 及 RAID 的支持直接内核支持；有时编完内核后，启动时不能识别硬盘和 RAID，大多事情出在这里；Slackware 中在这方面有的是模块支持，我们可以把它由< M >改成 <＊> 来支持；

##### 5]对于咱们所没有的设备，可以在内核中不选，熟能生巧罢了；

比如我没有 ISDN 设备 ，所以就把 ISDN 去掉；

```source
ISDN subsystem --->
< > Linux telephony support
```

如果您没有 1394 的设备 ，当然可以把 1394 的支持也去掉；

等等。。。。。。。

内核配置就说这么多吧，太多了，我也说不清楚，水平有限啊；配置好后先要保存

Save Configuration to an Alternate File

出来一个

Enter a filename to which this configuration ，should be saved as an alternate. Leave blank to abort.
.config

按回车就行了，这样就保存住了；

然后退出 < Exit > ，这时也会出现保存 ；

如果你想把 .config 保存起来，可以再复制一份到安全一点的目录，以备后用；


#### 3.编译内核

```source
bash-3.00# make
bash-3.00# make modules_install
```

这样就编译好了，并把模块也安装在了 /lib/modules 目录中了，请看：

```source
bash-3.00# ls /lib/modules/
2.4.29 2.6.12.3
```

现在我们得安装内核了，但我们也没有必要急着安装，我们可以用 Slackware 提供的脚本来打包,然后再来安装，这样移除也方便，对不对？



#### 4.用 Slackware 提供的脚本为内核及 moudules 打包；

我们在前面已经说了，把 linux-2.6.12.3 在镜像上的目录下的所有东西载下来。所以我们要用到这些东西了。我在前面把所有的东西都下载到了 /usr/src/kernel26 目录中。

所以我们要用他所提供的脚本打包；
```source
bash-3.00# cd /usr/src/kernel26/
bash-3.00# ls
config-2.6.12.3 kernel-generic kernel-modules linux-2.6.12.3.tar.bz2
linux-2.6.12.3.tar.bz2.sign
```


##### a)首先我们为内核打包：请运行如下命令：

```source
bash-3.00# bash-3.00# cp kernel-generic/slack-desc .
```

我们要把 kernel-generic/slack-desc 复到制当前操作目录中，只是一个说明文件；不复制也行；反正是自己用，也不是给别人用的；

```source
bash-3.00# sh kernel-generic/kernel-generic.SlackBuild
```

输出是什么呢？

```source
kernel-generic/kernel-generic.SlackBuild: line 33: [: too many arguments
Building kernel-generic-2.6.12.3-i486-1.tgz
using these source files. Please check and then hit
enter to make the package.

KERNEL = /usr/src/linux-2.6.12.3/arch/i386/boot/bzImage
SYSMAP = /usr/src/linux-2.6.12.3/System.map
CONFIG = /usr/src/linux-2.6.12.3/.config
```

看到了吧，我们用的配置文件在 /usr/src/linux-2.6.12.3/.config ；然后按回车；

**注意**：如果您把打包脚本 kernel-generic.SlackBuild 复制到了 /usr/src/linux-2.6.12.3 ，并在 /usr/src/linux-2.6.12.3 中执行它，提示运用的配置文件是 CONFIG = /usr/src/linux-2.6.12.3/config＊ ，所以要看好了。其实这个文件我们可能没有配置，是 slackware 原始自带的，我们在前面已经说了，我们配置的文件是 .config；除非你有把. config 另存为 config-2.6.12.3。如果要用我们配置好的内核文件，要进入内核源码目录，把 .config 拷贝一份名为 config-2.6.12.3的；


##### b)然后我们要为内核的模块打包；

```source
bash-3.00# sh kernel-modules/kernel-modules.SlackBuild
```

我们把包都打好了，他们究竟在哪里呢？在 /tmp 目录中，请看如下：

```source
bash-3.00# ls -lh /tmp/kernel-*
-rw-r--r-- 1 root root 1.9M 2005-08-06 11:59 /tmp/kernel-generic-2.6.12.3-i486-1.tgz
-rw-r--r-- 1 root root 11M 2005-08-06 12:13 /tmp/kernel-modules-2.6.12.3-i486-1.tgz
```


##### 5.安装编译好的内核及模块。

我们其实已经把编译好的模块早就安装好了，但我们最好重新安装一下。这样卸载也方便。

```source
bash-3.00#cd /tmp
bash-3.00# installpkg kernel-generic-2.6.12.3-i486-1.tgz
bash-3.00# installpkg kernel-modules-2.6.12.3-i486-1.tgz
```

这样就把内核及模块配置好了。


##### 6.查看系统引导管理器 grub 或者 lilo 的配置文件。

内核在安装的时候，可能已经改了一些东西，比如 /boot 内的变化，比如 vmlinuz 直接链到了 vmlinuz-generic-2.6.12 ，所以如果想要让新老内核都能让系统引导管理器 grub 和 lilo 的菜单上能看得到，必须改 grub.conf 或者 lilo.conf 我们必须保留老内核的在 grub 和 lilo 的启动菜单，毕竟我们编内核不能百分百的成功，对不对？？安全第一吧； 

**后记**：正在修订之中，以让其更可能的全面一点，算是版本0.1吧；没有技术含量，只是想帮助初学者用在最少的时间内掌握编译内核；
