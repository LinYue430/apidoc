<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="./locales.xsl" />
<xsl:output
    method="html"
    encoding="utf-8"
    indent="yes"
    version="5.0"
    doctype-system="about:legacy-compat"
/>

<xsl:template match="/">
<html lang="{$curr-lang}">
    <head>
        <title><xsl:value-of select="apidoc/title" /></title>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1" />
        <meta name="generator" content="apidoc" />
        <link rel="icon" type="image/svg+xml" href="{$icon}" />
        <link rel="mask-icon" type="image/svg+xml" href="{$icon}" color="black" />
        <xsl:if test="apidoc/license"><link rel="license" href="{apidoc/license/@url}" /></xsl:if>
        <link rel="stylesheet" type="text/css" href="{$base-url}apidoc.css" />
        <script src="{$base-url}apidoc.js" />
    </head>
    <body>
        <xsl:call-template name="header" />

        <main>
            <div class="content" data-type="{description/@type}">
                <pre><xsl:copy-of select="apidoc/description/node()" /></pre>
            </div>
            <div class="servers"><xsl:apply-templates select="apidoc/server" /></div>
            <xsl:apply-templates select="apidoc/api" />
        </main>

        <footer>
        <div class="wrap">
            <p><xsl:copy-of select="$locale-generator" /></p>
        </div>
        <a href="#" class="goto-top" title="{$locale-goto-top}" aria-label="{$locale-goto-top}" />
        </footer>
    </body>
</html>
</xsl:template>


<xsl:template match="/apidoc/server">
<div class="server">
    <h4>
        <xsl:call-template name="deprecated">
            <xsl:with-param name="deprecated" select="@deprecated" />
        </xsl:call-template>
        <xsl:value-of select="@name" />
    </h4>

    <p><xsl:value-of select="@url" /></p>
    <div>
        <xsl:choose>
            <xsl:when test="description">
                <xsl:attribute name="data-type">
                    <xsl:value-of select="description/@type" />
                </xsl:attribute>
                <pre><xsl:copy-of select="description/node()" /></pre>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="@summary" /></xsl:otherwise>
        </xsl:choose>
    </div>
</div>
</xsl:template>


<!-- header 界面元素 -->
<xsl:template name="header">
<header>
<div class="wrap">
    <h1>
        <img alt="logo" src="{$icon}" />
        <xsl:value-of select="/apidoc/title" />
        <span class="version">&#160;(<xsl:value-of select="/apidoc/@version" />)</span>
    </h1>

    <div class="menus">
        <!-- expand -->
        <label class="menu expand-selector" role="checkbox">
            <input type="checkbox" /><xsl:copy-of select="$locale-expand" />
        </label>

        <!-- server -->
        <xsl:if test="apidoc/server">
        <div class="menu server-selector" role="menu" aria-haspopup="true">
            <xsl:copy-of select="$locale-server" />
            <span aria-hiddren="true">&#160;&#x25bc;</span>
            <ul role="menu" aria-hiddren="true">
                <xsl:for-each select="apidoc/server">
                <li data-server="{@name}" role="menuitemcheckbox">
                    <label>
                        <input type="checkbox" checked="checked" />&#160;<xsl:value-of select="@name" />
                    </label>
                </li>
                </xsl:for-each>
            </ul>
        </div>
        </xsl:if>

        <!-- tag -->
        <xsl:if test="apidoc/tag">
        <div class="menu tag-selector" role="menu" aria-haspopup="true">
            <xsl:copy-of select="$locale-tag" />
            <span aria-hiddren="true">&#160;&#x25bc;</span>
            <ul role="menu" aria-hiddren="true">
                <li data-tag="" role="menuitemcheckbox">
                    <label>
                        <input type="checkbox" checked="checked" />&#160;<xsl:copy-of select="$locale-uncategorized" />
                    </label>
                </li>
                <xsl:for-each select="apidoc/tag">
                <li data-tag="{@name}" role="menuitemcheckbox">
                    <label>
                        <input type="checkbox" checked="checked" />&#160;<xsl:value-of select="@title" />
                    </label>
                </li>
                </xsl:for-each>
            </ul>
        </div>
        </xsl:if>

        <!-- method -->
        <div class="menu method-selector" role="menu" aria-haspopup="true">
            <xsl:copy-of select="$locale-method" />
            <span aria-hiddren="true">&#160;&#x25bc;</span>
            <ul role="menu" aria-hiddren="true">
                <!-- 浏览器好像都不支持 xpath 2.0，所以无法使用 distinct-values -->
                <!-- xsl:for-each select="distinct-values(/apidoc/api/@method)" -->
                <xsl:for-each select="/apidoc/api/@method[not(../preceding-sibling::api/@method = .)]">
                <li data-method="{.}" role="menuitemcheckbox">
                    <label><input type="checkbox" checked="checked" />&#160;<xsl:value-of select="." /></label>
                </li>
                </xsl:for-each>
            </ul>
        </div>

        <!-- language -->
        <div class="menu languages-selector" role="menu" aria-haspopup="true">
            <xsl:copy-of select="$locale-language" />
            <span aria-hiddren="true">&#160;&#x25bc;</span>
            <ul role="menu" aria-hiddren="true"><xsl:call-template name="languages" /></ul>
        </div>
    </div> <!-- end .menus -->
