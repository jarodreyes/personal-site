define ['window', 'jquery.xml2json'], 
(WindowView, xml2json) ->
    class HackingWindow extends WindowView
        className:'hacking-window'
        template: _.template $('#hacking-template').html()
        el: '.hacking'
        # secret: vJEOgLqaHHBf8J1lZxgHYwZ0TszZSJDNfQnULnKmLIQ
        
    return HackingWindow