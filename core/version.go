// SPDX-License-Identifier: MIT

package core

// Version 程序的版本号
//
// 遵守 https://semver.org/lang/zh-CN/ 规则。
// 程序不兼容或是文档格式不兼容时，需要提升主版本号。
const Version = "7.0.0"

var (
	fullVersion = Version
	buildDate   string
	commitHash  string
)

func init() {
	if buildDate != "" {
		fullVersion = Version + "+" + buildDate
	}

	if commitHash != "" {
		fullVersion += "." + commitHash
	}
}

// FullVersion 完整的版本号
func FullVersion() string {
	return fullVersion
}