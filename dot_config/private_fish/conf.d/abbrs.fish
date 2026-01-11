# -----------------------------
# 1. Common Tools
# -----------------------------
# cd -> zoxide
abbr -a cd z

# ls -> eza
abbr -a l 'eza --icons'
abbr -a ls 'eza --icons'
abbr -a ll 'eza -l --icons --git'
abbr -a la 'eza -la --icons --git'
abbr -a tree 'eza --tree --icons'

# cat -> bat
abbr -a cat 'bat'

# grep -> Ripgrep
abbr -a grep rg

# -----------------------------
# 2. Git 
# -----------------------------
abbr -a g 'git'
abbr -a ga 'git add'
abbr -a gc 'git commit -m'
abbr -a gco 'git checkout'
abbr -a gp 'git push'
abbr -a gl 'git pull'
abbr -a gst 'git status'
abbr -a gd 'git diff'
abbr -a glg 'git log --oneline --graph --decorate'

# -----------------------------
# 3. Chezmoi
# -----------------------------
abbr -a cm 'chezmoi'
abbr -a cmcd 'chezmoi cd'
abbr -a cma 'chezmoi apply'
abbr -a cme 'chezmoi edit'
abbr -a cmu 'chezmoi update'
abbr -a cmg 'chezmoi git'

# -----------------------------
# 4. Zellij
# -----------------------------
abbr -a zj 'zellij'
abbr -a zja 'zellij attach -c main'
abbr -a zjdev 'zellij --layout dev'