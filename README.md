# DoCSS is for building living styleguides

Wrap a block of `HAML` inside a `build_docss {}` block and it will output the corresponding `HAML` and `HTML` code needed to display that object.

Majorly just a WIP
__for now run `ruby play.rb` and it will build `test.html.haml`__

TODO:
 - Manage CSS better
  - Rails could use an engine, not sure about elsewhere
  - Should be configurable
 - Implement watcher to auto rebuild files
  - Guard would be my first thought
 - Deal with required wrapper tags better
 - Turn into a gem

### Example:

```haml
= build_docss do
  .taco
    This is where tacos go!
    %span
      This is a span about tacos
      %a{href: 'http://www.tacos.com'}
        This is a link about tacos!
    %span#nachos Nachos are cool too!
```

Would render:
![example image](example.png)
