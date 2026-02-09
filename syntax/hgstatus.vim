" Vim syntax file
" Language:     hg status output
" Maintainer:   Ludovic Chabant <ludovic@chabant.com>
" Filenames:    ^hg-status-*.txt

if exists("b:current_syntax")
    finish
endif

syn case match

syn match hgstatusModified      "^M"
syn match hgstatusAdded         "^A"
syn match hgstatusRemoved       "^R"
syn match hgstatusClean         "^C"
syn match hgstatusMissing       "^?"
syn match hgstatusNotTracked    "^!"
syn match hgstatusIgnored       "^I"

syn include @diffSyntax syntax/diff.vim
syn region hgstatusInlineDiff start="^\(diff \|@@ \)" end="^\ze\([MARC\!\?I ]\s\|[A-Za-z].*:\|$\)" contains=@diffSyntax

syn match hgstatusSectionHeader "^[A-Za-z].*:$"
syn match hgstatusSectionDivider "^-\{3,\}$"

syn match hglogRev              '\v^[0-9]+'
syn match hglogNode             '\v:[a-f0-9]{6,} 'hs=s+1,me=e-1
syn match hglogBookmark         '\v \+[^ ]+ 'ms=s+1,me=e-1 contains=hglogBookmarkPlus
syn match hglogTag              '\v #[^ ]+ 'ms=s+1,me=e-1 contains=hglogTagSharp
syn match hglogAuthorAndAge     '\v\(by .+, .+\)$'

syn match hglogBookmarkPlus     '\v\+' contained
syn match hglogTagSharp         '\v#'  contained

hi def link hgstatusModified    PreProc
hi def link hgstatusAdded       Statement
hi def link hgstatusRemoved     PreProc
hi def link hgstatusClean       Constant
hi def link hgstatusMissing     Error
hi def link hgstatusNotTracked  Todo
hi def link hgstatusIgnored     Ignore
hi def link hgstatusFileName    Constant

hi def link hgstatusSectionHeader Title
hi def link hgstatusSectionDivider Comment

hi def link hglogRev            Identifier
hi def link hglogNode           PreProc
hi def link hglogBookmark       Statement
hi def link hglogTag            Constant
hi def link hglogAuthorAndAge   Comment

