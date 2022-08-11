function rust_cmd(str)
    cmd(':autocmd FileType rust ' .. str)
end

rust_cmd(':nnoremap <buffer> T :CargoRun<esc>')
rust_cmd(':nnoremap <buffer> B :CargoBuild<esc>')

rust_cmd(':inoremap <buffer> tes testtest')
