// SPDX-License-Identifier: MIT

package lsp

import (
	"path/filepath"
	"strings"

	"github.com/caixw/apidoc/v7/build"
	"github.com/caixw/apidoc/v7/core"
	"github.com/caixw/apidoc/v7/internal/ast"
	"github.com/caixw/apidoc/v7/internal/lsp/protocol"
)

// 表示项目文件夹
type folder struct {
	protocol.WorkspaceFolder
	doc *ast.APIDoc
	h   *core.MessageHandler
	cfg *build.Config
}

func (f *folder) close() error {
	f.h.Stop()
	return nil
}

// uri 是否与属于项目匹配
func (f *folder) matchURI(uri core.URI) bool {
	return strings.HasPrefix(string(uri), string(f.URI))
}

func (f *folder) matchPosition(uri core.URI, pos core.Position) (bool, error) {
	var r core.Range
	if f.URI == uri {
		r = f.doc.Range
	} else {
		for _, api := range f.doc.Apis {
			if api.URI == uri {
				r = api.Range
				break
			}
		}
	}
	if r.IsEmpty() {
		return false, nil
	}

	return r.Contains(pos), nil
}

func (f *folder) openFile(uri core.URI) error {
	file, err := uri.File()
	if err != nil {
		return err
	}

	var input *build.Input
	ext := filepath.Ext(file)
	for _, i := range f.cfg.Inputs {
		if inStringSlice(i.Exts, ext) {
			input = i
			break
		}
	}
	if input == nil { // 无需解析
		return nil
	}

	f.parseFile(uri, input)
	return nil
}

// 分析 path 的内容，并将其中的文档解析至 doc
func (f *folder) parseFile(uri core.URI, i *build.Input) {
	f.doc.ParseBlocks(f.h, func(blocks chan core.Block) {
		i.ParseFile(blocks, f.h, uri)
	})
}

func (f *folder) closeFile(uri core.URI) error {
	f.doc.DeleteURI(uri)
	return nil
}

func (f *folder) messageHandler(msg *core.Message) {
	switch msg.Type {
	case core.Erro:
		// TODO
	case core.Warn:
		// TODO
	case core.Succ, core.Info: // 仅处理错误和警告
	default:
		panic("unreached")
	}
}

func (s *server) appendFolders(folders ...protocol.WorkspaceFolder) (err error) {
	for _, f := range folders {
		ff := &folder{
			WorkspaceFolder: f,
			doc:             &ast.APIDoc{},
		}

		ff.h = core.NewMessageHandler(ff.messageHandler)
		ff.cfg = build.LoadConfig(ff.h, f.URI)
		if ff.cfg == nil {
			if ff.cfg, err = build.DetectConfig(f.URI, true); err != nil {
				return err
			}
		}

		s.folders = append(s.folders, ff)
	}

	return nil
}

func (s *server) getMatchFolder(uri core.URI) *folder {
	for _, f := range s.folders {
		if f.matchURI(uri) {
			return f
		}
	}
	return nil
}

func inStringSlice(slice []string, key string) bool {
	for _, v := range slice {
		if v == key {
			return true
		}
	}
	return false
}
