# NeoVim config

## CodeDiff

- `:CodeDiff` / `<leader>cd`: Open CodeDiff (**c**ode **d**iff).
- `g?`: Toggle help.
- `Ctrl-w w`: Cycle between panes.
- `q`: Exit CodeDiff.

## Resolve merge conflicts

`<leader>` = **Space**.

- `<leader>ct`: Accept incoming changes (theirs).
- `<leader>co`: Accept current changes (ours).
- `<leader>cb`: Accept both.
- `]x` / `[x`: Next / previous conflict.
- `<leader>cT`: Accept incoming changes for the entire file.
- `<leader>cO`: Accept current changes for the entire file.
- `:w`: Save changes from the bottom result pane.

[Full configuration reference](https://github.com/esmuellert/codediff.nvim#configuration)
