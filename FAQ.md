# FAQ

## Terminal

### Why to use a relatively big font size?

- It's easier to read
- You can always zoom out anyways (<kbd>⌘</kbd> + <kbd>-</kbd>)

### Never remap these keys

<kbd>ctrl</kbd> + <kbd>h</kbd>

Used to delete back.

<kbd>ctrl</kbd> + <kbd>a</kbd>

Used to go to the beginning of the line.

## Neovim

### Useful commands

#### Open files in diff mode

```
nvim -d file1.txt file2.txt
```

#### Use a session file

Write:

`:mks`

Load:

```
nvim -S [Session.vim]
```

#### Use an alternate shada file

If you work on multiple projects and want different histories, registers, marks, and command histories for each, you can save and load a project-specific shada file.

Write:

`:wsha custom.shada`

Load:

```
nvim -i custom.shada
```
