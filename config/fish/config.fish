if status is-interactive
    starship init fish | source
    zoxide init fish | source

    # Yazi init
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file="$tmp"
        if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    set -gx fish_greeting
    set -gx EDITOR hx

end
