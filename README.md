# Tools I use and recommend

In the age of AI I've come to appreciate tools that solve a specific problem as best as they can and limit needless resource usage.

## Python
- [uv](https://docs.astral.sh/uv/): Once you go `uv`, you never go back
- [ruff](https://docs.astral.sh/ruff/): Honestly, anything Astral makes is a banger

## Terminal  
- [zoxide](https://zoxide.org/): `cd` wherever with just a few chars
- [starship](https://starship.rs/): showing the git branch you are on next to the dir name. so good.

## Neovim

I'm still not convinced it's the more productive way to work but I enjoy using it.
In the age of AI it brings back the sense of being in control and allows to eliminate needless resource wastage.

Config is still a work in progress.

### OS dependencies:
- C toolchain e.g. [gcc](https://gcc.gnu.org/)
- [rustup](https://rustup.rs/)
- [fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep/)

### CodeDiff

- `:CodeDiff` / `<leader>cd`: Open CodeDiff (**c**ode **d**iff).
- `g?`: Toggle help.
- `Ctrl-w w`: Cycle between panes.
- `q`: Exit CodeDiff.

#### Resolve merge conflicts

`<leader>` = **Space**.

- `<leader>ct`: Accept incoming changes (theirs).
- `<leader>co`: Accept current changes (ours).
- `<leader>cb`: Accept both.
- `]x` / `[x`: Next / previous conflict.
- `<leader>cT`: Accept incoming changes for the entire file.
- `<leader>cO`: Accept current changes for the entire file.
- `:w`: Save changes from the bottom result pane.

[Full configuration reference](https://github.com/esmuellert/codediff.nvim#configuration)
