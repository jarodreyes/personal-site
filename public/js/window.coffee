define [], () ->
    class WindowView extends Backbone.Marionette.Layout
        events: 
            'click' : 'toggleWindow'

        initialize: ->
            @render()

        toggleWindow: (event) ->
            (@$ '.window').toggleClass 'open'