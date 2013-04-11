define ['window', 'jquery.xml2json'], 
(WindowView, xml2json) ->
    class VoxyWindow extends WindowView
        className:'voxy-window'
        template: _.template $('#voxy-window-template').html()
        el: '.data'
        # secret: vJEOgLqaHHBf8J1lZxgHYwZ0TszZSJDNfQnULnKmLIQ
        
    return VoxyWindow