</div> <!-- end .wrap -->
</header>
</xsl:template>


<!-- api 界面元素 -->
<xsl:template match="/apidoc/api">
<xsl:variable name="id" select="concat(server, @method, translate(path/@path, $id-from, $id-to))" />

<details id="{$id}" class="api" data-method="{@method}">
<xsl:attribute name="data-tag">
    <xsl:for-each select="tag"><!-- NOTE: 如果是 xsl 2.0 可以直接使用 string-join 函数 -->
        <xsl:value-of select="." /><xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>
</xsl:attribute>
<xsl:attribute name="data-server">
    <xsl:for-each select="server">
        <xsl:value-of select="." /><xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>
</xsl:attribute>

    <!-- 
    bug: 将 summary 作为 flex 容器在 safari 会出错。
    https://bugs.webkit.org/show_bug.cgi?id=190065
    -->
    <summary>
        <div class="action">
            <a class="link" href="#{$id}">&#128279;</a> <!-- 链接符号 -->

            <span class="method"><xsl:value-of select="@method" /></span>
            <span>
                <xsl:call-template name="deprecated">
                    <xsl:with-param name="deprecated" select="@deprecated" />
                </xsl:call-template>

                <xsl:value-of select="path/@path" />
            </span>
        </div>

        <div class="right">
            <span class="srv">
                <xsl:for-each select="server">
                    <xsl:value-of select="." /><xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
            </span>

            <span class="summary"><xsl:value-of select="@summary" /></span>
        </div>
    </summary>

    <xsl:if test="description">
        <div class="description" data-type="{description/@type}">
            <pre><xsl:copy-of select="description/node()" /></pre>
        </div>
    </xsl:if>

    <div class="body">
        <div class="requests">
            <h4 class="header"><xsl:copy-of select="$locale-request" /></h4>
            <xsl:call-template name="requests">
                <xsl:with-param name="requests" select="request" />
                <xsl:with-param name="path" select="path" />
                <xsl:with-param name="headers" select="header | /apidoc/header" />
            </xsl:call-template>
        </div>
        <div class="responses">
            <h4 class="header"><xsl:copy-of select="$locale-response" /></h4>
            <xsl:call-template name="responses">
                <xsl:with-param name="responses" select="response | /apidoc/response" />
            </xsl:call-template>
        </div>
    </div>

    <xsl:if test="./callback"><xsl:apply-templates select="./callback" /></xsl:if>
</details>
</xsl:template>


