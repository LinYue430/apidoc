// SPDX-License-Identifier: MIT

package protocol

// 表示 InitializeParams.Trace 的枚举值
const (
	InitializeTraceOff      = "off"
	InitializeTraceMessages = "messages"
	InitializeTraceVerbose  = "verbose"
)

// SymbolKind A symbol kind.
type SymbolKind int

// SymbolKind 的各类枚举值
const (
	SymbolKindFile SymbolKind = iota + 1
	SymbolKindModule
	SymbolKindNamespace
	SymbolKindPackage
	SymbolKindClass
	SymbolKindMethod
	SymbolKindProperty
	SymbolKindField
	SymbolKindConstructor
	SymbolKindEnum
	SymbolKindInterface
	SymbolKindFunction
	SymbolKindVariable
	SymbolKindConstant
	SymbolKindString
	SymbolKindNumber
	SymbolKindBoolean
	SymbolKindArray
	SymbolKindObject
	SymbolKindKey
	SymbolKindNull
	SymbolKindEnumMember
	SymbolKindStruct
	SymbolKindEvent
	SymbolKindOperator
	SymbolKindTypeParameter
)

// ResourceOperationKind the kind of resource operations supported by the client.
type ResourceOperationKind string

const (
	// ResourceOperationKindCreate supports creating new files and folders.
	ResourceOperationKindCreate ResourceOperationKind = "create"

	// ResourceOperationKindRename supports renaming existing files and folders.
	ResourceOperationKindRename ResourceOperationKind = "rename"

	// ResourceOperationKindDelete supports deleting existing files and folders.
	ResourceOperationKindDelete ResourceOperationKind = "delete"
)

type FailureHandlingKind string

const (

	// FailureHandlingKindAbort applying the workspace change is simply aborted
	// if one of the changes provided fails.
	// All operations executed before the failing operation stay executed.
	FailureHandlingKindAbort FailureHandlingKind = "abort"

	// FailureHandlingKindTransactional all operations are executed transactionally.
	// That means they either all succeed or no changes at all are applied to the workspace.
	FailureHandlingKindTransactional FailureHandlingKind = "transactional"

	// FailureHandlingKindTextOnlyTransactional if the workspace edit contains only textual file changes they are executed transactionally.
	// If resource changes (create, rename or delete file) are part of the change the failure
	// handling strategy is abort.
	FailureHandlingKindTextOnlyTransactional FailureHandlingKind = "textOnlyTransactional"

	// FailureHandlingKindUndo The client tries to undo the operations already executed.
	// But there is no guarantee that this succeeds.
	FailureHandlingKindUndo FailureHandlingKind = "undo"
)

// CodeActionKind the kind of a code action.
//
// Kinds are a hierarchical list of identifiers separated by `.`, e.g. `"refactor.extract.function"`.
//
// The set of kinds is open and client needs to announce the kinds it supports to the server during
// initialization.
type CodeActionKind string

// A set of predefined code action kinds
const (
	// Empty kind.
	CodeActionKindEmpty CodeActionKind = ""

	// Base kind for quickfix actions: "quickfix"
	CodeActionKinQuickFix CodeActionKind = "quickfix"

	// Base kind for refactoring actions: "refactor"
	CodeActionKinRefactor CodeActionKind = "refactor"

	// Base kind for refactoring extraction actions: "refactor.extract"
	//
	// Example extract actions:
	//
	// - Extract method
	// - Extract function
	// - Extract variable
	// - Extract interface from class
	// - ...
	CodeActionKinRefactorExtract CodeActionKind = "refactor.extract"

	// Base kind for refactoring inline actions: "refactor.inline"
	//
	// Example inline actions:
	//
	// - Inline function
	// - Inline variable
	// - Inline constant
	// - ...
	CodeActionKinRefactorInline CodeActionKind = "refactor.inline"

	// Base kind for refactoring rewrite actions: "refactor.rewrite"
	//
	// Example rewrite actions:
	//
	// - Convert JavaScript function to class
	// - Add or remove parameter
	// - Encapsulate field
	// - Make method static
	// - Move method to base class
	// - ...
	CodeActionKinRefactorRewrite CodeActionKind = "refactor.rewrite"

	// Base kind for source actions: `source`
	//
	// Source code actions apply to the entire file.
	CodeActionKinSource CodeActionKind = "source"

	// Base kind for an organize imports source action: `source.organizeImports`
	CodeActionKinSourceOrganizeImports CodeActionKind = "source.organizeImports"
)

// MarkupKind describes the content type that a client supports in various
// result literals like `Hover`, `ParameterInfo` or `CompletionItem`.
//
// Please note that `MarkupKinds` must not start with a `$`. This kinds
// are reserved for internal usage.
type MarkupKind string

const (
	// MarkupKindPlainText plain text is supported as a content format
	MarkupKindPlainText MarkupKind = "plaintext"

	// MarkupKinMarkdown markdown is supported as a content format
	MarkupKinMarkdown MarkupKind = "markdown"
)

// CompletionItemKind the kind of a completion entry.
type CompletionItemKind int

// CompletionItemKind 的各类枚举值
const (
	CompletionItemKindText CompletionItemKind = iota + 1
	CompletionItemKindMethod
	CompletionItemKindFunction
	CompletionItemKindConstructor
	CompletionItemKindField
	CompletionItemKindVariable
	CompletionItemKindClass
	CompletionItemKindInterface
	CompletionItemKindModule
	CompletionItemKindProperty
	CompletionItemKindUnit
	CompletionItemKindValue
	CompletionItemKindEnum
	CompletionItemKindKeyword
	CompletionItemKindSnippet
	CompletionItemKindColor
	CompletionItemKindFile
	CompletionItemKindReference
	CompletionItemKindFolder
	CompletionItemKindEnumMember
	CompletionItemKindConstant
	CompletionItemKindStruct
	CompletionItemKindEvent
	CompletionItemKindOperator
	CompletionItemKindTypeParameter
)

// TextDocumentSyncKind defines how the host (editor) should sync document changes to the language server.
type TextDocumentSyncKind int

const (
	// TextDocumentSyncKindNone documents should not be synced at all.
	TextDocumentSyncKindNone TextDocumentSyncKind = iota

	// TextDocumentSyncKindFull documents are synced by always sending the full content of the document.
	TextDocumentSyncKindFull

	// TextDocumentSyncKindIncremental documents are synced by sending the full content on open.
	// After that only incremental updates to the document are send.
	TextDocumentSyncKindIncremental
)

// 有关折叠的相关类型
const (
	FoldingRangeKindComment = "comment" // Folding range for a comment
	FoldingRangeKindImports = "imports" // Folding range for a imports or includes
	FoldingRangeKindRegion  = "region"  // Folding range for a region (e.g. `#region`)
)
