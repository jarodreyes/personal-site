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
            @mainPage.setupHeight()

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

        setupHeight: ->
            @headerH = $('.header-main').outerHeight()
            @hackerHeader = $ '.header-hacker'
            @developerHeader = $ '.header-developer'
            @hackerDisplay = $ '.hacker-display'
            @developerDisplay = $ '.developer-display'
            @hackerTop = @hackerHeader.offset().top - (@headerH - HEADER_PADDING)
            @developerTop = @developerHeader.offset().top - (@headerH + @hackerHeader.outerHeight())

        detectScroll: (event) ->
            $(window).scroll (event) =>
                top = $(window).scrollTop()
                hackerMovement = $('.header-hacker').offset().top

                if top >= @hackerTop and top < @developerTop
                    @afixHacker true
                    @afixBio false
                    
                if top >= @developerTop
                    @afixDeveloper true

                if top < @developerTop
                    @afixDeveloper false
                    
                if top < @hackerTop
                    @afixHacker false
                    @afixBio true

        afixHacker: (afix= null) ->
            if afix
                $('#hacker > .header-offset').removeClass('absolute')
                @hackerDisplay.addClass 'show'
                @hackerHeader.addClass 'fixed' 
                Backbone.history.navigate 'hacker/'
                @toggleActive undefined, 'hacker'
            else
                @hackerDisplay.removeClass 'show'
                @hackerHeader.removeClass('fixed')
                @afixBio true

        afixDeveloper: (afix= null) ->
            if afix
                $('#developer > .header-offset').removeClass('absolute')
                @developerDisplay.addClass 'show'
                @developerHeader.addClass 'fixed'
                Backbone.history.navigate 'developer/'
                @toggleActive undefined, 'developer'
            else
                @developerDisplay.removeClass 'show'
                @developerHeader.removeClass 'fixed'

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
            @prepareScroll()
            _.defer =>
                $('html, body').animate
                    scrollTop: @hackerTop
                , 700

        scrollToDeveloper: (event)->
            @prepareScroll()
            _.defer =>
                $('html, body').animate
                    scrollTop: @developerTop
                , 700

        scrollToBio: (event)->
            @prepareScroll()
            _.defer =>
                $('html, body').animate
                    scrollTop: $("#bio").offset().top
                , 700

        prepareScroll: ->
            $('.window').removeClass 'open'

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

    class TweetView extends Backbone.Marionette.ItemView
        template: _.template $('#tweet-template').html()

    class TweetCollection extends Backbone.Marionette.CollectionView
        itemView: TweetView
        itemViewOptions:
            className: 'tweet block'

    class TweetManager extends Backbone.Marionette.Layout
        template: _.template $('#tweets-layout').html()
    

    app.start()


