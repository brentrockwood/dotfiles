" my filetypes 
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  " add more filetypes here
  au! BufRead,BufNewFile *.zsh-theme   setfiletype sh
augroup END