<!-- 回调内容 -->
<xsl:template match="/apidoc/api/callback">
<div class="callback" data-method="{./@method}">
    <h3>
        <xsl:copy-of select="$locale-callback" />
        <span class="summary"><xsl:value-of select="@summary" /></span>
    </h3>
    <xsl:if test="description">
        <div class="description" data-type="{description/@type}">
            <pre><xsl:copy-of select="description/node()" /></pre>
        </div>
    </xsl:if>

    <div class="body">
        <div class="requests">
            <h4 class="header"><xsl:copy-of select="$locale-request" /></h4>
            <xsl:call-template name="requests">
                <xsl:with-param name="requests" select="request" />
                <xsl:with-param name="path" select="path" />
                <xsl:with-param name="headers" select="header" />
            </xsl:call-template>
        </div>

        <xsl:if test="response">
            <div class="responses">
                <h4 class="header"><xsl:copy-of select="$locale-response" /></h4>
                <xsl:call-template name="responses">
                    <xsl:with-param name="responses" select="response" />
                </xsl:call-template>
            </div>
        </xsl:if>
    </div> <!-- end .body -->
</div> <!-- end .callback -->
</xsl:template>


<!-- api/request 的界面元素 -->
<xsl:template name="requests">
<xsl:param name="requests" />
<xsl:param name="path" />
<xsl:param name="headers" /> <!-- 公用的报头 -->
<xsl:if test="$path/param">
    <xsl:call-template name="param">
        <xsl:with-param name="title">
            <xsl:copy-of select="$locale-path-param" />
        </xsl:with-param>
        <xsl:with-param name="param" select="$path/param" />
        <xsl:with-param name="simple" select="'true'" />
    </xsl:call-template>
</xsl:if>

<xsl:if test="$path/query">
    <xsl:call-template name="param">
        <xsl:with-param name="title">
            <xsl:copy-of select="$locale-query" />
        </xsl:with-param>
        <xsl:with-param name="param" select="$path/query" />
        <xsl:with-param name="simple" select="'true'" />
    </xsl:call-template>
</xsl:if>

<xsl:if test="$headers">
    <xsl:call-template name="param">
        <xsl:with-param name="title">
            <xsl:copy-of select="$locale-header" />
        </xsl:with-param>
        <xsl:with-param name="param" select="$headers" />
        <xsl:with-param name="simple" select="'true'" />
    </xsl:call-template>
</xsl:if>

<xsl:variable name="request-any" select="$requests[not(@mimetype)]" />
<xsl:for-each select="/apidoc/mimetype | $requests/@mimetype[not(/apidoc/mimetype=.)]">
    <xsl:variable name="mimetype" select="." />
    <xsl:variable name="request" select="$requests[@mimetype=$mimetype]" />
    <xsl:if test="$request">
        <xsl:call-template name="request-body">
            <xsl:with-param name="mimetype" select="$mimetype" />
            <xsl:with-param name="request" select="$request" />
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="not($request) and $request-any">
        <xsl:call-template name="request-body">
            <xsl:with-param name="mimetype" select="$mimetype" />
            <xsl:with-param name="request" select="$request-any" />
        </xsl:call-template>
    </xsl:if>
</xsl:for-each>
</xsl:template>


<xsl:template name="request-body">
<xsl:param name="mimetype" />
<xsl:param name="request" />
<details>
    <summary><xsl:value-of select="$mimetype" /></summary>
    <xsl:call-template name="top-param">
        <xsl:with-param name="mimetype" select="$mimetype" />
        <xsl:with-param name="param" select="$request" />
    </xsl:call-template>
</details>
</xsl:template>

<xsl:template name="responses">
<xsl:param name="responses" />
<xsl:for-each select="/apidoc/mimetype | $responses/@mimetype[not(/apidoc/mimetype=.)]">
    <xsl:variable name="mimetype" select="." />
    <xsl:if test="$responses[@mimetype=$mimetype] | $responses[not(@mimetype)]">
        <details>
        <summary><xsl:value-of select="$mimetype" /></summary>
        <xsl:for-each select="$responses">
            <xsl:variable name="resp" select="current()[@mimetype=$mimetype]" />
            <xsl:variable name="resp-any" select="current()[not(@mimetype)]" />
            <xsl:if test="$resp"><!-- 可能同时存在符合 resp 和 resp-any 的数据，优先取 resp -->
                <xsl:call-template name="response">
                    <xsl:with-param name="response" select="$resp" />
                    <xsl:with-param name="mimetype" select="$mimetype" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="not($resp) and $resp-any">
                <xsl:call-template name="response">
                    <xsl:with-param name="response" select="$resp-any" />
                    <xsl:with-param name="mimetype" select="$mimetype" />
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
        </details>
    </xsl:if>
