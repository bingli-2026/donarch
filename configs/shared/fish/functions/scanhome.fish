function scanhome
    clamscan -r -i ~/Downloads ~/Documents
end

function scandownloads
    clamscan -r -i ~/Downloads
end

alias ll='ls -lah'
alias ports='sudo ss -tulpn'
alias audit='arch-audit'
