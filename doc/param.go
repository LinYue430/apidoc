// SPDX-License-Identifier: MIT

package doc

import (
	"encoding/xml"
	"sort"

	"github.com/caixw/apidoc/v5/internal/locale"
)

// Param 表示参数类型
//  <param name="user" deprecated="1.1.1" type="object" array="true">
//      <param name="name" type="string" />
//      <param name="sex" type="string">
//          <enum value="male">Male</enum>
//          <enum value="female">Female</enum>
//      </param>
//      <param name="age" type="number" />
//  </param>
type Param struct {
	Name        string   `xml:"name,attr"`
	Type        Type     `xml:"type,attr"`
	Deprecated  Version  `xml:"deprecated,attr,omitempty"`
	Default     string   `xml:"default,attr,omitempty"`
	Required    bool     `xml:"required,attr,omitempty"`
	Array       bool     `xml:"array,attr,omitempty"`
	Items       []*Param `xml:"param,omitempty"`
	Reference   string   `xml:"ref,attr,omitempty"`
	Summary     string   `xml:"summary,attr,omitempty"`
	Enums       []*Enum  `xml:"enum,omitempty"`
	Description string   `xml:"description,omitempty"`
}

// IsEnum 是否为一个枚举类型
func (p *Param) IsEnum() bool {
	return len(p.Enums) > 0
}

type shadowParam Param

// UnmarshalXML xml.Unmarshaler
func (p *Param) UnmarshalXML(d *xml.Decoder, start xml.StartElement) error {
	field := "/" + start.Name.Local
	shadow := (*shadowParam)(p)
	if err := d.DecodeElement(shadow, &start); err != nil {
		return fixedSyntaxError(err, "", field, 0)
	}

	if shadow.Name == "" {
		return newSyntaxError(field+"#name", locale.ErrRequired)
	}

	if shadow.Type == None {
		return newSyntaxError(field+"#type", locale.ErrRequired)
	}
	if shadow.Type == Object && len(shadow.Items) == 0 {
		return newSyntaxError(field+"/items", locale.ErrRequired)
	}

	// 判断 enums 的值是否相同
	if key := getDuplicateEnum(shadow.Enums); key != "" {
		return newSyntaxError(field+"/enum", locale.ErrDuplicateValue)
	}

	// 判断 items 的值是否相同
	if key := getDuplicateItems(shadow.Items); key != "" {
		return newSyntaxError(field+"/items", locale.ErrDuplicateValue)
	}

	return nil
}

// 返回重复枚举的值
func getDuplicateEnum(enums []*Enum) string {
	if len(enums) == 0 {
		return ""
	}

	es := make([]string, 0, len(enums))
	for _, e := range enums {
		es = append(es, e.Value)
	}
	sort.SliceStable(es, func(i, j int) bool { return es[i] > es[j] })

	for i := 1; i < len(es); i++ {
		if es[i] == es[i-1] {
			return es[i]
		}
	}

	return ""
}

func getDuplicateItems(items []*Param) string {
	if len(items) == 0 {
		return ""
	}

	es := make([]string, 0, len(items))
	for _, e := range items {
		es = append(es, e.Name)
	}
	sort.SliceStable(es, func(i, j int) bool { return es[i] > es[j] })

	for i := 1; i < len(es); i++ {
		if es[i] == es[i-1] {
			return es[i]
		}
	}

	return ""
}