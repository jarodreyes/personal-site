define ['reading-window'], 
(ReadingWindow) ->
    READING_TEMPLATES = $ '.reading-templates'
    HEADER_PADDING = 45

    class MainRouter extends Backbone.Router
        routes:
            'bio/': 'showBio'
            'hacker/': 'showHacker'

        initialize: ->
            @mainPage = new MainPage
            @reading = new ReadingWindow
            console.log 'yay'

        showBio: ->
            $(window).scrollTop(20)

    class MainPage extends Backbone.Marionette.Layout
        el: 'body'

        regions:
            'tweets': '.tweets'
            

        initialize: ->
            debugger
            @getTweets = new Tweets
            @getTweets.fetch
                success: =>
                    console.log "fetched"
                    @twitterFeed = new TweetCollection
                        collection: @getTweets
                    @tweets.show @twitterFeed
                error: (msg) =>
                    console.log "error: "+msg

            _.bindAll @, 'detectScroll'
            @detectScroll()

        detectScroll: (event) ->
            @headerH = $('.header-main').outerHeight()
            $hackerHeader = $ '.header-hacker'
            hackerTop = $hackerHeader.offset().top - (@headerH - HEADER_PADDING)
            $(window).scroll (event) =>
                top = $(window).scrollTop()
                hackerMovement = $('.header-hacker').offset().top
                console.log(top, hackerTop, @headerH)
                if top >= hackerTop
                    $('.header-offset').removeClass('absolute')
                    $hackerHeader.addClass('fixed')
                    $('.nav').addClass('fixed orange')
                    $('.logo').addClass('fixed')
                else
                    $('.header-offset').addClass('absolute')
                    $hackerHeader.removeClass('fixed')
                    $('.nav').removeClass('fixed orange')
                    $('.logo').removeClass('fixed')

    class TweetView extends Backbone.Marionette.ItemView
        template: _.template $('#tweet-template').html()

    class TweetCollection extends Backbone.Marionette.CollectionView
        itemView: TweetView
        itemViewOptions:
            className: 'tweet block'

    class Tweets extends Backbone.Collection
        url: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=jreyesdesign&count=4"
    

    return new MainRouter


