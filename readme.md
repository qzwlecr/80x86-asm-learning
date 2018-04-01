# 80x86-asm-learn-notes

## Dosbox Configuration

- Find configuration file in `~/.dosbox/*.conf`.
- In section`[sdl]`, change `windowresolution` to suitable resolution and `output` to `opengl`.
- In section`[autoexec]`, write startup script.

For Example:
```
    mount C: /some_path/80x86-asm-learning/
    path %path%;C:\tools\bats;C:\tools\masm611;C:\tools\td;C:\tools\vim\;
    C:
```

## Environment Configuration

- Use masm and link to assemble and link
- Use nmake to make a list of files
- Use td to debug.
- Use vim to edit file

