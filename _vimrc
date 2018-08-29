" =============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================
 
" -----------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
" -----------------------------------------------------------------------------
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif
 
" -----------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
 
 
" =============================================================================
"                          << 以下为软件默认配置 >>
" =============================================================================
 
" -----------------------------------------------------------------------------
"  < Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set diffexpr=MyDiff()
 
    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif
 
" -----------------------------------------------------------------------------
"  < Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if g:islinux
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配
 
    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif
 
    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim
 
        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif
 
        set mouse=a                    " 在任何模式下启用鼠标
        set t_Co=256                   " 在终端启用256色
        set backspace=2                " 设置退格键可用
 
        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif
 
 
" =============================================================================
"                          << 以下为用户自定义配置 >>
" =============================================================================
 
" -----------------------------------------------------------------------------
"  < Vundle 插件管理工具配置 >
" -----------------------------------------------------------------------------
" 用于更方便的管理vim插件，具体用法参考 :h vundle 帮助
" Vundle工具安装方法为在终端输入如下命令
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" 如果想在 windows 安装就必需先安装 "git for window"，可查阅网上资料
 
set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测
 
if g:islinux
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
else
	" set the runtime path to include Vundle and initialize
    set rtp+=$VIM/vimfiles/bundle/vundle/		  
	" pass a path where Vundle should install plugins
    call vundle#rc('$VIM/vimfiles/bundle/')
endif
 
" 使用Vundle来管理插件，这个必须要有。
Bundle 'gmarik/vundle'
 
" 以下为要安装或更新的插件，不同仓库都有（具体书写规范请参考帮助）

" 文件系统插件
Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'

" 检索插件
" Bundle 'ctrlpvim/ctrlp.vim'
" Bundle 'wesleyche/SrcExpl'

" 对齐插件
Bundle 'Yggdroot/indentLine'

" 注释插件
Bundle 'scrooloose/nerdcommenter'

" 高亮插件
Bundle 'Mark--Karkat'

" 自动补全插件
Bundle 'jiangmiao/auto-pairs'
Bundle 'ervandew/supertab'
Bundle 'davidhalter/jedi-vim'
" Bundle 'vim-scripts/Pydiction'

" 语法检查插件
Bundle 'nvie/vim-flake8'
Bundle 'vim-scripts/indentpython.vim'

" 状态条插件
Bundle 'Lokaltog/vim-powerline'


" 颜色插件
Bundle 'altercation/vim-colors-solarized'
Bundle 'jnurmine/Zenburn'


 
" -----------------------------------------------------------------------------
"  < 编码配置 >
" -----------------------------------------------------------------------------
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                                    "设置gvim内部编码，默认不更改
set fileencoding=utf-8                                "设置当前文件编码，可以更改，如：gbk（同cp936）
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码
 
" 文件格式，默认 ffs=dos,unix
set fileformat=unix                                   "设置新（当前）文件的<EOL>格式，可以更改，如：dos（windows系统常用）
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型
 
if (g:iswindows && g:isGUI)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
 
    "解决consle输出乱码
    language messages zh_CN.utf-8
endif
 
" -----------------------------------------------------------------------------
"  < 编写文件时的配置 >
" -----------------------------------------------------------------------------
filetype on                                           "启用文件类型侦测
filetype plugin on                                    "针对不同的文件类型加载对应的插件
filetype plugin indent on                             "启用缩进
set smartindent                                       "启用智能对齐方式
set expandtab                                         "将Tab键转换为空格
set tabstop=4                                         "设置Tab键的宽度，可以更改，如：宽度为2
set shiftwidth=4                                      "换行时自动缩进宽度，可更改（宽度同tabstop）
set smarttab                                          "指定按一次backspace就删除shiftwidth宽度
set foldenable                                        "启用折叠
"set foldmethod=indent                                 "indent 折叠方式
" set foldmethod=marker                                "marker 折叠方式
set clipboard=unnamed								  "使用系统粘贴板
 
" 常规模式下用空格键来开关光标行所在折叠（注：zR 展开所有折叠，zM 关闭所有折叠）
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
 
" 当文件在外部被修改，自动更新该文件
set autoread
 
" 常规模式下输入 cS 清除行尾空格
nmap cS :%s/\s\+$//g<CR>:noh<CR>
 
