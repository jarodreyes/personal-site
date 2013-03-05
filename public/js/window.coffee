define [], () ->
    class WindowView extends Backbone.Marionette.Layout
        originalEvents: 
            'click' : 'toggleWindow'
        pages: 5

        additionalEvents: {}

        events: ->
        	_.extend {}, @originalEvents, @additionalEvents

        initialize: ->
            @render()
            @leftScroll = 0

        setupSlider: ->
            @slideBox = (@$ '.inner-scroll')
            @windowWidth = (@$ '.card').outerWidth(true)
            @maxScroll = @windowWidth * @pages

        slideNext: (e) ->
            e.stopImmediatePropagation()
            @leftScroll += @windowWidth if @leftScroll < @maxScroll
            @slideBox.css('margin-left', -@leftScroll)
            return false

        slidePrev: (e) ->
            e.stopImmediatePropagation()
            @leftScroll -= @windowWidth if @leftScroll > 0
            @slideBox.css('margin-left', -@leftScroll)
            return false

        toggleWindow: (event) ->
            (@$ '.window').toggleClass 'open'
            if @scrollable
            	do @setupSlider