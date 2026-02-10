(define %systemchoice "desktop") ; Available options: "desktop", "laptop", "minimal", "libre".

(add-to-load-path (dirname (current-filename)))

(load (string-append (dirname (current-filename)) "/systems/" %systemchoice ".scm"))
