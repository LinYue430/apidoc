# 如何为 apidoc 贡献代码

apidoc 是一个基于 [MIT](https://opensource.org/licenses/MIT) 的开源软件。
欢迎大家共同参与开发。**若需要新功能，请先开 issue 讨论。**

## 本地化

本地化包含以下几个部分：

- `internal/locale` 主要包含了程序内各种语法错误以及命令行的提示信息；
- `docs/vx/locales.xsl` 包含展示界面中的本化元素；`vx` 表示版本信息，比如 `v5`、`v6` 等；
- `docs/index.*.xml` <https://apidoc.tools> 网站的内容，* 表示语言 ID；

## 文档

可以通过 `apidoc static -docs=xxx` 将 docs 作为一个本地的 web 服务，方便 XSL 相关功能的调试；

文档应该尽可能的保证在非 Javascript 环境下，也有基本的功能。

## 添加新编程语言支持

`internal/lang/lang.go` 文件中有所有语言模型的定义，在该文件中有详细的文档说明如何定义语言模型。若需要添加对新语言的支持，提交并更新 [#11](https://github.com/caixw/apidoc/issues/11)

## Git

Git 的编写规则参照 <https://www.conventionalcommits.org/zh-hans/>，
scope 值可直接写包名，或是文件名，比如 `internal/mock`、`README.md`。
