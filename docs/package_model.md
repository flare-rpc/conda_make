conda package 模板
====

前面`gtest`的例子，使用最简单的方式，尝试了conda build，在生产环境中，这种方式并不
能满足线上的要求。在生产环境中，一方面，软件的发布，需要按照规范发布，另一方面，为了简化
发布的操作，定义发布模板，简化操作。将分为两个部分，前半部分，介绍conda官方 package的
使用方式。后半部分，定义了一个发布模板。

官方文档地址[conda build](https://docs.conda.io/projects/conda-build/en/latest/resources/index.html)

# meta.yaml
在conda build过程中，所有的定义都在`meta.yaml`中，先看一个例子：

```yaml
{% set version = "1.1.0" %}

package:
  name: imagesize
  version: {{ version }}

source:
  url: https://pypi.io/packages/source/i/imagesize/imagesize-{{ version }}.tar.gz
  sha256: f3832918bc3c66617f92e35f5d70729187676313caa60c187eb0f28b8fe5e3b5

build:
  noarch: python
  number: 0
  script: python -m pip install --no-deps --ignore-installed .

requirements:
  host:
    - python
    - pip
  run:
    - python

test:
  imports:
    - imagesize

about:
  home: https://github.com/shibukawa/imagesize_py
  license: MIT
  summary: 'Getting image size from png/jpeg/jpeg2000/gif file'
  description: |
    This module analyzes jpeg/jpeg2000/png/gif image header and
    return image size.
  dev_url: https://github.com/shibukawa/imagesize_py
  doc_url: https://pypi.python.org/pypi/imagesize
  doc_source_url: https://github.com/shibukawa/imagesize_py/blob/master/README.rst
```
除了 `package/name`和 `package version`，所有部分都是可选的。

标题只能出现一次。如果它们出现多次，则只记住最后一次。例如，package: 标头在文件中应该只出现一次。

## package section
设定包信息

### package name
包的小写名称。它可以包含“-”，但不能包含空格。

```yaml
package:
  name: bsdiff4
```

### Package version
包的版本号。使用 PEP-386 verlib 约定。不能包含“-”。 YAML 
将版本号（例如 1.0）解释为浮点数，这意味着 0.10 将与 0.1 相同。
为避免这种情况，请将版本号放在引号中，以便将其解释为字符串。

```yaml
package:
  version: "1.1.4"
```
**note:**
在某些情况下，可能在构建包之前不知道包的版本、构建号或构建字符串。在这些情况下，
可以使用 [Templating with Jinja](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html#jinja-templates) 
或者 [Environment variables](https://docs.conda.io/projects/conda-build/en/latest/user-guide/environment-variables.html#git-env)以及
[Inherited environment variables](https://docs.conda.io/projects/conda-build/en/latest/user-guide/environment-variables.html#inherited-env-vars)。
后面会在模板部分介绍。

## source section

指定包的源代码来自何处。源代码可能来自 tarball 文件、git、hg 或 svn。
它可能是本地路径，并且可能包含补丁。

### Source from tarball or zip archive

```yaml
source:
  url: https://pypi.python.org/packages/source/b/bsdiff4/bsdiff4-1.1.4.tar.gz
  md5: 29f6089290505fc1a852e176bd276c43
  sha1: f0a2c9a30073449cfb7d171c57552f3109d93894
  sha256: 5a022ff4c1d1de87232b1c70bde50afbb98212fd246be4a867d8737173cf1f8f
```
如果提取的存档在其顶层仅包含 1 个文件夹，则其内容将向上移动 1 级，以便提取的包内容位于工作文件夹的根目录中。

### Source from git

```yaml
source:
  git_url: https://github.com/ilanschnell/bsdiff4.git
  git_rev: 1.1.4
  git_depth: 1 # (Defaults to -1/not shallow)
  ```

```yaml
source:
  git_url: ../
```
### Source from a local path

如果路径是相对的，则相对于脚本所在的目录。在构建之前将源复制到工作目录。

```yaml
source:
  path: ../src
```

## build section

### Build number and string

对于相同版本的新版本，版本号应递增。该数字默认为 0。构建字符串不能包含“-”。该字符串默认为默认 conda-build 字符串加上内部版本号。
```yaml
build:
  number: 1
  string: abc
```
当包受到 conda_build_config.yaml 文件中的一个或多个变量影响时，将出现一个哈希。散列由“使用”变量组成 - 如果使用任何东西，你就有一个散列。
如果您不使用这些变量，那么您将没有哈希。有一些特殊情况不会影响哈希，例如 Python 和 R 或任何已经在构建字符串中占有一席之地的东西。

如果任何依赖项都为真，则构建哈希将添加到构建字符串中：
- package 是 build、host 或 run deps 中的显式依赖项
- 包在 conda_build_config.yaml 中有一个匹配的条目，它是特定版本的引脚，而不是下限
- ignore_version 不会忽略该包
- 或者使用{{ compiler() }} jinja2

### Script

在配置文件直接使用脚本的内容替代`build.sh`或者`bld.bat`
```yaml
build:
  script: python setup.py install --single-version-externally-managed --record=record.txt
  ```
## requirements section

## Test section

## Outputs section

## about section

## App section