</xsl:for-each>
</xsl:template>


<!-- api/response 的界面 -->
<xsl:template name="response">
<xsl:param name="response" />
<xsl:param name="mimetype" />

<h5 class="status"><xsl:value-of select="$response/@status" /></h5>
<div>
<xsl:choose>
    <xsl:when test="$response/description">
        <xsl:attribute name="data-type">
            <xsl:value-of select="$response/description/@type" />
        </xsl:attribute>
        <pre><xsl:copy-of select="$response/description/node()" /></pre>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$response/@summary" /></xsl:otherwise>
</xsl:choose>
</div>
<xsl:call-template name="top-param">
    <xsl:with-param name="mimetype" select="$mimetype" />
    <xsl:with-param name="param" select="$response" />
</xsl:call-template>
</xsl:template>

<!-- request 和 response 参数的顶层元素调用模板 -->
<xsl:template name="top-param">
<xsl:param name="mimetype" />
<xsl:param name="param" />
<xsl:if test="$param/header">
    <xsl:call-template name="param">
        <xsl:with-param name="title">
            <xsl:copy-of select="$locale-header" />
        </xsl:with-param>
        <xsl:with-param name="param" select="$param/header" />
        <xsl:with-param name="simple" select="'true'" />
    </xsl:call-template>
</xsl:if>


<xsl:call-template name="param">
    <xsl:with-param name="title"><xsl:copy-of select="$locale-body" /></xsl:with-param>
    <xsl:with-param name="param" select="$param" />
</xsl:call-template>

<xsl:if test="$param/example">
    <h4 class="title">&#x27a4;&#160;<xsl:copy-of select="$locale-example" /></h4>
    <xsl:for-each select="$param/example">
        <xsl:if test="not(@mimetype) or @mimetype=$mimetype">
            <pre class="example"><xsl:copy-of select="node()" /></pre>
        </xsl:if>
    </xsl:for-each>
</xsl:if>
</xsl:template>


<!-- path param, path query, header 等的界面 -->
<xsl:template name="param">
<xsl:param name="title" />
<xsl:param name="param" />
<xsl:param name="simple" select="'false'" /> <!-- 简单的类型，不存在嵌套类型，也不会有示例代码 -->

<xsl:if test="$param/@type">
    <div class="param">
        <h4 class="title">&#x27a4;&#160;<xsl:copy-of select="$title" /></h4>

        <table class="param-list">
            <thead>
                <tr>
                    <th><xsl:copy-of select="$locale-var" /></th>
                    <th><xsl:copy-of select="$locale-type" /></th>
                    <th><xsl:copy-of select="$locale-value" /></th>
                    <th><xsl:copy-of select="$locale-description" /></th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="$simple='true'">
                        <xsl:call-template name="simple-param-list">
                            <xsl:with-param name="param" select="$param" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="param-list">
                            <xsl:with-param name="param" select="$param" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
    </div>
</xsl:if>
</xsl:template>


<!-- 列顺序必须要与 param 中的相同 -->
<xsl:template name="simple-param-list">
<xsl:param name="param" />

<xsl:for-each select="$param">
    <xsl:call-template name="param-list-tr">
        <xsl:with-param name="param" select="." />
    </xsl:call-template>
</xsl:for-each>
</xsl:template>

<!-- 列顺序必须要与 param 中的相同 -->
<xsl:template name="param-list">
<xsl:param name="param" />
<xsl:param name="parent" select="''" /> <!-- 上一级的名称，嵌套对象时可用 -->

<xsl:for-each select="$param">
    <xsl:call-template name="param-list-tr">
        <xsl:with-param name="param" select="." />
        <xsl:with-param name="parent" select="$parent" />
    </xsl:call-template>

    <xsl:if test="param">
        <xsl:variable name="p">
                <xsl:value-of select="concat($parent, @name)" />
                <xsl:if test="@name"><xsl:value-of select="'.'" /></xsl:if>
        </xsl:variable>

        <xsl:call-template name="param-list">
            <xsl:with-param name="param" select="param" />
            <xsl:with-param name="parent" select="$p" />
        </xsl:call-template>
    </xsl:if>
