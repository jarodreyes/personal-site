define ['reading-window', 'hacking-window', 'github-window', 'listening-window', 'voxy-window'], 
(ReadingWindow, HackingWindow, GithubWindow, ListeningWindow, VoxyWindow) ->
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
            'developer/': 'showDeveloper'

        initialize: ->
            @mainPage = new MainPage
            @reading = new ReadingWindow
            @hacking = new HackingWindow
            @git = new GithubWindow
            @listening = new ListeningWindow
            @voxy = new VoxyWindow

        showBio: ->
            @mainPage.scrollToBio()

        showHacker: ->
            @mainPage.scrollToHacker()

        showDeveloper: ->
            @mainPage.scrollToDeveloper()

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
            @hackerHeader = $ '.header-hacker'
            @developerHeader = $ '.header-developer'
            hackerTop = @hackerHeader.offset().top - (@headerH - HEADER_PADDING)
            developerTop = @developerHeader.offset().top - (@headerH + @hackerHeader.outerHeight())
            $(window).scroll (event) =>
                top = $(window).scrollTop()
                hackerMovement = $('.header-hacker').offset().top
                console.log top, developerTop

                if top >= hackerTop and top < developerTop
                    $('.header-offset').removeClass('absolute')
                    @afixHacker true
                    @afixBio false
                    
                if top >= developerTop
                    @afixDeveloper true

                if top < developerTop
                    @afixDeveloper false
                    
                if top < hackerTop
                    @afixHacker false
                    @afixBio true

        afixHacker: (afix= null) ->
            if afix
                @hackerHeader.addClass('fixed')
                Backbone.history.navigate 'hacker/'
                @toggleActive undefined, 'hacker'
            else
                @hackerHeader.removeClass('fixed')
                @afixBio true

        afixDeveloper: (afix= null) ->
            if afix
                @developerHeader.addClass('fixed')
                Backbone.history.navigate 'developer/'
                @toggleActive undefined, 'developer'
            else
                @developerHeader.removeClass('fixed')

        afixBio: (afix= null) ->
            if afix
                $('.header-offset').addClass('absolute')
                $('.logo-bg.main').show()
                $('.nav').removeClass('fixed orange')
                $('.logo').removeClass('fixed')
                Backbone.history.navigate '/'
                @toggleActive undefined, 'bio'
            else
                $('.nav').addClass('fixed orange')
                $('.logo').addClass('fixed')
                $('.logo-bg.main').hide()

        unfixHeaders: ->
            $('.header-offset').addClass('absolute')
            @hackerHeader.removeClass('fixed')
            @developerHeader.removeClass('fixed')
            $('.logo-bg.main').show()
            $('.nav').removeClass('fixed orange')
            $('.logo').removeClass('fixed')
            Backbone.history.navigate '/'
            @toggleActive undefined, 'bio'

        scrollToHacker: (event)->
            debugger
            $('html, body').animate
                scrollTop: $("#hacker").offset().top
            , 700

        scrollToDeveloper: (event)->
            $('html, body').animate
                scrollTop: $("#developer").offset().top
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


