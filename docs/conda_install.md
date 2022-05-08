conda install
===

# 什么是conda

Conda 是一个开源的软件包管理系统和环境管理系统，用于安装多个
版本的软件包及其依赖关系，并在它们之间轻松切换。 Conda 是为
Python 程序创建的，适用于 Linux，OS X 和Windows，也可以打包和分发其他软件。

# 安装conda

conda分为anaconda和miniconda。anaconda是包含一些常用包的版本（这里的常用不
代表你常用），miniconda则是精简版，需要啥装啥，所以推荐使用miniconda。通常情况
下，我们用来管理c++版本更喜欢用miniconda，更"干净"一些。

## 下载地址
    
    miniconda官网：https://conda.io/miniconda.html

选择适合自己的版本，用wget命令下载。

```shell
wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# 这个版本是适合于linux的，要看清楚噢。

# mac用户请用：
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

# mac用户选择图形化界面的anaconda版本也可。
# 传送门：https://www.anaconda.com/products/individual 
# 往下翻，选择64-Bit Graphical Installer
```
这里选择的是latest-Linux版本，所以下载的程序会随着python的版本更新而更新
（现在下载的版本默认的python版本已经是3.9了）

## 安装命令

```shell
chmod +x Miniconda3-latest-Linux-x86_64.sh #给执行权限
bash Miniconda3-latest-Linux-x86_64.sh #运行
```
注意，以前的教程都是教一路yes下来的，但是会有隐患，特别是当你的服务器之前有安装过软件的话，conda会污染你原来的环境，
把你原来设置好的东西进行更改。具体的惨痛教训请参见：

所以在询问是否将conda加入环境变量的时候选择no。当然也可以选择yes

## 启动conda

在上一步选择no之后，输入conda是会报找不到此命令的。那要如何启动呢？
找到你刚才安装的miniconda，如果没有更改过安装位置的话应该是在/home下面，
cd到miniconda3的bin目录下面，能看到有一个activate。

```shell
    source activate
```
当命令行前面出现(base)的时候说明现在已经在conda的环境中了。这时
候输入conda list 命令就有反应了

# 添加频道

```shell
conda config --add channels bioconda
conda config --add channels conda-forge
```

# 添加镜像源

```shell
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
```

- 显示安装的频道

```shell
 conda config --set show_channel_urls yes 
```
- 查看已经添加的channels
```shell
conda config --get channels
```

# 安装软件

- 搜索软件
```shell
 conda search faiss
```
- 搜索软件指定版本
```shell
  conda search faiss=1.7.2
  # 或者指定版本大于等于某个版本
  conda search faiss>=1.7.0
```
- 查看已经安装的软件列表

```shell
conda list
```

- 更新软件

```shell
conda update faiss
```

- 删除软件

```shell
conda remove faiss
```

- 退出conda环境

```shell
conda deactivate
```

# 创建conda环境

之前创建的时候显示的是（base）这是conda的基本环境，有些软件依赖的是
python2的版本，当你还是使用你的base的时候你的base里的python会被自动
降级，有可能会引发别的软件的报错，所以，可以给一些特别的软件一些特别的关照，
比如创建一个单独的环境。 在conda环境下，输入conda env list
（或者输入conda info --envs也是一样滴）查看当前存在的环境 ：

```shell
conda env list
```

## 创建一个环境

```shell
conda create -n python3 python=3.8
# -n: 设置新的环境的名字
# python=3.8 指定新环境的python的版本，非必须参数
# 这里也可以用一个-y参数，可以直接跳过安装的确认过程。
```
conda会创建一个新的python3的环境，并且会很温馨的提示你只要输入
conda activate python3就可以启动这个环境了

```shell
conda avtivate python3
```
退出环境

```shell
conda detivate
```

## 删除环境

```shell
conda remove -n myenv --all
```

## 重命名环境

实际上conda并没有提供这样的功能， 但是可以曲线救国，原理是先克隆一个原来的环
境，命名成想要的名字，再把原来的环境删掉即可

接下来演示把一个原来叫做py3的环境重新命名成python3：

```shell
conda create -n python3 --clone py3
conda remove -n py3 --all
```

# 从配置文件创建环境

在生产环境中，一个工程，往往有众多依赖，通常开发过程中，会随着使用使用
`conda install xxx`来安装依赖，当一来过多时，通常会有两种方式管理
这个环境，一种是通过conda 导出这当前的环境，另一种方式通过预先定义环境，
达到环境管理的目的。导出环境这种方式在实际生产中，因为conda会有依赖的树的概念
会导出过多，并且会丢失部分信息，如channel信息，会导致导出的环境并非完全正确。
推荐使用预先定义环境的方式管理环境。

环境配置文件的格式是yaml格式。通过下面的例子来介绍一下, environment_linux.yaml

```yaml
name: conda-dev
channels:
  - conda-forge
  - defaults
  - flare-rpc
dependencies:
  - gcc =8.5 # [linux]
  - gxx =8.5 # [linux]
  - sysroot_linux-64=2.17 # [linux]
  - cmake =3.19.1
  - make
  - gflags =2.2.2
  - leveldb =1.22
  - protobuf =3.12.4 # includes Protobuf compiler, C++ headers, Python libraries
  - openssl =1.1.1
  - zlib
  - gperftools=2.9.1
  - flare =0.2.0
  - frat =0.1.0
  - rocksdb =6.13.3
  - libfaiss =1.7.2
  - boost =1.75.0
```

文件分为三部分

- name 字段， 指定环境名字
- channels 字段，指定从哪些channel安装软件
- dependencies 字段， 指定依赖项目，注意 依赖项的`=`号和版本号之间不能有空格。

创建环境命令：

```shell
conda env create -f environment_linux.yaml
conda activate conda-dev
```
通过上述命令即可启动环境。