</xsl:for-each>
</xsl:template>


<!-- 显示一行参数数据 -->
<xsl:template name="param-list-tr">
<xsl:param name="param" />
<xsl:param name="parent" select="''" />
<tr>
    <xsl:call-template name="deprecated">
        <xsl:with-param name="deprecated" select="$param/@deprecated" />
    </xsl:call-template>
    <th>
        <span class="parent-type"><xsl:value-of select="$parent" /></span>
        <xsl:value-of select="$param/@name" />
    </th>

    <td>
        <xsl:value-of select="$param/@type" />
        <xsl:if test="$param/@array='true'"><xsl:value-of select="'[]'" /></xsl:if>
    </td>

    <td>
        <xsl:choose>
            <xsl:when test="$param/@optional='true'"><xsl:value-of select="'O'" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="'R'" /></xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="concat(' ', $param/@default)" />
    </td>

    <td>
        <xsl:choose>
            <xsl:when test="description">
                <xsl:attribute name="data-type">
                    <xsl:value-of select="description/@type" />
                </xsl:attribute>
                <pre><xsl:copy-of select="description/node()" /></pre>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="@summary" /></xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="enum">
            <xsl:with-param name="enum" select="$param/enum"/>
        </xsl:call-template>
    </td>
</tr>
</xsl:template>


<!-- 显示枚举类型的内容 -->
<xsl:template name="enum">
<xsl:param name="enum" />
<xsl:if test="$enum">
    <p><xsl:copy-of select="$locale-enum" /></p>
    <ul>
    <xsl:for-each select="$enum">
        <li>
        <xsl:call-template name="deprecated">
            <xsl:with-param name="deprecated" select="@deprecated" />
        </xsl:call-template>

        <xsl:value-of select="@value" />:
        <xsl:choose>
            <xsl:when test="description">
                <div data-type="{description/@type}">
                    <pre><xsl:copy-of select="description/node()" /></pre>
                </div>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="summary" /></xsl:otherwise>
        </xsl:choose>
        </li>
    </xsl:for-each>
    </ul>
</xsl:if>
</xsl:template>


<!--
给指定的元素添加已弃用的标记

该模板会给父元素添加 class 和 title 属性，
所以必须要在父元素的任何子元素之前，否则 chrome 和 safari 可能无法正常解析。
-->
<xsl:template name="deprecated">
<xsl:param name="deprecated" />
<xsl:if test="$deprecated">
    <xsl:attribute name="class"><xsl:value-of select="'del'" /></xsl:attribute>
    <xsl:attribute name="title">
        <xsl:value-of select="$deprecated" />
    </xsl:attribute>
</xsl:if>
</xsl:template>

<!-- 用于将 API 地址转换成合法的 ID 标记 -->
<xsl:variable name="id-from" select="'{}/'" />
<xsl:variable name="id-to" select="'__-'" />

<!-- 根据情况获取相应的图标 -->
<xsl:variable name="icon">
    <xsl:choose>
        <xsl:when test="/apidoc/@logo">
            <xsl:value-of select="/apidoc/@logo" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat($base-url, '../icon.svg')" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<!--
获取相对于当前 xsl 文件的基地址
xsl 2.0 可以直接采用 base-uri(document(''))
-->
<xsl:variable name="base-url">
    <xsl:apply-templates select="processing-instruction('xml-stylesheet')" />
</xsl:variable>

<xsl:template match="processing-instruction('xml-stylesheet')[1]">
    <xsl:variable name="v1" select="substring-after(., 'href=&quot;')" />
    <!-- NOTE: 此处假定当前文件叫作 apidoc.xsl，如果不是的话，需要另外处理此代码 -->
    <xsl:variable name="v2" select="substring-before($v1, 'apidoc.xsl&quot;')" />
    <xsl:value-of select="$v2" />
</xsl:template>

</xsl:stylesheet>
