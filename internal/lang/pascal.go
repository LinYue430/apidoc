// SPDX-License-Identifier: MIT

package lang

// 描述了 pascal/delphi 语言的字符串，在 pascal 中
// 转义字符即引号本身，不适合直接在 block 中定义。
type pascalStringBlock struct {
	symbol string
	escape string
}

func newPascalStringBlock(symbol byte) blocker {
	s := string(symbol)
	return &pascalStringBlock{
		symbol: s,
		escape: s + s,
	}
}

func (b *pascalStringBlock) beginFunc(l *parser) bool {
	return l.Match(b.symbol)
}

func (b *pascalStringBlock) endFunc(l *parser) (data []byte, ok bool) {
	for {
		switch {
		case l.AtEOF():
			return nil, false
		case l.Match(b.escape): // 转义
			break
		case l.Match(b.symbol): // 结束
			return nil, true
		default:
			l.Next(1)
		}
	} // end for
}