" 常规模式下输入 cM 清除行尾 ^M 符号
nmap cM :%s/\r$//g<CR>:noh<CR>
 
set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
" set noincsearch                                       "在输入要搜索的文字时，取消实时匹配
 
" Ctrl + K 插入模式下光标向上移动
imap <c-k> <Up> 
" Ctrl + J 插入模式下光标向下移动
imap <c-j> <Down>
" Ctrl + H 插入模式下光标向左移动
imap <c-h> <Left>
" Ctrl + L 插入模式下光标向右移动
imap <c-l> <Right>
 
" 启用每行超过80列的字符提示（字体变蓝并加下划线），不启用就注释掉
au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

" 用<C-k,j,h,l>切换到上下左右的窗口中去
noremap <c-k> <c-w>k
noremap <c-j> <c-w>j
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" 打开文件时光标自动到上次退出该文件时的光标所在位置
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal`\"" | endif


" -----------------------------------------------------------------------------
"  < 界面配置 >
" -----------------------------------------------------------------------------
set number                                            "显示行号
set laststatus=2                                      "启用状态栏信息
set cmdheight=2                                       "设置命令行的高度为2
set cursorline                                        "突出显示当前行
set guifont=Lucida_Console:h12 		                  "设置字体:字号（字体名称空格用下划线代替）
set nowrap                                            "设置不自动换行
set shortmess=atI                                     "去掉欢迎界面
 
" 设置 gVim 窗口初始位置及大小
if g:isGUI
    au GUIEnter * simalt ~x                           "窗口启动时自动最大化
"    winpos 100 10                                     "指定窗口出现的位置，坐标原点在屏幕左上角
"    set lines=38 columns=120                          "指定窗口大小，lines为高度，columns为宽度
endif
 
" 设置代码配色方案
if g:isGUI
	set background=dark
	colorscheme solarized              			 	  "Gvim配色方案
else
    colorscheme Zenburn				               	  "终端配色方案
endif
 
" 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
if g:isGUI
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    nmap <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
        \set guioptions-=m <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=r <Bar>
        \set guioptions-=L <Bar>
    \else <Bar>
        \set guioptions+=m <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=r <Bar>
        \set guioptions+=L <Bar>
    \endif<CR>
endif
 

" -----------------------------------------------------------------------------
"  < python 配置 >
" -----------------------------------------------------------------------------
" 断点快捷键
inoremap  <F10> import pdb;pdb.set_trace()<CR>
nnoremap  <F10> iimport pdb;pdb.set_trace()<ESC>
if (g:iswindows)
	" windows 下调试快捷键
	inoremap <F11> <ESC>:w<CR>:!start python -m pdb % <CR>
	nnoremap <F11> :w<CR>:!start python -m pdb % <CR>
	" windows 下运行快捷键
	" inoremap <F12> <ESC>:w<CR>:!start python % <CR>
	" nnoremap <F12> :w<CR>:!start python % <CR>	
endif

" 新建窗口运行 但不能边运行边显示，注释掉
if (0)
nnoremap <silent> <F12> :call SaveAndExecutePython()<CR>
vnoremap <silent> <F12> :<C-u>call SaveAndExecutePython()<CR>
function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    " setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')
	execute 'res 10' 
	
    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction
endif


"------------Start Python PEP 8 stuff----------------
" Number of spaces that a pre-existing tab is equal to.
au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=4

"spaces for indents
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
au BufRead,BufNewFile *.py set softtabstop=4

" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Wrap text after a certain number of characters
au BufRead,BufNewFile *.py,*.pyw, set textwidth=100

" Use UNIX (\n) line endings.
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

" Set the default file encoding to UTF-8:
set encoding=utf-8

" For full syntax highlighting:
let python_highlight_all=1
syntax on

" Keep indentation level from previous line:
autocmd FileType python set autoindent

" make backspaces more powerfull
set backspace=indent,eol,start


"Folding based on indentation:
" autocmd FileType python set foldmethod=indent
"use space to open folds
nnoremap <space> za 
"----------Stop python PEP 8 stuff--------------
 
 
 
" -----------------------------------------------------------------------------
"  < 其它配置 >
" -----------------------------------------------------------------------------
set writebackup                             "保存文件前建立备份，保存成功后删除该备份
set nobackup                                "设置无备份文件
set noswapfile                              "设置无临时文件
" set vb t_vb=                                "关闭提示音
 
 
" =============================================================================
"                          << 以下为常用插件配置 >>
" =============================================================================



" -----------------------------------------------------------------------------
"  < nerdtree 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/scrooloose/nerdtree
" 说明：目录树结构的文件浏览插件
" 常用快捷键：
"	o	打开关闭文件或者目录
"	t	在标签页中打开
"	T	在后台标签页中打开
"	gt	切换到后一个tab
"	gT	切换到前一个tab
"	i	水平分割创建文件的窗口，创建的是buffer
"	gi	水平分割创建文件的窗口，但是光标仍然留在NERDTree
"	s	垂直分割创建文件的窗口，创建的是buffer
"	gs	垂直分割创建文件的窗口，但是光标仍然留在NERDTree
"	r	递归刷新选中目录
"	!	执行此文件
"	p	到上层目录
"	K	到第一个节点
"	J	到最后一个节点
"	u	打开上层目录
"	m	显示文件系统菜单（添加、删除、移动操作）
"	q	关闭
" 常规模式下输入 F1 调用插件
nmap <F1> :silent NERDTreeToggle<CR> 
" 窗口位置
let g:NERDTreeWinPos='left'
" NerdTree 窗口大小
let NERDTreeWinSize=20
" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1
" 忽略一下文件的显示
let NERDTreeIgnore=['\.pyc','\~$','\.swp']
" 切换 tab 快捷键
" nnoremap <leader>l gt
" nnoremap <leader>h gT
nnoremap <leader>t : tabe<CR>


" -----------------------------------------------------------------------------
"  < ctrlp.vim 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/ctrlpvim/ctrlp.vim
" 说明：ctrlp提供了一种直观和快速的机制装载文件，从文件系统，从打开的缓冲区以及最近使用过的文件里
" Bug:error detected while processing function ctrlp (和powerline冲突)




" -----------------------------------------------------------------------------
"  < SrcExpl 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/wesleyche/SrcExpl
" 说明：实现自动显示跳转函数及变量定义功能，需要Ctag
nmap <F3> :SrcExplToggle<CR>                "打开/闭浏览窗口



" -----------------------------------------------------------------------------
"  < indentLine 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/Yggdroot/indentLine
" 说明：显示对齐线
if g:isGUI		" 设置Gvim的对齐线样式
    let g:indentLine_char = "┊"
    let g:indentLine_first_char = "┊"
endif 
" 设置终端对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
let g:indentLine_color_term = 239
" 设置 GUI 对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
let g:indentLine_color_gui = '#A4E57E'



" -----------------------------------------------------------------------------
"  < nerdcommenter 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/scrooloose/nerdcommenter
" 说明：快速注释/解开注释
" 常用快捷键：
"	<leader>cc			加注释
"	<leader>cu			解开注释
"	<leader>c<space>	加上/解开注释, 智能判断
"	<leader>cy			先复制, 再注解(p可以进行黏贴)
let NERDSpaceDelims = 1 " 在左注释符之后，右注释符之前留有空格



" -----------------------------------------------------------------------------
"  < Mark--Karkat 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/vim-scripts/Mark--Karkat
" 说明：高亮不同的单词，表明不同的变量时很有用
" 常用快捷键：
"	<Leader>m	高亮光标单词
"	<Leader>r	通过正则表达式高亮单词



" -----------------------------------------------------------------------------
"  < auto-pairs 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/jiangmiao/auto-pairs
" 说明：实现括号与引号自动补全，不过会与函数原型提示插件echofunc冲突

 

" -----------------------------------------------------------------------------
"  < supertab 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/ervandew/supertab
" 说明：使Tab快捷键具有上下文提示功能
let g:SuperTabDefaultCompletionType="context"



" -----------------------------------------------------------------------------
"  < jedi-vim 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/davidhalter/jedi-vim
" 说明：python自动补全，需要pip install jedi
" 常用快捷键：
"	<C-Space>	自动补全插件
"	<leader>d	跳转到定义处
"	<leader>n	显示所有使用当前光标对应命名的地方
"	K			显示文档


 
" -----------------------------------------------------------------------------
"  < pydiction 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/rkulla/pydiction
" 说明：tab键自动补全complete-dict中关键字，只能补全 complete-dict 中已有的关键字，而且与supertab矛盾，不建议使用
" let g:pydiction_location = 'C:/Soft/Dev/Vim/vimfiles/bundle/Pydiction/complete-dict'
" let g:pydiction_menu_height = 20



" -----------------------------------------------------------------------------
"  < vim-flake8 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/nvie/vim-flake8
" 说明：python的语法检查（Flake8 is a wrapper around PyFlakes, PEP8 and Ned's MacCabe script），需要pip install flake8
autocmd FileType python map <buffer> <F3> :call Flake8()<CR>



" -----------------------------------------------------------------------------
"  < indentpython.vim 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/vim-scripts/indentpython.vim
" 说明：使python的缩进符合 PEP 8


 
" -----------------------------------------------------------------------------
"  < powerline 插件配置 >
" -----------------------------------------------------------------------------
" 项目地址：https://github.com/powerline/powerline
" 说明：状态栏插件


 
" =============================================================================
"                          << 以下为常用工具配置 >>
" =============================================================================

 
" -----------------------------------------------------------------------------
"  < ctags 工具配置 >
" -----------------------------------------------------------------------------
" 对浏览代码非常的方便,可以在函数,变量之间跳转等
set tags=./tags;                            "向上级目录递归查找tags文件（好像只有在Windows下才有用）
set tags+=$VIM/python.ctags					"设置python tag位置

 

" -----------------------------------------------------------------------------
"  < TagList 插件配置 >
" -----------------------------------------------------------------------------
" 高效地浏览源码, 其功能就像vc中的workpace
" 那里面列出了当前文件中的所有宏,全局变量, 函数名等
 
" 常规模式下输入 F2 调用插件，如果有打开 Tagbar 窗口则先将其关闭
nmap <F2> :Tlist<CR>
 
let Tlist_Show_One_File=1                   "只显示当前文件的tags
" let Tlist_Enable_Fold_Column=0              "使taglist插件不显示左边的折叠行
let Tlist_Exit_OnlyWindow=1                 "如果Taglist窗口是最后一个窗口则退出Vim
let Tlist_File_Fold_Auto_Close=1            "自动折叠
let Tlist_WinWidth=30                       "设置窗口宽度
let Tlist_Use_Right_Window=1                "在右侧窗口中显示


 
" =============================================================================
"                          << 以下为常用自动命令配置 >>
" =============================================================================
 
" 自动切换目录为当前编辑文件所在目录
au BufRead,BufNewFile,BufEnter * cd %:p:h
 
" =============================================================================
"                     << windows 下解决 Quickfix 乱码问题 >>
" =============================================================================
" windows 默认编码为 cp936，而 Gvim(Vim) 内部编码为 utf-8，所以常常输出为乱码
" 以下代码可以将编码为 cp936 的输出信息转换为 utf-8 编码，以解决输出乱码问题
" 但好像只对输出信息全部为中文才有满意的效果，如果输出信息是中英混合的，那可能
" 不成功，会造成其中一种语言乱码，输出信息全部为英文的好像不会乱码
" 如果输出信息为乱码的可以试一下下面的代码，如果不行就还是给它注释掉
 
if g:iswindows
    function QfMakeConv()
        let qflist = getqflist()
        for i in qflist
           let i.text = iconv(i.text, "cp936", "utf-8")
        endfor
        call setqflist(qflist)
     endfunction
     au QuickfixCmdPost make call QfMakeConv()
endif
 
" =============================================================================
"                          << 其它 >>
" =============================================================================
" 注：上面配置中的"<Leader>"在本软件中设置为"\"键（引号里的反斜杠），如<Leader>t
" 指在常规模式下按"\"键加"t"键，这里不是同时按，而是先按"\"键后按"t"键，间隔在一
" 秒内，而<Leader>cs是先按"\"键再按"c"又再按"s"键；如要修改"<leader>"键，可以把
" 下面的设置取消注释，并修改双引号中的键为你想要的，如修改为逗号键。
 
let mapleader = ","
set timeout timeoutlen=1500



" ===== Windows-specific settins =====

cd C:/Data/Study/Program/Python