// SPDX-License-Identifier: MIT

package cmd

import (
	"fmt"
	"io"
	"strings"

	"github.com/caixw/apidoc/v5/internal/locale"
)

func init() {
	command.New("locale", doLocale, localeUsage)
}

func doLocale(w io.Writer) error {
	tail := 3

	locales := make(map[string]string, len(locale.DisplayNames()))

	// 计算各列的最大长度值
	var maxID int
	for k, v := range locale.DisplayNames() {
		id := k.String()
		calcMaxWidth(id, &maxID)
		locales[id] = v
	}
	maxID += tail

	for k, v := range locales {
		id := k + strings.Repeat(" ", maxID-len(k))
		printLine(w, infoColor, id, v)
	}

	return nil
}

func localeUsage(w io.Writer) error {
	_, err := fmt.Fprintln(w, locale.Sprintf(locale.CmdLocaleUsage))
	return err
}
