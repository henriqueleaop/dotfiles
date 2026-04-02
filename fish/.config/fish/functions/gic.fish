function gic -d "Gera commit com IA para arquivos em stage"
    # 1. Pega apenas o que você já deu 'git add'
    set diff_content (git diff --cached)

    # Trava se não houver nada no stage
    if test -z "$diff_content"
        echo "Nenhum arquivo no stage. Use 'git add' primeiro."
        return 1
    end

    echo "Analisando alterações..."

    # 2. Envia para o Gemini exigindo zero enrolação
    set prompt "Escreva uma mensagem de commit no padrão Conventional Commits (em inglês) para o diff abaixo. Retorne APENAS a string da mensagem final. Sem aspas, sem formatação markdown, sem blocos de código e sem explicações. Diff: $diff_content"
    
    set commit_msg (aichat "$prompt")

    # 3. Mostra o resultado e pede a sua aprovação
    echo -e "\nMensagem Sugerida:\n"
    echo -e "\033[1;32m$commit_msg\033[0m\n"

    read -l -p "echo 'Aprovar e commitar? [s/N]: '" confirm

    if test "$confirm" = "s" -o "$confirm" = "S"
        git commit -m "$commit_msg"
        echo "Commit salvo com sucesso."
    else
        echo "Cancelado. O stage continua intacto."
    end
end
