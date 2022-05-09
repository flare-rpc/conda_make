制作conda包
====

# 简单尝试：conda 编译c++ conda 包

预安装

- conda
- conda-build
- git
- cmake
- make

以gtest为例, 编译一个c++的conda包．

## 编译准备

创建文件夹作为工作目录：

```shell
mkdir gtest
```
在这个文件夹下面创建文件：
```shell
cd gtest
touch bld.bat
touch build.sh
touch meta.yaml
touch run.sh
```
我们在linux上测试，可以是ubuntu或者centos。 bld.bat是windows上构建脚本。
在linux上为空即可。

### build.sh

```shell
#!/bin/bash
set -e

mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release
cmake --build .
cmake --build . --target install
```

### run.sh

```shell
#!/bin/bash
set -e

export CONDA_BLD_PATH=build

if [ -d "build" ]; then
    rm -rf build
fi

mkdir build
conda build .
```
### meta.yaml

```yaml
package:
  name: gtest
  version: "1.10.0"

source:
  git_url: https://github.com/google/googletest.git
  git_rev: release-1.10.0

build:    
  include_recipe: False

requirements:
  build:
    - make
    - cmake
```

## 编译

```shell
sh run.sh
```

我们的conda包在build/linux-64/下. 等到build/linux-64/gtest-1.10.0-0.tar.bz2后。
我们有三种方式使用该包

- 本地安装
- 上传自建私有仓库，conda添加自建仓库channel，可以通过conda命令安装
- 上传到anaconda中心仓库，通过conda命令安装。

后两种方式都可以通过conda环境依赖的yaml配置文件引入。至此，简单演示了如何利用

# 上传包到anaconda

首先要注册 anaconda cloud 账号
地址为 https://anaconda.org/

## 安装`Anaconda`客户端

```shell
conda install anaconda-client
```

## 上传 `conda`包

### 方式一

登录 Anaconda

```shell
anaconda login
```
上传 Conda 包，执行以下命令

```shell
$ export CONDA_FILE=`conda build ${RECIPES_PATH} -c conda-forge -c defaults --output`
$ LABEL_OPTION="--label ${LABELS}"
$ anaconda upload ${LABEL_OPTION} --force ${CONDA_FILE}

```
RECIPES_PATH：对应Conda包的recipes路径。
LABELS: Conda包的label，如：main(默认) 或者 cuda10.0等

### 方式二：

```shell
$ export CONDA_FILE=`conda build ${RECIPES_PATH} -c conda-forge -c defaults --output`
$ LABEL_OPTION="--label ${LABELS}"
$ anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME} ${LABEL_OPTION} --force ${CONDA_FILE}

```

LABELS: Conda包的label，如：main(默认) 或者 cuda10.0等

RECIPES_PATH：对应Conda包的recipes路径

CONDA_USERNAME: Anaconda Cloud的用户名

MY_UPLOAD_KEY: Anaconda Cloud的Token

获取Anaconda Cloud Token方式

- 登陆Anaconda Cloud(https://anaconda.org/)
- 点击右上角的用户名，跳转到设置
- 在左侧面板，跳转到访问，然后要求输入密码
- 现在，我们需要创建一个API Token。为其命名，并至少勾选允许对API站点的读取访问权限和允许对API站点的写入权限
- 创建Token并复制保存

### 方式三：
基于前面gtest的例子

```shell
anaconda login # 输入用户秘密
anaconda upload -u my_group build/linux-64/gtest-1.10.0-0.tar.bz2
```
