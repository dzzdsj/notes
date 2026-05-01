
### neo-vim
https://github.com/neovim/neovim/releases/tag/v0.12.2

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
Then add this to your shell config (~/.bashrc, ~/.zshrc, …):

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

Neovim
├── LSP
│   ├── pyright
│   └── lua_ls
├── 补全
│   └── nvim-cmp
├── 语法树
│   └── treesitter
├── 模糊搜索
│   └── telescope
├── Git
│   └── gitsigns
└── 调试
    └── nvim-dap