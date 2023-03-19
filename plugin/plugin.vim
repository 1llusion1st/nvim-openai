" Оголошення команди
command! -nargs=1 QueryOPENAI :call QueryOPENAI(<q-args>)

" Визначення функції для виконання команди curl з аргументом та форматування результату в Markdown
function! QueryOPENAI(arg)
    " Виконання команди curl з переданим аргументом та отримання результату
    let curlCmd = "curl -X POST https://api.openai.com/v1/chat/completions 2>/dev/null" 
    let curlCmd .= " -H \"Content-Type: application/json\""
    let curlCmd .= " -H \"Authorization: Bearer " . $OPENAI_APIKEY . "\""
    let curlCmd .= " -d '{\"model\":\"gpt-3.5-turbo\",\"messages\":[{\"role\":\"assistant\",\"content\":\""
    let curlCmd .= a:arg
    let curlCmd .= "\"}]}' | tee /tmp/openai.lastresponse.json | jq -r '.choices[0].message.content' "
    " echo curlCmd

    let result = systemlist(curlCmd)
  
    " Створення нового вікна та відображення результату у ньому
    execute "vnew"
    set filetype=markdown

    " Форматування результату в Markdown
    for line in reverse(result)
        call append("line('$')", line)
    endfor

endfunction

