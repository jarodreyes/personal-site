define ['jquery.xml2json'], 
(xml) ->
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
                    

    class WindowView extends Backbone.Marionette.Layout
        events: 
            'click' : 'toggleWindow'

        initialize: ->
            @render()

        toggleWindow: (event) ->
            (@$ '.window').toggleClass 'open'


    class ReadingWindow extends WindowView
        className:'reading-window'
        template: _.template $('#reading-template').html()
        el: '.reading'
        url: 'http://www.goodreads.com/review/list/5406984.xml?key=Nkya34MwrAyEZ7cnbMzqA&v=2&shelf=read'
        # secret: vJEOgLqaHHBf8J1lZxgHYwZ0TszZSJDNfQnULnKmLIQ

        regions:
            books: '.book-list'

        initialize: ->
            @getReadingData()
            super

        toggleWindow: (event) ->
            @books.show @booksCollectionView
            (@$ 'small').toggleClass 'invisible'
            super

        getReadingData: () ->
            $.get @url, (xml) =>
                data = $.xml2json(xml)
                @model = new Backbone.Model data.reviews
                @prepareData()

        prepareData: () ->
            reviews = @model.get 'review'
            for review in reviews
                image = review.book.image_url
                image = image.replace /m\/(?=\d)/g, 'l/'
                review.book.image_url = image
            @bookList = new Backbone.Collection reviews
            @renderBooks()

        renderBooks: ->
            @booksCollectionView = new BooksCollectionView
                collection: @bookList

    class BookView extends Backbone.Marionette.ItemView
        template: _.template $('#books-template').html()

    class BooksCollectionView extends Backbone.Marionette.CollectionView
        itemView: BookView

    class GoodReadsData extends Backbone.Model
        url: 'http://www.goodreads.com/user/show/5406984.xml?key=Nkya34MwrAyEZ7cnbMzqA'

        fetch: (data) ->
            results = $.xml2json(data.results)
            return results

    return new MainRouter


