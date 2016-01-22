# DoCSS is for building living styleguides

Wrap a block of `HAML` inside a `build_docss {}` block and it will output the corresponding `HAML` and `HTML` code needed to display that object.

Majorly just a WIP!

~~*If you want to play around, for now run* `ruby play.rb` **and it will build** `test.html.haml`~~

## **NOW WITH RACK!**

1. Clone the app:  `git clone https://github.com/kormie/DoCSS`
2. Bundle install: `bundle`
3. Run Rack:       `bundle exec rackup`
4. View test page: `localhost:9292/test`
5. View README:    `localhost:9292/` *(works sometimes)*

TODO:

* ~~Manage CSS better~~

CSS now managed via Rack middleware

* ~~Implement watcher to auto rebuild files~~

Haml files compiled per request. All other files handled via `Rack::Reloader`

* Deal with required wrapper tags better
* Turn into a gem
* Fix `DoCSS::Indexer` middleware

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
![example image](/images/example.png)
