# Disable device detection BEFORE interactive check to prevent DA query timeout
# set -g fish_features no-device-detection

if status is-interactive
    set -g fish_greeting
    # set -g fish_term24bit 1

    if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    end

    # Initialize tools
    starship init fish | source
    zoxide init fish | source
    direnv hook fish | source

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