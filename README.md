# todo-vim

Yet another plain-text todo list plugin for (neo)vim.

## Installation

Use any package manager to install, for example, using Packer:

```
use 'huytd/todo-vim'
```

Then open any `*.todo` file to work.

## How to use

Syntax:

```
Title           # <title here>
Project name    ALLCAPS NAMES

Task statuses:

WIP             w <task description>
Todo            t <task description>
Blocked         b <task description>
Done            d <task description>
Moved           m <task description>
```

Shortcuts:

```
Insert today's date      /t
Insert a separator       ---
```

Example:

```
# Thursday, July 10th, 2025

PROJECT-A
d   Create a vim plugin for the todo app
m   Create a web app for it (someday)
w   I am working on this task
    A task can have a note under it as well.
    The note can be multiple lines, or whatever.

PROJECT-B
t   After that, I'll work on this
```
