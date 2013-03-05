define ['reading-window', 'hacking-window', 'github-window', 'listening-window'], 
(ReadingWindow, HackingWindow, GithubWindow, ListeningWindow) ->
    HEADER_PADDING = 45

    class MainApp extends Backbone.Marionette.Application

    app = new MainApp

    app.addInitializer ->
        router = new MainRouter
        Backbone.history.start
            root: '/'
            pushState: true

    class MainRouter extends Backbone.Router
        routes:
            'bio/': 'showBio'
            'hacker/': 'showHacker'

        initialize: ->
            @mainPage = new MainPage
            @reading = new ReadingWindow
            @hacking = new HackingWindow
            @git = new GithubWindow
            @listening = new ListeningWindow

        showBio: ->
            @mainPage.scrollToBio()

        showHacker: ->
            @mainPage.scrollToHacker()
            console.log 'yay'

    class MainPage extends Backbone.Marionette.Layout
        el: 'body'

        events:
            'click .nav-link': 'navigateTo'

        regions:
            'tweets': '.tweets'
            

        initialize: ->
            _.bindAll @, 'detectScroll'
            @detectScroll()

        detectScroll: (event) ->
            @headerH = $('.header-main').outerHeight()
            $hackerHeader = $ '.header-hacker'
            hackerTop = $hackerHeader.offset().top - (@headerH - HEADER_PADDING)
            $(window).scroll (event) =>
                top = $(window).scrollTop()
                hackerMovement = $('.header-hacker').offset().top
                if top >= hackerTop
                    $('.header-offset').removeClass('absolute')
                    $hackerHeader.addClass('fixed')
                    $('.nav').addClass('fixed orange')
                    $('.logo').addClass('fixed')
                    Backbone.history.navigate 'hacker/'
                    @toggleActive undefined, 'hacker'
                else
                    $('.header-offset').addClass('absolute')
                    $hackerHeader.removeClass('fixed')
                    $('.nav').removeClass('fixed orange')
                    $('.logo').removeClass('fixed')
                    Backbone.history.navigate '/'
                    @toggleActive undefined, 'bio'

        scrollToHacker: (event)->
            $('html, body').animate
                scrollTop: $("#hacker").offset().top
            , 700

        scrollToBio: (event)->
            $('html, body').animate
                scrollTop: $("#bio").offset().top
            , 700

        navigateTo: (event) ->
            data = $(event.currentTarget).data()
            event.preventDefault()
            route = data.route
            Backbone.history.navigate route, trigger:true
            @toggleActive event, undefined

        toggleActive: (event, element) ->
            $('.nav-link').removeClass 'active'
            # Need place holder for expanded state of link
            if event
                $(event.target).addClass 'active'
            if element
                $(".nav-link[data-route*=#{element}]").addClass 'active'
                console.log "#{element}"

    class TweetView extends Backbone.Marionette.ItemView
        template: _.template $('#tweet-template').html()

    class TweetCollection extends Backbone.Marionette.CollectionView
        itemView: TweetView
        itemViewOptions:
            className: 'tweet block'

    class TweetManager extends Backbone.Marionette.Layout
        template: _.template $('#tweets-layout').html()
    

    app.start()


