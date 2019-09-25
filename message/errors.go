// SPDX-License-Identifier: MIT

package message

import (
	"strconv"

	"golang.org/x/text/message"

	"github.com/caixw/apidoc/v5/internal/locale"
)

// SyntaxError 表示语法错误信息
//
// 无论是配置文件的错误，还是文档的语法错误，都将返回此错误。
// apidoc 的错误基本上都是基于 SyntaxError。
type SyntaxError struct {
	Message string
	File    string

	// 行号和字段二选一，构成语法错误的最终定位信息。
	Line  int
	Field string
}

func (err *SyntaxError) Error() string {
	detail := err.Field
	if detail == "" {
		detail = strconv.Itoa(err.Line)
	}

	// ErrMessage = "%s 位次于 %s:%d"
	return locale.Sprintf(locale.ErrMessage, err.Message, err.File, detail)
}

// NewLocaleError 本地化的错误信息
//
// 其中的 msg 和 val 会被转换成本地化的内容保存。
func NewLocaleError(file, field string, line int, msg message.Reference, val ...interface{}) *SyntaxError {
	return &SyntaxError{
		Message: locale.Sprintf(msg, val...),
		File:    file,
		Line:    line,
		Field:   field,
	}
}

// WithError 声明 SyntaxError 实例，其中的提示信息由 err 返回
func WithError(file, field string, line int, err error) *SyntaxError {
	return &SyntaxError{
		Message: err.Error(),
		File:    file,
		Line:    line,
		Field:   field,
	}
}
