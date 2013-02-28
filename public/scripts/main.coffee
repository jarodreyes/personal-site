define ['jquery.xml2json'], 
(xml) ->
    READING_TEMPLATES = $ '.reading-templates'

    class MainRouter extends Backbone.Router
        routes:
            'bio/': 'showBio'

        initialize: ->
            @layout = new ReadingWindow
            console.log 'yay'

        showBio: ->
            $(window).scrollTop(20)

    class ReadingWindow extends Backbone.Marionette.Layout
        className:'reading-window'
        template: _.template $('#reading-template').html()
        el: '.reading'
        url: 'http://www.goodreads.com/user/show/5406984.xml?key=Nkya34MwrAyEZ7cnbMzqA'
        # secret: vJEOgLqaHHBf8J1lZxgHYwZ0TszZSJDNfQnULnKmLIQ

        events: 
            'click' : 'openWindow'

        regions:
            books: '.book-list'

        initialize: ->
            @expanded = false
            @getReadingData()
            @render()

        openWindow: (event) ->
            (@$ 'window').addClass 'opened'
            @books.show @booksCollectionView

        getReadingData: () ->
            $.get @url, (xml) =>
                data = $.xml2json(xml)
                @model = new Backbone.Model data.user
                @prepareData()

        prepareData: () ->
            link = @model.get 'link'
            updates = (@model.get 'updates').update
            @bookList = new Backbone.Collection updates
            console.log @bookList
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


