// SPDX-License-Identifier: MIT

package lang

import (
	"testing"

	"github.com/issue9/assert"

	"github.com/caixw/apidoc/v7/core"
)

func TestPHPDocBlock(t *testing.T) {
	a := assert.New(t)
	b := newPHPDocBlock()
	a.NotNil(b)

	// herodoc
	data := []byte(`<<<EOF
	xx
	xx
EOF
`)
	l, err := NewLexer(core.Block{Data: data}, nil)
	a.NotError(err).NotNil(l)
	a.True(b.BeginFunc(l))
	bb, ok := b.(*phpDocBlock)
	a.True(ok)
	a.Equal(bb.token1, "\nEOF\n").
		Equal(bb.token2, "\nEOF;\n").
		Equal(bb.doctype, phpHerodoc)
	data, ok = b.EndFunc(l)
	a.True(ok).
		Nil(data)

	// nowdoc
	data = []byte(`<<<'EOF'
	xx
	xx
EOF
`)
	l, err = NewLexer(core.Block{Data: data}, nil)
	a.NotError(err).NotNil(l)
	a.True(b.BeginFunc(l))
	bb, ok = b.(*phpDocBlock)
	a.True(ok)
	a.Equal(bb.token1, "\nEOF\n").
		Equal(bb.token2, "\nEOF;\n").
		Equal(bb.doctype, phpNowdoc)
	data, ok = b.EndFunc(l)
	a.True(ok).
		Nil(data)

	// nowdoc 验证结尾带分号的结束符
	data = []byte(`<<<'EOF'
	xx
	xx
EOF;
`)
	l, err = NewLexer(core.Block{Data: data}, nil)
	a.NotError(err).NotNil(l)
	a.True(b.BeginFunc(l))
	bb, ok = b.(*phpDocBlock)
	a.True(ok)
	a.Equal(bb.token1, "\nEOF\n").
		Equal(bb.token2, "\nEOF;\n").
		Equal(bb.doctype, phpNowdoc)
	data, ok = b.EndFunc(l)
	a.True(ok).
		Nil(data)

	// 开始符号错误
	data = []byte(`<<<
	xx
	xx
EOF;
`)
	l, err = NewLexer(core.Block{Data: data}, nil)
	a.NotError(err).NotNil(l)
	a.False(b.BeginFunc(l))

	// nowdoc 不存在结束符
	data = []byte(`<<<'EOF'
	xx
	xx
EO
`)
	l, err = NewLexer(core.Block{Data: data}, nil)
	a.NotError(err).NotNil(l)
	a.True(b.BeginFunc(l))
	bb, ok = b.(*phpDocBlock)
	a.True(ok)
	a.Equal(bb.token1, "\nEOF\n").
		Equal(bb.token2, "\nEOF;\n").
		Equal(bb.doctype, phpNowdoc)
	data, ok = b.EndFunc(l)
	a.False(ok)
}
