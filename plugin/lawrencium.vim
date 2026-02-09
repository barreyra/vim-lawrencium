" lawrencium.vim - A Mercurial wrapper
" Maintainer:   Ludovic Chabant <http://ludovic.chabant.com>
" Version:      0.4.0


" Globals {{{

if !exists('g:lawrencium_debug')
    let g:lawrencium_debug = 0
endif

if (exists('g:loaded_lawrencium') || &cp) && !g:lawrencium_debug
    finish
endif
if (exists('g:loaded_lawrencium') && g:lawrencium_debug)
    echom "Reloaded Lawrencium."
endif
let g:loaded_lawrencium = 1

if !exists('g:lawrencium_hg_executable')
    let g:lawrencium_hg_executable = 'hg'
endif

if !exists('g:lawrencium_auto_cd')
    let g:lawrencium_auto_cd = 1
endif

if !exists('g:lawrencium_trace')
    let g:lawrencium_trace = 0
endif

if !exists('g:lawrencium_define_mappings')
    let g:lawrencium_define_mappings = 1
endif

if !exists('g:lawrencium_auto_close_buffers')
    let g:lawrencium_auto_close_buffers = 1
endif

if !exists('g:lawrencium_annotate_width_offset')
    let g:lawrencium_annotate_width_offset = 0
endif

if !exists('g:lawrencium_status_win_split_above')
    let g:lawrencium_status_win_split_above = 0
endif

if !exists('g:lawrencium_status_win_split_even')
    let g:lawrencium_status_win_split_even = 0
endif

if !exists('g:lawrencium_status_win_maxheight')
    let g:lawrencium_status_win_maxheight = 50
endif

if !exists('g:lawrencium_record_start_in_working_buffer')
    let g:lawrencium_record_start_in_working_buffer = 0
endif

if !exists('g:lawrencium_status_show_log')
    let g:lawrencium_status_show_log = 0
endif

if !exists('g:lawrencium_status_log_revset')
    let g:lawrencium_status_log_revset = ''
endif

if !exists('g:lawrencium_extensions')
    let g:lawrencium_extensions = []
endif

" }}}

" Setup {{{

call lawrencium#init()

augroup lawrencium_detect
    autocmd!
    autocmd BufNewFile,BufReadPost *     call lawrencium#setup_buffer_commands()
    autocmd VimEnter               *     if expand('<amatch>')==''|call lawrencium#setup_buffer_commands()|endif
augroup end

augroup lawrencium_files
    autocmd!
    autocmd BufReadCmd  lawrencium://**//**//* exe lawrencium#read_lawrencium_file(expand('<amatch>'))
    autocmd BufWriteCmd lawrencium://**//**//* exe lawrencium#write_lawrencium_file(expand('<amatch>'))
augroup END

augroup lawrencium_auto_refresh
    autocmd!
    autocmd BufWritePost * call s:AutoRefreshStatus()
    autocmd ShellCmdPost * call s:AutoRefreshAll()
    autocmd User HgCmdPost call s:AutoRefreshStatus()
    autocmd FocusGained  * call s:AutoRefreshAll()
augroup end

function! s:AutoRefreshStatus()
    let l:repo_root = ''
    if exists('b:mercurial_dir') && b:mercurial_dir != ''
        let l:repo_root = b:mercurial_dir
    else
        try
            let l:repo = lawrencium#hg_repo()
            let l:repo_root = l:repo.root_dir
        catch
        endtry
    endif

    if l:repo_root != ''
        " Defer the refresh using a timer to ensure we are out of the immediate
        " autocmd context. This prevents issues like the status window going blank
        " when it is refreshed while another buffer is being written or processed.
        let l:deferred_root = l:repo_root
        call timer_start(0, {-> lawrencium#status#RefreshIfOpen(l:deferred_root)})
    endif
endfunction

function! s:AutoRefreshAll()
    " Refresh all open status windows across all tabs when a global event occurs.
    call timer_start(0, {-> lawrencium#status#RefreshAllOpen()})
endfunction

" }}}

