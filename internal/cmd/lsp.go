// SPDX-License-Identifier: MIT

package cmd

import (
	"flag"
	"fmt"
	"io"
	"log"

	"github.com/caixw/apidoc/v6"
	"github.com/caixw/apidoc/v6/internal/locale"
)

var lspFlagSet *flag.FlagSet

var lspPort string
var lspMode string

func initLSP() {
	lspFlagSet = command.New("lsp", doLSP, lspUsage)
	lspFlagSet.StringVar(&lspPort, "p", ":8080", locale.Sprintf(locale.FlagLSPPortUsage))
	lspFlagSet.StringVar(&lspMode, "m", "http", locale.Sprintf(locale.FlagLSPModeUsage))
}

func doLSP(io.Writer) error {
	return apidoc.ServeLSP(lspMode, lspPort, log.New(erroOut, "", 0))
}

func lspUsage(w io.Writer) error {
	_, err := fmt.Fprintln(w, locale.Sprintf(locale.CmdLSPUsage, getFlagSetUsage(lspFlagSet)))
	return err
}
