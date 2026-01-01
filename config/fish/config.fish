if status is-interactive
    starship init fish | source
    zoxide init fish | source
    set -U fish_greeting
end
