if status is-interactive
    set -g fish_greeting
    eval (/opt/homebrew/bin/brew shellenv)

    # Initialize tools
    starship init fish | source
    zoxide init fish | source
    direnv hook fish | source

    # Theme
    fish_config theme choose "Catppuccin Mocha"

    # alias vim="nvim"
    # fish_vi_key_bindings
    
    # function sshz
    #     set host $argv[1]
    #     if test -z "$host"
    #         echo "Usage: sshz <host>"
    #         return 1
    #     end
    #     /usr/bin/ssh -t $host "zellij attach -c main || zellij -s main"
    # end
end

# fish_add_path $HOME/.local/bin
# fish_add_path $HOME/go/bin

# Render man page with bat
# set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"